"""Configured local custody transfer into acquisition staging."""

from __future__ import annotations

import asyncio
import hashlib
import os
import stat
from collections.abc import Mapping
from datetime import datetime, timezone
from functools import partial
from pathlib import Path
from typing import Literal, Self

from pydantic import Field, field_validator, model_validator

from procurement.errors import AcquisitionConflictError, AcquisitionError
from procurement.models import (
    ArtifactReference,
    DomainModel,
    PORTABLE_LEAF_PATTERN,
    validate_deposit_slug,
)
from procurement.payloads import (
    AcquiredArtifact,
    AcquisitionManifest,
    AcquisitionOutcome,
    AcquisitionResult,
    LocalImportProvenance,
)
from procurement.services.acquisition import validate_gzip_payload, validate_pdf_payload
from procurement.settings import ArtifactLimitSettings
from procurement.staging import AcquisitionItem, AcquisitionStore, collate_acquisition, validate_form_file

_COPY_CHUNK_BYTES = 1024 * 1024
_REPARSE_POINT = getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0x400)


class LocalImportRequest(DomainModel):
    """Logical local-inbox item to transfer into one staged acquisition."""

    inbox: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    leaf: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    deposit_slug: str = Field(
        min_length=1,
        json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN},
    )

    @field_validator("inbox", "leaf", "deposit_slug", mode="before")
    @classmethod
    def _portable_leaf(cls, value: object) -> str:
        return validate_deposit_slug(value)


class LocalImportInbox(DomainModel):
    """Logical local-import inbox exposed without its host path."""

    name: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})

    @field_validator("name", mode="before")
    @classmethod
    def _portable_name(cls, value: object) -> str:
        return validate_deposit_slug(value)


class LocalImportInboxCatalog(DomainModel):
    """Configured local-import inboxes safe to expose to clients."""

    inboxes: tuple[LocalImportInbox, ...]

    @model_validator(mode="after")
    def _unique_names(self) -> Self:
        names = [item.name.casefold() for item in self.inboxes]
        if len(names) != len(set(names)):
            raise ValueError("local-import inbox names must be unique")
        return self


