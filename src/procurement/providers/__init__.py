"""Procurement provider adapters and construction catalogs."""

from procurement.providers.arxiv import ArxivProvider
from procurement.providers.builtin import (
    BUILTIN_PROVIDER_FACTORIES,
    get_builtin_provider_factory_catalog,
)
from procurement.providers.factory import (
    ProviderBuildContext,
    ProviderFactory,
    ProviderFactoryCatalog,
)
from procurement.providers.openalex import OpenAlexProvider
from procurement.providers.scihub import SciHubProvider
from procurement.providers.semanticscholar import SemanticScholarProvider
from procurement.providers.zenodo import ZenodoProvider

__all__ = [
    "ArxivProvider",
    "BUILTIN_PROVIDER_FACTORIES",
    "OpenAlexProvider",
    "ProviderBuildContext",
    "ProviderFactory",
    "ProviderFactoryCatalog",
    "SciHubProvider",
    "SemanticScholarProvider",
    "ZenodoProvider",
    "get_builtin_provider_factory_catalog",
]
