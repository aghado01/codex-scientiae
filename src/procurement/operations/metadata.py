"""API metadata selection and source-deposit projection."""

from __future__ import annotations

import asyncio
from typing import cast

from procurement.domain.deposits import (
    validate_artifact_deposit_reference,
    validate_deposit_slug,
)
from procurement.domain.metadata import (
    ArtifactReference,
    DepositMetadataBundle,
    MetadataAttempt,
    MetadataObservation,
    project_article_metadata,
    project_identifier_article_metadata,
)
from procurement.domain.works import WorkIdentityAnchor, artifact_identity_aliases
from procurement.errors import (
    MetadataError,
    MetadataIdentityError,
    MetadataUnavailableError,
    ProviderError,
)
from procurement.identifiers import is_doi, normalize_doi, split_arxiv_id, split_zenodo_id
from procurement.providers.base import Capability, MetadataProvider, ProviderRole
from procurement.providers.catalog import ProviderBinding, ProviderCatalog


class MetadataService:
    """Collect exact decoded API evidence and project it for an article deposit."""

    def __init__(self, catalog: ProviderCatalog, fallback_sources: tuple[str, ...]) -> None:
        if not fallback_sources:
            raise ValueError("at least one metadata fallback source is required")
        self._catalog = catalog
        self._fallback_sources = fallback_sources

    async def collect(
        self,
        *,
        deposit_slug: str,
        artifact_provider: str,
        identifier: str,
        fallback_sources: tuple[str, ...] | None = None,
    ) -> DepositMetadataBundle:
        """Select authoritative metadata or an identity-checked aggregator fallback."""

        deposit_slug = validate_deposit_slug(deposit_slug)
        artifact_binding = self._catalog.binding(artifact_provider)
        if ProviderRole.ARTIFACT_ACCESS not in artifact_binding.roles:
            raise ValueError(f"provider {artifact_provider!r} is not an artifact-access provider")
        identifier = validate_artifact_deposit_reference(
            artifact_binding.name,
            deposit_slug,
            identifier,
        )

        fallbacks = self._fallback_sources if fallback_sources is None else fallback_sources
        candidates = [artifact_binding]
        seen = {artifact_binding.name.casefold()}
        for name in fallbacks:
            binding = self._catalog.binding(name)
            if ProviderRole.METADATA_AGGREGATOR not in binding.roles:
                raise ValueError(f"fallback provider {name!r} is not a metadata aggregator")
            if binding.name.casefold() not in seen:
                candidates.append(binding)
                seen.add(binding.name.casefold())

        attempts: list[MetadataAttempt] = []
        selected: MetadataObservation | None = None
        for binding in candidates:
            if (
                binding.name.casefold() == artifact_binding.name.casefold()
                and ProviderRole.METADATA_AUTHORITY not in binding.roles
            ):
                attempts.append(
                    MetadataAttempt(
                        provider=binding.name,
                        status="not-supported",
                        error="artifact-access provider is not a metadata authority",
                    )
                )
                continue
            if Capability.METADATA not in binding.capabilities:
                attempts.append(
                    MetadataAttempt(
                        provider=binding.name,
                        status="not-supported",
                        error="provider does not expose metadata",
                    )
                )
                continue
            provider = cast(MetadataProvider, binding.provider)
            lookup = self._lookup_reference(
                artifact_binding,
                identifier,
                metadata_provider=binding.name,
            )
            if lookup is None:
                attempts.append(
                    MetadataAttempt(
                        provider=binding.name,
                        status="not-supported",
                        error="provider has no singleton lookup for this artifact identifier",
                    )
                )
                continue
            try:
                retrieved = await provider.get_metadata(lookup)
                self._assert_identity(artifact_binding, identifier, retrieved.work.identity_aliases)
                self._assert_authority_version(
                    artifact_binding,
                    binding,
                    identifier,
                    retrieved.work.arxiv_id,
                )
            except asyncio.CancelledError:
                raise
            except (MetadataError, ProviderError, ValueError) as exc:
                attempts.append(
                    MetadataAttempt(
                        provider=binding.name,
                        status="error",
                        error=str(exc) or type(exc).__name__,
                    )
                )
                continue
            attempts.append(MetadataAttempt(provider=binding.name, status="ok"))
            selected = MetadataObservation(
                provider=binding.name,
                provider_roles=tuple(sorted(role.value for role in binding.roles)),
                work=retrieved.work,
                response=retrieved.response,
            )
            break

        if selected is None:
            detail = "; ".join(f"{item.provider}: {item.error}" for item in attempts)
            raise MetadataUnavailableError(f"no metadata provider satisfied the artifact: {detail}")

        route = (
            "artifact-provider"
            if selected.provider.casefold() == artifact_binding.name.casefold()
            and ProviderRole.METADATA_AUTHORITY in artifact_binding.roles
            else "aggregator-fallback"
        )
        artifact = ArtifactReference(
            provider=artifact_binding.name,
            identifier=identifier,
            provider_roles=tuple(sorted(role.value for role in artifact_binding.roles)),
        )
        return DepositMetadataBundle(
            deposit_slug=deposit_slug,
            artifact=artifact,
            route=route,
            selected=selected,
            attempts=tuple(attempts),
            article=project_article_metadata(
                artifact_binding.name,
                identifier,
                selected.work,
                preserve_categories=(
                    route == "artifact-provider"
                    and artifact_binding.name.casefold() == "arxiv"
                ),
            ),
        )

    async def collect_by_doi(
        self,
        *,
        deposit_slug: str,
        artifact: ArtifactReference,
        doi: str,
        fallback_sources: tuple[str, ...] | None = None,
    ) -> DepositMetadataBundle:
        """Select aggregator metadata by an explicit DOI independently of artifact provenance."""

        deposit_slug = validate_deposit_slug(deposit_slug)
        if not is_doi(doi):
            raise ValueError("a DOI metadata route requires a complete DOI")
        anchor = WorkIdentityAnchor(kind="doi", value=doi)

        canonical_identifier = validate_artifact_deposit_reference(
            artifact.provider,
            deposit_slug,
            artifact.identifier,
        )
        if canonical_identifier != artifact.identifier:
            artifact = ArtifactReference(
                provider=artifact.provider,
                identifier=canonical_identifier,
                provider_roles=artifact.provider_roles,
            )

        fallbacks = self._fallback_sources if fallback_sources is None else fallback_sources
        candidates = self._aggregator_bindings(fallbacks)
        if not candidates:
            raise MetadataUnavailableError(
                f"no metadata aggregator was selected for DOI {anchor.value!r}"
            )

        attempts: list[MetadataAttempt] = []
        selected: MetadataObservation | None = None
        lookup = f"doi:{anchor.value}"
        for binding in candidates:
            if Capability.METADATA not in binding.capabilities:
                attempts.append(
                    MetadataAttempt(
                        provider=binding.name,
                        status="not-supported",
                        error="provider does not expose metadata",
                    )
                )
                continue
            provider = cast(MetadataProvider, binding.provider)
            try:
                retrieved = await provider.get_metadata(lookup)
                if anchor.identity_aliases.isdisjoint(retrieved.work.identity_aliases):
                    raise MetadataIdentityError(
                        f"metadata identities {sorted(retrieved.work.identity_aliases)} "
                        f"do not match DOI identity {anchor.value!r}"
                    )
            except asyncio.CancelledError:
                raise
            except (MetadataError, ProviderError, ValueError) as exc:
                attempts.append(
                    MetadataAttempt(
                        provider=binding.name,
                        status="error",
                        error=str(exc) or type(exc).__name__,
                    )
                )
                continue
            attempts.append(MetadataAttempt(provider=binding.name, status="ok"))
            selected = MetadataObservation(
                provider=binding.name,
                provider_roles=tuple(sorted(role.value for role in binding.roles)),
                work=retrieved.work,
                response=retrieved.response,
            )
            break

        if selected is None:
            detail = "; ".join(f"{item.provider}: {item.error}" for item in attempts)
            raise MetadataUnavailableError(
                f"no metadata aggregator satisfied DOI {anchor.value!r}: {detail}"
            )

        return DepositMetadataBundle(
            deposit_slug=deposit_slug,
            artifact=artifact,
            identity_anchor=anchor,
            route="identifier-aggregator",
            selected=selected,
            attempts=tuple(attempts),
            article=project_identifier_article_metadata(selected.work),
        )

    def _aggregator_bindings(
        self,
        names: tuple[str, ...],
    ) -> tuple[ProviderBinding, ...]:
        """Resolve distinct declared metadata aggregators in caller order."""

        selected: list[ProviderBinding] = []
        seen: set[str] = set()
        for name in names:
            binding = self._catalog.binding(name)
            if ProviderRole.METADATA_AGGREGATOR not in binding.roles:
                raise ValueError(f"fallback provider {name!r} is not a metadata aggregator")
            key = binding.name.casefold()
            if key not in seen:
                selected.append(binding)
                seen.add(key)
        return tuple(selected)

    @staticmethod
    def _lookup_reference(
        artifact: ProviderBinding,
        identifier: str,
        *,
        metadata_provider: str,
    ) -> str | None:
        if metadata_provider.casefold() == artifact.name.casefold():
            return identifier
        provider = artifact.name.casefold()
        if provider == "arxiv":
            return f"arxiv:{split_arxiv_id(identifier).versionless}"
        if provider == "zenodo":
            return split_zenodo_id(identifier).doi
        if provider == "scihub":
            doi = normalize_doi(identifier)
            if not doi:
                raise ValueError("Sci-Hub artifact metadata fallback requires a DOI")
            return f"doi:{doi}"
        return identifier

    @staticmethod
    def _assert_identity(
        artifact: ProviderBinding,
        identifier: str,
        work_aliases: frozenset[str],
    ) -> None:
        expected = artifact_identity_aliases(artifact.name, identifier)
        if expected.isdisjoint(work_aliases):
            raise MetadataIdentityError(
                f"metadata identities {sorted(work_aliases)} do not match artifact identities "
                f"{sorted(expected)}"
            )

    @staticmethod
    def _assert_authority_version(
        artifact: ProviderBinding,
        selected: ProviderBinding,
        identifier: str,
        returned_arxiv_id: str | None,
    ) -> None:
        if artifact.name.casefold() != "arxiv" or selected.name.casefold() != "arxiv":
            return
        expected = split_arxiv_id(identifier)
        if expected.version is None:
            return
        if returned_arxiv_id is None:
            raise MetadataIdentityError("arXiv authority metadata omitted the arXiv identifier")
        actual = split_arxiv_id(returned_arxiv_id)
        if actual.versioned.casefold() != expected.versioned.casefold():
            raise MetadataIdentityError(
                f"arXiv authority returned {actual.versioned!r} for artifact {expected.versioned!r}"
            )
