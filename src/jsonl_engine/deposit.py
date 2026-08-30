"""Article deposit assembly and immutable publication.

The service fingerprints deposited forms, projects optional metadata, validates the article schema,
and creates ``article.json``. Compatible existing articles are returned unchanged. ``overwrite=True``
is an explicit rebuild: it replaces the sentinel from current evidence and preserves
``initialized_utc``. The caller owns source-tree coordination for the complete call.
"""

from __future__ import annotations

import copy
import hashlib
import ntpath
import os
import posixpath
import stat
from contextlib import contextmanager
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, Dict, Iterable, Iterator, List, Mapping, Optional, Tuple

from filelock import FileLock, Timeout

from .kinds.article import (
    MAX_ARTICLE_MANIFEST_BYTES,
    ArticleManifest,
    ArticleMetadataContribution,
    ArticleMetadataExtension,
    source_archive_names,
)
from .publication import PinnedPublicationRoot, PublicationError
from .reader import loads
from .writer import serialize_json

__all__ = [
    "DepositConflict",
    "DepositError",
    "DepositResult",
    "deposit_article",
    "source_archive_names",
]


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
    relative_path: str | None = None

    @classmethod
    def capture(
        cls,
        path: str,
        info: os.stat_result,
        *,
        relative_path: str | None = None,
    ) -> "_FileWitness":
        return cls(
            path=path,
            device=info.st_dev,
            inode=info.st_ino,
            size=info.st_size,
            mtime_ns=getattr(info, "st_mtime_ns", int(info.st_mtime * 1_000_000_000)),
            ctime_ns=getattr(info, "st_ctime_ns", int(info.st_ctime * 1_000_000_000)),
            relative_path=relative_path,
        )

    def matches(self, info: os.stat_result) -> bool:
        current = type(self).capture(self.path, info, relative_path=self.relative_path)
        return current == self


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


@contextmanager
def _document_publication(
    document_dir: str,
    publication_root: PinnedPublicationRoot | None,
) -> Iterator[tuple[PinnedPublicationRoot, str]]:
    """Yield the exact document generation used for every deposit operation."""

    if publication_root is None:
        root_path, directory_leaf = _document_root(document_dir)
        owned_root = PinnedPublicationRoot(root_path)
        try:
            owned_root.__enter__()
        except (OSError, RuntimeError, ValueError) as exc:
            raise DepositError(
                f"document deposit could not retain its directory generation: '{root_path}'"
            ) from exc
        try:
            yield owned_root, directory_leaf
        finally:
            owned_root.__exit__(None, None, None)
        return

    if not isinstance(publication_root, PinnedPublicationRoot):
        raise TypeError("publication_root must be an active PinnedPublicationRoot or None")
    requested = os.path.abspath(os.fspath(document_dir))
    if os.path.normpath(requested) != os.path.normpath(publication_root.path):
        raise DepositError(
            "document_dir must exactly name the supplied publication root: "
            f"{requested!r} != {publication_root.path!r}"
        )
    if not publication_root.is_active:
        raise DepositError("publication_root must remain active for the complete deposit")
    try:
        publication_root.assert_current()
        info = publication_root.stat_root()
    except (OSError, RuntimeError) as exc:
        raise DepositError(
            f"document deposit root is no longer current: '{publication_root.path}'"
        ) from exc
    if not stat.S_ISDIR(info.st_mode):
        raise DepositError(
            f"document deposit root is not a physical directory: '{publication_root.path}'"
        )
    yield publication_root, os.path.basename(os.path.normpath(publication_root.path))


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
    root: PinnedPublicationRoot,
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

    relative = "/".join(components)
    lexical = root.absolute_relative(relative)
    try:
        info = root.stat_relative(relative)
    except OSError as exc:
        raise DepositError(f"{label} is not accessible: '{lexical}'") from exc
    attributes = getattr(info, "st_file_attributes", 0)
    if stat.S_ISLNK(info.st_mode) or attributes & 0x400:
        raise DepositError(
            f"{label} must not traverse a symbolic link or reparse point: {value!r}"
        )
    if kind == "file" and not stat.S_ISREG(info.st_mode):
        raise DepositError(f"{label} file not found: '{lexical}'")
    if kind == "directory" and not stat.S_ISDIR(info.st_mode):
        raise DepositError(f"{label} directory not found: '{lexical}'")
    return relative, lexical


