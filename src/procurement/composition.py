"""Default procurement application composition."""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

from jsonl_engine.paths import find_repository_root
from procurement.archive import ArchiveLimits
from procurement.errors import ConfigurationError
from procurement.http import HttpClient, RequestPolicy
from procurement.providers import ArxivProvider, OpenAlexProvider, SemanticScholarProvider, ZenodoProvider
from procurement.providers.base import Capability, ProviderRole
from procurement.registry import ProviderBinding, ProviderRegistry
from procurement.services import (
    AcquisitionService,
    ArticleCatalogService,
    DiscoveryService,
    LocalImportService,
    MetadataService,
    SourceMaterializationService,
)
from procurement.settings import DiscoverySettings, RuntimeSecrets
from procurement.staging import AcquisitionStore
from procurement.source import SourceDepositStore


@dataclass(slots=True)
class ProcurementApplication:
    """Owned runtime dependencies and application services."""

    discovery: DiscoveryService
    metadata: MetadataService
    http: HttpClient
    acquisition: AcquisitionService | None = None
    local_import: LocalImportService | None = None
    catalogs: ArticleCatalogService | None = None
    materialization: SourceMaterializationService | None = None

    async def close(self) -> None:
        await self.http.close()

    async def __aenter__(self) -> "ProcurementApplication":
        return self

    async def __aexit__(self, exc_type: object, exc: object, traceback: object) -> None:
        await self.close()


def build_application(
    settings: DiscoverySettings | None = None,
    secrets: RuntimeSecrets | None = None,
    http: HttpClient | None = None,
    workspace_root: str | Path | None = None,
) -> ProcurementApplication:
    """Construct the default provider registry and discovery service."""

    settings = settings or DiscoverySettings.load()
    _validate_composition_settings(settings)
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

    openalex = OpenAlexProvider(http, settings.providers["openalex"], secrets)
    semantic_scholar = SemanticScholarProvider(http, settings.providers["semanticscholar"], secrets)
    arxiv = ArxivProvider(
        http,
        settings.providers["arxiv"],
        secrets,
        settings.acquisition.limits,
    )
    zenodo = ZenodoProvider(
        http,
        settings.providers["zenodo"],
        secrets,
        settings.acquisition.limits,
    )

    registry = ProviderRegistry(
        [
            ProviderBinding(
                openalex,
                frozenset(
                    {
                        Capability.SEARCH,
                        Capability.GET_WORK,
                        Capability.CITATIONS,
                        Capability.REFERENCES,
                        Capability.RESOLVE,
                        Capability.METADATA,
                    }
                ),
                frozenset({ProviderRole.METADATA_AGGREGATOR}),
            ),
            ProviderBinding(
                semantic_scholar,
                frozenset(
                    {
                        Capability.SEARCH,
                        Capability.GET_WORK,
                        Capability.CITATIONS,
                        Capability.REFERENCES,
                        Capability.RECOMMENDATIONS,
                        Capability.RESOLVE,
                        Capability.METADATA,
                    }
                ),
                frozenset({ProviderRole.METADATA_AGGREGATOR}),
            ),
            ProviderBinding(
                arxiv,
                frozenset(
                    {
                        Capability.SEARCH,
                        Capability.GET_WORK,
                        Capability.METADATA,
                        Capability.PLAN_ARTIFACT,
                    }
                ),
                frozenset(
                    {
                        ProviderRole.ARTIFACT_ORIGIN,
                        ProviderRole.ARTIFACT_ACCESS,
                        ProviderRole.METADATA_AUTHORITY,
                    }
                ),
            ),
            ProviderBinding(
                zenodo,
                frozenset(
                    {
                        Capability.SEARCH,
                        Capability.GET_WORK,
                        Capability.METADATA,
                        Capability.PLAN_ARTIFACT,
                    }
                ),
                frozenset(
                    {
                        ProviderRole.ARTIFACT_ORIGIN,
                        ProviderRole.ARTIFACT_ACCESS,
                        ProviderRole.METADATA_AUTHORITY,
                    }
                ),
            ),
            ProviderBinding(
                _DeclaredProvider("scihub"),
                frozenset(),
                frozenset({ProviderRole.ARTIFACT_ACCESS}),
            ),
        ]
    )
    metadata = MetadataService(registry, settings.metadata_fallback_sources)
    policies = {
        name: RequestPolicy(
            min_interval_seconds=settings.providers[name].min_interval_seconds,
            timeout_seconds=settings.providers[name].timeout_seconds,
            max_attempts=settings.providers[name].max_attempts,
        )
        for name in ("arxiv", "zenodo")
    }
    catalog_service = ArticleCatalogService(catalog_roots)
    acquisition_store = AcquisitionStore(
        staging_root,
        lock_timeout=settings.acquisition.lock_timeout_seconds,
    )
    acquisition_service = AcquisitionService(
        registry,
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
        catalog_service,
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
        discovery=DiscoveryService(registry, settings.default_sources),
        metadata=metadata,
        http=http,
        acquisition=acquisition_service,
        local_import=local_import_service,
        catalogs=catalog_service,
        materialization=materialization_service,
    )


