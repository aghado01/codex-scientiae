"""Artifact acquisition plans, receipts, and operation results."""

from __future__ import annotations

import ipaddress
from datetime import datetime
from typing import Any, Literal, Self
from urllib.parse import urlsplit

from pydantic import ConfigDict, Field, field_validator, model_validator

from procurement.identifiers import artifact_slug
from procurement.models import (
    ArtifactReference,
    DomainModel,
    PORTABLE_LEAF_PATTERN,
    validate_artifact_deposit_reference,
    validate_deposit_slug,
)

ArtifactKind = Literal["source", "pdf", "html"]
PayloadKind = Literal["gzip", "pdf", "html"]
_MD5_PATTERN = r"^[0-9a-f]{32}$"
_SHA256_PATTERN = r"^[0-9a-f]{64}$"
SAFE_ARTIFACT_URL_PATTERN = (
    r"^(?:"
    r"[Hh][Tt][Tt][Pp][Ss]://(?:[^:/?#@\s\[\]]+|\[[0-9A-Fa-f:.]+\])"
    r"(?::[0-9]{1,5})?"
    r"|[Hh][Tt][Tt][Pp]://(?:"
    r"[Ll][Oo][Cc][Aa][Ll][Hh][Oo][Ss][Tt]\.?"
    r"|127(?:\.(?:0|[1-9][0-9]?|1[0-9]{2}|2[0-4][0-9]|25[0-5])){3}"
    r"|\[(?:::1|0:0:0:0:0:0:0:1)\]"
    r")(?::[0-9]{1,5})?"
    r")(?=[/?#]|$)"
)
_ACQUISITION_RUNTIME_INVARIANTS = (
    "artifact provider, slug, and identifier form one canonical provider identity",
    "form paths are unique under portable Unicode case-folding",
)


def _require_serialized_properties(schema: dict[str, Any]) -> None:
    properties = schema.get("properties")
    if isinstance(properties, dict):
        schema["required"] = list(properties)


def _checksum_schema(schema: dict[str, Any]) -> None:
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


def _acquisition_manifest_schema_extra(schema: dict[str, Any]) -> None:
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


def _acquired_artifact_schema_extra(schema: dict[str, Any]) -> None:
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
            "else": {
                "properties": {
                    "origin_url": {"type": "null"},
                    "candidate_id": {"type": "null"},
                    "fetched_at": {"type": "null"},
                    "provider_checksum": {"type": "null"},
                    "local_import": {"not": {"type": "null"}},
                }
            },
        }
    ]


def _acquisition_outcome_schema(schema: dict[str, Any]) -> None:
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


def _acquisition_result_schema(schema: dict[str, Any]) -> None:
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


def _unique_text(values: object, *, label: str) -> tuple[str, ...]:
    if isinstance(values, str):
        values = (values,)
    if not isinstance(values, (list, tuple, set, frozenset)):
        raise ValueError(f"{label} must be a sequence")
    result: list[str] = []
    seen: set[str] = set()
    for value in values:
        if not isinstance(value, str) or not value.strip():
            raise ValueError(f"{label} entries must be non-empty strings")
        text = value.strip()
        key = text.casefold()
        if key not in seen:
            seen.add(key)
            result.append(text)
    return tuple(result)


def _is_loopback_host(value: str) -> bool:
    host = value.casefold().rstrip(".")
    if host == "localhost":
        return True
    try:
        return ipaddress.ip_address(host).is_loopback
    except ValueError:
        return False


def is_safe_artifact_url(value: object) -> bool:
    """Return whether an artifact route uses HTTPS or deliberate loopback HTTP."""

    if not isinstance(value, str) or not value.strip():
        return False
    parsed = urlsplit(value.strip())
    if not parsed.hostname or parsed.username is not None or parsed.password is not None:
        return False
    scheme = parsed.scheme.casefold()
    return scheme == "https" or (scheme == "http" and _is_loopback_host(parsed.hostname))


def _safe_http_url(value: object, *, label: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"{label} must be a non-empty URL")
    text = value.strip()
    parsed = urlsplit(text)
    if not is_safe_artifact_url(text):
        raise ValueError(f"{label} must use HTTPS or loopback HTTP without credentials")
    if parsed.username is not None or parsed.password is not None:
        raise ValueError(f"{label} must not contain URL credentials")
    return text


