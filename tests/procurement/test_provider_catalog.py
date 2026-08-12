"""Provider descriptor and application catalog contracts."""

from __future__ import annotations

import unittest

from procurement.errors import UnsupportedCapabilityError
from procurement.providers import (
    ProviderBuildContext,
    ProviderFactory,
    ProviderFactoryCatalog,
)
from procurement.providers.base import (
    Capability,
    ProviderCategory,
    ProviderDefinition,
    ProviderRole,
)
from procurement.providers.catalog import ProviderBinding, ProviderCatalog
from procurement.settings import (
    ArtifactLimitSettings,
    ProviderHttpSettings,
    RuntimeSecrets,
)


class SearchAdapter:
    descriptor = ProviderDefinition(
        name="search",
        category=ProviderCategory.SERVICE,
        capabilities=frozenset({Capability.SEARCH}),
        search_constraints=frozenset({"filters"}),
    )
    name = descriptor.name
    search_constraints = descriptor.search_constraints

    async def search(self, request: object) -> object:
        return request


class AggregatorAdapter:
    descriptor = ProviderDefinition(
        name="aggregator",
        category=ProviderCategory.AGGREGATOR,
        capabilities=frozenset({Capability.METADATA}),
        roles=frozenset({ProviderRole.METADATA_AGGREGATOR}),
    )
    name = descriptor.name
    search_constraints = descriptor.search_constraints

    async def get_metadata(self, identifier: str) -> str:
        return identifier


class ConfiguredSearchAdapter(SearchAdapter):
    def __init__(
        self,
        http: object,
        settings: ProviderHttpSettings,
        secrets: RuntimeSecrets,
    ) -> None:
        self.http = http
        self.settings = settings
        self.secrets = secrets


class TestProviderDefinition(unittest.TestCase):
    def test_category_requires_its_defining_roles(self) -> None:
        with self.assertRaisesRegex(ValueError, "requires roles: metadata-aggregator"):
            ProviderDefinition(
                name="invalid",
                category=ProviderCategory.AGGREGATOR,
                capabilities=frozenset({Capability.METADATA}),
            )

    def test_search_constraints_require_search_capability(self) -> None:
        with self.assertRaisesRegex(ValueError, "without search capability"):
            ProviderDefinition(
                name="invalid",
                category=ProviderCategory.SERVICE,
                capabilities=frozenset(),
                search_constraints=frozenset({"filters"}),
            )

    def test_primary_category_rejects_conflicting_roles(self) -> None:
        with self.assertRaisesRegex(ValueError, "conflicts with roles: metadata-aggregator"):
            ProviderDefinition(
                name="invalid",
                category=ProviderCategory.REPOSITORY,
                capabilities=frozenset({Capability.METADATA}),
                roles=frozenset(
                    {
                        ProviderRole.ARTIFACT_ORIGIN,
                        ProviderRole.ARTIFACT_ACCESS,
                        ProviderRole.METADATA_AUTHORITY,
                        ProviderRole.METADATA_AGGREGATOR,
                    }
                ),
            )


class TestProviderCatalog(unittest.TestCase):
    def test_binding_uses_the_adapter_descriptor(self) -> None:
        binding = ProviderBinding(SearchAdapter())

        self.assertIs(SearchAdapter.descriptor, binding.descriptor)
        self.assertEqual(frozenset({Capability.SEARCH}), binding.capabilities)
        self.assertEqual(frozenset({"filters"}), binding.search_constraints)

    def test_catalog_selects_by_capability_role_and_category(self) -> None:
        catalog = ProviderCatalog(
            [ProviderBinding(SearchAdapter()), ProviderBinding(AggregatorAdapter())]
        )

        self.assertEqual(("search",), catalog.names(Capability.SEARCH))
        self.assertEqual(
            ("aggregator",),
            catalog.names(role=ProviderRole.METADATA_AGGREGATOR),
        )
        self.assertEqual(
            ("aggregator",),
            catalog.names(category=ProviderCategory.AGGREGATOR),
        )
        with self.assertRaises(UnsupportedCapabilityError):
            catalog.get("search", Capability.METADATA)

    def test_public_descriptors_include_primary_category(self) -> None:
        catalog = ProviderCatalog(
            [ProviderBinding(SearchAdapter()), ProviderBinding(AggregatorAdapter())]
        )

        public = {item.name: item for item in catalog.describe()}
        self.assertEqual("service", public["search"].category)
        self.assertEqual("aggregator", public["aggregator"].category)
        self.assertEqual(("metadata-aggregator",), public["aggregator"].roles)

    def test_binding_rejects_adapter_descriptor_drift(self) -> None:
        class DriftedAdapter(SearchAdapter):
            name = "different"

        with self.assertRaisesRegex(ValueError, "must exactly match descriptor"):
            ProviderBinding(DriftedAdapter())

    def test_binding_rejects_an_explicit_descriptor_that_drifts_from_adapter(self) -> None:
        drifted = ProviderDefinition(
            name="search",
            category=ProviderCategory.SERVICE,
            capabilities=frozenset({Capability.SEARCH}),
        )

        with self.assertRaisesRegex(ValueError, "descriptor differs"):
            ProviderBinding(SearchAdapter(), drifted)


