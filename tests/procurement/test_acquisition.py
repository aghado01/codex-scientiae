"""Artifact planning, streamed retrieval, and durable acquisition receipts."""

from __future__ import annotations

import asyncio
import copy
import gzip
import hashlib
import json
import os
import tempfile
import threading
import unittest
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
from unittest import mock

import httpx
import jsonschema
from pydantic import ValidationError

from jsonl_engine.publication import PinnedPublicationRoot
from procurement.errors import AcquisitionConflictError, ProviderHttpError, ProviderPayloadError
from procurement.transport.http import HttpClient, RequestPolicy
from procurement.domain.metadata import ArtifactReference
from procurement.domain.acquisition.planning import (
    ArtifactAcquisitionRequest,
    ArtifactPlan,
    ArtifactPlanSummary,
    ChecksumExpectation,
    PlannedArtifact,
    RetrievalCandidate,
    UnavailableArtifact,
)
from procurement.domain.acquisition.receipts import (
    AcquiredArtifact,
    AcquisitionManifest,
    acquisition_manifest_schema,
)
from procurement.providers.arxiv import ArxivProvider
from procurement.providers.base import Capability, ProviderRole
from procurement.providers.zenodo import ZenodoProvider
from procurement.providers.catalog import ProviderBinding, ProviderCatalog
from procurement.configuration import ArtifactLimitSettings, ProviderHttpSettings
from procurement.operations.acquisition import AcquisitionService
from procurement.storage.acquisitions import (
    AcquisitionItem,
    AcquisitionStore,
    collate_acquisition,
    measure_artifact_file,
)
from procurement.storage.roots import ConfiguredRootDescriptor, ConfiguredRootKind


NOW = datetime(2026, 8, 11, 12, 0, tzinfo=timezone.utc)
PDF = b"%PDF-1.7\n1 0 obj\n<<>>\nendobj\n%%EOF\n"
HTML = b"<!doctype html><html><body>paper</body></html>"
SOURCE = gzip.compress(b"\\documentclass{article}\n\\begin{document}x\\end{document}\n")


def artifact_reference(
    provider: str = "arxiv",
    identifier: str = "2008.10579v1",
) -> ArtifactReference:
    return ArtifactReference(
        provider=provider,
        identifier=identifier,
        provider_roles=("artifact-origin", "artifact-access", "metadata-authority"),
    )


def planned_artifact(
    kind: str,
    *,
    url: str | None = None,
    checksum: ChecksumExpectation | None = None,
    expected_bytes: int | None = None,
) -> PlannedArtifact:
    leaf, media_type, payload_kind, minimum = {
        "source": ("arXiv-2008.10579v1.tar.gz", "application/gzip", "gzip", 2),
        "pdf": ("2008.10579v1.pdf", "application/pdf", "pdf", 5),
        "html": ("2008.10579v1.html", "text/html", "html", 16),
    }[kind]
    return PlannedArtifact(
        kind=kind,
        target_leaf=leaf,
        media_type=media_type,
        payload_kind=payload_kind,
        minimum_bytes=minimum,
        maximum_bytes=1024 * 1024,
        expected_bytes=expected_bytes,
        checksum=checksum,
        candidates=(
            RetrievalCandidate(
                candidate_id=f"test-{kind}",
                url=url or f"https://provider.test/{kind}",
                allowed_hosts=("provider.test",),
            ),
        ),
    )


def artifact_plan(
    payloads: tuple[PlannedArtifact, ...],
    *,
    requested: tuple[str, ...] | None = None,
    unavailable: tuple[UnavailableArtifact, ...] = (),
) -> ArtifactPlan:
    return ArtifactPlan(
        artifact=artifact_reference(),
        deposit_slug="2008.10579v1",
        requested=requested or tuple(item.kind for item in payloads),
        payloads=payloads,
        unavailable=unavailable,
    )


def acquired_artifact(
    kind: str,
    body: bytes,
    *,
    checksum: ChecksumExpectation | None = None,
) -> AcquiredArtifact:
    leaf, media_type = {
        "source": ("arXiv-2008.10579v1.tar.gz", "application/gzip"),
        "pdf": ("2008.10579v1.pdf", "application/pdf"),
        "html": ("2008.10579v1.html", "text/html"),
    }[kind]
    return AcquiredArtifact(
        kind=kind,
        path=leaf,
        format=media_type,
        bytes=len(body),
        sha256=hashlib.sha256(body).hexdigest(),
        origin_url=f"https://provider.test/{kind}",
        candidate_id=f"test-{kind}",
        fetched_at=NOW,
        provider_checksum=checksum,
    )


class StaticPlanningProvider:
    name = "arxiv"

    def __init__(self, plan: ArtifactPlan) -> None:
        self.plan = plan
        self.calls = 0

    async def plan_artifact(self, request: ArtifactAcquisitionRequest) -> ArtifactPlan:
        self.calls += 1
        return self.plan


