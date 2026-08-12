"""Hierarchical pinned roots and schema-backed JSON document stores."""

from __future__ import annotations

import os
import tempfile
import unittest
from dataclasses import dataclass

from jsonl_engine.documents import JsonDocumentError, JsonDocumentKind, JsonDocumentStore
from jsonl_engine.publication import PinnedPublicationRoot
from jsonl_engine.schemas import SchemaCatalog


@dataclass(frozen=True, slots=True)
class Note:
    name: object


class NoteDocument(JsonDocumentKind[Note]):
    KIND = "test-note"
    SCHEMA = "note.schema.json"
    MAXIMUM_BYTES = 256

    def record_of(self, value: Note) -> dict[str, object]:
        return {"schema": "test/note/1", "name": value.name}

    def value_of(self, record: dict[str, object]) -> Note:
        return Note(name=record["name"])


def note_kind() -> NoteDocument:
    catalog = SchemaCatalog()
    catalog.register_schema_data(
        "note.schema.json",
        {
            "$schema": "https://json-schema.org/draft/2020-12/schema",
            "$id": "test/note/1",
            "type": "object",
            "additionalProperties": False,
            "required": ["schema", "name"],
            "properties": {
                "schema": {"const": "test/note/1"},
                "name": {"type": "string", "minLength": 1},
            },
        },
    )
    return NoteDocument(catalog)


