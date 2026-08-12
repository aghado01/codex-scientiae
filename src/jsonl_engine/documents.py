"""Schema-backed single-object JSON document kinds and pinned stores."""

from __future__ import annotations

from abc import ABC
from typing import Any, Generic, Mapping, TypeVar, cast

from .policy import DEFAULT_ENCODING, Codec
from .publication import PinnedPublicationRoot, PublicationError
from .reader import loads
from .schemas import SchemaCatalog, get_schema_catalog
from .writer import serialize_json, write_bytes

DocumentValue = TypeVar("DocumentValue")


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
            if not self.root.lexists(self.path):
                return None
            return self.root.read_bytes(
                self.path,
                maximum_bytes=self.kind.MAXIMUM_BYTES,
            )
        except FileNotFoundError:
            return None
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise JsonDocumentError(f"document could not be read ({exc})", path=self.path) from exc

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
