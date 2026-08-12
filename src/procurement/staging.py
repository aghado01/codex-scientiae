"""Path-confined acquisition receipt storage and crash recovery."""

from __future__ import annotations

import hashlib
import os
import re
import stat
from contextlib import contextmanager
from pathlib import Path
from typing import Iterator, Literal
from uuid import uuid4

from filelock import FileLock, Timeout
from pydantic import Field, field_validator, model_validator

from jsonl_engine.sidecar import lock_path
from jsonl_engine.writer import write_json
from procurement.errors import AcquisitionConflictError, AcquisitionError
from procurement.models import ArtifactReference, DomainModel, validate_deposit_slug
from procurement.payloads import AcquiredArtifact, AcquisitionManifest

MAX_ACQUISITION_MANIFEST_BYTES = 1024 * 1024
_JOURNAL_PATTERN = re.compile(r"^\.acquisition-publish-[0-9a-f]{32}\.json$")
_PARTIAL_PATTERN = re.compile(r"^\.download-[0-9a-f]{32}\.part$")
_FORM_ORDER = {"source": 0, "pdf": 1, "html": 2}


def _is_reparse(info: os.stat_result) -> bool:
    return bool(getattr(info, "st_file_attributes", 0) & 0x400)


def _require_plain_directory(path: Path, *, label: str) -> Path:
    requested = path.absolute()
    try:
        info = requested.lstat()
    except OSError as exc:
        raise AcquisitionError(f"{label} is not accessible: '{requested}'") from exc
    if not stat.S_ISDIR(info.st_mode) or stat.S_ISLNK(info.st_mode) or _is_reparse(info):
        raise AcquisitionError(f"{label} must be a physical directory: '{requested}'")
    resolved = requested.resolve(strict=True)
    if os.path.normcase(str(requested)) != os.path.normcase(str(resolved)):
        raise AcquisitionError(f"{label} must not traverse a link or reparse point: '{requested}'")
    return resolved


def _stable_bytes(path: Path, *, maximum: int) -> bytes:
    try:
        with path.open("rb") as handle:
            before = os.fstat(handle.fileno())
            if not stat.S_ISREG(before.st_mode) or _is_reparse(before):
                raise AcquisitionConflictError(f"receipt is not a regular file: '{path}'")
            if before.st_size > maximum:
                raise AcquisitionConflictError(
                    f"receipt exceeds the {maximum}-byte boundary: '{path}'"
                )
            raw = handle.read(maximum + 1)
            after = os.fstat(handle.fileno())
    except AcquisitionConflictError:
        raise
    except OSError as exc:
        raise AcquisitionConflictError(f"receipt cannot be read: '{path}'") from exc
    if len(raw) > maximum or len(raw) != after.st_size:
        raise AcquisitionConflictError(f"receipt changed while being read: '{path}'")
    before_identity = (
        before.st_dev,
        before.st_ino,
        before.st_size,
        before.st_mtime_ns,
        getattr(before, "st_ctime_ns", None),
    )
    after_identity = (
        after.st_dev,
        after.st_ino,
        after.st_size,
        after.st_mtime_ns,
        getattr(after, "st_ctime_ns", None),
    )
    if before_identity != after_identity:
        raise AcquisitionConflictError(f"receipt changed while being read: '{path}'")
    current = path.lstat()
    if (
        not stat.S_ISREG(current.st_mode)
        or _is_reparse(current)
        or current.st_dev != after.st_dev
        or current.st_ino != after.st_ino
        or current.st_size != after.st_size
    ):
        raise AcquisitionConflictError(f"receipt path changed while being read: '{path}'")
    return raw


def _measure_file(path: Path) -> tuple[int, str]:
    digest = hashlib.sha256()
    size = 0
    try:
        with path.open("rb") as handle:
            before = os.fstat(handle.fileno())
            if not stat.S_ISREG(before.st_mode) or _is_reparse(before):
                raise AcquisitionConflictError(f"artifact is not a regular file: '{path}'")
            while chunk := handle.read(1024 * 1024):
                size += len(chunk)
                digest.update(chunk)
            after = os.fstat(handle.fileno())
    except AcquisitionConflictError:
        raise
    except OSError as exc:
        raise AcquisitionConflictError(f"artifact cannot be measured: '{path}'") from exc
    if (
        size != after.st_size
        or before.st_dev != after.st_dev
        or before.st_ino != after.st_ino
        or before.st_mtime_ns != after.st_mtime_ns
        or getattr(before, "st_ctime_ns", None) != getattr(after, "st_ctime_ns", None)
    ):
        raise AcquisitionConflictError(f"artifact changed while being measured: '{path}'")
    current = path.lstat()
    if (
        not stat.S_ISREG(current.st_mode)
        or _is_reparse(current)
        or current.st_dev != after.st_dev
        or current.st_ino != after.st_ino
        or current.st_size != after.st_size
    ):
        raise AcquisitionConflictError(f"artifact path changed while being measured: '{path}'")
    return size, digest.hexdigest()


