"""Composition-time procurement configuration contracts."""

from __future__ import annotations

import copy
import unittest

from procurement.composition import build_application
from procurement.errors import ConfigurationError
from procurement.settings import DiscoverySettings


def changed_settings(**changes: object) -> DiscoverySettings:
    payload = copy.deepcopy(DiscoverySettings.load().model_dump())
    payload.update(changes)
    return DiscoverySettings.model_validate(payload)


class TestCompositionValidation(unittest.TestCase):
    def test_unknown_default_source_fails_before_runtime_construction(self) -> None:
        settings = changed_settings(default_sources=("openalex", "unknown"))

        with self.assertRaisesRegex(ConfigurationError, "non-search providers: unknown"):
            build_application(settings=settings)

    def test_non_aggregator_metadata_fallback_is_rejected(self) -> None:
        settings = changed_settings(metadata_fallback_sources=("arxiv",))

        with self.assertRaisesRegex(ConfigurationError, "must be metadata aggregators: arxiv"):
            build_application(settings=settings)

    def test_semantic_scholar_recommendation_endpoint_is_required(self) -> None:
        payload = copy.deepcopy(DiscoverySettings.load().model_dump())
        payload["providers"]["semanticscholar"]["secondary_base_url"] = None
        settings = DiscoverySettings.model_validate(payload)

        with self.assertRaisesRegex(ConfigurationError, "recommendations secondary_base_url"):
            build_application(settings=settings)

    def test_provider_configuration_keys_are_canonical(self) -> None:
        payload = copy.deepcopy(DiscoverySettings.load().model_dump())
        payload["providers"]["OpenAlex"] = payload["providers"].pop("openalex")
        settings = DiscoverySettings.model_validate(payload)

        with self.assertRaisesRegex(ConfigurationError, "omit providers: openalex"):
            build_application(settings=settings)
