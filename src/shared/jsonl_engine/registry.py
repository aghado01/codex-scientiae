"""Artifact kinds, declared as classes.

A kind is an archetype of JSONL artifact: `inventory`, not the inventory.jsonl under one directory.

Identity is declared as class attributes -- KIND, VERSION, DISCIPLINE, CODEC, EMIT_HEADER,
NAME_FORMAT, RECORD_SCHEMA, PARENT_KIND and CHILD_KINDS. Location is a call argument.
__init__ accepts target_dir, run_id, and a schema_registry override.

Schema binding is strict. A kind naming a schema that cannot be resolved raises at construction; a
kind naming none is unvalidated.

validate_record dispatches on a row discriminator. HEADER_SCHEMA is the variant for
__type__ == "header". A kind carrying several body shapes needs the same dispatch over its own
discriminator.

Key extraction, uniqueness, and canonical ordering are not implemented.
"""

import os
import jsonschema
from abc import ABC
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from .engine import JsonlEngine, Discipline
from .policy import DEFAULT_ENCODING, Codec, Eol
from .reader import JsonlStore
from .schema_registry import get_global_schema_registry, SchemaRegistry


# The base header schema every kind gets unless it declares its own. Named, not inlined: the two row
# categories are declared the same way, and a kind carrying container metadata of its own -- stats,
# scope, a source reference -- needs a schema file to put it in.
BASE_HEADER_SCHEMA = "header.schema.json"


