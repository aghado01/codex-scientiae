"""Capability-specific provider ports."""

from __future__ import annotations

import base64
import hashlib
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
