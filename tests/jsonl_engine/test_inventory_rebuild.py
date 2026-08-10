"""Catalog-root inventory rebuild service and CLI verb."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import unittest

from jsonl_engine.inventory_rebuild import InventoryRebuildError, rebuild_inventory
from jsonl_engine.reader import JsonlStore

from jsonl_test_support import article as article_record


def _write_json(path: str, value) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as handle:
        json.dump(value, handle, ensure_ascii=False, separators=(",", ":"), allow_nan=False)
        handle.write("\n")


def _run_cli(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, "-m", "jsonl_engine", *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=120,
    )


class TestInventoryRebuild(unittest.TestCase):
    def test_rebuild_writes_sorted_inventory_rows(self):
        with tempfile.TemporaryDirectory() as catalog:
            paths = []
            for slug in ("b.0001v1", "a.0001v1"):
                article_path = os.path.join(catalog, slug, "article.json")
                _write_json(article_path, article_record(slug))
                paths.append(article_path)

            result = rebuild_inventory(catalog_dir=catalog, article_paths=paths)
            self.assertEqual(2, result.article_count)
            self.assertEqual(["a.0001v1", "b.0001v1"], result.slugs)
            self.assertTrue(os.path.isfile(result.inventory_path))

            records = list(JsonlStore(result.inventory_path))
            self.assertEqual("inventory", records[0]["kind"])
            rows = records[1:]
            self.assertEqual(["a.0001v1", "b.0001v1"], [row["slug"] for row in rows])

    def test_empty_article_list_publishes_empty_inventory(self):
        with tempfile.TemporaryDirectory() as catalog:
            result = rebuild_inventory(catalog_dir=catalog, article_paths=[])
            self.assertEqual(0, result.article_count)
            self.assertEqual([], result.slugs)
            self.assertTrue(os.path.isfile(result.inventory_path))

    def test_slug_must_match_direct_child_leaf(self):
        with tempfile.TemporaryDirectory() as catalog:
            article_path = os.path.join(catalog, "1105.4224v1", "article.json")
            _write_json(article_path, article_record("9999.0000v1"))
            with self.assertRaisesRegex(InventoryRebuildError, "does not match"):
                rebuild_inventory(catalog_dir=catalog, article_paths=[article_path])

    def test_nested_article_is_rejected(self):
        with tempfile.TemporaryDirectory() as catalog:
            article_path = os.path.join(catalog, "parent", "child", "article.json")
            _write_json(article_path, article_record("child"))
            with self.assertRaisesRegex(InventoryRebuildError, "direct child"):
                rebuild_inventory(catalog_dir=catalog, article_paths=[article_path])

    def test_cli_rebuild_inventory_framed(self):
        with tempfile.TemporaryDirectory() as catalog:
            slug = "1105.4224v1"
            article_path = os.path.join(catalog, slug, "article.json")
            _write_json(article_path, article_record(slug))
            paths_json = os.path.join(catalog, "article-paths.json")
            _write_json(paths_json, [article_path])

            proc = _run_cli(
                "--framed",
                "rebuild-inventory",
                "--catalog-dir",
                catalog,
                "--article-paths-json",
                paths_json,
            )
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            frame = json.loads(proc.stdout)
            self.assertEqual("value", frame["type"])
            self.assertEqual(1, frame["value"]["article_count"])
            self.assertEqual([slug], frame["value"]["slugs"])
            self.assertTrue(os.path.isfile(frame["value"]["inventory_path"]))


if __name__ == "__main__":
    unittest.main()
