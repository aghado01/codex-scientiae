"""Provider-planned, path-confined artifact acquisition."""

from __future__ import annotations

import asyncio
import gzip
import os
from collections.abc import Callable, Mapping
from concurrent.futures import ThreadPoolExecutor
from dataclasses import replace
from functools import partial
from pathlib import Path
from types import TracebackType
from typing import TypeVar

from procurement.errors import AcquisitionConflictError, AcquisitionError, ProviderError
from procurement.http import HttpClient, HttpDownload, RequestPolicy
from procurement.payloads import (
    AcquiredArtifact,
    AcquisitionManifest,
    AcquisitionOutcome,
    AcquisitionResult,
    ArtifactAcquisitionRequest,
    ArtifactPlan,
    ArtifactPlanSummary,
    PlannedArtifact,
)
from procurement.providers.base import Capability
from procurement.registry import ProviderRegistry
from procurement.staging import (
    AcquisitionItem,
    AcquisitionStore,
    collate_acquisition,
    measure_artifact_file,
    validate_form_file,
)

_T = TypeVar("_T")


def validate_gzip_payload(path: str | Path, *, maximum_expanded_bytes: int) -> None:
    """Validate one complete non-empty gzip stream within its expansion boundary."""

    expanded = 0
    try:
        with gzip.open(Path(path), "rb") as stream:
            while chunk := stream.read(1024 * 1024):
                expanded += len(chunk)
                if expanded > maximum_expanded_bytes:
                    raise AcquisitionError(
                        "gzip payload exceeds the configured expanded-byte limit"
                    )
    except AcquisitionError:
        raise
    except (OSError, EOFError) as exc:
        raise AcquisitionError("gzip payload is incomplete or invalid") from exc
    if expanded == 0:
        raise AcquisitionError("gzip payload expands to an empty body")


def validate_pdf_payload(path: str | Path) -> None:
    """Validate the required leading and trailing markers of one PDF payload."""

    target = Path(path)
    with target.open("rb") as handle:
        prefix = handle.read(5)
        handle.seek(max(0, target.stat().st_size - 4096))
        suffix = handle.read()
    if prefix != b"%PDF-" or b"%%EOF" not in suffix:
        raise AcquisitionError("PDF payload lacks its required header or end marker")


class _AsyncAcquisitionTransaction:
    """Run one thread-local staging lease and its filesystem work off the event loop."""

    def __init__(self, store: AcquisitionStore, slug: str) -> None:
        self._context = store.transaction(slug)
        self._executor = ThreadPoolExecutor(
            max_workers=1,
            thread_name_prefix="procurement-acquisition",
        )
        self.item: AcquisitionItem | None = None

    def _submit(self, function: Callable[..., _T], *args: object, **kwargs: object):
        loop = asyncio.get_running_loop()
        return loop.run_in_executor(self._executor, partial(function, *args, **kwargs))

    async def run(
        self,
        function: Callable[..., _T],
        *args: object,
        **kwargs: object,
    ) -> _T:
        """Finish an in-flight filesystem boundary before propagating cancellation."""

        future = self._submit(function, *args, **kwargs)
        try:
            return await asyncio.shield(future)
        except asyncio.CancelledError:
            try:
                await future
            except BaseException:
                pass
            raise

    async def __aenter__(self) -> "_AsyncAcquisitionTransaction":
        future = self._submit(self._context.__enter__)
        try:
            self.item = await asyncio.shield(future)
        except asyncio.CancelledError:
            try:
                self.item = await future
            except BaseException:
                pass
            else:
                try:
                    await self.run(self._context.__exit__, None, None, None)
                finally:
                    self.item = None
            self._executor.shutdown(wait=True)
            raise
        except BaseException:
            self._executor.shutdown(wait=True)
            raise
        return self

    async def __aexit__(
        self,
        exc_type: type[BaseException] | None,
        exc: BaseException | None,
        traceback: TracebackType | None,
    ) -> bool:
        try:
            return bool(await self.run(self._context.__exit__, exc_type, exc, traceback))
        finally:
            self.item = None
            self._executor.shutdown(wait=True)