def acquisition_service(
    plan: ArtifactPlan,
    http: HttpClient,
    store: AcquisitionStore,
    *,
    maximum_expanded_source_bytes: int = 1024 * 1024,
) -> tuple[AcquisitionService, StaticPlanningProvider]:
    planner = StaticPlanningProvider(plan)
    registry = ProviderCatalog(
        [
            ProviderBinding(
                planner,
                frozenset({Capability.PLAN_ARTIFACT}),
                frozenset(
                    {
                        ProviderRole.ARTIFACT_ORIGIN,
                        ProviderRole.ARTIFACT_ACCESS,
                        ProviderRole.METADATA_AUTHORITY,
                    }
                ),
            )
        ]
    )
    return (
        AcquisitionService(
            registry,
            http,
            store,
            provider_policies={
                "arxiv": RequestPolicy(max_attempts=1, max_decoded_body_bytes=1024 * 1024)
            },
            maximum_expanded_source_bytes=maximum_expanded_source_bytes,
        ),
        planner,
    )


@contextmanager
def opened_acquisition_store(
    root: str | Path,
    *,
    lock_timeout: float = 60.0,
):
    with PinnedPublicationRoot(root) as pinned:
        descriptor = ConfiguredRootDescriptor(
            kind=ConfiguredRootKind.STAGING,
            name="default",
            path=pinned.path,
            identity=pinned.identity,
            publication_root=pinned,
        )
        yield AcquisitionStore(descriptor, lock_timeout=lock_timeout)


