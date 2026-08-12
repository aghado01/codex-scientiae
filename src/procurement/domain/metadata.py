"""Metadata evidence, projection, and deposit bundle contracts."""

from __future__ import annotations

import base64
import hashlib
from datetime import date, datetime
from typing import Any, Literal, Self

from pydantic import ConfigDict, Field, field_validator, model_validator

from procurement.domain.base import (
    DomainModel,
    FrozenStringMap,
    _require_serialized_properties,
    _unique_strings,
)
from procurement.domain.deposits import (
    PORTABLE_LEAF_PATTERN,
    validate_artifact_deposit_reference,
    validate_deposit_slug,
)
from procurement.domain.providers import ProviderRoleName
from procurement.domain.works import (
    WorkIdentityAnchor,
    WorkRecord,
    artifact_identity_aliases,
)
from procurement.identifiers import is_doi, normalize_doi, split_arxiv_id
from procurement.limits import MAX_API_RESPONSE_BASE64_CHARS


def _deposit_bundle_schema(schema: dict[str, Any]) -> None:
    _require_serialized_properties(schema)
    schema["required"] = [
        name for name in schema.get("required", ()) if name != "identity_anchor"
    ]
    schema["$id"] = "codex-scientiae/deposit-metadata/0.1"
    schema["allOf"] = [
        {
            "if": {"properties": {"route": {"const": "artifact-provider"}}},
            "then": {
                "properties": {
                    "identity_anchor": {"type": "null"},
                    "selected": {
                        "properties": {
                            "provider_roles": {
                                "contains": {"const": "metadata-authority"}
                            }
                        }
                    },
                }
            },
        },
        {
            "if": {"properties": {"route": {"const": "aggregator-fallback"}}},
            "then": {
                "properties": {
                    "identity_anchor": {"type": "null"},
                    "selected": {
                        "properties": {
                            "provider_roles": {
                                "contains": {"const": "metadata-aggregator"}
                            }
                        }
                    },
                }
            },
        },
        {
            "if": {"properties": {"route": {"const": "identifier-aggregator"}}},
            "then": {
                "required": ["identity_anchor"],
                "properties": {
                    "identity_anchor": {"not": {"type": "null"}},
                    "selected": {
                        "properties": {
                            "provider_roles": {
                                "contains": {"const": "metadata-aggregator"}
                            }
                        }
                    },
                },
            },
        },
    ]


def _metadata_attempt_schema(schema: dict[str, Any]) -> None:
    _require_serialized_properties(schema)
    schema["allOf"] = [
        {
            "if": {"properties": {"status": {"const": "ok"}}},
            "then": {"properties": {"error": {"type": "null"}}},
            "else": {
                "properties": {"error": {"type": "string", "minLength": 1}}
            },
        }
    ]


class ArtifactReference(DomainModel):
    """Identity of the provider that supplied the deposited artifact."""

    provider: str = Field(min_length=1)
    identifier: str = Field(min_length=1)
    provider_roles: tuple[ProviderRoleName, ...] = Field(
        json_schema_extra={
            "contains": {"const": "artifact-access"},
            "uniqueItems": True,
        }
    )

    @field_validator("provider_roles", mode="before")
    @classmethod
    def _deduplicate_roles(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)

    @model_validator(mode="after")
    def _require_access_role(self) -> Self:
        if "artifact-access" not in self.provider_roles:
            raise ValueError("an artifact reference requires the artifact-access role")
        return self


class ApiResponseEvidence(DomainModel):
    """Exact HTTP-decoded API payload used for one metadata observation."""

    url: str = Field(min_length=1)
    media_type: str = Field(min_length=1)
    fetched_at: datetime
    sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    body_base64: str = Field(
        min_length=1,
        max_length=MAX_API_RESPONSE_BASE64_CHARS,
        pattern=r"^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$",
    )

    @model_validator(mode="after")
    def _validate_body_digest(self) -> Self:
        if self.fetched_at.tzinfo is None or self.fetched_at.utcoffset() is None:
            raise ValueError("fetched_at must include a UTC offset")
        try:
            body = base64.b64decode(self.body_base64, validate=True)
        except (ValueError, TypeError) as exc:
            raise ValueError("body_base64 must be canonical base64") from exc
        if base64.b64encode(body).decode("ascii") != self.body_base64:
            raise ValueError("body_base64 must use canonical padding")
        if hashlib.sha256(body).hexdigest() != self.sha256:
            raise ValueError("API response body does not match sha256")
        return self


class RetrievedMetadata(DomainModel):
    """Provider result before composition adds declared provider roles."""

    work: WorkRecord
    response: ApiResponseEvidence


