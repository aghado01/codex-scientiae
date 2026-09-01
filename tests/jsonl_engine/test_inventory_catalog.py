"""Catalog-root inventory build service and CLI verb."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from unittest import mock

import jsonl_engine.inventory_catalog as inventory_catalog
import jsonl_engine.publication as publication
from jsonl_engine.inventory_catalog import (
    MAX_ARTICLE_MANIFEST_BYTES,
    InventoryCatalogError,
    build_inventory,
    discover_article_paths,
    fold_inventory,
)
from jsonl_engine.kinds.inventory import InventoryRegistry
from jsonl_engine.kinds.registry import DuplicateEntry
from jsonl_engine.publication import PinnedPublicationRoot
from jsonl_engine.reader import JsonlStore
from jsonl_engine.sidecar import SCRATCH_ROOT_ENV

from jsonl_test_support import article as article_record
from tests.support.filesystem import directory_link


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


class TestInventoryCatalog(unittest.TestCase):
    def test_windows_route_compare_normalizes_drive_but_not_component_case(self):
        if os.name != "nt":
            self.skipTest("Windows final-path proof")
        self.assertTrue(
            publication._windows_paths_equal(
                r"c:\catalog-route\article",
                r"C:\catalog-route\article",
            )
        )
        self.assertFalse(
            publication._windows_paths_equal(
                r"C:\catalog-route\article",
                r"C:\catalog-route\ARTICLE",
            )
        )

    def test_pinned_root_rejects_a_unicode_casefold_ancestor_junction(self):
        if os.name != "nt":
            self.skipTest("Windows final-path proof")
        with tempfile.TemporaryDirectory() as parent:
            # Python Unicode casefold equates these names; exact Windows ordinal comparison does not.
            target = os.path.join(parent, "ss")
            catalog = os.path.join(target, "catalog")
            junction = os.path.join(parent, "ß")
            os.makedirs(catalog)
            with directory_link(junction, target):
                publication_root = PinnedPublicationRoot(os.path.join(junction, "catalog"))
                with self.assertRaisesRegex(NotADirectoryError, "resolves through another"):
                    publication_root.__enter__()
                self.assertEqual([], publication_root._windows_handles)

    def test_precheck_to_pin_ancestor_junction_swap_is_refused(self):
        if os.name != "nt":
            self.skipTest("Windows final-path proof")
        with tempfile.TemporaryDirectory() as parent:
            route = os.path.join(parent, "catalog-route")
            catalog = os.path.join(route, "catalog")
            retired = os.path.join(parent, "retired-route")
            replacement = os.path.join(parent, "replacement-route")
            replacement_catalog = os.path.join(replacement, "catalog")
            slug = "a.0001v1"
            article_path = os.path.join(catalog, slug, "article.json")
            replacement_article = os.path.join(replacement_catalog, slug, "article.json")
            _write_json(article_path, article_record(slug))
            _write_json(replacement_article, article_record(slug))
            original_catalog_root = inventory_catalog._catalog_root
            swapped = False
            junction_context = None

            def swap_after_precheck(value: str) -> str:
                nonlocal junction_context, swapped
                root = original_catalog_root(value)
                if not swapped:
                    swapped = True
                    os.rename(route, retired)
                    junction_context = directory_link(route, replacement)
                    junction_context.__enter__()
                return root

            try:
                with mock.patch(
                    "jsonl_engine.inventory_catalog._catalog_root",
                    side_effect=swap_after_precheck,
                ):
                    with self.assertRaisesRegex(
                        InventoryCatalogError,
                        "catalog directory could not be pinned",
                    ) as raised:
                        build_inventory(catalog_dir=catalog, article_paths=[article_path])
                self.assertIsInstance(raised.exception.__cause__, NotADirectoryError)
                self.assertIn("resolves through another", str(raised.exception.__cause__))
                self.assertFalse(
                    os.path.lexists(os.path.join(replacement_catalog, "inventory.jsonl"))
                )
                self.assertFalse(
                    os.path.lexists(os.path.join(retired, "catalog", "inventory.jsonl"))
                )
            finally:
                if junction_context is not None:
                    junction_context.__exit__(None, None, None)

    def test_catalog_generation_is_pinned_from_article_read_through_publication(self):
        with tempfile.TemporaryDirectory() as parent:
            catalog = os.path.join(parent, "catalog")
            retired = os.path.join(parent, "retired-catalog")
            article_path = os.path.join(catalog, "a.0001v1", "article.json")
            _write_json(article_path, article_record("a.0001v1"))
            original_load = inventory_catalog._load_article_at_catalog_path
            article_loaded = threading.Event()
            release_builder = threading.Event()
            outcomes = []

            def pause_after_article(*args, **kwargs):
                article = original_load(*args, **kwargs)
                article_loaded.set()
                if not release_builder.wait(10.0):
                    raise TimeoutError("test did not release the paused inventory builder")
                return article

            def build() -> None:
                try:
                    outcomes.append(
                        ("published", build_inventory(catalog_dir=catalog, article_paths=[article_path]))
                    )
                except BaseException as exc:
                    outcomes.append(("failed", exc))

            with mock.patch(
                "jsonl_engine.inventory_catalog._load_article_at_catalog_path",
                side_effect=pause_after_article,
            ):
                worker = threading.Thread(target=build, daemon=True)
                worker.start()
                self.assertTrue(article_loaded.wait(10.0), "inventory builder did not reach barrier")
                try:
                    if os.name == "nt":
                        with self.assertRaises(OSError):
                            os.rename(catalog, retired)
                    else:
                        os.rename(catalog, retired)
                        os.mkdir(catalog)
                finally:
                    release_builder.set()
                worker.join(20.0)

            self.assertFalse(worker.is_alive(), "inventory builder did not stop")
            self.assertEqual(1, len(outcomes), outcomes)
            if os.name == "nt":
                self.assertEqual("published", outcomes[0][0], outcomes)
                store = JsonlStore(os.path.join(catalog, "inventory.jsonl"))
                self.assertTrue(store.verify())
                os.rename(catalog, retired)
                self.assertTrue(os.path.isdir(retired))
            else:
                self.assertEqual("failed", outcomes[0][0], outcomes)
                self.assertIsInstance(outcomes[0][1], InventoryCatalogError)
                self.assertIn("changed during inventory publication", str(outcomes[0][1]))
                self.assertFalse(os.path.lexists(os.path.join(catalog, "inventory.jsonl")))
                self.assertTrue(JsonlStore(os.path.join(retired, "inventory.jsonl")).verify())

    def test_safe_discovery_builds_from_direct_children_only(self):
        with tempfile.TemporaryDirectory() as catalog:
            expected = []
            for slug in ("b.0001v1", "a.0001v1"):
                path = os.path.join(catalog, slug, "article.json")
                _write_json(path, article_record(slug))
                expected.append(os.path.abspath(path))
            os.makedirs(os.path.join(catalog, "not-deposited"))
            nested = os.path.join(catalog, "nested", "child", "article.json")
            _write_json(nested, article_record("child"))

            discovered = discover_article_paths(catalog)
            self.assertEqual(list(reversed(expected)), discovered)

            result = build_inventory(catalog_dir=catalog)
            self.assertEqual(["a.0001v1", "b.0001v1"], result.slugs)
            rows = list(JsonlStore(result.inventory_path))[1:]
            self.assertEqual(result.slugs, [row["slug"] for row in rows])

    def test_build_writes_sorted_inventory_rows(self):
        with tempfile.TemporaryDirectory() as catalog:
            paths = []
            for slug in ("b.0001v1", "a.0001v1"):
                article_path = os.path.join(catalog, slug, "article.json")
                _write_json(article_path, article_record(slug))
                paths.append(article_path)

            result = build_inventory(catalog_dir=catalog, article_paths=paths)
            self.assertEqual(2, result.article_count)
            self.assertEqual(["a.0001v1", "b.0001v1"], result.slugs)
            self.assertTrue(os.path.isfile(result.inventory_path))

            records = list(JsonlStore(result.inventory_path))
            self.assertEqual("inventory", records[0]["kind"])
            rows = records[1:]
            self.assertEqual(["a.0001v1", "b.0001v1"], [row["slug"] for row in rows])

    def test_empty_article_list_publishes_empty_inventory(self):
        with tempfile.TemporaryDirectory() as catalog:
            result = build_inventory(catalog_dir=catalog, article_paths=[])
            self.assertEqual(0, result.article_count)
            self.assertEqual([], result.slugs)
            self.assertTrue(os.path.isfile(result.inventory_path))

    def test_existing_inventory_is_refused_without_force(self):
        with tempfile.TemporaryDirectory() as catalog:
            paths = []
            for slug in ("a.0001v1",):
                article_path = os.path.join(catalog, slug, "article.json")
                _write_json(article_path, article_record(slug))
                paths.append(article_path)

            first = build_inventory(catalog_dir=catalog, article_paths=paths)
            self.assertTrue(os.path.isfile(first.inventory_path))
            with self.assertRaisesRegex(InventoryCatalogError, "already exists"):
                build_inventory(catalog_dir=catalog, article_paths=paths)

    def test_force_overwrites_existing_inventory(self):
        with tempfile.TemporaryDirectory() as catalog:
            first_path = os.path.join(catalog, "a.0001v1", "article.json")
            _write_json(first_path, article_record("a.0001v1"))
            build_inventory(catalog_dir=catalog, article_paths=[first_path])

            second_path = os.path.join(catalog, "b.0001v1", "article.json")
            _write_json(second_path, article_record("b.0001v1"))
            result = build_inventory(
                catalog_dir=catalog,
                article_paths=[first_path, second_path],
                force=True,
            )
            self.assertEqual(2, result.article_count)
            self.assertEqual(["a.0001v1", "b.0001v1"], result.slugs)
            records = list(JsonlStore(result.inventory_path))
            self.assertEqual(["a.0001v1", "b.0001v1"], [row["slug"] for row in records[1:]])

    def test_force_never_overwrites_a_replacement_reached_by_ancestor_swap(self):
        with tempfile.TemporaryDirectory() as parent:
            outer = os.path.join(parent, "outer")
            catalog = os.path.join(outer, "route", "catalog")
            retired = os.path.join(parent, "retired-outer")
            first_path = os.path.join(catalog, "a.0001v1", "article.json")
            second_path = os.path.join(catalog, "b.0001v1", "article.json")
            _write_json(first_path, article_record("a.0001v1"))
            build_inventory(catalog_dir=catalog, article_paths=[first_path])
            _write_json(second_path, article_record("b.0001v1"))

            original_load = inventory_catalog._load_article_at_catalog_path
            article_loaded = threading.Event()
            release_builder = threading.Event()
            outcomes = []
            replacement_bytes = b"replacement-generation-owned\n"

            def pause_after_article(*args, **kwargs):
                article = original_load(*args, **kwargs)
                article_loaded.set()
                if not release_builder.wait(10.0):
                    raise TimeoutError("test did not release the paused forced inventory builder")
                return article

            def build() -> None:
                try:
                    outcomes.append(
                        (
                            "published",
                            build_inventory(
                                catalog_dir=catalog,
                                article_paths=[second_path],
                                force=True,
                            ),
                        )
                    )
                except BaseException as exc:
                    outcomes.append(("failed", exc))

            with mock.patch(
                "jsonl_engine.inventory_catalog._load_article_at_catalog_path",
                side_effect=pause_after_article,
            ):
                worker = threading.Thread(target=build, daemon=True)
                worker.start()
                self.assertTrue(article_loaded.wait(10.0), "forced builder did not reach barrier")
                try:
                    if os.name == "nt":
                        with self.assertRaises(OSError):
                            os.rename(outer, retired)
                    else:
                        os.rename(outer, retired)
                        os.makedirs(catalog)
                        with open(os.path.join(catalog, "inventory.jsonl"), "wb") as handle:
                            handle.write(replacement_bytes)
                finally:
                    release_builder.set()
                worker.join(20.0)

            self.assertFalse(worker.is_alive(), "forced inventory builder did not stop")
            self.assertEqual(1, len(outcomes), outcomes)
            if os.name == "nt":
                self.assertEqual("published", outcomes[0][0], outcomes)
                records = list(JsonlStore(os.path.join(catalog, "inventory.jsonl")))
                self.assertEqual(["b.0001v1"], [record["slug"] for record in records[1:]])
                os.rename(outer, retired)
                self.assertTrue(os.path.isdir(retired))
            else:
                self.assertEqual("failed", outcomes[0][0], outcomes)
                self.assertIsInstance(outcomes[0][1], InventoryCatalogError)
                with open(os.path.join(catalog, "inventory.jsonl"), "rb") as handle:
                    self.assertEqual(replacement_bytes, handle.read())
                self.assertFalse(os.path.lexists(os.path.join(catalog, "inventory.jsonl.jidx")))
                self.assertFalse(os.path.lexists(os.path.join(catalog, "inventory.jsonl.sig")))
                old_inventory = os.path.join(retired, "route", "catalog", "inventory.jsonl")
                records = list(JsonlStore(old_inventory))
                self.assertEqual(["b.0001v1"], [record["slug"] for record in records[1:]])
                self.assertTrue(JsonlStore(old_inventory).verify())

    def test_inventory_appearing_after_precheck_is_not_replaced(self):
        with tempfile.TemporaryDirectory() as catalog:
            article_path = os.path.join(catalog, "a.0001v1", "article.json")
            _write_json(article_path, article_record("a.0001v1"))
            inventory_path = os.path.join(catalog, "inventory.jsonl")
            peer_bytes = b"peer-writer-owned\n"

            def appear_after_precheck(path: str, *, force: bool, publication_root) -> None:
                self.assertEqual(inventory_path, path)
                self.assertFalse(force)
                self.assertFalse(publication_root.lexists(path))
                with open(path, "wb") as handle:
                    handle.write(peer_bytes)

            with mock.patch(
                "jsonl_engine.inventory_catalog._inventory_occupancy",
                side_effect=appear_after_precheck,
            ):
                with self.assertRaisesRegex(InventoryCatalogError, "already exists"):
                    build_inventory(catalog_dir=catalog, article_paths=[article_path])

            with open(inventory_path, "rb") as handle:
                self.assertEqual(peer_bytes, handle.read())

    def test_two_create_only_builders_publish_exactly_one_complete_inventory(self):
        """Both callers pass the fast precheck; the artifact lease chooses one winner."""

        with tempfile.TemporaryDirectory() as parent:
            catalog = os.path.join(parent, "catalog")
            scratch = os.path.join(parent, "json-scratch")
            os.makedirs(catalog)
            article_paths = {}
            for tag, slug in (("first", "a.0001v1"), ("second", "b.0001v1")):
                path = os.path.join(catalog, slug, "article.json")
                _write_json(path, article_record(slug))
                article_paths[tag] = path

            precheck = threading.Barrier(2, timeout=10.0)
            outcomes = []
            outcome_lock = threading.Lock()

            def synchronize_absence(path: str, *, force: bool, publication_root) -> None:
                self.assertEqual(os.path.join(catalog, "inventory.jsonl"), path)
                self.assertFalse(force)
                self.assertFalse(publication_root.lexists(path))
                precheck.wait()

            def build(tag: str) -> None:
                try:
                    value = build_inventory(
                        catalog_dir=catalog,
                        article_paths=[article_paths[tag]],
                    )
                    outcome = (tag, "published", value)
                except BaseException as exc:  # surfaced after both writers terminate
                    outcome = (tag, "failed", exc)
                with outcome_lock:
                    outcomes.append(outcome)

            with mock.patch.dict(os.environ, {SCRATCH_ROOT_ENV: scratch}), mock.patch(
                "jsonl_engine.inventory_catalog._inventory_occupancy",
                side_effect=synchronize_absence,
            ):
                writers = [
                    threading.Thread(target=build, args=(tag,), daemon=True)
                    for tag in ("first", "second")
                ]
                for writer in writers:
                    writer.start()
                deadline = time.monotonic() + 20.0
                for writer in writers:
                    writer.join(max(0.0, deadline - time.monotonic()))

            alive = [writer.name for writer in writers if writer.is_alive()]
            self.assertEqual([], alive, f"inventory writers did not stop: {alive}")
            published = [item for item in outcomes if item[1] == "published"]
            failed = [item for item in outcomes if item[1] == "failed"]
            self.assertEqual(1, len(published), outcomes)
            self.assertEqual(1, len(failed), outcomes)
            self.assertIsInstance(failed[0][2], InventoryCatalogError)
            self.assertIn("already exists", str(failed[0][2]))

            winner_tag, _, winner_result = published[0]
            winner_slug = os.path.basename(os.path.dirname(article_paths[winner_tag]))
            self.assertEqual([winner_slug], winner_result.slugs)
            store = JsonlStore(os.path.join(catalog, "inventory.jsonl"))
            records = list(store)
            self.assertEqual([winner_slug], [record["slug"] for record in records[1:]])
            self.assertTrue(store.verify())
            self.assertEqual(
                [],
                [name for name in os.listdir(catalog) if name.endswith(".tmp")],
            )

    def test_slug_must_match_direct_child_leaf(self):
        with tempfile.TemporaryDirectory() as catalog:
            article_path = os.path.join(catalog, "1105.4224v1", "article.json")
            _write_json(article_path, article_record("9999.0000v1"))
            with self.assertRaisesRegex(InventoryCatalogError, "does not match"):
                build_inventory(catalog_dir=catalog, article_paths=[article_path])

    def test_nested_article_is_rejected(self):
        with tempfile.TemporaryDirectory() as catalog:
            article_path = os.path.join(catalog, "parent", "child", "article.json")
            _write_json(article_path, article_record("child"))
            with self.assertRaisesRegex(InventoryCatalogError, "direct child"):
                build_inventory(catalog_dir=catalog, article_paths=[article_path])

    def test_parent_article_cannot_escape_the_catalog(self):
        with tempfile.TemporaryDirectory() as parent:
            catalog = os.path.join(parent, "catalog")
            os.makedirs(catalog)
            article_path = os.path.join(parent, "article.json")
            _write_json(article_path, article_record(".."))
            with self.assertRaisesRegex(InventoryCatalogError, "direct child"):
                build_inventory(catalog_dir=catalog, article_paths=[article_path])

    def test_present_non_file_article_is_rejected_by_discovery(self):
        with tempfile.TemporaryDirectory() as catalog:
            os.makedirs(os.path.join(catalog, "occupied", "article.json"))
            with self.assertRaisesRegex(InventoryCatalogError, "physical non-reparse file"):
                discover_article_paths(catalog)

    def test_oversized_article_is_refused_before_json_parsing(self):
        with tempfile.TemporaryDirectory() as catalog:
            article_path = os.path.join(catalog, "large", "article.json")
            os.makedirs(os.path.dirname(article_path))
            with open(article_path, "wb") as handle:
                handle.truncate(MAX_ARTICLE_MANIFEST_BYTES + 1)
            with self.assertRaisesRegex(InventoryCatalogError, "exceeds the .*byte limit"):
                build_inventory(catalog_dir=catalog)

    def test_file_generation_drift_is_refused(self):
        with tempfile.TemporaryDirectory() as catalog:
            article_path = os.path.join(catalog, "drift", "article.json")
            _write_json(article_path, article_record("drift"))
            with mock.patch(
                "jsonl_engine.inventory_catalog._same_snapshot", return_value=False
            ):
                with self.assertRaisesRegex(InventoryCatalogError, "changed while it was being read"):
                    build_inventory(catalog_dir=catalog, article_paths=[article_path])

    def test_inventory_registry_rejects_portable_case_collisions(self):
        with tempfile.TemporaryDirectory() as catalog:
            registry = InventoryRegistry(target_dir=catalog)
            with self.assertRaisesRegex(DuplicateEntry, "ordinal-ignore-case"):
                registry.collate([article_record("Paper"), article_record("paper")])

    def test_discovery_rejects_symlinked_catalog_children_when_supported(self):
        with tempfile.TemporaryDirectory() as catalog, tempfile.TemporaryDirectory() as outside:
            _write_json(os.path.join(outside, "article.json"), article_record("linked"))
            link = os.path.join(catalog, "linked")
            with directory_link(link, outside):
                with self.assertRaisesRegex(
                    InventoryCatalogError, "symbolic link or reparse point"
                ):
                    discover_article_paths(catalog)

    def test_cli_build_inventory_framed(self):
        with tempfile.TemporaryDirectory() as catalog:
            slug = "1105.4224v1"
            article_path = os.path.join(catalog, slug, "article.json")
            _write_json(article_path, article_record(slug))
            paths_json = os.path.join(catalog, "article-paths.json")
            _write_json(paths_json, [article_path])

            proc = _run_cli(
                "--framed",
                "build-inventory",
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

            refused = _run_cli(
                "--framed",
                "build-inventory",
                "--catalog-dir",
                catalog,
                "--article-paths-json",
                paths_json,
            )
            self.assertNotEqual(0, refused.returncode)

            forced = _run_cli(
                "--framed",
                "build-inventory",
                "--catalog-dir",
                catalog,
                "--article-paths-json",
                paths_json,
                "--force",
            )
            self.assertEqual(0, forced.returncode, forced.stderr.decode("utf-8"))

    def test_fold_relocates_leaf_paths_from_child_inventories(self):
        with tempfile.TemporaryDirectory() as parent:
            first = os.path.join(parent, "kisungyou")
            second = os.path.join(parent, "mapper")
            os.makedirs(os.path.join(parent, "empty-collection"))
            _write_json(
                os.path.join(first, "a.0001v1", "article.json"),
                article_record("a.0001v1"),
            )
            _write_json(
                os.path.join(second, "b.0001v1", "article.json"),
                article_record("b.0001v1"),
            )
            build_inventory(catalog_dir=first)
            build_inventory(catalog_dir=second)

            result = fold_inventory(catalog_dir=parent)
            self.assertEqual(["a.0001v1", "b.0001v1"], result.slugs)
            rows = list(JsonlStore(result.inventory_path))[1:]
            by_slug = {row["slug"]: row for row in rows}
            self.assertEqual(
                "kisungyou/a.0001v1/a.0001v1.tar.gz",
                by_slug["a.0001v1"]["source_forms"][0]["path"],
            )
            self.assertEqual(
                "kisungyou/a.0001v1/a.0001v1.tar.gz",
                by_slug["a.0001v1"]["source_forms"][1]["derived_from"],
            )
            self.assertEqual(
                "mapper/b.0001v1/b.0001v1-tex",
                by_slug["b.0001v1"]["source_forms"][1]["path"],
            )
            self.assertEqual("main.tex", by_slug["a.0001v1"]["evidence"]["latex_source"]["entrypoint"])

    def test_fold_skips_collections_without_inventory(self):
        with tempfile.TemporaryDirectory() as parent:
            child = os.path.join(parent, "mapper")
            _write_json(
                os.path.join(child, "a.0001v1", "article.json"),
                article_record("a.0001v1"),
            )
            result = fold_inventory(catalog_dir=parent)
            self.assertEqual(0, result.article_count)
            self.assertEqual([], result.slugs)

    def test_fold_refuses_duplicate_slugs_across_children(self):
        with tempfile.TemporaryDirectory() as parent:
            left = os.path.join(parent, "left")
            right = os.path.join(parent, "right")
            _write_json(os.path.join(left, "a.0001v1", "article.json"), article_record("a.0001v1"))
            _write_json(os.path.join(right, "a.0001v1", "article.json"), article_record("a.0001v1"))
            build_inventory(catalog_dir=left)
            build_inventory(catalog_dir=right)
            with self.assertRaisesRegex(InventoryCatalogError, "Duplicate entry"):
                fold_inventory(catalog_dir=parent)

    def test_fold_existing_inventory_is_refused_without_force(self):
        with tempfile.TemporaryDirectory() as parent:
            child = os.path.join(parent, "mapper")
            _write_json(
                os.path.join(child, "a.0001v1", "article.json"),
                article_record("a.0001v1"),
            )
            build_inventory(catalog_dir=child)
            fold_inventory(catalog_dir=parent)
            with self.assertRaisesRegex(InventoryCatalogError, "already exists"):
                fold_inventory(catalog_dir=parent)
            result = fold_inventory(catalog_dir=parent, force=True)
            self.assertEqual(["a.0001v1"], result.slugs)

    def test_cli_fold_inventory_framed(self):
        with tempfile.TemporaryDirectory() as parent:
            child = os.path.join(parent, "mapper")
            _write_json(
                os.path.join(child, "1105.4224v1", "article.json"),
                article_record("1105.4224v1"),
            )
            build_inventory(catalog_dir=child)
            proc = _run_cli("--framed", "fold-inventory", "--catalog-dir", parent)
            self.assertEqual(0, proc.returncode, proc.stderr.decode("utf-8"))
            frame = json.loads(proc.stdout)
            self.assertEqual("value", frame["type"])
            self.assertEqual(["1105.4224v1"], frame["value"]["slugs"])


if __name__ == "__main__":
    unittest.main()
