"""Identifier normalization contracts."""

from __future__ import annotations

import unittest

from procurement.errors import IdentifierError
from procurement.identifiers import (
    arxiv_identity,
    extract_doi,
    is_doi,
    is_arxiv_id,
    normalize_arxiv_id,
    normalize_doi,
    split_arxiv_id,
    split_zenodo_id,
)


class TestDoiIdentity(unittest.TestCase):
    def test_normalization_removes_resolver_forms(self) -> None:
        self.assertEqual(normalize_doi("https://doi.org/10.1234/ABC.def"), "10.1234/abc.def")
        self.assertEqual(normalize_doi("http://dx.doi.org/10.1/X"), "10.1/x")
        self.assertEqual(normalize_doi("doi:10.5/Y"), "10.5/y")
        self.assertIsNone(normalize_doi("   "))

    def test_extraction_trims_sentence_punctuation(self) -> None:
        self.assertEqual(extract_doi("See doi:10.1000/XYZ. in the bibliography"), "10.1000/xyz")

    def test_complete_shape_is_distinct_from_permissive_normalization(self) -> None:
        self.assertTrue(is_doi("https://doi.org/10.1000/XYZ"))
        self.assertFalse(is_doi("10.1/x"))
        self.assertFalse(is_doi("10.not-a-doi"))


class TestArxivIdentity(unittest.TestCase):
    def test_modern_legacy_url_and_version_forms(self) -> None:
        self.assertTrue(is_arxiv_id("2008.10579v3"))
        self.assertTrue(is_arxiv_id("math.GT/0309136"))
        self.assertEqual(normalize_arxiv_id("https://arxiv.org/pdf/2008.10579v3.pdf"), "2008.10579v3")
        parts = split_arxiv_id("2008.10579v3")
        self.assertEqual((parts.versionless, parts.versioned, parts.version), ("2008.10579", "2008.10579v3", 3))
        self.assertEqual(arxiv_identity("2008.10579V3"), "2008.10579")

    def test_invalid_identifier_is_rejected(self) -> None:
        self.assertFalse(is_arxiv_id("../etc/passwd"))
        self.assertFalse(is_arxiv_id("2008.10579v0"))
        self.assertFalse(is_arxiv_id("2013.10579v1"))
        self.assertFalse(is_arxiv_id("math.GT/0313136"))
        with self.assertRaises(IdentifierError):
            split_arxiv_id("not an id")


class TestZenodoIdentity(unittest.TestCase):
    def test_record_shorthand_and_doi_converge(self) -> None:
        expected = split_zenodo_id("1234567")
        self.assertEqual(split_zenodo_id("zenodo.1234567"), expected)
        self.assertEqual(split_zenodo_id("10.5281/zenodo.1234567"), expected)
        self.assertEqual(
            split_zenodo_id("https://doi.org/10.5281/zenodo.1234567"),
            expected,
        )
        self.assertEqual(
            split_zenodo_id("https://zenodo.org/records/1234567"),
            expected,
        )
        self.assertEqual(expected.slug, "zenodo_1234567")

    def test_record_ids_are_positive_and_canonicalized(self) -> None:
        self.assertEqual(split_zenodo_id("000123").record_id, "123")
        self.assertEqual(split_zenodo_id("000123").slug, "zenodo_123")
        with self.assertRaises(IdentifierError):
            split_zenodo_id("0")
