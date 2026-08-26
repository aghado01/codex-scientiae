"""Provider-role and API metadata fallback contracts."""

from __future__ import annotations

import asyncio
import base64
import hashlib
import unittest
from datetime import datetime, timezone

from pydantic import ValidationError

from procurement.errors import MetadataUnavailableError, ProviderError
from procurement.domain.metadata import (
    ApiResponseEvidence,
    ArtifactReference,
    DepositMetadataBundle,
    RetrievedMetadata,
)
from procurement.domain.works import (
    SourceReference,
    WorkRecord,
)
from procurement.providers.base import Capability, ProviderRole
from procurement.providers.catalog import ProviderBinding, ProviderCatalog
from procurement.operations.metadata import MetadataService
from procurement.storage.schemas import get_procurement_schema_catalog


def metadata_result(provider: str, work: WorkRecord, body: bytes) -> RetrievedMetadata:
    return RetrievedMetadata(
        work=work,
        response=ApiResponseEvidence(
            url=f"https://{provider}.example/record",
            media_type="application/json",
            fetched_at=datetime(2026, 8, 11, tzinfo=timezone.utc),
            sha256=hashlib.sha256(body).hexdigest(),
            body_base64=base64.b64encode(body).decode("ascii"),
        ),
    )


def work(
    provider: str,
    identifier: str,
    *,
    doi: str | None = None,
    arxiv_id: str | None = None,
    categories: tuple[str, ...] = (),
    concepts: tuple[str, ...] = (),
) -> WorkRecord:
    return WorkRecord(
        title=f"Metadata from {provider}",
        doi=doi,
        arxiv_id=arxiv_id,
        categories=categories,
        concepts=concepts,
        sources=(
            SourceReference(
                provider=provider,
                identifier=identifier,
                doi=doi,
                arxiv_id=arxiv_id,
            ),
        ),
    )


class FakeMetadataProvider:
    def __init__(
        self,
        name: str,
        result: RetrievedMetadata | None = None,
        failure: Exception | None = None,
    ) -> None:
        self.name = name
        self.result = result
        self.failure = failure
        self.identifiers: list[str] = []

    async def get_metadata(self, identifier: str) -> RetrievedMetadata:
        self.identifiers.append(identifier)
        if self.failure:
            raise self.failure
        assert self.result is not None
        return self.result


class DeclaredProvider:
    def __init__(self, name: str) -> None:
        self.name = name


class CancelledMetadataProvider:
    name = "arxiv"

    async def get_metadata(self, identifier: str) -> RetrievedMetadata:
        raise asyncio.CancelledError


AUTHORITY_ROLES = frozenset(
    {
        ProviderRole.ARTIFACT_ORIGIN,
        ProviderRole.ARTIFACT_ACCESS,
        ProviderRole.METADATA_AUTHORITY,
    }
)
AGGREGATOR_ROLES = frozenset({ProviderRole.METADATA_AGGREGATOR})


