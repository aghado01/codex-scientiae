"""Normalized record and cross-provider identity contracts."""

from __future__ import annotations

import unittest

from pydantic import ValidationError

from procurement.domain.discovery import SearchRequest
from procurement.domain.deposits import (
    is_portable_leaf,
    validate_catalog_destination,
    validate_deposit_slug,
)
from procurement.domain.metadata import ArticleIdentifiers
from procurement.domain.works import (
    SourceReference,
    WorkRecord,
    merge_works,
)


def work(
    provider: str,
    identifier: str,
    *,
    doi: str | None = None,
    arxiv_id: str | None = None,
    title: str | None = None,
    abstract: str | None = None,
) -> WorkRecord:
    return WorkRecord(
        title=title,
        abstract=abstract,
        doi=doi,
        arxiv_id=arxiv_id,
        sources=(
            SourceReference(
                provider=provider,
                identifier=identifier,
                doi=doi,
                arxiv_id=arxiv_id,
            ),
        ),
    )


class TestWorkRecord(unittest.TestCase):
    def test_requires_provider_provenance(self) -> None:
        with self.assertRaises(ValidationError):
            WorkRecord(title="orphan", sources=())
        with self.assertRaises(ValidationError):
            SourceReference(provider=None, identifier="W1")
        with self.assertRaises(ValidationError):
            SourceReference(provider="   ", identifier="W1")

    def test_merge_preserves_every_provider_identity(self) -> None:
        left = work("openalex", "W1", doi="10.1/X", title="A paper")
        right = work(
            "semanticscholar",
            "P1",
            doi="https://doi.org/10.1/x",
            arxiv_id="2008.10579v2",
            abstract="A longer abstract.",
        )
        merged = left.merge(right)
        self.assertEqual(merged.doi, "10.1/x")
        self.assertEqual(merged.arxiv_id, "2008.10579v2")
        self.assertEqual(merged.title, "A paper")
        self.assertEqual(merged.abstract, "A longer abstract.")
        self.assertEqual(
            {(source.provider, source.identifier) for source in merged.sources},
            {("openalex", "W1"), ("semanticscholar", "P1")},
        )

    def test_dedup_handles_a_transitive_identifier_bridge(self) -> None:
        doi_only = work("openalex", "W1", doi="10.1/x")
        arxiv_only = work("arxiv", "2008.10579v1", arxiv_id="2008.10579v1")
        bridge = work("semanticscholar", "P1", doi="10.1/x", arxiv_id="2008.10579")
        merged = merge_works([doi_only, arxiv_only, bridge])
        self.assertEqual(len(merged), 1)
        self.assertEqual(len(merged[0].sources), 3)

    def test_source_crosswalks_are_promoted_into_known_identity_aliases(self) -> None:
        source_only = WorkRecord(
            title="Source-only crosswalk",
            sources=(
                SourceReference(
                    provider="catalog",
                    identifier="C1",
                    doi="10.1/source-only",
                    arxiv_id="2008.10579v2",
                ),
            ),
        )

        self.assertEqual(source_only.doi, "10.1/source-only")
        self.assertEqual(source_only.arxiv_id, "2008.10579v2")
        self.assertIn("doi:10.1/source-only", source_only.identity_aliases)
        self.assertIn("arxiv:2008.10579", source_only.identity_aliases)

    def test_conflicting_source_crosswalk_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValidationError, "conflicting DOI identities"):
            WorkRecord(
                doi="10.1/left",
                sources=(
                    SourceReference(
                        provider="catalog",
                        identifier="C1",
                        doi="10.1/right",
                    ),
                ),
            )

    def test_conflicting_crosswalks_remain_separate_during_federated_merge(self) -> None:
        left = work(
            "openalex",
            "W1",
            doi="10.1/left",
            arxiv_id="2008.10579",
        )
        right = work(
            "semanticscholar",
            "P1",
            doi="10.1/right",
            arxiv_id="2008.10579v2",
        )

        self.assertEqual(len(merge_works((left, right))), 2)
        with self.assertRaisesRegex(ValueError, "conflicting identity crosswalks"):
            left.merge(right)

        bridge = work("arxiv", "2008.10579v3", arxiv_id="2008.10579v3")
        bridged = merge_works((left, right, bridge))
        self.assertEqual(len(bridged), 2)
        self.assertEqual({record.doi for record in bridged}, {"10.1/left", "10.1/right"})

    def test_unrelated_records_cannot_be_merged_directly(self) -> None:
        with self.assertRaisesRegex(ValueError, "shared identity"):
            work("openalex", "W1").merge(work("openalex", "W2"))

    def test_public_mappings_are_immutable_and_deepcopy_stable(self) -> None:
        record = WorkRecord(
            external_ids={"doi": "10.1/x"},
            sources=(SourceReference(provider="openalex", identifier="W1"),),
        )
        identifiers = ArticleIdentifiers(external={"catalog": "C1"})

        with self.assertRaises(TypeError):
            record.external_ids["mutated"] = "yes"
        with self.assertRaises(TypeError):
            identifiers.external["mutated"] = "yes"
        self.assertEqual(record.model_copy(deep=True), record)
        self.assertEqual(identifiers.model_copy(deep=True), identifiers)


class TestSearchRequest(unittest.TestCase):
    def test_query_must_be_nonblank_text(self) -> None:
        for query in (None, "", "   "):
            with self.subTest(query=query), self.assertRaises(ValidationError):
                SearchRequest(query=query)


class TestDepositSlug(unittest.TestCase):
    def test_accepts_bounded_portable_unicode_leaves(self) -> None:
        for slug in ("paper", "résumé-v1", "a" * 255):
            with self.subTest(slug=slug):
                self.assertTrue(is_portable_leaf(slug))
                self.assertEqual(validate_deposit_slug(slug), slug)

    def test_rejects_every_nonportable_leaf_class(self) -> None:
        invalid = (
            None,
            "",
            ".",
            "..",
            "CON",
            "con.txt",
            "nested/paper",
            "nested\\paper",
            "paper.",
            "paper ",
            "paper\x00",
            "paper\x1f",
            "\ud800",
            "a" * 256,
            "é" * 128,
        )
        for slug in invalid:
            with self.subTest(slug=slug):
                self.assertFalse(is_portable_leaf(slug))
                with self.assertRaises(ValueError):
                    validate_deposit_slug(slug)


class TestCatalogDestination(unittest.TestCase):
    def test_accepts_a_configured_name_or_relative_workspace_path(self) -> None:
        self.assertEqual(validate_catalog_destination("inventory"), "inventory")
        self.assertEqual(
            validate_catalog_destination("ingestion/gauntlet/blahblah/"),
            "ingestion/gauntlet/blahblah",
        )

    def test_rejects_absolute_parent_and_backslash_destinations(self) -> None:
        invalid = (
            "",
            "/",
            "../outside",
            "ingestion\\gauntlet",
            "C:/ingestion",
            "ingestion/../inventory",
            "ingestion/CON",
        )
        for destination in invalid:
            with self.subTest(destination=destination):
                with self.assertRaises(ValueError):
                    validate_catalog_destination(destination)
