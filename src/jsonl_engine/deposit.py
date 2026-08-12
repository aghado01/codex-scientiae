"""Article deposit assembly and immutable publication.

The service accepts source facts established by the PowerShell LaTeX transaction. It resolves and
fingerprints deposited files, projects optional provider metadata, validates the article schema,
and creates ``article.json``. An existing compatible article is returned unchanged; an invalid or
incompatible article is a visible conflict. The caller owns source-tree coordination for the whole
call; the PowerShell orchestrator supplies that lock. File-generation witnesses are checked on both
sides of publication, and a newly created article is rolled back if the closing check detects drift.
"""

from __future__ import annotations

import copy
import hashlib
import ntpath
import os
import posixpath
import stat
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, Dict, Iterable, List, Optional, Tuple

from filelock import FileLock, Timeout
from pydantic import ValidationError
from procurement.limits import MAX_DEPOSIT_METADATA_BUNDLE_BYTES
from procurement.models import DepositMetadataBundle

from .kinds.article import ArticleManifest
from .reader import loads
from .sidecar import lock_path
from .writer import serialize_json

__all__ = ["DepositConflict", "DepositError", "DepositResult", "deposit_article"]


class DepositError(ValueError):
    """A deposit request or one of its source artifacts is invalid."""


class DepositConflict(DepositError):
    """An existing article is invalid or does not describe the requested deposit."""


@dataclass(frozen=True)
class DepositResult:
    """The one result emitted for a completed or idempotent deposit."""

    status: str
    article_path: str
    archive_path: str
    source_path: str
    article: Dict[str, Any]

    @property
    def created(self) -> bool:
        return self.status == "deposited"

    def as_dict(self) -> Dict[str, Any]:
        return {
            "status": self.status,
            "created": self.created,
            "article_path": self.article_path,
            "archive_path": self.archive_path,
            "source_path": self.source_path,
            "article": copy.deepcopy(self.article),
        }


@dataclass(frozen=True)
class _FileWitness:
    """Identity and mutation facts retained from one measured source file."""

    path: str
    device: int
    inode: int
    size: int
    mtime_ns: int
    ctime_ns: int

    @classmethod
    def capture(cls, path: str, info: os.stat_result) -> "_FileWitness":
        return cls(
            path=path,
            device=info.st_dev,
            inode=info.st_ino,
            size=info.st_size,
            mtime_ns=getattr(info, "st_mtime_ns", int(info.st_mtime * 1_000_000_000)),
            ctime_ns=getattr(info, "st_ctime_ns", int(info.st_ctime * 1_000_000_000)),
        )

    def matches(self, info: os.stat_result) -> bool:
        current = type(self).capture(self.path, info)
        return current == self


def _same_file_generation(left: os.stat_result, right: os.stat_result) -> bool:
    """Compare an opened file with its pathname without relying on close-finalized timestamps."""
    if left.st_ino or right.st_ino:
        return (
            left.st_dev == right.st_dev
            and left.st_ino == right.st_ino
            and left.st_size == right.st_size
        )
    return (
        left.st_dev == right.st_dev
        and left.st_size == right.st_size
        and getattr(left, "st_ctime_ns", None) == getattr(right, "st_ctime_ns", None)
    )


_ARCHIVE_KINDS = frozenset(("tar+gzip", "single-tex+gzip"))
_PUBLICATIONS = frozenset(("published-new-tree", "recovered-existing-tree"))
_INVALID_PORTABLE_LEAF = frozenset('<>:"/\\|?*')
_WINDOWS_RESERVED_LEAVES = frozenset(
    ("CON", "PRN", "AUX", "NUL")
    + tuple(f"COM{number}" for number in range(1, 10))
    + tuple(f"LPT{number}" for number in range(1, 10))
)


def _utc_timestamp() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def _within(root: str, candidate: str) -> bool:
    try:
        return os.path.normcase(os.path.commonpath((root, candidate))) == os.path.normcase(root)
    except ValueError:
        return False