class TestProviderFactoryCatalog(unittest.TestCase):
    def setUp(self) -> None:
        self.http_settings = ProviderHttpSettings(
            base_url="https://example.test/api",
            min_interval_seconds=1.0,
            timeout_seconds=10.0,
        )
        self.secrets = RuntimeSecrets()
        self.limits = ArtifactLimitSettings()

    def test_catalog_builds_configured_and_declaration_only_adapters_in_order(self) -> None:
        factories = ProviderFactoryCatalog(
            (
                ProviderFactory.configured(ConfiguredSearchAdapter),
                ProviderFactory.declaration_only(AggregatorAdapter),
            )
        )
        http = object()

        catalog = factories.build(
            {"search": self.http_settings},
            http=http,  # type: ignore[arg-type]
            secrets=self.secrets,
            artifact_limits=self.limits,
        )

        self.assertEqual(("search", "aggregator"), catalog.names())
        search = catalog.get("search", Capability.SEARCH)
        self.assertIs(http, search.http)
        self.assertIs(self.http_settings, search.settings)

    def test_extended_returns_a_new_catalog_without_mutating_the_base(self) -> None:
        base = ProviderFactoryCatalog(
            (ProviderFactory.configured(ConfiguredSearchAdapter),)
        )

        extended = base.extended(ProviderFactory.declaration_only(AggregatorAdapter))

        self.assertEqual(("search",), base.names())
        self.assertEqual(("search", "aggregator"), extended.names())
        self.assertEqual(("search",), extended.names(requires_settings=True))
        self.assertEqual(("aggregator",), extended.names(requires_settings=False))

    def test_duplicate_factory_names_are_rejected(self) -> None:
        factory = ProviderFactory.configured(ConfiguredSearchAdapter)

        with self.assertRaisesRegex(ValueError, "already declared: search"):
            ProviderFactoryCatalog((factory, factory))

    def test_factory_rejects_wrong_adapter_type_from_custom_constructor(self) -> None:
        factory = ProviderFactory(
            adapter_type=ConfiguredSearchAdapter,
            constructor=lambda _context: AggregatorAdapter(),
            requires_settings=True,
        )
        context = ProviderBuildContext(
            http=object(),  # type: ignore[arg-type]
            settings=self.http_settings,
            secrets=self.secrets,
            artifact_limits=self.limits,
        )

        with self.assertRaisesRegex(ValueError, "expected 'ConfiguredSearchAdapter'"):
            factory.bind(context)

    def test_factory_owned_settings_validator_runs_during_preflight(self) -> None:
        def reject(settings: ProviderHttpSettings) -> None:
            raise ValueError(f"unsupported endpoint: {settings.base_url}")

        factories = ProviderFactoryCatalog(
            (
                ProviderFactory.configured(
                    ConfiguredSearchAdapter,
                    settings_validator=reject,
                ),
            )
        )

        with self.assertRaisesRegex(ValueError, "unsupported endpoint"):
            factories.validate_settings({"search": self.http_settings})


if __name__ == "__main__":
    unittest.main()
