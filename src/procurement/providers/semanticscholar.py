"""Semantic Scholar graph and recommendation adapter."""

from __future__ import annotations

import re
from collections.abc import Mapping
from typing import Any
from urllib.parse import quote

from procurement.errors import ProviderHttpError, ProviderPayloadError
from procurement.http import HttpClient, RequestPolicy
from procurement.identifiers import extract_doi, normalize_arxiv_id, normalize_doi
from procurement.models import SearchPage, SearchRequest, SourceReference, WorkRecord
from procurement.providers.base import RelatedKind
from procurement.settings import ProviderHttpSettings, RuntimeSecrets


class SemanticScholarProvider:
    """Semantic Scholar Graph API mapped onto procurement records."""

    name = "semanticscholar"
    _fields = ",".join(
        (
            "paperId",
            "externalIds",
            "url",
            "title",
            "abstract",
            "year",
            "publicationDate",
            "venue",
            "authors",
            "citationCount",
            "referenceCount",
            "tldr",
            "openAccessPdf",
            "fieldsOfStudy",
        )
    )
    _typed_prefix = re.compile(r"^(DOI|ARXIV|MAG|ACL|PMID|PMCID|CorpusId|URL):", re.IGNORECASE)

    def __init__(
        self,
        http: HttpClient,
        settings: ProviderHttpSettings,
        secrets: RuntimeSecrets = RuntimeSecrets(),
    ) -> None:
        self._http = http
        self._graph_url = settings.base_url.rstrip("/")
        self._recommendations_url = (settings.secondary_base_url or "").rstrip("/")
        headers = {"User-Agent": secrets.user_agent()}
        if secrets.semantic_scholar_api_key:
            headers["x-api-key"] = secrets.semantic_scholar_api_key
        self._headers = headers
        interval = min(settings.min_interval_seconds, 0.35) if secrets.semantic_scholar_api_key else settings.min_interval_seconds
        self._policy = RequestPolicy(
            min_interval_seconds=interval,
            timeout_seconds=settings.timeout_seconds,
            max_attempts=settings.max_attempts,
        )

    async def _get_json(
        self,
        path: str,
        params: Mapping[str, Any] | None = None,
        *,
        recommendations: bool = False,
    ) -> Mapping[str, Any]:
        base = self._recommendations_url if recommendations else self._graph_url
        payload = await self._http.get_json(
            f"{base}/{path.lstrip('/')}",
            params=params,
            headers=self._headers,
            rate_key=self.name,
            policy=self._policy,
        )
        if not isinstance(payload, Mapping):
            raise ProviderPayloadError("Semantic Scholar returned a non-object JSON payload")
        return payload

    @classmethod
    def normalize_key(cls, identifier: str) -> str:
        value = identifier.strip()
        if cls._typed_prefix.match(value):
            prefix, payload = value.split(":", 1)
            canonical = "ARXIV" if prefix.casefold() == "arxiv" else "DOI" if prefix.casefold() == "doi" else prefix
            return f"{canonical}:{payload}"
        doi = normalize_doi(value)
        if re.match(r"^10\.\d", value):
            return f"DOI:{doi}"
        arxiv = normalize_arxiv_id(value)
        if arxiv:
            return f"ARXIV:{arxiv}"
        return value

    @classmethod
    def map_work(cls, payload: Mapping[str, Any]) -> WorkRecord:
        paper_id = str(payload.get("paperId") or "").strip()
        if not paper_id:
            raise ProviderPayloadError("Semantic Scholar paper is missing paperId")
        raw_external = payload.get("externalIds")
        raw_external = raw_external if isinstance(raw_external, Mapping) else {}
        external_ids = {str(key): str(value) for key, value in raw_external.items() if value is not None}
        doi = raw_external.get("DOI")
        arxiv_id = raw_external.get("ArXiv") or raw_external.get("ARXIV")
        authors = [
            str(author["name"])
            for author in payload.get("authors") or []
            if isinstance(author, Mapping) and author.get("name")
        ]
        open_pdf = payload.get("openAccessPdf")
        open_pdf = open_pdf if isinstance(open_pdf, Mapping) else {}
        tldr = payload.get("tldr")
        tldr = tldr if isinstance(tldr, Mapping) else {}
        source_url = str(payload.get("url") or f"https://www.semanticscholar.org/paper/{paper_id}")
        year = payload.get("year")
        citation_count = payload.get("citationCount")
        reference_count = payload.get("referenceCount")

        return WorkRecord(
            title=payload.get("title"),
            authors=authors,
            abstract=payload.get("abstract"),
            doi=doi,
            arxiv_id=arxiv_id,
            published=payload.get("publicationDate"),
            year=int(year) if year is not None else None,
            venue=payload.get("venue"),
            open_access_url=source_url,
            pdf_url=open_pdf.get("url"),
            citation_count=int(citation_count) if citation_count is not None else None,
            reference_count=int(reference_count) if reference_count is not None else None,
            tldr=tldr.get("text"),
            concepts=payload.get("fieldsOfStudy") or (),
            external_ids=external_ids,
            sources=(
                SourceReference(
                    provider=cls.name,
                    identifier=paper_id,
                    url=source_url,
                    doi=doi,
                    arxiv_id=arxiv_id,
                    published=payload.get("publicationDate"),
                ),
            ),
        )

    async def search(self, request: SearchRequest) -> SearchPage:
        limit = min(request.limit, 100)
        payload = await self._get_json(
            "paper/search",
            {"query": request.query, "offset": request.start, "limit": limit, "fields": self._fields},
        )
        results = payload.get("data")
        if not isinstance(results, list):
            raise ProviderPayloadError("Semantic Scholar search response is missing data[]")
        works = tuple(self.map_work(item) for item in results if isinstance(item, Mapping) and item.get("paperId"))
        total_raw = payload.get("total")
        total = int(total_raw) if total_raw is not None else None
        next_raw = payload.get("next")
        next_start = int(next_raw) if next_raw is not None else None
        return SearchPage(provider=self.name, total_available=total, start=request.start, next_start=next_start, works=works)

    async def get_work(self, identifier: str) -> WorkRecord:
        key = quote(self.normalize_key(identifier), safe=":")
        return self.map_work(await self._get_json(f"paper/{key}", {"fields": self._fields}))

    async def related(self, identifier: str, kind: RelatedKind, limit: int) -> tuple[WorkRecord, ...]:
        key = quote(self.normalize_key(identifier), safe=":")
        bounded = min(max(limit, 1), 100)
        if kind == "recommendations":
            payload = await self._get_json(
                f"papers/forpaper/{key}",
                {"limit": bounded, "fields": self._fields},
                recommendations=True,
            )
            records = payload.get("recommendedPapers")
            member = None
        else:
            payload = await self._get_json(
                f"paper/{key}/{kind}",
                {"limit": bounded, "fields": self._fields},
            )
            records = payload.get("data")
            member = "citingPaper" if kind == "citations" else "citedPaper"
        if not isinstance(records, list):
            raise ProviderPayloadError("Semantic Scholar related response is missing its records array")
        mapped: list[WorkRecord] = []
        for item in records:
            if not isinstance(item, Mapping):
                continue
            candidate = item.get(member) if member else item
            if isinstance(candidate, Mapping) and candidate.get("paperId"):
                mapped.append(self.map_work(candidate))
        return tuple(mapped)

    async def resolve(self, reference: str) -> tuple[WorkRecord, ...]:
        direct_key: str | None = None
        doi = extract_doi(reference)
        if doi:
            direct_key = f"DOI:{doi}"
        else:
            arxiv = normalize_arxiv_id(reference)
            if arxiv:
                direct_key = f"ARXIV:{arxiv}"
        if direct_key:
            try:
                return (await self.get_work(direct_key),)
            except ProviderHttpError as exc:
                if exc.status_code != 404:
                    raise
        page = await self.search(SearchRequest(query=reference, limit=5))
        return page.works
