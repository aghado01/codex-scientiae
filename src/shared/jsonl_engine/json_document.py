"""Single-object JSON artifacts: article manifests, provider metadata, .sig sidecars.

read_json_value reads and parses one file. The read is binary; a UTF-8 BOM, invalid UTF-8, malformed
JSON, and a non-object top level are rejected. require_object=False permits any top-level value.

read_json_document adds validation. Its validator argument is positional with no default and accepts
None, which declares the document unvalidated.

Failures raise JsonDocumentError, which carries the path.

Schemas are read by SchemaRegistry.read_schema_file. The atomic single-object writer is not
implemented.
"""

import json
import os
from typing import Any, Optional

UTF8_BOM = b"\xef\xbb\xbf"


class JsonDocumentError(ValueError):
    """A JSON document could not be read, or did not satisfy its declared shape.

    Carries the path so a caller can report which artifact failed without reconstructing it.
    """

    def __init__(self, path: str, message: str) -> None:
        self.path = path
        super().__init__(f"{message}: '{path}'")


def read_json_value(path: str, require_object: bool = True) -> Any:
    """Read and parse one JSON file. No schema authority.

    Rejects a UTF-8 BOM, invalid UTF-8, malformed JSON, and -- unless require_object is False -- a
    top-level value that is not an object.
    """
    full = os.path.abspath(path)
    if not os.path.exists(full):
        raise FileNotFoundError(f"JSON document not found: '{full}'")

    with open(full, "rb") as handle:
        raw = handle.read()

    if raw.startswith(UTF8_BOM):
        raise JsonDocumentError(full, "JSON document must be UTF-8 without BOM")

    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise JsonDocumentError(full, f"JSON document is not valid UTF-8 ({exc})") from exc

    try:
        value = json.loads(text)
    except json.JSONDecodeError as exc:
        raise JsonDocumentError(
            full, f"JSON document is malformed (line {exc.lineno}, column {exc.colno})"
        ) from exc

    if require_object and not isinstance(value, dict):
        raise JsonDocumentError(full, f"JSON document must be one object, got {type(value).__name__}")

    return value


def read_json_document(path: str, validator: Any, require_object: bool = True) -> Any:
    """Read one JSON document and validate it.

    `validator` is positional and has no default: a call site must state what authority applies.
    Pass a compiled jsonschema validator, or None to declare the document deliberately unvalidated
    -- foreign input such as an acquisition tool's output, where a schema would be a guess.
    """
    full = os.path.abspath(path)
    value = read_json_value(full, require_object=require_object)
    if validator is None:
        return value

    errors = sorted(validator.iter_errors(value), key=lambda e: str(e.path))
    if errors:
        first = errors[0]
        where = " -> ".join(str(p) for p in first.path) if first.path else "root"
        raise JsonDocumentError(full, f"JSON document failed schema validation at [{where}]: {first.message}")
    return value


def read_json_value_or_none(path: str, require_object: bool = True) -> Optional[Any]:
    """Read and parse one JSON file, or return None when it is absent.

    For optional sidecars, where absence is a normal state and a malformed file is still an error.
    """
    if not os.path.exists(os.path.abspath(path)):
        return None
    return read_json_value(path, require_object=require_object)
