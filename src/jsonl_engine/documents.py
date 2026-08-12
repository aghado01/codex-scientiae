"""Schema-backed single-object JSON document kinds and pinned stores."""

from __future__ import annotations

import os
import stat
from abc import ABC
from typing import Any, Generic, Mapping, TypeVar, cast

from .policy import DEFAULT_ENCODING, Codec
from .publication import PinnedPublicationRoot
from .reader import loads
from .schemas import SchemaCatalog, get_schema_catalog
from .writer import serialize_json, write_bytes

DocumentValue = TypeVar("DocumentValue")
_REPARSE_POINT = getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0x400)


def _is_reparse(info: os.stat_result) -> bool:
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
    left_birth = getattr(left, "st_birthtime_ns", None)
    right_birth = getattr(right, "st_birthtime_ns", None)
    if left_birth is not None or right_birth is not None:
        return (
            left.st_dev == right.st_dev
            and left_birth == right_birth
            and left.st_size == right.st_size
        )
    return (
        left.st_dev == right.st_dev
        and left.st_size == right.st_size
        and getattr(left, "st_ctime_ns", None) == getattr(right, "st_ctime_ns", None)
    )


class JsonDocumentError(ValueError):
    """A schema-backed JSON document could not be validated or read."""

    def __init__(self, message: str, *, path: str | None = None) -> None:
        self.path = path
        super().__init__(f"{message}: '{path}'" if path else message)


class JsonDocumentKind(ABC, Generic[DocumentValue]):
    """Declared schema, byte policy, and domain conversion for one JSON document kind."""

    KIND = "document"
    SCHEMA: str | None = None
    MAXIMUM_BYTES = 1024 * 1024
    ENCODING = DEFAULT_ENCODING
    CODEC = Codec.UNICODE
    INDENT: int | None = 2
    SORT_KEYS = False
    TRAILING_NEWLINE = True

    def __init__(self, schema_catalog: SchemaCatalog | None = None) -> None:
        if not self.SCHEMA:
            raise TypeError(f"JSON document kind {self.KIND!r} declares no SCHEMA")
        if self.MAXIMUM_BYTES < 1:
            raise ValueError("MAXIMUM_BYTES must be positive")
        self.schemas = schema_catalog or get_schema_catalog()
        if not self.schemas.has_schema(self.SCHEMA):
            raise KeyError(
                f"Declared schema {self.SCHEMA!r} for JSON document kind {self.KIND!r} "
                "could not be resolved from the SchemaCatalog."
            )
        self._validator = self.schemas.get_validator(self.SCHEMA)

    def record_of(self, value: DocumentValue) -> dict[str, Any]:
        """Return the JSON object represented by one domain value."""

        if not isinstance(value, Mapping):
            raise TypeError(
                f"JSON document kind {self.KIND!r} requires record_of() for "
                f"{type(value).__name__} values"
            )
        return dict(value)

    def value_of(self, record: dict[str, Any]) -> DocumentValue:
        """Return the domain value represented by one validated JSON object."""

        return cast(DocumentValue, record)

    def validate_record(
        self,
        record: dict[str, Any],
        *,
        path: str | None = None,
    ) -> dict[str, Any]:
        """Validate one object against the document kind's declared schema."""

        if not isinstance(record, dict):
            raise JsonDocumentError(
                f"JSON document kind {self.KIND!r} requires one object",
                path=path,
            )
        errors = sorted(self._validator.iter_errors(record), key=lambda error: str(error.path))
        if errors:
            first = errors[0]
            where = " -> ".join(str(part) for part in first.path) if first.path else "root"
            raise JsonDocumentError(
                f"schema validation failed for {self.KIND!r} at [{where}]: {first.message}",
                path=path,
            ) from first
        return record

    def mint(self, values: dict[str, Any] | None = None) -> DocumentValue:
        """Mint and convert one value from the schema catalog."""

        assert self.SCHEMA is not None
        return self.value_of(self.schemas.mint(self.SCHEMA, values))

    def dumps(self, value: DocumentValue, *, path: str | None = None) -> bytes:
        """Validate and serialize one domain value under the declared byte policy."""

        try:
            record = self.validate_record(self.record_of(value), path=path)
        except JsonDocumentError:
            raise
        except (TypeError, ValueError) as exc:
            raise JsonDocumentError(
                f"domain conversion failed for JSON document kind {self.KIND!r}: {exc}",
                path=path,
            ) from exc
        raw = serialize_json(
            record,
            encoding=self.ENCODING,
            codec=self.CODEC,
            indent=self.INDENT,
            sort_keys=self.SORT_KEYS,
            trailing_newline=self.TRAILING_NEWLINE,
            path=path,
        )
        if len(raw) > self.MAXIMUM_BYTES:
            raise JsonDocumentError(
                f"serialized {self.KIND!r} document exceeds the "
                f"{self.MAXIMUM_BYTES}-byte boundary",
                path=path,
            )
        return raw

    def loads(self, raw: bytes, *, path: str) -> DocumentValue:
        """Parse, schema-validate, and convert one bounded JSON document."""

        if len(raw) > self.MAXIMUM_BYTES:
            raise JsonDocumentError(
                f"{self.KIND!r} document exceeds the {self.MAXIMUM_BYTES}-byte boundary",
                path=path,
            )
        try:
            record = loads(
                raw,
                path=path,
                encoding=self.ENCODING,
                validator=self._validator,
                require_object=True,
            )
            return self.value_of(record)
        except JsonDocumentError:
            raise
        except (TypeError, ValueError) as exc:
            raise JsonDocumentError(
                f"invalid {self.KIND!r} document ({exc})",
                path=path,
            ) from exc


