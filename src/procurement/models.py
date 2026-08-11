"""Provider-neutral discovery records and operation envelopes."""

from __future__ import annotations

from datetime import date, datetime
from typing import Any, Literal, Self

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from procurement.identifiers import arxiv_identity, normalize_arxiv_id, normalize_doi


def _unique_strings(values: Any) -> tuple[str, ...]:
    if values is None:
        return ()
    if isinstance(values, str):
        values = (values,)
    seen: set[str] = set()
    result: list[str] = []
    for value in values:
        text = str(value).strip()
        key = text.casefold()
        if text and key not in seen:
            seen.add(key)
            result.append(text)
    return tuple(result)


class DomainModel(BaseModel):
    """Immutable, strict base for public procurement values."""

    model_config = ConfigDict(frozen=True, extra="forbid")


class SourceReference(DomainModel):
    """Provider identity and temporal provenance for one record."""

    provider: str = Field(min_length=1)
    identifier: str = Field(min_length=1)
    url: str | None = None
    doi: str | None = None
    arxiv_id: str | None = None
    published: datetime | date | None = None
    updated: datetime | date | None = None

    @field_validator("provider", "identifier", mode="before")
    @classmethod
    def _strip_required(cls, value: object) -> str:
        return str(value).strip()

    @field_validator("doi", mode="before")
    @classmethod
    def _normalize_doi(cls, value: object | None) -> str | None:
        return normalize_doi(value)

    @field_validator("arxiv_id", mode="before")
    @classmethod
    def _normalize_arxiv(cls, value: object | None) -> str | None:
        return normalize_arxiv_id(value)

    @property
    def key(self) -> tuple[str, str]:
        return self.provider.casefold(), self.identifier.casefold()


class WorkRecord(DomainModel):
    """Merged scholarly metadata with explicit provider provenance."""

    title: str | None = None
    authors: tuple[str, ...] = ()
    abstract: str | None = None
    doi: str | None = None
    arxiv_id: str | None = None
    published: datetime | date | None = None
    updated: datetime | date | None = None
    year: int | None = Field(default=None, ge=0)
    venue: str | None = None
    open_access_url: str | None = None
    pdf_url: str | None = None
    citation_count: int | None = Field(default=None, ge=0)
    reference_count: int | None = Field(default=None, ge=0)
    tldr: str | None = None
    concepts: tuple[str, ...] = ()
    categories: tuple[str, ...] = ()
    external_ids: dict[str, str] = Field(default_factory=dict)
    sources: tuple[SourceReference, ...]

    @field_validator("doi", mode="before")
    @classmethod
    def _normalize_doi(cls, value: object | None) -> str | None:
        return normalize_doi(value)

    @field_validator("arxiv_id", mode="before")
    @classmethod
    def _normalize_arxiv(cls, value: object | None) -> str | None:
        return normalize_arxiv_id(value)

    @field_validator("authors", "concepts", "categories", mode="before")
    @classmethod
    def _deduplicate_lists(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)

    @field_validator("external_ids", mode="before")
    @classmethod
    def _stringify_ids(cls, value: object | None) -> dict[str, str]:
        if not value:
            return {}
        return {
            str(key): str(item)
            for key, item in dict(value).items()
            if item is not None and str(item).strip()
        }

    @model_validator(mode="after")
    def _require_source(self) -> Self:
        if not self.sources:
            raise ValueError("a work record requires at least one source reference")
        return self

    @property
    def identity_aliases(self) -> frozenset[str]:
        aliases = {f"source:{source.provider.casefold()}:{source.identifier.casefold()}" for source in self.sources}
        if self.doi:
            aliases.add(f"doi:{self.doi}")
        if self.arxiv_id:
            aliases.add(f"arxiv:{arxiv_identity(self.arxiv_id)}")
        return frozenset(aliases)

    @property
    def identity_key(self) -> str:
        if self.doi:
            return f"doi:{self.doi}"
        if self.arxiv_id:
            return f"arxiv:{arxiv_identity(self.arxiv_id)}"
        source = self.sources[0]
        return f"source:{source.provider.casefold()}:{source.identifier.casefold()}"

    def merge(self, other: "WorkRecord") -> "WorkRecord":
        """Merge two records known to describe the same work."""

        if self.identity_aliases.isdisjoint(other.identity_aliases):
            raise ValueError("cannot merge work records without a shared identity alias")

        def present(first: Any, second: Any) -> Any:
            return first if first not in (None, "") else second

        def richer(first: str | None, second: str | None) -> str | None:
            if not first:
                return second
            if not second:
                return first
            return first if len(first) >= len(second) else second

        source_by_key = {source.key: source for source in self.sources}
        for source in other.sources:
            source_by_key.setdefault(source.key, source)

        external_ids = dict(other.external_ids)
        external_ids.update(self.external_ids)

        return WorkRecord(
            title=present(self.title, other.title),
            authors=self.authors if len(self.authors) >= len(other.authors) else other.authors,
            abstract=richer(self.abstract, other.abstract),
            doi=present(self.doi, other.doi),
            arxiv_id=present(self.arxiv_id, other.arxiv_id),
            published=present(self.published, other.published),
            updated=present(self.updated, other.updated),
            year=present(self.year, other.year),
            venue=present(self.venue, other.venue),
            open_access_url=present(self.open_access_url, other.open_access_url),
            pdf_url=present(self.pdf_url, other.pdf_url),
            citation_count=max(
                (value for value in (self.citation_count, other.citation_count) if value is not None),
                default=None,
            ),
            reference_count=max(
                (value for value in (self.reference_count, other.reference_count) if value is not None),
                default=None,
            ),
            tldr=richer(self.tldr, other.tldr),
            concepts=_unique_strings((*self.concepts, *other.concepts)),
            categories=_unique_strings((*self.categories, *other.categories)),
            external_ids=external_ids,
            sources=tuple(source_by_key.values()),
        )


