"""OpenAlex discovery and citation-graph adapter."""

from __future__ import annotations

import re
from collections.abc import Mapping
from typing import Any
from urllib.parse import quote, urlparse

from procurement.errors import ProviderHttpError, ProviderPayloadError
from procurement.http import HttpClient, RequestPolicy
from procurement.identifiers import extract_doi, normalize_doi
from procurement.models import SearchPage, SearchRequest, SourceReference, WorkRecord
from procurement.providers.base import RelatedKind
from procurement.settings import ProviderHttpSettings, RuntimeSecrets


class OpenAlexProvider:
    """OpenAlex works API mapped onto procurement records."""

    name = "openalex"
    _select = ",".join(
        (
            "id",
            "doi",
            "title",
            "publication_year",
            "publication_date",
            "updated_date",
            "cited_by_count",
            "referenced_works",
            "authorships",
            "primary_location",
            "best_oa_location",
            "locations",
            "ids",
            "abstract_inverted_index",
            "topics",
        )
    )

    def __init__(
        self,
        http: HttpClient,
        settings: ProviderHttpSettings,
        secrets: RuntimeSecrets = RuntimeSecrets(),
    ) -> None:
        self._http = http
        self._base_url = settings.base_url.rstrip("/")
        self._contact = secrets.contact_email
        self._headers = {"User-Agent": secrets.user_agent()}
        self._policy = RequestPolicy(
            min_interval_seconds=settings.min_interval_seconds,
            timeout_seconds=settings.timeout_seconds,
            max_attempts=settings.max_attempts,
        )

    async def _get_json(self, path: str, params: Mapping[str, Any] | None = None) -> Mapping[str, Any]:
        query = dict(params or {})
        if self._contact:
            query["mailto"] = self._contact
        payload = await self._http.get_json(
            f"{self._base_url}/{path.lstrip('/')}",
            params=query,
            headers=self._headers,
            rate_key=self.name,
            policy=self._policy,
        )
        if not isinstance(payload, Mapping):
            raise ProviderPayloadError("OpenAlex returned a non-object JSON payload")
        return payload

    @staticmethod
    def normalize_key(identifier: str) -> str:
        value = identifier.strip()
        match = re.match(r"^https?://openalex\.org/(.+)$", value, flags=re.IGNORECASE)
        if match:
            return match.group(1)
        doi = normalize_doi(value)
        if value.lower().startswith(("doi:", "http://doi.org/", "https://doi.org/", "http://dx.doi.org/", "https://dx.doi.org/")):
            return f"doi:{doi}"
        if re.match(r"^10\.\d", value):
            return f"doi:{doi}"
        return value

    @staticmethod
    def reconstruct_abstract(inverted: object | None) -> str | None:
        if not isinstance(inverted, Mapping):
            return None
        positions: dict[int, str] = {}
        for word, offsets in inverted.items():
            if not isinstance(offsets, (list, tuple)):
                continue
            for offset in offsets:
                try:
                    positions[int(offset)] = str(word)
                except (TypeError, ValueError):
                    continue
        if not positions:
            return None
        return " ".join(positions.get(index, "") for index in range(max(positions) + 1)).strip()

    @staticmethod
    def _arxiv_from_url(value: object | None) -> str | None:
        if not value:
            return None
        parsed = urlparse(str(value))
        if parsed.hostname not in {"arxiv.org", "www.arxiv.org", "export.arxiv.org"}:
            return None
        match = re.search(r"/(?:abs|pdf)/(.+?)(?:\.pdf)?$", parsed.path, flags=re.IGNORECASE)
        return match.group(1) if match else None

    @classmethod
    def map_work(cls, payload: Mapping[str, Any]) -> WorkRecord:
        raw_id = str(payload.get("id") or "").strip()
        source_id = re.sub(r"^https?://openalex\.org/", "", raw_id, flags=re.IGNORECASE)
        if not source_id:
            raise ProviderPayloadError("OpenAlex work is missing its id")

        raw_ids = payload.get("ids") if isinstance(payload.get("ids"), Mapping) else {}
        external_ids = {str(key): str(value) for key, value in raw_ids.items() if value is not None}
        doi = payload.get("doi") or raw_ids.get("doi")
        arxiv_id = raw_ids.get("arxiv")

        locations: list[Mapping[str, Any]] = []
        for candidate in (payload.get("primary_location"), payload.get("best_oa_location")):
            if isinstance(candidate, Mapping):
                locations.append(candidate)
        raw_locations = payload.get("locations")
        if isinstance(raw_locations, list):
            locations.extend(item for item in raw_locations if isinstance(item, Mapping))
        if not arxiv_id:
            for location in locations:
                for field in ("landing_page_url", "pdf_url"):
                    arxiv_id = cls._arxiv_from_url(location.get(field))
                    if arxiv_id:
                        break
                if arxiv_id:
                    break

        authors: list[str] = []
        for authorship in payload.get("authorships") or []:
            if not isinstance(authorship, Mapping) or not isinstance(authorship.get("author"), Mapping):
                continue
            name = authorship["author"].get("display_name")
            if name:
                authors.append(str(name))

        primary = payload.get("primary_location")
        best = payload.get("best_oa_location")
        primary = primary if isinstance(primary, Mapping) else {}
        best = best if isinstance(best, Mapping) else {}
        source = primary.get("source") if isinstance(primary.get("source"), Mapping) else {}
        pdf_url = best.get("pdf_url") or primary.get("pdf_url")
        open_access_url = best.get("landing_page_url") or primary.get("landing_page_url")

        concepts: list[str] = []
        for topic in payload.get("topics") or []:
            if isinstance(topic, Mapping) and topic.get("display_name"):
                concepts.append(str(topic["display_name"]))

        referenced = payload.get("referenced_works")
        reference_count = len(referenced) if isinstance(referenced, list) else None
        publication_year = payload.get("publication_year")
        citation_count = payload.get("cited_by_count")
        source_url = raw_id or f"https://openalex.org/{source_id}"

        return WorkRecord(
            title=payload.get("title"),
            authors=authors,
            abstract=cls.reconstruct_abstract(payload.get("abstract_inverted_index")),
            doi=doi,
            arxiv_id=arxiv_id,
            published=payload.get("publication_date"),
            updated=payload.get("updated_date"),
            year=int(publication_year) if publication_year is not None else None,
            venue=source.get("display_name"),
            open_access_url=open_access_url,
            pdf_url=pdf_url,
            citation_count=int(citation_count) if citation_count is not None else None,
            reference_count=reference_count,
            concepts=concepts[:5],
            external_ids=external_ids,
            sources=(
                SourceReference(
                    provider=cls.name,
                    identifier=source_id,
                    url=source_url,
                    doi=doi,
                    arxiv_id=arxiv_id,
                    published=payload.get("publication_date"),
                    updated=payload.get("updated_date"),
                ),
            ),
        )

    async def search(self, request: SearchRequest) -> SearchPage:
        limit = min(request.limit, 50)
        if request.start % limit:
            raise ValueError(f"OpenAlex start must be divisible by its effective page size ({limit})")
        params: dict[str, Any] = {
            "search": request.query,
            "per-page": limit,
            "page": request.start // limit + 1,
            "select": self._select,
        }
        if request.filters:
            params["filter"] = ",".join(request.filters)
        payload = await self._get_json("works", params)
        raw_results = payload.get("results")
        if not isinstance(raw_results, list):
            raise ProviderPayloadError("OpenAlex search response is missing results[]")
        works = tuple(self.map_work(item) for item in raw_results if isinstance(item, Mapping))
        meta = payload.get("meta") if isinstance(payload.get("meta"), Mapping) else {}
        total_raw = meta.get("count")
        total = int(total_raw) if total_raw is not None else None
        next_start = request.start + len(works) if total is not None and request.start + len(works) < total else None
        return SearchPage(provider=self.name, total_available=total, start=request.start, next_start=next_start, works=works)

    async def get_work(self, identifier: str) -> WorkRecord:
        key = quote(self.normalize_key(identifier), safe=":")
        return self.map_work(await self._get_json(f"works/{key}", {"select": self._select}))

    async def related(self, identifier: str, kind: RelatedKind, limit: int) -> tuple[WorkRecord, ...]:
        bounded = min(max(limit, 1), 50)
        if kind == "recommendations":
            raise ValueError("OpenAlex does not provide semantic recommendations")
        if kind == "citations":
            key = self.normalize_key(identifier)
            if key.casefold().startswith("doi:"):
                work = await self.get_work(identifier)
                key = work.sources[0].identifier
            payload = await self._get_json(
                "works",
                {"filter": f"cites:{key}", "per-page": bounded, "select": self._select},
            )
        else:
            key = quote(self.normalize_key(identifier), safe=":")
            raw = await self._get_json(f"works/{key}", {"select": "referenced_works"})
            references = raw.get("referenced_works")
            ids = [
                re.sub(r"^https?://openalex\.org/", "", str(item), flags=re.IGNORECASE)
                for item in references or []
            ][:bounded]
            if not ids:
                return ()
            payload = await self._get_json(
                "works",
                {"filter": f"openalex:{'|'.join(ids)}", "per-page": len(ids), "select": self._select},
            )
        results = payload.get("results")
        if not isinstance(results, list):
            raise ProviderPayloadError("OpenAlex related response is missing results[]")
        return tuple(self.map_work(item) for item in results if isinstance(item, Mapping))

    async def resolve(self, reference: str) -> tuple[WorkRecord, ...]:
        doi = extract_doi(reference)
        if doi:
            try:
                return (await self.get_work(f"doi:{doi}"),)
            except ProviderHttpError as exc:
                if exc.status_code != 404:
                    raise
        page = await self.search(SearchRequest(query=reference, limit=5))
        return page.works
