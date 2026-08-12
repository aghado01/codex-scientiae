"""Artifact acquisition receipts and operation results."""

from __future__ import annotations

from datetime import datetime
from typing import Any, Literal, Self

from pydantic import ConfigDict, Field, field_validator, model_validator

from procurement.domain.acquisition._schema import (
    acquired_artifact_schema_extra,
    acquisition_manifest_schema_extra,
    acquisition_outcome_schema,
    acquisition_result_schema,
)
from procurement.domain.acquisition.planning import (
    SAFE_ARTIFACT_URL_PATTERN,
    ArtifactKind,
    ChecksumExpectation,
    _safe_http_url,
)
from procurement.domain.base import DomainModel
from procurement.domain.deposits import (
    PORTABLE_LEAF_PATTERN,
    validate_artifact_deposit_reference,
    validate_deposit_slug,
)
from procurement.domain.metadata import ArtifactReference


class LocalImportProvenance(DomainModel):
    """Configured logical source and time for a local custody transfer."""

    inbox: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    leaf: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    imported_at: datetime

    @field_validator("inbox", "leaf", mode="before")
    @classmethod
    def _portable_leaf(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @model_validator(mode="after")
    def _require_aware_time(self) -> Self:
        if self.imported_at.tzinfo is None or self.imported_at.utcoffset() is None:
            raise ValueError("imported_at must include a UTC offset")
        return self


class AcquiredArtifact(DomainModel):
    """One locally validated artifact named by an acquisition receipt."""

    model_config = ConfigDict(json_schema_extra=acquired_artifact_schema_extra)

    kind: ArtifactKind
    path: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    format: str = Field(min_length=1)
    bytes: int = Field(ge=1)
    sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    custody: Literal["provider-download", "local-import"] = "provider-download"
    origin_url: str | None = Field(
        default=None,
        json_schema_extra={"format": "uri", "pattern": SAFE_ARTIFACT_URL_PATTERN},
    )
    candidate_id: str | None = Field(default=None, min_length=1)
    fetched_at: datetime | None = None
    provider_checksum: ChecksumExpectation | None = None
    local_import: LocalImportProvenance | None = None

    @field_validator("path", mode="before")
    @classmethod
    def _portable_path(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @field_validator("origin_url", mode="before")
    @classmethod
    def _origin_url(cls, value: object | None) -> str | None:
        if value is None:
            return None
        return _safe_http_url(value, label="origin_url")

    @model_validator(mode="after")
    def _validate_custody(self) -> Self:
        if self.custody == "provider-download":
            if self.origin_url is None or self.candidate_id is None or self.fetched_at is None:
                raise ValueError(
                    "provider-download custody requires origin_url, candidate_id, and fetched_at"
                )
            if self.local_import is not None:
                raise ValueError("provider-download custody cannot name a local import")
        else:
            if self.local_import is None:
                raise ValueError("local-import custody requires local_import provenance")
            if any(
                value is not None
                for value in (
                    self.origin_url,
                    self.candidate_id,
                    self.fetched_at,
                    self.provider_checksum,
                )
            ):
                raise ValueError(
                    "local-import custody cannot claim provider download provenance"
                )
        if self.fetched_at is not None and (
            self.fetched_at.tzinfo is None or self.fetched_at.utcoffset() is None
        ):
            raise ValueError("fetched_at must include a UTC offset")
        return self


class AcquisitionManifest(DomainModel):
    """Narrow acquired-byte receipt; it makes no source-ready claim."""

    model_config = ConfigDict(json_schema_extra=acquisition_manifest_schema_extra)

    schema_id: Literal["codex-scientiae/acquisition/0.1"] = Field(
        default="codex-scientiae/acquisition/0.1",
        alias="schema",
    )
    state: Literal["acquired"] = "acquired"
    slug: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    artifact: ArtifactReference
    forms: tuple[AcquiredArtifact, ...] = Field(min_length=1)

    @field_validator("slug", mode="before")
    @classmethod
    def _portable_slug(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @model_validator(mode="after")
    def _validate_manifest(self) -> Self:
        # Provider canonicalization and Unicode case-folded path comparison are
        # intentionally runtime-only; standard JSON Schema cannot express them.
        canonical = validate_artifact_deposit_reference(
            self.artifact.provider,
            self.slug,
            self.artifact.identifier,
        )
        if canonical != self.artifact.identifier:
            raise ValueError("acquisition identifier is not canonical")
        kinds = [form.kind for form in self.forms]
        paths = [form.path.casefold() for form in self.forms]
        if len(kinds) != len(set(kinds)):
            raise ValueError("an acquisition receipt may contain one form per artifact kind")
        if len(paths) != len(set(paths)):
            raise ValueError("acquisition paths must be portable-case unique")
        return self


class AcquisitionOutcome(DomainModel):
    """Result of acquiring or considering one requested artifact kind."""

    model_config = ConfigDict(json_schema_extra=acquisition_outcome_schema)

    kind: ArtifactKind
    status: Literal["acquired", "already-present", "unavailable", "error"]
    path: str | None = None
    error: str | None = None

    @model_validator(mode="after")
    def _validate_status(self) -> Self:
        if self.status in {"acquired", "already-present"}:
            if self.path is None or self.error is not None:
                raise ValueError("successful acquisition outcomes require path and no error")
        elif not self.error or self.path is not None:
            raise ValueError("unsuccessful acquisition outcomes require error and no path")
        return self


class AcquisitionResult(DomainModel):
    """One acquisition operation and its current durable receipt."""

    model_config = ConfigDict(json_schema_extra=acquisition_result_schema)

    staging_directory: str = Field(min_length=1)
    manifest_path: str | None = None
    manifest: AcquisitionManifest | None = None
    outcomes: tuple[AcquisitionOutcome, ...] = Field(min_length=1)

    @model_validator(mode="after")
    def _manifest_pair(self) -> Self:
        if (self.manifest_path is None) != (self.manifest is None):
            raise ValueError(
                "manifest_path and manifest must either both be present or both be absent"
            )
        if self.manifest is None and any(
            outcome.status in {"acquired", "already-present"} for outcome in self.outcomes
        ):
            raise ValueError("successful outcomes require an acquisition manifest")
        return self


def acquisition_manifest_schema() -> dict[str, Any]:
    """Return the public receipt schema with serialized defaults required."""

    return AcquisitionManifest.model_json_schema(mode="serialization", by_alias=True)


__all__ = [
    "AcquiredArtifact",
    "AcquisitionManifest",
    "AcquisitionOutcome",
    "AcquisitionResult",
    "LocalImportProvenance",
    "acquisition_manifest_schema",
]