class TestMetadataService(unittest.TestCase):
    def test_procurement_catalog_layers_application_schemas_over_engine_schemas(self) -> None:
        catalog = get_procurement_schema_catalog()

        self.assertTrue(catalog.has_schema("article.schema.json"))
        self.assertTrue(catalog.has_schema("acquisition.schema.json"))
        self.assertTrue(catalog.has_schema("deposit.metadata.schema.json"))

    def test_provider_cancellation_is_never_converted_to_a_fallback_attempt(self) -> None:
        cancelled = CancelledMetadataProvider()
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(
                        cancelled,
                        frozenset({Capability.METADATA}),
                        AUTHORITY_ROLES,
                    )
                ]
            ),
            ("unused",),
        )

        with self.assertRaises(asyncio.CancelledError):
            asyncio.run(
                service.collect(
                    deposit_slug="2008.10579v1",
                    artifact_provider="arxiv",
                    identifier="2008.10579v1",
                    fallback_sources=(),
                )
            )

    def test_artifact_authority_wins_without_querying_aggregator(self) -> None:
        arxiv = FakeMetadataProvider(
            "arxiv",
            metadata_result(
                "arxiv",
                work(
                    "arxiv",
                    "2008.10579v2",
                    arxiv_id="2008.10579v2",
                    categories=("math.OC",),
                ),
                b"<feed>authority</feed>",
            ),
        )
        openalex = FakeMetadataProvider("openalex", failure=AssertionError("must not run"))
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(arxiv, frozenset({Capability.METADATA}), AUTHORITY_ROLES),
                    ProviderBinding(
                        openalex,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("openalex",),
        )

        result = asyncio.run(
            service.collect(
                deposit_slug="2008.10579v2",
                artifact_provider="arxiv",
                identifier="2008.10579v2",
            )
        )

        self.assertEqual(result.route, "artifact-provider")
        self.assertEqual(result.selected.provider, "arxiv")
        self.assertEqual(result.article.identifiers.arxiv, "2008.10579")
        self.assertEqual(result.article.identifiers.arxiv_versioned, "2008.10579v2")
        self.assertEqual(result.article.categories, ("math.OC",))
        self.assertEqual(openalex.identifiers, [])

        tampered = result.model_dump(mode="json", by_alias=True)
        tampered["article"]["title"] = "Unwitnessed title"
        with self.assertRaisesRegex(ValidationError, "article projection does not match"):
            DepositMetadataBundle.model_validate(tampered)

        unpinned = result.model_dump(mode="json", by_alias=True)
        unpinned["deposit_slug"] = "2008.10579"
        unpinned["artifact"]["identifier"] = "2008.10579"
        with self.assertRaisesRegex(ValidationError, "versioned identifier"):
            DepositMetadataBundle.model_validate(unpinned)

        legacy = result.model_dump(mode="json", by_alias=True)
        del legacy["identity_anchor"]
        self.assertIsNone(DepositMetadataBundle.model_validate(legacy).identity_anchor)

    def test_aggregator_fallback_preserves_concepts_without_fabricating_categories(self) -> None:
        arxiv = FakeMetadataProvider("arxiv", failure=ProviderError("Atom unavailable"))
        semantic = FakeMetadataProvider(
            "semanticscholar",
            metadata_result(
                "semanticscholar",
                work(
                    "semanticscholar",
                    "P1",
                    arxiv_id="2008.10579",
                    concepts=("Optimization",),
                ),
                b'{"paperId":"P1"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(arxiv, frozenset({Capability.METADATA}), AUTHORITY_ROLES),
                    ProviderBinding(
                        semantic,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("semanticscholar",),
        )

        result = asyncio.run(
            service.collect(
                deposit_slug="2008.10579v1",
                artifact_provider="arxiv",
                identifier="2008.10579v1",
            )
        )

        self.assertEqual(result.route, "aggregator-fallback")
        self.assertEqual([attempt.status for attempt in result.attempts], ["error", "ok"])
        self.assertEqual(semantic.identifiers, ["arxiv:2008.10579"])
        self.assertEqual(result.article.categories, ())
        self.assertEqual(result.article.concepts, ("Optimization",))

        missing_authority_attempt = result.model_dump(mode="json", by_alias=True)
        missing_authority_attempt["attempts"] = missing_authority_attempt["attempts"][1:]
        with self.assertRaisesRegex(ValidationError, "must begin with the artifact provider"):
            DepositMetadataBundle.model_validate(missing_authority_attempt)

        success_before_failure = result.model_dump(mode="json", by_alias=True)
        success_before_failure["attempts"].reverse()
        with self.assertRaisesRegex(ValidationError, "must begin with the artifact provider"):
            DepositMetadataBundle.model_validate(success_before_failure)

    def test_openalex_fallback_for_arxiv(self) -> None:
        arxiv = FakeMetadataProvider("arxiv", failure=ProviderError("Atom unavailable"))
        openalex = FakeMetadataProvider(
            "openalex",
            metadata_result(
                "openalex",
                work(
                    "openalex",
                    "W123",
                    arxiv_id="2008.10579",
                    concepts=("Optimization",),
                ),
                b'{"id":"W123"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(arxiv, frozenset({Capability.METADATA}), AUTHORITY_ROLES),
                    ProviderBinding(
                        openalex,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("openalex",),
        )

        result = asyncio.run(
            service.collect(
                deposit_slug="2008.10579v1",
                artifact_provider="arxiv",
                identifier="2008.10579v1",
            )
        )

        self.assertEqual(result.route, "aggregator-fallback")
        self.assertEqual(openalex.identifiers, ["arxiv:2008.10579"])

    def test_access_only_provider_uses_doi_aggregator_fallback(self) -> None:
        scihub = DeclaredProvider("scihub")
        semantic = FakeMetadataProvider(
            "semanticscholar",
            metadata_result(
                "semanticscholar",
                work("semanticscholar", "P1", doi="10.1000/example"),
                b'{"paperId":"P1"}',
            ),
        )
        catalog = ProviderCatalog(
            [
                ProviderBinding(
                    scihub,
                    frozenset(),
                    frozenset({ProviderRole.ARTIFACT_ACCESS}),
                ),
                ProviderBinding(
                    semantic,
                    frozenset({Capability.METADATA}),
                    AGGREGATOR_ROLES,
                ),
            ]
        )
        service = MetadataService(catalog, ("semanticscholar",))

        result = asyncio.run(
            service.collect(
                deposit_slug="doi-example",
                artifact_provider="scihub",
                identifier="https://doi.org/10.1000/EXAMPLE",
            )
        )

        self.assertEqual(result.route, "aggregator-fallback")
        self.assertEqual([attempt.status for attempt in result.attempts], ["not-supported", "ok"])
        self.assertEqual(semantic.identifiers, ["doi:10.1000/example"])
        roles = {provider.name: provider.roles for provider in catalog.describe()}
        self.assertEqual(roles["scihub"], ("artifact-access",))
        self.assertEqual(roles["semanticscholar"], ("metadata-aggregator",))

        with self.assertRaisesRegex(ValueError, "complete DOI"):
            asyncio.run(
                service.collect(
                    deposit_slug="invalid-doi",
                    artifact_provider="scihub",
                    identifier="10.not-a-doi",
                )
            )
        self.assertEqual(semantic.identifiers, ["doi:10.1000/example"])

    def test_identity_mismatch_is_rejected_as_a_failed_fallback(self) -> None:
        scihub = DeclaredProvider("scihub")
        wrong = FakeMetadataProvider(
            "openalex",
            metadata_result(
                "openalex",
                work("openalex", "W2", doi="10.1000/wrong"),
                b'{"id":"W2"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(
                        scihub,
                        frozenset(),
                        frozenset({ProviderRole.ARTIFACT_ACCESS}),
                    ),
                    ProviderBinding(
                        wrong,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("openalex",),
        )

        with self.assertRaisesRegex(MetadataUnavailableError, "do not match artifact identities"):
            asyncio.run(
                service.collect(
                    deposit_slug="doi-example",
                    artifact_provider="scihub",
                    identifier="10.1000/example",
                )
            )

    def test_access_only_provider_is_not_queried_as_a_metadata_authority(self) -> None:
        scihub = FakeMetadataProvider("scihub", failure=AssertionError("must not run"))
        semantic = FakeMetadataProvider(
            "semanticscholar",
            metadata_result(
                "semanticscholar",
                work("semanticscholar", "P1", doi="10.1000/example"),
                b'{"paperId":"P1"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(
                        scihub,
                        frozenset({Capability.METADATA}),
                        frozenset({ProviderRole.ARTIFACT_ACCESS}),
                    ),
                    ProviderBinding(
                        semantic,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("semanticscholar",),
        )

        result = asyncio.run(
            service.collect(
                deposit_slug="doi-example",
                artifact_provider="scihub",
                identifier="10.1000/example",
            )
        )

        self.assertEqual(result.route, "aggregator-fallback")
        self.assertEqual([attempt.status for attempt in result.attempts], ["not-supported", "ok"])
        self.assertEqual(scihub.identifiers, [])

    def test_arxiv_authority_version_mismatch_uses_identity_checked_fallback(self) -> None:
        arxiv = FakeMetadataProvider(
            "arxiv",
            metadata_result(
                "arxiv",
                work("arxiv", "2008.10579v1", arxiv_id="2008.10579v1"),
                b"<feed>wrong-version</feed>",
            ),
        )
        semantic = FakeMetadataProvider(
            "semanticscholar",
            metadata_result(
                "semanticscholar",
                work("semanticscholar", "P1", arxiv_id="2008.10579"),
                b'{"paperId":"P1"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(arxiv, frozenset({Capability.METADATA}), AUTHORITY_ROLES),
                    ProviderBinding(
                        semantic,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("semanticscholar",),
        )

        result = asyncio.run(
            service.collect(
                deposit_slug="2008.10579v2",
                artifact_provider="arxiv",
                identifier="2008.10579v2",
            )
        )

        self.assertEqual(result.selected.provider, "semanticscholar")
        self.assertEqual([attempt.status for attempt in result.attempts], ["error", "ok"])
        self.assertIn("returned '2008.10579v1'", result.attempts[0].error)

    def test_explicit_empty_fallback_list_disables_configured_aggregators(self) -> None:
        arxiv = FakeMetadataProvider("arxiv", failure=ProviderError("authority unavailable"))
        semantic = FakeMetadataProvider(
            "semanticscholar",
            metadata_result(
                "semanticscholar",
                work("semanticscholar", "P1", arxiv_id="2008.10579"),
                b'{"paperId":"P1"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(arxiv, frozenset({Capability.METADATA}), AUTHORITY_ROLES),
                    ProviderBinding(
                        semantic,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("semanticscholar",),
        )

        with self.assertRaisesRegex(MetadataUnavailableError, "authority unavailable"):
            asyncio.run(
                service.collect(
                    deposit_slug="2008.10579v1",
                    artifact_provider="arxiv",
                    identifier="2008.10579v1",
                    fallback_sources=(),
                )
            )
        self.assertEqual(semantic.identifiers, [])

    def test_invalid_or_unpinned_deposit_identity_fails_before_provider_io(self) -> None:
        arxiv = FakeMetadataProvider(
            "arxiv",
            metadata_result(
                "arxiv",
                work("arxiv", "2008.10579v1", arxiv_id="2008.10579v1"),
                b"<feed />",
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [ProviderBinding(arxiv, frozenset({Capability.METADATA}), AUTHORITY_ROLES)]
            ),
            ("missing-fallback-is-not-resolved-for-invalid-input",),
        )

        with self.assertRaisesRegex(ValueError, "portable directory leaf"):
            asyncio.run(
                service.collect(
                    deposit_slug="../escape",
                    artifact_provider="arxiv",
                    identifier="2008.10579v1",
                )
            )
        with self.assertRaisesRegex(ValueError, "versioned identifier"):
            asyncio.run(
                service.collect(
                    deposit_slug="2008.10579",
                    artifact_provider="arxiv",
                    identifier="2008.10579",
                )
            )
        with self.assertRaisesRegex(ValueError, "invalid arXiv identifier"):
            asyncio.run(
                service.collect(
                    deposit_slug="2008.10579v0",
                    artifact_provider="arxiv",
                    identifier="2008.10579v0",
                )
            )
        self.assertEqual(arxiv.identifiers, [])

    def test_zenodo_identifier_is_canonicalized_before_provider_io(self) -> None:
        zenodo = FakeMetadataProvider(
            "zenodo",
            metadata_result(
                "zenodo",
                work(
                    "zenodo",
                    "123",
                    doi="10.5281/zenodo.123",
                    concepts=("dataset",),
                ),
                b'{"id":123}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [ProviderBinding(zenodo, frozenset({Capability.METADATA}), AUTHORITY_ROLES)]
            ),
            ("unused",),
        )

        result = asyncio.run(
            service.collect(
                deposit_slug="zenodo_123",
                artifact_provider="zenodo",
                identifier="000123",
                fallback_sources=(),
            )
        )
        self.assertEqual(result.artifact.identifier, "123")
        self.assertEqual(zenodo.identifiers, ["123"])

        with self.assertRaisesRegex(ValueError, "must match artifact 'zenodo_123'"):
            asyncio.run(
                service.collect(
                    deposit_slug="zenodo_000123",
                    artifact_provider="zenodo",
                    identifier="000123",
                    fallback_sources=(),
                )
            )
        self.assertEqual(zenodo.identifiers, ["123"])

    def test_explicit_doi_uses_ordered_aggregators_independently_of_artifact(self) -> None:
        wrong = FakeMetadataProvider(
            "openalex",
            metadata_result(
                "openalex",
                work("openalex", "W-wrong", doi="10.1000/wrong"),
                b'{"id":"W-wrong"}',
            ),
        )
        semantic = FakeMetadataProvider(
            "semanticscholar",
            metadata_result(
                "semanticscholar",
                work(
                    "semanticscholar",
                    "P1",
                    doi="10.1000/example",
                    arxiv_id="2008.10579",
                    categories=("untrusted.category",),
                    concepts=("Optimization",),
                ),
                b'{"paperId":"P1"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(
                        wrong,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                    ProviderBinding(
                        semantic,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("openalex", "semanticscholar"),
        )
        artifact = ArtifactReference(
            provider="manual-import",
            identifier="sha256:abc123",
            provider_roles=("artifact-access",),
        )

        result = asyncio.run(
            service.collect_by_doi(
                deposit_slug="manual-paper",
                artifact=artifact,
                doi="https://doi.org/10.1000/EXAMPLE",
            )
        )

        self.assertEqual(result.route, "identifier-aggregator")
        self.assertEqual(result.artifact, artifact)
        self.assertIsNotNone(result.identity_anchor)
        assert result.identity_anchor is not None
        self.assertEqual(result.identity_anchor.kind, "doi")
        self.assertEqual(result.identity_anchor.value, "10.1000/example")
        self.assertEqual(result.identity_anchor.supplied_by, "caller")
        self.assertEqual([item.status for item in result.attempts], ["error", "ok"])
        self.assertIn("do not match DOI identity", result.attempts[0].error or "")
        self.assertEqual(wrong.identifiers, ["doi:10.1000/example"])
        self.assertEqual(semantic.identifiers, ["doi:10.1000/example"])
        self.assertEqual(result.article.identifiers.doi, "10.1000/example")
        self.assertEqual(result.article.identifiers.arxiv, "2008.10579")
        self.assertEqual(result.article.categories, ())
        self.assertEqual(result.article.concepts, ("Optimization",))
        get_procurement_schema_catalog().get_validator(
            "deposit.metadata.schema.json"
        ).validate(
            result.model_dump(mode="json", by_alias=True)
        )

    def test_explicit_doi_rejects_empty_or_nonaggregator_fallbacks_before_io(self) -> None:
        authority = FakeMetadataProvider(
            "arxiv",
            failure=AssertionError("identifier route must not query an authority"),
        )
        semantic = FakeMetadataProvider(
            "semanticscholar",
            metadata_result(
                "semanticscholar",
                work("semanticscholar", "P1", doi="10.1000/example"),
                b'{"paperId":"P1"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(
                        authority,
                        frozenset({Capability.METADATA}),
                        AUTHORITY_ROLES,
                    ),
                    ProviderBinding(
                        semantic,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    ),
                ]
            ),
            ("semanticscholar",),
        )
        artifact = ArtifactReference(
            provider="manual-import",
            identifier="sha256:abc123",
            provider_roles=("artifact-access",),
        )

        with self.assertRaisesRegex(MetadataUnavailableError, "no metadata aggregator was selected"):
            asyncio.run(
                service.collect_by_doi(
                    deposit_slug="manual-paper",
                    artifact=artifact,
                    doi="10.1000/example",
                    fallback_sources=(),
                )
            )
        with self.assertRaisesRegex(ValueError, "is not a metadata aggregator"):
            asyncio.run(
                service.collect_by_doi(
                    deposit_slug="manual-paper",
                    artifact=artifact,
                    doi="10.1000/example",
                    fallback_sources=("arxiv",),
                )
            )
        self.assertEqual(authority.identifiers, [])
        self.assertEqual(semantic.identifiers, [])

    def test_identifier_bundle_rejects_anchor_and_projection_tampering(self) -> None:
        semantic = FakeMetadataProvider(
            "semanticscholar",
            metadata_result(
                "semanticscholar",
                work("semanticscholar", "P1", doi="10.1000/example"),
                b'{"paperId":"P1"}',
            ),
        )
        service = MetadataService(
            ProviderCatalog(
                [
                    ProviderBinding(
                        semantic,
                        frozenset({Capability.METADATA}),
                        AGGREGATOR_ROLES,
                    )
                ]
            ),
            ("semanticscholar",),
        )
        artifact = ArtifactReference(
            provider="manual-import",
            identifier="sha256:abc123",
            provider_roles=("artifact-access",),
        )
        result = asyncio.run(
            service.collect_by_doi(
                deposit_slug="manual-paper",
                artifact=artifact,
                doi="10.1000/example",
            )
        )

        wrong_anchor = result.model_dump(mode="json", by_alias=True)
        wrong_anchor["identity_anchor"]["value"] = "10.1000/other"
        with self.assertRaisesRegex(ValidationError, "does not identify the identity anchor"):
            DepositMetadataBundle.model_validate(wrong_anchor)

        missing_anchor = result.model_dump(mode="json", by_alias=True)
        del missing_anchor["identity_anchor"]
        with self.assertRaisesRegex(ValidationError, "requires an identity anchor"):
            DepositMetadataBundle.model_validate(missing_anchor)

        wrong_projection = result.model_dump(mode="json", by_alias=True)
        wrong_projection["article"]["title"] = "Unwitnessed title"
        with self.assertRaisesRegex(ValidationError, "article projection does not match"):
            DepositMetadataBundle.model_validate(wrong_projection)
