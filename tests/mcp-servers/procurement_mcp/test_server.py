"""In-memory MCP contract for the Python procurement server."""

from __future__ import annotations

import asyncio
import base64
import copy
import hashlib
import os
import tempfile
import unittest
from datetime import datetime, timezone
from types import SimpleNamespace

import httpx
import jsonschema
from mcp import Client

from procurement_mcp.server import create_server
from procurement.application import ProcurementApplication
from procurement.errors import ProviderError
from procurement.transport.http import HttpClient
from procurement.limits import MAX_API_RESPONSE_BASE64_CHARS
from procurement.domain.acquisition.receipts import (
    AcquiredArtifact,
    AcquisitionManifest,
    AcquisitionOutcome,
    AcquisitionResult,
    LocalImportProvenance,
    acquisition_manifest_schema,
)
from procurement.domain.acquisition.planning import (
    ArtifactAcquisitionRequest,
    ArtifactPlan,
    PlannedArtifact,
    RetrievalCandidate,
    UnavailableArtifact,
)
from procurement.domain.deposits import (
    PORTABLE_LEAF_MAX_UTF16_UNITS,
    PORTABLE_LEAF_PATTERN,
)
from procurement.domain.discovery import SearchPage, SearchRequest
from procurement.domain.metadata import (
    ApiResponseEvidence,
    ArtifactReference,
    RetrievedMetadata,
)
from procurement.domain.works import (
    SourceReference,
    WorkRecord,
)
from procurement.providers.base import Capability, ProviderRole
from procurement.providers.catalog import ProviderBinding, ProviderCatalog
from procurement.domain.materialization import SourceMaterializationResult
from procurement.operations.discovery import DiscoveryService
from procurement.operations.acquisition import AcquisitionService
from procurement.operations.local_import import (
    LocalImportInbox,
    LocalImportInboxCatalog,
)
from procurement.operations.metadata import MetadataService
from procurement.storage.roots import ProcurementRootCatalog
from procurement.storage.acquisitions import AcquisitionStore
from procurement.transport.http import RequestPolicy


def application_roots(parent: str) -> ProcurementRootCatalog:
    """Open one complete configured-root set for a direct application fixture."""

    staging = os.path.join(parent, "staging")
    catalog = os.path.join(parent, "catalog")
    inbox = os.path.join(parent, "inbox")
    for path in (staging, catalog, inbox):
        os.mkdir(path)
    return ProcurementRootCatalog(
        staging,
        article_catalogs={"inventory": catalog},
        local_inboxes={"manual": inbox},
    ).open()


class StaticCatalogService:
    def __init__(self) -> None:
        self.descriptor = SimpleNamespace(name="inventory", catalog_dir="D:/catalog")

    def catalogs(self):
        return (self.descriptor,)

    def resolve(self, name: str):
        if name.casefold() != "inventory":
            raise ValueError("unknown catalog")
        return self.descriptor

    def inspect(self, name: str):
        self.resolve(name)
        return SimpleNamespace(
            name="inventory",
            catalog_dir="D:/catalog",
            article_count=2,
            slugs=("a", "b"),
            has_inventory=False,
        )

    def rebuild(self, name: str, *, force: bool = False):
        self.resolve(name)
        return SimpleNamespace(
            catalog_dir="D:/catalog",
            inventory_path="D:/catalog/inventory.jsonl",
            article_count=2,
            slugs=["a", "b"],
        )

    def fold(self, name: str, *, force: bool = False):
        self.resolve(name)
        return SimpleNamespace(
            catalog_dir="D:/catalog",
            inventory_path="D:/catalog/inventory.jsonl",
            article_count=2,
            slugs=["a", "b"],
        )