def measure_artifact_file(path: str | Path) -> tuple[int, str]:
    """Return stable byte count and SHA-256 for one physical artifact file."""

    return _measure_file(Path(path))


def validate_form_file(directory: Path, form: AcquiredArtifact) -> Path:
    """Validate one receipt form against the physical file it names."""

    leaf = validate_deposit_slug(form.path)
    path = directory / leaf
    size, digest = _measure_file(path)
    if size != form.bytes or digest != form.sha256:
        raise AcquisitionConflictError(
            f"staged artifact no longer matches acquisition.json: '{path}'"
        )
    return path


def collate_acquisition(
    existing: AcquisitionManifest | None,
    incoming: AcquisitionManifest,
) -> AcquisitionManifest:
    """Union compatible acquired forms without weakening prior evidence."""

    if existing is None:
        return incoming
    if existing.slug != incoming.slug or existing.artifact != incoming.artifact:
        raise AcquisitionConflictError("acquisition receipt identity conflicts with the staged item")
    forms = {form.kind: form for form in existing.forms}
    for new_form in incoming.forms:
        current = forms.get(new_form.kind)
        if current is None:
            forms[new_form.kind] = new_form
            continue
        immutable = ("path", "format", "bytes", "sha256")
        if any(getattr(current, field) != getattr(new_form, field) for field in immutable):
            raise AcquisitionConflictError(
                f"acquired {new_form.kind!r} form conflicts with its existing receipt"
            )
        if (
            current.provider_checksum is not None
            and new_form.provider_checksum is not None
            and current.provider_checksum != new_form.provider_checksum
        ):
            raise AcquisitionConflictError(
                f"provider checksum for {new_form.kind!r} conflicts with its existing receipt"
            )
        if current.provider_checksum is None and new_form.provider_checksum is not None:
            forms[new_form.kind] = current.model_copy(
                update={"provider_checksum": new_form.provider_checksum}
            )
    ordered = tuple(sorted(forms.values(), key=lambda form: _FORM_ORDER[form.kind]))
    return AcquisitionManifest(
        slug=existing.slug,
        artifact=existing.artifact,
        forms=ordered,
    )


