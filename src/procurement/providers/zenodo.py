"""Zenodo record-discovery adapter."""

from __future__ import annotations

from collections.abc import Mapping
from html.parser import HTMLParser
from typing import Any

from procurement.errors import ProviderPayloadError
from procurement.http import HttpClient, RequestPolicy
from procurement.identifiers import split_zenodo_id
from procurement.models import RetrievedMetadata, SearchPage, SearchRequest, SourceReference, WorkRecord
from procurement.providers.base import retrieved_metadata
from procurement.settings import ProviderHttpSettings, RuntimeSecrets


class _TextExtractor(HTMLParser):
    _separators = frozenset(
        {
            "br",
            "dd",
            "div",
            "dl",
            "dt",
            "h1",
            "h2",
            "h3",
            "h4",
            "h5",
            "h6",
            "li",
            "ol",
            "p",
            "pre",
            "table",
            "td",
            "th",
            "tr",
            "ul",
        }
    )

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.parts: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag.casefold() in self._separators:
            self.parts.append(" ")

    def handle_endtag(self, tag: str) -> None:
        if tag.casefold() in self._separators:
            self.parts.append(" ")

    def handle_data(self, data: str) -> None:
        self.parts.append(data)


def strip_html(value: object | None) -> str | None:
    """Return normalized text from a small HTML fragment."""

    if not value:
        return None
    parser = _TextExtractor()
    parser.feed(str(value))
    text = " ".join("".join(parser.parts).split())
    return text or None


class ZenodoProvider:
    """Zenodo records API mapped onto procurement records."""

    name = "zenodo"
    search_constraints = frozenset({"resource_type", "sort"})

    def __init__(
        self,
        http: HttpClient,
        settings: ProviderHttpSettings,
        secrets: RuntimeSecrets = RuntimeSecrets(),
    ) -> None:
        self._http = http
        self._base_url = settings.base_url.rstrip("/")
        self._headers = {"User-Agent": secrets.user_agent()}
        self._policy = RequestPolicy(
            min_interval_seconds=settings.min_interval_seconds,
            timeout_seconds=settings.timeout_seconds,
            max_attempts=settings.max_attempts,
        )

    async def _get_json(self, path: str = "", params: Mapping[str, Any] | None = None) -> Mapping[str, Any]:
        url = self._base_url + (f"/{path.lstrip('/')}" if path else "")
        payload = await self._http.get_json(
            url,
            params=params,
            headers=self._headers,
            rate_key=self.name,
            policy=self._policy,
        )
        if not isinstance(payload, Mapping):
            raise ProviderPayloadError("Zenodo returned a non-object JSON payload")
        return payload

    @classmethod
    def map_work(cls, payload: Mapping[str, Any]) -> WorkRecord:
        record_id = str(payload.get("id") or "").strip()
        if not record_id:
            raise ProviderPayloadError("Zenodo record is missing id")
        metadata = payload.get("metadata")
        metadata = metadata if isinstance(metadata, Mapping) else {}
        links = payload.get("links")
        links = links if isinstance(links, Mapping) else {}
        doi = payload.get("doi") or metadata.get("doi")
        authors = [
            str(creator["name"])
            for creator in metadata.get("creators") or []
            if isinstance(creator, Mapping) and creator.get("name")
        ]
        pdf_url: str | None = None
        for file_record in payload.get("files") or []:
            if not isinstance(file_record, Mapping):
                continue
            filename = str(file_record.get("key") or file_record.get("filename") or "")
            if not filename.casefold().endswith(".pdf"):
                continue
            file_links = file_record.get("links")
            file_links = file_links if isinstance(file_links, Mapping) else {}
            pdf_url = file_links.get("self") or file_links.get("download")
            if pdf_url:
                pdf_url = str(pdf_url)
                break
        publication_date = metadata.get("publication_date")
        publication_text = str(publication_date) if publication_date else None
        year = int(publication_text[:4]) if publication_text and publication_text[:4].isdigit() else None
        resource_type = metadata.get("resource_type")
        resource_type = resource_type if isinstance(resource_type, Mapping) else {}
        record_url = str(links.get("html") or f"https://zenodo.org/records/{record_id}")
        external_ids = {"zenodo": record_id}
        if doi:
            external_ids["doi"] = str(doi)
        return WorkRecord(
            title=metadata.get("title"),
            authors=authors,
            abstract=strip_html(metadata.get("description")),
            doi=doi,
            published=publication_text,
            year=year,
            venue=f"Zenodo ({resource_type.get('type')})" if resource_type.get("type") else "Zenodo",
            open_access_url=record_url,
            pdf_url=pdf_url,
            concepts=metadata.get("keywords") or (),
            external_ids=external_ids,
            sources=(
                SourceReference(
                    provider=cls.name,
                    identifier=record_id,
                    url=record_url,
                    doi=doi,
                    published=publication_text,
                ),
            ),
        )

    async def search(self, request: SearchRequest) -> SearchPage:
        # The public records endpoint permits at most 25 results without authentication.
        limit = min(request.limit, 25)
        if request.sort not in {None, "bestmatch", "mostrecent"}:
            raise ValueError("Zenodo sort must be 'bestmatch' or 'mostrecent'")
        if request.start % limit:
            raise ValueError(f"Zenodo start must be divisible by its effective page size ({limit})")
        params: dict[str, Any] = {
            "q": request.query,
            "size": limit,
            "page": request.start // limit + 1,
            "sort": request.sort or "bestmatch",
        }
        if request.resource_type:
            params["type"] = request.resource_type
        payload = await self._get_json(params=params)
        hits_container = payload.get("hits")
        hits_container = hits_container if isinstance(hits_container, Mapping) else {}
        records = hits_container.get("hits")
        if not isinstance(records, list):
            raise ProviderPayloadError("Zenodo search response is missing hits.hits[]")
        works = tuple(self.map_work(item) for item in records if isinstance(item, Mapping))
        total_raw = hits_container.get("total")
        if isinstance(total_raw, Mapping):
            total_raw = total_raw.get("value")
        total = int(total_raw) if total_raw is not None else None
        next_start = (
            request.start + len(works)
            if total is not None and request.start + len(works) < total
            else None
        )
        return SearchPage(
            provider=self.name,
            total_available=total,
            start=request.start,
            next_start=next_start,
            works=works,
        )

    async def get_work(self, identifier: str) -> WorkRecord:
        record = split_zenodo_id(identifier)
        return self.map_work(await self._get_json(record.record_id))

    async def get_metadata(self, identifier: str) -> RetrievedMetadata:
        """Return normalized metadata with its exact HTTP-decoded Zenodo payload."""

        record = split_zenodo_id(identifier)
        document = await self._http.get_document(
            f"{self._base_url}/{record.record_id}",
            headers=self._headers,
            rate_key=self.name,
            policy=self._policy,
        )
        try:
            payload = document.json()
        except (ValueError, UnicodeDecodeError) as exc:
            raise ProviderPayloadError("Zenodo returned invalid JSON metadata") from exc
        if not isinstance(payload, Mapping):
            raise ProviderPayloadError("Zenodo returned a non-object JSON metadata payload")
        return retrieved_metadata(self.map_work(payload), document)
