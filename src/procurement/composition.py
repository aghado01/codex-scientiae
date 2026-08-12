"""Default procurement application composition."""

from __future__ import annotations

import os
from pathlib import Path

from jsonl_engine.paths import find_repository_root
from procurement.application import ProcurementApplication
from procurement.configuration import DiscoverySettings, RuntimeSecrets, load_settings
from procurement.errors import ConfigurationError
from procurement.operations.acquisition import AcquisitionService
from procurement.operations.catalogs import ArticleCatalogService
from procurement.operations.discovery import DiscoveryService
from procurement.operations.local_import import LocalImportService
from procurement.operations.materialization import SourceMaterializationService
from procurement.operations.metadata import MetadataService
from procurement.providers import (
    ProviderFactoryCatalog,
    get_builtin_provider_factory_catalog,
)
from procurement.providers.base import Capability, ProviderRole
from procurement.source.archive import ArchiveLimits
from procurement.storage.acquisitions import AcquisitionStore
from procurement.storage.catalogs import ArticleCatalogRoots
from procurement.storage.source_deposits import SourceDepositStore
from procurement.transport.http import HttpClient, RequestPolicy


def build_application(
    settings: DiscoverySettings | None = None,
    secrets: RuntimeSecrets | None = None,
    http: HttpClient | None = None,
    workspace_root: str | Path | None = None,
    provider_factories: ProviderFactoryCatalog | None = None,
) -> ProcurementApplication:
    """Construct the configured provider catalog and application services."""

    settings = settings or load_settings()
    factories = (
        get_builtin_provider_factory_catalog()
        if provider_factories is None
        else provider_factories
    )
    _validate_composition_settings(settings, factories)
    root = _resolve_workspace_root(workspace_root)
    staging_root = _resolve_configured_directory(
        root,
        settings.acquisition.staging_root,
        label="acquisition staging root",
    )
    catalog_roots = {
        catalog.name: str(
            _resolve_configured_directory(
                root,
                catalog.path,
                label=f"catalog {catalog.name!r}",
            )
        )
        for catalog in settings.acquisition.catalogs
    }
    local_inbox_roots = {
        inbox.name: str(
            _resolve_configured_directory(
                root,
                inbox.path,
                label=f"local inbox {inbox.name!r}",
            )
        )
        for inbox in settings.acquisition.local_inboxes
    }
    secrets = secrets or RuntimeSecrets.from_environment()
    http = http or HttpClient()

    catalog = factories.build(
        settings.providers,
        http=http,
        secrets=secrets,
        artifact_limits=settings.acquisition.limits,
    )
    metadata = MetadataService(catalog, settings.metadata_fallback_sources)
    policies = {}
    for binding in catalog.bindings(capability=Capability.PLAN_ARTIFACT):
        provider_settings = settings.providers.get(binding.name)
        if provider_settings is not None:
            policies[binding.name] = RequestPolicy(
                min_interval_seconds=provider_settings.min_interval_seconds,
                timeout_seconds=provider_settings.timeout_seconds,
                max_attempts=provider_settings.max_attempts,
            )
    article_catalog_roots = ArticleCatalogRoots(catalog_roots)
    catalog_service = ArticleCatalogService(article_catalog_roots)
    acquisition_store = AcquisitionStore(
        staging_root,
        lock_timeout=settings.acquisition.lock_timeout_seconds,
    )
    acquisition_service = AcquisitionService(
        catalog,
        http,
        acquisition_store,
        provider_policies=policies,
        user_agent=secrets.user_agent(),
        maximum_expanded_source_bytes=settings.acquisition.limits.expanded_source_bytes,
    )
    local_import_service = LocalImportService(
        local_inbox_roots,
        acquisition_store,
        settings.acquisition.limits,
    )
    source_store = SourceDepositStore(
        article_catalog_roots,
        lock_timeout=settings.acquisition.lock_timeout_seconds,
    )
    materialization_service = SourceMaterializationService(
        metadata,
        acquisition_store,
        source_store,
        archive_limits=ArchiveLimits(
            max_archive_bytes=settings.acquisition.limits.source_bytes,
            max_gzip_payload_bytes=settings.acquisition.limits.expanded_source_bytes,
            max_extracted_bytes=settings.acquisition.limits.expanded_source_bytes,
            max_member_bytes=settings.acquisition.limits.expanded_source_bytes,
            max_entries=settings.acquisition.limits.archive_entries,
        ),
        lock_timeout=settings.acquisition.lock_timeout_seconds,
    )
    return ProcurementApplication(
        providers=catalog,
        discovery=DiscoveryService(catalog, settings.default_sources),
        metadata=metadata,
        http=http,
        acquisition=acquisition_service,
        local_import=local_import_service,
        catalogs=catalog_service,
        materialization=materialization_service,
    )


