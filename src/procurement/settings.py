"""Validated non-secret settings and environment-derived credentials."""

from __future__ import annotations

import json
import os
from importlib.resources import files
from pathlib import Path
from typing import Literal, Self

from pydantic import BaseModel, ConfigDict, Field, SecretStr, field_validator, model_validator

from procurement.errors import ConfigurationError
from procurement.models import validate_deposit_slug


class ProviderHttpSettings(BaseModel):
    """HTTP endpoint and request policy for one provider."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    base_url: str
    secondary_base_url: str | None = None
    artifact_base_url: str | None = None
    secondary_artifact_base_url: str | None = None
    min_interval_seconds: float = Field(ge=0)
    timeout_seconds: float = Field(gt=0)
    max_attempts: int = Field(default=3, ge=1)


class CatalogSettings(BaseModel):
    """One logical source catalog beneath the application workspace."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    name: str = Field(min_length=1)
    path: str = Field(min_length=1)


class LocalInboxSettings(BaseModel):
    """One logical local-import inbox beneath the application workspace."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    name: str = Field(min_length=1)
    path: str = Field(min_length=1)

    @field_validator("name", mode="before")
    @classmethod
    def _portable_name(cls, value: object) -> str:
        return validate_deposit_slug(value)


class ArtifactLimitSettings(BaseModel):
    """Byte and archive-expansion limits for artifact workflows."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    source_bytes: int = Field(default=4 * 1024 * 1024 * 1024, gt=0)
    pdf_bytes: int = Field(default=1024 * 1024 * 1024, gt=0)
    html_bytes: int = Field(default=128 * 1024 * 1024, gt=0)
    expanded_source_bytes: int = Field(default=4 * 1024 * 1024 * 1024, gt=0)
    archive_entries: int = Field(default=100_000, gt=0)


class AcquisitionSettings(BaseModel):
    """Configured storage names and bounded acquisition policy."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    staging_root: str = Field(min_length=1)
    catalogs: tuple[CatalogSettings, ...]
    local_inboxes: tuple[LocalInboxSettings, ...]
    lock_timeout_seconds: float = Field(default=60.0, gt=0)
    limits: ArtifactLimitSettings

    @model_validator(mode="after")
    def _unique_logical_names(self) -> Self:
        names = [inbox.name.casefold() for inbox in self.local_inboxes]
        if not names:
            raise ValueError("acquisition settings require at least one local inbox")
        if len(names) != len(set(names)):
            raise ValueError("local inbox names must be unique")
        return self


class DiscoverySettings(BaseModel):
    """Composition settings for the discovery application."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    version: Literal[2]
    default_sources: tuple[str, ...]
    metadata_fallback_sources: tuple[str, ...]
    providers: dict[str, ProviderHttpSettings]
    acquisition: AcquisitionSettings

    @classmethod
    def load(cls, path: str | Path | None = None) -> "DiscoverySettings":
        source = Path(path) if path else files("procurement").joinpath("configs/defaults.json")
        try:
            payload = json.loads(source.read_text(encoding="utf-8"))
            return cls.model_validate(payload)
        except (OSError, ValueError) as exc:
            raise ConfigurationError(f"invalid discovery settings at {source}: {exc}") from exc


class RuntimeSecrets(BaseModel):
    """Credentials and contact values read from the process environment."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    contact_email: str | None = None
    openalex_api_key: SecretStr | None = Field(default=None, repr=False)
    semantic_scholar_api_key: SecretStr | None = Field(default=None, repr=False)

    @classmethod
    def from_environment(cls) -> "RuntimeSecrets":
        return cls(
            contact_email=os.environ.get("CODEX_SCHOLAR_MAILTO") or None,
            openalex_api_key=os.environ.get("OPENALEX_API_KEY") or None,
            semantic_scholar_api_key=os.environ.get("SEMANTIC_SCHOLAR_API_KEY") or None,
        )

    def user_agent(self, product: str = "codex-scientiae-procurement/0.1") -> str:
        if self.contact_email:
            return f"{product} (mailto:{self.contact_email})"
        return product
