"""Provider descriptor and catalog contracts."""

from __future__ import annotations

from typing import Literal

from pydantic import Field, field_validator

from procurement.domain.base import DomainModel, _unique_strings

ProviderRoleName = Literal[
    "artifact-origin",
    "artifact-access",
    "metadata-authority",
    "metadata-aggregator",
]
ProviderCategoryName = Literal[
    "aggregator",
    "repository",
    "access-source",
    "service",
]


class ProviderDescriptor(DomainModel):
    """Declared provider category, roles, operations, and search constraints."""

    name: str = Field(min_length=1)
    category: ProviderCategoryName
    roles: tuple[ProviderRoleName, ...] = Field(json_schema_extra={"uniqueItems": True})
    capabilities: tuple[str, ...] = Field(json_schema_extra={"uniqueItems": True})
    search_constraints: tuple[str, ...] = Field(json_schema_extra={"uniqueItems": True})

    @field_validator("roles", "capabilities", "search_constraints", mode="before")
    @classmethod
    def _deduplicate_declarations(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)


class ProviderCatalogResponse(DomainModel):
    """Provider declarations exposed to protocol consumers."""

    providers: tuple[ProviderDescriptor, ...]


__all__ = [
    "ProviderCatalogResponse",
    "ProviderCategoryName",
    "ProviderDescriptor",
    "ProviderRoleName",
]