@dataclass(frozen=True, slots=True)
class _DeclaredProvider:
    """Provider identity with no callable implementation in this slice."""

    name: str


def _validate_composition_settings(settings: DiscoverySettings) -> None:
    """Fail before runtime allocation when composition data cannot form the application."""

    required = {"openalex", "semanticscholar", "arxiv", "zenodo"}
    supported = required | {"scihub"}
    groups = settings.provider_groups
    declared_groups = {
        name: group
        for group, names in (
            ("aggregator", groups.aggregators),
            ("repository", groups.repositories),
            ("access-source", groups.access_sources),
        )
        for name in names
    }
    missing_declarations = supported.difference(declared_groups)
    if missing_declarations:
        raise ConfigurationError(
            "provider groups omit declarations: "
            + ", ".join(sorted(missing_declarations))
        )
    unsupported_declarations = set(declared_groups).difference(supported)
    if unsupported_declarations:
        raise ConfigurationError(
            "provider groups name providers without implementations: "
            + ", ".join(sorted(unsupported_declarations))
        )
    expected_groups = {
        "openalex": "aggregator",
        "semanticscholar": "aggregator",
        "arxiv": "repository",
        "zenodo": "repository",
        "scihub": "access-source",
    }
    misclassified = [
        f"{name}={declared_groups[name]}"
        for name, expected in expected_groups.items()
        if declared_groups[name] != expected
    ]
    if misclassified:
        raise ConfigurationError(
            "provider groups conflict with implemented provider roles: "
            + ", ".join(misclassified)
        )

    missing = required.difference(settings.providers)
    if missing:
        raise ConfigurationError(
            f"discovery settings omit providers: {', '.join(sorted(missing))}"
        )

    defaults = tuple(name.casefold() for name in settings.default_sources)
    if not defaults:
        raise ConfigurationError("default_sources must not be empty")
    if len(defaults) != len(set(defaults)):
        raise ConfigurationError("default_sources must not contain duplicates")
    unknown_defaults = set(defaults).difference(groups.search_sources)
    if unknown_defaults:
        raise ConfigurationError(
            "default_sources contain non-search providers: "
            + ", ".join(sorted(unknown_defaults))
        )

    fallbacks = tuple(name.casefold() for name in settings.metadata_fallback_sources)
    if not fallbacks:
        raise ConfigurationError("metadata_fallback_sources must not be empty")
    if len(fallbacks) != len(set(fallbacks)):
        raise ConfigurationError("metadata_fallback_sources must not contain duplicates")
    invalid_fallbacks = set(fallbacks).difference(groups.aggregators)
    if invalid_fallbacks:
        raise ConfigurationError(
            "metadata fallbacks must be metadata aggregators: "
            + ", ".join(sorted(invalid_fallbacks))
        )

    semantic = settings.providers.get("semanticscholar")
    if semantic is None or not semantic.secondary_base_url:
        raise ConfigurationError(
            "Semantic Scholar settings require a recommendations secondary_base_url"
        )

    arxiv = settings.providers.get("arxiv")
    if arxiv is None or not arxiv.artifact_base_url or not arxiv.secondary_artifact_base_url:
        raise ConfigurationError(
            "arXiv settings require primary and secondary artifact endpoints"
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
