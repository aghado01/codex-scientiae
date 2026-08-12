"""Named article-catalog service boundaries."""

from __future__ import annotations

import os
import tempfile
import unittest
from unittest import mock

from jsonl_engine.inventory_catalog import InventoryCatalogResult
from procurement.operations.catalogs import ArticleCatalogService
from procurement.storage.catalogs import (
    ArticleCatalogConfigurationError,
    ArticleCatalogRoots,
)


def _touch_article(catalog: str, slug: str) -> None:
    path = os.path.join(catalog, slug, "article.json")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb"):
        pass


class TestArticleCatalogService(unittest.TestCase):
    def test_inspect_and_rebuild_use_a_configured_name(self):
        with tempfile.TemporaryDirectory() as catalog:
            _touch_article(catalog, "b.0001v1")
            _touch_article(catalog, "a.0001v1")
            service = ArticleCatalogService(ArticleCatalogRoots({"Research": catalog}))

            self.assertEqual(
                os.path.abspath(catalog), service.resolve("RESEARCH").catalog_dir
            )
            snapshot = service.inspect("research")
            self.assertEqual("Research", snapshot.name)
            self.assertEqual(("a.0001v1", "b.0001v1"), snapshot.slugs)

            expected = InventoryCatalogResult(
                catalog, "inventory.jsonl", 2, list(snapshot.slugs)
            )
            with mock.patch(
                "procurement.operations.catalogs.build_inventory", return_value=expected
            ) as build:
                self.assertIs(expected, service.rebuild("RESEARCH", force=True))
            build.assert_called_once_with(catalog_dir=os.path.abspath(catalog), force=True)

            with self.assertRaisesRegex(ArticleCatalogConfigurationError, "unknown"):
                service.inspect("other")

    def test_rebuild_requires_explicit_force_for_an_existing_inventory(self):
        with tempfile.TemporaryDirectory() as catalog:
            service = ArticleCatalogService(ArticleCatalogRoots({"inventory": catalog}))
            service.rebuild("inventory")
            with self.assertRaisesRegex(ValueError, "force=True"):
                service.rebuild("inventory")
            self.assertEqual(0, service.rebuild("inventory", force=True).article_count)

    def test_configuration_rejects_case_colliding_names(self):
        with self.assertRaisesRegex(ArticleCatalogConfigurationError, "case collision"):
            ArticleCatalogRoots({"Corpus": "one", "corpus": "two"})


if __name__ == "__main__":
    unittest.main()