def _document_root(document_dir: str) -> Tuple[str, str]:
    requested = os.path.abspath(os.fspath(document_dir))
    if not os.path.isdir(requested):
        raise DepositError(f"document deposit is not a directory: '{requested}'")
    resolved = os.path.realpath(requested)
    if os.path.normcase(os.path.normpath(requested)) != os.path.normcase(
        os.path.normpath(resolved)
    ):
        raise DepositError(
            f"document deposit must not traverse a symbolic link or reparse point: '{requested}'"
        )
    return resolved, os.path.basename(os.path.normpath(requested))


def _validate_slug(slug: str, *, directory_leaf: str) -> str:
    if not isinstance(slug, str) or not _is_portable_leaf(slug):
        raise DepositError(f"slug must be one non-empty portable directory leaf: {slug!r}")
    if slug != directory_leaf:
        raise DepositError(
            f"slug {slug!r} does not match document directory leaf {directory_leaf!r}"
        )
    return slug


def _is_portable_leaf(value: str) -> bool:
    """Whether one path component is portable across the supported filesystems."""
    if not value or value in (".", "..") or value[-1] in (" ", "."):
        return False
    if any(ord(char) < 32 or char in _INVALID_PORTABLE_LEAF for char in value):
        return False
    return value.split(".", 1)[0].upper() not in _WINDOWS_RESERVED_LEAVES


def _resolve_relative(
    root: str,
    value: str,
    *,
    label: str,
    kind: str,
) -> Tuple[str, str]:
    if not isinstance(value, str) or not value:
        raise DepositError(f"{label} must be a non-empty portable relative path")
    drive, _ = ntpath.splitdrive(value)
    normalized = posixpath.normpath(value)
    components = value.split("/")
    if (
        "\\" in value
        or drive
        or value.startswith("/")
        or normalized != value
        or normalized in (".", "..")
        or any(not _is_portable_leaf(part) for part in components)
    ):
        raise DepositError(f"{label} must be a normalized portable relative path: {value!r}")

    lexical = os.path.abspath(os.path.join(root, *components))
    actual = os.path.realpath(lexical)
    if not _within(root, lexical) or not _within(root, actual):
        raise DepositError(f"{label} escapes the document directory: {value!r}")
    if os.path.normcase(os.path.normpath(lexical)) != os.path.normcase(
        os.path.normpath(actual)
    ):
        raise DepositError(f"{label} must not traverse a symbolic link or reparse point: {value!r}")
    if kind == "file" and not os.path.isfile(actual):
        raise DepositError(f"{label} file not found: '{lexical}'")
    if kind == "directory" and not os.path.isdir(actual):
        raise DepositError(f"{label} directory not found: '{lexical}'")
    return value, actual


def _stable_read(
    path: str,
    *,
    max_bytes: int | None = None,
) -> Tuple[bytes, _FileWitness]:
    with open(path, "rb") as handle:
        before = os.fstat(handle.fileno())
        if not stat.S_ISREG(before.st_mode):
            raise DepositError(f"source is not a regular file: '{path}'")
        if max_bytes is not None and before.st_size > max_bytes:
            raise DepositError(
                f"source exceeds the {max_bytes}-byte read limit: '{path}'"
            )
        raw = handle.read() if max_bytes is None else handle.read(max_bytes + 1)
        if max_bytes is not None and len(raw) > max_bytes:
            raise DepositError(
                f"source exceeds the {max_bytes}-byte read limit: '{path}'"
            )
        after = os.fstat(handle.fileno())
    identity_before = (
        before.st_dev,
        before.st_ino,
        before.st_size,
        before.st_mtime_ns,
        before.st_ctime_ns,
    )
    identity_after = (
        after.st_dev,
        after.st_ino,
        after.st_size,
        after.st_mtime_ns,
        after.st_ctime_ns,
    )
    if identity_before != identity_after or len(raw) != after.st_size:
        raise DepositError(f"file changed while it was being read: '{path}'")
    try:
        current = os.stat(path, follow_symlinks=False)
    except OSError as exc:
        raise DepositError(f"file path changed while it was being read: '{path}'") from exc
    if not stat.S_ISREG(current.st_mode) or not _same_file_generation(after, current):
        raise DepositError(f"file path changed while it was being read: '{path}'")
    return raw, _FileWitness.capture(path, current)