class MetadataObservation(DomainModel):
    """Normalized metadata plus the exact decoded provider payload it consumed."""

    provider: str = Field(min_length=1)
    provider_roles: tuple[ProviderRoleName, ...] = Field(
        json_schema_extra={"uniqueItems": True}
    )
    work: WorkRecord
    response: ApiResponseEvidence

    @field_validator("provider_roles", mode="before")
    @classmethod
    def _deduplicate_roles(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)


class MetadataAttempt(DomainModel):
    """One provider considered by metadata fallback policy."""

    model_config = ConfigDict(json_schema_extra=_metadata_attempt_schema)

    provider: str = Field(min_length=1)
    status: Literal["ok", "error", "not-supported"]
    error: str | None = None

    @model_validator(mode="after")
    def _validate_error(self) -> Self:
        if self.status == "ok" and self.error is not None:
            raise ValueError("a successful metadata attempt cannot carry an error")
        if self.status != "ok" and not self.error:
            raise ValueError("an unsuccessful metadata attempt requires an error")
        return self


class ArticleIdentifiers(DomainModel):
    """Identifier projection consumed by the article deposit boundary."""

    arxiv: str | None = None
    arxiv_versioned: str | None = None
    doi: str | None = None
    external: FrozenStringMap = Field(default_factory=dict)


class ArticleMetadataProjection(DomainModel):
    """Provider-neutral bibliographic fields projected into article.json."""

    title: str | None = None
    authors: tuple[str, ...] = ()
    abstract: str | None = None
    identifiers: ArticleIdentifiers
    categories: tuple[str, ...] = ()
    concepts: tuple[str, ...] = ()
    primary_category: str | None = None
    published: datetime | date | None = None
    updated: datetime | date | None = None


def project_article_metadata(
    artifact_provider: str,
    artifact_identifier: str,
    work: WorkRecord,
    *,
    preserve_categories: bool,
) -> ArticleMetadataProjection:
    """Project an identity-checked work into article metadata."""

    arxiv_id = work.arxiv_id
    arxiv_versioned = work.arxiv_id
    if artifact_provider.casefold() == "arxiv":
        parsed = split_arxiv_id(artifact_identifier)
        arxiv_id = parsed.versionless
        arxiv_versioned = parsed.versioned
    elif arxiv_id:
        parsed = split_arxiv_id(arxiv_id)
        arxiv_id = parsed.versionless
        arxiv_versioned = parsed.versioned if parsed.version is not None else None

    return _project_article_metadata(
        work,
        arxiv_id=arxiv_id,
        arxiv_versioned=arxiv_versioned,
        preserve_categories=preserve_categories,
    )


def project_identifier_article_metadata(work: WorkRecord) -> ArticleMetadataProjection:
    """Project metadata selected by a work identifier."""

    arxiv_id = work.arxiv_id
    arxiv_versioned = work.arxiv_id
    if arxiv_id:
        parsed = split_arxiv_id(arxiv_id)
        arxiv_id = parsed.versionless
        arxiv_versioned = parsed.versioned if parsed.version is not None else None
    return _project_article_metadata(
        work,
        arxiv_id=arxiv_id,
        arxiv_versioned=arxiv_versioned,
        preserve_categories=False,
    )


def _project_article_metadata(
    work: WorkRecord,
    *,
    arxiv_id: str | None,
    arxiv_versioned: str | None,
    preserve_categories: bool,
) -> ArticleMetadataProjection:
    categories = work.categories if preserve_categories else ()
    return ArticleMetadataProjection(
        title=work.title,
        authors=work.authors,
        abstract=work.abstract,
        identifiers=ArticleIdentifiers(
            arxiv=arxiv_id,
            arxiv_versioned=arxiv_versioned,
            doi=work.doi,
            external=work.external_ids,
        ),
        categories=categories,
        concepts=work.concepts,
        primary_category=categories[0] if categories else None,
        published=work.published,
        updated=work.updated,
    )


