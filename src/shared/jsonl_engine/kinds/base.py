"""Artifact kinds, declared as classes.

A kind is an archetype of artifact: `inventory`, not the inventory.jsonl under one directory. It
declares identity (KIND, VERSION), text policy (CODEC, EOL, ENCODING), sidecar policy (EMIT_INDEX,
EMIT_SIG), naming (NAME_FORMAT), and shape (RECORD_SCHEMA, HEADER_SCHEMA). Location is a call
argument.

Schema binding is strict. A kind naming a schema that cannot be resolved raises at construction; a
kind naming none is unvalidated.

validate_record dispatches on a row discriminator. HEADER_SCHEMA is the variant for
__type__ == "header". A kind carrying several body shapes needs the same dispatch over its own
discriminator.

Key extraction, uniqueness, and canonical ordering are deliberately absent here. They are not
missing features of a store -- they are the definition of a registry, and live in registry.py.
"""

import os
from abc import ABC
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

import jsonschema

from ..engine import Discipline, JsonlEngine
from ..policy import DEFAULT_ENCODING, Codec, Eol
from ..reader import JsonlStore
from ..schemas import SchemaCatalog, get_schema_catalog

# The base header schema every kind gets unless it declares its own. Named, not inlined: the two row
# categories are declared the same way, and a kind carrying container metadata of its own -- stats,
# scope, a source reference -- needs a schema file to put it in.
BASE_HEADER_SCHEMA = "header.schema.json"


class BaseStore(ABC):
    """Base class for artifact kinds. Seals identity and policy; resolves schemas at construction."""

    KIND: str = "base"
    VERSION: str = "1.0"
    DISCIPLINE: Discipline = Discipline.CREATE

    # The three text-policy axes, declared here because a kind is what knows them. The .sig records
    # all three, so a store this kind wrote carries its own policy and a reader never guesses.
    #
    # UNICODE is readable and refuses unpaired surrogates; ASCII escapes them losslessly and is for
    # extracted-text kinds only. LF and UTF-8 are this engine's posture for everything it writes --
    # a kind overrides them only to match a consumer that cannot be moved.
    CODEC: Codec = Codec.UNICODE
    EOL: Eol = Eol.LF
    ENCODING: str = DEFAULT_ENCODING

    # Sidecars, declared per kind. On by default because a signed, indexed store is the posture
    # worth defaulting to -- but a kind that appends often should weigh EMIT_SIG: every append
    # re-hashes the whole store, since a SHA-256 cannot be resumed from a digest.
    #
    # These are the floor, not the ceiling: a sidecar already on disk is maintained regardless, so
    # turning one off never orphans an existing one. See JsonlEngine.__enter__.
    EMIT_INDEX: bool = True
    EMIT_SIG: bool = True

    EMIT_HEADER: bool = False  # Default False to match unheadered production lanes
    NAME_FORMAT: str = "{kind}.jsonl"

    # The two row categories of a store, declared the same way. Either accepts any key the
    # SchemaCatalog indexes: a $id, a filename, or a filename stem.
    #
    # RECORD_SCHEMA governs one record. A JSONL container holds many under it; a JSON container one.
    # HEADER_SCHEMA governs the container metadata row, and defaults to the base.
    RECORD_SCHEMA: Optional[str] = None
    HEADER_SCHEMA: str = BASE_HEADER_SCHEMA

    def __init__(
        self,
        target_dir: str,
        run_id: Optional[str] = None,
        schema_catalog: Optional[SchemaCatalog] = None,
    ):
        self.target_dir = os.path.abspath(target_dir)
        self.run_id = run_id
        self._records: List[Dict[str, Any]] = []

        self.schemas = schema_catalog or get_schema_catalog()
        self._header_validator = self.schemas.get_validator(self.HEADER_SCHEMA)
        self._payload_validator = self._resolve_payload_validator()

    def _resolve_payload_validator(self) -> Optional[jsonschema.protocols.Validator]:
        """Resolve the record validator. Fails fast if RECORD_SCHEMA is declared but missing."""
        declared = self.RECORD_SCHEMA
        if declared is not None:
            if not self.schemas.has_schema(declared):
                raise KeyError(
                    f"Declared schema '{declared}' for kind '{self.KIND}' could not be resolved "
                    f"from the SchemaCatalog."
                )
            return self.schemas.get_validator(declared)

        if self.schemas.has_schema(self.KIND):
            return self.schemas.get_validator(self.KIND)

        return None

    def mint(self, values: Optional[Dict[str, Any]] = None, **_unused) -> Dict[str, Any]:
        """Build one record of this kind from a single data structure.

        Delegates to the schema: `const` and `default` properties are filled from the declaration,
        the rest comes from `values`, and key order follows the schema so records of one kind are
        byte-canonical. A kind declaring no RECORD_SCHEMA has nothing to mint from and says so.
        """
        if self.RECORD_SCHEMA is None:
            raise TypeError(
                f"Kind '{self.KIND}' declares no RECORD_SCHEMA, so there is no shape to mint from."
            )
        return self.schemas.mint(self.RECORD_SCHEMA, values)

    def get_output_path(self, stem: Optional[str] = None, filename: Optional[str] = None) -> str:
        """Resolve the final output path through NAME_FORMAT."""
        if filename:
            name = filename
        else:
            name = self.NAME_FORMAT.format(
                kind=self.KIND, stem=stem or "", run_id=self.run_id or ""
            )
            if name.startswith("."):
                name = name[1:]
            name = name.replace("..", ".")

        return os.path.join(self.target_dir, name)

    def validate_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """Validate against HEADER_SCHEMA for a header row, RECORD_SCHEMA otherwise."""
        if not isinstance(record, dict):
            raise jsonschema.ValidationError(f"Record must be a JSON dict, got {type(record)}")

        if record.get("__type__") == "header":
            errors = sorted(self._header_validator.iter_errors(record), key=lambda e: str(e.path))
            if errors:
                raise jsonschema.ValidationError(
                    f"Header validation failed for kind '{self.KIND}': {errors[0].message}"
                )
        elif self._payload_validator:
            errors = sorted(self._payload_validator.iter_errors(record), key=lambda e: str(e.path))
            if errors:
                first = errors[0]
                where = " -> ".join(str(p) for p in first.path) if first.path else "root"
                raise jsonschema.ValidationError(
                    f"Record validation failed for kind '{self.KIND}': {first.message} at [{where}]"
                )
        return record

    def header_fields(self) -> Dict[str, Any]:
        """Container metadata beyond the base. Overridden by a kind that declares its own."""
        return {}

    def header_base(self) -> Dict[str, Any]:
        """The header fields every kind carries. Overridable, because not every kind should
        stamp a wall clock into its bytes -- see Registry."""
        return {
            "__type__": "header",
            "kind": self.KIND,
            "version": self.VERSION,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }

    def build_header(self) -> Dict[str, Any]:
        """Construct and validate the header record."""
        header = self.header_base()
        header.update(self.header_fields())
        return self.validate_record(header)

    def add(self, record: Dict[str, Any]) -> None:
        """Buffer one validated record for write()."""
        self._records.append(self.validate_record(record))

    def open_writer(
        self, stem: Optional[str] = None, filename: Optional[str] = None
    ) -> "StoreWriter":
        """Streaming writer for this kind. Equivalent to add()/write(), at constant memory.

        Choose between them on memory alone: reach for write() only when the record set is
        something you need in hand before it lands -- to sort it, dedupe it, count it, or decide
        whether to write at all. Everything derived from a document, where the count follows the
        input, belongs here.
        """
        out_path = self.get_output_path(stem=stem, filename=filename)
        return StoreWriter(self, self._engine(out_path), out_path)

    def open_store(
        self, stem: Optional[str] = None, filename: Optional[str] = None
    ) -> JsonlStore:
        """Reader for a store of this kind, carrying its policy and record validator.

        The counterpart to open_writer. A caller reading a store this kind produced states nothing:
        the kind already declared what the bytes are and what shape they hold.
        """
        return JsonlStore(
            self.get_output_path(stem=stem, filename=filename),
            encoding=self.ENCODING,
            eol=self.EOL,
            validator=self._payload_validator,
        )

    def _engine(self, out_path: str) -> JsonlEngine:
        """A JsonlEngine carrying this kind's declared discipline and policy."""
        return JsonlEngine(
            output_path=out_path,
            discipline=self.DISCIPLINE,
            codec=self.CODEC,
            eol=self.EOL,
            encoding=self.ENCODING,
            emit_index=self.EMIT_INDEX,
            emit_sig=self.EMIT_SIG,
        )

    def wants_header(self, out_path: str) -> bool:
        """Whether this write should open with a header record.

        A header belongs to a store, not to a write: an APPEND landing in an existing store would
        otherwise put a second one partway through.
        """
        if not self.EMIT_HEADER:
            return False
        return self.DISCIPLINE == Discipline.CREATE or not os.path.exists(out_path)

    def stage_metadata(self) -> Dict[str, Any]:
        """What this kind records in the .sig's metadata block."""
        return {"kind": self.KIND, "version": self.VERSION, "run_id": self.run_id}

    def write(self, stem: Optional[str] = None, filename: Optional[str] = None) -> str:
        """Flush the records buffered by add(). Routed through the streaming writer, so both paths
        produce the same bytes for the same records."""
        with self.open_writer(stem=stem, filename=filename) as writer:
            for record in self._records:
                writer.append(record)
            writer.commit()
        return writer.output_path


