"""Configured local-import custody and acquisition-receipt tests."""

from __future__ import annotations

import asyncio
import gzip
import json
import os
from pathlib import Path
from unittest import mock

import jsonschema
import pytest
from pydantic import ValidationError

from procurement.errors import AcquisitionConflictError, AcquisitionError
from procurement.payloads import acquisition_manifest_schema
from procurement.configuration import ArtifactLimitSettings
from procurement.operations.local_import import LocalImportRequest, LocalImportService
from procurement.storage.acquisitions import AcquisitionStore

PDF = b"%PDF-1.7\n1 0 obj\n<<>>\nendobj\n%%EOF\n"
SOURCE = gzip.compress(
    b"\\documentclass{article}\n\\begin{document}x\\end{document}\n",
    mtime=0,
)


def service_layout(tmp_path: Path, **limit_changes: int) -> tuple[LocalImportService, Path, Path]:
    inbox = tmp_path / "inbox"
    staging = tmp_path / "staging"
    inbox.mkdir()
    staging.mkdir()
    limits = ArtifactLimitSettings(
        source_bytes=limit_changes.get("source_bytes", 1024 * 1024),
        pdf_bytes=limit_changes.get("pdf_bytes", 1024 * 1024),
        html_bytes=1024 * 1024,
        expanded_source_bytes=limit_changes.get("expanded_source_bytes", 1024 * 1024),
        archive_entries=100,
    )
    service = LocalImportService(
        {"manual": inbox},
        AcquisitionStore(staging, lock_timeout=2),
        limits,
    )
    return service, inbox, staging


def run_import(
    service: LocalImportService,
    leaf: str,
    *,
    slug: str = "manual-paper",
):
    return asyncio.run(
        service.import_artifact(
            LocalImportRequest(inbox="manual", leaf=leaf, deposit_slug=slug)
        )
    )


def test_source_and_pdf_import_collate_normal_receipt_with_local_custody(tmp_path: Path) -> None:
    service, inbox, staging = service_layout(tmp_path)
    (inbox / "downloaded-source.bin").write_bytes(SOURCE)
    (inbox / "downloaded-paper.bin").write_bytes(PDF)

    source_result = run_import(service, "downloaded-source.bin")
    pdf_result = run_import(service, "downloaded-paper.bin")

    assert source_result.outcomes[0].status == "acquired"
    assert pdf_result.outcomes[0].status == "acquired"
    assert pdf_result.manifest is not None
    assert pdf_result.manifest.artifact.provider == "manual-import"
    assert pdf_result.manifest.artifact.identifier == "manual-paper"
    assert pdf_result.manifest.artifact.provider_roles == ("artifact-access",)
    assert [form.kind for form in pdf_result.manifest.forms] == ["source", "pdf"]
    assert [form.path for form in pdf_result.manifest.forms] == [
        "manual-paper.tar.gz",
        "manual-paper.pdf",
    ]
    for form in pdf_result.manifest.forms:
        assert form.custody == "local-import"
        assert form.origin_url is None
        assert form.candidate_id is None
        assert form.fetched_at is None
        assert form.provider_checksum is None
        assert form.local_import is not None
        assert form.local_import.inbox == "manual"
    assert (staging / "manual-paper" / "manual-paper.tar.gz").read_bytes() == SOURCE
    assert (staging / "manual-paper" / "manual-paper.pdf").read_bytes() == PDF

    payload = json.loads(
        (staging / "manual-paper" / "acquisition.json").read_text(encoding="utf-8")
    )
    jsonschema.Draft202012Validator(acquisition_manifest_schema()).validate(payload)
    static = json.loads(
        (
            Path(__file__).resolve().parents[2]
            / "src"
            / "procurement"
            / "schemas"
            / "acquisition.schema.json"
        ).read_text(encoding="utf-8")
    )
    jsonschema.Draft202012Validator(static).validate(payload)


def test_same_bytes_are_idempotent_and_changed_bytes_conflict(tmp_path: Path) -> None:
    service, inbox, staging = service_layout(tmp_path)
    candidate = inbox / "paper.pdf"
    candidate.write_bytes(PDF)

    first = run_import(service, candidate.name)
    second = run_import(service, candidate.name)

    assert first.outcomes[0].status == "acquired"
    assert second.outcomes[0].status == "already-present"
    before = (staging / "manual-paper" / "acquisition.json").read_bytes()

    candidate.write_bytes(PDF.replace(b"<<>>", b"<</Title(x)>>"))
    with pytest.raises(AcquisitionConflictError, match="bytes conflict"):
        run_import(service, candidate.name)
    assert (staging / "manual-paper" / "acquisition.json").read_bytes() == before
    assert not (staging / "manual-paper" / ".download.part").exists()


def test_invalid_kind_truncated_payload_and_kind_limits_publish_nothing(tmp_path: Path) -> None:
    service, inbox, staging = service_layout(tmp_path, pdf_bytes=len(PDF) - 1)
    candidates = {
        "unknown.bin": b"not an artifact",
        "truncated.pdf": b"%PDF-1.7\nmissing trailer",
        "large.pdf": PDF,
    }
    for leaf, body in candidates.items():
        (inbox / leaf).write_bytes(body)
        with pytest.raises(AcquisitionError):
            run_import(service, leaf, slug=leaf.split(".", 1)[0])

    assert not list(staging.rglob("acquisition.json"))
    assert not list(staging.rglob(".download.part"))


def test_request_and_physical_file_confinement(tmp_path: Path) -> None:
    service, inbox, _ = service_layout(tmp_path)

    for leaf in ("../paper.pdf", "nested/paper.pdf", str(tmp_path / "paper.pdf")):
        with pytest.raises(ValidationError):
            LocalImportRequest(inbox="manual", leaf=leaf, deposit_slug="paper")

    (inbox / "directory.pdf").mkdir()
    with pytest.raises(AcquisitionError, match="physical regular file"):
        run_import(service, "directory.pdf")

    outside = tmp_path / "outside.pdf"
    outside.write_bytes(PDF)
    linked = inbox / "linked.pdf"
    try:
        linked.symlink_to(outside)
    except OSError:
        pass
    else:
        with pytest.raises(AcquisitionError, match="physical regular file"):
            run_import(service, linked.name)

    alias = tmp_path / "inbox-alias"
    try:
        alias.symlink_to(inbox, target_is_directory=True)
    except OSError:
        pass
    else:
        staging = tmp_path / "other-staging"
        staging.mkdir()
        with pytest.raises(AcquisitionError, match="must not traverse a link|physical directory"):
            LocalImportService(
                {"manual": alias},
                AcquisitionStore(staging),
                ArtifactLimitSettings(),
            )


def test_detected_source_mutation_cleans_private_copy(tmp_path: Path) -> None:
    service, inbox, staging = service_layout(tmp_path)
    (inbox / "source.gz").write_bytes(SOURCE)

    with mock.patch(
        "procurement.operations.local_import._same_open_snapshot",
        return_value=False,
    ):
        with pytest.raises(AcquisitionConflictError, match="changed while copying"):
            run_import(service, "source.gz")

    assert not list(staging.rglob("acquisition.json"))
    assert not list(staging.rglob(".download.part"))


def test_inbox_catalog_exposes_logical_names_only(tmp_path: Path) -> None:
    service, _, _ = service_layout(tmp_path)

    assert service.inbox_names == ("manual",)
    assert service.inboxes().model_dump(mode="json") == {"inboxes": [{"name": "manual"}]}
    schema_text = json.dumps(service.inboxes().model_json_schema())
    assert str(tmp_path) not in schema_text
