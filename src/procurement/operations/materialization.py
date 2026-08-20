"""Independent preparation of source-ready article deposits."""

from __future__ import annotations

import asyncio
from collections.abc import Callable
from pathlib import Path
from typing import TypeVar

from jsonl_engine.deposit import DepositResult
from procurement.domain.acquisition.receipts import AcquiredArtifact, AcquisitionManifest
from procurement.domain.materialization import (
    SourceMaterializationRequest,
    SourceMaterializationResult,
)
from procurement.domain.metadata import DepositMetadataBundle
from procurement.domain.works import WorkIdentityAnchor
from procurement.source.contracts import ArchiveLimits
from procurement.source.extraction import SourceArchiveExtractor
from procurement.source.latex import LatexSourceInspection, LatexSourceInspector
from procurement.errors import SourceMaterializationError
from procurement.identifiers import is_doi, normalize_doi
from procurement.operations.metadata import MetadataService
from procurement.runtime.concurrency import await_boundary
from procurement.source.findings import build_source_findings
from procurement.storage.acquisitions import AcquisitionItem
from procurement.storage.source_deposits import (
    SourceDepositItem,
    SourceDepositStore,
)
from procurement.storage.article import deposit_procurement_article

_T = TypeVar("_T")


class SourceMaterializationService:
    """Transform one validated acquisition into one immutable article sentinel."""

    def __init__(
        self,
        metadata: MetadataService,
        deposits: SourceDepositStore,
        *,
        archive_limits: ArchiveLimits | None = None,
        article_deposit: Callable[..., DepositResult] = deposit_procurement_article,
        lock_timeout: float = 60.0,
    ) -> None:
        if lock_timeout <= 0:
            raise ValueError("lock_timeout must be positive")
        limits = archive_limits or ArchiveLimits()
        self._metadata = metadata
        self._deposits = deposits
        self._extractor = SourceArchiveExtractor(limits)
        self._inspector = LatexSourceInspector(limits)
        self._article_deposit = article_deposit
        self._lock_timeout = lock_timeout

    async def materialize(
        self,
        request: SourceMaterializationRequest,
    ) -> SourceMaterializationResult:
        """Prepare one catalog acquisition without copying bytes or rebuilding inventory."""

        manifest = await self._run_sync(
            self._read_acquisition,
            request.catalog,
            request.acquisition_slug,
        )
        _, receipt_pdf = self._forms(manifest)
        existing = await self._run_sync(
            self._deposits.inspect_existing,
            request.catalog,
            manifest.slug,
            artifact=manifest.artifact,
            identity_anchor=request.identity_anchor,
            requested_mode=request.metadata_mode,
            receipt_has_pdf=receipt_pdf is not None,
        )
        metadata: DepositMetadataBundle | None = None
        if request.metadata_mode == "required":
            metadata = existing.metadata if existing is not None else None
            if metadata is None:
                if request.metadata.mode == "artifact-identity":
                    metadata = await self._metadata.collect(
                        deposit_slug=manifest.slug,
                        artifact_provider=manifest.artifact.provider,
                        identifier=manifest.artifact.identifier,
                        fallback_sources=request.metadata_fallback_sources,
                    )
                elif request.metadata.mode == "explicit-doi":
                    metadata = await self._metadata.collect_by_doi(
                        deposit_slug=manifest.slug,
                        artifact=manifest.artifact,
                        doi=request.metadata.doi,
                        fallback_sources=request.metadata_fallback_sources,
                    )
                else:  # pragma: no cover - metadata_mode closes this branch
                    raise SourceMaterializationError("required metadata strategy is invalid")

        return await self._run_sync(
            self._materialize,
            request,
            manifest,
            metadata,
        )

    async def _run_sync(self, function: Callable[..., _T], *args: object, **kwargs: object) -> _T:
        """Wait for a mutating worker to reach its transaction boundary before cancellation."""

        task = asyncio.create_task(asyncio.to_thread(function, *args, **kwargs))
        return await await_boundary(task)

    def _read_acquisition(self, catalog: str, slug: str) -> AcquisitionManifest:
        with self._deposits.transaction(catalog, slug, create=False) as item:
            if item is None:
                raise SourceMaterializationError(
                    f"catalog {catalog!r} has no acquisition item {slug!r}"
                )
            acq = AcquisitionItem(item.publication_root, slug)
            manifest = acq.recover(acq.read_manifest())
            if manifest is None:
                raise SourceMaterializationError(
                    f"acquisition item has no acquisition.json receipt: '{item.directory}'"
                )
            self._forms(manifest)
            for form in manifest.forms:
                acq.validate_form(form)
            return manifest

    @staticmethod
    def _forms(
        manifest: AcquisitionManifest,
    ) -> tuple[AcquiredArtifact, AcquiredArtifact | None]:
        source = next((form for form in manifest.forms if form.kind == "source"), None)
        if source is None:
            raise SourceMaterializationError(
                f"acquisition {manifest.slug!r} has no source artifact"
            )
        if source.format != "application/gzip":
            raise SourceMaterializationError("source artifact is not a gzip payload")
        pdf = next((form for form in manifest.forms if form.kind == "pdf"), None)
        if pdf is not None and pdf.format != "application/pdf":
            raise SourceMaterializationError("PDF artifact has an unexpected media type")
        return source, pdf

    def _materialize(
        self,
        request: SourceMaterializationRequest,
        expected_manifest: AcquisitionManifest,
        proposed_metadata: DepositMetadataBundle | None,
    ) -> SourceMaterializationResult:
        with self._deposits.transaction(
            request.catalog,
            expected_manifest.slug,
            create=True,
        ) as item:
            if item is None:  # pragma: no cover - create=True is a closed invariant
                raise SourceMaterializationError("source deposit directory was not created")
            acq = AcquisitionItem(item.publication_root, expected_manifest.slug)
            manifest = acq.recover(acq.read_manifest())
            if manifest is None:
                raise SourceMaterializationError(
                    "acquisition receipt disappeared before preparation"
                )
            if (
                manifest.slug != expected_manifest.slug
                or manifest.artifact != expected_manifest.artifact
            ):
                raise SourceMaterializationError("acquisition identity changed before preparation")
            source_form, pdf_form = self._forms(manifest)
            source_path = acq.validate_form(source_form)
            pdf_source = (
                acq.validate_form(pdf_form)
                if pdf_form is not None
                else None
            )
            existing = item.inspect_existing(
                artifact=manifest.artifact,
                identity_anchor=request.identity_anchor,
                requested_mode=request.metadata_mode,
                receipt_has_pdf=pdf_form is not None,
            )
            metadata = proposed_metadata
            if request.metadata_mode == "required":
                if existing is not None and existing.metadata is not None:
                    metadata = existing.metadata
                if metadata is None:
                    raise SourceMaterializationError(
                        "required API metadata was not available at publication"
                    )
                if metadata.identity_anchor != request.identity_anchor:
                    raise SourceMaterializationError(
                        "resolved API metadata does not match the requested "
                        "bibliographic identity"
                    )
            elif metadata is not None:
                raise SourceMaterializationError(
                    "metadata-free publication received an API metadata bundle"
                )

            return self._publish(
                item,
                acq,
                manifest,
                source_form,
                source_path,
                pdf_form,
                pdf_source,
                metadata,
                identity_anchor=request.identity_anchor,
                main_tex=request.main_tex or "",
            )

    def _publish(
        self,
        item: SourceDepositItem,
        acq: AcquisitionItem,
        manifest: AcquisitionManifest,
        source_form: AcquiredArtifact,
        source_path: Path,
        pdf_form: AcquiredArtifact | None,
        pdf_source: Path | None,
        metadata: DepositMetadataBundle | None,
        *,
        identity_anchor: WorkIdentityAnchor | None,
        main_tex: str,
    ) -> SourceMaterializationResult:
        if source_path.parent != item.directory:
            raise SourceMaterializationError(
                "source artifact is not in the catalog document directory"
            )
        archive_leaf = source_form.path
        candidate = item.new_tree_stage()
        try:
            with item.pin_tree_stage(candidate) as candidate_root:
                extraction = self._extractor.extract_pinned(
                    item.publication_root,
                    source_path,
                    candidate_root,
                )
                candidate_inspection = self._inspector.inspect(
                    candidate,
                    slug=manifest.slug,
                    main_tex=main_tex,
                    publication_root=candidate_root,
                )
            if extraction.archive_sha256 != source_form.sha256:
                raise SourceMaterializationError(
                    "expanded source archive does not match its acquisition receipt"
                )
            self._assert_declared_identity(candidate_inspection, metadata)

            pdf_path: str | None = None
            pdf_leaf: str | None = None
            if pdf_form is not None and pdf_source is not None:
                if pdf_source.parent != item.directory:
                    raise SourceMaterializationError(
                        "PDF artifact is not in the catalog document directory"
                    )
                pdf_leaf = pdf_form.path
                pdf_path = str(pdf_source)
            else:
                if item.exists(item.pdf_path):
                    raise SourceMaterializationError(
                        f"unreceipted PDF occupies the source deposit: '{item.pdf_path}'"
                    )

            metadata_path: str | None = None
            metadata_route = None
            if metadata is not None:
                metadata = item.publish_metadata(
                    metadata,
                    artifact=manifest.artifact,
                    identity_anchor=identity_anchor,
                )
                metadata_path = str(item.metadata_path)
                metadata_route = metadata.route

            installed = item.install_tree(
                candidate,
                candidate_inspection,
                inspector=self._inspector,
                main_tex=main_tex,
            )
            findings = build_source_findings(extraction, installed.inspection)
            deposit = self._article_deposit(
                document_dir=str(item.directory),
                slug=manifest.slug,
                archive=archive_leaf,
                archive_sha256=extraction.archive_sha256,
                archive_kind=extraction.archive_kind,
                tree=f"{manifest.slug}-tex",
                tree_sha256=installed.inspection.tree_sha256,
                files=installed.inspection.file_count,
                tex_files=installed.inspection.tex_file_count,
                entrypoint=installed.inspection.entrypoint,
                entrypoint_selection=installed.inspection.entrypoint_selection,
                publication=installed.publication,
                findings=findings,
                metadata_json=(item.metadata_path.name if metadata is not None else None),
                pdf=pdf_leaf,
                lock_timeout=self._lock_timeout,
                publication_root=item.publication_root,
            )
            item.assert_current()
            acq.assert_current()
            return SourceMaterializationResult(
                catalog=item.catalog,
                slug=manifest.slug,
                status=deposit.status,
                created=deposit.created,
                artifact=manifest.artifact,
                acquisition_manifest_path=str(acq.manifest_path),
                document_directory=str(item.directory),
                article_path=deposit.article_path,
                archive_path=str(source_path),
                source_path=installed.path,
                metadata_path=metadata_path,
                pdf_path=pdf_path,
                archive_sha256=extraction.archive_sha256,
                tree_sha256=installed.inspection.tree_sha256,
                archive_kind=extraction.archive_kind,
                entrypoint=installed.inspection.entrypoint,
                metadata_route=metadata_route,
            )
        finally:
            item.discard_tree_stage(candidate)

    @staticmethod
    def _assert_declared_identity(
        inspection: LatexSourceInspection,
        metadata: DepositMetadataBundle | None,
    ) -> None:
        """Reject a source DOI that contradicts a caller-selected DOI identity."""

        if metadata is None or metadata.identity_anchor is None:
            return
        declared = inspection.embedded_metadata.doi
        if declared is None:
            return
        if not is_doi(declared):
            raise SourceMaterializationError(
                "LaTeX source declares an invalid DOI that cannot be reconciled with "
                "the explicit metadata identity"
            )
        canonical = normalize_doi(declared)
        if canonical != metadata.identity_anchor.value:
            raise SourceMaterializationError(
                f"LaTeX source DOI {canonical!r} conflicts with explicit metadata DOI "
                f"{metadata.identity_anchor.value!r}"
            )


__all__ = ["SourceMaterializationService"]