def _validate_composition_settings(
    settings: DiscoverySettings,
    factories: ProviderFactoryCatalog,
) -> None:
    """Fail before runtime allocation when composition data cannot form the application."""

    configured = set(settings.providers)
    noncanonical = sorted(
        name for name in configured if not name or name != name.casefold()
    )
    if noncanonical:
        raise ConfigurationError(
            "provider configuration keys must be canonical lowercase names: "
            + ", ".join(noncanonical)
        )
    try:
        factories.validate_settings(settings.providers)
    except ValueError as exc:
        raise ConfigurationError(str(exc)) from exc

    declared = {definition.name: definition for definition in factories.definitions()}

    defaults = _canonical_provider_sequence(settings.default_sources, label="default_sources")
    if not defaults:
        raise ConfigurationError("default_sources must not be empty")
    if len(defaults) != len(set(defaults)):
        raise ConfigurationError("default_sources must not contain duplicates")
    unknown_defaults = set(defaults).difference(declared)
    if unknown_defaults:
        raise ConfigurationError(
            "default_sources contain unknown providers: "
            + ", ".join(sorted(unknown_defaults))
        )
    invalid_defaults = {
        name
        for name in defaults
        if Capability.SEARCH not in declared[name].capabilities
    }
    if invalid_defaults:
        raise ConfigurationError(
            "default_sources contain non-search providers: "
            + ", ".join(sorted(invalid_defaults))
        )

    fallbacks = _canonical_provider_sequence(
        settings.metadata_fallback_sources,
        label="metadata_fallback_sources",
    )
    if not fallbacks:
        raise ConfigurationError("metadata_fallback_sources must not be empty")
    if len(fallbacks) != len(set(fallbacks)):
        raise ConfigurationError("metadata_fallback_sources must not contain duplicates")
    unknown_fallbacks = set(fallbacks).difference(declared)
    if unknown_fallbacks:
        raise ConfigurationError(
            "metadata_fallback_sources contain unknown providers: "
            + ", ".join(sorted(unknown_fallbacks))
        )
    invalid_fallbacks = {
        name
        for name in fallbacks
        if ProviderRole.METADATA_AGGREGATOR not in declared[name].roles
    }
    if invalid_fallbacks:
        raise ConfigurationError(
            "metadata fallbacks must be metadata aggregators: "
            + ", ".join(sorted(invalid_fallbacks))
        )

    catalogs = [catalog.name.casefold() for catalog in settings.acquisition.catalogs]
    if not catalogs:
        raise ConfigurationError("acquisition settings require at least one catalog")
    if len(catalogs) != len(set(catalogs)):
        raise ConfigurationError("acquisition catalog names must be unique")

    inboxes = [inbox.name.casefold() for inbox in settings.acquisition.local_inboxes]
    if not inboxes:
        raise ConfigurationError("acquisition settings require at least one local inbox")
    if len(inboxes) != len(set(inboxes)):
        raise ConfigurationError("acquisition local inbox names must be unique")


def _canonical_provider_sequence(values: tuple[str, ...], *, label: str) -> tuple[str, ...]:
    """Validate ordered provider names without silently normalizing configuration."""

    invalid = [name for name in values if not name or name != name.casefold()]
    if invalid:
        raise ConfigurationError(
            f"{label} must contain canonical lowercase provider names: "
            + ", ".join(repr(name) for name in invalid)
        )
    return values


def _resolve_workspace_root(value: str | Path | None) -> Path:
    """Resolve one physical workspace root before allocating runtime dependencies."""

    configured = value if value is not None else os.environ.get("CODEX_SCIENTIAE_ROOT")
    requested = Path(configured) if configured is not None else Path(find_repository_root())
    requested = requested.absolute()
    if not requested.is_dir():
        raise ConfigurationError(f"procurement workspace root is not a directory: '{requested}'")
    resolved = requested.resolve(strict=True)
    if os.path.normcase(str(requested)) != os.path.normcase(str(resolved)):
        raise ConfigurationError(
            f"procurement workspace root must not traverse a link: '{requested}'"
        )
    return resolved


def _resolve_configured_directory(root: Path, value: str, *, label: str) -> Path:
    """Resolve one configured relative directory and confine it to the workspace."""

    relative = Path(value)
    if relative.is_absolute() or "\\" in value or not value.strip():
        raise ConfigurationError(f"{label} must be a non-empty relative path: {value!r}")
    lexical = (root / relative).absolute()
    try:
        resolved = lexical.resolve(strict=True)
        resolved.relative_to(root)
    except (OSError, ValueError) as exc:
        raise ConfigurationError(f"{label} escapes or is missing from the workspace: {value!r}") from exc
    if not resolved.is_dir() or os.path.normcase(str(lexical)) != os.path.normcase(str(resolved)):
        raise ConfigurationError(f"{label} must be a physical workspace directory: {value!r}")
    info = resolved.lstat()
    if getattr(info, "st_file_attributes", 0) & 0x400:
        raise ConfigurationError(f"{label} must not be a reparse point: {value!r}")
    return resolved
