"""Composition-time procurement configuration contracts."""

from __future__ import annotations

import asyncio
import copy
import unittest
from pathlib import Path

from pydantic import ValidationError

from procurement.composition import build_application
from procurement.configuration import (
    CatalogSettings,
    DiscoverySettings,
    ProviderHttpSettings,
    RuntimeSecrets,
    load_settings,
)
from procurement.errors import ConfigurationError
from procurement.domain.discovery import SearchPage, SearchRequest
from procurement.providers import (
    ArxivProvider,
    OpenAlexProvider,
    ProviderFactory,
    SciHubProvider,
    SemanticScholarProvider,
    ZenodoProvider,
    get_builtin_provider_factory_catalog,
)
from procurement.providers.base import (
    Capability,
    ProviderCategory,
    ProviderDefinition,
    ProviderRole,
)


class BioRxivProvider:
    descriptor = ProviderDefinition(
        name="biorxiv",
        category=ProviderCategory.REPOSITORY,
        capabilities=frozenset({Capability.SEARCH}),
        roles=frozenset(
            {
                ProviderRole.ARTIFACT_ORIGIN,
                ProviderRole.ARTIFACT_ACCESS,
                ProviderRole.METADATA_AUTHORITY,
            }
        ),
    )
    name = descriptor.name
    search_constraints = descriptor.search_constraints

    def __init__(
        self,
        http: object,
        settings: ProviderHttpSettings,
        secrets: RuntimeSecrets,
    ) -> None:
        self.http = http
        self.settings = settings
        self.secrets = secrets

    async def search(self, request: SearchRequest) -> SearchPage:
        return SearchPage(provider=self.name, start=request.start)


def changed_settings(**changes: object) -> DiscoverySettings:
    payload = copy.deepcopy(load_settings().model_dump())
    payload.update(changes)
    return DiscoverySettings.model_validate(payload)


