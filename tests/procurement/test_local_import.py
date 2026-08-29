"""Configured local-import custody and acquisition-receipt tests."""

from __future__ import annotations

import asyncio
import gzip
import json
import os
import subprocess
import threading
from pathlib import Path
from unittest import mock

import jsonschema
import pytest
from pydantic import ValidationError

import procurement.operations.local_import as local_import_module
from procurement.errors import AcquisitionConflictError, AcquisitionError
from procurement.domain.acquisition.receipts import acquisition_manifest_schema
from procurement.configuration import ArtifactLimitSettings
from procurement.operations.local_import import LocalImportRequest, LocalImportService
from procurement.storage.acquisitions import AcquisitionStore
from procurement.storage.roots import ConfiguredRootKind, ProcurementRootCatalog
from procurement.storage.safety import is_link_or_reparse

PDF = b"%PDF-1.7\n1 0 obj\n<<>>\nendobj\n%%EOF\n"
SOURCE = gzip.compress(
    b"\\documentclass{article}\n\\begin{document}x\\end{document}\n",
    mtime=0,
)


def _create_directory_link(link: Path, target: Path) -> None:
    """Create one directory link, using a privilege-free junction on Windows."""

    if os.name != "nt":
        link.symlink_to(target, target_is_directory=True)
        return
    command = os.environ.get("ComSpec", "cmd.exe")
    result = subprocess.run(
        [command, "/d", "/c", "mklink", "/J", str(link), str(target)],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=10,
        check=False,
    )
    if result.returncode != 0 or not os.path.lexists(link):
        reason = (result.stderr or result.stdout).decode("utf-8", errors="replace").strip()
        pytest.skip(f"directory links are unavailable: {reason}")


def _remove_directory_link(link: Path) -> None:
    if not os.path.lexists(link):
        return
    if os.name == "nt":
        link.rmdir()
    else:
        link.unlink()


@pytest.fixture
def service_layout(tmp_path: Path, monkeypatch: pytest.MonkeyPatch):
    monkeypatch.setenv("CODEX_JSON_SCRATCH_ROOT", str(tmp_path / "json-scratch"))
    opened: list[ProcurementRootCatalog] = []
    serial = 0

    def build(**limit_changes: int) -> tuple[LocalImportService, Path, Path]:
        nonlocal serial
        serial += 1
        case = tmp_path / f"case-{serial:02d}"
        inbox = case / "inbox"
        staging = case / "staging"
        catalog = case / "catalog"
        inbox.mkdir(parents=True)
        staging.mkdir()
        catalog.mkdir()
        limits = ArtifactLimitSettings(
            source_bytes=limit_changes.get("source_bytes", 1024 * 1024),
            pdf_bytes=limit_changes.get("pdf_bytes", 1024 * 1024),
            html_bytes=1024 * 1024,
            expanded_source_bytes=limit_changes.get("expanded_source_bytes", 1024 * 1024),
            archive_entries=100,
        )
        roots = ProcurementRootCatalog(
            staging,
            local_inboxes={"manual": inbox},
            article_catalogs={"primary": catalog},
        ).open()
        opened.append(roots)
        service = LocalImportService(
            roots.descriptors(ConfiguredRootKind.LOCAL_INBOX),
            AcquisitionStore(roots.staging, lock_timeout=2),
            limits,
        )
        return service, inbox, staging

    try:
        yield build
    finally:
        for roots in reversed(opened):
            roots.close()


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


def test_source_and_pdf_import_collate_normal_receipt_with_local_custody(service_layout) -> None:
    service, inbox, staging = service_layout()
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


def test_same_bytes_are_idempotent_and_changed_bytes_conflict(service_layout) -> None:
    service, inbox, staging = service_layout()
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