class JsonDocumentStore(Generic[DocumentValue]):
    """One direct-child JSON document beneath an active pinned directory generation.

    The store owns validation, stable reads, and atomic publication. Its caller owns the
    transaction lease and decides whether replacement is authorized.
    """

    def __init__(
        self,
        root: PinnedPublicationRoot,
        leaf: str,
        kind: JsonDocumentKind[DocumentValue],
    ) -> None:
        root.identity
        self.root = root
        self.kind = kind
        self.path = root.absolute(leaf)
        self.leaf = root.direct_leaf(self.path)

    def exists(self) -> bool:
        """Return whether the document leaf is occupied in the pinned generation."""

        self.root.assert_current()
        return self.root.lexists(self.path)

    def _read_bytes(self) -> bytes | None:
        try:
            named_before = self.root.stat_leaf(self.leaf)
        except FileNotFoundError:
            return None
        if not stat.S_ISREG(named_before.st_mode) or _is_reparse(named_before):
            raise JsonDocumentError("document path is not a physical regular file", path=self.path)
        if named_before.st_size > self.kind.MAXIMUM_BYTES:
            raise JsonDocumentError(
                f"document exceeds the {self.kind.MAXIMUM_BYTES}-byte boundary",
                path=self.path,
            )
        try:
            with self.root.open_leaf(self.leaf, "rb") as handle:
                opened_before = os.fstat(handle.fileno())
                if not stat.S_ISREG(opened_before.st_mode) or not _same_named_generation(
                    named_before, opened_before
                ):
                    raise JsonDocumentError(
                        "document changed before it could be read",
                        path=self.path,
                    )
                raw = handle.read(self.kind.MAXIMUM_BYTES + 1)
                opened_after = os.fstat(handle.fileno())
        except JsonDocumentError:
            raise
        except OSError as exc:
            raise JsonDocumentError("document could not be read", path=self.path) from exc
        if (
            len(raw) > self.kind.MAXIMUM_BYTES
            or len(raw) != opened_after.st_size
            or not _same_open_snapshot(opened_before, opened_after)
        ):
            raise JsonDocumentError("document changed while it was read", path=self.path)
        try:
            named_after = self.root.stat_leaf(self.leaf)
        except OSError as exc:
            raise JsonDocumentError(
                "document disappeared after it was read",
                path=self.path,
            ) from exc
        if _is_reparse(named_after) or not _same_named_generation(opened_after, named_after):
            raise JsonDocumentError("document path changed while it was read", path=self.path)
        return raw

    def read(self) -> DocumentValue | None:
        """Return the validated document, or ``None`` when its leaf is absent."""

        self.root.assert_current()
        raw = self._read_bytes()
        self.root.assert_current()
        if raw is None:
            return None
        return self.kind.loads(raw, path=self.path)

    def require(self) -> DocumentValue:
        """Return the validated document and reject an absent leaf."""

        value = self.read()
        if value is None:
            raise FileNotFoundError(self.path)
        return value

    def publish(self, value: DocumentValue, *, overwrite: bool = False) -> str:
        """Atomically publish one validated document in the pinned generation."""

        self.root.assert_current()
        raw = self.kind.dumps(value, path=self.path)
        written = write_bytes(
            self.path,
            raw,
            overwrite=overwrite,
            publication_root=self.root,
        )
        self.root.assert_current()
        return written


__all__ = ["JsonDocumentError", "JsonDocumentKind", "JsonDocumentStore"]
