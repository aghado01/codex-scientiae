"""Default procurement application composition."""

from __future__ import annotations

from dataclasses import dataclass

from procurement.errors import ConfigurationError
from procurement.http import HttpClient
from procurement.providers import ArxivProvider, OpenAlexProvider, SemanticScholarProvider, ZenodoProvider
from procurement.providers.base import Capability
from procurement.registry import ProviderBinding, ProviderRegistry
from procurement.services import DiscoveryService
from procurement.settings import DiscoverySettings, RuntimeSecrets


@dataclass(slots=True)
class ProcurementApplication:
    """Owned runtime dependencies and application services."""

    discovery: DiscoveryService
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
    secrets = secrets or RuntimeSecrets.from_environment()
    http = http or HttpClient()

    missing = {"openalex", "semanticscholar", "arxiv", "zenodo"}.difference(settings.providers)
    if missing:
        raise ConfigurationError(f"discovery settings omit providers: {', '.join(sorted(missing))}")

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
                    }
                ),
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
                    }
                ),
            ),
            ProviderBinding(arxiv, frozenset({Capability.SEARCH, Capability.GET_WORK})),
            ProviderBinding(zenodo, frozenset({Capability.SEARCH, Capability.GET_WORK})),
        ]
    )
    return ProcurementApplication(
        discovery=DiscoveryService(registry, settings.default_sources),
        http=http,
    )
