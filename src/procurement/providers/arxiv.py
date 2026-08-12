"""arXiv Atom discovery adapter."""

from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass
from datetime import date
from typing import Any
from urllib.parse import quote, urlsplit

from defusedxml import ElementTree

from procurement.errors import IdentifierError, ProviderPayloadError, ProviderRecordNotFoundError
from procurement.http import HttpClient, RequestPolicy
from procurement.identifiers import normalize_doi, split_arxiv_id
from procurement.models import RetrievedMetadata, SearchPage, SearchRequest, SourceReference, WorkRecord
from procurement.models import ArtifactReference
from procurement.payloads import (
    ArtifactAcquisitionRequest,
    ArtifactPlan,
    PlannedArtifact,
    RetrievalCandidate,
)
from procurement.providers.base import (
    Capability,
    ProviderCategory,
    ProviderDefinition,
    ProviderRole,
    retrieved_metadata,
)
from procurement.settings import ArtifactLimitSettings, ProviderHttpSettings, RuntimeSecrets
from procurement.identifiers import artifact_slug

_ATOM = "http://www.w3.org/2005/Atom"
_ARXIV = "http://arxiv.org/schemas/atom"
_OPEN_SEARCH = "http://a9.com/-/spec/opensearch/1.1/"
_NS = {"atom": _ATOM, "arxiv": _ARXIV, "os": _OPEN_SEARCH}


@dataclass(frozen=True, slots=True)
class ArxivFeed:
    """Parsed arXiv feed page and counters."""

    total: int | None
    start: int
    items_per_page: int | None
    works: tuple[WorkRecord, ...]


def build_search_query(request: SearchRequest) -> str:
    """Build an arXiv search_query expression from common search fields."""

    parts: list[str] = []
    if request.query:
        parts.append(f"({request.query})")
    if request.categories:
        parts.append("(" + " OR ".join(f"cat:{category}" for category in request.categories) + ")")
    if request.date_from or request.date_to:
        lower = request.date_from or date(1991, 7, 1)
        upper = request.date_to or date.today()
        parts.append(f"submittedDate:[{lower:%Y%m%d}0000 TO {upper:%Y%m%d}2359]")
    if not parts:
        raise ValueError("an arXiv search requires a query, categories, or a date bound")
    return " AND ".join(parts)


