"""Load validated procurement configuration data."""

from __future__ import annotations

import json
from importlib.resources import files
from pathlib import Path

from procurement.configuration.models import DiscoverySettings
from procurement.errors import ConfigurationError


def load_settings(path: str | Path | None = None) -> DiscoverySettings:
    """Load discovery settings from a path or the packaged defaults."""

    source = Path(path) if path is not None else files("procurement").joinpath(
        "configs/defaults.json"
    )
    try:
        payload = json.loads(source.read_text(encoding="utf-8"))
        return DiscoverySettings.model_validate(payload)
    except (OSError, ValueError) as exc:
        raise ConfigurationError(f"invalid discovery settings at {source}: {exc}") from exc


__all__ = ["load_settings"]
