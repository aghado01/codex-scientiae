"""Provider-neutral discovery records and operation envelopes."""

from __future__ import annotations

import base64
import hashlib
from collections.abc import Mapping
from datetime import date, datetime
from typing import Annotated, Any, Literal, Self

from pydantic import (
    AfterValidator,
    BaseModel,
    ConfigDict,
    Field,
    PlainSerializer,
    field_validator,
    model_validator,
)

from procurement.identifiers import (
    artifact_slug,
    arxiv_identity,
    is_doi,
    normalize_arxiv_id,
    normalize_doi,
    split_arxiv_id,
    split_zenodo_id,
)
from procurement.limits import MAX_API_RESPONSE_BASE64_CHARS

_INVALID_PORTABLE_LEAF = frozenset('<>:"/\\|?*')
_WINDOWS_RESERVED_LEAVES = frozenset(
    ("CON", "PRN", "AUX", "NUL")
    + tuple(f"COM{number}" for number in range(1, 10))
    + tuple(f"LPT{number}" for number in range(1, 10))
)
PORTABLE_LEAF_PATTERN = (
    r"^(?!(?:[Cc][Oo][Nn]|[Pp][Rr][Nn]|[Aa][Uu][Xx]|[Nn][Uu][Ll]|"
    r"[Cc][Oo][Mm][1-9]|[Ll][Pp][Tt][1-9])(?:\.|$))(?!\.{1,2}$)"
    r"(?!.*[ .]$)[^<>:\"/\\|?*\u0000-\u001F]+$"
)


def _unique_strings(values: Any) -> tuple[str, ...]:
    if values is None:
        return ()
    if isinstance(values, str):
        values = (values,)
    seen: set[str] = set()
    result: list[str] = []
    for value in values:
        if value is None:
            continue
        text = str(value).strip()
        key = text.casefold()
        if text and key not in seen:
            seen.add(key)
            result.append(text)
    return tuple(result)


def validate_deposit_slug(value: object) -> str:
    """Return one portable deposit-directory leaf or raise ``ValueError``."""

    if not isinstance(value, str):
        raise ValueError("deposit_slug must be a string")
    if not value or value in (".", "..") or value[-1] in (" ", "."):
        raise ValueError("deposit_slug must be one non-empty portable directory leaf")
    if any(ord(char) < 32 or char in _INVALID_PORTABLE_LEAF for char in value):
        raise ValueError("deposit_slug must be one non-empty portable directory leaf")
    if value.split(".", 1)[0].upper() in _WINDOWS_RESERVED_LEAVES:
        raise ValueError("deposit_slug uses a reserved Windows directory name")
    return value


def validate_artifact_deposit_reference(
    provider: str,
    deposit_slug: str,
    identifier: str,
) -> str:
    """Validate and canonicalize one artifact identity before provider I/O."""

    deposit_slug = validate_deposit_slug(deposit_slug)
    key = provider.casefold()
    if key == "arxiv":
        parsed = split_arxiv_id(identifier)
        if parsed.version is None:
            raise ValueError("an arXiv source deposit requires a versioned identifier")
        expected_slug = artifact_slug("arxiv", parsed.versioned)
        if deposit_slug != expected_slug:
            raise ValueError(
                f"arXiv deposit slug {deposit_slug!r} must match artifact leaf {expected_slug!r}"
            )
        return parsed.versioned
    if key == "zenodo":
        parsed = split_zenodo_id(identifier)
        if deposit_slug != parsed.slug:
            raise ValueError(
                f"Zenodo deposit slug {deposit_slug!r} must match artifact {parsed.slug!r}"
            )
        return parsed.record_id
    if key == "scihub":
        if not is_doi(identifier):
            raise ValueError("Sci-Hub artifact metadata fallback requires a complete DOI")
        return normalize_doi(identifier) or ""
    if not isinstance(identifier, str) or not identifier.strip():
        raise ValueError("artifact identifier must not be empty")
    return identifier.strip()