class ArxivProvider:
    """arXiv query API mapped onto procurement records."""

    descriptor = ProviderDefinition(
        name="arxiv",
        category=ProviderCategory.REPOSITORY,
        capabilities=frozenset(
            {
                Capability.SEARCH,
                Capability.GET_WORK,
                Capability.METADATA,
                Capability.PLAN_ARTIFACT,
            }
        ),
        roles=frozenset(
            {
                ProviderRole.ARTIFACT_ORIGIN,
                ProviderRole.ARTIFACT_ACCESS,
                ProviderRole.METADATA_AUTHORITY,
            }
        ),
        search_constraints=frozenset({"categories", "date_from", "date_to", "sort"}),
    )
    name = descriptor.name
    search_constraints = descriptor.search_constraints

    def __init__(
        self,
        http: HttpClient,
        settings: ProviderHttpSettings,
        secrets: RuntimeSecrets = RuntimeSecrets(),
        artifact_limits: ArtifactLimitSettings = ArtifactLimitSettings(),
    ) -> None:
        self._http = http
        self._url = settings.base_url
        self._headers = {"User-Agent": secrets.user_agent("codex-scientiae-arxiv/0.1")}
        self._policy = RequestPolicy(
            min_interval_seconds=settings.min_interval_seconds,
            timeout_seconds=settings.timeout_seconds,
            max_attempts=settings.max_attempts,
        )
        self._artifact_base_url = (settings.artifact_base_url or "https://arxiv.org").rstrip("/")
        self._secondary_artifact_base_url = (
            settings.secondary_artifact_base_url or "https://export.arxiv.org"
        ).rstrip("/")
        self._artifact_limits = artifact_limits

    async def _query(self, params: Mapping[str, Any]) -> str:
        return await self._http.get_text(
            self._url,
            params=params,
            headers=self._headers,
            rate_key=self.name,
            policy=self._policy,
        )

    @classmethod
    def parse_feed(cls, xml: str) -> ArxivFeed:
        try:
            root = ElementTree.fromstring(xml)
        except Exception as exc:
            raise ProviderPayloadError(f"arXiv returned invalid Atom XML: {exc}") from exc

        def counter(name: str) -> int | None:
            value = root.findtext(f"os:{name}", namespaces=_NS)
            try:
                return int(value) if value is not None else None
            except ValueError:
                return None

        works: list[WorkRecord] = []
        for entry in root.findall("atom:entry", _NS):
            raw_url = (entry.findtext("atom:id", default="", namespaces=_NS) or "").strip()
            raw_id = raw_url.rsplit("/abs/", 1)[-1]
            try:
                identifier = split_arxiv_id(raw_id)
            except IdentifierError:
                continue

            title = " ".join((entry.findtext("atom:title", default="", namespaces=_NS) or "").split()) or None
            abstract = " ".join((entry.findtext("atom:summary", default="", namespaces=_NS) or "").split()) or None
            authors = [
                " ".join((node.text or "").split())
                for node in entry.findall("atom:author/atom:name", _NS)
                if node.text
            ]
            primary_node = entry.find("arxiv:primary_category", _NS)
            primary = primary_node.get("term") if primary_node is not None else None
            categories: list[str] = [primary] if primary else []
            for node in entry.findall("atom:category", _NS):
                category = node.get("term")
                if category and category not in categories:
                    categories.append(category)

            pdf_url: str | None = None
            for link in entry.findall("atom:link", _NS):
                if link.get("title") == "pdf":
                    pdf_url = link.get("href")
                    break
            pdf_url = pdf_url or f"https://arxiv.org/pdf/{identifier.versioned}"
            abs_url = f"https://arxiv.org/abs/{identifier.versioned}"
            published = entry.findtext("atom:published", namespaces=_NS) or None
            updated = entry.findtext("atom:updated", namespaces=_NS) or None
            doi = normalize_doi(entry.findtext("arxiv:doi", namespaces=_NS))
            venue = entry.findtext("arxiv:journal_ref", namespaces=_NS) or None
            year = int(published[:4]) if published and published[:4].isdigit() else None
            external_ids = {"arxiv": identifier.versioned}
            if doi:
                external_ids["doi"] = doi
            works.append(
                WorkRecord(
                    title=title,
                    authors=authors,
                    abstract=abstract,
                    doi=doi,
                    arxiv_id=identifier.versioned,
                    published=published,
                    updated=updated,
                    year=year,
                    venue=venue,
                    open_access_url=abs_url,
                    pdf_url=pdf_url,
                    categories=categories,
                    external_ids=external_ids,
                    sources=(
                        SourceReference(
                            provider=cls.name,
                            identifier=identifier.versioned,
                            url=abs_url,
                            doi=doi,
                            arxiv_id=identifier.versioned,
                            published=published,
                            updated=updated,
                        ),
                    ),
                )
            )
        return ArxivFeed(
            total=counter("totalResults"),
            start=counter("startIndex") or 0,
            items_per_page=counter("itemsPerPage"),
            works=tuple(works),
        )

    async def search(self, request: SearchRequest) -> SearchPage:
        limit = min(request.limit, 50)
        if request.sort not in {None, "date", "mostrecent", "relevance"}:
            raise ValueError("arXiv sort must be 'date', 'mostrecent', or 'relevance'")
        sort_by = "submittedDate" if request.sort in {"date", "mostrecent"} else "relevance"
        feed = self.parse_feed(
            await self._query(
                {
                    "search_query": build_search_query(request),
                    "start": request.start,
                    "max_results": limit,
                    "sortBy": sort_by,
                    "sortOrder": "descending",
                }
            )
        )
        next_start = (
            request.start + len(feed.works)
            if feed.total is not None
            and request.start + len(feed.works) < feed.total
            else None
        )
        return SearchPage(
            provider=self.name,
            total_available=feed.total,
            start=request.start,
            next_start=next_start,
            works=feed.works,
        )

    async def get_work(self, identifier: str) -> WorkRecord:
        normalized = split_arxiv_id(identifier).versioned
        feed = self.parse_feed(await self._query({"id_list": normalized, "max_results": 1}))
        if not feed.works:
            raise ProviderRecordNotFoundError(f"arXiv returned no record for {identifier!r}")
        return feed.works[0]

    async def get_metadata(self, identifier: str) -> RetrievedMetadata:
        """Return normalized metadata with the exact decoded arXiv Atom payload."""

        normalized = split_arxiv_id(identifier).versioned
        document = await self._http.get_document(
            self._url,
            params={"id_list": normalized, "max_results": 1},
            headers=self._headers,
            rate_key=self.name,
            policy=self._policy,
        )
        feed = self.parse_feed(document.text)
        if not feed.works:
            raise ProviderRecordNotFoundError(f"arXiv returned no record for {identifier!r}")
        return retrieved_metadata(feed.works[0], document)

    async def plan_artifact(self, request: ArtifactAcquisitionRequest) -> ArtifactPlan:
        """Resolve one request to version-pinned arXiv artifact routes."""

        if request.provider.casefold() != self.name:
            raise ValueError("arXiv cannot plan an acquisition for another provider")
        requested = split_arxiv_id(request.identifier)
        retrieved = await self.get_metadata(requested.versioned)
        returned_raw = retrieved.work.arxiv_id
        if returned_raw is None:
            raise ProviderPayloadError("arXiv metadata omitted the returned identifier")
        returned = split_arxiv_id(returned_raw)
        if returned.version is None:
            raise ProviderPayloadError("arXiv metadata did not resolve an exact artifact version")
        if requested.versionless.casefold() != returned.versionless.casefold():
            raise ProviderPayloadError(
                f"arXiv returned {returned.versioned!r} for artifact {requested.versionless!r}"
            )
        if requested.version is not None and requested.versioned.casefold() != returned.versioned.casefold():
            raise ProviderPayloadError(
                f"arXiv returned {returned.versioned!r} for version-pinned request {requested.versioned!r}"
            )

        identifier = returned.versioned
        slug = artifact_slug(self.name, identifier)
        encoded = quote(identifier, safe="/")
        primary_host = urlsplit(self._artifact_base_url).hostname
        secondary_host = urlsplit(self._secondary_artifact_base_url).hostname
        if not primary_host or not secondary_host:
            raise ProviderPayloadError("arXiv artifact endpoints require HTTP hosts")
        allowed_hosts = tuple(dict.fromkeys((primary_host.casefold(), secondary_host.casefold())))
        payloads: list[PlannedArtifact] = []
        for kind in request.artifacts:
            if kind == "source":
                payloads.append(
                    PlannedArtifact(
                        kind=kind,
                        target_leaf=f"arXiv-{slug}.tar.gz",
                        media_type="application/gzip",
                        payload_kind="gzip",
                        minimum_bytes=2,
                        maximum_bytes=self._artifact_limits.source_bytes,
                        candidates=(
                            RetrievalCandidate(
                                candidate_id="arxiv-export-eprint",
                                url=f"{self._secondary_artifact_base_url}/e-print/{encoded}",
                                allowed_hosts=allowed_hosts,
                            ),
                            RetrievalCandidate(
                                candidate_id="arxiv-source",
                                url=f"{self._artifact_base_url}/src/{encoded}",
                                allowed_hosts=allowed_hosts,
                            ),
                        ),
                    )
                )
            elif kind == "pdf":
                payloads.append(
                    PlannedArtifact(
                        kind=kind,
                        target_leaf=f"{slug}.pdf",
                        media_type="application/pdf",
                        payload_kind="pdf",
                        minimum_bytes=5,
                        maximum_bytes=self._artifact_limits.pdf_bytes,
                        candidates=(
                            RetrievalCandidate(
                                candidate_id="arxiv-pdf",
                                url=f"{self._artifact_base_url}/pdf/{encoded}",
                                allowed_hosts=(primary_host.casefold(),),
                            ),
                        ),
                    )
                )
            else:
                payloads.append(
                    PlannedArtifact(
                        kind=kind,
                        target_leaf=f"{slug}.html",
                        media_type="text/html",
                        payload_kind="html",
                        minimum_bytes=16,
                        maximum_bytes=self._artifact_limits.html_bytes,
                        candidates=(
                            RetrievalCandidate(
                                candidate_id="arxiv-html",
                                url=f"{self._artifact_base_url}/html/{encoded}",
                                allowed_hosts=(primary_host.casefold(),),
                            ),
                        ),
                    )
                )

        return ArtifactPlan(
            artifact=ArtifactReference(
                provider=self.name,
                identifier=identifier,
                provider_roles=("artifact-origin", "artifact-access", "metadata-authority"),
            ),
            deposit_slug=slug,
            requested=request.artifacts,
            payloads=tuple(payloads),
        )