class _PublicationJournal(DomainModel):
    schema_id: Literal["codex-scientiae/acquisition-publication/0.1"] = Field(
        default="codex-scientiae/acquisition-publication/0.1",
        alias="schema",
    )
    slug: str
    artifact: ArtifactReference
    partial_leaf: str
    form: AcquiredArtifact

    @field_validator("slug", mode="before")
    @classmethod
    def _portable_slug(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @field_validator("partial_leaf", mode="before")
    @classmethod
    def _private_partial(cls, value: object) -> str:
        if not isinstance(value, str) or not _PARTIAL_PATTERN.fullmatch(value):
            raise ValueError("publication journal partial_leaf is invalid")
        return value

    @model_validator(mode="after")
    def _canonical_identity(self) -> "_PublicationJournal":
        AcquisitionManifest(slug=self.slug, artifact=self.artifact, forms=(self.form,))
        return self


class AcquisitionItem:
    """One locked staging item transaction."""

    def __init__(self, directory: Path) -> None:
        self.directory = directory
        self.manifest_path = directory / "acquisition.json"

    def read_manifest(self) -> AcquisitionManifest | None:
        if not os.path.lexists(self.manifest_path):
            return None
        raw = _stable_bytes(self.manifest_path, maximum=MAX_ACQUISITION_MANIFEST_BYTES)
        try:
            return AcquisitionManifest.model_validate_json(raw)
        except ValueError as exc:
            raise AcquisitionConflictError(
                f"existing acquisition.json is invalid: '{self.manifest_path}': {exc}"
            ) from exc

    def publish_manifest(self, manifest: AcquisitionManifest) -> None:
        if manifest.slug != self.directory.name:
            raise AcquisitionConflictError("acquisition receipt slug does not match its directory")
        write_json(
            str(self.manifest_path),
            manifest.model_dump(mode="json", by_alias=True),
            indent=2,
            overwrite=os.path.lexists(self.manifest_path),
        )

    def private_download_path(self) -> Path:
        return self.directory / f".download-{uuid4().hex}.part"

    def artifact_path(self, leaf: str) -> Path:
        return self.directory / validate_deposit_slug(leaf)

    def write_journal(self, artifact: ArtifactReference, partial: Path, form: AcquiredArtifact) -> Path:
        if partial.parent != self.directory or not _PARTIAL_PATTERN.fullmatch(partial.name):
            raise AcquisitionError("publication partial is outside the locked staging item")
        journal = _PublicationJournal(
            slug=self.directory.name,
            artifact=artifact,
            partial_leaf=partial.name,
            form=form,
        )
        path = self.directory / f".acquisition-publish-{uuid4().hex}.json"
        write_json(
            str(path),
            journal.model_dump(mode="json", by_alias=True),
            indent=2,
            overwrite=False,
        )
        return path

    def publish_download(self, partial: Path, form: AcquiredArtifact) -> Path:
        if partial.parent != self.directory or not _PARTIAL_PATTERN.fullmatch(partial.name):
            raise AcquisitionError("publication partial is outside the locked staging item")
        destination = self.artifact_path(form.path)
        if os.path.lexists(destination):
            raise AcquisitionConflictError(f"refusing to overwrite staged artifact: '{destination}'")
        try:
            os.link(partial, destination, follow_symlinks=False)
            partial.unlink()
        except FileExistsError as exc:
            raise AcquisitionConflictError(
                f"staged artifact appeared during publication: '{destination}'"
            ) from exc
        except OSError as exc:
            raise AcquisitionError(f"artifact publication failed: '{destination}'") from exc
        validate_form_file(self.directory, form)
        return destination

    def recover(self, existing: AcquisitionManifest | None) -> AcquisitionManifest | None:
        """Finish journaled publications and remove abandoned private downloads."""

        manifest = existing
        journals = sorted(
            entry for entry in self.directory.iterdir() if _JOURNAL_PATTERN.fullmatch(entry.name)
        )
        for path in journals:
            raw = _stable_bytes(path, maximum=MAX_ACQUISITION_MANIFEST_BYTES)
            try:
                journal = _PublicationJournal.model_validate_json(raw)
            except ValueError as exc:
                raise AcquisitionConflictError(f"invalid acquisition publication journal: '{path}'") from exc
            if journal.slug != self.directory.name:
                raise AcquisitionConflictError(f"publication journal targets another item: '{path}'")
            partial = self.directory / journal.partial_leaf
            destination = self.artifact_path(journal.form.path)
            if os.path.lexists(destination):
                validate_form_file(self.directory, journal.form)
                if os.path.lexists(partial):
                    size, digest = _measure_file(partial)
                    if size != journal.form.bytes or digest != journal.form.sha256:
                        raise AcquisitionConflictError(
                            f"publication partial conflicts with journal: '{partial}'"
                        )
                    partial.unlink()
            elif os.path.lexists(partial):
                size, digest = _measure_file(partial)
                if size != journal.form.bytes or digest != journal.form.sha256:
                    raise AcquisitionConflictError(f"publication partial conflicts with journal: '{partial}'")
                self.publish_download(partial, journal.form)
            else:
                path.unlink()
                continue
            incoming = AcquisitionManifest(
                slug=journal.slug,
                artifact=journal.artifact,
                forms=(journal.form,),
            )
            manifest = collate_acquisition(manifest, incoming)
            self.publish_manifest(manifest)
            path.unlink()

        for entry in self.directory.iterdir():
            if _PARTIAL_PATTERN.fullmatch(entry.name):
                info = entry.lstat()
                if not stat.S_ISREG(info.st_mode) or _is_reparse(info):
                    raise AcquisitionConflictError(f"private download is not a regular file: '{entry}'")
                entry.unlink()
        return manifest


class AcquisitionStore:
    """Configured staging collection with one lease per acquisition receipt."""

    def __init__(self, root: str | Path, *, lock_timeout: float = 60.0) -> None:
        self.root = _require_plain_directory(Path(root), label="acquisition staging root")
        self.lock_timeout = lock_timeout

    @contextmanager
    def transaction(self, slug: str, *, create: bool = True) -> Iterator[AcquisitionItem]:
        slug = validate_deposit_slug(slug)
        directory = self.root / slug
        item = AcquisitionItem(directory)
        lease = FileLock(lock_path(str(item.manifest_path)), timeout=self.lock_timeout)
        try:
            lease.acquire()
        except Timeout as exc:
            raise TimeoutError(
                f"could not acquire acquisition receipt lease within {self.lock_timeout}s: "
                f"'{item.manifest_path}'"
            ) from exc
        try:
            if os.path.lexists(directory):
                _require_plain_directory(directory, label="acquisition item directory")
            elif create:
                directory.mkdir()
            else:
                raise AcquisitionError(f"acquisition item does not exist: '{directory}'")
            yield item
        finally:
            lease.release()
