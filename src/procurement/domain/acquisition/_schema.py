"""Acquisition JSON Schema callbacks."""

from __future__ import annotations

from typing import Any

from procurement.domain.base import _require_serialized_properties

_MD5_PATTERN = r"^[0-9a-f]{32}$"
_SHA256_PATTERN = r"^[0-9a-f]{64}$"
_ACQUISITION_RUNTIME_INVARIANTS = (
    "artifact provider, slug, and identifier form one canonical provider identity",
    "form paths are unique under portable Unicode case-folding",
)


def checksum_schema(schema: dict[str, Any]) -> None:
    _require_serialized_properties(schema)
    schema["allOf"] = [
        {
            "if": {
                "properties": {"algorithm": {"const": algorithm}},
                "required": ["algorithm"],
            },
            "then": {"properties": {"digest": {"pattern": pattern}}},
        }
        for algorithm, pattern in (("md5", _MD5_PATTERN), ("sha256", _SHA256_PATTERN))
    ]


def acquisition_manifest_schema_extra(schema: dict[str, Any]) -> None:
    _require_serialized_properties(schema)
    schema["allOf"] = [
        {
            "properties": {
                "forms": {
                    "contains": {
                        "type": "object",
                        "properties": {"kind": {"const": kind}},
                        "required": ["kind"],
                    },
                    "minContains": 0,
                    "maxContains": 1,
                }
            }
        }
        for kind in ("source", "pdf", "html")
    ]
    schema["x-runtime-invariants"] = list(_ACQUISITION_RUNTIME_INVARIANTS)


def acquired_artifact_schema_extra(schema: dict[str, Any]) -> None:
    _require_serialized_properties(schema)
    schema["allOf"] = [
        {
            "if": {
                "properties": {"custody": {"const": "provider-download"}},
                "required": ["custody"],
            },
            "then": {
                "properties": {
                    "origin_url": {"type": "string"},
                    "candidate_id": {"type": "string", "minLength": 1},
                    "fetched_at": {"type": "string", "format": "date-time"},
                    "local_import": {"type": "null"},
                }
            },
        },
        {
            "if": {
                "properties": {"custody": {"const": "local-import"}},
                "required": ["custody"],
            },
            "then": {
                "properties": {
                    "origin_url": {"type": "null"},
                    "candidate_id": {"type": "null"},
                    "fetched_at": {"type": "null"},
                    "provider_checksum": {"type": "null"},
                    "local_import": {"not": {"type": "null"}},
                }
            },
        },
        {
            "if": {
                "properties": {"custody": {"const": "adopted"}},
                "required": ["custody"],
            },
            "then": {
                "properties": {
                    "origin_url": {"type": "null"},
                    "candidate_id": {"type": "null"},
                    "fetched_at": {"type": "null"},
                    "provider_checksum": {"type": "null"},
                    "local_import": {"type": "null"},
                }
            },
        },
    ]


def acquisition_outcome_schema(schema: dict[str, Any]) -> None:
    _require_serialized_properties(schema)
    schema["allOf"] = [
        {
            "if": {
                "properties": {
                    "status": {"enum": ["acquired", "already-present"]}
                },
                "required": ["status"],
            },
            "then": {
                "properties": {"path": {"type": "string"}, "error": {"type": "null"}}
            },
            "else": {
                "properties": {
                    "path": {"type": "null"},
                    "error": {"type": "string", "minLength": 1},
                }
            },
        }
    ]


def acquisition_result_schema(schema: dict[str, Any]) -> None:
    _require_serialized_properties(schema)
    schema["allOf"] = [
        {
            "if": {
                "properties": {"manifest": {"type": "null"}},
                "required": ["manifest"],
            },
            "then": {"properties": {"manifest_path": {"type": "null"}}},
            "else": {"properties": {"manifest_path": {"type": "string"}}},
        },
        {
            "if": {
                "properties": {
                    "outcomes": {
                        "contains": {
                            "type": "object",
                            "properties": {
                                "status": {"enum": ["acquired", "already-present"]}
                            },
                            "required": ["status"],
                        }
                    }
                },
                "required": ["outcomes"],
            },
            "then": {"properties": {"manifest": {"not": {"type": "null"}}}},
        },
    ]


__all__ = [
    "acquired_artifact_schema_extra",
    "acquisition_manifest_schema_extra",
    "acquisition_outcome_schema",
    "acquisition_result_schema",
    "checksum_schema",
]