class DepositMetadataBundle(DomainModel):
    """Self-contained API metadata evidence for one source deposit."""

    model_config = ConfigDict(json_schema_extra=_deposit_bundle_schema)

    schema_id: Literal["codex-scientiae/deposit-metadata/0.1"] = Field(
        default="codex-scientiae/deposit-metadata/0.1",
        alias="schema",
    )
    deposit_slug: str = Field(
        min_length=1,
        pattern=r'^[^<>:"/\\|?*\x00-\x1f]+$',
        json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN},
    )
    artifact: ArtifactReference
    identity_anchor: WorkIdentityAnchor | None = None
    route: Literal[
        "artifact-provider",
        "aggregator-fallback",
        "identifier-aggregator",
    ]
    selected: MetadataObservation
    attempts: tuple[MetadataAttempt, ...] = Field(
        min_length=1,
        json_schema_extra={"uniqueItems": True},
    )
    article: ArticleMetadataProjection

    @field_validator("deposit_slug", mode="before")
    @classmethod
    def _validate_deposit_slug(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @model_validator(mode="after")
    def _validate_resolution(self) -> Self:
        if not self.attempts:
            raise ValueError("a deposit metadata bundle requires at least one attempt")
        providers = [attempt.provider.casefold() for attempt in self.attempts]
        if len(providers) != len(set(providers)):
            raise ValueError("metadata attempts must name distinct providers")
        successful = [attempt for attempt in self.attempts if attempt.status == "ok"]
        if len(successful) != 1 or (
            successful[0].provider.casefold() != self.selected.provider.casefold()
        ):
            raise ValueError("exactly one successful attempt must name the selected provider")
        identifier_route = self.route == "identifier-aggregator"
        if not identifier_route and (
            self.attempts[0].provider.casefold() != self.artifact.provider.casefold()
        ):
            raise ValueError("metadata attempts must begin with the artifact provider")
        if self.attempts[-1].status != "ok" or (
            self.attempts[-1].provider.casefold() != self.selected.provider.casefold()
        ):
            raise ValueError("the selected provider must be the final successful attempt")

        if identifier_route:
            if self.identity_anchor is None:
                raise ValueError("an identifier route requires an identity anchor")
            if "metadata-aggregator" not in self.selected.provider_roles:
                raise ValueError("identifier-aggregator route requires a metadata aggregator")
        else:
            if self.identity_anchor is not None:
                raise ValueError("artifact metadata routes cannot carry an identity anchor")
            same_provider = (
                self.selected.provider.casefold() == self.artifact.provider.casefold()
            )
            if self.route == "artifact-provider":
                if not same_provider:
                    raise ValueError("artifact-provider route must select the artifact provider")
                if "metadata-authority" not in self.selected.provider_roles:
                    raise ValueError("artifact-provider route requires a metadata authority")
                if len(self.attempts) != 1:
                    raise ValueError("artifact-provider route must stop after authority success")
            else:
                if same_provider:
                    raise ValueError("aggregator fallback must select a different provider")
                if "metadata-aggregator" not in self.selected.provider_roles:
                    raise ValueError("aggregator fallback requires a metadata aggregator")
                if self.attempts[0].status == "ok":
                    raise ValueError(
                        "aggregator fallback requires a failed authority-first attempt"
                    )

        canonical_identifier = validate_artifact_deposit_reference(
            self.artifact.provider,
            self.deposit_slug,
            self.artifact.identifier,
        )
        if canonical_identifier != self.artifact.identifier:
            raise ValueError("artifact identifier is not in canonical provider form")

        expected_aliases = (
            self.identity_anchor.identity_aliases
            if self.identity_anchor is not None
            else artifact_identity_aliases(
                self.artifact.provider,
                self.artifact.identifier,
            )
        )
        if expected_aliases.isdisjoint(self.selected.work.identity_aliases):
            subject = "identity anchor" if identifier_route else "referenced artifact"
            raise ValueError(f"selected metadata does not identify the {subject}")
        if self.route == "artifact-provider" and self.artifact.provider.casefold() == "arxiv":
            returned = self.selected.work.arxiv_id
            if returned is None or (
                split_arxiv_id(returned).versioned.casefold()
                != split_arxiv_id(self.artifact.identifier).versioned.casefold()
            ):
                raise ValueError("arXiv authority metadata does not identify the artifact version")

        expected_article = (
            project_identifier_article_metadata(self.selected.work)
            if identifier_route
            else project_article_metadata(
                self.artifact.provider,
                self.artifact.identifier,
                self.selected.work,
                preserve_categories=(
                    self.route == "artifact-provider"
                    and self.artifact.provider.casefold() == "arxiv"
                ),
            )
        )
        if self.article != expected_article:
            raise ValueError("article projection does not match the selected metadata")
        return self


__all__ = [
    "ApiResponseEvidence",
    "ArticleIdentifiers",
    "ArticleMetadataProjection",
    "ArtifactReference",
    "DepositMetadataBundle",
    "MetadataAttempt",
    "MetadataObservation",
    "RetrievedMetadata",
    "project_article_metadata",
    "project_identifier_article_metadata",
]
