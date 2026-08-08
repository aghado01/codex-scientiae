"""Store path triple, .NET ticks, and the .sig schema id.

Leaf module: no imports from engine, reader, or schemas. Shared by writers and readers.
"""

from __future__ import annotations

import glob
import hashlib
import json
import os
import tempfile
import uuid
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import List

_DOTNET_EPOCH = datetime(1, 1, 1, tzinfo=timezone.utc)
_UNIX_EPOCH = datetime(1970, 1, 1, tzinfo=timezone.utc)
TICKS_PER_SECOND = 10_000_000

_PACKAGE_DIR = os.path.dirname(os.path.abspath(__file__))
SIG_SCHEMA_PATH = os.path.join(_PACKAGE_DIR, "schemas", "sig.schema.json")

UTF8_BOM = b"\xef\xbb\xbf"
_SIDECAR_EXTS = {".jidx", ".sig"}


def get_ticks_offset() -> int:
    """Ticks from the .NET epoch (0001-01-01 UTC) to the Unix epoch (1970-01-01 UTC)."""
    delta = _UNIX_EPOCH - _DOTNET_EPOCH
    return (delta.days * 86_400 + delta.seconds) * TICKS_PER_SECOND


DOTNET_TICKS_OFFSET = get_ticks_offset()


def get_file_dotnet_ticks(file_path: str) -> int:
    """Last-write time of `file_path` as .NET UTC ticks from st_mtime_ns."""
    stat = os.stat(file_path)
    return (stat.st_mtime_ns // 100) + get_ticks_offset()


def _load_sig_schema_id(path: str) -> str:
    """Read `$id` from sig.schema.json. Explicit UTF-8; no reader dependency."""
    raw = Path(path).read_bytes()
    if raw.startswith(UTF8_BOM):
        raise ValueError(f"sig schema must be UTF-8 without BOM: '{path}'")
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise ValueError(f"sig schema is not valid UTF-8: '{path}'") from exc
    data = json.loads(text)
    schema_id = data.get("$id")
    if not isinstance(schema_id, str) or not schema_id:
        raise ValueError(f"sig schema missing string $id: '{path}'")
    return schema_id


SIG_SCHEMA_ID = _load_sig_schema_id(SIG_SCHEMA_PATH)


@dataclass(frozen=True)
class StorePaths:
    """Absolute paths for an artifact and its sidecars.

    `artifact` is the subject -- a .jsonl store or a single-object .json. `jidx` is meaningful only
    for the former: there is nothing to index in a document with no records.
    """

    artifact: str
    jidx: str
    sig: str


SCRATCH_DIRNAME = os.path.join("artifacts", "json-scratch")
SCRATCH_ROOT_ENV = "CODEX_JSON_SCRATCH_ROOT"


def scratch_root() -> str:
    """Directory for engine coordination files that are not artifacts.

    `<repo>/artifacts/json-scratch`, flat and not run-stamped: a lock is not a product of a run, it
    is per-artifact and outlives any one of them, so filing it under a run stamp would scatter one
    logical thing across every run that ever touched the store.

    Deliberately inside the repository rather than the system temp directory. A process writing to
    the repo has no business reaching for another volume to coordinate with itself, and on this
    machine that means engaging C: for work happening entirely on D:. artifacts/ is already
    gitignored regenerable output, which is exactly what these are.

    ``CODEX_JSON_SCRATCH_ROOT`` selects a process-scoped coordination root. Batch workers use a
    job-local value so independent jobs do not write to one shared directory. Every process that
    can write the same artifact must receive the same value, because the directory defines the
    lock-coordination domain.

    Without that override, the production default remains the repository scratch directory below.
    It falls back to the system temp directory only when there is no repository to anchor to -- the
    engine has to keep working when installed as a wheel somewhere else.
    """
    configured = os.environ.get(SCRATCH_ROOT_ENV)
    if configured is not None:
        if not configured.strip() or not os.path.isabs(configured):
            raise ValueError(
                f"{SCRATCH_ROOT_ENV} must name a non-empty absolute directory, got "
                f"{configured!r}"
            )
        root = os.path.abspath(configured)
    else:
        try:
            from .paths import find_repository_root

            root = os.path.join(find_repository_root(), SCRATCH_DIRNAME)
        except (RuntimeError, ImportError):
            root = os.path.join(tempfile.gettempdir(), "codex-json-scratch")
    os.makedirs(root, exist_ok=True)
    return root


def lock_path(artifact_path: str) -> str:
    """Where the write lock for `artifact_path` lives.

    Under scratch_root, not beside the artifact. A lock is machine-local process coordination, not
    state belonging to the store: it says nothing about the bytes and is meaningless to a reader,
    so leaving one in every output directory would be noise a reader has to learn to ignore.

    Keyed by a digest of the canonical path so two artifacts never share a lock and one artifact
    always resolves to the same one, including through Windows case aliases and resolved links.
    """
    canonical = os.path.normcase(os.path.realpath(os.path.abspath(artifact_path)))
    digest = hashlib.sha256(os.fsencode(canonical)).hexdigest()[:32]
    return os.path.join(scratch_root(), f"{digest}.lock")


def temp_write_path(artifact_path: str) -> str:
    """A write-transaction scratch path unique to this call.

    Unique, not derived from the artifact name alone: a deterministic '{artifact}.tmp' is shared by
    every concurrent writer of that artifact, so two transactions interleave their records into one
    scratch file. On Windows that surfaces as a sharing violation; on POSIX os.replace succeeds and
    publishes a blend of both writers with a signature covering only one.
    """
    return f"{artifact_path}.{os.getpid()}.{uuid.uuid4().hex[:12]}.tmp"


def scratch_glob(artifact_path: str) -> str:
    """Glob candidates for one transaction subject; exact grammar is checked afterward.

    Scratch must sit beside its target: os.replace is atomic only within one filesystem, and a
    shared scratch directory would silently degrade the atomic publish into a cross-volume copy --
    or fail outright, which is what it does on Windows. Adjacency is a correctness requirement, not
    a placement preference, so the answer to strays is sweeping them rather than relocating them.
    """
    return f"{glob.escape(artifact_path)}.*.*.tmp"


def _is_transaction_scratch(subject: str, candidate: str) -> bool:
    """Whether `candidate` is exactly ``subject.PID.12-lower-hex.tmp``."""
    prefix = subject + "."
    if not os.path.normcase(candidate).startswith(os.path.normcase(prefix)):
        return False

    parts = candidate[len(prefix) :].split(".")
    if len(parts) != 3:
        return False
    pid, token, extension = parts
    return (
        bool(pid)
        and all("0" <= char <= "9" for char in pid)
        and len(token) == 12
        and all(char in "0123456789abcdef" for char in token)
        and extension == "tmp"
    )


def find_stale_scratch(artifact_path: str) -> List[str]:
    """Scratch files left beside `artifact_path` by a writer that is no longer running.

    Only sound to call while holding the artifact's write lease. The lease is what makes this
    exact: if this process holds it, no other live writer is mid-transaction on this artifact, so
    any scratch present belongs to one that died. Without the lease the same files are
    indistinguishable from a peer's work in progress, and deleting them would corrupt it.
    """
    paths = store_paths(artifact_path)
    found = set()
    for subject in (paths.artifact, paths.jidx, paths.sig):
        found.update(
            candidate
            for candidate in glob.glob(scratch_glob(subject))
            if _is_transaction_scratch(subject, candidate)
        )
    return sorted(found)


def store_paths(path: str) -> StorePaths:
    """Derive the sidecar paths for `path`, or recover the subject from a sidecar path.

    Sidecars append rather than replace the extension: `records.jsonl` is accompanied by
    `records.jsonl.jidx` and `records.jsonl.sig`. One rule for every artifact type.

    Replacement cannot serve a signed `.json`: `foo.json` and `foo.jsonl` in one directory would
    contend for a single `foo.sig`, and recovering the subject from a bare `foo.sig` would have to
    guess which of the two it belonged to. Appending makes both exact -- the sidecar names its own
    subject, and stripping one suffix returns it.
    """
    full = os.path.abspath(path)
    root, ext = os.path.splitext(full)
    artifact = root if ext.lower() in _SIDECAR_EXTS else full
    return StorePaths(artifact=artifact, jidx=artifact + ".jidx", sig=artifact + ".sig")