class TestPinnedDirectoryHierarchy(unittest.TestCase):
    def test_lock_address_changes_with_the_directory_generation(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            root_path = os.path.join(parent, "root")
            retired = os.path.join(parent, "retired")
            os.mkdir(root_path)
            with PinnedPublicationRoot(root_path) as first:
                first_lock = first.lock_path(first.absolute("artifact.json"))
            with PinnedPublicationRoot(root_path) as same:
                self.assertEqual(first_lock, same.lock_path(same.absolute("artifact.json")))
            os.rename(root_path, retired)
            os.mkdir(root_path)
            with PinnedPublicationRoot(root_path) as replacement:
                replacement_lock = replacement.lock_path(
                    replacement.absolute("artifact.json")
                )
            self.assertNotEqual(first_lock, replacement_lock)

    def test_child_creation_pin_and_removal_are_anchored_to_the_parent(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            root_path = os.path.join(parent, "root")
            os.mkdir(root_path)
            with PinnedPublicationRoot(root_path) as root:
                child_path = root.mkdir_leaf("child")
                with root.pin_child("child") as child:
                    self.assertTrue(child.is_active)
                    self.assertEqual(child_path, child.path)
                    self.assertTrue(child.path_is_current())
                    with child.open_leaf("evidence.bin", "xb") as handle:
                        handle.write(b"evidence")
                    self.assertEqual(8, child.stat_leaf("evidence.bin").st_size)
                    child.unlink(child.absolute("evidence.bin"))
                root.rmdir_leaf("child")
                self.assertFalse(os.path.lexists(child_path))

    def test_child_cannot_outlive_the_parent_activation(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            os.mkdir(os.path.join(root_path, "child"))
            root = PinnedPublicationRoot(root_path)
            root.__enter__()
            child = root.pin_child("child")
            child.__enter__()
            root.__exit__(None, None, None)
            try:
                self.assertFalse(child.is_active)
                with self.assertRaisesRegex(RuntimeError, "parent activation|not active"):
                    child.list_names()
            finally:
                child.__exit__(None, None, None)

    def test_child_pin_rejects_a_redirecting_directory_leaf(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            root_path = os.path.join(parent, "root")
            outside = os.path.join(parent, "outside")
            os.mkdir(root_path)
            os.mkdir(outside)
            link = os.path.join(root_path, "child")
            try:
                os.symlink(outside, link, target_is_directory=True)
            except (OSError, NotImplementedError) as exc:
                self.skipTest(f"directory symbolic links are unavailable: {exc}")
            with PinnedPublicationRoot(root_path) as root:
                with self.assertRaises((OSError, NotADirectoryError)):
                    with root.pin_child("child"):
                        pass

    @unittest.skipIf(os.name == "nt", "Windows holds the named route against replacement")
    def test_current_path_check_detects_a_replaced_posix_root(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            root_path = os.path.join(parent, "root")
            retired = os.path.join(parent, "retired")
            os.mkdir(root_path)
            with PinnedPublicationRoot(root_path) as root:
                os.rename(root_path, retired)
                os.mkdir(root_path)
                self.assertFalse(root.path_is_current())
                with self.assertRaisesRegex(RuntimeError, "no longer names"):
                    root.assert_current()

    @unittest.skipUnless(os.name == "nt", "Windows delete-sharing contract")
    def test_windows_pin_blocks_root_replacement_until_close(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            root_path = os.path.join(parent, "root")
            retired = os.path.join(parent, "retired")
            os.mkdir(root_path)
            root = PinnedPublicationRoot(root_path)
            root.__enter__()
            try:
                with self.assertRaises(PermissionError):
                    os.rename(root_path, retired)
            finally:
                root.__exit__(None, None, None)
            os.rename(root_path, retired)
            self.assertTrue(os.path.isdir(retired))


class TestJsonDocumentStore(unittest.TestCase):
    def test_store_requires_an_active_pinned_root(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            with self.assertRaisesRegex(RuntimeError, "not active"):
                JsonDocumentStore(PinnedPublicationRoot(root_path), "note.json", note_kind())

    def test_publish_read_and_require_use_the_declared_kind(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            with PinnedPublicationRoot(root_path) as root:
                store = JsonDocumentStore(root, "note.json", note_kind())
                self.assertIsNone(store.read())
                self.assertEqual(store.path, store.publish(Note("alpha")))
                self.assertEqual(Note("alpha"), store.read())
                self.assertEqual(Note("alpha"), store.require())
                with open(store.path, "rb") as handle:
                    raw = handle.read()
                self.assertTrue(raw.endswith(b"\n"))
                self.assertIn(b'"schema": "test/note/1"', raw)

    def test_create_only_publication_preserves_existing_bytes(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            with PinnedPublicationRoot(root_path) as root:
                store = JsonDocumentStore(root, "note.json", note_kind())
                store.publish(Note("first"))
                with open(store.path, "rb") as handle:
                    before = handle.read()
                with self.assertRaises(FileExistsError):
                    store.publish(Note("second"))
                with open(store.path, "rb") as handle:
                    self.assertEqual(before, handle.read())
                scratch = [
                    name for name in os.listdir(root_path) if name.endswith(".tmp")
                ]
                self.assertEqual([], scratch)

    def test_schema_failure_occurs_before_any_filesystem_write(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            with PinnedPublicationRoot(root_path) as root:
                store = JsonDocumentStore(root, "note.json", note_kind())
                with self.assertRaisesRegex(JsonDocumentError, "schema validation failed"):
                    store.publish(Note(7))
                self.assertEqual([], os.listdir(root_path))

    def test_read_rejects_nonregular_occupancy(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            os.mkdir(os.path.join(root_path, "note.json"))
            with PinnedPublicationRoot(root_path) as root:
                store = JsonDocumentStore(root, "note.json", note_kind())
                with self.assertRaisesRegex(JsonDocumentError, "physical regular file"):
                    store.read()

    @unittest.skipIf(os.name == "nt", "POSIX route replacement witness")
    def test_store_refuses_to_write_after_the_named_root_is_replaced(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            root_path = os.path.join(parent, "root")
            retired = os.path.join(parent, "retired")
            os.mkdir(root_path)
            with PinnedPublicationRoot(root_path) as root:
                store = JsonDocumentStore(root, "note.json", note_kind())
                os.rename(root_path, retired)
                os.mkdir(root_path)
                with self.assertRaisesRegex(RuntimeError, "no longer names"):
                    store.publish(Note("refused"))
                self.assertEqual([], os.listdir(root_path))
                self.assertEqual([], os.listdir(retired))


if __name__ == "__main__":
    unittest.main()