class FrozenStringMapping(Mapping[str, str]):
    """Small immutable, deepcopy-stable string mapping for public values."""

    __slots__ = ("_data",)

    def __init__(self, value: Mapping[str, str]) -> None:
        self._data = dict(value)

    def __getitem__(self, key: str) -> str:
        return self._data[key]

    def __iter__(self):
        return iter(self._data)

    def __len__(self) -> int:
        return len(self._data)

    def __repr__(self) -> str:
        return f"FrozenStringMapping({self._data!r})"

    def __eq__(self, other: object) -> bool:
        return isinstance(other, Mapping) and dict(self.items()) == dict(other.items())

    def __copy__(self) -> "FrozenStringMapping":
        return self

    def __deepcopy__(self, memo: dict[int, object]) -> "FrozenStringMapping":
        return self


def _freeze_string_map(value: Mapping[str, str]) -> Mapping[str, str]:
    if isinstance(value, FrozenStringMapping):
        return value
    return FrozenStringMapping(value)


FrozenStringMap = Annotated[
    Mapping[str, str],
    AfterValidator(_freeze_string_map),
    PlainSerializer(lambda value: dict(value), return_type=dict[str, str]),
]


def _require_serialized_properties(schema: dict[str, Any]) -> None:
    """Describe the complete object emitted by default model serialization."""

    properties = schema.get("properties")
    if isinstance(properties, dict):
        schema["required"] = list(properties)


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
                    }
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
                    }
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


class DomainModel(BaseModel):
    """Immutable, extra-forbidding base for public procurement values."""

    model_config = ConfigDict(
        frozen=True,
        extra="forbid",
        populate_by_name=True,
        serialize_by_alias=True,
        validate_default=True,
        json_schema_serialization_defaults_required=True,
        json_schema_extra=_require_serialized_properties,
    )


class SourceReference(DomainModel):
    """Provider identity and temporal provenance for one record."""

    provider: str = Field(min_length=1)
    identifier: str = Field(min_length=1)
    url: str | None = None
    doi: str | None = None
    arxiv_id: str | None = None
    published: datetime | date | None = None
    updated: datetime | date | None = None

    @field_validator("provider", "identifier", mode="before")
    @classmethod
    def _strip_required(cls, value: object) -> str:
        if not isinstance(value, str):
            raise ValueError("provider and identifier must be strings")
        text = value.strip()
        if not text:
            raise ValueError("provider and identifier must not be blank")
        return text

    @field_validator("doi", mode="before")
    @classmethod
    def _normalize_doi(cls, value: object | None) -> str | None:
        return normalize_doi(value)

    @field_validator("arxiv_id", mode="before")
    @classmethod
    def _normalize_arxiv(cls, value: object | None) -> str | None:
        return normalize_arxiv_id(value)

    @property
    def key(self) -> tuple[str, str]:
        return self.provider.casefold(), self.identifier.casefold()


