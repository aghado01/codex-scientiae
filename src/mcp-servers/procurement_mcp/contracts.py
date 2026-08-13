"""MCP request aliases and response projections."""

from __future__ import annotations

from typing import Annotated, Literal

from pydantic import BeforeValidator, Field, StringConstraints, WithJsonSchema

from procurement.domain.base import DomainModel
from procurement.domain.deposits import (
    PORTABLE_LEAF_MAX_UTF16_UNITS,
    PORTABLE_LEAF_PATTERN,
    validate_deposit_slug,
)
from procurement.domain.materialization import PORTABLE_TEX_PATH_PATTERN

RelatedKind = Literal["citations", "references", "recommendations"]
DepositSlug = Annotated[
    str,
    StringConstraints(
        min_length=1,
        max_length=PORTABLE_LEAF_MAX_UTF16_UNITS,
        pattern=r'^[^<>:"/\\|?*\x00-\x1f]+$',
    ),
    BeforeValidator(validate_deposit_slug),
    WithJsonSchema(
        {
            "type": "string",
            "minLength": 1,
            "maxLength": PORTABLE_LEAF_MAX_UTF16_UNITS,
            "pattern": PORTABLE_LEAF_PATTERN,
        },
        mode="validation",
    ),
]
NonEmptyIdentifier = Annotated[str, StringConstraints(strip_whitespace=True, min_length=1)]
ProviderName = NonEmptyIdentifier
MainTexPath = Annotated[
    str,
    StringConstraints(strip_whitespace=True, min_length=5),
    WithJsonSchema(
        {"type": "string", "minLength": 5, "pattern": PORTABLE_TEX_PATH_PATTERN},
        mode="validation",
    ),
]
StartOffset = Annotated[int, Field(ge=0)]
SearchLimit = Annotated[int, Field(ge=1, le=100)]
RelatedLimit = Annotated[int, Field(ge=1, le=50)]


class ArticleCatalogDescriptorResponse(DomainModel):
    """One configured catalog exposed by logical name."""

    name: str


class ArticleCatalogListResponse(DomainModel):
    """Configured source-ready catalogs."""

    catalogs: tuple[ArticleCatalogDescriptorResponse, ...]


class ArticleCatalogSnapshotResponse(DomainModel):
    """Direct-child source-ready membership without inventory publication."""

    name: str
    article_count: int = Field(ge=0)
    slugs: tuple[str, ...]


class ArticleInventoryResultResponse(DomainModel):
    """One independently rebuilt source-ready article inventory."""

    catalog: str
    article_count: int = Field(ge=0)
    slugs: tuple[str, ...]
