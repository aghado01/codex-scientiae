"""Procurement domain contracts."""

from procurement.domain.materialization import (
    ArtifactIdentityMetadata,
    ExplicitDoiMetadata,
    MetadataMode,
    OmitArticleMetadata,
    SourceMaterializationRequest,
    SourceMaterializationResult,
    SourceMetadataInput,
)

__all__ = [
    "ArtifactIdentityMetadata",
    "ExplicitDoiMetadata",
    "MetadataMode",
    "OmitArticleMetadata",
    "SourceMaterializationRequest",
    "SourceMaterializationResult",
    "SourceMetadataInput",
]
