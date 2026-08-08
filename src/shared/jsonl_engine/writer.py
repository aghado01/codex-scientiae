"""Write single-object JSON artifacts: manifests, provider metadata, .sig sidecars.

serialize_json turns a value into bytes under a declared encoding and Codec. write_json puts those
bytes on disk, by default through a temporary file and os.replace so a reader never observes a
partial document.

atomic=False writes the named path directly. JsonlEngine.commit() uses it: the .sig is written to a
.tmp of its own and renamed alongside the .jidx at the end of the store transaction, so the sidecars
appear together or not at all.

The JSONL record path is not here. It lives in JsonlEngine.append(), which must interleave
serialization with offset capture and hashing.
"""

from __future__ import annotations

import json
import os
from typing import Any, Optional

from .policy import DEFAULT_ENCODING, Codec


class JsonWriterError(ValueError):
    """A value could not be serialized or written. Carries `path` when one is known."""

    def __init__(self, message: str, path: Optional[str] = None) -> None:
        self.path = path
        super().__init__(f"{message}: '{path}'" if path else message)


def serialize_json(
    value: Any,
    *,
    encoding: str = DEFAULT_ENCODING,
    codec: Codec = Codec.UNICODE,
    indent: Optional[int] = None,
    sort_keys: bool = False,
    path: Optional[str] = None,
) -> bytes:
    """Serialize `value` to bytes. Compact separators unless `indent` is set.

    Key order is insertion order unless `sort_keys` is set. Text with no form in `encoding` raises
    rather than being substituted; see Codec.
    """
    separators = None if indent is not None else (",", ":")
    text = json.dumps(
        value,
        ensure_ascii=codec.ensure_ascii,
        separators=separators,
        indent=indent,
        sort_keys=sort_keys,
    )

    try:
        return text.encode(encoding)
    except UnicodeEncodeError as exc:
        raise JsonWriterError(
            f"value contains a code unit with no form in '{encoding}' (typically an unpaired "
            f"surrogate from text extraction). This artifact's codec is '{codec.value}', which "
            f"refuses rather than replaces. Declare Codec.ASCII to carry it losslessly as a "
            f"\\uXXXX escape, or repair the value upstream. Underlying error: {exc}",
            path,
        ) from exc


def write_json(
    path: str,
    value: Any,
    *,
    encoding: str = DEFAULT_ENCODING,
    codec: Codec = Codec.UNICODE,
    indent: Optional[int] = 2,
    sort_keys: bool = False,
    trailing_newline: bool = True,
    atomic: bool = True,
) -> str:
    """Write one JSON document to `path`. Returns the absolute path written.

    Defaults to indent=2 because the artifacts that use this writer are read by people. Pass
    indent=None for compact output.
    """
    full = os.path.abspath(path)
    raw = serialize_json(
        value, encoding=encoding, codec=codec, indent=indent, sort_keys=sort_keys, path=full
    )
    if trailing_newline:
        raw += "\n".encode(encoding)

    parent = os.path.dirname(full)
    if parent:
        os.makedirs(parent, exist_ok=True)

    if not atomic:
        with open(full, "wb") as handle:
            handle.write(raw)
        return full

    tmp = full + ".tmp"
    try:
        with open(tmp, "wb") as handle:
            handle.write(raw)
        os.replace(tmp, full)
    except BaseException:
        if os.path.exists(tmp):
            try:
                os.remove(tmp)
            except OSError:
                pass
        raise
    return full