def _fingerprint(path: str) -> Tuple[int, str, _FileWitness]:
    digest = hashlib.sha256()
    size = 0
    with open(path, "rb") as handle:
        before = os.fstat(handle.fileno())
        if not stat.S_ISREG(before.st_mode):
            raise DepositError(f"source is not a regular file: '{path}'")
        while True:
            chunk = handle.read(1024 * 1024)
            if not chunk:
                break
            size += len(chunk)
            digest.update(chunk)
        after = os.fstat(handle.fileno())
    identity_before = (
        before.st_dev,
        before.st_ino,
        before.st_size,
        before.st_mtime_ns,
        before.st_ctime_ns,
    )
    identity_after = (
        after.st_dev,
        after.st_ino,
        after.st_size,
        after.st_mtime_ns,
        after.st_ctime_ns,
    )
    if identity_before != identity_after or size != after.st_size:
        raise DepositError(f"file changed while it was being fingerprinted: '{path}'")
    try:
        current = os.stat(path, follow_symlinks=False)
    except OSError as exc:
        raise DepositError(
            f"file path changed while it was being fingerprinted: '{path}'"
        ) from exc
    if not stat.S_ISREG(current.st_mode) or not _same_file_generation(after, current):
        raise DepositError(f"file path changed while it was being fingerprinted: '{path}'")
    return size, digest.hexdigest(), _FileWitness.capture(path, current)


def _fingerprint_tree(root: str) -> Tuple[str, int, int]:
    """Recompute the PowerShell source-tree fingerprint without following links."""

    records: List[Tuple[str, str]] = []
    portable_paths: set[str] = set()
    pending = [root]
    while pending:
        directory = pending.pop()
        try:
            entries = list(os.scandir(directory))
        except OSError as exc:
            raise DepositError(f"source tree cannot be enumerated: '{directory}'") from exc
        for entry in entries:
            try:
                info = entry.stat(follow_symlinks=False)
            except OSError as exc:
                raise DepositError(f"source tree entry cannot be measured: '{entry.path}'") from exc
            attributes = getattr(info, "st_file_attributes", 0)
            if stat.S_ISLNK(info.st_mode) or attributes & 0x400:
                raise DepositError(
                    f"source tree contains a symbolic link or reparse point: '{entry.path}'"
                )
            if stat.S_ISDIR(info.st_mode):
                pending.append(entry.path)
                continue
            if not stat.S_ISREG(info.st_mode):
                raise DepositError(f"source tree entry is not a regular file: '{entry.path}'")
            relative = os.path.relpath(entry.path, root).replace(os.sep, "/")
            parts = relative.split("/")
            if any(not _is_portable_leaf(part) for part in parts):
                raise DepositError(f"source tree contains a non-portable path: {relative!r}")
            portable_key = relative.casefold()
            if portable_key in portable_paths:
                raise DepositError(
                    f"source tree contains duplicate or case-colliding paths: {relative!r}"
                )
            portable_paths.add(portable_key)
            records.append((relative, entry.path))
    if not records:
        raise DepositError(f"source tree is empty: '{root}'")

    records.sort(key=lambda item: item[0].encode("utf-16-be", "surrogatepass"))
    witnessed: List[bytes] = []
    tex_files = 0
    for relative, path in records:
        size, digest, _ = _fingerprint(path)
        witnessed.append(f"{relative}\0{size}\0{digest}\n".encode("utf-8"))
        if relative.casefold().endswith(".tex"):
            tex_files += 1
    tree_hash = hashlib.sha256(b"".join(witnessed)).hexdigest()
    return tree_hash, len(records), tex_files