class WorkRecord(DomainModel):
    """Merged scholarly metadata with explicit provider provenance."""

    title: str | None = None
    authors: tuple[str, ...] = ()
    abstract: str | None = None
    doi: str | None = None
    arxiv_id: str | None = None
    published: datetime | date | None = None
    updated: datetime | date | None = None
    year: int | None = Field(default=None, ge=0)
    venue: str | None = None
    open_access_url: str | None = None
    pdf_url: str | None = None
    citation_count: int | None = Field(default=None, ge=0)
    reference_count: int | None = Field(default=None, ge=0)
    tldr: str | None = None
    concepts: tuple[str, ...] = ()
    categories: tuple[str, ...] = ()
    external_ids: FrozenStringMap = Field(default_factory=dict)
    sources: tuple[SourceReference, ...]

    @field_validator("doi", mode="before")
    @classmethod
    def _normalize_doi(cls, value: object | None) -> str | None:
        return normalize_doi(value)

    @field_validator("arxiv_id", mode="before")
    @classmethod
    def _normalize_arxiv(cls, value: object | None) -> str | None:
        return normalize_arxiv_id(value)

    @field_validator("authors", "concepts", "categories", mode="before")
    @classmethod
    def _deduplicate_lists(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)

    @field_validator("external_ids", mode="before")
    @classmethod
    def _stringify_ids(cls, value: object | None) -> dict[str, str]:
        if not value:
            return {}
        return {
            str(key): str(item)
            for key, item in dict(value).items()
            if item is not None and str(item).strip()
        }

    @model_validator(mode="after")
    def _require_source(self) -> Self:
        if not self.sources:
            raise ValueError("a work record requires at least one source reference")

        dois = {value for value in (self.doi, *(source.doi for source in self.sources)) if value}
        if len(dois) > 1:
            raise ValueError(f"a work record contains conflicting DOI identities: {sorted(dois)}")
        if self.doi is None and dois:
            object.__setattr__(self, "doi", next(iter(dois)))

        arxiv_values = [
            value
            for value in (self.arxiv_id, *(source.arxiv_id for source in self.sources))
            if value
        ]
        arxiv_identities = {arxiv_identity(value) for value in arxiv_values}
        if len(arxiv_identities) > 1:
            raise ValueError(
                "a work record contains conflicting arXiv identities: "
                f"{sorted(arxiv_identities)}"
            )
        if self.arxiv_id is None and arxiv_values:
            selected = max(
                arxiv_values,
                key=lambda value: (
                    split_arxiv_id(value).version is not None,
                    split_arxiv_id(value).version or 0,
                ),
            )
            object.__setattr__(self, "arxiv_id", selected)
        return self

    @property
    def identity_aliases(self) -> frozenset[str]:
        aliases = {
            f"source:{source.provider.casefold()}:{source.identifier.casefold()}"
            for source in self.sources
        }
        aliases.update(f"doi:{source.doi}" for source in self.sources if source.doi)
        aliases.update(
            f"arxiv:{arxiv_identity(source.arxiv_id)}"
            for source in self.sources
            if source.arxiv_id
        )
        if self.doi:
            aliases.add(f"doi:{self.doi}")
        if self.arxiv_id:
            aliases.add(f"arxiv:{arxiv_identity(self.arxiv_id)}")
        return frozenset(aliases)

    @property
    def identity_key(self) -> str:
        if self.doi:
            return f"doi:{self.doi}"
        if self.arxiv_id:
            return f"arxiv:{arxiv_identity(self.arxiv_id)}"
        source = self.sources[0]
        return f"source:{source.provider.casefold()}:{source.identifier.casefold()}"

    def identity_is_compatible_with(self, other: "WorkRecord") -> bool:
        """Return whether two records can share one work without crosswalk conflict."""

        if self.doi and other.doi and self.doi != other.doi:
            return False
        if self.arxiv_id and other.arxiv_id:
            return arxiv_identity(self.arxiv_id) == arxiv_identity(other.arxiv_id)
        return True

    def merge(self, other: "WorkRecord") -> "WorkRecord":
        """Merge two records known to describe the same work."""

        if self.identity_aliases.isdisjoint(other.identity_aliases):
            raise ValueError("cannot merge work records without a shared identity alias")
        if not self.identity_is_compatible_with(other):
            raise ValueError("cannot merge work records with conflicting identity crosswalks")

        def present(first: Any, second: Any) -> Any:
            return first if first not in (None, "") else second

        def richer(first: str | None, second: str | None) -> str | None:
            if not first:
                return second
            if not second:
                return first
            return first if len(first) >= len(second) else second

        source_by_key = {source.key: source for source in self.sources}
        for source in other.sources:
            source_by_key.setdefault(source.key, source)

        external_ids = dict(other.external_ids)
        external_ids.update(self.external_ids)

        return WorkRecord(
            title=present(self.title, other.title),
            authors=self.authors if len(self.authors) >= len(other.authors) else other.authors,
            abstract=richer(self.abstract, other.abstract),
            doi=present(self.doi, other.doi),
            arxiv_id=present(self.arxiv_id, other.arxiv_id),
            published=present(self.published, other.published),
            updated=present(self.updated, other.updated),
            year=present(self.year, other.year),
            venue=present(self.venue, other.venue),
            open_access_url=present(self.open_access_url, other.open_access_url),
            pdf_url=present(self.pdf_url, other.pdf_url),
            citation_count=max(
                (value for value in (self.citation_count, other.citation_count) if value is not None),
                default=None,
            ),
            reference_count=max(
                (value for value in (self.reference_count, other.reference_count) if value is not None),
                default=None,
            ),
            tldr=richer(self.tldr, other.tldr),
            concepts=_unique_strings((*self.concepts, *other.concepts)),
            categories=_unique_strings((*self.categories, *other.categories)),
            external_ids=external_ids,
            sources=tuple(source_by_key.values()),
        )