class TestAcquisitionModels(unittest.TestCase):
    def test_artifact_routes_require_https_except_for_deliberate_loopback_http(self) -> None:
        with self.assertRaisesRegex(ValidationError, "HTTPS or loopback HTTP"):
            RetrievalCandidate(
                candidate_id="unsafe",
                url="http://provider.test/source",
                allowed_hosts=("provider.test",),
            )

        candidate = RetrievalCandidate(
            candidate_id="local-fixture",
            url="http://127.0.0.1:8765/source",
            allowed_hosts=("127.0.0.1",),
        )
        self.assertEqual(candidate.url, "http://127.0.0.1:8765/source")

    def test_receipt_schemas_match_expressible_runtime_invariants(self) -> None:
        static_schema_path = (
            Path(__file__).resolve().parents[2]
            / "src"
            / "procurement"
            / "schemas"
            / "acquisition.schema.json"
        )
        static_schema = json.loads(static_schema_path.read_text(encoding="utf-8"))
        generated_schema = acquisition_manifest_schema()
        jsonschema.Draft202012Validator.check_schema(static_schema)
        jsonschema.Draft202012Validator.check_schema(generated_schema)

        checksum = ChecksumExpectation(
            algorithm="md5",
            digest=hashlib.md5(SOURCE).hexdigest(),
        )
        receipt = AcquisitionManifest(
            slug="2008.10579v1",
            artifact=artifact_reference(),
            forms=(acquired_artifact("source", SOURCE, checksum=checksum),),
        ).model_dump(mode="json", by_alias=True)
        validators = {
            "committed": jsonschema.Draft202012Validator(static_schema),
            "generated": jsonschema.Draft202012Validator(generated_schema),
        }
        for label, validator in validators.items():
            with self.subTest(schema=label, case="valid receipt"):
                validator.validate(receipt)

        self.assertEqual(static_schema["allOf"], generated_schema["allOf"])
        self.assertEqual(
            static_schema["x-runtime-invariants"],
            generated_schema["x-runtime-invariants"],
        )
        self.assertEqual(
            static_schema["$defs"]["checksum"]["allOf"],
            generated_schema["$defs"]["ChecksumExpectation"]["allOf"],
        )
        self.assertEqual(
            static_schema["properties"]["forms"]["items"]["properties"][
                "origin_url"
            ]["pattern"],
            generated_schema["$defs"]["AcquiredArtifact"]["properties"][
                "origin_url"
            ]["pattern"],
        )

        invalid_receipts: dict[str, dict[str, object]] = {}
        wrong_checksum = copy.deepcopy(receipt)
        wrong_checksum["forms"][0]["provider_checksum"]["digest"] = "a" * 64
        invalid_receipts["algorithm-specific checksum"] = wrong_checksum

        duplicate_kind = copy.deepcopy(receipt)
        duplicate_kind["forms"].append(copy.deepcopy(duplicate_kind["forms"][0]))
        invalid_receipts["one form per kind"] = duplicate_kind

        unsafe_origin = copy.deepcopy(receipt)
        unsafe_origin["forms"][0]["origin_url"] = "ftp://provider.test/source"
        invalid_receipts["safe origin URL"] = unsafe_origin

        remote_http = copy.deepcopy(receipt)
        remote_http["forms"][0]["origin_url"] = "http://provider.test/source"
        invalid_receipts["remote HTTP origin"] = remote_http

        missing_origin_host = copy.deepcopy(receipt)
        missing_origin_host["forms"][0]["origin_url"] = "https://?query"
        invalid_receipts["missing HTTPS host"] = missing_origin_host

        credentialed_origin = copy.deepcopy(receipt)
        credentialed_origin["forms"][0]["origin_url"] = (
            "https://user:password@provider.test/source"
        )
        invalid_receipts["credentialed HTTPS origin"] = credentialed_origin

        for case, invalid in invalid_receipts.items():
            for label, validator in validators.items():
                with self.subTest(schema=label, case=case):
                    self.assertFalse(validator.is_valid(invalid))

        loopback = copy.deepcopy(receipt)
        loopback["forms"][0]["origin_url"] = "http://127.0.0.1:8765/source"
        for label, validator in validators.items():
            with self.subTest(schema=label, case="loopback HTTP"):
                validator.validate(loopback)

        identity_mismatch = copy.deepcopy(receipt)
        identity_mismatch["artifact"]["identifier"] = "2008.10580v1"
        case_collision = copy.deepcopy(receipt)
        colliding_form = copy.deepcopy(case_collision["forms"][0])
        colliding_form["kind"] = "pdf"
        colliding_form["path"] = colliding_form["path"].upper()
        case_collision["forms"].append(colliding_form)

        for case, runtime_only in {
            "canonical provider identity": identity_mismatch,
            "portable case-folded paths": case_collision,
        }.items():
            for label, validator in validators.items():
                with self.subTest(schema=label, case=case):
                    validator.validate(runtime_only)
            with self.subTest(runtime=case):
                with self.assertRaises(ValidationError):
                    AcquisitionManifest.model_validate(runtime_only)

    def test_request_deduplicates_and_plan_accounts_for_every_kind(self) -> None:
        request = ArtifactAcquisitionRequest(
            provider=" arxiv ",
            identifier=" 2008.10579v1 ",
            artifacts=("source", "source", "pdf"),
        )
        self.assertEqual(request.provider, "arxiv")
        self.assertEqual(request.artifacts, ("source", "pdf"))

        plan = artifact_plan(
            (planned_artifact("source"),),
            requested=request.artifacts,
            unavailable=(UnavailableArtifact(kind="pdf", reason="not deposited"),),
        )
        summary = ArtifactPlanSummary.from_plan(plan)
        self.assertEqual(summary.deposit_slug, "2008.10579v1")
        self.assertEqual(summary.payloads[0].candidate_count, 1)
        self.assertNotIn("provider.test", json.dumps(summary.model_dump(mode="json")))

        with self.assertRaisesRegex(ValidationError, "account for every requested kind"):
            artifact_plan((planned_artifact("source"),), requested=("source", "pdf"))

    def test_plan_rejects_case_colliding_targets_and_duplicate_candidate_ids(self) -> None:
        source = planned_artifact("source")
        pdf = planned_artifact("pdf").model_copy(
            update={"target_leaf": source.target_leaf.upper()}
        )
        with self.assertRaisesRegex(ValidationError, "portable-case unique"):
            artifact_plan((source, pdf), requested=("source", "pdf"))

        candidate = source.candidates[0]
        with self.assertRaisesRegex(ValidationError, "candidate IDs must be unique"):
            PlannedArtifact.model_validate(
                {
                    **source.model_dump(mode="python"),
                    "candidates": (candidate, candidate),
                }
            )

    def test_collation_is_idempotent_orders_forms_and_never_downgrades_checksum(self) -> None:
        pdf = acquired_artifact("pdf", PDF)
        existing = AcquisitionManifest(
            slug="2008.10579v1",
            artifact=artifact_reference(),
            forms=(pdf,),
        )
        provider_checksum = ChecksumExpectation(
            algorithm="md5", digest=hashlib.md5(PDF).hexdigest()
        )
        stronger_pdf = acquired_artifact("pdf", PDF, checksum=provider_checksum)
        source = acquired_artifact("source", SOURCE)
        incoming = AcquisitionManifest(
            slug="2008.10579v1",
            artifact=artifact_reference(),
            forms=(source, stronger_pdf),
        )

        merged = collate_acquisition(existing, incoming)
        self.assertEqual(tuple(form.kind for form in merged.forms), ("source", "pdf"))
        self.assertEqual(merged.forms[1].provider_checksum, provider_checksum)
        self.assertEqual(collate_acquisition(merged, existing), merged)
        self.assertEqual(collate_acquisition(merged, merged), merged)

    def test_collation_rejects_byte_or_identity_conflicts(self) -> None:
        existing = AcquisitionManifest(
            slug="2008.10579v1",
            artifact=artifact_reference(),
            forms=(acquired_artifact("pdf", PDF),),
        )
        changed = AcquisitionManifest(
            slug="2008.10579v1",
            artifact=artifact_reference(),
            forms=(acquired_artifact("pdf", PDF + b"changed"),),
        )
        with self.assertRaisesRegex(AcquisitionConflictError, "conflicts"):
            collate_acquisition(existing, changed)

        other = existing.model_copy(
            update={"artifact": artifact_reference(identifier="2008.10580v1")}
        )
        with self.assertRaisesRegex(AcquisitionConflictError, "identity conflicts"):
            collate_acquisition(existing, other)