class BaseStore(ABC):
    """
    Abstract base class for JSONL artifact registries.
    Seals KIND, VERSION, DISCIPLINE, EMIT_HEADER, resolves JSONSchema via SchemaRegistry,
    and captures hierarchical parent-child relationships between artifact kinds.
    Fails fast if a declared schema cannot be resolved.
    """
    KIND: str = "base"
    VERSION: str = "1.0"
    DISCIPLINE: Discipline = Discipline.CREATE

    # The three text-policy axes, declared here because a kind is what knows them. The .sig records
    # all three, so a store this registry wrote carries its own policy and a reader never guesses.
    #
    # UNICODE is readable and refuses unpaired surrogates; ASCII escapes them losslessly and is for
    # extracted-text kinds only. LF and UTF-8 are this engine's posture for everything it writes --
    # a kind overrides them only to match a consumer that cannot be moved.
    CODEC: Codec = Codec.UNICODE
    EOL: Eol = Eol.LF
    ENCODING: str = DEFAULT_ENCODING

    EMIT_HEADER: bool = False  # Default False to match unheadered production lanes
    NAME_FORMAT: str = "{kind}.jsonl"

    # Hierarchy declaration
    PARENT_KIND: Optional[str] = None
    CHILD_KINDS: List[str] = []

    # The two row categories of a JSONL store, declared the same way. Either accepts any key
    # SchemaRegistry indexes: a $id, a filename, or a filename stem.
    #
    # RECORD_SCHEMA governs one record. A JSONL container holds many under it; a JSON container one.
    # HEADER_SCHEMA governs the container metadata row, and defaults to the base.
    RECORD_SCHEMA: Optional[str] = None
    HEADER_SCHEMA: str = BASE_HEADER_SCHEMA

    def __init__(
        self,
        target_dir: str,
        run_id: Optional[str] = None,
        schema_registry: Optional[SchemaRegistry] = None
    ):
        self.target_dir = os.path.abspath(target_dir)
        self.run_id = run_id
        self._records: List[Dict[str, Any]] = []

        self.schema_registry = schema_registry or get_global_schema_registry()
        self._header_validator = self.schema_registry.get_validator(self.HEADER_SCHEMA)
        self._payload_validator = self._resolve_payload_validator()

    def _resolve_payload_validator(self) -> Optional[jsonschema.protocols.Validator]:
        """
        Resolves the compiled jsonschema validator from the SchemaRegistry.
        Fails fast with KeyError if RECORD_SCHEMA is declared but missing.
        """
        declared_key = self.RECORD_SCHEMA
        if declared_key is not None:
            if not self.schema_registry.has_schema(declared_key):
                raise KeyError(
                    f"Declared schema '{declared_key}' for artifact registry kind '{self.KIND}' "
                    f"could not be resolved from SchemaRegistry."
                )
            return self.schema_registry.get_validator(declared_key)

        # Fallback to KIND lookup if available
        if self.schema_registry.has_schema(self.KIND):
            return self.schema_registry.get_validator(self.KIND)

        return None

    def get_child_registry(self, child_kind: str, child_target_dir: Optional[str] = None) -> 'BaseStore':
        """Instantiates a child registry of this parent artifact."""
        from .registries.catalog import RegistryCatalog
        if child_kind not in self.CHILD_KINDS and child_kind != "any":
            raise ValueError(
                f"Kind '{child_kind}' is not declared as a valid child of parent kind '{self.KIND}'. "
                f"Allowed: {self.CHILD_KINDS}"
            )

        target = child_target_dir or self.target_dir
        return RegistryCatalog.create(child_kind, target_dir=target, run_id=self.run_id)

    def get_output_path(self, stem: Optional[str] = None, filename: Optional[str] = None) -> str:
        """
        Resolves final output path cleanly through NAME_FORMAT.
        """
        if filename:
            name = filename
        else:
            name = self.NAME_FORMAT.format(
                kind=self.KIND,
                stem=stem or "",
                run_id=self.run_id or ""
            )
            # Clean up leading or double dots if stem/run_id is empty
            if name.startswith("."):
                name = name[1:]
            name = name.replace("..", ".")
            
        return os.path.join(self.target_dir, name)

    def validate_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """
        Validates record against appropriate schema:
        - If __type__ == 'header', validates against HEADER_SCHEMA.
        - Otherwise, validates payload against resolved external JSONSchema.
        """
        if not isinstance(record, dict):
            raise jsonschema.ValidationError(f"Record must be a JSON dict, got {type(record)}")

        rec_type = record.get("__type__")
        if rec_type == "header":
            errors = sorted(self._header_validator.iter_errors(record), key=lambda e: str(e.path))
            if errors:
                raise jsonschema.ValidationError(
                    f"Header validation failed for kind '{self.KIND}': {errors[0].message}"
                )
        elif self._payload_validator:
            errors = sorted(self._payload_validator.iter_errors(record), key=lambda e: str(e.path))
            if errors:
                first_err = errors[0]
                path_str = " -> ".join(str(p) for p in first_err.path) if first_err.path else "root"
                raise jsonschema.ValidationError(
                    f"Record validation failed for kind '{self.KIND}': {first_err.message} at [{path_str}]"
                )
        return record

    def build_header(self) -> Dict[str, Any]:
        """Constructs and validates the header record."""
        header = {
            "__type__": "header",
            "kind": self.KIND,
            "version": self.VERSION,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        return self.validate_record(header)

    def add(self, record: Dict[str, Any]) -> None:
        """In-memory batch record accumulation."""
        validated = self.validate_record(record)
        self._records.append(validated)

    def open_writer(
        self, stem: Optional[str] = None, filename: Optional[str] = None
    ) -> "StoreWriter":
        """Streaming writer for this kind. Equivalent to add()/write(), at constant memory.

        Choose between them on memory alone: reach for write() only when the record set is
        something you need in hand before it lands -- to sort it, dedupe it, count it, or decide
        whether to write at all. Everything derived from a document, where the count follows the
        input, belongs here.

        That is a real choice only because this writer applies the kind's validator and header
        rules, which a bare JsonlEngine does not. It used to return the engine, so streaming
        silently skipped both.
        """
        out_path = self.get_output_path(stem=stem, filename=filename)
        return StoreWriter(self, self._engine(out_path), out_path)

    def open_store(
        self, stem: Optional[str] = None, filename: Optional[str] = None
    ) -> JsonlStore:
        """Reader for a store of this kind, carrying the kind's policy and record validator.

        The counterpart to open_writer. A caller reading a store this registry produced states
        nothing: the kind already declared what the bytes are and what shape they hold.
        """
        return JsonlStore(
            self.get_output_path(stem=stem, filename=filename),
            encoding=self.ENCODING,
            eol=self.EOL,
            validator=self._payload_validator,
        )

    def _engine(self, out_path: str) -> JsonlEngine:
        """A JsonlEngine carrying this kind's declared discipline and text policy."""
        return JsonlEngine(
            output_path=out_path,
            discipline=self.DISCIPLINE,
            codec=self.CODEC,
            eol=self.EOL,
            encoding=self.ENCODING,
        )

    def wants_header(self, out_path: str) -> bool:
        """Whether this write should open with a header record.

        A header belongs to a store, not to a write: an APPEND that lands in an existing store
        would otherwise put a second one partway through.
        """
        if not self.EMIT_HEADER:
            return False
        return self.DISCIPLINE == Discipline.CREATE or not os.path.exists(out_path)

    def stage_metadata(self) -> Dict[str, Any]:
        """What this kind records in the .sig's metadata block."""
        return {"kind": self.KIND, "version": self.VERSION, "run_id": self.run_id}

    def write(self, stem: Optional[str] = None, filename: Optional[str] = None) -> str:
        """Flush the records accumulated by add() to disk.

        Buffered rather than streamed; see open_writer for which to reach for. Routed through the
        same writer so both paths produce the same bytes for the same records.
        """
        with self.open_writer(stem=stem, filename=filename) as writer:
            for rec in self._records:
                writer.append(rec)
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
        # already existed, but reading it after the fact would be answering a different question.
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