def merge_works(works: list[WorkRecord] | tuple[WorkRecord, ...]) -> tuple[WorkRecord, ...]:
    """Merge a sequence by every known identity alias in stable first-seen order."""

    result: list[WorkRecord] = []
    for work in works:
        combined = work
        merged_indices: list[int] = []
        changed = True
        while changed:
            changed = False
            for index, existing in enumerate(result):
                if index in merged_indices:
                    continue
                if existing.identity_aliases.isdisjoint(combined.identity_aliases):
                    continue
                if not existing.identity_is_compatible_with(combined):
                    continue
                combined = existing.merge(combined)
                merged_indices.append(index)
                changed = True
        if not merged_indices:
            result.append(work)
            continue
        first = min(merged_indices)
        for index in reversed(sorted(merged_indices)):
            del result[index]
        result.insert(first, combined)
    return tuple(result)


class SearchRequest(DomainModel):
    """Provider-neutral discovery search input."""

    model_config = ConfigDict(json_schema_extra=None)

    query: str = Field(min_length=1)
    start: int = Field(default=0, ge=0)
    limit: int = Field(default=25, ge=1, le=100)
    filters: tuple[str, ...] = ()
    categories: tuple[str, ...] = ()
    date_from: date | None = None
    date_to: date | None = None
    resource_type: str | None = None
    sort: str | None = None

    @field_validator("query", mode="before")
    @classmethod
    def _strip_query(cls, value: object) -> str:
        if not isinstance(value, str):
            raise ValueError("query must be a string")
        text = value.strip()
        if not text:
            raise ValueError("query must not be blank")
        return text

    @field_validator("filters", "categories", mode="before")
    @classmethod
    def _normalize_lists(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)

    @field_validator("resource_type", "sort", mode="before")
    @classmethod
    def _strip_optional_text(cls, value: object | None) -> str | None:
        if value is None:
            return None
        if not isinstance(value, str) or not value.strip():
            raise ValueError("optional search text must be a nonblank string")
        return value.strip()

    @model_validator(mode="after")
    def _date_order(self) -> Self:
        if self.date_from and self.date_to and self.date_from > self.date_to:
            raise ValueError("date_from must not be later than date_to")
        return self


class SearchPage(DomainModel):
    """One provider's bounded discovery page."""

    provider: str
    total_available: int | None = Field(default=None, ge=0)
    start: int = Field(ge=0)
    next_start: int | None = Field(default=None, ge=0)
    works: tuple[WorkRecord, ...] = ()
    returned: int = Field(default=0, ge=0)

    @model_validator(mode="after")
    def _derive_returned(self) -> Self:
        object.__setattr__(self, "returned", len(self.works))
        return self


