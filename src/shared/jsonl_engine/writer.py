"""Write single-object JSON artifacts: manifests, provider metadata, .sig sidecars.

serialize_json turns a value into bytes under a declared encoding and Codec. write_json puts those
bytes on disk through an adjacent temporary file so a reader never observes a partial document.
Ordinary writes publish with os.replace; create-if-absent writes publish without replacement.

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
from .sidecar import temp_write_path


class JsonWriterError(ValueError):
    """A value could not be serialized or written. Carries `path` when one is known."""

    def __init__(self, message: str, path: Optional[str] = None) -> None:
        self.path = path
        super().__init__(f"{message}: '{path}'" if path else message)


def _serialize_json_text(
    value: Any,
    *,
    codec: Codec,
    indent: Optional[int],
    sort_keys: bool,
    path: Optional[str],
) -> str:
    """Serialize to strict JSON text before any byte encoding is applied."""
    separators = None if indent is not None else (",", ":")
    try:
        return json.dumps(
            value,
            ensure_ascii=codec.ensure_ascii,
            separators=separators,
            indent=indent,
            sort_keys=sort_keys,
            allow_nan=False,
        )
    except (TypeError, ValueError) as exc:
        raise JsonWriterError(
            f"value cannot be serialized as strict JSON ({type(exc).__name__}: {exc})",
            path,
        ) from exc


def _encode_json_text(text: str, *, encoding: str, codec: Codec, path: Optional[str]) -> bytes:
    """Encode serialized JSON without replacement, retaining policy context on failure."""
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
    except LookupError as exc:
        raise JsonWriterError(f"unknown encoding '{encoding}'", path) from exc


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
    text = _serialize_json_text(
        value,
        codec=codec,
        indent=indent,
        sort_keys=sort_keys,
        path=path,
    )
    return _encode_json_text(text, encoding=encoding, codec=codec, path=path)


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
    overwrite: bool = True,
) -> str:
    """Write one JSON document to `path`. Returns the absolute path written.

    Defaults to indent=2 because the artifacts that use this writer are read by people. Pass
    indent=None for compact output. ``overwrite=False`` publishes the complete adjacent scratch
    through an atomic no-replace operation and raises ``FileExistsError`` if another artifact is
    already at the destination. It is available only with atomic publication: a direct
    create-if-absent write would expose partial bytes to readers.
    """
    if not atomic and not overwrite:
        raise ValueError("overwrite=False requires atomic=True")

    full = os.path.abspath(path)
    text = _serialize_json_text(
        value,
        codec=codec,
        indent=indent,
        sort_keys=sort_keys,
        path=full,
    )
    if trailing_newline:
        text += "\n"
    # Encode the complete document once. BOM-emitting encodings such as UTF-16 therefore emit one
    # BOM at the document boundary rather than a second BOM before the trailing newline.
    raw = _encode_json_text(text, encoding=encoding, codec=codec, path=full)

    parent = os.path.dirname(full)
    if parent:
        os.makedirs(parent, exist_ok=True)

    if not atomic:
        with open(full, "wb") as handle:
            handle.write(raw)
        return full

    # Adjacent keeps publication atomic; unique keeps concurrent writers from sharing scratch.
    tmp = temp_write_path(full)
    try:
        with open(tmp, "xb") as handle:
            written = handle.write(raw)
            if written != len(raw):
                raise OSError(
                    f"short write while staging JSON document ({written} of {len(raw)} bytes): "
                    f"'{full}'"
                )
            handle.flush()
            os.fsync(handle.fileno())
        if overwrite:
            os.replace(tmp, full)
        elif os.name == "nt":
            # Windows rename is atomic and refuses an existing destination. POSIX rename replaces,
            # so that platform uses the link-based no-clobber publication below.
            os.rename(tmp, full)
        else:
            # Linking a complete adjacent file creates the destination atomically without the
            # overwrite semantics of os.replace/os.rename on POSIX. A crash after the link leaves a
            # complete destination plus discoverable scratch, never a partial document.
            os.link(tmp, full)
            try:
                os.remove(tmp)
            except OSError:
                # Publication already succeeded. The exact adjacent scratch name is discoverable
                # and can be swept under the artifact lease; it is not sound to report the complete
                # destination as a failed write merely because unlinking its second name failed.
                pass
    except BaseException:
        if os.path.exists(tmp):
            try:
                os.remove(tmp)
            except OSError:
                pass
        raise
    return full
