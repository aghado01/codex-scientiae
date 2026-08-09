"""The registry category, and what distinguishes it from a store that merely carries a header."""

import hashlib
import json
import os
import tempfile
import unittest

from jsonl_engine import JsonlStore, JsonReaderError
from jsonl_engine.kinds import DuplicateEntry, InventoryRegistry, SchemaRegistry
from jsonl_engine.schemas import get_schema_catalog

from jsonl_test_support import article


def _sha(path: str) -> str:
    with open(path, "rb") as handle:
        return hashlib.sha256(handle.read()).hexdigest()


def _rows(path: str):
    records = list(JsonlStore(path))
    return records[0], records[1:]


class TestRegistrySemantics(unittest.TestCase):
    def test_rows_are_emitted_in_canonical_key_order(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = InventoryRegistry(target_dir=tmpdir)
            path = registry.rebuild([article(s) for s in ("c", "a", "b")])
            _, rows = _rows(path)
            self.assertEqual(["a", "b", "c"], [r["slug"] for r in rows])

    def test_the_same_population_produces_the_same_bytes_in_any_order(self):
        """The property the whole category exists for."""
        with tempfile.TemporaryDirectory() as d1, tempfile.TemporaryDirectory() as d2:
            forward = [article(s) for s in ("a", "b", "c")]
            shuffled = [article(s) for s in ("b", "c", "a")]
            first = InventoryRegistry(target_dir=d1).rebuild(forward)
            second = InventoryRegistry(target_dir=d2).rebuild(shuffled)
            self.assertEqual(_sha(first), _sha(second))

    def test_the_header_carries_no_wall_clock(self):
        """created_at would defeat reproducibility; the .sig records the write instead."""
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = InventoryRegistry(target_dir=tmpdir)
            path = registry.rebuild([article()])
            header, _ = _rows(path)
            self.assertNotIn("created_at", header)
            self.assertIn("created_at", JsonlStore(path).read_sig())

    def test_a_duplicate_key_is_refused_rather_than_overwritten(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = InventoryRegistry(target_dir=tmpdir)
            with self.assertRaises(DuplicateEntry) as caught:
                registry.rebuild([article("dup"), article("dup")])
            self.assertIn("'/slug': 'dup'", str(caught.exception))

    def test_the_header_declares_the_population(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = InventoryRegistry(target_dir=tmpdir)
            path = registry.rebuild([article(s) for s in ("a", "b")])
            header, _ = _rows(path)
            self.assertEqual("inventory", header["kind"])
            self.assertEqual(["/slug"], header["identity"])
            self.assertEqual(2, header["count"])

    def test_accumulating_into_a_registry_is_refused(self):
        """Incremental APIs would bypass ordering, uniqueness, and an accurate header count."""
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = InventoryRegistry(target_dir=tmpdir)
            for call in (
                lambda: registry.add(article()),
                registry.write,
                registry.open_writer,
            ):
                with self.assertRaises(TypeError) as caught:
                    call()
                self.assertIn("rebuild(entries)", str(caught.exception))
            self.assertFalse(os.path.exists(registry.get_output_path()))

    def test_open_store_validates_header_and_payload_with_their_own_schemas(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = InventoryRegistry(target_dir=tmpdir)
            registry.rebuild([article("a"), article("b")])

            header, *rows = list(registry.open_store())
            self.assertEqual("inventory", header["kind"])
            self.assertEqual(["a", "b"], [row["slug"] for row in rows])

    def test_open_store_rejects_foreign_header_identity_at_the_declaring_field(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = InventoryRegistry(target_dir=tmpdir)
            for field, foreign, expected in (
                ("kind", "schema-registry", "inventory"),
                ("version", "99.0", registry.VERSION),
            ):
                with self.subTest(field=field):
                    filename = f"foreign-{field}.jsonl"
                    path = registry.get_output_path(filename=filename)
                    header = registry.build_header()
                    header[field] = foreign
                    with open(path, "w", encoding="utf-8", newline="\n") as handle:
                        handle.write(json.dumps(header) + "\n")

                    with self.assertRaises(JsonReaderError) as caught:
                        next(iter(registry.open_store(filename=filename)))
                    self.assertIn(
                        f"schema validation failed at [{field}]", str(caught.exception)
                    )
                    self.assertIn(f"must be {expected!r}", str(caught.exception))

    def test_identity_comes_from_the_schema_not_the_class(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = InventoryRegistry(target_dir=tmpdir)
            declared = get_schema_catalog().identity_of(InventoryRegistry.RECORD_SCHEMA)
            self.assertEqual(tuple(declared), tuple(registry.identity))

    def test_a_schema_without_identity_cannot_back_a_registry(self):
        from jsonl_engine.kinds import Registry

        class Unkeyed(Registry):
            KIND = "test-unkeyed"
            RECORD_SCHEMA = "header.schema.json"  # ships no x-identity

        with tempfile.TemporaryDirectory() as tmpdir:
            with self.assertRaises(TypeError) as caught:
                Unkeyed(target_dir=tmpdir)
            self.assertIn("x-identity", str(caught.exception))


class TestSchemaRegistry(unittest.TestCase):
    """The engine's own schemas, published as an artifact."""

    def test_it_registers_every_schema_the_catalog_holds(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = SchemaRegistry(target_dir=tmpdir)
            path = registry.rebuild_from_catalog()
            header, rows = _rows(path)

            catalog = get_schema_catalog()
            self.assertEqual(catalog.keys(), [r["id"] for r in rows])
            self.assertEqual(len(rows), header["count"])
            self.assertTrue(JsonlStore(path).verify())

    def test_entries_carry_what_a_consumer_needs_to_resolve_a_schema(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = SchemaRegistry(target_dir=tmpdir).rebuild_from_catalog()
            _, rows = _rows(path)
            article = next(r for r in rows if r["id"] == "codex-scientiae/article/0.1")
            self.assertEqual("article.schema.json", article["file"])
            self.assertEqual(["/slug"], article["identity"])
            self.assertTrue(article["draft"].startswith("https://json-schema.org/"))

    def test_a_schema_declaring_no_identity_says_so_by_omission(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            path = SchemaRegistry(target_dir=tmpdir).rebuild_from_catalog()
            _, rows = _rows(path)
            header_schema = next(
                r for r in rows if r["id"] == "codex-scientiae/jsonl-header/0.1"
            )
            self.assertNotIn("identity", header_schema)

    def test_it_is_self_hosting(self):
        """Its own entry schema appears in the registry it produces."""
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = SchemaRegistry(target_dir=tmpdir)
            path = registry.rebuild_from_catalog()
            _, rows = _rows(path)
            self.assertIn(
                "codex-scientiae/schema-entry/0.1", [r["id"] for r in rows]
            )

    def test_its_kind_reader_accepts_its_own_header_and_entries(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            registry = SchemaRegistry(target_dir=tmpdir)
            registry.rebuild_from_catalog()

            header, *rows = list(registry.open_store())
            self.assertEqual("schema-registry", header["kind"])
            self.assertEqual(header["count"], len(rows))


class TestMint(unittest.TestCase):
    def test_const_properties_are_filled_from_the_schema(self):
        catalog = get_schema_catalog()
        supplied = {k: v for k, v in article().items() if k not in ("schema", "state")}
        minted = catalog.mint("article.schema.json", supplied)
        self.assertEqual("codex-scientiae/article/0.1", minted["schema"])
        self.assertEqual("source-ready", minted["state"])

    def test_key_order_follows_the_schema_not_the_caller(self):
        catalog = get_schema_catalog()
        forward = article()
        reversed_input = dict(reversed(list(forward.items())))
        self.assertEqual(
            list(catalog.mint("article.schema.json", forward)),
            list(catalog.mint("article.schema.json", reversed_input)),
        )

    def test_a_missing_required_property_fails_validation(self):
        import jsonschema

        catalog = get_schema_catalog()
        incomplete = {k: v for k, v in article().items() if k != "slug"}
        with self.assertRaises(jsonschema.ValidationError):
            catalog.mint("article.schema.json", incomplete)


if __name__ == "__main__":
    unittest.main()
