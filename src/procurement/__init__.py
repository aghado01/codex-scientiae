"""Scholarly discovery and acquisition capabilities."""

from procurement.domain.discovery import (
    ProviderReport,
    RelatedResponse,
    ResolveResponse,
    SearchPage,
    SearchRequest,
    SearchResponse,
)
from procurement.domain.acquisition.planning import (
    ArtifactAcquisitionRequest,
    ArtifactPlanSummary,
)
from procurement.domain.acquisition.receipts import AcquisitionManifest, AcquisitionResult
from procurement.domain.metadata import ApiResponseEvidence, DepositMetadataBundle
from procurement.domain.providers import ProviderCatalogResponse, ProviderDescriptor
from procurement.domain.works import (
    SourceReference,
    WorkIdentityAnchor,
    WorkRecord,
    merge_works,
)
from procurement.domain.materialization import (
    ArtifactIdentityMetadata,
    ExplicitDoiMetadata,
    OmitArticleMetadata,
    SourceMaterializationRequest,
    SourceMaterializationResult,
)

__all__ = [
    "ApiResponseEvidence",
    "AcquisitionManifest",
    "AcquisitionResult",
    "ArtifactAcquisitionRequest",
    "ArtifactPlanSummary",
    "ArtifactIdentityMetadata",
    "DepositMetadataBundle",
    "ExplicitDoiMetadata",
    "OmitArticleMetadata",
    "ProviderCatalogResponse",
    "ProviderDescriptor",
    "ProviderReport",
    "RelatedResponse",
    "ResolveResponse",
    "SearchPage",
    "SearchRequest",
    "SearchResponse",
    "SourceMaterializationRequest",
    "SourceMaterializationResult",
    "SourceReference",
    "WorkIdentityAnchor",
    "WorkRecord",
    "merge_works",
]
