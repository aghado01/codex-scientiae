"""Lock-step procure sequences acquire then materialize at one destination."""

from __future__ import annotations

import asyncio
import unittest
from datetime import datetime, timezone

from pydantic import ValidationError

from procurement.domain.acquisition.receipts import (
    AcquiredArtifact,
    AcquisitionManifest,
    AcquisitionOutcome,
    AcquisitionResult,
)
from procurement.domain.materialization import (
    ArtifactIdentityMetadata,
    SourceMaterializationRequest,
    SourceMaterializationResult,
)
from procurement.domain.metadata import ArtifactReference
from procurement.domain.procure import ProcureRequest
from procurement.errors import ProcureError
from procurement.operations.procure import ProcureService


NOW = datetime(2026, 8, 20, 12, 0, tzinfo=timezone.utc)
SLUG = "2008.10579v1"
ROLES = ("artifact-origin", "artifact-access", "metadata-authority")


def artifact() -> ArtifactReference:
    return ArtifactReference(provider="arxiv", identifier=SLUG, provider_roles=ROLES)


def acquisition_result(*, with_source: bool = True) -> AcquisitionResult:
    forms = ()
    outcomes = (
        AcquisitionOutcome(kind="pdf", status="unavailable", error="no pdf"),
    )
    if with_source:
        source = AcquiredArtifact(
            kind="source",
            path=f"arXiv-{SLUG}.tar.gz",
            format="application/gzip",
            bytes=4,
            sha256="a" * 64,
            origin_url=f"https://export.arxiv.org/src/{SLUG}",
            candidate_id="arxiv-export-eprint",
            fetched_at=NOW,
        )
        forms = (source,)
        outcomes = (
            AcquisitionOutcome(kind="source", status="acquired", path=source.path),
            AcquisitionOutcome(kind="pdf", status="unavailable", error="no pdf"),
        )
    manifest = (
        AcquisitionManifest(slug=SLUG, artifact=artifact(), forms=forms)
        if with_source
        else None
    )
    return AcquisitionResult(
        staging_directory=f"D:/catalog/{SLUG}",
        manifest_path=f"D:/catalog/{SLUG}/acquisition.json" if with_source else None,
        manifest=manifest,
        outcomes=outcomes,
    )


def materialization_result() -> SourceMaterializationResult:
    return SourceMaterializationResult(
        catalog="inventory",
        slug=SLUG,
        status="deposited",
        created=True,
        artifact=artifact(),
        acquisition_manifest_path=f"D:/catalog/{SLUG}/acquisition.json",
        document_directory=f"D:/catalog/{SLUG}",
        article_path=f"D:/catalog/{SLUG}/article.json",
        archive_path=f"D:/catalog/{SLUG}/arXiv-{SLUG}.tar.gz",
        source_path=f"D:/catalog/{SLUG}/{SLUG}-tex",
        metadata_path=f"D:/catalog/{SLUG}/{SLUG}.api-metadata.json",
        archive_sha256="a" * 64,
        tree_sha256="b" * 64,
        archive_kind="tar+gzip",
        entrypoint="main.tex",
        metadata_route="artifact-provider",
    )


class RecordingAcquisition:
    def __init__(self, result: AcquisitionResult) -> None:
        self.result = result
        self.requests: list[object] = []

    async def acquire(self, request: object) -> AcquisitionResult:
        self.requests.append(request)
        return self.result


class RecordingMaterialization:
    def __init__(self) -> None:
        self.requests: list[SourceMaterializationRequest] = []

    async def materialize(
        self, request: SourceMaterializationRequest
    ) -> SourceMaterializationResult:
        self.requests.append(request)
        return materialization_result()


class TestProcureRequest(unittest.TestCase):
    def test_defaults_source_and_pdf_and_requires_a_destination(self) -> None:
        request = ProcureRequest(provider="arxiv", identifier=SLUG, catalog="inventory")
        self.assertEqual(request.artifacts, ("source", "pdf", "html"))
        self.assertIsInstance(request.metadata, ArtifactIdentityMetadata)
        with self.assertRaises(ValidationError):
            ProcureRequest(provider="arxiv", identifier=SLUG, catalog="")


class TestProcureService(unittest.TestCase):
    def test_acquire_then_materialize_at_the_same_destination(self) -> None:
        acquisition = RecordingAcquisition(acquisition_result())
        materialization = RecordingMaterialization()
        result = asyncio.run(
            ProcureService(acquisition, materialization).procure(  # type: ignore[arg-type]
                ProcureRequest(
                    provider="arxiv",
                    identifier=SLUG,
                    catalog="supellex/gauntlet/topic",
                )
            )
        )
        self.assertEqual(acquisition.requests[0].catalog, "supellex/gauntlet/topic")
        self.assertEqual(acquisition.requests[0].artifacts, ("source", "pdf", "html"))
        self.assertEqual(materialization.requests[0].catalog, "supellex/gauntlet/topic")
        self.assertEqual(materialization.requests[0].acquisition_slug, SLUG)
        self.assertEqual(result.materialization.status, "deposited")
        self.assertEqual(result.acquisition.manifest.slug, SLUG)

    def test_refuses_procure_without_a_source_artifact(self) -> None:
        with self.assertRaisesRegex(ProcureError, "source artifact"):
            asyncio.run(
                ProcureService(
                    RecordingAcquisition(acquisition_result()),
                    RecordingMaterialization(),
                ).procure(  # type: ignore[arg-type]
                    ProcureRequest(
                        provider="arxiv",
                        identifier=SLUG,
                        catalog="inventory",
                        artifacts=("pdf",),
                    )
                )
            )

    def test_does_not_materialize_when_source_was_not_receipted(self) -> None:
        materialization = RecordingMaterialization()
        with self.assertRaisesRegex(ProcureError, "did not receipt a source form"):
            asyncio.run(
                ProcureService(
                    RecordingAcquisition(acquisition_result(with_source=False)),
                    materialization,
                ).procure(  # type: ignore[arg-type]
                    ProcureRequest(provider="arxiv", identifier=SLUG, catalog="inventory")
                )
            )
        self.assertEqual(materialization.requests, [])
