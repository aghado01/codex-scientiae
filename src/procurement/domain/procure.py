"""Lock-step acquire-and-materialize contracts."""

from __future__ import annotations

from pydantic import Field, field_validator

from procurement.domain.acquisition.planning import (
    ArtifactKind,
    _unique_text,
)
from procurement.domain.acquisition.receipts import AcquisitionResult
from procurement.domain.base import DomainModel
from procurement.domain.deposits import validate_catalog_destination
from procurement.domain.materialization import (
    ArtifactIdentityMetadata,
    PORTABLE_TEX_PATH_PATTERN,
    SourceMaterializationResult,
    SourceMetadataInput,
    validate_source_relative_path,
)


class ProcureRequest(DomainModel):
    """One destination-bound acquire followed immediately by source materialization."""

    provider: str = Field(min_length=1)
    identifier: str = Field(min_length=1)
    catalog: str = Field(min_length=1)
    artifacts: tuple[ArtifactKind, ...] = Field(
        default=("source", "pdf"),
        min_length=1,
        json_schema_extra={"uniqueItems": True},
    )
    main_tex: str | None = Field(
        default=None,
        json_schema_extra={"pattern": PORTABLE_TEX_PATH_PATTERN},
    )
    metadata: SourceMetadataInput = Field(default_factory=ArtifactIdentityMetadata)

    @field_validator("provider", "identifier", mode="before")
    @classmethod
    def _strip_text(cls, value: object) -> str:
        if not isinstance(value, str) or not value.strip():
            raise ValueError("provider and identifier must be non-empty strings")
        return value.strip()

    @field_validator("catalog", mode="before")
    @classmethod
    def _catalog_destination(cls, value: object) -> str:
        if not isinstance(value, str) or not value.strip():
            raise ValueError("catalog destination must be a non-empty string")
        return validate_catalog_destination(value)

    @field_validator("artifacts", mode="before")
    @classmethod
    def _deduplicate_artifacts(cls, value: object) -> tuple[str, ...]:
        return _unique_text(value, label="artifacts")

    @field_validator("main_tex", mode="before")
    @classmethod
    def _optional_main_tex(cls, value: object) -> str | None:
        if value is None:
            return None
        if not isinstance(value, str):
            raise ValueError("main_tex must be a string or null")
        text = value.strip()
        return validate_source_relative_path(text) if text else None


class ProcureResult(DomainModel):
    """Acquisition receipt and source-ready article from one procure operation."""

    acquisition: AcquisitionResult
    materialization: SourceMaterializationResult


__all__ = ["ProcureRequest", "ProcureResult"]
