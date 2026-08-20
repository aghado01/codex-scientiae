"""Lock-step acquire into a destination leaf and materialize article.json."""

from __future__ import annotations

from procurement.domain.acquisition.planning import ArtifactAcquisitionRequest
from procurement.domain.materialization import SourceMaterializationRequest
from procurement.domain.procure import ProcureRequest, ProcureResult
from procurement.errors import ProcureError
from procurement.operations.acquisition import AcquisitionService
from procurement.operations.materialization import SourceMaterializationService


class ProcureService:
    """Run acquisition and source materialization as one destination-bound operation."""

    def __init__(
        self,
        acquisition: AcquisitionService,
        materialization: SourceMaterializationService,
    ) -> None:
        self._acquisition = acquisition
        self._materialization = materialization

    async def procure(self, request: ProcureRequest) -> ProcureResult:
        """Acquire receipted bytes, then materialize the same destination leaf."""

        if "source" not in request.artifacts:
            raise ProcureError("procure requires a source artifact")
        acquired = await self._acquisition.acquire(
            ArtifactAcquisitionRequest(
                provider=request.provider,
                identifier=request.identifier,
                artifacts=request.artifacts,
                catalog=request.catalog,
            )
        )
        manifest = acquired.manifest
        if manifest is None or all(form.kind != "source" for form in manifest.forms):
            raise ProcureError(
                "procure did not receipt a source form at "
                f"{request.catalog!r}; materialization was not attempted"
            )
        materialized = await self._materialization.materialize(
            SourceMaterializationRequest(
                catalog=request.catalog,
                acquisition_slug=manifest.slug,
                main_tex=request.main_tex,
                metadata=request.metadata,
            )
        )
        return ProcureResult(acquisition=acquired, materialization=materialized)


__all__ = ["ProcureService"]