class TestProviderPlanning(unittest.TestCase):
    def test_arxiv_plans_version_pinned_old_style_routes_with_portable_slug(self) -> None:
        atom = b"""<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
      xmlns:arxiv="http://arxiv.org/schemas/atom">
  <opensearch:totalResults>1</opensearch:totalResults>
  <opensearch:startIndex>0</opensearch:startIndex>
  <opensearch:itemsPerPage>1</opensearch:itemsPerPage>
  <entry>
    <id>https://arxiv.org/abs/hep-th/9901001v2</id>
    <updated>2026-08-11T00:00:00Z</updated>
    <published>1999-01-01T00:00:00Z</published>
    <title>Old style paper</title>
    <summary>Summary</summary>
    <author><name>A. Author</name></author>
    <category term="hep-th" />
    <arxiv:primary_category term="hep-th" />
    <link title="pdf" href="https://arxiv.test/pdf/hep-th/9901001v2" />
  </entry>
</feed>"""
        settings = ProviderHttpSettings(
            base_url="https://api.arxiv.test/query",
            artifact_base_url="https://arxiv.test",
            secondary_artifact_base_url="https://export.arxiv.test",
            min_interval_seconds=0,
            timeout_seconds=5,
            max_attempts=1,
        )

        async def exercise() -> None:
            async with httpx.AsyncClient(
                transport=httpx.MockTransport(
                    lambda request: httpx.Response(
                        200,
                        content=atom,
                        headers={"content-type": "application/atom+xml"},
                    )
                )
            ) as raw:
                provider = ArxivProvider(
                    HttpClient(raw, utc_now=lambda: NOW),
                    settings,
                    artifact_limits=ArtifactLimitSettings(
                        source_bytes=1000,
                        pdf_bytes=1000,
                        html_bytes=1000,
                        expanded_source_bytes=2000,
                        archive_entries=100,
                    ),
                )
                plan = await provider.plan_artifact(
                    ArtifactAcquisitionRequest(
                        provider="arxiv",
                        identifier="hep-th/9901001v2",
                        artifacts=("source", "pdf", "html"),
                    )
                )

            mismatched = atom.replace(b"hep-th/9901001v2", b"hep-th/9901002v1")
            async with httpx.AsyncClient(
                transport=httpx.MockTransport(
                    lambda request: httpx.Response(200, content=mismatched)
                )
            ) as raw:
                provider = ArxivProvider(HttpClient(raw), settings)
                with self.assertRaisesRegex(ProviderPayloadError, "for artifact 'hep-th/9901001'"):
                    await provider.plan_artifact(
                        ArtifactAcquisitionRequest(
                            provider="arxiv",
                            identifier="hep-th/9901001",
                            artifacts=("source",),
                        )
                    )

            self.assertEqual(plan.artifact.identifier, "hep-th/9901001v2")
            self.assertEqual(plan.deposit_slug, "hep-th_9901001v2")
            self.assertEqual(tuple(item.kind for item in plan.payloads), ("source", "pdf", "html"))
            self.assertEqual(len(plan.payloads[0].candidates), 2)
            self.assertIn("/e-print/hep-th/9901001v2", plan.payloads[0].candidates[0].url)
            self.assertEqual(plan.payloads[0].maximum_bytes, 1000)

        asyncio.run(exercise())

    def test_zenodo_plans_manifest_checksum_and_reports_ambiguous_files(self) -> None:
        record = {
            "id": 123,
            "metadata": {"title": "Record", "creators": []},
            "files": [
                {
                    "key": "paper.tar.gz",
                    "size": len(SOURCE),
                    "checksum": f"md5:{hashlib.md5(SOURCE).hexdigest()}",
                    "links": {
                        "self": "https://zenodo.test/api/records/123/files/source/content",
                        "download": "https://zenodo.test/api/records/123/files/source/content",
                    },
                },
                {
                    "key": "paper.pdf",
                    "size": len(PDF),
                    "checksum": f"md5:{hashlib.md5(PDF).hexdigest()}",
                    "links": {"self": "https://zenodo.test/files/paper.pdf"},
                },
                {
                    "key": "appendix.pdf",
                    "size": len(PDF),
                    "checksum": f"md5:{hashlib.md5(PDF).hexdigest()}",
                    "links": {"self": "https://zenodo.test/files/appendix.pdf"},
                },
            ],
        }
        settings = ProviderHttpSettings(
            base_url="https://zenodo.test/api/records",
            min_interval_seconds=0,
            timeout_seconds=5,
            max_attempts=1,
        )

        async def exercise() -> None:
            async with httpx.AsyncClient(
                transport=httpx.MockTransport(
                    lambda request: httpx.Response(
                        200,
                        json=record,
                        headers={"content-type": "application/json"},
                    )
                )
            ) as raw:
                provider = ZenodoProvider(
                    HttpClient(raw, utc_now=lambda: NOW),
                    settings,
                )
                plan = await provider.plan_artifact(
                    ArtifactAcquisitionRequest(
                        provider="zenodo",
                        identifier="000123",
                        artifacts=("source", "pdf", "html"),
                    )
                )

            malformed = {**record, "files": {"not": "an array"}}
            async with httpx.AsyncClient(
                transport=httpx.MockTransport(
                    lambda request: httpx.Response(200, json=malformed)
                )
            ) as raw:
                provider = ZenodoProvider(HttpClient(raw), settings)
                with self.assertRaisesRegex(ProviderPayloadError, r"valid files\[\] manifest"):
                    await provider.plan_artifact(
                        ArtifactAcquisitionRequest(
                            provider="zenodo",
                            identifier="123",
                            artifacts=("source",),
                        )
                    )

            self.assertEqual(plan.artifact.identifier, "123")
            self.assertEqual(plan.deposit_slug, "zenodo_123")
            self.assertEqual(tuple(item.kind for item in plan.payloads), ("source",))
            self.assertEqual(plan.payloads[0].expected_bytes, len(SOURCE))
            self.assertEqual(plan.payloads[0].checksum.algorithm, "md5")
            self.assertEqual(len(plan.payloads[0].candidates), 1)
            unavailable = {item.kind: item.reason for item in plan.unavailable}
            self.assertIn("ambiguous", unavailable["pdf"])
            self.assertIn("no 'html' file", unavailable["html"])

        asyncio.run(exercise())