class LocalImportService:
    """Validate configured direct-child files and publish narrow custody receipts."""

    def __init__(
        self,
        inboxes: Mapping[str, str | Path],
        store: AcquisitionStore,
        limits: ArtifactLimitSettings,
    ) -> None:
        configured: dict[str, tuple[str, Path]] = {}
        for name, path in inboxes.items():
            canonical = validate_deposit_slug(name)
            key = canonical.casefold()
            if key in configured:
                raise AcquisitionError(f"duplicate local-import inbox name: {canonical!r}")
            configured[key] = (
                canonical,
                _require_physical_directory(Path(path), label=f"local inbox {canonical!r}"),
            )
        if not configured:
            raise AcquisitionError("at least one local-import inbox is required")
        self._inboxes = configured
        self._store = store
        self._limits = limits

    @property
    def inbox_names(self) -> tuple[str, ...]:
        """Return configured logical names without host filesystem paths."""

        return tuple(value[0] for value in self._inboxes.values())

    def inboxes(self) -> LocalImportInboxCatalog:
        """Return typed logical inbox descriptors without host filesystem paths."""

        return LocalImportInboxCatalog(
            inboxes=tuple(LocalImportInbox(name=name) for name in self.inbox_names)
        )

    async def import_artifact(self, request: LocalImportRequest) -> AcquisitionResult:
        """Transfer one stable local file without blocking the caller's event loop."""

        loop = asyncio.get_running_loop()
        future = loop.run_in_executor(None, partial(self._import_artifact, request))
        try:
            return await asyncio.shield(future)
        except asyncio.CancelledError:
            try:
                await future
            except BaseException:
                pass
            raise

    def _import_artifact(self, request: LocalImportRequest) -> AcquisitionResult:
        inbox = self._inboxes.get(request.inbox.casefold())
        if inbox is None:
            raise AcquisitionError(
                f"unknown local-import inbox {request.inbox!r}; "
                f"configured names: {', '.join(self.inbox_names)}"
            )
        inbox_name, root = inbox
        source = root / request.leaf
        if source.parent != root:
            raise AcquisitionError("local import must name one direct inbox child")

        artifact = ArtifactReference(
            provider="manual-import",
            identifier=request.deposit_slug,
            provider_roles=("artifact-access",),
        )
        with self._store.transaction(request.deposit_slug) as item:
            manifest = item.recover(item.read_manifest())
            if manifest is not None and manifest.artifact != artifact:
                raise AcquisitionConflictError(
                    "staging item acquisition identity conflicts with the local import"
                )

            partial = item.private_download_path()
            journal: Path | None = None
            try:
                kind, size, digest = _copy_import_candidate(
                    source,
                    partial,
                    source_maximum=self._limits.source_bytes,
                    pdf_maximum=self._limits.pdf_bytes,
                )
                if kind == "source":
                    validate_gzip_payload(
                        partial,
                        maximum_expanded_bytes=self._limits.expanded_source_bytes,
                    )
                    target_leaf = f"{request.deposit_slug}.tar.gz"
                    media_type = "application/gzip"
                else:
                    validate_pdf_payload(partial)
                    target_leaf = f"{request.deposit_slug}.pdf"
                    media_type = "application/pdf"

                form = AcquiredArtifact(
                    kind=kind,
                    path=target_leaf,
                    format=media_type,
                    bytes=size,
                    sha256=digest,
                    custody="local-import",
                    local_import=LocalImportProvenance(
                        inbox=inbox_name,
                        leaf=request.leaf,
                        imported_at=datetime.now(timezone.utc),
                    ),
                )
                existing = (
                    next((value for value in manifest.forms if value.kind == kind), None)
                    if manifest is not None
                    else None
                )
                if existing is not None:
                    if existing.path != target_leaf:
                        raise AcquisitionConflictError(
                            f"existing {kind!r} target disagrees with the local-import target"
                        )
                    validate_form_file(item.directory, existing)
                    if existing.bytes != size or existing.sha256 != digest:
                        raise AcquisitionConflictError(
                            f"local {kind!r} bytes conflict with the existing receipt"
                        )
                    return _result(
                        item,
                        manifest,
                        AcquisitionOutcome(
                            kind=kind,
                            status="already-present",
                            path=existing.path,
                        ),
                    )

                destination = item.artifact_path(target_leaf)
                if os.path.lexists(destination):
                    raise AcquisitionConflictError(
                        f"unreceipted artifact occupies the local-import target: '{destination}'"
                    )

                journal = item.write_journal(artifact, partial, form)
                item.publish_download(partial, form)
                incoming = AcquisitionManifest(
                    slug=request.deposit_slug,
                    artifact=artifact,
                    forms=(form,),
                )
                manifest = collate_acquisition(manifest, incoming)
                item.publish_manifest(manifest)
                journal.unlink()
                journal = None
                for value in manifest.forms:
                    validate_form_file(item.directory, value)
                return _result(
                    item,
                    manifest,
                    AcquisitionOutcome(kind=kind, status="acquired", path=form.path),
                )
            finally:
                if os.path.lexists(partial):
                    try:
                        partial.unlink()
                    except OSError:
                        pass


def _result(
    item: AcquisitionItem,
    manifest: AcquisitionManifest,
    outcome: AcquisitionOutcome,
) -> AcquisitionResult:
    return AcquisitionResult(
        staging_directory=str(item.directory),
        manifest_path=str(item.manifest_path),
        manifest=manifest,
        outcomes=(outcome,),
    )


def _is_link_or_reparse(info: os.stat_result) -> bool:
    return stat.S_ISLNK(info.st_mode) or bool(
        getattr(info, "st_file_attributes", 0) & _REPARSE_POINT
    )


def _same_open_snapshot(left: os.stat_result, right: os.stat_result) -> bool:
    fields = ("st_dev", "st_ino", "st_size", "st_mtime_ns", "st_ctime_ns")
    return all(getattr(left, field, None) == getattr(right, field, None) for field in fields)


def _same_named_generation(left: os.stat_result, right: os.stat_result) -> bool:
    if left.st_ino or right.st_ino:
        return (
            left.st_dev == right.st_dev
            and left.st_ino == right.st_ino
            and left.st_size == right.st_size
        )
    return (
        left.st_dev == right.st_dev
        and left.st_size == right.st_size
        and getattr(left, "st_mtime_ns", None) == getattr(right, "st_mtime_ns", None)
    )