class AcquisitionService:
    """Plan trusted provider routes and execute each requested payload independently."""

    def __init__(
        self,
        registry: ProviderRegistry,
        http: HttpClient,
        store: AcquisitionStore,
        *,
        provider_policies: Mapping[str, RequestPolicy] | None = None,
        user_agent: str = "codex-scientiae-procurement/0.1",
        maximum_expanded_source_bytes: int = 4 * 1024 * 1024 * 1024,
    ) -> None:
        self._registry = registry
        self._http = http
        self._store = store
        self._policies = {
            name.casefold(): policy for name, policy in (provider_policies or {}).items()
        }
        self._headers = {"User-Agent": user_agent}
        self._maximum_expanded_source_bytes = maximum_expanded_source_bytes

    async def plan(self, request: ArtifactAcquisitionRequest) -> ArtifactPlan:
        """Return an internal server-produced plan; callers cannot supply candidate URLs."""

        provider = self._registry.get(request.provider, Capability.PLAN_ARTIFACT)
        plan = await provider.plan_artifact(request)
        if plan.artifact.provider.casefold() != provider.name.casefold():
            raise AcquisitionError("artifact planner returned another provider's identity")
        if set(plan.requested) != set(request.artifacts):
            raise AcquisitionError("artifact planner did not account for the request")
        return plan

    async def summarize_plan(
        self,
        request: ArtifactAcquisitionRequest,
    ) -> ArtifactPlanSummary:
        """Return a URL-free public projection of a freshly produced plan."""

        return ArtifactPlanSummary.from_plan(await self.plan(request))

    async def acquire(self, request: ArtifactAcquisitionRequest) -> AcquisitionResult:
        """Acquire available payloads and monotonically collate acquisition.json."""

        plan = await self.plan(request)
        outcomes: list[AcquisitionOutcome] = [
            AcquisitionOutcome(kind=item.kind, status="unavailable", error=item.reason)
            for item in plan.unavailable
        ]
        async with _AsyncAcquisitionTransaction(self._store, plan.deposit_slug) as transaction:
            item = transaction.item
            if item is None:  # pragma: no cover - successful entry establishes the item
                raise AcquisitionError("acquisition staging transaction did not open")
            manifest = await transaction.run(self._recover_item, item)
            if manifest is not None and manifest.artifact != plan.artifact:
                raise AcquisitionConflictError(
                    "staging item acquisition identity conflicts with the provider plan"
                )

            known = {form.kind: form for form in manifest.forms} if manifest else {}
            for payload in plan.payloads:
                existing = known.get(payload.kind)
                if existing is not None:
                    if existing.path != payload.target_leaf:
                        raise AcquisitionConflictError(
                            f"existing {payload.kind!r} target disagrees with the provider plan"
                        )
                    await transaction.run(validate_form_file, item.directory, existing)
                    outcomes.append(
                        AcquisitionOutcome(
                            kind=payload.kind,
                            status="already-present",
                            path=existing.path,
                        )
                    )
                    continue

                target = item.artifact_path(payload.target_leaf)
                if await transaction.run(os.path.lexists, target):
                    raise AcquisitionConflictError(
                        f"unreceipted artifact occupies the planned target: '{target}'"
                    )

                acquired, errors = await self._acquire_payload(
                    transaction,
                    item,
                    plan,
                    payload,
                )
                if acquired is None:
                    outcomes.append(
                        AcquisitionOutcome(
                            kind=payload.kind,
                            status="error",
                            error="; ".join(errors) or "no retrieval candidate succeeded",
                        )
                    )
                    continue

                partial, form = acquired
                manifest = await transaction.run(
                    self._publish_acquired,
                    item,
                    plan,
                    manifest,
                    partial,
                    form,
                )
                known[form.kind] = form
                outcomes.append(
                    AcquisitionOutcome(kind=form.kind, status="acquired", path=form.path)
                )

            if manifest is not None:
                await transaction.run(self._validate_manifest_forms, item.directory, manifest)

            ordered_outcomes = tuple(
                next(outcome for outcome in outcomes if outcome.kind == requested)
                for requested in plan.requested
            )
            return AcquisitionResult(
                staging_directory=str(item.directory),
                manifest_path=str(item.manifest_path) if manifest is not None else None,
                manifest=manifest,
                outcomes=ordered_outcomes,
            )

    def inspect(self, deposit_slug: str) -> AcquisitionManifest:
        """Read and revalidate one durable acquisition receipt and all named forms."""

        with self._store.transaction(deposit_slug, create=False) as item:
            manifest = item.recover(item.read_manifest())
            if manifest is None:
                raise AcquisitionError(
                    f"no acquisition.json exists for staged item {deposit_slug!r}"
                )
            for form in manifest.forms:
                validate_form_file(item.directory, form)
            return manifest

    async def _acquire_payload(
        self,
        transaction: _AsyncAcquisitionTransaction,
        item: AcquisitionItem,
        plan: ArtifactPlan,
        payload: PlannedArtifact,
    ) -> tuple[tuple[Path, AcquiredArtifact] | None, list[str]]:
        errors: list[str] = []
        policy = replace(
            self._policies.get(plan.artifact.provider.casefold(), RequestPolicy()),
            max_decoded_body_bytes=payload.maximum_bytes,
        )
        for candidate in payload.candidates:
            partial = item.private_download_path()
            retained = False
            try:
                algorithms = (
                    (payload.checksum.algorithm,) if payload.checksum is not None else ()
                )
                download = await self._http.download_to(
                    candidate.url,
                    str(partial),
                    allowed_hosts=candidate.allowed_hosts,
                    headers=self._headers,
                    rate_key=plan.artifact.provider,
                    policy=policy,
                    hash_algorithms=algorithms,
                )
                await transaction.run(self._validate_download, partial, payload, download)
                form = AcquiredArtifact(
                    kind=payload.kind,
                    path=payload.target_leaf,
                    format=payload.media_type,
                    bytes=download.bytes,
                    sha256=download.sha256,
                    origin_url=download.url,
                    candidate_id=candidate.candidate_id,
                    fetched_at=download.fetched_at,
                    provider_checksum=payload.checksum,
                )
                retained = True
                return (partial, form), errors
            except (ProviderError, AcquisitionError, OSError) as exc:
                errors.append(f"{candidate.candidate_id}: {exc}")
            finally:
                if not retained:
                    await transaction.run(self._unlink_if_present, partial)
        return None, errors

    @staticmethod
    def _recover_item(item: AcquisitionItem) -> AcquisitionManifest | None:
        return item.recover(item.read_manifest())

    @staticmethod
    def _validate_manifest_forms(directory: Path, manifest: AcquisitionManifest) -> None:
        for form in manifest.forms:
            validate_form_file(directory, form)

    @staticmethod
    def _unlink_if_present(path: Path) -> None:
        try:
            path.unlink()
        except FileNotFoundError:
            pass

    @staticmethod
    def _publish_acquired(
        item: AcquisitionItem,
        plan: ArtifactPlan,
        manifest: AcquisitionManifest | None,
        partial: Path,
        form: AcquiredArtifact,
    ) -> AcquisitionManifest:
        journal = item.write_journal(plan.artifact, partial, form)
        item.publish_download(partial, form)
        incoming = AcquisitionManifest(
            slug=plan.deposit_slug,
            artifact=plan.artifact,
            forms=(form,),
        )
        published = collate_acquisition(manifest, incoming)
        item.publish_manifest(published)
        journal.unlink()
        return published

    def _validate_download(
        self,
        path: Path,
        payload: PlannedArtifact,
        download: HttpDownload,
    ) -> None:
        size, digest = measure_artifact_file(path)
        if size != download.bytes or digest != download.sha256:
            raise AcquisitionError("downloaded file changed before payload validation")
        if size < payload.minimum_bytes:
            raise AcquisitionError(
                f"downloaded {payload.kind} is smaller than {payload.minimum_bytes} bytes"
            )
        if payload.expected_bytes is not None and size != payload.expected_bytes:
            raise AcquisitionError(
                f"downloaded {payload.kind} has {size} bytes; expected {payload.expected_bytes}"
            )
        if payload.checksum is not None:
            digests = dict(download.digests)
            if digests.get(payload.checksum.algorithm) != payload.checksum.digest:
                raise AcquisitionError(
                    f"downloaded {payload.kind} does not match its provider checksum"
                )

        if payload.payload_kind == "gzip":
            validate_gzip_payload(
                path,
                maximum_expanded_bytes=self._maximum_expanded_source_bytes,
            )
        elif payload.payload_kind == "pdf":
            validate_pdf_payload(path)
        else:
            self._validate_html(path)

    @staticmethod
    def _validate_html(path: Path) -> None:
        try:
            with path.open("rb") as handle:
                head = handle.read(8192).decode("utf-8", errors="strict").casefold()
        except UnicodeDecodeError as exc:
            raise AcquisitionError("HTML payload is not valid UTF-8") from exc
        if "<html" not in head and "<!doctype html" not in head:
            raise AcquisitionError("HTML payload lacks an HTML document marker")
