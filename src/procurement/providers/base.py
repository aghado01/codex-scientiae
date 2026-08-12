"""Capability-specific provider ports."""

from __future__ import annotations

import base64
import hashlib
from dataclasses import dataclass
from enum import StrEnum
from typing import Literal, Protocol

from procurement.http import HttpDocument
from procurement.models import (
    ApiResponseEvidence,
    RetrievedMetadata,
    SearchPage,
    SearchRequest,
    WorkRecord,
)
from procurement.payloads import ArtifactAcquisitionRequest, ArtifactPlan

RelatedKind = Literal["citations", "references", "recommendations"]
SEARCH_CONSTRAINT_FIELDS = (
    "filters",
    "categories",
    "date_from",
    "date_to",
    "resource_type",
    "sort",
)
SEARCH_CONSTRAINTS = frozenset(SEARCH_CONSTRAINT_FIELDS)


def retrieved_metadata(work: WorkRecord, document: HttpDocument) -> RetrievedMetadata:
    """Bind a normalized work to the exact decoded payload used to produce it."""

    body = document.body
    return RetrievedMetadata(
        work=work,
        response=ApiResponseEvidence(
            url=document.url,
            media_type=document.media_type,
            fetched_at=document.fetched_at,
            sha256=hashlib.sha256(body).hexdigest(),
            body_base64=base64.b64encode(body).decode("ascii"),
        ),
    )


class Capability(StrEnum):
    """Operations that a provider may implement."""

    SEARCH = "search"
    GET_WORK = "get_work"
    CITATIONS = "citations"
    REFERENCES = "references"
    RECOMMENDATIONS = "recommendations"
    RESOLVE = "resolve"
    METADATA = "metadata"
    PLAN_ARTIFACT = "plan_artifact"


class ProviderRole(StrEnum):
    """Non-exclusive roles a procurement provider may occupy."""

    ARTIFACT_ORIGIN = "artifact-origin"
    ARTIFACT_ACCESS = "artifact-access"
    METADATA_AUTHORITY = "metadata-authority"
    METADATA_AGGREGATOR = "metadata-aggregator"


class ProviderCategory(StrEnum):
    """Primary provider classification used for catalog presentation."""

    AGGREGATOR = "aggregator"
    REPOSITORY = "repository"
    ACCESS_SOURCE = "access-source"
    SERVICE = "service"


@dataclass(frozen=True, slots=True)
class ProviderDefinition:
    """Immutable identity, role, capability, and search declaration for one adapter."""

    name: str
    category: ProviderCategory
    capabilities: frozenset[Capability]
    roles: frozenset[ProviderRole] = frozenset()
    search_constraints: frozenset[str] = frozenset()

    def __post_init__(self) -> None:
        name = self.name.strip() if isinstance(self.name, str) else ""
        if not name or name != name.casefold():
            raise ValueError("provider names must be non-empty canonical lowercase strings")
        object.__setattr__(self, "name", name)
        try:
            category = ProviderCategory(self.category)
            capabilities = frozenset(Capability(item) for item in self.capabilities)
            roles = frozenset(ProviderRole(item) for item in self.roles)
        except (TypeError, ValueError) as exc:
            raise ValueError(f"provider {name!r} has an invalid declaration") from exc
        constraints = frozenset(self.search_constraints)
        if not all(isinstance(item, str) and item for item in constraints):
            raise ValueError(f"provider {name!r} has an invalid search constraint")
        unknown = constraints.difference(SEARCH_CONSTRAINTS)
        if unknown:
            raise ValueError(
                f"provider {name!r} declares unknown constraints: {sorted(unknown)}"
            )
        if constraints and Capability.SEARCH not in capabilities:
            raise ValueError(
                f"provider {name!r} declares search constraints without search capability"
            )
        required_roles = {
            ProviderCategory.AGGREGATOR: frozenset({ProviderRole.METADATA_AGGREGATOR}),
            ProviderCategory.REPOSITORY: frozenset(
                {
                    ProviderRole.ARTIFACT_ORIGIN,
                    ProviderRole.ARTIFACT_ACCESS,
                    ProviderRole.METADATA_AUTHORITY,
                }
            ),
            ProviderCategory.ACCESS_SOURCE: frozenset({ProviderRole.ARTIFACT_ACCESS}),
            ProviderCategory.SERVICE: frozenset(),
        }[category]
        if not required_roles.issubset(roles):
            missing = ", ".join(sorted(role.value for role in required_roles.difference(roles)))
            raise ValueError(
                f"provider {name!r} category {category.value!r} requires roles: {missing}"
            )
        incompatible_roles = {
            ProviderCategory.AGGREGATOR: frozenset(
                {ProviderRole.ARTIFACT_ORIGIN, ProviderRole.METADATA_AUTHORITY}
            ),
            ProviderCategory.REPOSITORY: frozenset({ProviderRole.METADATA_AGGREGATOR}),
            ProviderCategory.ACCESS_SOURCE: frozenset(
                {
                    ProviderRole.ARTIFACT_ORIGIN,
                    ProviderRole.METADATA_AUTHORITY,
                    ProviderRole.METADATA_AGGREGATOR,
                }
            ),
            ProviderCategory.SERVICE: frozenset(ProviderRole),
        }[category].intersection(roles)
        if incompatible_roles:
            conflicts = ", ".join(sorted(role.value for role in incompatible_roles))
            raise ValueError(
                f"provider {name!r} category {category.value!r} conflicts with roles: {conflicts}"
            )
        object.__setattr__(self, "category", category)
        object.__setattr__(self, "capabilities", capabilities)
        object.__setattr__(self, "roles", roles)
        object.__setattr__(self, "search_constraints", constraints)


class SearchProvider(Protocol):
    name: str
    search_constraints: frozenset[str]

    async def search(self, request: SearchRequest) -> SearchPage: ...


class WorkProvider(Protocol):
    name: str

    async def get_work(self, identifier: str) -> WorkRecord: ...


class MetadataProvider(Protocol):
    name: str

    async def get_metadata(self, identifier: str) -> RetrievedMetadata: ...


class RelatedProvider(Protocol):
    name: str

    async def related(self, identifier: str, kind: RelatedKind, limit: int) -> tuple[WorkRecord, ...]: ...


class ResolveProvider(Protocol):
    name: str

    async def resolve(self, reference: str) -> tuple[WorkRecord, ...]: ...


class ArtifactPlanningProvider(Protocol):
    name: str

    async def plan_artifact(self, request: ArtifactAcquisitionRequest) -> ArtifactPlan: ...