class ArtifactAcquisitionRequest(DomainModel):
    """One server-planned artifact acquisition request."""

    provider: str = Field(min_length=1)
    identifier: str = Field(min_length=1)
    artifacts: tuple[ArtifactKind, ...] = Field(
        default=("source",),
        min_length=1,
        json_schema_extra={"uniqueItems": True},
    )

    @field_validator("provider", "identifier", mode="before")
    @classmethod
    def _strip_text(cls, value: object) -> str:
        if not isinstance(value, str) or not value.strip():
            raise ValueError("provider and identifier must be non-empty strings")
        return value.strip()

    @field_validator("artifacts", mode="before")
    @classmethod
    def _deduplicate_artifacts(cls, value: object) -> tuple[str, ...]:
        return _unique_text(value, label="artifacts")


class ChecksumExpectation(DomainModel):
    """Provider-supplied integrity evidence for one payload."""

    model_config = ConfigDict(json_schema_extra=_checksum_schema)

    algorithm: Literal["md5", "sha256"]
    digest: str

    @field_validator("digest", mode="before")
    @classmethod
    def _canonical_digest(cls, value: object) -> str:
        if not isinstance(value, str):
            raise ValueError("checksum digest must be a string")
        return value.strip().casefold()

    @model_validator(mode="after")
    def _validate_digest(self) -> Self:
        length = 32 if self.algorithm == "md5" else 64
        if len(self.digest) != length or any(char not in "0123456789abcdef" for char in self.digest):
            raise ValueError(f"{self.algorithm} digest must be {length} lowercase hexadecimal characters")
        return self


class RetrievalCandidate(DomainModel):
    """One trusted provider-produced route for a planned payload."""

    candidate_id: str = Field(min_length=1)
    url: str
    allowed_hosts: tuple[str, ...] = Field(min_length=1, json_schema_extra={"uniqueItems": True})

    @field_validator("candidate_id", mode="before")
    @classmethod
    def _strip_candidate_id(cls, value: object) -> str:
        if not isinstance(value, str) or not value.strip():
            raise ValueError("candidate_id must be a non-empty string")
        return value.strip()

    @field_validator("url", mode="before")
    @classmethod
    def _validate_url(cls, value: object) -> str:
        return _safe_http_url(value, label="candidate URL")

    @field_validator("allowed_hosts", mode="before")
    @classmethod
    def _canonical_hosts(cls, value: object) -> tuple[str, ...]:
        hosts = _unique_text(value, label="allowed_hosts")
        result: list[str] = []
        for host in hosts:
            normalized = host.casefold().strip(".")
            if not normalized or any(char in normalized for char in "/:@[]"):
                raise ValueError("allowed_hosts entries must be DNS host names")
            result.append(normalized)
        return tuple(result)

    @model_validator(mode="after")
    def _initial_host_is_allowed(self) -> Self:
        host = (urlsplit(self.url).hostname or "").casefold().strip(".")
        if host not in self.allowed_hosts:
            raise ValueError("candidate URL host is not in allowed_hosts")
        return self


