"""Named article-catalog service boundaries."""

from __future__ import annotations

import os
import tempfile
import unittest
from unittest import mock

from jsonl_engine.inventory_catalog import InventoryCatalogError, InventoryCatalogResult
from procurement.operations.catalogs import ArticleCatalogService
from procurement.storage.catalogs import (
    ArticleCatalogConfigurationError,
    ArticleCatalogRoots,
)
from procurement.storage.roots import ProcurementRootCatalog


def _touch_article(catalog: str, slug: str) -> None:
    path = os.path.join(catalog, slug, "article.json")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb"):
        pass


def _roots(parent: str, catalog_name: str = "Research") -> ProcurementRootCatalog:
    staging = os.path.join(parent, "staging")
    catalog = os.path.join(parent, "catalog")
    inbox = os.path.join(parent, "inbox")
    for path in (staging, catalog, inbox):
        os.mkdir(path)
    return ProcurementRootCatalog(
        staging,
        article_catalogs={catalog_name: catalog},
        local_inboxes={"manual": inbox},
    ).open()


class TestArticleCatalogService(unittest.TestCase):
    def test_inspect_and_rebuild_use_a_configured_name(self):
        with tempfile.TemporaryDirectory() as parent:
            roots = _roots(parent)
            catalog = os.path.join(parent, "catalog")
            _touch_article(catalog, "b.0001v1")
            _touch_article(catalog, "a.0001v1")
            service = ArticleCatalogService(ArticleCatalogRoots(roots))

            try:
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
                build.assert_called_once_with(
                    catalog_dir=os.path.abspath(catalog),
                    force=True,
                    publication_root=service.resolve("Research").publication_root,
                )

                with self.assertRaisesRegex(ArticleCatalogConfigurationError, "unknown"):
                    service.inspect("other")
            finally:
                roots.close()

    def test_rebuild_requires_explicit_force_for_an_existing_inventory(self):
        with tempfile.TemporaryDirectory() as parent:
            roots = _roots(parent, "inventory")
            service = ArticleCatalogService(ArticleCatalogRoots(roots))
            try:
                service.rebuild("inventory")
                with self.assertRaisesRegex(ValueError, "force=True"):
                    service.rebuild("inventory")
                self.assertEqual(0, service.rebuild("inventory", force=True).article_count)
            finally:
                roots.close()

    @unittest.skipIf(os.name == "nt", "Windows retained roots block route replacement")
    def test_service_refuses_a_replacement_of_the_configured_catalog_generation(self):
        with tempfile.TemporaryDirectory() as parent:
            roots = _roots(parent)
            service = ArticleCatalogService(ArticleCatalogRoots(roots))
            catalog = os.path.join(parent, "catalog")
            retired = os.path.join(parent, "retired")
            os.rename(catalog, retired)
            os.mkdir(catalog)
            try:
                with self.assertRaisesRegex(InventoryCatalogError, "retained generation"):
                    service.inspect("Research")
                with self.assertRaisesRegex(InventoryCatalogError, "retained generation"):
                    service.rebuild("Research")
                self.assertEqual([], os.listdir(catalog))
                self.assertFalse(os.path.lexists(os.path.join(retired, "inventory.jsonl")))
            finally:
                roots.close()

    def test_loose_path_mappings_are_not_a_catalog_root_registry(self):
        with self.assertRaisesRegex(TypeError, "ProcurementRootCatalog"):
            ArticleCatalogRoots({"Corpus": "one"})  # type: ignore[arg-type]


if __name__ == "__main__":
    unittest.main()
