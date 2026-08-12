"""Projection of procurement metadata evidence into the article manifest contract."""

from __future__ import annotations

import copy
import hashlib
from functools import lru_cache
from typing import Any

from jsonl_engine.deposit import DepositResult, deposit_article
from jsonl_engine.kinds.article import ArticleMetadataContribution, ArticleMetadataExtension

from procurement.limits import MAX_DEPOSIT_METADATA_BUNDLE_BYTES
from procurement.domain.metadata import DepositMetadataBundle
from procurement.storage.schemas import ProcurementSchemaCatalog, get_procurement_schema_catalog

_DEPOSIT_METADATA_SCHEMA = "deposit.metadata.schema.json"


class ProcurementArticleMetadataExtension(ArticleMetadataExtension):
    """Validate a procurement evidence bundle and project article metadata from it."""

    def __init__(self, schemas: ProcurementSchemaCatalog | None = None) -> None:
        self._schemas = schemas or get_procurement_schema_catalog()

    @property
    def maximum_bytes(self) -> int:
        return MAX_DEPOSIT_METADATA_BUNDLE_BYTES

    def project(
        self,
        value: dict[str, Any],
        *,
        raw: bytes,
        path: str,
        slug: str,
    ) -> ArticleMetadataContribution:
        self._schemas.get_validator(_DEPOSIT_METADATA_SCHEMA).validate(value)
        bundle = DepositMetadataBundle.model_validate(value)
        if bundle.deposit_slug != slug:
            raise ValueError(
                f"API metadata bundle slug {bundle.deposit_slug!r} does not match deposit slug {slug!r}"
            )

        wire = bundle.model_dump(mode="json", by_alias=True)
        selected = wire["selected"]
        response = selected["response"]
        artifact = wire["artifact"]
        evidence = {
            "role": "api-metadata-bundle",
            "path": path,
            "format": "application/vnd.codex-scientiae.deposit-metadata+json",
            "bytes": len(raw),
            "sha256": hashlib.sha256(raw).hexdigest(),
            "provider": selected["provider"],
            "provider_roles": copy.deepcopy(selected["provider_roles"]),
            "artifact_provider": artifact["provider"],
            "artifact_provider_roles": copy.deepcopy(artifact["provider_roles"]),
            "route": wire["route"],
            "fetched_at": response["fetched_at"],
            "response_url": response["url"],
            "response_format": response["media_type"],
            "response_sha256": response["sha256"],
        }
        resolution = {
            "route": wire["route"],
            "artifact": copy.deepcopy(artifact),
            "selected_provider": selected["provider"],
            "selected_provider_roles": copy.deepcopy(selected["provider_roles"]),
            "attempts": copy.deepcopy(wire["attempts"]),
        }
        if wire.get("identity_anchor") is not None:
            resolution["identity_anchor"] = copy.deepcopy(wire["identity_anchor"])
        return ArticleMetadataContribution(
            article=copy.deepcopy(wire["article"]),
            evidence=evidence,
            resolution=resolution,
        )


@lru_cache(maxsize=1)
def get_procurement_article_metadata_extension() -> ProcurementArticleMetadataExtension:
    """Return the process-wide procurement article metadata extension."""

    return ProcurementArticleMetadataExtension()


def deposit_procurement_article(**kwargs: Any) -> DepositResult:
    """Publish an article with the procurement metadata extension installed."""

    if "metadata_extension" in kwargs:
        raise TypeError("metadata_extension is owned by deposit_procurement_article")
    if kwargs.get("metadata_json") is not None:
        kwargs["metadata_extension"] = get_procurement_article_metadata_extension()
    return deposit_article(**kwargs)


__all__ = [
    "ProcurementArticleMetadataExtension",
    "deposit_procurement_article",
    "get_procurement_article_metadata_extension",
]