def merge_works(works: list[WorkRecord] | tuple[WorkRecord, ...]) -> tuple[WorkRecord, ...]:
    """Merge a sequence by every known identity alias in stable first-seen order."""

    result: list[WorkRecord] = []
    for work in works:
        matches = [
            index
            for index, existing in enumerate(result)
            if not existing.identity_aliases.isdisjoint(work.identity_aliases)
        ]
        if not matches:
            result.append(work)
            continue
        first = matches[0]
        combined = result[first].merge(work)
        for index in reversed(matches[1:]):
            combined = combined.merge(result[index])
            del result[index]
        result[first] = combined
    return tuple(result)


class SearchRequest(DomainModel):
    """Provider-neutral discovery search input."""

    query: str = Field(min_length=1)
    start: int = Field(default=0, ge=0)
    limit: int = Field(default=25, ge=1, le=100)
    filters: tuple[str, ...] = ()
    categories: tuple[str, ...] = ()
    date_from: date | None = None
    date_to: date | None = None
    resource_type: str | None = None
    sort: str | None = None

    @field_validator("query", mode="before")
    @classmethod
    def _strip_query(cls, value: object) -> str:
        return str(value).strip()

    @field_validator("filters", "categories", mode="before")
    @classmethod
    def _normalize_lists(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)

    @model_validator(mode="after")
    def _date_order(self) -> Self:
        if self.date_from and self.date_to and self.date_from > self.date_to:
            raise ValueError("date_from must not be later than date_to")
        return self


class SearchPage(DomainModel):
    """One provider's bounded discovery page."""

    provider: str
    total_available: int | None = Field(default=None, ge=0)
    start: int = Field(ge=0)
    next_start: int | None = Field(default=None, ge=0)
    works: tuple[WorkRecord, ...] = ()
    returned: int = Field(default=0, ge=0)

    @model_validator(mode="after")
    def _derive_returned(self) -> Self:
        object.__setattr__(self, "returned", len(self.works))
        return self


class ProviderReport(DomainModel):
    """Outcome of one provider participating in a federated operation."""

    provider: str
    status: Literal["ok", "error"]
    total_available: int | None = None
    returned: int = Field(default=0, ge=0)
    next_start: int | None = None
    error: str | None = None


class SearchResponse(DomainModel):
    """Single-provider or federated discovery response."""

    source: str
    providers: tuple[ProviderReport, ...]
    works: tuple[WorkRecord, ...]
    returned: int = Field(default=0, ge=0)

    @model_validator(mode="after")
    def _derive_returned(self) -> Self:
        object.__setattr__(self, "returned", len(self.works))
        return self


class RelatedResponse(DomainModel):
    """Related works returned from one graph provider."""

    provider: str
    kind: Literal["citations", "references", "recommendations"]
    works: tuple[WorkRecord, ...]


class ResolveResponse(DomainModel):
    """Ranked candidate works for a loose reference."""

    provider: str
    reference: str
    works: tuple[WorkRecord, ...]