class RecordingMaterializationService:
    def __init__(self) -> None:
        self.requests = []

    async def materialize(self, request):
        self.requests.append(request)
        return SourceMaterializationResult(
            catalog=request.catalog,
            slug=request.acquisition_slug,
            status="deposited",
            created=True,
            artifact=ArtifactReference(
                provider="arxiv",
                identifier=request.acquisition_slug,
                provider_roles=(
                    "artifact-origin",
                    "artifact-access",
                    "metadata-authority",
                ),
            ),
            acquisition_manifest_path="D:/staging/acquisition.json",
            document_directory="D:/catalog/2008.10579v1",
            article_path="D:/catalog/2008.10579v1/article.json",
            archive_path="D:/catalog/2008.10579v1/2008.10579v1.tar.gz",
            source_path="D:/catalog/2008.10579v1/2008.10579v1-tex",
            metadata_path="D:/catalog/2008.10579v1/2008.10579v1.api-metadata.json",
            archive_sha256="a" * 64,
            tree_sha256="b" * 64,
            archive_kind="tar+gzip",
            entrypoint="main.tex",
            metadata_route="artifact-provider",
        )


class RecordingLocalImportService:
    def __init__(self) -> None:
        self.requests = []

    def inboxes(self) -> LocalImportInboxCatalog:
        return LocalImportInboxCatalog(inboxes=(LocalImportInbox(name="manual"),))

    async def import_artifact(self, request):
        self.requests.append(request)
        body = b"%PDF-1.7\n%%EOF\n"
        manifest = AcquisitionManifest(
            slug=request.deposit_slug,
            artifact=ArtifactReference(
                provider="manual-import",
                identifier=request.deposit_slug,
                provider_roles=("artifact-access",),
            ),
            forms=(
                AcquiredArtifact(
                    kind="pdf",
                    path=f"{request.deposit_slug}.pdf",
                    format="application/pdf",
                    bytes=len(body),
                    sha256=hashlib.sha256(body).hexdigest(),
                    custody="local-import",
                    local_import=LocalImportProvenance(
                        inbox=request.inbox,
                        leaf=request.leaf,
                        imported_at=datetime(2026, 8, 11, tzinfo=timezone.utc),
                    ),
                ),
            ),
        )
        return AcquisitionResult(
            staging_directory=f"D:/staging/{request.deposit_slug}",
            manifest_path=f"D:/staging/{request.deposit_slug}/acquisition.json",
            manifest=manifest,
            outcomes=(
                AcquisitionOutcome(
                    kind="pdf",
                    status="acquired",
                    path=f"{request.deposit_slug}.pdf",
                ),
            ),
        )


class StaticAcquisitionService:
    def inspect(self, slug: str, *, catalog: str | None = None) -> AcquisitionManifest:
        return AcquisitionManifest(
            slug=slug,
            artifact=ArtifactReference(
                provider="manual-import",
                identifier=slug,
                provider_roles=("artifact-access",),
            ),
            forms=(
                AcquiredArtifact(
                    kind="pdf",
                    path=f"{slug}.pdf",
                    format="application/pdf",
                    bytes=5,
                    sha256="a" * 64,
                    custody="local-import",
                    local_import=LocalImportProvenance(
                        inbox="manual",
                        leaf="paper.pdf",
                        imported_at=datetime(2026, 8, 11, tzinfo=timezone.utc),
                    ),
                ),
            ),
        )


