"""Scholarly work identities and merged records."""

from __future__ import annotations

from datetime import date, datetime
from typing import Any, Literal, Self

from pydantic import Field, field_validator, model_validator

from procurement.domain.base import DomainModel, FrozenStringMap, _unique_strings
from procurement.identifiers import (
    arxiv_identity,
    is_doi,
    normalize_arxiv_id,
    normalize_doi,
    split_arxiv_id,
    split_zenodo_id,
)


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
        if not isinstance(value, str):
            raise ValueError("provider and identifier must be strings")
        text = value.strip()
        if not text:
            raise ValueError("provider and identifier must not be blank")
        return text

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
    external_ids: FrozenStringMap = Field(default_factory=dict)
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

        dois = {value for value in (self.doi, *(source.doi for source in self.sources)) if value}
        if len(dois) > 1:
            raise ValueError(f"a work record contains conflicting DOI identities: {sorted(dois)}")
        if self.doi is None and dois:
            object.__setattr__(self, "doi", next(iter(dois)))

        arxiv_values = [
            value
            for value in (self.arxiv_id, *(source.arxiv_id for source in self.sources))
            if value
        ]
        arxiv_identities = {arxiv_identity(value) for value in arxiv_values}
        if len(arxiv_identities) > 1:
            raise ValueError(
                "a work record contains conflicting arXiv identities: "
                f"{sorted(arxiv_identities)}"
            )
        if self.arxiv_id is None and arxiv_values:
            selected = max(
                arxiv_values,
                key=lambda value: (
                    split_arxiv_id(value).version is not None,
                    split_arxiv_id(value).version or 0,
                ),
            )
            object.__setattr__(self, "arxiv_id", selected)
        return self

    @property
    def identity_aliases(self) -> frozenset[str]:
        aliases = {
            f"source:{source.provider.casefold()}:{source.identifier.casefold()}"
            for source in self.sources
        }
        aliases.update(f"doi:{source.doi}" for source in self.sources if source.doi)
        aliases.update(
            f"arxiv:{arxiv_identity(source.arxiv_id)}"
            for source in self.sources
            if source.arxiv_id
        )
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

    def identity_is_compatible_with(self, other: "WorkRecord") -> bool:
        """Return whether two records can share one work."""

        if self.doi and other.doi and self.doi != other.doi:
            return False
        if self.arxiv_id and other.arxiv_id:
            return arxiv_identity(self.arxiv_id) == arxiv_identity(other.arxiv_id)
        return True

    def merge(self, other: "WorkRecord") -> "WorkRecord":
        """Merge two records that describe the same work."""

        if self.identity_aliases.isdisjoint(other.identity_aliases):
            raise ValueError("cannot merge work records without a shared identity alias")
        if not self.identity_is_compatible_with(other):
            raise ValueError("cannot merge work records with conflicting identity crosswalks")

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
                (
                    value
                    for value in (self.citation_count, other.citation_count)
                    if value is not None
                ),
                default=None,
            ),
            reference_count=max(
                (
                    value
                    for value in (self.reference_count, other.reference_count)
                    if value is not None
                ),
                default=None,
            ),
            tldr=richer(self.tldr, other.tldr),
            concepts=_unique_strings((*self.concepts, *other.concepts)),
            categories=_unique_strings((*self.categories, *other.categories)),
            external_ids=external_ids,
            sources=tuple(source_by_key.values()),
        )


def merge_works(works: list[WorkRecord] | tuple[WorkRecord, ...]) -> tuple[WorkRecord, ...]:
    """Merge records by all known identity aliases in stable order."""

    result: list[WorkRecord] = []
    for work in works:
        combined = work
        merged_indices: list[int] = []
        changed = True
        while changed:
            changed = False
            for index, existing in enumerate(result):
                if index in merged_indices:
                    continue
                if existing.identity_aliases.isdisjoint(combined.identity_aliases):
                    continue
                if not existing.identity_is_compatible_with(combined):
                    continue
                combined = existing.merge(combined)
                merged_indices.append(index)
                changed = True
        if not merged_indices:
            result.append(work)
            continue
        first = min(merged_indices)
        for index in reversed(sorted(merged_indices)):
            del result[index]
        result.insert(first, combined)
    return tuple(result)


class WorkIdentityAnchor(DomainModel):
    """Caller-supplied scholarly identity used to select API metadata."""

    kind: Literal["doi"]
    value: str = Field(min_length=1)
    supplied_by: Literal["caller"] = "caller"

    @field_validator("value", mode="before")
    @classmethod
    def _canonicalize_value(cls, value: object) -> str:
        if not is_doi(value):
            raise ValueError("a DOI identity anchor requires a complete DOI")
        return normalize_doi(value) or ""

    @property
    def identity_aliases(self) -> frozenset[str]:
        """Return the canonical work aliases represented by the anchor."""

        return frozenset({f"doi:{self.value}"})


def artifact_identity_aliases(provider: str, identifier: str) -> frozenset[str]:
    """Return aliases that prove an artifact-metadata identity match."""

    key = provider.casefold()
    if key == "arxiv":
        return frozenset({f"arxiv:{arxiv_identity(identifier)}"})
    if key == "zenodo":
        value = split_zenodo_id(identifier)
        return frozenset(
            {
                f"source:zenodo:{value.record_id}",
                f"doi:{value.doi}",
            }
        )
    if key == "scihub":
        doi = normalize_doi(identifier)
        if not is_doi(doi):
            raise ValueError("Sci-Hub artifact identity requires a DOI")
        return frozenset({f"doi:{doi}"})
    return frozenset({f"source:{key}:{identifier.casefold()}"})


__all__ = [
    "SourceReference",
    "WorkIdentityAnchor",
    "WorkRecord",
    "artifact_identity_aliases",
    "merge_works",
]