class PlannedArtifact(DomainModel):
    """Expected bytes and ordered retrieval routes for one logical artifact."""

    kind: ArtifactKind
    target_leaf: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    media_type: str = Field(min_length=1)
    payload_kind: PayloadKind
    minimum_bytes: int = Field(default=1, ge=1)
    maximum_bytes: int = Field(ge=1)
    expected_bytes: int | None = Field(default=None, ge=1)
    checksum: ChecksumExpectation | None = None
    candidates: tuple[RetrievalCandidate, ...] = Field(min_length=1)

    @field_validator("target_leaf", mode="before")
    @classmethod
    def _portable_target(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @model_validator(mode="after")
    def _validate_expectation(self) -> Self:
        if self.minimum_bytes > self.maximum_bytes:
            raise ValueError("minimum_bytes cannot exceed maximum_bytes")
        if self.expected_bytes is not None and not (
            self.minimum_bytes <= self.expected_bytes <= self.maximum_bytes
        ):
            raise ValueError("expected_bytes must fall within the payload bounds")
        ids = [candidate.candidate_id.casefold() for candidate in self.candidates]
        if len(ids) != len(set(ids)):
            raise ValueError("retrieval candidate IDs must be unique")
        return self


class UnavailableArtifact(DomainModel):
    """A requested artifact absent from a provider manifest."""

    kind: ArtifactKind
    reason: str = Field(min_length=1)


class ArtifactPlan(DomainModel):
    """Immutable provider plan consumed only inside the acquisition application."""

    schema_id: Literal["codex-scientiae/artifact-plan/0.1"] = Field(
        default="codex-scientiae/artifact-plan/0.1",
        alias="schema",
    )
    artifact: ArtifactReference
    deposit_slug: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    requested: tuple[ArtifactKind, ...] = Field(min_length=1, json_schema_extra={"uniqueItems": True})
    payloads: tuple[PlannedArtifact, ...] = ()
    unavailable: tuple[UnavailableArtifact, ...] = ()

    @field_validator("deposit_slug", mode="before")
    @classmethod
    def _portable_slug(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @field_validator("requested", mode="before")
    @classmethod
    def _requested_unique(cls, value: object) -> tuple[str, ...]:
        return _unique_text(value, label="requested")

    @model_validator(mode="after")
    def _validate_plan(self) -> Self:
        canonical = validate_artifact_deposit_reference(
            self.artifact.provider,
            self.deposit_slug,
            self.artifact.identifier,
        )
        if canonical != self.artifact.identifier:
            raise ValueError("artifact plan identifier is not canonical")
        expected_slug = artifact_slug(self.artifact.provider, self.artifact.identifier)
        if self.deposit_slug != expected_slug:
            raise ValueError("artifact plan slug does not match its provider identity")
        planned = [payload.kind for payload in self.payloads]
        missing = [item.kind for item in self.unavailable]
        if len(planned) != len(set(planned)) or len(missing) != len(set(missing)):
            raise ValueError("planned and unavailable artifact kinds must each be unique")
        if set(planned).intersection(missing):
            raise ValueError("an artifact kind cannot be both planned and unavailable")
        if set(planned).union(missing) != set(self.requested):
            raise ValueError("artifact plan must account for every requested kind")
        paths = [payload.target_leaf.casefold() for payload in self.payloads]
        if len(paths) != len(set(paths)):
            raise ValueError("planned target paths must be portable-case unique")
        return self


class ArtifactPlanItemSummary(DomainModel):
    """Credential-free route summary safe to expose over MCP."""

    kind: ArtifactKind
    target_leaf: str
    payload_kind: PayloadKind
    candidate_count: int = Field(ge=1)
    provider_checksum: bool
    maximum_bytes: int = Field(ge=1)


class ArtifactPlanSummary(DomainModel):
    """Safe public projection of an internal artifact plan."""

    provider: str
    identifier: str
    deposit_slug: str
    payloads: tuple[ArtifactPlanItemSummary, ...]
    unavailable: tuple[UnavailableArtifact, ...]

    @classmethod
    def from_plan(cls, plan: ArtifactPlan) -> "ArtifactPlanSummary":
        return cls(
            provider=plan.artifact.provider,
            identifier=plan.artifact.identifier,
            deposit_slug=plan.deposit_slug,
            payloads=tuple(
                ArtifactPlanItemSummary(
                    kind=item.kind,
                    target_leaf=item.target_leaf,
                    payload_kind=item.payload_kind,
                    candidate_count=len(item.candidates),
                    provider_checksum=item.checksum is not None,
                    maximum_bytes=item.maximum_bytes,
                )
                for item in plan.payloads
            ),
            unavailable=plan.unavailable,
        )


class LocalImportProvenance(DomainModel):
    """Configured logical source and time for a local custody transfer."""

    inbox: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    leaf: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    imported_at: datetime

    @field_validator("inbox", "leaf", mode="before")
    @classmethod
    def _portable_leaf(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @model_validator(mode="after")
    def _require_aware_time(self) -> Self:
        if self.imported_at.tzinfo is None or self.imported_at.utcoffset() is None:
            raise ValueError("imported_at must include a UTC offset")
        return self


class AcquiredArtifact(DomainModel):
    """One locally validated artifact named by an acquisition receipt."""

    model_config = ConfigDict(json_schema_extra=_acquired_artifact_schema_extra)

    kind: ArtifactKind
    path: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    format: str = Field(min_length=1)
    bytes: int = Field(ge=1)
    sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    custody: Literal["provider-download", "local-import"] = "provider-download"
    origin_url: str | None = Field(
        default=None,
        json_schema_extra={"format": "uri", "pattern": SAFE_ARTIFACT_URL_PATTERN},
    )
    candidate_id: str | None = Field(default=None, min_length=1)
    fetched_at: datetime | None = None
    provider_checksum: ChecksumExpectation | None = None
    local_import: LocalImportProvenance | None = None

    @field_validator("path", mode="before")
    @classmethod
    def _portable_path(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @field_validator("origin_url", mode="before")
    @classmethod
    def _origin_url(cls, value: object | None) -> str | None:
        if value is None:
            return None
        return _safe_http_url(value, label="origin_url")

    @model_validator(mode="after")
    def _validate_custody(self) -> Self:
        if self.custody == "provider-download":
            if self.origin_url is None or self.candidate_id is None or self.fetched_at is None:
                raise ValueError(
                    "provider-download custody requires origin_url, candidate_id, and fetched_at"
                )
            if self.local_import is not None:
                raise ValueError("provider-download custody cannot name a local import")
        else:
            if self.local_import is None:
                raise ValueError("local-import custody requires local_import provenance")
            if any(
                value is not None
                for value in (
                    self.origin_url,
                    self.candidate_id,
                    self.fetched_at,
                    self.provider_checksum,
                )
            ):
                raise ValueError(
                    "local-import custody cannot claim provider download provenance"
                )
        if self.fetched_at is not None and (
            self.fetched_at.tzinfo is None or self.fetched_at.utcoffset() is None
        ):
            raise ValueError("fetched_at must include a UTC offset")
        return self


class AcquisitionManifest(DomainModel):
    """Narrow acquired-byte receipt; it makes no source-ready claim."""

    model_config = ConfigDict(json_schema_extra=_acquisition_manifest_schema_extra)

    schema_id: Literal["codex-scientiae/acquisition/0.1"] = Field(
        default="codex-scientiae/acquisition/0.1",
        alias="schema",
    )
    state: Literal["acquired"] = "acquired"
    slug: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    artifact: ArtifactReference
    forms: tuple[AcquiredArtifact, ...] = Field(min_length=1)

    @field_validator("slug", mode="before")
    @classmethod
    def _portable_slug(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @model_validator(mode="after")
    def _validate_manifest(self) -> Self:
        # Provider canonicalization and Unicode case-folded path comparison are
        # intentionally runtime-only; standard JSON Schema cannot express them.
        canonical = validate_artifact_deposit_reference(
            self.artifact.provider,
            self.slug,
            self.artifact.identifier,
        )
        if canonical != self.artifact.identifier:
            raise ValueError("acquisition identifier is not canonical")
        kinds = [form.kind for form in self.forms]
        paths = [form.path.casefold() for form in self.forms]
        if len(kinds) != len(set(kinds)):
            raise ValueError("an acquisition receipt may contain one form per artifact kind")
        if len(paths) != len(set(paths)):
            raise ValueError("acquisition paths must be portable-case unique")
        return self


class AcquisitionOutcome(DomainModel):
    """Result of acquiring or considering one requested artifact kind."""

    model_config = ConfigDict(json_schema_extra=_acquisition_outcome_schema)

    kind: ArtifactKind
    status: Literal["acquired", "already-present", "unavailable", "error"]
    path: str | None = None
    error: str | None = None

    @model_validator(mode="after")
    def _validate_status(self) -> Self:
        if self.status in {"acquired", "already-present"}:
            if self.path is None or self.error is not None:
                raise ValueError("successful acquisition outcomes require path and no error")
        elif not self.error or self.path is not None:
            raise ValueError("unsuccessful acquisition outcomes require error and no path")
        return self


class AcquisitionResult(DomainModel):
    """One acquisition operation and its current durable receipt."""

    model_config = ConfigDict(json_schema_extra=_acquisition_result_schema)

    staging_directory: str = Field(min_length=1)
    manifest_path: str | None = None
    manifest: AcquisitionManifest | None = None
    outcomes: tuple[AcquisitionOutcome, ...] = Field(min_length=1)

    @model_validator(mode="after")
    def _manifest_pair(self) -> Self:
        if (self.manifest_path is None) != (self.manifest is None):
            raise ValueError("manifest_path and manifest must either both be present or both be absent")
        if self.manifest is None and any(
            outcome.status in {"acquired", "already-present"} for outcome in self.outcomes
        ):
            raise ValueError("successful outcomes require an acquisition manifest")
        return self


def acquisition_manifest_schema() -> dict[str, Any]:
    """Return the public receipt schema with serialized defaults required."""

    return AcquisitionManifest.model_json_schema(mode="serialization", by_alias=True)
