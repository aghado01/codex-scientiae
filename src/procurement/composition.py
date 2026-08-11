"""Default procurement application composition."""

from __future__ import annotations

from dataclasses import dataclass

from procurement.errors import ConfigurationError
from procurement.http import HttpClient
from procurement.providers import ArxivProvider, OpenAlexProvider, SemanticScholarProvider, ZenodoProvider
from procurement.providers.base import Capability, ProviderRole
from procurement.registry import ProviderBinding, ProviderRegistry
from procurement.services import DiscoveryService, MetadataService
from procurement.settings import DiscoverySettings, RuntimeSecrets


@dataclass(slots=True)
class ProcurementApplication:
    """Owned runtime dependencies and application services."""

    discovery: DiscoveryService
    metadata: MetadataService
    http: HttpClient

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
) -> ProcurementApplication:
    """Construct the default provider registry and discovery service."""

    settings = settings or DiscoverySettings.load()
    _validate_composition_settings(settings)
    secrets = secrets or RuntimeSecrets.from_environment()
    http = http or HttpClient()

    openalex = OpenAlexProvider(http, settings.providers["openalex"], secrets)
    semantic_scholar = SemanticScholarProvider(http, settings.providers["semanticscholar"], secrets)
    arxiv = ArxivProvider(http, settings.providers["arxiv"], secrets)
    zenodo = ZenodoProvider(http, settings.providers["zenodo"], secrets)

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
                frozenset({Capability.SEARCH, Capability.GET_WORK, Capability.METADATA}),
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
                frozenset({Capability.SEARCH, Capability.GET_WORK, Capability.METADATA}),
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
    return ProcurementApplication(
        discovery=DiscoveryService(registry, settings.default_sources),
        metadata=MetadataService(registry, settings.metadata_fallback_sources),
        http=http,
    )


@dataclass(frozen=True, slots=True)
class _DeclaredProvider:
    """Provider identity with no callable implementation in this slice."""

    name: str


def _validate_composition_settings(settings: DiscoverySettings) -> None:
    """Fail before runtime allocation when composition data cannot form the application."""

    required = {"openalex", "semanticscholar", "arxiv", "zenodo"}
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
    unknown_defaults = set(defaults).difference(required)
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
    invalid_fallbacks = set(fallbacks).difference({"openalex", "semanticscholar"})
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
