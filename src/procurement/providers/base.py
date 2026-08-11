"""Capability-specific provider ports."""

from __future__ import annotations

from enum import StrEnum
from typing import Literal, Protocol

from procurement.models import SearchPage, SearchRequest, WorkRecord

RelatedKind = Literal["citations", "references", "recommendations"]


class Capability(StrEnum):
    """Operations that a provider may implement."""

    SEARCH = "search"
    GET_WORK = "get_work"
    CITATIONS = "citations"
    REFERENCES = "references"
    RECOMMENDATIONS = "recommendations"
    RESOLVE = "resolve"


class SearchProvider(Protocol):
    name: str

    async def search(self, request: SearchRequest) -> SearchPage: ...


class WorkProvider(Protocol):
    name: str

    async def get_work(self, identifier: str) -> WorkRecord: ...


class RelatedProvider(Protocol):
    name: str

    async def related(self, identifier: str, kind: RelatedKind, limit: int) -> tuple[WorkRecord, ...]: ...


class ResolveProvider(Protocol):
    name: str

    async def resolve(self, reference: str) -> tuple[WorkRecord, ...]: ...
