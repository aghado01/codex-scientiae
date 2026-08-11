"""Validated non-secret settings and environment-derived credentials."""

from __future__ import annotations

import json
import os
from importlib.resources import files
from pathlib import Path

from pydantic import BaseModel, ConfigDict, Field, SecretStr

from procurement.errors import ConfigurationError


class ProviderHttpSettings(BaseModel):
    """HTTP endpoint and request policy for one provider."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    base_url: str
    secondary_base_url: str | None = None
    min_interval_seconds: float = Field(ge=0)
    timeout_seconds: float = Field(gt=0)
    max_attempts: int = Field(default=3, ge=1)


class DiscoverySettings(BaseModel):
    """Composition settings for the discovery application."""

    model_config = ConfigDict(extra="forbid", frozen=True)

    version: int = Field(ge=1)
    default_sources: tuple[str, ...]
    metadata_fallback_sources: tuple[str, ...]
    providers: dict[str, ProviderHttpSettings]

    @classmethod
    def load(cls, path: str | Path | None = None) -> "DiscoverySettings":
        source = Path(path) if path else files("procurement").joinpath("stores/discovery.json")
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