class StoreWriter:
    """Streaming writer that applies a kind's rules on the way to a JsonlEngine.

    JsonlEngine knows nothing about kinds or schemas and should not: it is the byte layer. This is
    where the kind's validator and header rule attach, so a streamed write and a buffered one
    produce the same store from the same records.

    Not constructed directly. BaseStore.open_writer() builds it with the engine already carrying
    the kind's discipline and text policy.
    """

    def __init__(self, store: BaseStore, engine: JsonlEngine, output_path: str) -> None:
        self.store = store
        self.engine = engine
        self.output_path = output_path
        self.record_count = 0

    def __enter__(self) -> "StoreWriter":
        # Resolved before the engine opens: APPEND adoption does not change whether this store
        # already existed, but reading it after the fact would answer a different question.
        wants_header = self.store.wants_header(self.output_path)
        self.engine.__enter__()
        if wants_header:
            self.engine.append(self.store.build_header())
        return self

    def append(self, record: Dict[str, Any]) -> None:
        """Validate against the kind, then write. Refuses before any byte reaches the stream."""
        self.engine.append(self.store.validate_record(record))
        self.record_count += 1

    def commit(self, stage_metadata: Optional[Dict[str, Any]] = None) -> None:
        """Publish, defaulting the .sig metadata to this kind's identity."""
        self.engine.commit(stage_metadata=stage_metadata or self.store.stage_metadata())

    def __exit__(self, exc_type, exc_val, exc_tb):
        return self.engine.__exit__(exc_type, exc_val, exc_tb)