class TestCompositionValidation(unittest.TestCase):
    def test_catalog_names_are_portable_leaves(self) -> None:
        for name in ("../catalog", "CON", "catalog."):
            with self.subTest(name=name), self.assertRaises(ValidationError):
                CatalogSettings(name=name, path="supellex")

    def test_builtin_factory_catalog_separates_configured_and_declared_adapters(self) -> None:
        factories = get_builtin_provider_factory_catalog()

        self.assertEqual(
            ("openalex", "semanticscholar", "arxiv", "zenodo", "scihub"),
            factories.names(),
        )
        self.assertEqual(
            ("openalex", "semanticscholar", "arxiv", "zenodo"),
            factories.names(requires_settings=True),
        )
        self.assertEqual(("scihub",), factories.names(requires_settings=False))

    def test_adapters_declare_aggregators_repositories_and_access_sources(self) -> None:
        categories = {
            provider.descriptor.name: provider.descriptor.category
            for provider in (
                OpenAlexProvider,
                SemanticScholarProvider,
                ArxivProvider,
                ZenodoProvider,
                SciHubProvider,
            )
        }

        self.assertEqual(ProviderCategory.AGGREGATOR, categories["openalex"])
        self.assertEqual(ProviderCategory.AGGREGATOR, categories["semanticscholar"])
        self.assertEqual(ProviderCategory.REPOSITORY, categories["arxiv"])
        self.assertEqual(ProviderCategory.REPOSITORY, categories["zenodo"])
        self.assertEqual(ProviderCategory.ACCESS_SOURCE, categories["scihub"])

    def test_default_application_catalog_is_composed_from_adapter_descriptors(self) -> None:
        root = Path(__file__).resolve().parents[2]
        application = build_application(workspace_root=root)
        try:
            descriptors = {
                item.name: item
                for item in application.providers.describe()
            }
            self.assertEqual(
                {
                    "openalex": "aggregator",
                    "semanticscholar": "aggregator",
                    "arxiv": "repository",
                    "zenodo": "repository",
                    "scihub": "access-source",
                },
                {name: item.category for name, item in descriptors.items()},
            )
            self.assertIn("plan_artifact", descriptors["arxiv"].capabilities)
            self.assertNotIn("plan_artifact", descriptors["scihub"].capabilities)
        finally:
            asyncio.run(application.close())

    def test_application_owns_configured_root_lifetime(self) -> None:
        root = Path(__file__).resolve().parents[2]
        application = build_application(workspace_root=root)
        descriptors = application.roots.descriptors()
        self.assertTrue(application.roots.is_open)
        self.assertEqual(3, len(descriptors))
        self.assertTrue(all(item.publication_root.is_active for item in descriptors))

        asyncio.run(application.close())
        asyncio.run(application.close())

        self.assertFalse(application.roots.is_open)
        self.assertTrue(all(not item.publication_root.is_active for item in descriptors))

    def test_factory_catalog_extension_adds_repository_without_composition_branch(self) -> None:
        payload = copy.deepcopy(load_settings().model_dump())
        payload["providers"]["biorxiv"] = {
            "base_url": "https://api.biorxiv.org",
            "min_interval_seconds": 1.0,
            "timeout_seconds": 30.0,
            "max_attempts": 3,
        }
        payload["default_sources"] = (*payload["default_sources"], "biorxiv")
        settings = DiscoverySettings.model_validate(payload)
        factories = get_builtin_provider_factory_catalog().extended(
            ProviderFactory.configured(BioRxivProvider)
        )
        root = Path(__file__).resolve().parents[2]

        application = build_application(
            settings=settings,
            workspace_root=root,
            provider_factories=factories,
        )
        try:
            binding = application.providers.binding("biorxiv")
            self.assertIsInstance(binding.provider, BioRxivProvider)
            self.assertEqual(ProviderCategory.REPOSITORY, binding.category)
            self.assertIn("biorxiv", application.discovery.providers)
            result = asyncio.run(
                application.discovery.search(
                    SearchRequest(query="preprint extension"),
                    source="biorxiv",
                )
            )
            self.assertEqual("biorxiv", result.source)
            self.assertEqual(("biorxiv",), tuple(item.provider for item in result.providers))
        finally:
            asyncio.run(application.close())

    def test_unknown_default_source_fails_before_runtime_construction(self) -> None:
        settings = changed_settings(default_sources=("openalex", "unknown"))

        with self.assertRaisesRegex(ConfigurationError, "unknown providers: unknown"):
            build_application(settings=settings)

    def test_non_aggregator_metadata_fallback_is_rejected(self) -> None:
        settings = changed_settings(metadata_fallback_sources=("arxiv",))

        with self.assertRaisesRegex(ConfigurationError, "must be metadata aggregators: arxiv"):
            build_application(settings=settings)

    def test_semantic_scholar_recommendation_endpoint_is_required(self) -> None:
        payload = copy.deepcopy(load_settings().model_dump())
        payload["providers"]["semanticscholar"]["secondary_base_url"] = None
        settings = DiscoverySettings.model_validate(payload)

        with self.assertRaisesRegex(ConfigurationError, "recommendations secondary_base_url"):
            build_application(settings=settings)

    def test_arxiv_artifact_endpoints_are_required(self) -> None:
        payload = copy.deepcopy(load_settings().model_dump())
        payload["providers"]["arxiv"]["secondary_artifact_base_url"] = None
        settings = DiscoverySettings.model_validate(payload)

        with self.assertRaisesRegex(ConfigurationError, "primary and secondary artifact endpoints"):
            build_application(settings=settings)

    def test_provider_configuration_keys_are_canonical(self) -> None:
        payload = copy.deepcopy(load_settings().model_dump())
        payload["providers"]["OpenAlex"] = payload["providers"].pop("openalex")
        settings = DiscoverySettings.model_validate(payload)

        with self.assertRaisesRegex(ConfigurationError, "canonical lowercase names: OpenAlex"):
            build_application(settings=settings)

    def test_legacy_provider_groups_are_not_configuration(self) -> None:
        payload = copy.deepcopy(load_settings().model_dump())
        payload["provider_groups"] = {
            "aggregators": ("openalex", "semanticscholar"),
            "repositories": ("arxiv", "zenodo"),
            "access_sources": ("scihub",),
        }

        with self.assertRaisesRegex(
            ValidationError,
            "Extra inputs are not permitted",
        ):
            DiscoverySettings.model_validate(payload)

    def test_legacy_config_version_is_rejected(self) -> None:
        payload = copy.deepcopy(load_settings().model_dump())
        payload["version"] = 1

        with self.assertRaisesRegex(ValidationError, "Input should be 2"):
            DiscoverySettings.model_validate(payload)