class StaticProvider:
    name = "arxiv"
    search_constraints = frozenset()

    async def search(self, request: SearchRequest) -> SearchPage:
        return SearchPage(
            provider=self.name,
            total_available=1,
            start=request.start,
            works=(
                WorkRecord(
                    title="A paper",
                    doi="10.1/X",
                    sources=(SourceReference(provider=self.name, identifier="W1", doi="10.1/X"),),
                ),
            ),
        )

    async def get_metadata(self, identifier: str) -> RetrievedMetadata:
        body = b'<feed xmlns="http://www.w3.org/2005/Atom" />'
        return RetrievedMetadata(
            work=WorkRecord(
                title="A paper",
                doi="10.1/X",
                arxiv_id="2008.10579v1",
                categories=("math.OC",),
                sources=(
                    SourceReference(
                        provider=self.name,
                        identifier="2008.10579v1",
                        doi="10.1/X",
                        arxiv_id="2008.10579v1",
                    ),
                ),
            ),
            response=ApiResponseEvidence(
                url="https://export.arxiv.org/api/query?id_list=2008.10579v1",
                media_type="application/atom+xml",
                fetched_at=datetime(2026, 8, 11, tzinfo=timezone.utc),
                sha256=hashlib.sha256(body).hexdigest(),
                body_base64=base64.b64encode(body).decode("ascii"),
            ),
        )

    async def get_work(self, identifier: str) -> WorkRecord:
        return WorkRecord(
            title="A paper",
            doi="10.1/X",
            sources=(
                SourceReference(provider=self.name, identifier=identifier, doi="10.1/X"),
            ),
        )

    async def related(self, identifier: str, kind: str, limit: int) -> tuple[WorkRecord, ...]:
        del kind, limit
        return (await self.get_work(f"related:{identifier}"),)

    async def resolve(self, reference: str) -> tuple[WorkRecord, ...]:
        return (await self.get_work(f"resolved:{reference}"),)

    async def plan_artifact(self, request: ArtifactAcquisitionRequest) -> ArtifactPlan:
        payloads = tuple(
            PlannedArtifact(
                kind="pdf",
                target_leaf="2008.10579v1.pdf",
                media_type="application/pdf",
                payload_kind="pdf",
                maximum_bytes=1024,
                candidates=(
                    RetrievalCandidate(
                        candidate_id="protocol-pdf",
                        url="https://provider.test/pdf",
                        allowed_hosts=("provider.test",),
                    ),
                ),
            )
            for kind in request.artifacts
            if kind == "pdf"
        )
        unavailable = tuple(
            UnavailableArtifact(kind=kind, reason="not used by the protocol fixture")
            for kind in request.artifacts
            if kind != "pdf"
        )
        return ArtifactPlan(
            artifact=ArtifactReference(
                provider="arxiv",
                identifier="2008.10579v1",
                provider_roles=(
                    "artifact-origin",
                    "artifact-access",
                    "metadata-authority",
                ),
            ),
            deposit_slug="2008.10579v1",
            requested=request.artifacts,
            payloads=payloads,
            unavailable=unavailable,
        )


class AggregatorProvider:
    name = "openalex"

    async def get_metadata(self, identifier: str) -> RetrievedMetadata:
        raise AssertionError("authority should satisfy this request")


class FailingAuthority(StaticProvider):
    def __init__(self) -> None:
        self.metadata_calls = 0

    async def get_metadata(self, identifier: str) -> RetrievedMetadata:
        self.metadata_calls += 1
        raise ProviderError("authority unavailable")


class RecordingAggregator:
    name = "semanticscholar"

    def __init__(self) -> None:
        self.identifiers: list[str] = []

    async def get_metadata(self, identifier: str) -> RetrievedMetadata:
        self.identifiers.append(identifier)
        body = b'{"id":"W1"}'
        return RetrievedMetadata(
            work=WorkRecord(
                title="Fallback paper",
                doi="10.1000/example",
                arxiv_id="2008.10579",
                concepts=("Optimization",),
                sources=(
                    SourceReference(
                        provider=self.name,
                        identifier="W1",
                        doi="10.1000/example",
                        arxiv_id="2008.10579",
                    ),
                ),
            ),
            response=ApiResponseEvidence(
                url="https://api.semanticscholar.org/graph/v1/paper/W1",
                media_type="application/json",
                fetched_at=datetime(2026, 8, 11, tzinfo=timezone.utc),
                sha256=hashlib.sha256(body).hexdigest(),
                body_base64=base64.b64encode(body).decode("ascii"),
            ),
        )


