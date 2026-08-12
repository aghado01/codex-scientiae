"""Source-acquisition to immutable article-deposit integration contracts."""

from __future__ import annotations

import asyncio
import base64
import copy
import hashlib
import io
import json
import os
import tarfile
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

import pytest
import jsonschema
from pydantic import ValidationError

from jsonl_engine.kinds.article import ArticleManifest
from procurement.configuration import ArtifactLimitSettings
from procurement.domain.materialization import (
    ArtifactIdentityMetadata,
    ExplicitDoiMetadata,
    OmitArticleMetadata,
    SourceMaterializationRequest,
    SourceMaterializationResult,
)
from procurement.source.archive import (
    ArchiveExtraction,
    EmbeddedLatexMetadata,
    LatexSourceInspection,
    TreeFile,
)
from procurement.source.findings import build_source_findings
from procurement.errors import AcquisitionConflictError, SourceMaterializationError
from procurement.filesystem import stable_copy_no_clobber
from procurement.models import (
    ApiResponseEvidence,
    ArtifactReference,
    DepositMetadataBundle,
    MetadataAttempt,
    MetadataObservation,
    SourceReference,
    WorkIdentityAnchor,
    WorkRecord,
    project_identifier_article_metadata,
    project_article_metadata,
)
from procurement.payloads import AcquiredArtifact, AcquisitionManifest
from procurement.operations.catalogs import ArticleCatalogService
from procurement.operations.local_import import LocalImportRequest, LocalImportService
from procurement.operations.materialization import SourceMaterializationService
from procurement.storage.acquisitions import AcquisitionStore
from procurement.storage.catalogs import ArticleCatalogRoots
from procurement.storage.source_deposits import SourceDepositStore


NOW = datetime(2026, 8, 11, 12, 0, tzinfo=timezone.utc)
SLUG = "2008.10579v1"
ARXIV_ALIAS = f"arXiv-{SLUG}.tar.gz"
ROLES = ("artifact-origin", "artifact-access", "metadata-authority")
MAIN_TEX = (
    b"\\documentclass{article}\n"
    b"\\title{Materialization Test}\n"
    b"\\author{Ada Example}\n"
    b"\\input{section}\n"
    b"\\begin{document}Hello\\end{document}\n"
)
PDF = b"%PDF-1.7\n1 0 obj\n<<>>\nendobj\n%%EOF\n"


@dataclass(frozen=True, slots=True)
class Layout:
    staging_root: Path
    catalog_root: Path
    acquisitions: AcquisitionStore
    deposits: SourceDepositStore


class StaticMetadataService:
    """Count metadata calls while returning one already validated bundle."""

    def __init__(self, bundle: DepositMetadataBundle) -> None:
        self.bundle = bundle
        self.calls: list[dict[str, object]] = []

    async def collect(self, **kwargs: object) -> DepositMetadataBundle:
        self.calls.append(dict(kwargs))
        return self.bundle

    async def collect_by_doi(self, **kwargs: object) -> DepositMetadataBundle:
        self.calls.append(dict(kwargs))
        return self.bundle


class RejectingMetadataService:
    """Prove metadata-free materialization never enters the API route."""

    async def collect(self, **kwargs: object) -> DepositMetadataBundle:
        raise AssertionError(f"metadata collection must not run: {kwargs}")

    async def collect_by_doi(self, **kwargs: object) -> DepositMetadataBundle:
        raise AssertionError(f"metadata collection must not run: {kwargs}")


