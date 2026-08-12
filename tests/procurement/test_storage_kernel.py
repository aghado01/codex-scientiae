"""Configured-root ownership and procurement JSON document kinds."""

from __future__ import annotations

import base64
import hashlib
import json
import os
import tempfile
import unittest
from datetime import datetime, timezone

from jsonl_engine.documents import JsonDocumentError, JsonDocumentStore

from procurement.domain.metadata import (
    ApiResponseEvidence,
    ArtifactReference,
    DepositMetadataBundle,
    MetadataAttempt,
    MetadataObservation,
    project_article_metadata,
)
from procurement.domain.works import (
    SourceReference,
    WorkRecord,
)
from procurement.payloads import (
    AcquiredArtifact,
    AcquisitionManifest,
    LocalImportProvenance,
)
from procurement.storage.catalogs import ArticleCatalogRoots
from procurement.storage.documents import (
    AcquisitionManifestDocument,
    DepositMetadataDocument,
)
from procurement.storage.roots import (
    ConfiguredRootError,
    ConfiguredRootKind,
    ProcurementRootCatalog,
)

NOW = datetime(2026, 8, 12, 12, 0, tzinfo=timezone.utc)
SLUG = "2008.10579v1"
ROLES = ("artifact-origin", "artifact-access", "metadata-authority")


def open_roots(parent: str) -> ProcurementRootCatalog:
    paths = {
        "staging": os.path.join(parent, "staging"),
        "catalog": os.path.join(parent, "catalog"),
        "inbox": os.path.join(parent, "inbox"),
    }
    for path in paths.values():
        os.mkdir(path)
    return ProcurementRootCatalog(
        paths["staging"],
        article_catalogs={"Research": paths["catalog"]},
        local_inboxes={"manual": paths["inbox"]},
    ).open()


def acquisition_manifest() -> AcquisitionManifest:
    body = b"source"
    return AcquisitionManifest(
        slug=SLUG,
        artifact=ArtifactReference(
            provider="manual-import",
            identifier=SLUG,
            provider_roles=("artifact-access",),
        ),
        forms=(
            AcquiredArtifact(
                kind="source",
                path=f"{SLUG}.tar.gz",
                format="application/gzip",
                bytes=len(body),
                sha256=hashlib.sha256(body).hexdigest(),
                custody="local-import",
                local_import=LocalImportProvenance(
                    inbox="manual",
                    leaf="paper.tar.gz",
                    imported_at=NOW,
                ),
            ),
        ),
    )


def metadata_bundle() -> DepositMetadataBundle:
    response_body = b"<feed><entry>metadata</entry></feed>"
    artifact = ArtifactReference(
        provider="arxiv",
        identifier=SLUG,
        provider_roles=ROLES,
    )
    work = WorkRecord(
        title="Pinned metadata",
        authors=("Ada Example",),
        arxiv_id=SLUG,
        categories=("math.OC",),
        sources=(
            SourceReference(provider="arxiv", identifier=SLUG, arxiv_id=SLUG),
        ),
    )
    observation = MetadataObservation(
        provider="arxiv",
        provider_roles=ROLES,
        work=work,
        response=ApiResponseEvidence(
            url=f"https://export.arxiv.org/api/query?id_list={SLUG}",
            media_type="application/atom+xml",
            fetched_at=NOW,
            sha256=hashlib.sha256(response_body).hexdigest(),
            body_base64=base64.b64encode(response_body).decode("ascii"),
        ),
    )
    return DepositMetadataBundle(
        deposit_slug=SLUG,
        artifact=artifact,
        route="artifact-provider",
        selected=observation,
        attempts=(MetadataAttempt(provider="arxiv", status="ok"),),
        article=project_article_metadata(
            "arxiv",
            SLUG,
            work,
            preserve_categories=True,
        ),
    )


