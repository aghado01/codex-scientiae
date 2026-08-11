"""In-memory MCP contract for the Python procurement server."""

from __future__ import annotations

import asyncio
import base64
import hashlib
import unittest
from datetime import datetime, timezone

import httpx
from mcp import Client

from mcps.procurement.server import create_server
from procurement.composition import ProcurementApplication
from procurement.errors import ProviderError
from procurement.http import HttpClient
from procurement.limits import MAX_API_RESPONSE_BASE64_CHARS
from procurement.models import (
    PORTABLE_LEAF_PATTERN,
    SearchPage,
    SearchRequest,
    SourceReference,
    WorkRecord,
)
from procurement.models import ApiResponseEvidence, RetrievedMetadata
from procurement.providers.base import Capability, ProviderRole
from procurement.registry import ProviderBinding, ProviderRegistry
from procurement.services import DiscoveryService, MetadataService


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
                arxiv_id="2008.10579",
                concepts=("Optimization",),
                sources=(
                    SourceReference(
                        provider=self.name,
                        identifier="W1",
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
        async def exercise() -> None:
            provider = StaticProvider()
            aggregator = AggregatorProvider()
            registry = ProviderRegistry(
                [
                    ProviderBinding(
                        provider,
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
            service = DiscoveryService(registry, ("arxiv",))
            metadata = MetadataService(registry, ("openalex",))
            async with httpx.AsyncClient(transport=httpx.MockTransport(lambda request: httpx.Response(500))) as raw:
                application = ProcurementApplication(
                    discovery=service,
                    metadata=metadata,
                    http=HttpClient(raw),
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
                            "list_procurement_providers",
                        },
                    )
                    search_tool = tools_by_name["discover_search"].model_dump(
                        mode="json", by_alias=True
                    )
                    search_input = search_tool["inputSchema"]
                    self.assertEqual(search_input["properties"]["query"]["minLength"], 1)
                    self.assertEqual(search_input["properties"]["start"]["minimum"], 0)
                    self.assertEqual(search_input["properties"]["max_results"]["maximum"], 100)

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
                    self.assertEqual(len(metadata_output["allOf"]), 2)
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
                    self.assertIn("artifact-access", declared["arxiv"])
                    self.assertEqual(declared["openalex"], ["metadata-aggregator"])
                    self.assertEqual(constraints, {"arxiv": [], "openalex": []})

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

        asyncio.run(exercise())

    def test_explicit_empty_metadata_fallback_is_preserved_by_the_protocol(self) -> None:
        async def exercise() -> None:
            authority = FailingAuthority()
            aggregator = RecordingAggregator()
            registry = ProviderRegistry(
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
                    discovery=DiscoveryService(registry, ("arxiv",)),
                    metadata=MetadataService(registry, ("semanticscholar",)),
                    http=HttpClient(raw),
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

        asyncio.run(exercise())