@pytest.fixture
def layout(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Layout:
    scratch = tmp_path / "json-scratch"
    monkeypatch.setenv("CODEX_JSON_SCRATCH_ROOT", str(scratch))
    staging_root = tmp_path / "staging"
    catalog_root = tmp_path / "catalog"
    staging_root.mkdir()
    catalog_root.mkdir()
    catalog_roots = ArticleCatalogRoots({"primary": str(catalog_root)})
    return Layout(
        staging_root=staging_root,
        catalog_root=catalog_root,
        acquisitions=AcquisitionStore(staging_root, lock_timeout=2),
        deposits=SourceDepositStore(catalog_roots, lock_timeout=2),
    )


def artifact() -> ArtifactReference:
    return ArtifactReference(
        provider="arxiv",
        identifier=SLUG,
        provider_roles=ROLES,
    )


def tar_gzip_source(
    *,
    main_name: str = "main.tex",
    main_tex: bytes = MAIN_TEX,
    extras: dict[str, bytes] | None = None,
) -> bytes:
    files = {
        main_name: main_tex,
        "section.tex": b"A resolved input.\n",
        "00README.json": b'{"source":"test"}\n',
    }
    files.update(extras or {})
    output = io.BytesIO()
    with tarfile.open(fileobj=output, mode="w:gz", format=tarfile.PAX_FORMAT) as archive:
        for name, body in files.items():
            member = tarfile.TarInfo(name)
            member.size = len(body)
            member.mode = 0o600
            member.mtime = 0
            archive.addfile(member, io.BytesIO(body))
    return output.getvalue()


def stage_source(
    layout: Layout,
    body: bytes,
    *,
    write_source: bool = True,
    receipt_body: bytes | None = None,
) -> Path:
    witnessed = body if receipt_body is None else receipt_body
    form = AcquiredArtifact(
        kind="source",
        path=ARXIV_ALIAS,
        format="application/gzip",
        bytes=len(witnessed),
        sha256=hashlib.sha256(witnessed).hexdigest(),
        origin_url=f"https://export.arxiv.org/e-print/{SLUG}",
        candidate_id="arxiv-export-source",
        fetched_at=NOW,
    )
    manifest = AcquisitionManifest(
        slug=SLUG,
        artifact=artifact(),
        forms=(form,),
    )
    with layout.acquisitions.transaction(SLUG) as item:
        source_path = item.directory / ARXIV_ALIAS
        if write_source:
            source_path.write_bytes(body)
        item.publish_manifest(manifest)
    return layout.staging_root / SLUG / ARXIV_ALIAS


def add_pdf_to_receipt(layout: Layout, body: bytes = PDF) -> Path:
    """Add a receipted PDF to an existing source acquisition."""

    pdf = AcquiredArtifact(
        kind="pdf",
        path=f"{SLUG}.pdf",
        format="application/pdf",
        bytes=len(body),
        sha256=hashlib.sha256(body).hexdigest(),
        origin_url=f"https://arxiv.org/pdf/{SLUG}",
        candidate_id="arxiv-pdf",
        fetched_at=NOW,
    )
    with layout.acquisitions.transaction(SLUG, create=False) as item:
        manifest = item.read_manifest()
        assert manifest is not None
        pdf_path = item.directory / pdf.path
        pdf_path.write_bytes(body)
        item.publish_manifest(manifest.model_copy(update={"forms": (*manifest.forms, pdf)}))
    return layout.staging_root / SLUG / pdf.path


def metadata_bundle() -> DepositMetadataBundle:
    response_body = b"<feed><entry>authoritative metadata</entry></feed>"
    work = WorkRecord(
        title="API title",
        authors=("API Author",),
        abstract="API abstract",
        arxiv_id=SLUG,
        categories=("math.OC",),
        sources=(
            SourceReference(
                provider="arxiv",
                identifier=SLUG,
                arxiv_id=SLUG,
            ),
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
        artifact=artifact(),
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


def doi_metadata_bundle(
    doi: str = "10.1000/example",
    *,
    artifact_reference: ArtifactReference | None = None,
    deposit_slug: str = SLUG,
) -> DepositMetadataBundle:
    response_body = b'{"id":"https://openalex.org/W1"}'
    work = WorkRecord(
        title="DOI-resolved API title",
        authors=("API Author",),
        doi=doi,
        arxiv_id=SLUG,
        concepts=("Optimization",),
        sources=(
            SourceReference(
                provider="openalex",
                identifier="W1",
                doi=doi,
                arxiv_id=SLUG,
            ),
        ),
    )
    observation = MetadataObservation(
        provider="openalex",
        provider_roles=("metadata-aggregator",),
        work=work,
        response=ApiResponseEvidence(
            url="https://api.openalex.org/works/https://doi.org/10.1000/example",
            media_type="application/json",
            fetched_at=NOW,
            sha256=hashlib.sha256(response_body).hexdigest(),
            body_base64=base64.b64encode(response_body).decode("ascii"),
        ),
    )
    return DepositMetadataBundle(
        deposit_slug=deposit_slug,
        artifact=artifact_reference or artifact(),
        identity_anchor=WorkIdentityAnchor(kind="doi", value=doi),
        route="identifier-aggregator",
        selected=observation,
        attempts=(MetadataAttempt(provider="openalex", status="ok"),),
        article=project_identifier_article_metadata(work),
    )


def service(layout: Layout, metadata: object) -> SourceMaterializationService:
    return SourceMaterializationService(
        metadata,  # type: ignore[arg-type]
        layout.acquisitions,
        layout.deposits,
        lock_timeout=2,
    )


def request(
    *,
    metadata_mode: str = "omit",
    main_tex: str | None = None,
    metadata: object | None = None,
) -> SourceMaterializationRequest:
    if metadata is None:
        metadata = (
            ArtifactIdentityMetadata()
            if metadata_mode == "required"
            else OmitArticleMetadata()
        )
    return SourceMaterializationRequest(
        catalog="primary",
        acquisition_slug=SLUG,
        metadata=metadata,
        main_tex=main_tex,
    )


def test_real_tar_materialization_normalizes_arxiv_alias_and_uses_real_deposit(
    layout: Layout,
) -> None:
    source_body = tar_gzip_source()
    staged_source = stage_source(layout, source_body)

    result = asyncio.run(
        service(layout, RejectingMetadataService()).materialize(request())
    )

    document = layout.catalog_root / SLUG
    canonical_archive = document / f"{SLUG}.tar.gz"
    article_path = document / "article.json"
    article = json.loads(article_path.read_text(encoding="utf-8"))
    validated = ArticleManifest(target_dir=str(document)).validate_record(article)

    assert result.status == "deposited"
    assert result.created is True
    assert result.archive_kind == "tar+gzip"
    assert result.entrypoint == "main.tex"
    assert canonical_archive.read_bytes() == source_body
    assert canonical_archive.name == f"{SLUG}.tar.gz"
    assert not (document / ARXIV_ALIAS).exists()
    assert not os.path.samefile(staged_source, canonical_archive)
    assert validated["source_forms"][0]["path"] == f"{SLUG}.tar.gz"
    assert validated["source_forms"][0]["archive_kind"] == "tar+gzip"
    assert validated["validation"]["publication"] == "published-new-tree"


def test_required_metadata_is_persisted_reused_and_article_is_byte_idempotent(
    layout: Layout,
) -> None:
    stage_source(layout, tar_gzip_source())
    expected = metadata_bundle()
    metadata = StaticMetadataService(expected)
    materializer = service(layout, metadata)
    materialize_request = request(metadata_mode="required")

    first = asyncio.run(materializer.materialize(materialize_request))
    article_path = Path(first.article_path)
    metadata_path = Path(first.metadata_path or "")
    first_article = article_path.read_bytes()
    first_article_mtime = article_path.stat().st_mtime_ns
    first_metadata = metadata_path.read_bytes()
    first_metadata_mtime = metadata_path.stat().st_mtime_ns

    second = asyncio.run(materializer.materialize(materialize_request))

    assert first.status == "deposited"
    assert second.status == "already-deposited"
    assert second.created is False
    assert len(metadata.calls) == 1
    assert metadata.calls[0]["deposit_slug"] == SLUG
    assert metadata.calls[0]["artifact_provider"] == "arxiv"
    assert metadata.calls[0]["identifier"] == SLUG
    assert DepositMetadataBundle.model_validate_json(first_metadata) == expected
    assert article_path.read_bytes() == first_article
    assert article_path.stat().st_mtime_ns == first_article_mtime
    assert metadata_path.read_bytes() == first_metadata
    assert metadata_path.stat().st_mtime_ns == first_metadata_mtime
    article = json.loads(first_article)
    assert article["evidence"]["metadata_resolution"]["route"] == "artifact-provider"
    assert article["title"] == "API title"


def test_explicit_doi_metadata_is_independent_of_artifact_provenance_and_reused(
    layout: Layout,
) -> None:
    doi = "10.1000/example"
    source = MAIN_TEX.replace(
        b"\\begin{document}",
        b"\\doi{10.1000/EXAMPLE}\n\\begin{document}",
    )
    stage_source(layout, tar_gzip_source(main_tex=source))
    expected = doi_metadata_bundle(doi)
    metadata = StaticMetadataService(expected)
    materializer = service(layout, metadata)
    materialize_request = request(
        metadata=ExplicitDoiMetadata(
            doi="https://doi.org/10.1000/EXAMPLE",
            fallback_sources=("openalex",),
        )
    )

    first = asyncio.run(materializer.materialize(materialize_request))
    second = asyncio.run(materializer.materialize(materialize_request))

    assert first.status == "deposited"
    assert second.status == "already-deposited"
    assert len(metadata.calls) == 1
    assert metadata.calls[0]["artifact"] == artifact()
    assert metadata.calls[0]["doi"] == doi
    article = json.loads(Path(first.article_path).read_bytes())
    resolution = article["evidence"]["metadata_resolution"]
    assert resolution["route"] == "identifier-aggregator"
    assert resolution["identity_anchor"] == {
        "kind": "doi",
        "value": doi,
        "supplied_by": "caller",
    }
    assert article["title"] == "DOI-resolved API title"


def test_explicit_doi_conflict_with_latex_declaration_fails_before_publication(
    layout: Layout,
) -> None:
    source = MAIN_TEX.replace(
        b"\\begin{document}",
        b"\\doi{10.1000/other}\n\\begin{document}",
    )
    stage_source(layout, tar_gzip_source(main_tex=source))
    metadata = StaticMetadataService(doi_metadata_bundle())

    with pytest.raises(SourceMaterializationError, match="conflicts with explicit metadata DOI"):
        asyncio.run(
            service(layout, metadata).materialize(
                request(metadata=ExplicitDoiMetadata(doi="10.1000/example"))
            )
        )

    document = layout.catalog_root / SLUG
    assert not (document / "article.json").exists()
    assert not (document / f"{SLUG}.api-metadata.json").exists()
    assert not (document / f"{SLUG}.tar.gz").exists()


def test_metadata_service_cannot_substitute_a_different_explicit_doi(
    layout: Layout,
) -> None:
    stage_source(layout, tar_gzip_source())
    metadata = StaticMetadataService(doi_metadata_bundle("10.1000/other"))

    with pytest.raises(SourceMaterializationError, match="requested bibliographic identity"):
        asyncio.run(
            service(layout, metadata).materialize(
                request(metadata=ExplicitDoiMetadata(doi="10.1000/example"))
            )
        )

    assert not (layout.catalog_root / SLUG / "article.json").exists()


def test_manual_tarball_plus_explicit_doi_converges_on_normal_article_json(
    layout: Layout,
    tmp_path: Path,
) -> None:
    slug = "manual-paper"
    doi = "10.1000/example"
    inbox = tmp_path / "manual-inbox"
    inbox.mkdir()
    source = MAIN_TEX.replace(
        b"\\begin{document}",
        b"\\doi{10.1000/example}\n\\begin{document}",
    )
    (inbox / "downloaded-source.tgz").write_bytes(tar_gzip_source(main_tex=source))
    importer = LocalImportService(
        {"manual": inbox},
        layout.acquisitions,
        ArtifactLimitSettings(
            source_bytes=1024 * 1024,
            pdf_bytes=1024 * 1024,
            html_bytes=1024 * 1024,
            expanded_source_bytes=1024 * 1024,
            archive_entries=100,
        ),
    )

    imported = asyncio.run(
        importer.import_artifact(
            LocalImportRequest(
                inbox="manual",
                leaf="downloaded-source.tgz",
                deposit_slug=slug,
            )
        )
    )
    assert imported.manifest is not None
    assert imported.manifest.forms[0].custody == "local-import"
    manual_artifact = imported.manifest.artifact
    expected = doi_metadata_bundle(
        doi,
        artifact_reference=manual_artifact,
        deposit_slug=slug,
    )
    metadata = StaticMetadataService(expected)

    result = asyncio.run(
        service(layout, metadata).materialize(
            SourceMaterializationRequest(
                catalog="primary",
                acquisition_slug=slug,
                metadata=ExplicitDoiMetadata(
                    doi=doi,
                    fallback_sources=("openalex",),
                ),
            )
        )
    )

    article = json.loads(Path(result.article_path).read_bytes())
    assert article["slug"] == slug
    assert article["title"] == "DOI-resolved API title"
    assert article["identifiers"]["doi"] == doi
    assert article["evidence"]["metadata_resolution"]["artifact"]["provider"] == (
        "manual-import"
    )
    assert article["evidence"]["metadata_resolution"]["identity_anchor"]["value"] == doi
    assert article["source_forms"][0]["path"] == f"{slug}.tar.gz"
    assert (layout.catalog_root / slug / "article.json").is_file()

    tampered = copy.deepcopy(article)
    del tampered["evidence"]["metadata_resolution"]["identity_anchor"]
    with pytest.raises(jsonschema.ValidationError):
        ArticleManifest(target_dir=str(layout.catalog_root / slug)).validate_record(tampered)

    mismatched = copy.deepcopy(article)
    mismatched["evidence"]["metadata_resolution"]["identity_anchor"]["value"] = (
        "10.1000/other"
    )
    with pytest.raises(jsonschema.ValidationError, match="projected article DOI"):
        ArticleManifest(target_dir=str(layout.catalog_root / slug)).validate_record(mismatched)


def test_omit_mode_never_collects_or_persists_api_metadata(layout: Layout) -> None:
    stage_source(layout, tar_gzip_source())

    result = asyncio.run(
        service(layout, RejectingMetadataService()).materialize(request(metadata_mode="omit"))
    )

    document = layout.catalog_root / SLUG
    article = json.loads(Path(result.article_path).read_bytes())
    assert result.metadata_path is None
    assert result.metadata_route is None
    assert not (document / f"{SLUG}.api-metadata.json").exists()
    assert "metadata_resolution" not in article["evidence"]
    assert article["evidence"]["provider_metadata"] == []


def test_later_pdf_enrichment_fails_before_copying_or_mutating_article(
    layout: Layout,
) -> None:
    stage_source(layout, tar_gzip_source())
    materializer = service(layout, RejectingMetadataService())
    first = asyncio.run(materializer.materialize(request()))
    document = layout.catalog_root / SLUG
    article_path = Path(first.article_path)
    article_bytes = article_path.read_bytes()
    article_mtime = article_path.stat().st_mtime_ns
    archive_path = document / f"{SLUG}.tar.gz"
    archive_mtime = archive_path.stat().st_mtime_ns
    tree_main = document / f"{SLUG}-tex" / "main.tex"
    tree_bytes = tree_main.read_bytes()
    children_before = sorted(path.name for path in document.iterdir())
    add_pdf_to_receipt(layout)

    with pytest.raises(SourceMaterializationError, match="freezes PDF inclusion"):
        asyncio.run(materializer.materialize(request()))

    assert not (document / f"{SLUG}.pdf").exists()
    assert sorted(path.name for path in document.iterdir()) == children_before
    assert article_path.read_bytes() == article_bytes
    assert article_path.stat().st_mtime_ns == article_mtime
    assert archive_path.stat().st_mtime_ns == archive_mtime
    assert tree_main.read_bytes() == tree_bytes


def test_pdf_inclusion_is_idempotent_when_frozen_present(layout: Layout) -> None:
    stage_source(layout, tar_gzip_source())
    staged_pdf = add_pdf_to_receipt(layout)
    materializer = service(layout, RejectingMetadataService())

    first = asyncio.run(materializer.materialize(request()))
    deposited_pdf = Path(first.pdf_path or "")
    article_path = Path(first.article_path)
    pdf_bytes = deposited_pdf.read_bytes()
    pdf_mtime = deposited_pdf.stat().st_mtime_ns
    article_bytes = article_path.read_bytes()
    article_mtime = article_path.stat().st_mtime_ns
    second = asyncio.run(materializer.materialize(request()))

    assert first.status == "deposited"
    assert second.status == "already-deposited"
    assert second.pdf_path == str(deposited_pdf)
    assert deposited_pdf.read_bytes() == pdf_bytes == PDF
    assert deposited_pdf.stat().st_mtime_ns == pdf_mtime
    assert article_path.read_bytes() == article_bytes
    assert article_path.stat().st_mtime_ns == article_mtime
    assert not os.path.samefile(staged_pdf, deposited_pdf)
    article = json.loads(article_bytes)
    assert [form["role"] for form in article["source_forms"]] == [
        "latex-source-archive",
        "latex-source-tree",
        "pdf-source",
    ]


@pytest.mark.parametrize("condition", ("missing", "tampered"))
def test_missing_or_tampered_staged_source_is_rejected_before_publication(
    layout: Layout,
    condition: str,
) -> None:
    source_body = tar_gzip_source()
    staged = stage_source(
        layout,
        source_body,
        write_source=condition != "missing",
    )
    if condition == "tampered":
        staged.write_bytes(source_body + b"tampered")

    with pytest.raises(AcquisitionConflictError, match="artifact"):
        asyncio.run(
            service(layout, RejectingMetadataService()).materialize(request())
        )

    assert not (layout.catalog_root / SLUG).exists()


@pytest.mark.parametrize("occupancy", ("archive", "tree"))
def test_conflicting_destination_archive_or_tree_is_never_replaced(
    layout: Layout,
    occupancy: str,
) -> None:
    source_body = tar_gzip_source()
    stage_source(layout, source_body)
    document = layout.catalog_root / SLUG
    document.mkdir()
    if occupancy == "archive":
        conflict = document / f"{SLUG}.tar.gz"
        conflict.write_bytes(b"occupied by different bytes")
    else:
        (document / f"{SLUG}.tar.gz").write_bytes(source_body)
        conflict = document / f"{SLUG}-tex"
        conflict.mkdir()
        (conflict / "main.tex").write_bytes(
            b"\\documentclass{book}\n\\begin{document}different\\end{document}\n"
        )

    before = conflict.read_bytes() if conflict.is_file() else (conflict / "main.tex").read_bytes()
    with pytest.raises(SourceMaterializationError, match="conflict"):
        asyncio.run(
            service(layout, RejectingMetadataService()).materialize(request())
        )

    after = conflict.read_bytes() if conflict.is_file() else (conflict / "main.tex").read_bytes()
    assert after == before
    assert not (document / "article.json").exists()


@pytest.mark.parametrize(
    ("archive_kind", "selection", "expected_archive_outcome", "expected_entry_outcome"),
    (
        ("tar+gzip", "single-candidate", "passed", "passed"),
        ("single-tex+gzip", "explicit", "not-applicable", "not-applicable"),
    ),
)
def test_findings_are_a_closed_seven_probe_ledger(
    archive_kind: str,
    selection: str,
    expected_archive_outcome: str,
    expected_entry_outcome: str,
) -> None:
    digest = hashlib.sha256(b"x").hexdigest()
    extraction = ArchiveExtraction(
        archive_path="source.tar.gz",
        destination_path="expanded",
        archive_kind=archive_kind,  # type: ignore[arg-type]
        archive_entries=1,
        archive_sha256=digest,
        gzip_payload_bytes=1,
        extracted_bytes=1,
    )
    inspection = LatexSourceInspection(
        root_path="expanded",
        entrypoint="main.tex",
        entrypoint_selection=selection,
        file_count=1,
        tex_file_count=1,
        tree_sha256=digest,
        files=(TreeFile(path="main.tex", bytes=1, sha256=digest),),
        package_control_files=(),
        embedded_metadata=EmbeddedLatexMetadata(
            title_tex="A title",
            authors_tex=("An author",),
            doi=None,
        ),
    )

    findings = build_source_findings(extraction, inspection)
    checks = findings["checks"]
    by_name = {item["name"]: item for item in checks}

    assert [item["name"] for item in checks] == [
        "gzip-readable",
        "archive-members-confined",
        "no-links-or-reparse-points",
        "tex-valid-utf8",
        "entrypoint-unambiguous",
        "literal-inputs-resolved",
        "document-environment-present",
    ]
    assert len(by_name) == 7
    assert by_name["archive-members-confined"]["outcome"] == expected_archive_outcome
    assert by_name["entrypoint-unambiguous"]["outcome"] == expected_entry_outcome
    for check in checks:
        if check["outcome"] != "passed":
            assert check["reason"]
    assert findings["declarations"]["title_tex"] == "A title"


def test_stable_copy_is_independent_idempotent_and_no_clobber(tmp_path: Path) -> None:
    source = tmp_path / "source.bin"
    destination_parent = tmp_path / "deposit"
    destination_parent.mkdir()
    destination = destination_parent / "source.bin"
    body = b"independent immutable copy"
    digest = hashlib.sha256(body).hexdigest()
    source.write_bytes(body)

    first = stable_copy_no_clobber(
        source,
        destination,
        expected_bytes=len(body),
        expected_sha256=digest,
    )
    first_mtime = destination.stat().st_mtime_ns
    second = stable_copy_no_clobber(
        source,
        destination,
        expected_bytes=len(body),
        expected_sha256=digest,
    )

    assert first.created is True
    assert second.created is False
    assert destination.read_bytes() == body
    assert destination.stat().st_mtime_ns == first_mtime
    assert not os.path.samefile(source, destination)

    destination.write_bytes(b"conflicting occupied value")
    with pytest.raises(SourceMaterializationError, match="conflict"):
        stable_copy_no_clobber(
            source,
            destination,
            expected_bytes=len(body),
            expected_sha256=digest,
        )
    assert destination.read_bytes() == b"conflicting occupied value"


@pytest.mark.parametrize(
    "values",
    (
        {"catalog": "", "acquisition_slug": SLUG},
        {"catalog": "primary", "acquisition_slug": "../escape"},
        {
            "catalog": "primary",
            "acquisition_slug": SLUG,
            "main_tex": "../outside.tex",
        },
        {
            "catalog": "primary",
            "acquisition_slug": SLUG,
            "metadata": {
                "mode": "omit",
                "fallback_sources": ("openalex",),
            },
        },
        {
            "catalog": "primary",
            "acquisition_slug": SLUG,
            "metadata": {
                "mode": "artifact-identity",
                "fallback_sources": ("OpenAlex", "openalex"),
            },
        },
        {
            "catalog": "primary",
            "acquisition_slug": SLUG,
            "metadata": {"mode": "explicit-doi", "doi": "not-a-doi"},
        },
    ),
)
def test_materialization_request_rejects_ambiguous_or_unsafe_inputs(
    values: dict[str, object],
) -> None:
    with pytest.raises(ValidationError):
        SourceMaterializationRequest.model_validate(values)


def test_materialization_result_enforces_status_and_metadata_pairs() -> None:
    base = {
        "catalog": "primary",
        "slug": SLUG,
        "status": "deposited",
        "created": True,
        "artifact": artifact(),
        "acquisition_manifest_path": "staging/acquisition.json",
        "document_directory": "catalog/document",
        "article_path": "catalog/document/article.json",
        "archive_path": "catalog/document/source.tar.gz",
        "source_path": "catalog/document/source-tex",
        "archive_sha256": "0" * 64,
        "tree_sha256": "1" * 64,
        "archive_kind": "tar+gzip",
        "entrypoint": "main.tex",
    }
    with pytest.raises(ValidationError, match="created must agree"):
        SourceMaterializationResult.model_validate({**base, "created": False})
    with pytest.raises(ValidationError, match="metadata path and route"):
        SourceMaterializationResult.model_validate(
            {**base, "metadata_path": "metadata.json"}
        )
