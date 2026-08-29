"""Source-materialization request and result contracts."""

from __future__ import annotations

from typing import Annotated, Literal, Self

from pydantic import Field, field_validator, model_validator

from procurement.domain.base import DomainModel
from procurement.domain.deposits import (
    PORTABLE_LEAF_PATTERN,
    validate_artifact_deposit_reference,
    validate_catalog_destination,
    validate_deposit_slug,
)
from procurement.domain.metadata import ArtifactReference
from procurement.domain.works import WorkIdentityAnchor
from procurement.identifiers import is_doi, normalize_doi

MetadataMode = Literal["required", "omit"]
PORTABLE_RELATIVE_PATTERN = (
    r"^(?!(?:.*\/)?(?:[Cc][Oo][Nn]|[Pp][Rr][Nn]|[Aa][Uu][Xx]|[Nn][Uu][Ll]|"
    r"[Cc][Oo][Mm][1-9]|[Ll][Pp][Tt][1-9])(?:\.|\/|$))"
    r"(?!(?:.*\/)?\.{1,2}(?:\/|$))(?!.*[ .](?:\/|$))"
    r"(?!.*[<>:\"\\|?*\u0000-\u001F])[^/]+(?:/[^/]+)*$"
)
PORTABLE_TEX_PATH_PATTERN = PORTABLE_RELATIVE_PATTERN[:-1] + r"\.[Tt][Ee][Xx]$"


def validate_source_relative_path(value: str) -> str:
    """Return one normalized portable relative source path."""

    if (
        not value
        or "\\" in value
        or value.startswith("/")
        or value.endswith("/")
        or ":" in value
    ):
        raise ValueError("main_tex must be a normalized portable relative path")
    parts = value.split("/")
    if any(validate_deposit_slug(part) != part for part in parts):
        raise ValueError("main_tex must be a normalized portable relative path")
    if not value.casefold().endswith(".tex"):
        raise ValueError("main_tex must name a .tex source file")
    return value


def _metadata_fallback_names(value: object) -> tuple[str, ...] | None:
    """Return distinct configured provider names without resolving them."""

    if value is None:
        return None
    if isinstance(value, str) or not isinstance(value, (list, tuple)):
        raise ValueError("fallback_sources must be a sequence or null")
    result: list[str] = []
    seen: set[str] = set()
    for item in value:
        if not isinstance(item, str) or not item.strip():
            raise ValueError("metadata fallback names must be non-empty strings")
        name = item.strip()
        key = name.casefold()
        if key in seen:
            raise ValueError("metadata fallback names must be unique")
        seen.add(key)
        result.append(name)
    return tuple(result)


class ArtifactIdentityMetadata(DomainModel):
    """Resolve bibliography from the acquisition artifact identity."""

    mode: Literal["artifact-identity"] = "artifact-identity"
    fallback_sources: tuple[str, ...] | None = None

    @field_validator("fallback_sources", mode="before")
    @classmethod
    def _fallbacks(cls, value: object) -> tuple[str, ...] | None:
        return _metadata_fallback_names(value)


class ExplicitDoiMetadata(DomainModel):
    """Resolve bibliography from one caller-selected DOI identity."""

    mode: Literal["explicit-doi"] = "explicit-doi"
    doi: str
    fallback_sources: tuple[str, ...] | None = None

    @field_validator("doi", mode="before")
    @classmethod
    def _canonical_doi(cls, value: object) -> str:
        if not is_doi(value):
            raise ValueError("explicit-doi metadata requires a complete DOI")
        return normalize_doi(value) or ""

    @field_validator("fallback_sources", mode="before")
    @classmethod
    def _fallbacks(cls, value: object) -> tuple[str, ...] | None:
        return _metadata_fallback_names(value)


class OmitArticleMetadata(DomainModel):
    """Publish a deliberately metadata-free article."""

    mode: Literal["omit"] = "omit"


SourceMetadataInput = Annotated[
    ArtifactIdentityMetadata | ExplicitDoiMetadata | OmitArticleMetadata,
    Field(discriminator="mode"),
]


class SourceMaterializationRequest(DomainModel):
    """One source-only preparation request addressed through configured names."""

    catalog: str = Field(min_length=1)
    acquisition_slug: str = Field(
        min_length=1,
        json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN},
    )
    main_tex: str | None = Field(
        default=None,
        json_schema_extra={"pattern": PORTABLE_TEX_PATH_PATTERN},
    )
    metadata: SourceMetadataInput = Field(default_factory=ArtifactIdentityMetadata)
    rebuild: bool = False

    @field_validator("catalog", mode="before")
    @classmethod
    def _catalog_name(cls, value: object) -> str:
        if not isinstance(value, str) or not value.strip():
            raise ValueError("catalog destination must be a non-empty string")
        return validate_catalog_destination(value)

    @field_validator("acquisition_slug", mode="before")
    @classmethod
    def _acquisition_leaf(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @field_validator("main_tex", mode="before")
    @classmethod
    def _optional_main_tex(cls, value: object) -> str | None:
        if value is None:
            return None
        if not isinstance(value, str):
            raise ValueError("main_tex must be a string or null")
        text = value.strip()
        return validate_source_relative_path(text) if text else None

    @property
    def metadata_mode(self) -> MetadataMode:
        """Return the immutable article's coarse metadata state."""

        return "omit" if self.metadata.mode == "omit" else "required"

    @property
    def metadata_fallback_sources(self) -> tuple[str, ...] | None:
        """Return configured aggregator overrides for resolving strategies."""

        return getattr(self.metadata, "fallback_sources", None)

    @property
    def identity_anchor(self) -> WorkIdentityAnchor | None:
        """Return the expected durable identity anchor for explicit resolution."""

        if self.metadata.mode != "explicit-doi":
            return None
        return WorkIdentityAnchor(kind="doi", value=self.metadata.doi)


class SourceMaterializationResult(DomainModel):
    """Published source-deposit facts returned without rematerializing an inventory."""

    catalog: str = Field(min_length=1)
    slug: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    status: Literal["deposited", "already-deposited", "rebuilt"]
    created: bool
    artifact: ArtifactReference
    acquisition_manifest_path: str = Field(min_length=1)
    document_directory: str = Field(min_length=1)
    article_path: str = Field(min_length=1)
    archive_path: str = Field(min_length=1)
    source_path: str = Field(min_length=1)
    metadata_path: str | None = None
    pdf_path: str | None = None
    archive_sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    tree_sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    archive_kind: Literal["tar+gzip", "single-tex+gzip"]
    entrypoint: str = Field(min_length=1)
    metadata_route: Literal[
        "artifact-provider",
        "aggregator-fallback",
        "identifier-aggregator",
    ] | None = None

    @model_validator(mode="after")
    def _status_agrees(self) -> Self:
        validate_artifact_deposit_reference(
            self.artifact.provider,
            self.slug,
            self.artifact.identifier,
        )
        if self.created != (self.status == "deposited"):
            raise ValueError("created must agree with the source-deposit status")
        if (self.metadata_path is None) != (self.metadata_route is None):
            raise ValueError("metadata path and route must either both be present or both be absent")
        return self


__all__ = [
    "ArtifactIdentityMetadata",
    "ExplicitDoiMetadata",
    "MetadataMode",
    "OmitArticleMetadata",
    "PORTABLE_RELATIVE_PATTERN",
    "PORTABLE_TEX_PATH_PATTERN",
    "SourceMaterializationRequest",
    "SourceMaterializationResult",
    "SourceMetadataInput",
    "validate_source_relative_path",
]
