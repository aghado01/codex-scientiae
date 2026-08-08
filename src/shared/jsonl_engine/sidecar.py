"""Store path triple, .NET ticks, and the .sig schema id.

Leaf module: no imports from engine, reader, or schema_registry. Shared by writers and readers.
"""

from __future__ import annotations

import json
import os
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

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


def store_paths(path: str) -> StorePaths:
    """Derive the sidecar paths for `path`, or recover the subject from a sidecar path.

    Sidecars replace the extension: `records.jsonl` is accompanied by `records.jidx` and
    `records.sig`. This is the canonical form, matching Get-JsonlIndexPath in
    jso-ops/jsonl-v2.ps1; the appended `records.jsonl.jidx` shape is the retired form that lane
    reads for discovery and never writes.

    A single-object `.json` resolves the same way, so a manifest can carry a `.sig` without a
    second convention. The cost of replacement is that a `.json` and a `.jsonl` sharing a stem in
    one directory would contend for one sidecar, and that a sidecar path alone cannot say which of
    the two it belongs to -- recovery assumes `.jsonl`.
    """
    full = os.path.abspath(path)
    root, ext = os.path.splitext(full)
    artifact = root + ".jsonl" if ext.lower() in _SIDECAR_EXTS else full
    stem = os.path.splitext(artifact)[0]
    return StorePaths(artifact=artifact, jidx=stem + ".jidx", sig=stem + ".sig")