def _assert_tree_snapshot(
    root: str,
    *,
    expected_sha256: str,
    expected_files: int,
    expected_tex_files: int,
) -> None:
    actual_sha256, actual_files, actual_tex_files = _fingerprint_tree(root)
    if actual_sha256 != expected_sha256:
        raise DepositConflict("published source tree does not match its supplied sha256")
    if actual_files != expected_files or actual_tex_files != expected_tex_files:
        raise DepositConflict(
            "published source tree counts do not match supplied files/tex_files"
        )


def _assert_file_witnesses(witnesses: Iterable[_FileWitness]) -> None:
    """Refuse publication when a measured path no longer names the measured file generation."""
    for witness in witnesses:
        try:
            current = os.stat(witness.path, follow_symlinks=False)
        except OSError as exc:
            raise DepositError(
                f"measured source disappeared before article publication: '{witness.path}'"
            ) from exc
        if not stat.S_ISREG(current.st_mode) or not witness.matches(current):
            raise DepositError(
                f"measured source changed before article publication: '{witness.path}'"
            )


def _file_record(
    *,
    path: str,
    full_path: str,
    role: str,
    media_type: str,
    witnesses: List[_FileWitness],
    extra: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
    size, digest, witness = _fingerprint(full_path)
    witnesses.append(witness)
    record: Dict[str, Any] = {
        "role": role,
        "path": path,
        "format": media_type,
        "bytes": size,
        "sha256": digest,
    }
    if extra:
        record.update(extra)
    return record


def _read_object_with_bytes(
    path: str,
    *,
    label: str,
    max_bytes: int | None = None,
) -> Tuple[Dict[str, Any], bytes, _FileWitness]:
    try:
        raw, witness = _stable_read(path, max_bytes=max_bytes)
        value = loads(raw, path=path)
    except DepositError:
        raise
    except Exception as exc:
        raise DepositError(f"{label} is not a strict UTF-8 JSON object: '{path}': {exc}") from exc
    return value, raw, witness


def _read_object(path: str, *, label: str) -> Dict[str, Any]:
    return _read_object_with_bytes(path, label=label)[0]


def _read_findings(path: str) -> Dict[str, Any]:
    full = os.path.abspath(os.fspath(path))
    findings = _read_object(full, label="findings JSON")
    required = {"checks", "declarations", "package_control_files"}
    actual = set(findings)
    if actual != required:
        missing = sorted(required - actual)
        unexpected = sorted(actual - required)
        detail = []
        if missing:
            detail.append(f"missing {missing}")
        if unexpected:
            detail.append(f"unexpected {unexpected}")
        raise DepositError("findings JSON fields are invalid: " + "; ".join(detail))
    return findings


def _provider_values(provider: Optional[Dict[str, Any]]) -> Dict[str, Any]:
    if provider is None:
        return {
            "title": None,
            "authors": [],
            "abstract": None,
            "identifiers": {"arxiv": None, "arxiv_versioned": None, "doi": None},
            "categories": [],
            "primary_category": None,
            "published": None,
            "updated": None,
        }
    authors = provider.get("authors")
    categories = provider.get("categories")
    return {
        "title": provider.get("title"),
        "authors": [] if authors is None else authors,
        "abstract": provider.get("abstract"),
        "identifiers": {
            "arxiv": provider.get("id"),
            "arxiv_versioned": provider.get("idv"),
            "doi": provider.get("doi"),
        },
        "categories": [] if categories is None else categories,
        "primary_category": provider.get("primary_category"),
        "published": provider.get("published"),
        "updated": provider.get("updated"),
    }


def _read_metadata_bundle(
    kind: ArticleManifest,
    path: str,
    *,
    slug: str,
) -> Tuple[Dict[str, Any], bytes, _FileWitness]:
    bundle, raw, witness = _read_object_with_bytes(
        path,
        label="API metadata bundle",
        max_bytes=MAX_DEPOSIT_METADATA_BUNDLE_BYTES,
    )
    try:
        kind.schemas.get_validator("deposit.metadata.schema.json").validate(bundle)
    except Exception as exc:
        raise DepositError(f"API metadata bundle does not satisfy its schema: '{path}': {exc}") from exc

    try:
        DepositMetadataBundle.model_validate(bundle)
    except ValidationError as exc:
        raise DepositError(
            f"API metadata bundle does not satisfy the shared procurement contract: "
            f"'{path}': {exc}"
        ) from exc

    if bundle["deposit_slug"] != slug:
        raise DepositError(
            f"API metadata bundle slug {bundle['deposit_slug']!r} does not match deposit slug {slug!r}"
        )
    return bundle, raw, witness


def _assemble_article(
    *,
    kind: ArticleManifest,
    slug: str,
    archive: str,
    archive_full: str,
    archive_sha256: str,
    archive_kind: str,
    tree: str,
    tree_sha256: str,
    files: int,
    tex_files: int,
    entrypoint: str,
    entrypoint_selection: str,
    publication: str,
    findings: Dict[str, Any],
    provider_json: Optional[str],
    provider_full: Optional[str],
    metadata_json: Optional[str],
    metadata_full: Optional[str],
    pdf: Optional[str],
    pdf_full: Optional[str],
) -> Tuple[Dict[str, Any], Tuple[_FileWitness, ...]]:
    witnesses: List[_FileWitness] = []
    provider = None
    provider_raw = None
    metadata = None
    metadata_raw = None
    if provider_full is not None:
        provider, provider_raw, provider_witness = _read_object_with_bytes(
            provider_full,
            label="provider metadata",
            max_bytes=MAX_DEPOSIT_METADATA_BUNDLE_BYTES,
        )
        witnesses.append(provider_witness)
    if provider is not None and provider.get("idv") and provider.get("idv") != slug:
        raise DepositError(
            f"provider metadata idv {provider.get('idv')!r} does not match deposit slug {slug!r}"
        )
    if metadata_full is not None:
        metadata, metadata_raw, metadata_witness = _read_metadata_bundle(
            kind,
            metadata_full,
            slug=slug,
        )
        witnesses.append(metadata_witness)

    archive_record = _file_record(
        path=archive,
        full_path=archive_full,
        role="latex-source-archive",
        media_type="application/gzip",
        witnesses=witnesses,
        extra={"archive_kind": archive_kind},
    )
    if archive_record["sha256"] != archive_sha256:
        raise DepositConflict(
            "published source archive does not match its expansion-time sha256"
        )
    tree_record = {
        "role": "latex-source-tree",
        "path": tree,
        "format": "application/x-latex-source-tree",
        "derived_from": archive,
        "entrypoint": entrypoint,
        "entrypoint_selection": entrypoint_selection,
        "files": files,
        "tex_files": tex_files,
        "sha256": tree_sha256,
    }
    source_forms = [archive_record, tree_record]
    if pdf is not None and pdf_full is not None:
        source_forms.append(
            _file_record(
                path=pdf,
                full_path=pdf_full,
                role="pdf-source",
                media_type="application/pdf",
                witnesses=witnesses,
            )
        )

    provider_evidence = []
    if (
        provider is not None
        and provider_raw is not None
        and provider_json is not None
        and provider_full is not None
    ):
        provider_evidence.append(
            {
                "role": "provider-metadata",
                "path": provider_json,
                "format": "application/json",
                "bytes": len(provider_raw),
                "sha256": hashlib.sha256(provider_raw).hexdigest(),
                "provider": "arxiv",
                "fetched_at": provider.get("fetched_at"),
                "fetched_by": provider.get("fetched_by"),
            }
        )

    metadata_resolution = None
    if metadata is not None and metadata_raw is not None and metadata_json is not None:
        selected = metadata["selected"]
        response = selected["response"]
        artifact = metadata["artifact"]
        provider_evidence.append(
            {
                "role": "api-metadata-bundle",
                "path": metadata_json,
                "format": "application/vnd.codex-scientiae.deposit-metadata+json",
                "bytes": len(metadata_raw),
                "sha256": hashlib.sha256(metadata_raw).hexdigest(),
                "provider": selected["provider"],
                "provider_roles": copy.deepcopy(selected["provider_roles"]),
                "artifact_provider": artifact["provider"],
                "artifact_provider_roles": copy.deepcopy(artifact["provider_roles"]),
                "route": metadata["route"],
                "fetched_at": response["fetched_at"],
                "response_url": response["url"],
                "response_format": response["media_type"],
                "response_sha256": response["sha256"],
            }
        )
        metadata_resolution = {
            "route": metadata["route"],
            "artifact": copy.deepcopy(artifact),
            "selected_provider": selected["provider"],
            "selected_provider_roles": copy.deepcopy(selected["provider_roles"]),
            "attempts": copy.deepcopy(metadata["attempts"]),
        }
        if metadata.get("identity_anchor") is not None:
            metadata_resolution["identity_anchor"] = copy.deepcopy(
                metadata["identity_anchor"]
            )

    timestamp = _utc_timestamp()
    bibliographic = (
        copy.deepcopy(metadata["article"])
        if metadata is not None
        else _provider_values(provider)
    )
    evidence: Dict[str, Any] = {
        "provider_metadata": provider_evidence,
        "latex_source": {
            "entrypoint": entrypoint,
            "selection": entrypoint_selection,
            "declarations": copy.deepcopy(findings["declarations"]),
        },
        "package_control_files": copy.deepcopy(findings["package_control_files"]),
    }
    if metadata_resolution is not None:
        evidence["metadata_resolution"] = metadata_resolution

    values: Dict[str, Any] = {
        "slug": slug,
        "initialized_utc": timestamp,
        **bibliographic,
        "evidence": evidence,
        "source_forms": source_forms,
        "validation": {
            "status": "valid",
            "validated_utc": timestamp,
            "publication": publication,
            "checks": copy.deepcopy(findings["checks"]),
        },
    }
    return kind.validate_record(kind.mint(values)), tuple(witnesses)


def _first_difference(left: Any, right: Any, path: str = "$") -> Optional[str]:
    if type(left) is not type(right):
        return path
    if isinstance(left, dict):
        for key in left:
            if key not in right:
                return f"{path}/{key}"
            difference = _first_difference(left[key], right[key], f"{path}/{key}")
            if difference is not None:
                return difference
        for key in right:
            if key not in left:
                return f"{path}/{key}"
        return None
    if isinstance(left, list):
        if len(left) != len(right):
            return path
        for index, (left_value, right_value) in enumerate(zip(left, right)):
            difference = _first_difference(left_value, right_value, f"{path}/{index}")
            if difference is not None:
                return difference
        return None
    return None if left == right else path


def _read_existing_article(kind: ArticleManifest, path: str) -> Tuple[Dict[str, Any], bytes]:
    """Read one stable, no-follow regular article file through its opened generation."""
    flags = os.O_RDONLY | getattr(os, "O_BINARY", 0) | getattr(os, "O_NOFOLLOW", 0)
    try:
        descriptor = os.open(path, flags)
    except OSError as exc:
        raise DepositConflict(f"existing article.json is not a readable regular file: '{path}'") from exc

    try:
        with os.fdopen(descriptor, "rb") as handle:
            before = os.fstat(handle.fileno())
            if not stat.S_ISREG(before.st_mode):
                raise DepositConflict(f"existing article.json is not a regular file: '{path}'")
            raw = handle.read()
            after = os.fstat(handle.fileno())
        before_identity = _FileWitness.capture(path, before)
        after_identity = _FileWitness.capture(path, after)
        if before_identity != after_identity or len(raw) != after.st_size:
            raise DepositConflict(f"existing article.json changed while being read: '{path}'")

        current = os.stat(path, follow_symlinks=False)
        if not stat.S_ISREG(current.st_mode) or not _same_file_generation(after, current):
            raise DepositConflict(f"existing article.json path changed while being read: '{path}'")
        existing = kind.validate_record(loads(raw, path=path))
    except Exception as exc:
        if isinstance(exc, DepositConflict):
            raise
        raise DepositConflict(f"existing article.json is invalid: '{path}': {exc}") from exc
    return existing, raw


def _existing_article(kind: ArticleManifest, path: str, candidate: Dict[str, Any]) -> Dict[str, Any]:
    existing, raw = _read_existing_article(kind, path)

    comparable = copy.deepcopy(candidate)
    comparable["initialized_utc"] = existing["initialized_utc"]
    comparable["validation"]["validated_utc"] = existing["validation"]["validated_utc"]
    comparable["validation"]["publication"] = existing["validation"]["publication"]
    difference = _first_difference(existing, comparable)
    if difference is not None:
        raise DepositConflict(
            f"existing article.json conflicts with the requested deposit at {difference}: '{path}'"
        )
    canonical = serialize_json(
        comparable,
        encoding=kind.ENCODING,
        codec=kind.CODEC,
        indent=2,
        path=path,
    ) + b"\n"
    if raw != canonical:
        raise DepositConflict(
            f"existing article.json does not use the canonical JSON byte policy: '{path}'"
        )
    return existing


def _rollback_created_article(
    kind: ArticleManifest, path: str, candidate: Dict[str, Any]
) -> None:
    """Remove only the exact article this transaction just published.

    The caller still holds the article lease. Re-reading before unlink protects lease-cooperating
    writers and refuses a replacement already visible at the closing check. Uncoordinated writes
    are outside the lease contract.
    """
    current, raw = _read_existing_article(kind, path)
    canonical = serialize_json(
        candidate,
        encoding=kind.ENCODING,
        codec=kind.CODEC,
        indent=2,
        path=path,
    ) + b"\n"
    if _first_difference(current, candidate) is not None or raw != canonical:
        raise DepositConflict(
            "measured source changed after publication, but article.json was also replaced; "
            f"refusing rollback: '{path}'"
        )
    try:
        os.remove(path)
    except OSError as exc:
        raise DepositConflict(
            f"measured source changed after publication and article.json rollback failed: '{path}'"
        ) from exc


def deposit_article(
    *,
    document_dir: str,
    slug: str,
    archive: str,
    archive_sha256: str,
    archive_kind: str,
    tree: str,
    tree_sha256: str,
    files: int,
    tex_files: int,
    entrypoint: str,
    entrypoint_selection: str,
    publication: str,
    findings_json: str,
    provider_json: Optional[str] = None,
    metadata_json: Optional[str] = None,
    pdf: Optional[str] = None,
    lock_timeout: float = 60.0,
) -> DepositResult:
    """Create or validate one source-ready ``article.json`` deposit.

    Artifact paths are normalized forward-slash paths relative to ``document_dir``. The archive
    digest is the expansion-time witness and is remeasured here. The tree digest and counts are
    recomputed before and after publication. Entrypoint facts, declarations, package-control
    fingerprints, and the probe ledger come from the LaTeX transaction; provider projections are
    derived from deposited evidence. The caller must prevent concurrent mutation of the source tree
    and deposited inputs for this call; ``New-LatexSourceDeposit`` holds that source lock.
    """
    root, directory_leaf = _document_root(document_dir)
    slug = _validate_slug(slug, directory_leaf=directory_leaf)
    if archive_kind not in _ARCHIVE_KINDS:
        raise DepositError(
            f"archive_kind must be one of {sorted(_ARCHIVE_KINDS)}, got {archive_kind!r}"
        )
    if publication not in _PUBLICATIONS:
        raise DepositError(
            f"publication must be one of {sorted(_PUBLICATIONS)}, got {publication!r}"
        )
    for label, digest in (
        ("archive_sha256", archive_sha256),
        ("tree_sha256", tree_sha256),
    ):
        if not isinstance(digest, str) or len(digest) != 64 or any(
            char not in "0123456789abcdef" for char in digest
        ):
            raise DepositError(f"{label} must be 64 lowercase hexadecimal characters")
    if isinstance(files, bool) or not isinstance(files, int) or files < 1:
        raise DepositError("files must be an integer greater than zero")
    if isinstance(tex_files, bool) or not isinstance(tex_files, int) or tex_files < 1:
        raise DepositError("tex_files must be an integer greater than zero")
    if tex_files > files:
        raise DepositError("tex_files cannot exceed files")
    if not isinstance(entrypoint_selection, str) or not entrypoint_selection:
        raise DepositError("entrypoint_selection must be a non-empty string")

    archive, archive_full = _resolve_relative(root, archive, label="archive", kind="file")
    tree, tree_full = _resolve_relative(root, tree, label="tree", kind="directory")
    if archive != f"{slug}.tar.gz":
        raise DepositError(
            f"archive must use the canonical deposit path {slug + '.tar.gz'!r}, got {archive!r}"
        )
    if tree != f"{slug}-tex":
        raise DepositError(
            f"tree must use the canonical deposit path {slug + '-tex'!r}, got {tree!r}"
        )
    entrypoint, entrypoint_full = _resolve_relative(
        tree_full, entrypoint, label="entrypoint", kind="file"
    )
    if not _within(tree_full, entrypoint_full):
        raise DepositError(f"entrypoint escapes the source tree: {entrypoint!r}")

    if provider_json is not None and metadata_json is not None:
        raise DepositError("provider_json and metadata_json are mutually exclusive")

    provider_full = None
    if provider_json is not None:
        provider_json, provider_full = _resolve_relative(
            root, provider_json, label="provider_json", kind="file"
        )
    metadata_full = None
    if metadata_json is not None:
        metadata_json, metadata_full = _resolve_relative(
            root, metadata_json, label="metadata_json", kind="file"
        )
    pdf_full = None
    if pdf is not None:
        pdf, pdf_full = _resolve_relative(root, pdf, label="pdf", kind="file")

    kind = ArticleManifest(target_dir=root)
    article_path = kind.get_output_path()
    lease = FileLock(lock_path(article_path), timeout=lock_timeout)
    try:
        lease.acquire()
    except Timeout as exc:
        raise TimeoutError(
            f"could not acquire the article write lease within {lock_timeout}s: '{article_path}'"
        ) from exc
    try:
        findings = _read_findings(findings_json)
        candidate, source_witnesses = _assemble_article(
            kind=kind,
            slug=slug,
            archive=archive,
            archive_full=archive_full,
            archive_sha256=archive_sha256,
            archive_kind=archive_kind,
            tree=tree,
            tree_sha256=tree_sha256,
            files=files,
            tex_files=tex_files,
            entrypoint=entrypoint,
            entrypoint_selection=entrypoint_selection,
            publication=publication,
            findings=findings,
            provider_json=provider_json,
            provider_full=provider_full,
            metadata_json=metadata_json,
            metadata_full=metadata_full,
            pdf=pdf,
            pdf_full=pdf_full,
        )
        _assert_tree_snapshot(
            tree_full,
            expected_sha256=tree_sha256,
            expected_files=files,
            expected_tex_files=tex_files,
        )
        _assert_file_witnesses(source_witnesses)
        created_here = False
        if os.path.lexists(article_path):
            article = _existing_article(kind, article_path, candidate)
            status = "already-deposited"
        else:
            try:
                kind.publish(candidate)
                article = candidate
                status = "deposited"
                created_here = True
            except FileExistsError:
                article = _existing_article(kind, article_path, candidate)
                status = "already-deposited"
        try:
            # The PowerShell orchestrator keeps its source lock through this call. This second
            # check also protects direct service/CLI callers from a source replacement in the
            # narrow interval between the pre-publication witness check and the atomic publish.
            _assert_file_witnesses(source_witnesses)
            _assert_tree_snapshot(
                tree_full,
                expected_sha256=tree_sha256,
                expected_files=files,
                expected_tex_files=tex_files,
            )
        except BaseException:
            if created_here:
                _rollback_created_article(kind, article_path, candidate)
            raise
    finally:
        lease.release()

    return DepositResult(
        status=status,
        article_path=article_path,
        archive_path=archive_full,
        source_path=tree_full,
        article=article,
    )