def _stable_read(
    root: PinnedPublicationRoot,
    relative_path: str,
    *,
    max_bytes: int | None = None,
) -> Tuple[bytes, _FileWitness]:
    path = root.absolute_relative(relative_path)
    named_before = root.stat_relative(relative_path)
    with root.open_stable_relative_file(relative_path) as handle:
        before = os.fstat(handle.fileno())
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
    named_after = root.stat_relative(relative_path)
    witness_before = _FileWitness.capture(
        path,
        named_before,
        relative_path=relative_path,
    )
    witness_after = _FileWitness.capture(
        path,
        named_after,
        relative_path=relative_path,
    )
    if not stat.S_ISREG(named_after.st_mode) or witness_before != witness_after:
        raise DepositError(f"file path changed while it was being read: '{path}'")
    return raw, witness_after


def _fingerprint(
    root: PinnedPublicationRoot,
    relative_path: str,
) -> Tuple[int, str, _FileWitness]:
    path = root.absolute_relative(relative_path)
    named_before = root.stat_relative(relative_path)
    digest = hashlib.sha256()
    size = 0
    with root.open_stable_relative_file(relative_path) as handle:
        before = os.fstat(handle.fileno())
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
    named_after = root.stat_relative(relative_path)
    witness_before = _FileWitness.capture(
        path,
        named_before,
        relative_path=relative_path,
    )
    witness_after = _FileWitness.capture(
        path,
        named_after,
        relative_path=relative_path,
    )
    if not stat.S_ISREG(named_after.st_mode) or witness_before != witness_after:
        raise DepositError(f"file path changed while it was being fingerprinted: '{path}'")
    return (
        size,
        digest.hexdigest(),
        witness_after,
    )


def _same_directory_generation(left: os.stat_result, right: os.stat_result) -> bool:
    if left.st_ino or right.st_ino:
        return left.st_dev == right.st_dev and left.st_ino == right.st_ino
    return left.st_dev == right.st_dev and getattr(
        left, "st_ctime_ns", None
    ) == getattr(right, "st_ctime_ns", None)


def _fingerprint_pinned_tree(root: PinnedPublicationRoot) -> Tuple[str, int, int]:
    """Fingerprint one retained physical tree without following links or reparses."""

    records: List[Tuple[str, int, str]] = []
    portable_paths: set[str] = set()

    def scan(directory: PinnedPublicationRoot, prefix: str) -> None:
        directory.assert_current()
        directory_before = directory.stat_root()
        try:
            entries = directory.list_names()
        except OSError as exc:
            raise DepositError(
                f"source tree cannot be enumerated: '{directory.path}'"
            ) from exc
        for name in entries:
            relative = f"{prefix}/{name}" if prefix else name
            if any(not _is_portable_leaf(part) for part in relative.split("/")):
                raise DepositError(f"source tree contains a non-portable path: {relative!r}")
            portable_key = relative.casefold()
            if portable_key in portable_paths:
                raise DepositError(
                    f"source tree contains duplicate or case-colliding paths: {relative!r}"
                )
            portable_paths.add(portable_key)
            try:
                info = directory.stat_leaf(name)
            except OSError as exc:
                raise DepositError(
                    f"source tree entry cannot be measured: '{directory.absolute(name)}'"
                ) from exc
            attributes = getattr(info, "st_file_attributes", 0)
            if stat.S_ISLNK(info.st_mode) or attributes & 0x400:
                raise DepositError(
                    "source tree contains a symbolic link or reparse point: "
                    f"'{directory.absolute(name)}'"
                )
            if stat.S_ISDIR(info.st_mode):
                with directory.pin_child(name) as child:
                    if not _same_directory_generation(info, child.stat_root()):
                        raise DepositError(
                            "source tree directory changed while it was pinned: "
                            f"'{child.path}'"
                        )
                    scan(child, relative)
                continue
            if not stat.S_ISREG(info.st_mode):
                raise DepositError(
                    f"source tree entry is not a regular file: '{directory.absolute(name)}'"
                )
            size, digest, _ = _fingerprint(directory, name)
            records.append((relative, size, digest))
        directory_after = directory.stat_root()
        directory.assert_current()
        directory_fields = (
            "st_dev",
            "st_ino",
            "st_size",
            "st_mtime_ns",
            "st_ctime_ns",
        )
        if any(
            getattr(directory_before, field, None) != getattr(directory_after, field, None)
            for field in directory_fields
        ):
            raise DepositError(
                f"source tree directory changed while it was scanned: '{directory.path}'"
            )

    root.assert_current()
    scan(root, "")
    root.assert_current()
    if not records:
        raise DepositError(f"source tree is empty: '{root.path}'")

    records.sort(key=lambda item: item[0].encode("utf-16-be", "surrogatepass"))
    witnessed: List[bytes] = []
    tex_files = 0
    for relative, size, digest in records:
        witnessed.append(f"{relative}\0{size}\0{digest}\n".encode("utf-8"))
        if relative.casefold().endswith(".tex"):
            tex_files += 1
    tree_hash = hashlib.sha256(b"".join(witnessed)).hexdigest()
    return tree_hash, len(records), tex_files