def test_matching_unreceipted_destination_is_receipted_without_overwrite(
    service_layout,
) -> None:
    service, inbox, staging = service_layout()
    (inbox / "paper.pdf").write_bytes(PDF)
    dest = staging / "manual-paper"
    dest.mkdir()
    occupant = dest / "manual-paper.pdf"
    occupant.write_bytes(PDF)

    result = run_import(service, "paper.pdf")

    assert result.outcomes[0].status == "already-present"
    assert result.manifest is not None
    assert result.manifest.forms[0].custody == "local-import"
    assert occupant.read_bytes() == PDF
    assert not (dest / ".download.part").exists()


def test_mismatched_unreceipted_destination_still_conflicts(service_layout) -> None:
    service, inbox, staging = service_layout()
    (inbox / "paper.pdf").write_bytes(PDF)
    dest = staging / "manual-paper"
    dest.mkdir()
    occupant = dest / "manual-paper.pdf"
    occupant.write_bytes(PDF.replace(b"<<>>", b"<</Title(x)>>"))

    with pytest.raises(AcquisitionConflictError, match="occupies the local-import target"):
        run_import(service, "paper.pdf")
    assert occupant.read_bytes() == PDF.replace(b"<<>>", b"<</Title(x)>>")
    assert not (dest / "acquisition.json").exists()


def test_invalid_kind_truncated_payload_and_kind_limits_publish_nothing(service_layout) -> None:
    service, inbox, staging = service_layout(pdf_bytes=len(PDF) - 1)
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


def test_request_and_physical_file_confinement(
    service_layout,
    tmp_path: Path,
) -> None:
    service, inbox, _ = service_layout()

    for leaf in ("../paper.pdf", "nested/paper.pdf", str(tmp_path / "paper.pdf")):
        with pytest.raises(ValidationError):
            LocalImportRequest(inbox="manual", leaf=leaf, deposit_slug="paper")

    (inbox / "directory.pdf").mkdir()
    with pytest.raises(AcquisitionError, match="physical regular file"):
        run_import(service, "directory.pdf")

    outside = tmp_path / "outside-artifact"
    if os.name == "nt":
        outside.mkdir()
    else:
        outside.write_bytes(PDF)
    linked = inbox / "linked.pdf"
    try:
        if os.name == "nt":
            _create_directory_link(linked, outside)
            assert is_link_or_reparse(linked.lstat())
        else:
            linked.symlink_to(outside)
        with pytest.raises(AcquisitionError, match="physical regular file"):
            run_import(service, linked.name)
    finally:
        _remove_directory_link(linked)

    alias = tmp_path / "inbox-alias"
    try:
        _create_directory_link(alias, inbox)
        assert is_link_or_reparse(alias.lstat())
        staging = tmp_path / "other-staging"
        catalog = tmp_path / "other-catalog"
        staging.mkdir()
        catalog.mkdir()
        with pytest.raises(OSError):
            ProcurementRootCatalog(
                staging,
                local_inboxes={"manual": alias},
                article_catalogs={"primary": catalog},
            ).open()
    finally:
        _remove_directory_link(alias)


def test_detected_source_mutation_cleans_private_copy(service_layout) -> None:
    service, inbox, staging = service_layout()
    (inbox / "source.gz").write_bytes(SOURCE)

    with mock.patch(
        "procurement.operations.local_import._same_open_snapshot",
        return_value=False,
    ):
        with pytest.raises(AcquisitionConflictError, match="changed while copying"):
            run_import(service, "source.gz")

    assert not list(staging.rglob("acquisition.json"))
    assert not list(staging.rglob(".download.part"))


