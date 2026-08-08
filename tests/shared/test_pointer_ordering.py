"""JSON Pointer resolution and the deterministic ordering registries sort by."""

import unittest

from jsonl_engine.ordering import KeyComparison, SortField, comparable, sort_tuple
from jsonl_engine.pointer import MISSING, PointerError, exists, parse, resolve

DOC = {
    "slug": "x1",
    "nested": {"a": [10, {"b": "deep"}]},
    "a/b": "slashed",
    "a~b": "tilded",
    "null": None,
}


class TestPointer(unittest.TestCase):
    def test_the_empty_pointer_is_the_whole_document(self):
        self.assertIs(DOC, resolve(DOC, ""))

    def test_it_walks_objects_and_array_indexes(self):
        self.assertEqual("x1", resolve(DOC, "/slug"))
        self.assertEqual(10, resolve(DOC, "/nested/a/0"))
        self.assertEqual("deep", resolve(DOC, "/nested/a/1/b"))

    def test_escapes_address_properties_containing_slash_and_tilde(self):
        self.assertEqual("slashed", resolve(DOC, "/a~1b"))
        self.assertEqual("tilded", resolve(DOC, "/a~0b"))

    def test_tilde_one_unescapes_before_tilde_zero(self):
        """'~01' is a literal '~1', not a '/'. Order of unescaping decides which."""
        self.assertEqual(("~1",), parse("/~01"))

    def test_a_bare_property_name_is_refused_with_the_fix_named(self):
        with self.assertRaises(PointerError) as caught:
            resolve(DOC, "slug")
        self.assertIn("did you mean '/slug'", str(caught.exception))

    def test_absent_and_null_are_distinguishable(self):
        self.assertIsNone(resolve(DOC, "/null"))
        self.assertIs(MISSING, resolve(DOC, "/nope"))
        self.assertTrue(exists(DOC, "/null"))
        self.assertFalse(exists(DOC, "/nope"))

    def test_a_missing_value_takes_the_default(self):
        self.assertEqual("fallback", resolve(DOC, "/nope", "fallback"))

    def test_out_of_range_and_non_numeric_array_tokens(self):
        self.assertIs(MISSING, resolve(DOC, "/nested/a/9"))
        with self.assertRaises(PointerError):
            resolve(DOC, "/nested/a/first")


class TestOrdering(unittest.TestCase):
    def test_values_of_mixed_json_types_are_totally_ordered(self):
        """Python cannot compare str with int; a registry keyed across both still must sort."""
        values = ["text", 3, None, True, 1.5, {"k": 1}]
        ordered = sorted(values, key=comparable)
        self.assertEqual([None, True, 1.5, 3, "text", {"k": 1}], ordered)

    def test_numbers_sort_numerically_not_lexically(self):
        self.assertEqual([2, 9, 10, 100], sorted([100, 9, 10, 2], key=comparable))

    def test_large_integers_keep_their_precision(self):
        big = 2**63 + 1
        self.assertLess(comparable(big - 1), comparable(big))

    def test_descending_terms_invert_within_a_mixed_sort(self):
        rows = [("b", 1), ("a", 2), ("b", 2), ("a", 1)]
        ordered = sorted(
            rows, key=lambda row: sort_tuple(list(row), [False, True])
        )
        self.assertEqual([("a", 2), ("a", 1), ("b", 2), ("b", 1)], ordered)

    def test_ordinal_is_case_sensitive_and_ignore_case_is_not(self):
        self.assertNotEqual(
            sort_tuple(["ABC"], comparison=KeyComparison.ORDINAL),
            sort_tuple(["abc"], comparison=KeyComparison.ORDINAL),
        )
        self.assertEqual(
            sort_tuple(["ABC"], comparison=KeyComparison.ORDINAL_IGNORE_CASE),
            sort_tuple(["abc"], comparison=KeyComparison.ORDINAL_IGNORE_CASE),
        )

    def test_caseless_folding_uses_casefold_not_lower(self):
        """str.lower leaves 'ß' unequal to 'SS'; casefold is the Unicode caseless operation."""
        fold = KeyComparison.ORDINAL_IGNORE_CASE.fold
        self.assertEqual(fold("ß"), fold("SS"))
        self.assertEqual("straße".lower(), "straße")  # lower would not have matched

    def test_folding_leaves_non_strings_alone(self):
        for value in (3, None, True, [1]):
            self.assertEqual(value, KeyComparison.ORDINAL_IGNORE_CASE.fold(value))

    def test_sort_field_defaults_to_ascending(self):
        self.assertFalse(SortField("/slug").descending)


if __name__ == "__main__":
    unittest.main()