def _fingerprint_tree(
    root: str,
    *,
    publication_root: PinnedPublicationRoot | None = None,
) -> Tuple[str, int, int]:
    """Fingerprint one physical source tree through a retained directory generation."""

    requested = os.path.abspath(os.fspath(root))
    if publication_root is not None:
        if os.path.normpath(requested) != os.path.normpath(publication_root.path):
            raise DepositError("source tree path does not match its publication root")
        return _fingerprint_pinned_tree(publication_root)
    try:
        with PinnedPublicationRoot(requested) as owned_root:
            return _fingerprint_pinned_tree(owned_root)
    except (OSError, PublicationError, RuntimeError, ValueError) as exc:
        if isinstance(exc, DepositError):
            raise
        raise DepositError(f"source tree could not be fingerprinted: '{requested}'") from exc


def _assert_tree_snapshot(
    root: str,
    *,
    expected_sha256: str,
    expected_files: int,
    expected_tex_files: int,
    publication_root: PinnedPublicationRoot | None = None,
) -> None:
    actual_sha256, actual_files, actual_tex_files = _fingerprint_tree(
        root,
        publication_root=publication_root,
    )
    if actual_sha256 != expected_sha256:
        raise DepositConflict("published source tree does not match its supplied sha256")
    if actual_files != expected_files or actual_tex_files != expected_tex_files:
        raise DepositConflict(
            "published source tree counts do not match supplied files/tex_files"
        )


def _assert_file_witnesses(
    witnesses: Iterable[_FileWitness],
    publication_root: PinnedPublicationRoot,
) -> None:
    """Refuse publication when a measured path no longer names the measured file generation."""
    for witness in witnesses:
        if witness.relative_path is None:
            raise DepositError(f"measured source has no pinned relative path: '{witness.path}'")
        try:
            current = publication_root.stat_relative(witness.relative_path)
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
    publication_root: PinnedPublicationRoot,
    role: str,
    media_type: str,
    witnesses: List[_FileWitness],
    extra: Optional[Dict[str, Any]] = None,
) -> Dict[str, Any]:
    size, digest, witness = _fingerprint(publication_root, path)
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
    root: PinnedPublicationRoot,
    relative_path: str,
    path: str,
    *,
    label: str,
    max_bytes: int | None = None,
) -> Tuple[Dict[str, Any], bytes, _FileWitness]:
    try:
        raw, witness = _stable_read(root, relative_path, max_bytes=max_bytes)
        value = loads(raw, path=path)
    except DepositError:
        raise
    except PublicationError as exc:
        raise DepositError(
            f"{label} changed while it was read through the retained generation: '{path}'"
        ) from exc
    except Exception as exc:
        raise DepositError(f"{label} is not a strict UTF-8 JSON object: '{path}': {exc}") from exc
    return value, raw, witness