class TestStreamedDownloads(unittest.TestCase):
    def test_download_follows_allowed_redirect_and_hashes_decoded_bytes(self) -> None:
        calls: list[str] = []

        def handler(request: httpx.Request) -> httpx.Response:
            calls.append(str(request.url))
            if request.url.path == "/start":
                return httpx.Response(302, headers={"location": "/payload?token=secret"})
            return httpx.Response(
                200,
                content=PDF,
                headers={"content-type": "application/pdf"},
            )

        async def exercise(destination: Path) -> None:
            with PinnedPublicationRoot(destination.parent) as output_root:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    result = await HttpClient(raw, utc_now=lambda: NOW).download_to(
                        "https://provider.test/start",
                        str(destination),
                        publication_root=output_root,
                        allowed_hosts=("provider.test",),
                        policy=RequestPolicy(max_attempts=1, max_decoded_body_bytes=1024),
                        hash_algorithms=("md5",),
                    )
            self.assertEqual(destination.read_bytes(), PDF)
            self.assertEqual(result.sha256, hashlib.sha256(PDF).hexdigest())
            self.assertEqual(dict(result.digests)["md5"], hashlib.md5(PDF).hexdigest())
            self.assertIn("token=REDACTED", result.url)

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(Path(root) / "payload.part"))
        self.assertEqual(len(calls), 2)

    def test_download_rejects_off_host_redirect_and_removes_private_file(self) -> None:
        called_hosts: list[str] = []

        def handler(request: httpx.Request) -> httpx.Response:
            called_hosts.append(request.url.host)
            return httpx.Response(302, headers={"location": "https://evil.test/payload"})

        async def exercise(destination: Path) -> None:
            with PinnedPublicationRoot(destination.parent) as output_root:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    with self.assertRaisesRegex(ProviderHttpError, "left its allowed hosts"):
                        await HttpClient(raw).download_to(
                            "https://provider.test/start",
                            str(destination),
                            publication_root=output_root,
                            allowed_hosts=("provider.test",),
                            policy=RequestPolicy(max_attempts=1),
                        )
            self.assertFalse(os.path.lexists(destination))

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(Path(root) / "payload.part"))
        self.assertEqual(called_hosts, ["provider.test"])

    def test_download_rejects_https_to_http_redirect_before_plaintext_request(self) -> None:
        called_urls: list[str] = []

        def handler(request: httpx.Request) -> httpx.Response:
            called_urls.append(str(request.url))
            return httpx.Response(
                302,
                headers={"location": "http://provider.test/plaintext"},
            )

        async def exercise(destination: Path) -> None:
            with PinnedPublicationRoot(destination.parent) as output_root:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    with self.assertRaisesRegex(ProviderHttpError, "HTTPS-to-HTTP downgrade"):
                        await HttpClient(raw).download_to(
                            "https://provider.test/start",
                            str(destination),
                            publication_root=output_root,
                            allowed_hosts=("provider.test",),
                            policy=RequestPolicy(max_attempts=1),
                        )
            self.assertFalse(os.path.lexists(destination))

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(Path(root) / "payload.part"))
        self.assertEqual(called_urls, ["https://provider.test/start"])

    def test_download_refuses_oversize_and_truncated_responses_without_residue(self) -> None:
        cases = (
            (
                "oversize",
                lambda request: httpx.Response(
                    200, content=b"12345", headers={"content-length": "5"}
                ),
                RequestPolicy(max_attempts=1, max_decoded_body_bytes=4),
                "exceeds",
            ),
            (
                "truncated",
                lambda request: httpx.Response(
                    200, content=b"123", headers={"content-length": "10"}
                ),
                RequestPolicy(max_attempts=1, max_decoded_body_bytes=20),
                "truncated",
            ),
        )

        async def exercise(destination: Path, handler, policy: RequestPolicy, pattern: str) -> None:
            with PinnedPublicationRoot(destination.parent) as output_root:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    with self.assertRaisesRegex(ProviderPayloadError, pattern):
                        await HttpClient(raw).download_to(
                            "https://provider.test/payload",
                            str(destination),
                            publication_root=output_root,
                            allowed_hosts=("provider.test",),
                            policy=policy,
                        )
            self.assertFalse(os.path.lexists(destination))

        with tempfile.TemporaryDirectory() as root:
            for name, handler, policy, pattern in cases:
                with self.subTest(name=name):
                    asyncio.run(
                        exercise(Path(root) / f"{name}.part", handler, policy, pattern)
                    )

    def test_download_rate_limit_retry_honors_bounded_retry_after(self) -> None:
        attempts = 0
        delays: list[float] = []

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal attempts
            attempts += 1
            if attempts == 1:
                return httpx.Response(429, headers={"retry-after": "2"})
            return httpx.Response(200, content=PDF)

        async def sleep(delay: float) -> None:
            delays.append(delay)

        async def exercise(destination: Path) -> None:
            with PinnedPublicationRoot(destination.parent) as output_root:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    result = await HttpClient(
                        raw,
                        sleep=sleep,
                        utc_now=lambda: NOW,
                    ).download_to(
                        "https://provider.test/payload",
                        str(destination),
                        publication_root=output_root,
                        allowed_hosts=("provider.test",),
                        policy=RequestPolicy(
                            max_attempts=2,
                            retry_rate_limits=True,
                            max_retry_after_seconds=3,
                        ),
                    )
            self.assertEqual(result.bytes, len(PDF))

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(Path(root) / "payload.part"))
        self.assertEqual(attempts, 2)
        self.assertEqual(delays, [2.0])