class ProviderReport(DomainModel):
    """Outcome of one provider participating in a federated operation."""

    provider: str
    status: Literal["ok", "error"]
    total_available: int | None = None
    returned: int = Field(default=0, ge=0)
    next_start: int | None = None
    error: str | None = None


class SearchResponse(DomainModel):
    """Single-provider or federated discovery response."""

    source: str
    providers: tuple[ProviderReport, ...]
    works: tuple[WorkRecord, ...]
    returned: int = Field(default=0, ge=0)

    @model_validator(mode="after")
    def _derive_returned(self) -> Self:
        object.__setattr__(self, "returned", len(self.works))
        return self


class RelatedResponse(DomainModel):
    """Related works returned from one graph provider."""

    provider: str
    kind: Literal["citations", "references", "recommendations"]
    works: tuple[WorkRecord, ...]


class ResolveResponse(DomainModel):
    """Ranked candidate works for a loose reference."""

    provider: str
    reference: str
    works: tuple[WorkRecord, ...]


ProviderRoleName = Literal[
    "artifact-origin",
    "artifact-access",
    "metadata-authority",
    "metadata-aggregator",
]
ProviderCategoryName = Literal[
    "aggregator",
    "repository",
    "access-source",
    "service",
]


class ProviderDescriptor(DomainModel):
    """Declared provider category, roles, operations, and search constraints."""

    name: str = Field(min_length=1)
    category: ProviderCategoryName
    roles: tuple[ProviderRoleName, ...] = Field(json_schema_extra={"uniqueItems": True})
    capabilities: tuple[str, ...] = Field(json_schema_extra={"uniqueItems": True})
    search_constraints: tuple[str, ...] = Field(json_schema_extra={"uniqueItems": True})

    @field_validator("roles", "capabilities", "search_constraints", mode="before")
    @classmethod
    def _deduplicate_declarations(cls, value: object) -> tuple[str, ...]:
        return _unique_strings(value)


class ProviderCatalogResponse(DomainModel):
    """Provider declarations exposed to protocol consumers."""

    providers: tuple[ProviderDescriptor, ...]


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


class WorkIdentityAnchor(DomainModel):
    """Caller-supplied scholarly identity used to select API metadata."""

    kind: Literal["doi"]
    value: str = Field(min_length=1)
    supplied_by: Literal["caller"] = "caller"

    @field_validator("value", mode="before")
    @classmethod
    def _canonicalize_value(cls, value: object) -> str:
        if not is_doi(value):
            raise ValueError("a DOI identity anchor requires a complete DOI")
        return normalize_doi(value) or ""

    @property
    def identity_aliases(self) -> frozenset[str]:
        """Return the canonical work aliases represented by the anchor."""

        return frozenset({f"doi:{self.value}"})


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


def artifact_identity_aliases(provider: str, identifier: str) -> frozenset[str]:
    """Return canonical aliases that can prove an artifact-metadata identity match."""

    key = provider.casefold()
    if key == "arxiv":
        return frozenset({f"arxiv:{arxiv_identity(identifier)}"})
    if key == "zenodo":
        value = split_zenodo_id(identifier)
        return frozenset(
            {
                f"source:zenodo:{value.record_id}",
                f"doi:{value.doi}",
            }
        )
    if key == "scihub":
        doi = normalize_doi(identifier)
        if not is_doi(doi):
            raise ValueError("Sci-Hub artifact identity requires a DOI")
        return frozenset({f"doi:{doi}"})
    return frozenset({f"source:{key}:{identifier.casefold()}"})


def project_article_metadata(
    artifact_provider: str,
    artifact_identifier: str,
    work: WorkRecord,
    *,
    preserve_categories: bool,
) -> ArticleMetadataProjection:
    """Project one identity-checked work into deterministic article metadata."""

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
    """Project metadata selected by a work identifier rather than artifact provenance."""

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
                    raise ValueError("aggregator fallback requires a failed authority-first attempt")

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