def _validate_findings(value: Mapping[str, Any]) -> Dict[str, Any]:
    if not isinstance(value, Mapping):
        raise DepositError("findings must be one mapping")
    findings = dict(value)
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
        raise DepositError("findings fields are invalid: " + "; ".join(detail))
    return copy.deepcopy(findings)


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
    extension: ArticleMetadataExtension,
    root: PinnedPublicationRoot,
    path: str,
    *,
    relative_path: str,
    slug: str,
) -> Tuple[ArticleMetadataContribution, _FileWitness]:
    maximum_bytes = extension.maximum_bytes
    if (
        isinstance(maximum_bytes, bool)
        or not isinstance(maximum_bytes, int)
        or maximum_bytes < 1
    ):
        raise DepositError("article metadata extension maximum_bytes must be a positive integer")
    bundle, raw, witness = _read_object_with_bytes(
        root,
        relative_path,
        path,
        label="API metadata bundle",
        max_bytes=maximum_bytes,
    )
    try:
        contribution = extension.project(
            bundle,
            raw=raw,
            path=relative_path,
            slug=slug,
        )
    except Exception as exc:
        raise DepositError(
            f"API metadata bundle does not satisfy its application contract: '{path}': {exc}"
        ) from exc
    if not isinstance(contribution, ArticleMetadataContribution):
        raise DepositError("article metadata extension returned an invalid contribution")
    return contribution, witness