def test_cancellation_settles_local_publication_and_releases_item_pin(service_layout) -> None:
    async def exercise() -> None:
        service, inbox, staging = service_layout()
        (inbox / "paper.pdf").write_bytes(PDF)
        entered = threading.Event()
        release = threading.Event()
        original_copy = local_import_module._copy_import_candidate

        def delayed_copy(*args: object, **kwargs: object):
            result = original_copy(*args, **kwargs)
            entered.set()
            if not release.wait(2):
                raise AssertionError("test did not release the completed local copy")
            return result

        try:
            with mock.patch(
                "procurement.operations.local_import._copy_import_candidate",
                side_effect=delayed_copy,
            ):
                task = asyncio.create_task(
                    service.import_artifact(
                        LocalImportRequest(
                            inbox="manual",
                            leaf="paper.pdf",
                            deposit_slug="manual-paper",
                        )
                    )
                )
                assert await asyncio.to_thread(entered.wait, 1)
                task.cancel()
                await asyncio.sleep(0)
                assert not task.done()
                release.set()
                with pytest.raises(asyncio.CancelledError):
                    await task
        finally:
            release.set()

        second = await service.import_artifact(
            LocalImportRequest(
                inbox="manual",
                leaf="paper.pdf",
                deposit_slug="manual-paper",
            )
        )
        assert second.outcomes[0].status == "already-present"
        item = staging / "manual-paper"
        assert not (item / ".download.part").exists()
        assert not (item / ".acquisition-publish.json").exists()

    asyncio.run(exercise())


def test_local_copy_cannot_be_redirected_to_replaced_inbox_or_item(service_layout) -> None:
    async def exercise(target_kind: str) -> None:
        service, inbox, staging = service_layout()
        (inbox / "paper.pdf").write_bytes(PDF)
        entered = threading.Event()
        release = threading.Event()
        original_snapshot = local_import_module._same_open_snapshot

        def paused_snapshot(left: os.stat_result, right: os.stat_result) -> bool:
            entered.set()
            if not release.wait(2):
                raise AssertionError("test did not release the paused local copy")
            return original_snapshot(left, right)

        with mock.patch(
            "procurement.operations.local_import._same_open_snapshot",
            side_effect=paused_snapshot,
        ):
            task = asyncio.create_task(
                service.import_artifact(
                    LocalImportRequest(
                        inbox="manual",
                        leaf="paper.pdf",
                        deposit_slug="manual-paper",
                    )
                )
            )
            assert await asyncio.to_thread(entered.wait, 1)
            target = inbox if target_kind == "inbox" else staging / "manual-paper"
            displaced = (
                inbox.parent / "inbox-displaced"
                if target_kind == "inbox"
                else staging / "item-displaced"
            )
            swapped = False
            blocked = False
            replacement_body = b"%PDF-1.7\nreplacement\n%%EOF\n"
            try:
                os.rename(target, displaced)
            except OSError:
                # Windows directory pins deny the rename. POSIX pins keep both endpoints
                # descriptor-relative and reject success when the lexical generation changes.
                blocked = True
            else:
                swapped = True
                target.mkdir()
                if target_kind == "inbox":
                    (target / "paper.pdf").write_bytes(replacement_body)
            finally:
                release.set()

            if os.name == "nt":
                assert blocked is True
                assert swapped is False
                result = await asyncio.wait_for(task, timeout=2)
                assert result.outcomes[0].status == "acquired"
                assert not displaced.exists()
            else:
                assert swapped is True
                with pytest.raises(
                    AcquisitionConflictError,
                    match="retained directory generation",
                ):
                    await asyncio.wait_for(task, timeout=2)
                assert not list(staging.rglob("acquisition.json"))
                assert not list(staging.rglob(".download.part"))
                if target_kind == "inbox":
                    assert (target / "paper.pdf").read_bytes() == replacement_body
                else:
                    assert list(target.iterdir()) == []
    for target_kind in ("inbox", "item"):
        asyncio.run(exercise(target_kind))


def test_inbox_catalog_exposes_logical_names_only(service_layout, tmp_path: Path) -> None:
    service, _, _ = service_layout()

    assert service.inbox_names == ("manual",)
    assert service.inboxes().model_dump(mode="json") == {"inboxes": [{"name": "manual"}]}
    schema_text = json.dumps(service.inboxes().model_json_schema())
    assert str(tmp_path) not in schema_text
