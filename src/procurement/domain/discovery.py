"""Provider-neutral discovery operation contracts."""

from __future__ import annotations

from datetime import date
from typing import Literal, Self

from pydantic import ConfigDict, Field, field_validator, model_validator

from procurement.domain.base import DomainModel, _unique_strings
from procurement.domain.works import WorkRecord


class SearchRequest(DomainModel):
    """Provider-neutral discovery search input."""

    model_config = ConfigDict(json_schema_extra=None)

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
        if not isinstance(value, str):
            raise ValueError("query must be a string")
        text = value.strip()
        if not text:
            raise ValueError("query must not be blank")
        return text

    @field_validator("filters", "categories", mode="before")
    @classmethod
    def _normalize_lists(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)

    @field_validator("resource_type", "sort", mode="before")
    @classmethod
    def _strip_optional_text(cls, value: object | None) -> str | None:
        if value is None:
            return None
        if not isinstance(value, str) or not value.strip():
            raise ValueError("optional search text must be a nonblank string")
        return value.strip()

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


__all__ = [
    "ProviderReport",
    "RelatedResponse",
    "ResolveResponse",
    "SearchPage",
    "SearchRequest",
    "SearchResponse",
]