class TestAcquisitionService(unittest.TestCase):
    def test_store_rejects_an_unretained_path_dependency(self) -> None:
        with tempfile.TemporaryDirectory() as root:
            with self.assertRaisesRegex(TypeError, "active staging-root descriptor"):
                AcquisitionStore(root)  # type: ignore[arg-type]

    def test_item_replacement_between_creation_and_pin_is_never_accepted(self) -> None:
        with tempfile.TemporaryDirectory() as root:
            staging = Path(root) / "staging"
            staging.mkdir()
            with opened_acquisition_store(staging) as store:
                original_pin_child = PinnedPublicationRoot.pin_child
                swapped = False
                blocked = False

                def replace_before_pin(
                    parent: PinnedPublicationRoot,
                    leaf: str,
                ) -> PinnedPublicationRoot:
                    nonlocal swapped, blocked
                    if parent is store.publication_root and not swapped and not blocked:
                        item = staging / leaf
                        displaced = staging / "item-before-pin"
                        try:
                            os.rename(item, displaced)
                        except OSError:
                            blocked = True
                        else:
                            swapped = True
                            item.mkdir()
                    return original_pin_child(parent, leaf)

                caught: AcquisitionConflictError | None = None
                try:
                    with mock.patch.object(
                        PinnedPublicationRoot,
                        "pin_child",
                        replace_before_pin,
                    ):
                        with store.transaction("paper"):
                            pass
                except AcquisitionConflictError as exc:
                    caught = exc

                if swapped:
                    self.assertIsNotNone(caught)
                    assert caught is not None
                    self.assertIn("changed while its generation was pinned", str(caught))
                    self.assertEqual(list((staging / "paper").iterdir()), [])
                else:
                    self.assertTrue(blocked)
                    self.assertIsNone(caught)

    def test_streamed_download_cannot_be_redirected_to_a_replacement_generation(self) -> None:
        async def exercise(base: Path, target_kind: str) -> None:
            staging = base / "staging"
            staging.mkdir()
            entered = asyncio.Event()
            release = asyncio.Event()

            class PausedBody(httpx.AsyncByteStream):
                async def __aiter__(self):
                    entered.set()
                    await release.wait()
                    yield PDF

            def handler(request: httpx.Request) -> httpx.Response:
                return httpx.Response(200, stream=PausedBody())

            with opened_acquisition_store(staging) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    service, _ = acquisition_service(
                        artifact_plan((planned_artifact("pdf"),)),
                        HttpClient(raw, utc_now=lambda: NOW),
                        store,
                    )
                    task = asyncio.create_task(
                        service.acquire(
                            ArtifactAcquisitionRequest(
                                provider="arxiv",
                                identifier="2008.10579v1",
                                artifacts=("pdf",),
                            )
                        )
                    )
                    await asyncio.wait_for(entered.wait(), timeout=1)
                    target = staging if target_kind == "staging" else staging / "2008.10579v1"
                    displaced = (
                        base / "staging-displaced"
                        if target_kind == "staging"
                        else staging / "item-displaced"
                    )
                    swapped = False
                    try:
                        os.rename(target, displaced)
                    except OSError:
                        # Windows retains the configured and item directories without delete
                        # sharing. POSIX may rename them, but all file I/O remains descriptor-relative.
                        pass
                    else:
                        swapped = True
                        target.mkdir()
                    finally:
                        release.set()

                    if swapped:
                        with self.assertRaisesRegex(
                            AcquisitionConflictError,
                            "retained directory generation",
                        ):
                            await asyncio.wait_for(task, timeout=2)
                        self.assertEqual(list(target.iterdir()), [])
                    else:
                        result = await asyncio.wait_for(task, timeout=2)
                        self.assertEqual(result.outcomes[0].status, "acquired")

        for target_kind in ("staging", "item"):
            with self.subTest(target_kind=target_kind), tempfile.TemporaryDirectory() as root:
                asyncio.run(exercise(Path(root), target_kind))

    def test_store_lock_wait_does_not_block_the_event_loop(self) -> None:
        plan = artifact_plan((planned_artifact("pdf"),))

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(200, content=PDF)

        async def exercise(root: str) -> None:
            with opened_acquisition_store(root, lock_timeout=2) as store:
                entered = threading.Event()
                release = threading.Event()

                def hold_store_lease() -> None:
                    with store.transaction(plan.deposit_slug):
                        entered.set()
                        release.wait(2)

                holder = threading.Thread(target=hold_store_lease, daemon=True)
                holder.start()
                self.assertTrue(await asyncio.to_thread(entered.wait, 1))
                try:
                    async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                        service, _ = acquisition_service(
                            plan,
                            HttpClient(raw, utc_now=lambda: NOW),
                            store,
                        )
                        task = asyncio.create_task(
                            service.acquire(
                                ArtifactAcquisitionRequest(
                                    provider="arxiv",
                                    identifier="2008.10579v1",
                                    artifacts=("pdf",),
                                )
                            )
                        )
                        await asyncio.sleep(0.05)
                        self.assertFalse(task.done())
                        release.set()
                        result = await asyncio.wait_for(task, timeout=1)
                    self.assertEqual(result.outcomes[0].status, "acquired")
                finally:
                    release.set()
                    await asyncio.to_thread(holder.join, 1)

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(root))

    def test_cancellation_waits_for_publication_and_releases_the_store_lease(self) -> None:
        plan = artifact_plan((planned_artifact("pdf"),))
        entered = threading.Event()
        release = threading.Event()
        original_publish = AcquisitionItem.publish_download

        def delayed_publish(
            item: AcquisitionItem,
            partial: Path,
            form: AcquiredArtifact,
        ) -> Path:
            entered.set()
            if not release.wait(2):
                raise AssertionError("test did not release delayed publication")
            return original_publish(item, partial, form)

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(200, content=PDF)

        async def exercise(root: str) -> None:
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    service, _ = acquisition_service(
                        plan,
                        HttpClient(raw, utc_now=lambda: NOW),
                        store,
                    )
                    with mock.patch.object(AcquisitionItem, "publish_download", delayed_publish):
                        task = asyncio.create_task(
                            service.acquire(
                                ArtifactAcquisitionRequest(
                                    provider="arxiv",
                                    identifier="2008.10579v1",
                                    artifacts=("pdf",),
                                )
                            )
                        )
                        self.assertTrue(await asyncio.to_thread(entered.wait, 1))
                        task.cancel()
                        await asyncio.sleep(0)
                        self.assertFalse(task.done())
                        release.set()
                        with self.assertRaises(asyncio.CancelledError):
                            await task

                    manifest = await asyncio.to_thread(service.inspect, plan.deposit_slug)
                    self.assertEqual(tuple(form.kind for form in manifest.forms), ("pdf",))
                    self.assertFalse(
                        any(
                            path.name in {".download.part", ".acquisition-publish.json"}
                            for path in (Path(root) / plan.deposit_slug).iterdir()
                        )
                    )

        try:
            with tempfile.TemporaryDirectory() as root:
                asyncio.run(exercise(root))
        finally:
            release.set()

    def test_acquire_publishes_receipt_and_reuses_valid_existing_form(self) -> None:
        calls = 0

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal calls
            calls += 1
            return httpx.Response(
                200,
                content=PDF,
                headers={"content-type": "application/pdf"},
            )

        async def exercise(root: str) -> None:
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    service, planner = acquisition_service(
                        artifact_plan((planned_artifact("pdf"),)),
                        HttpClient(raw, utc_now=lambda: NOW),
                        store,
                    )
                    request = ArtifactAcquisitionRequest(
                        provider="arxiv", identifier="2008.10579v1", artifacts=("pdf",)
                    )
                    first = await service.acquire(request)
                    second = await service.acquire(request)

            self.assertEqual(first.outcomes[0].status, "acquired")
            self.assertEqual(second.outcomes[0].status, "already-present")
            self.assertEqual(first.manifest, second.manifest)
            self.assertEqual(planner.calls, 2)
            manifest_path = Path(first.manifest_path)
            self.assertTrue(manifest_path.is_file())
            self.assertEqual(AcquisitionManifest.model_validate_json(manifest_path.read_bytes()), first.manifest)
            self.assertEqual(
                measure_artifact_file(Path(first.staging_directory) / first.outcomes[0].path),
                (len(PDF), hashlib.sha256(PDF).hexdigest()),
            )
            self.assertFalse((manifest_path.parent / ".download.part").exists())

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(root))
        self.assertEqual(calls, 1)

    def test_partial_outcome_keeps_independently_valid_payload(self) -> None:
        def handler(request: httpx.Request) -> httpx.Response:
            body = b"not a gzip stream" if request.url.path == "/source" else PDF
            return httpx.Response(200, content=body)

        async def exercise(root: str) -> None:
            plan = artifact_plan(
                (planned_artifact("source"), planned_artifact("pdf")),
                requested=("source", "pdf"),
            )
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    service, _ = acquisition_service(
                        plan,
                        HttpClient(raw, utc_now=lambda: NOW),
                        store,
                    )
                    result = await service.acquire(
                        ArtifactAcquisitionRequest(
                            provider="arxiv",
                            identifier="2008.10579v1",
                            artifacts=("source", "pdf"),
                        )
                    )

            self.assertEqual(tuple(item.status for item in result.outcomes), ("error", "acquired"))
            self.assertIn("gzip payload", result.outcomes[0].error)
            self.assertEqual(tuple(form.kind for form in result.manifest.forms), ("pdf",))
            item_dir = Path(result.staging_directory)
            self.assertFalse((item_dir / "arXiv-2008.10579v1.tar.gz").exists())
            self.assertTrue((item_dir / "2008.10579v1.pdf").is_file())
            self.assertFalse(any(path.name.endswith(".part") for path in item_dir.iterdir()))

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(root))

    def test_checksum_and_magic_failures_publish_no_receipt(self) -> None:
        wrong_checksum = ChecksumExpectation(algorithm="md5", digest="0" * 32)

        def handler(request: httpx.Request) -> httpx.Response:
            if request.url.path == "/source":
                return httpx.Response(200, content=SOURCE)
            return httpx.Response(200, content=b"not a pdf")

        async def exercise(root: str) -> None:
            plan = artifact_plan(
                (
                    planned_artifact("source", checksum=wrong_checksum),
                    planned_artifact("pdf"),
                ),
                requested=("source", "pdf"),
            )
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    service, _ = acquisition_service(
                        plan,
                        HttpClient(raw, utc_now=lambda: NOW),
                        store,
                    )
                    result = await service.acquire(
                        ArtifactAcquisitionRequest(
                            provider="arxiv",
                            identifier="2008.10579v1",
                            artifacts=("source", "pdf"),
                        )
                    )

            self.assertEqual(tuple(item.status for item in result.outcomes), ("error", "error"))
            self.assertIn("provider checksum", result.outcomes[0].error)
            self.assertIn("PDF payload", result.outcomes[1].error)
            self.assertIsNone(result.manifest)
            self.assertIsNone(result.manifest_path)
            item_dir = Path(result.staging_directory)
            self.assertFalse((item_dir / "acquisition.json").exists())
            self.assertEqual(list(item_dir.iterdir()), [])

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(root))

    def test_recovery_finishes_journaled_partial_before_network_retrieval(self) -> None:
        plan = artifact_plan((planned_artifact("pdf"),))

        async def exercise(root: str) -> None:
            with opened_acquisition_store(root) as store:
                form = acquired_artifact("pdf", PDF)
                with store.transaction("2008.10579v1") as item:
                    partial = item.private_download_path()
                    self.assertEqual(partial.name, ".download.part")
                    with item.open_file(partial, "xb") as handle:
                        handle.write(PDF)
                    journal = item.write_journal(plan.artifact, partial, form)
                    self.assertEqual(journal.name, ".acquisition-publish.json")

                def forbidden(request: httpx.Request) -> httpx.Response:
                    raise AssertionError("recovery should satisfy the planned payload")

                async with httpx.AsyncClient(transport=httpx.MockTransport(forbidden)) as raw:
                    service, _ = acquisition_service(
                        plan,
                        HttpClient(raw, utc_now=lambda: NOW),
                        store,
                    )
                    result = await service.acquire(
                        ArtifactAcquisitionRequest(
                            provider="arxiv", identifier="2008.10579v1", artifacts=("pdf",)
                        )
                    )

            self.assertEqual(result.outcomes[0].status, "already-present")
            item_dir = Path(result.staging_directory)
            self.assertTrue((item_dir / "2008.10579v1.pdf").is_file())
            self.assertTrue((item_dir / "acquisition.json").is_file())
            self.assertFalse((item_dir / ".acquisition-publish.json").exists())
            self.assertFalse((item_dir / ".download.part").exists())

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(root))


if __name__ == "__main__":
    unittest.main()
