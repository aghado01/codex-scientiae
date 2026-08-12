"""Built-in procurement provider factory declarations."""

from __future__ import annotations

from procurement.providers.arxiv import ArxivProvider
from procurement.providers.factory import ProviderFactory, ProviderFactoryCatalog
from procurement.providers.openalex import OpenAlexProvider
from procurement.providers.scihub import SciHubProvider
from procurement.providers.semanticscholar import SemanticScholarProvider
from procurement.providers.zenodo import ZenodoProvider
from procurement.configuration import ProviderHttpSettings


def _validate_semantic_scholar_settings(settings: ProviderHttpSettings) -> None:
    if not settings.secondary_base_url:
        raise ValueError(
            "Semantic Scholar settings require a recommendations secondary_base_url"
        )


def _validate_arxiv_settings(settings: ProviderHttpSettings) -> None:
    if not settings.artifact_base_url or not settings.secondary_artifact_base_url:
        raise ValueError("arXiv settings require primary and secondary artifact endpoints")


BUILTIN_PROVIDER_FACTORIES = ProviderFactoryCatalog(
    (
        ProviderFactory.configured(OpenAlexProvider),
        ProviderFactory.configured(
            SemanticScholarProvider,
            settings_validator=_validate_semantic_scholar_settings,
        ),
        ProviderFactory.configured(
            ArxivProvider,
            artifact_limits=True,
            settings_validator=_validate_arxiv_settings,
        ),
        ProviderFactory.configured(ZenodoProvider, artifact_limits=True),
        ProviderFactory.declaration_only(SciHubProvider),
    )
)


def get_builtin_provider_factory_catalog() -> ProviderFactoryCatalog:
    """Return the immutable built-in provider construction catalog."""

    return BUILTIN_PROVIDER_FACTORIES