def _require_physical_directory(path: Path, *, label: str) -> Path:
    requested = path.absolute()
    try:
        info = requested.stat(follow_symlinks=False)
        resolved = requested.resolve(strict=True)
    except OSError as exc:
        raise AcquisitionError(f"{label} is not accessible: '{requested}'") from exc
    if not stat.S_ISDIR(info.st_mode) or _is_link_or_reparse(info):
        raise AcquisitionError(f"{label} must be a physical directory: '{requested}'")
    if os.path.normcase(str(requested)) != os.path.normcase(str(resolved)):
        raise AcquisitionError(f"{label} must not traverse a link: '{requested}'")
    return resolved


def _classify(head: bytes) -> Literal["source", "pdf"]:
    if head.startswith(b"%PDF-"):
        return "pdf"
    if head.startswith(b"\x1f\x8b"):
        return "source"
    raise AcquisitionError("local import is neither a PDF nor a gzip source payload")


def _copy_import_candidate(
    source: Path,
    destination: Path,
    *,
    source_maximum: int,
    pdf_maximum: int,
) -> tuple[Literal["source", "pdf"], int, str]:
    """Copy one stable direct-child generation and return its classified digest."""

    try:
        named_before = source.stat(follow_symlinks=False)
    except OSError as exc:
        raise AcquisitionError(f"local-import file is not readable: '{source}'") from exc
    if not stat.S_ISREG(named_before.st_mode) or _is_link_or_reparse(named_before):
        raise AcquisitionError(f"local-import file must be a physical regular file: '{source}'")
    maximum = max(source_maximum, pdf_maximum)
    if named_before.st_size < 1:
        raise AcquisitionError("local-import file is empty")
    if named_before.st_size > maximum:
        raise AcquisitionError(
            f"local-import file exceeds the {maximum}-byte absolute boundary"
        )

    flags = os.O_RDONLY | getattr(os, "O_BINARY", 0) | getattr(os, "O_NOFOLLOW", 0)
    try:
        descriptor = os.open(source, flags)
        with os.fdopen(descriptor, "rb") as input_handle, destination.open("xb") as output_handle:
            opened_before = os.fstat(input_handle.fileno())
            if not stat.S_ISREG(opened_before.st_mode) or not _same_named_generation(
                named_before, opened_before
            ):
                raise AcquisitionConflictError(
                    f"local-import file changed before copying: '{source}'"
                )
            head = input_handle.read(5)
            kind = _classify(head)
            maximum = source_maximum if kind == "source" else pdf_maximum
            if opened_before.st_size > maximum:
                raise AcquisitionError(
                    f"local {kind} exceeds the {maximum}-byte boundary"
                )
            input_handle.seek(0)
            digest = hashlib.sha256()
            size = 0
            while chunk := input_handle.read(_COPY_CHUNK_BYTES):
                if len(chunk) > maximum - size:
                    raise AcquisitionError(
                        f"local {kind} exceeds the {maximum}-byte boundary"
                    )
                size += len(chunk)
                digest.update(chunk)
                output_handle.write(chunk)
            output_handle.flush()
            os.fsync(output_handle.fileno())
            opened_after = os.fstat(input_handle.fileno())
    except (AcquisitionError, AcquisitionConflictError):
        raise
    except OSError as exc:
        raise AcquisitionError(f"local-import file could not be copied: '{source}'") from exc

    if size != opened_after.st_size or not _same_open_snapshot(opened_before, opened_after):
        raise AcquisitionConflictError(f"local-import file changed while copying: '{source}'")
    try:
        named_after = source.stat(follow_symlinks=False)
    except OSError as exc:
        raise AcquisitionConflictError(
            f"local-import file disappeared after copying: '{source}'"
        ) from exc
    if _is_link_or_reparse(named_after) or not _same_named_generation(opened_after, named_after):
        raise AcquisitionConflictError(f"local-import path changed while copying: '{source}'")
    return kind, size, digest.hexdigest()


__all__ = [
    "LocalImportInbox",
    "LocalImportInboxCatalog",
    "LocalImportRequest",
    "LocalImportService",
]