class TestProcurementRootCatalog(unittest.TestCase):
    def test_catalog_retains_one_identity_for_every_configured_root(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            roots = open_roots(parent)
            try:
                self.assertTrue(roots.is_open)
                self.assertEqual(3, len(roots.descriptors()))
                roots.assert_current()
                staging = roots.staging
                self.assertTrue(staging.publication_root.is_active)
                self.assertEqual(staging.identity, staging.publication_root.identity)
                article = roots.resolve(ConfiguredRootKind.ARTICLE_CATALOG, "research")
                self.assertEqual("Research", article.name)
                view = ArticleCatalogRoots(roots).resolve("RESEARCH")
                self.assertEqual(article.identity, view.identity)
                self.assertIs(article.publication_root, view.publication_root)
            finally:
                roots.close()
            self.assertFalse(roots.is_open)
            self.assertFalse(staging.publication_root.is_active)
            with self.assertRaisesRegex(ConfiguredRootError, "not open"):
                roots.resolve(ConfiguredRootKind.ARTICLE_CATALOG, "Research")

    def test_close_is_idempotent_and_releases_the_windows_route(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            roots = open_roots(parent)
            staging = roots.staging.path
            roots.close()
            roots.close()
            retired = staging + "-retired"
            os.rename(staging, retired)
            self.assertTrue(os.path.isdir(retired))

    def test_root_namespaces_reject_case_collisions(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            staging = os.path.join(parent, "staging")
            first = os.path.join(parent, "first")
            second = os.path.join(parent, "second")
            inbox = os.path.join(parent, "inbox")
            for path in (staging, first, second, inbox):
                os.mkdir(path)
            with self.assertRaisesRegex(ConfiguredRootError, "case collision"):
                ProcurementRootCatalog(
                    staging,
                    article_catalogs={"Corpus": first, "corpus": second},
                    local_inboxes={"manual": inbox},
                )

    def test_distinct_roles_cannot_alias_one_root(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            staging = os.path.join(parent, "staging")
            catalog = os.path.join(parent, "catalog")
            for path in (staging, catalog):
                os.mkdir(path)
            with self.assertRaisesRegex(ConfiguredRootError, "must not alias"):
                ProcurementRootCatalog(
                    staging,
                    article_catalogs={"primary": catalog},
                    local_inboxes={"manual": catalog},
                )

    def test_failed_open_releases_roots_opened_before_the_failure(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            staging = os.path.join(parent, "staging")
            catalog = os.path.join(parent, "catalog")
            missing = os.path.join(parent, "missing")
            os.mkdir(staging)
            os.mkdir(catalog)
            roots = ProcurementRootCatalog(
                staging,
                article_catalogs={"primary": catalog},
                local_inboxes={"manual": missing},
            )
            with self.assertRaises(OSError):
                roots.open()
            self.assertFalse(roots.is_open)
            retired = staging + "-retired"
            os.rename(staging, retired)
            self.assertTrue(os.path.isdir(retired))


class TestProcurementDocumentKinds(unittest.TestCase):
    def test_acquisition_kind_uses_procurement_schema_and_domain_model(self) -> None:
        manifest = acquisition_manifest()
        kind = AcquisitionManifestDocument()
        raw = kind.dumps(manifest, path="acquisition.json")
        decoded = kind.loads(raw, path="acquisition.json")
        self.assertEqual(manifest, decoded)
        self.assertEqual(
            "codex-scientiae/acquisition/0.1",
            json.loads(raw)["schema"],
        )

    def test_deposit_metadata_kind_uses_engine_owned_schema_and_domain_model(self) -> None:
        bundle = metadata_bundle()
        kind = DepositMetadataDocument()
        raw = kind.dumps(bundle, path=f"{SLUG}.api-metadata.json")
        self.assertEqual(bundle, kind.loads(raw, path=f"{SLUG}.api-metadata.json"))

    def test_document_store_publishes_through_the_application_root_pin(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            roots = open_roots(parent)
            try:
                store = JsonDocumentStore(
                    roots.staging.publication_root,
                    "acquisition.json",
                    AcquisitionManifestDocument(),
                )
                manifest = acquisition_manifest()
                store.publish(manifest)
                self.assertEqual(manifest, store.require())
            finally:
                roots.close()

    def test_static_schema_rejection_precedes_domain_coercion(self) -> None:
        kind = AcquisitionManifestDocument()
        payload = acquisition_manifest().model_dump(mode="json", by_alias=True)
        payload["forms"][0]["bytes"] = "6"
        raw = json.dumps(payload, separators=(",", ":")).encode("utf-8")
        with self.assertRaisesRegex(JsonDocumentError, "schema validation"):
            kind.loads(raw, path="acquisition.json")


if __name__ == "__main__":
    unittest.main()
