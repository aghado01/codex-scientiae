"""
src/shared/jsonl_engine/registry.py - Base Artifact Registry with Tagged-Union Schema Validation
"""

import os
import jsonschema
from abc import ABC
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional

from .engine import JsonlEngine, Discipline


# Standard Schema for Header Records
HEADER_SCHEMA: Dict[str, Any] = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "type": "object",
    "required": ["__type__", "kind", "version", "created_at"],
    "properties": {
        "__type__": {"const": "header"},
        "kind": {"type": "string"},
        "version": {"type": "string"},
        "created_at": {"type": "string"}
    }
}


class BaseArtifactRegistry(ABC):
    """
    Abstract base class for JSONL artifact registries.
    Seals KIND, VERSION, and JSONSchema validation contracts.
    """
    KIND: str = "base"
    VERSION: str = "1.0"
    SCHEMA: Optional[Dict[str, Any]] = None  # Row/Payload schema dict

    def __init__(
        self,
        target_dir: str,
        run_id: Optional[str] = None,
        discipline: Discipline = Discipline.CREATE
    ):
        self.target_dir = os.path.abspath(target_dir)
        self.run_id = run_id
        self.discipline = discipline
        self._records: List[Dict[str, Any]] = []

        self._header_validator = jsonschema.Draft202012Validator(HEADER_SCHEMA)
        self._payload_validator = (
            jsonschema.Draft202012Validator(self.SCHEMA) if self.SCHEMA else None
        )

    def get_output_path(self) -> str:
        suffix = f".{self.run_id}" if self.run_id else ""
        return os.path.join(self.target_dir, f"{self.KIND}{suffix}.jsonl")

    def validate_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """
        Validates record against appropriate schema:
        - If __type__ == 'header', validates against HEADER_SCHEMA.
        - Otherwise, validates payload against self.SCHEMA.
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

    def open_writer(self) -> JsonlEngine:
        """Low-memory streaming context writer."""
        out_path = self.get_output_path()
        return JsonlEngine(output_path=out_path, discipline=self.discipline)

    def write(self) -> str:
        """Flushes buffered records to disk using JsonlEngine."""
        out_path = self.get_output_path()
        engine = JsonlEngine(output_path=out_path, discipline=self.discipline)

        with engine:
            # Header line (only for CREATE discipline or new file)
            if self.discipline == Discipline.CREATE or not os.path.exists(out_path):
                header = self.build_header()
                engine.append(header)

            # Record stream
            for rec in self._records:
                engine.append(rec)

            engine.commit(stage_metadata={
                "kind": self.KIND,
                "version": self.VERSION,
                "run_id": self.run_id
            })

        return out_path