class TestProcurementMcp(unittest.TestCase):
    def test_lists_and_calls_discovery_tool_with_structured_output(self) -> None:
        async def exercise(roots: ProcurementRootCatalog) -> None:
            provider = StaticProvider()
            aggregator = AggregatorProvider()
            registry = ProviderCatalog(
                [
                    ProviderBinding(
                        provider,
                        frozenset(
                            {
                                Capability.SEARCH,
                                Capability.GET_WORK,
                                Capability.CITATIONS,
                                Capability.REFERENCES,
                                Capability.RECOMMENDATIONS,
                                Capability.RESOLVE,
                                Capability.METADATA,
                                Capability.PLAN_ARTIFACT,
                            }
                        ),
                        frozenset(
                            {
                                ProviderRole.ARTIFACT_ORIGIN,
                                ProviderRole.ARTIFACT_ACCESS,
                                ProviderRole.METADATA_AUTHORITY,
                            }
                        ),
                    ),
                    ProviderBinding(
                        aggregator,
                        frozenset({Capability.METADATA}),
                        frozenset({ProviderRole.METADATA_AGGREGATOR}),
                    ),
                ]
            )
            service = DiscoveryService(registry, ("arxiv",))
            metadata = MetadataService(registry, ("openalex",))
            materialization = RecordingMaterializationService()
            local_import = RecordingLocalImportService()
            def handler(request: httpx.Request) -> httpx.Response:
                if request.url.host == "provider.test" and request.url.path == "/pdf":
                    return httpx.Response(
                        200,
                        content=b"%PDF-1.7\nprotocol\n%%EOF\n",
                        headers={"content-type": "application/pdf"},
                    )
                return httpx.Response(500)

            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                http = HttpClient(raw, utc_now=lambda: datetime(2026, 8, 11, tzinfo=timezone.utc))
                application = ProcurementApplication(
                    providers=registry,
                    discovery=service,
                    metadata=metadata,
                    http=http,
                    roots=roots,
                    acquisition=AcquisitionService(
                        registry,
                        http,
                        AcquisitionStore(roots.staging, lock_timeout=2),
                        provider_policies={
                            "arxiv": RequestPolicy(
                                max_attempts=1,
                                max_decoded_body_bytes=1024,
                            )
                        },
                    ),
                    catalogs=StaticCatalogService(),
                    local_import=local_import,
                    materialization=materialization,
                )
                server = create_server(application)
                async with Client(server) as client:
                    tools = await client.list_tools()
                    tools_by_name = {tool.name: tool for tool in tools.tools}
                    self.assertEqual(
                        set(tools_by_name),
                        {
                            "discover_search",
                            "discover_related",
                            "resolve_reference",
                            "get_work",
                            "prepare_source_deposit_metadata",
                            "prepare_article_metadata_by_doi",
                            "plan_artifact_acquisition",
                            "acquire_artifact",
                            "get_acquisition_receipt",
                            "list_local_import_inboxes",
                            "import_local_artifact",
                            "materialize_source_deposit",
                            "procure_source",
                            "list_article_catalogs",
                            "inspect_article_catalog",
                            "rebuild_article_inventory",
                            "fold_article_inventory",
                            "list_procurement_providers",
                        },
                    )
                    receipt_output = tools_by_name[
                        "get_acquisition_receipt"
                    ].model_dump(mode="json", by_alias=True)["outputSchema"]
                    acquisition_output = tools_by_name[
                        "acquire_artifact"
                    ].model_dump(mode="json", by_alias=True)["outputSchema"]
                    self.assertEqual(receipt_output, acquisition_manifest_schema())
                    self.assertEqual(
                        acquisition_output,
                        AcquisitionResult.model_json_schema(
                            mode="serialization", by_alias=True
                        ),
                    )
                    jsonschema.Draft202012Validator.check_schema(receipt_output)
                    jsonschema.Draft202012Validator.check_schema(acquisition_output)
                    self.assertEqual(
                        receipt_output["$defs"]["ChecksumExpectation"]["allOf"],
                        acquisition_output["$defs"]["ChecksumExpectation"]["allOf"],
                    )
                    self.assertEqual(
                        receipt_output["$defs"]["AcquiredArtifact"]["properties"][
                            "origin_url"
                        ]["pattern"],
                        acquisition_output["$defs"]["AcquiredArtifact"]["properties"][
                            "origin_url"
                        ]["pattern"],
                    )
                    self.assertEqual(
                        receipt_output["allOf"],
                        acquisition_output["$defs"]["AcquisitionManifest"]["allOf"],
                    )
                    self.assertEqual(len(acquisition_output["allOf"]), 2)
                    self.assertEqual(
                        len(
                            acquisition_output["$defs"]["AcquisitionOutcome"][
                                "allOf"
                            ]
                        ),
                        1,
                    )

                    receipt = AcquisitionManifest(
                        slug="2008.10579v1",
                        artifact=ArtifactReference(
                            provider="arxiv",
                            identifier="2008.10579v1",
                            provider_roles=(
                                "artifact-origin",
                                "artifact-access",
                                "metadata-authority",
                            ),
                        ),
                        forms=(
                            AcquiredArtifact(
                                kind="source",
                                path="arXiv-2008.10579v1.tar.gz",
                                format="application/gzip",
                                bytes=1,
                                sha256="a" * 64,
                                origin_url="https://arxiv.org/e-print/2008.10579v1",
                                candidate_id="arxiv-export-source",
                                fetched_at=datetime(2026, 8, 11, tzinfo=timezone.utc),
                            ),
                        ),
                    )
                    successful = AcquisitionResult(
                        staging_directory="D:/staging/2008.10579v1",
                        manifest_path="D:/staging/2008.10579v1/acquisition.json",
                        manifest=receipt,
                        outcomes=(
                            AcquisitionOutcome(
                                kind="source",
                                status="acquired",
                                path="arXiv-2008.10579v1.tar.gz",
                            ),
                        ),
                    ).model_dump(mode="json", by_alias=True)
                    result_validator = jsonschema.Draft202012Validator(
                        acquisition_output
                    )
                    result_validator.validate(successful)

                    success_without_manifest = copy.deepcopy(successful)
                    success_without_manifest["manifest"] = None
                    success_without_manifest["manifest_path"] = None
                    self.assertFalse(
                        result_validator.is_valid(success_without_manifest)
                    )
                    split_manifest_pair = copy.deepcopy(successful)
                    split_manifest_pair["manifest_path"] = None
                    self.assertFalse(result_validator.is_valid(split_manifest_pair))
                    contradictory_outcome = copy.deepcopy(successful)
                    contradictory_outcome["outcomes"][0]["error"] = "unexpected"
                    self.assertFalse(result_validator.is_valid(contradictory_outcome))

                    search_tool = tools_by_name["discover_search"].model_dump(
                        mode="json", by_alias=True
                    )
                    search_input = search_tool["inputSchema"]
                    self.assertEqual(search_input["properties"]["query"]["minLength"], 1)
                    self.assertEqual(search_input["properties"]["start"]["minimum"], 0)
                    self.assertEqual(search_input["properties"]["max_results"]["maximum"], 100)
                    self.assertEqual(search_input["properties"]["source"]["minLength"], 1)
                    self.assertNotIn("enum", search_input["properties"]["source"])

                    related_tool = tools_by_name["discover_related"].model_dump(
                        mode="json", by_alias=True
                    )
                    self.assertEqual(
                        related_tool["inputSchema"]["properties"]["max_results"]["maximum"],
                        50,
                    )

                    metadata_tool = tools_by_name[
                        "prepare_source_deposit_metadata"
                    ].model_dump(mode="json", by_alias=True)
                    metadata_input = metadata_tool["inputSchema"]
                    self.assertEqual(
                        metadata_input["properties"]["deposit_slug"]["pattern"],
                        PORTABLE_LEAF_PATTERN,
                    )
                    self.assertEqual(
                        metadata_input["properties"]["deposit_slug"]["maxLength"],
                        PORTABLE_LEAF_MAX_UTF16_UNITS,
                    )
                    metadata_output = metadata_tool["outputSchema"]
                    self.assertEqual(
                        set(metadata_output["required"]),
                        {
                            "schema",
                            "deposit_slug",
                            "artifact",
                            "route",
                            "selected",
                            "attempts",
                            "article",
                        },
                    )
                    definitions = metadata_output["$defs"]
                    self.assertEqual(
                        set(definitions["ArticleMetadataProjection"]["required"]),
                        set(definitions["ArticleMetadataProjection"]["properties"]),
                    )
                    self.assertEqual(
                        set(definitions["ArticleIdentifiers"]["required"]),
                        set(definitions["ArticleIdentifiers"]["properties"]),
                    )
                    self.assertIn("error", definitions["MetadataAttempt"]["required"])
                    self.assertEqual(len(definitions["MetadataAttempt"]["allOf"]), 1)
                    self.assertEqual(metadata_output["properties"]["attempts"]["minItems"], 1)
                    self.assertTrue(
                        metadata_output["properties"]["attempts"]["uniqueItems"]
                    )
                    self.assertIn(
                        "contains",
                        definitions["ArtifactReference"]["properties"]["provider_roles"],
                    )
                    self.assertTrue(
                        definitions["ArtifactReference"]["properties"]["provider_roles"][
                            "uniqueItems"
                        ]
                    )
                    self.assertIn(
                        "pattern",
                        definitions["ApiResponseEvidence"]["properties"]["body_base64"],
                    )
                    self.assertEqual(
                        definitions["ApiResponseEvidence"]["properties"]["body_base64"][
                            "maxLength"
                        ],
                        MAX_API_RESPONSE_BASE64_CHARS,
                    )
                    self.assertEqual(len(metadata_output["allOf"]), 3)

                    doi_metadata_tool = tools_by_name[
                        "prepare_article_metadata_by_doi"
                    ].model_dump(mode="json", by_alias=True)
                    self.assertEqual(
                        doi_metadata_tool["inputSchema"]["properties"]["acquisition_slug"][
                            "pattern"
                        ],
                        PORTABLE_LEAF_PATTERN,
                    )
                    self.assertIn(
                        "identifier-aggregator",
                        doi_metadata_tool["outputSchema"]["properties"]["route"]["enum"],
                    )

                    source_tool = tools_by_name["materialize_source_deposit"].model_dump(
                        mode="json", by_alias=True
                    )
                    source_input = source_tool["inputSchema"]
                    self.assertEqual(
                        source_input["properties"]["acquisition_slug"]["pattern"],
                        PORTABLE_LEAF_PATTERN,
                    )
                    metadata_schema = source_input["properties"]["metadata"]
                    union_schema = next(
                        branch
                        for branch in metadata_schema["anyOf"]
                        if "oneOf" in branch
                    )
                    self.assertEqual(
                        set(union_schema["discriminator"]["mapping"]),
                        {"artifact-identity", "explicit-doi", "omit"},
                    )
                    self.assertIn(
                        "[Tt][Ee][Xx]",
                        source_input["properties"]["main_tex"]["anyOf"][0]["pattern"],
                    )

                    local_import_tool = tools_by_name["import_local_artifact"].model_dump(
                        mode="json", by_alias=True
                    )
                    self.assertEqual(
                        set(local_import_tool["inputSchema"]["properties"]),
                        {"inbox", "leaf", "deposit_slug", "catalog"},
                    )
                    for field in ("inbox", "leaf", "deposit_slug"):
                        self.assertEqual(
                            local_import_tool["inputSchema"]["properties"][field][
                                "pattern"
                            ],
                            PORTABLE_LEAF_PATTERN,
                        )
                        self.assertEqual(
                            local_import_tool["inputSchema"]["properties"][field][
                                "maxLength"
                            ],
                            PORTABLE_LEAF_MAX_UTF16_UNITS,
                        )

                    catalog_list = await client.call_tool("list_article_catalogs", {})
                    self.assertFalse(catalog_list.is_error)
                    self.assertEqual(
                        catalog_list.structured_content,
                        {"catalogs": [{"name": "inventory"}]},
                    )
                    catalog_snapshot = await client.call_tool(
                        "inspect_article_catalog", {"catalog": "inventory"}
                    )
                    self.assertFalse(catalog_snapshot.is_error)
                    self.assertEqual(
                        catalog_snapshot.structured_content,
                        {
                            "name": "inventory",
                            "article_count": 2,
                            "slugs": ["a", "b"],
                            "has_inventory": False,
                        },
                    )
                    inventory_result = await client.call_tool(
                        "rebuild_article_inventory",
                        {"catalog": "inventory", "force": True},
                    )
                    self.assertFalse(inventory_result.is_error)
                    self.assertEqual(
                        inventory_result.structured_content,
                        {
                            "catalog": "inventory",
                            "article_count": 2,
                            "slugs": ["a", "b"],
                        },
                    )

                    inboxes = await client.call_tool("list_local_import_inboxes", {})
                    self.assertFalse(inboxes.is_error)
                    self.assertEqual(
                        inboxes.structured_content["inboxes"],
                        [{"name": "manual"}],
                    )
                    imported = await client.call_tool(
                        "import_local_artifact",
                        {
                            "inbox": "manual",
                            "leaf": "paper.pdf",
                            "deposit_slug": "doi-paper",
                        },
                    )
                    self.assertFalse(imported.is_error)
                    self.assertEqual(
                        imported.structured_content["manifest"]["forms"][0]["custody"],
                        "local-import",
                    )
                    self.assertEqual(local_import.requests[0].leaf, "paper.pdf")

                    source_result = await client.call_tool(
                        "materialize_source_deposit",
                        {
                            "catalog": "inventory",
                            "acquisition_slug": "2008.10579v1",
                            "metadata": {
                                "mode": "artifact-identity",
                                "fallback_sources": [],
                            },
                        },
                    )
                    self.assertFalse(source_result.is_error)
                    self.assertEqual(source_result.structured_content["status"], "deposited")
                    self.assertEqual(
                        materialization.requests[0].metadata_fallback_sources,
                        (),
                    )
                    related = await client.call_tool(
                        "discover_related",
                        {
                            "identifier": "W1",
                            "kind": "citations",
                            "source": "arxiv",
                            "max_results": 3,
                        },
                    )
                    self.assertFalse(related.is_error)
                    self.assertEqual(related.structured_content["kind"], "citations")

                    resolved = await client.call_tool(
                        "resolve_reference",
                        {"reference": "10.1/X", "source": "arxiv"},
                    )
                    self.assertFalse(resolved.is_error)
                    self.assertEqual(resolved.structured_content["provider"], "arxiv")

                    work = await client.call_tool(
                        "get_work",
                        {"identifier": "W1", "source": "arxiv"},
                    )
                    self.assertFalse(work.is_error)
                    self.assertEqual(work.structured_content["doi"], "10.1/x")

                    plan = await client.call_tool(
                        "plan_artifact_acquisition",
                        {
                            "provider": "arxiv",
                            "identifier": "2008.10579v1",
                            "artifacts": ["pdf"],
                        },
                    )
                    self.assertFalse(plan.is_error)
                    self.assertEqual(plan.structured_content["deposit_slug"], "2008.10579v1")
                    self.assertEqual(plan.structured_content["payloads"][0]["kind"], "pdf")
                    self.assertNotIn("url", plan.structured_content["payloads"][0])

                    acquired = await client.call_tool(
                        "acquire_artifact",
                        {
                            "provider": "arxiv",
                            "identifier": "2008.10579v1",
                            "artifacts": ["pdf"],
                        },
                    )
                    self.assertFalse(acquired.is_error)
                    self.assertEqual(acquired.structured_content["outcomes"][0]["status"], "acquired")

                    staged_receipt = await client.call_tool(
                        "get_acquisition_receipt",
                        {"deposit_slug": "2008.10579v1"},
                    )
                    self.assertFalse(staged_receipt.is_error)
                    self.assertEqual(staged_receipt.structured_content["forms"][0]["kind"], "pdf")

                    result = await client.call_tool(
                        "discover_search",
                        {"query": "persistent homology", "source": "arxiv", "max_results": 5},
                    )
                    self.assertFalse(result.is_error)
                    assert result.structured_content is not None
                    self.assertEqual(result.structured_content["returned"], 1)
                    record = result.structured_content["works"][0]
                    self.assertEqual(record["doi"], "10.1/x")
                    self.assertEqual(record["sources"][0]["identifier"], "W1")

                    metadata_result = await client.call_tool(
                        "prepare_source_deposit_metadata",
                        {
                            "deposit_slug": "2008.10579v1",
                            "artifact_provider": "arxiv",
                            "identifier": "2008.10579v1",
                        },
                    )
                    self.assertFalse(metadata_result.is_error)
                    assert metadata_result.structured_content is not None
                    self.assertEqual(
                        metadata_result.structured_content["schema"],
                        "codex-scientiae/deposit-metadata/0.1",
                    )
                    self.assertEqual(
                        metadata_result.structured_content["route"],
                        "artifact-provider",
                    )

                    catalog = await client.call_tool("list_procurement_providers", {})
                    self.assertFalse(catalog.is_error)
                    assert catalog.structured_content is not None
                    declared = {
                        item["name"]: item["roles"]
                        for item in catalog.structured_content["providers"]
                    }
                    constraints = {
                        item["name"]: item["search_constraints"]
                        for item in catalog.structured_content["providers"]
                    }
                    categories = {
                        item["name"]: item["category"]
                        for item in catalog.structured_content["providers"]
                    }
                    self.assertIn("artifact-access", declared["arxiv"])
                    self.assertEqual(declared["openalex"], ["metadata-aggregator"])
                    self.assertEqual(constraints, {"arxiv": [], "openalex": []})
                    self.assertEqual(
                        categories,
                        {"arxiv": "repository", "openalex": "aggregator"},
                    )

                    prompt = await client.get_prompt("discovery_procedure")
                    self.assertIn("untrusted external text", prompt.messages[0].content.text)

                    invalid_slug = await client.call_tool(
                        "prepare_source_deposit_metadata",
                        {
                            "deposit_slug": "CON",
                            "artifact_provider": "arxiv",
                            "identifier": "2008.10579v1",
                        },
                    )
                    self.assertTrue(invalid_slug.is_error)

                    invalid_query = await client.call_tool(
                        "discover_search",
                        {"query": "   ", "source": "arxiv"},
                    )
                    self.assertTrue(invalid_query.is_error)

        with tempfile.TemporaryDirectory() as root_parent:
            roots = application_roots(root_parent)
            try:
                asyncio.run(exercise(roots))
            finally:
                roots.close()

    def test_explicit_empty_metadata_fallback_is_preserved_by_the_protocol(self) -> None:
        async def exercise(roots: ProcurementRootCatalog) -> None:
            authority = FailingAuthority()
            aggregator = RecordingAggregator()
            registry = ProviderCatalog(
                [
                    ProviderBinding(
                        authority,
                        frozenset({Capability.SEARCH, Capability.METADATA}),
                        frozenset(
                            {
                                ProviderRole.ARTIFACT_ORIGIN,
                                ProviderRole.ARTIFACT_ACCESS,
                                ProviderRole.METADATA_AUTHORITY,
                            }
                        ),
                    ),
                    ProviderBinding(
                        aggregator,
                        frozenset({Capability.METADATA}),
                        frozenset({ProviderRole.METADATA_AGGREGATOR}),
                    ),
                ]
            )
            async with httpx.AsyncClient(
                transport=httpx.MockTransport(lambda request: httpx.Response(500))
            ) as raw:
                application = ProcurementApplication(
                    providers=registry,
                    discovery=DiscoveryService(registry, ("arxiv",)),
                    metadata=MetadataService(registry, ("semanticscholar",)),
                    http=HttpClient(raw),
                    roots=roots,
                    acquisition=StaticAcquisitionService(),
                )
                async with Client(create_server(application)) as client:
                    disabled = await client.call_tool(
                        "prepare_source_deposit_metadata",
                        {
                            "deposit_slug": "2008.10579v1",
                            "artifact_provider": "arxiv",
                            "identifier": "2008.10579v1",
                            "fallback_sources": [],
                        },
                    )
                    self.assertTrue(disabled.is_error)
                    self.assertEqual(aggregator.identifiers, [])

                    enabled = await client.call_tool(
                        "prepare_source_deposit_metadata",
                        {
                            "deposit_slug": "2008.10579v1",
                            "artifact_provider": "arxiv",
                            "identifier": "2008.10579v1",
                        },
                    )
                    self.assertFalse(enabled.is_error)
                    self.assertEqual(aggregator.identifiers, ["arxiv:2008.10579"])
                    assert enabled.structured_content is not None
                    self.assertEqual(
                        [attempt["status"] for attempt in enabled.structured_content["attempts"]],
                        ["error", "ok"],
                    )

                    by_doi = await client.call_tool(
                        "prepare_article_metadata_by_doi",
                        {
                            "acquisition_slug": "manual-paper",
                            "doi": "https://doi.org/10.1000/EXAMPLE",
                            "fallback_sources": ["semanticscholar"],
                        },
                    )
                    self.assertFalse(by_doi.is_error)
                    assert by_doi.structured_content is not None
                    self.assertEqual(
                        by_doi.structured_content["route"],
                        "identifier-aggregator",
                    )
                    self.assertEqual(
                        by_doi.structured_content["artifact"]["provider"],
                        "manual-import",
                    )
                    self.assertEqual(
                        by_doi.structured_content["identity_anchor"]["value"],
                        "10.1000/example",
                    )
                    self.assertEqual(
                        aggregator.identifiers[-1],
                        "doi:10.1000/example",
                    )

        with tempfile.TemporaryDirectory() as root_parent:
            roots = application_roots(root_parent)
            try:
                asyncio.run(exercise(roots))
            finally:
                roots.close()