def _assemble_article(
    *,
    kind: ArticleManifest,
    publication_root: PinnedPublicationRoot,
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
    metadata_extension: Optional[ArticleMetadataExtension],
    pdf: Optional[str],
    pdf_full: Optional[str],
) -> Tuple[Dict[str, Any], Tuple[_FileWitness, ...]]:
    witnesses: List[_FileWitness] = []
    provider = None
    provider_raw = None
    metadata = None
    if provider_full is not None:
        provider, provider_raw, provider_witness = _read_object_with_bytes(
            publication_root,
            provider_json or "",
            provider_full,
            label="provider metadata",
            max_bytes=32 * 1024 * 1024,
        )
        witnesses.append(provider_witness)
    if provider is not None and provider.get("idv") and provider.get("idv") != slug:
        raise DepositError(
            f"provider metadata idv {provider.get('idv')!r} does not match deposit slug {slug!r}"
        )
    if metadata_full is not None:
        if metadata_extension is None:  # closed by deposit_article before filesystem work
            raise DepositError("metadata_json requires an article metadata extension")
        metadata, metadata_witness = _read_metadata_bundle(
            metadata_extension,
            publication_root,
            metadata_full,
            relative_path=metadata_json or "",
            slug=slug,
        )
        witnesses.append(metadata_witness)

    archive_record = _file_record(
        path=archive,
        full_path=archive_full,
        publication_root=publication_root,
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
                publication_root=publication_root,
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
    if metadata is not None:
        provider_evidence.append(copy.deepcopy(metadata.evidence))
        metadata_resolution = copy.deepcopy(metadata.resolution)

    timestamp = _utc_timestamp()
    bibliographic = (
        copy.deepcopy(metadata.article)
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


def _read_existing_article(
    kind: ArticleManifest,
    path: str,
    publication_root: PinnedPublicationRoot,
) -> Tuple[Dict[str, Any], bytes]:
    """Read one article through its retained document generation."""

    try:
        raw = publication_root.read_bytes(
            path,
            maximum_bytes=MAX_ARTICLE_MANIFEST_BYTES,
        )
        existing = kind.validate_record(loads(raw, path=path))
    except Exception as exc:
        if isinstance(exc, DepositConflict):
            raise
        raise DepositConflict(f"existing article.json is invalid: '{path}': {exc}") from exc
    return existing, raw


def _existing_article(
    kind: ArticleManifest,
    path: str,
    candidate: Dict[str, Any],
    publication_root: PinnedPublicationRoot,
) -> Dict[str, Any]:
    existing, raw = _read_existing_article(kind, path, publication_root)

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
    kind: ArticleManifest,
    path: str,
    candidate: Dict[str, Any],
    publication_root: PinnedPublicationRoot,
) -> None:
    """Remove only the exact article this transaction just published.

    The caller still holds the article lease. Re-reading before unlink protects lease-cooperating
    writers and refuses a replacement already visible at the closing check. Uncoordinated writes
    are outside the lease contract.
    """
    current, raw = _read_existing_article(kind, path, publication_root)
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
        publication_root.unlink(path)
    except OSError as exc:
        raise DepositConflict(
            f"measured source changed after publication and article.json rollback failed: '{path}'"
        ) from exc


def _publish_article_transaction(
    *,
    publication_root: PinnedPublicationRoot,
    tree_root: PinnedPublicationRoot,
    slug: str,
    archive: str,
    archive_full: str,
    archive_sha256: str,
    archive_kind: str,
    tree: str,
    tree_full: str,
    tree_sha256: str,
    files: int,
    tex_files: int,
    entrypoint: str,
    entrypoint_selection: str,
    publication: str,
    findings: Mapping[str, Any],
    provider_json: Optional[str],
    provider_full: Optional[str],
    metadata_json: Optional[str],
    metadata_full: Optional[str],
    metadata_extension: Optional[ArticleMetadataExtension],
    pdf: Optional[str],
    pdf_full: Optional[str],
    lock_timeout: float,
    overwrite: bool = False,
) -> DepositResult:
    kind = ArticleManifest(
        target_dir=publication_root.path,
        publication_root=publication_root,
    )
    article_path = kind.get_output_path()
    lease = FileLock(publication_root.lock_path(article_path), timeout=lock_timeout)
    try:
        lease.acquire()
    except Timeout as exc:
        raise TimeoutError(
            f"could not acquire the article write lease within {lock_timeout}s: '{article_path}'"
        ) from exc
    try:
        validated_findings = _validate_findings(findings)
        candidate, source_witnesses = _assemble_article(
            kind=kind,
            publication_root=publication_root,
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
            findings=validated_findings,
            provider_json=provider_json,
            provider_full=provider_full,
            metadata_json=metadata_json,
            metadata_full=metadata_full,
            metadata_extension=metadata_extension,
            pdf=pdf,
            pdf_full=pdf_full,
        )
        _assert_tree_snapshot(
            tree_full,
            expected_sha256=tree_sha256,
            expected_files=files,
            expected_tex_files=tex_files,
            publication_root=tree_root,
        )
        _assert_file_witnesses(source_witnesses, publication_root)
        publication_root.assert_current()
        tree_root.assert_current()
        created_here = False
        if publication_root.lexists(article_path):
            if overwrite:
                existing, _raw = _read_existing_article(kind, article_path, publication_root)
                candidate["initialized_utc"] = existing["initialized_utc"]
                kind.publish(candidate, overwrite=True)
                article = candidate
                status = "rebuilt"
            else:
                article = _existing_article(
                    kind,
                    article_path,
                    candidate,
                    publication_root,
                )
                status = "already-deposited"
        else:
            try:
                kind.publish(candidate)
                article = candidate
                status = "deposited"
                created_here = True
            except FileExistsError:
                article = _existing_article(
                    kind,
                    article_path,
                    candidate,
                    publication_root,
                )
                status = "already-deposited"
        try:
            _assert_file_witnesses(source_witnesses, publication_root)
            _assert_tree_snapshot(
                tree_full,
                expected_sha256=tree_sha256,
                expected_files=files,
                expected_tex_files=tex_files,
                publication_root=tree_root,
            )
            publication_root.assert_current()
            tree_root.assert_current()
        except BaseException:
            if created_here:
                _rollback_created_article(
                    kind,
                    article_path,
                    candidate,
                    publication_root,
                )
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


def _deposit_article_pinned(
    *,
    publication_root: PinnedPublicationRoot,
    directory_leaf: str,
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
    findings: Mapping[str, Any],
    provider_json: Optional[str] = None,
    metadata_json: Optional[str] = None,
    metadata_extension: Optional[ArticleMetadataExtension] = None,
    pdf: Optional[str] = None,
    lock_timeout: float = 60.0,
    overwrite: bool = False,
) -> DepositResult:
    """Create or validate one article within an already retained document generation."""

    publication_root.assert_current()
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

    archive, archive_full = _resolve_relative(
        publication_root,
        archive,
        label="archive",
        kind="file",
    )
    tree, tree_full = _resolve_relative(
        publication_root,
        tree,
        label="tree",
        kind="directory",
    )
    allowed_archives = source_archive_names(slug)
    if archive not in allowed_archives:
        raise DepositError(
            "archive must use a canonical deposit path "
            f"{allowed_archives[0]!r} or {allowed_archives[1]!r}, got {archive!r}"
        )
    if tree != f"{slug}-tex":
        raise DepositError(
            f"tree must use the canonical deposit path {slug + '-tex'!r}, got {tree!r}"
        )
    if provider_json is not None and metadata_json is not None:
        raise DepositError("provider_json and metadata_json are mutually exclusive")
    if metadata_json is not None and metadata_extension is None:
        raise DepositError("metadata_json requires an article metadata extension")
    if metadata_json is None and metadata_extension is not None:
        raise DepositError("article metadata extension requires metadata_json")

    provider_full = None
    if provider_json is not None:
        provider_json, provider_full = _resolve_relative(
            publication_root,
            provider_json,
            label="provider_json",
            kind="file",
        )
    metadata_full = None
    if metadata_json is not None:
        metadata_json, metadata_full = _resolve_relative(
            publication_root,
            metadata_json,
            label="metadata_json",
            kind="file",
        )
    pdf_full = None
    if pdf is not None:
        pdf, pdf_full = _resolve_relative(
            publication_root,
            pdf,
            label="pdf",
            kind="file",
        )

    with publication_root.pin_descendant(tree) as tree_root:
        entrypoint, _ = _resolve_relative(
            tree_root,
            entrypoint,
            label="entrypoint",
            kind="file",
        )
        return _publish_article_transaction(
            publication_root=publication_root,
            tree_root=tree_root,
            slug=slug,
            archive=archive,
            archive_full=archive_full,
            archive_sha256=archive_sha256,
            archive_kind=archive_kind,
            tree=tree,
            tree_full=tree_full,
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
            metadata_extension=metadata_extension,
            pdf=pdf,
            pdf_full=pdf_full,
            lock_timeout=lock_timeout,
            overwrite=overwrite,
        )


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
    findings: Mapping[str, Any],
    provider_json: Optional[str] = None,
    metadata_json: Optional[str] = None,
    metadata_extension: Optional[ArticleMetadataExtension] = None,
    pdf: Optional[str] = None,
    lock_timeout: float = 60.0,
    publication_root: PinnedPublicationRoot | None = None,
    overwrite: bool = False,
) -> DepositResult:
    """Create or validate one source-ready ``article.json`` deposit.

    The archive, source tree, evidence inputs, and sentinel are read or published through one
    retained document generation. A caller may supply its active document pin; standalone callers
    receive an operation-scoped pin. The source tree is retained independently through both
    fingerprint passes and sentinel publication. ``overwrite=True`` rebuilds an existing sentinel
    from current evidence and preserves ``initialized_utc``.
    """

    try:
        with _document_publication(document_dir, publication_root) as (
            retained_root,
            directory_leaf,
        ):
            return _deposit_article_pinned(
                publication_root=retained_root,
                directory_leaf=directory_leaf,
                slug=slug,
                archive=archive,
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
                metadata_json=metadata_json,
                metadata_extension=metadata_extension,
                pdf=pdf,
                lock_timeout=lock_timeout,
                overwrite=overwrite,
            )
    except (DepositError, TimeoutError):
        raise
    except (PublicationError, RuntimeError) as exc:
        raise DepositError(
            f"article deposit could not preserve its publication generation: '{document_dir}'"
        ) from exc
