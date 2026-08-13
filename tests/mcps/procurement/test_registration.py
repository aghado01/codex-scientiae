"""Registration and lifespan contract for the procurement MCP."""

from __future__ import annotations

import asyncio
import hashlib
import json
import unittest
from importlib.resources import files
from unittest.mock import patch

from mcp import Client

from mcps.procurement.server import create_server
from procurement.operations.local_import import LocalImportInbox, LocalImportInboxCatalog

EXPECTED_TOOLS = (
    (
        "discover_search",
        "Search one provider or fan out, explicitly reporting unsupported constraints.",
    ),
    (
        "discover_related",
        "Traverse citations, references, or semantic recommendations from one work.",
    ),
    (
        "resolve_reference",
        "Resolve a DOI, arXiv identifier, title, or loose citation to ranked works.",
    ),
    (
        "get_work",
        "Return one normalized work while preserving its provider identity.",
    ),
    (
        "prepare_source_deposit_metadata",
        "Build validated article metadata with exact decoded API evidence and fallback.",
    ),
    (
        "prepare_article_metadata_by_doi",
        "Resolve a caller-selected DOI for one existing acquisition receipt.",
    ),
    (
        "plan_artifact_acquisition",
        "Resolve a URL-free acquisition summary without writing artifact bytes.",
    ),
    (
        "acquire_artifact",
        "Acquire validated bytes into configured staging and publish acquisition.json.",
    ),
    (
        "get_acquisition_receipt",
        "Read and revalidate one configured staging acquisition receipt.",
    ),
    (
        "list_local_import_inboxes",
        "List logical local-import inbox names without exposing host paths.",
    ),
    (
        "import_local_artifact",
        "Validate one configured local PDF or gzip source and publish acquisition.json.",
    ),
    (
        "materialize_source_deposit",
        "Validate one staged source and publish article.json using one metadata strategy.",
    ),
    (
        "list_article_catalogs",
        "List configured catalog names accepted by source and inventory operations.",
    ),
    (
        "inspect_article_catalog",
        "Inspect current direct-child article.json membership without writing inventory.",
    ),
    (
        "rebuild_article_inventory",
        "Rebuild inventory.jsonl from every current direct-child article.json sentinel.",
    ),
    (
        "list_procurement_providers",
        "List non-exclusive artifact, authority, aggregator, and access roles.",
    ),
)

EXPECTED_TOOL_SCHEMA_FINGERPRINTS = {
    "discover_search": (
        "d82470cf0f2997e44dee62b3d866a43c5a3ccf7119d5699825fa448902a7798a",
        "ec52c38fa01ff07e0b4ed4645f3558c8699bdac8f3b0e03e5bf3ccfa046c7ca8",
    ),
    "discover_related": (
        "06583892b28100e6de23f41fb17329c9c47f1187b54dd8f8be4943d2353e98a3",
        "5edd3f4149d2d0177028d087a62e77c733d7debb17fc62da7d249c6a534d9b7d",
    ),
    "resolve_reference": (
        "92c9ba358a3a53ec8003a9c96baf6c0b6285bd02283a4e3f7da9bdbb0408a020",
        "8cfa0b98fb53e347338424d42459d2e9883ad4c0e52d95d107aeee5a91ae7b15",
    ),
    "get_work": (
        "82fa3feec2cfd88651aaf304d63f82cd256d8adb822e6216f2059f8a990de37b",
        "358fa9d40645cbc69e978cdce201e2d464cc69fe1a1359801100823515c7ceaa",
    ),
    "prepare_source_deposit_metadata": (
        "1324ae3f3235c6b58365357bc0dbbfb8b1e34e158bb10d9bfc77c667bd6f8a9f",
        "126e73bee9d56850692293a801bd1384d21011e02dc4e6250423b27e3ba0a918",
    ),
    "prepare_article_metadata_by_doi": (
        "1f7c0438e1c567ac77c5f12b038620a542885bf3cdffd55fa5e0063a281d4e54",
        "126e73bee9d56850692293a801bd1384d21011e02dc4e6250423b27e3ba0a918",
    ),
    "plan_artifact_acquisition": (
        "fbad6ed124918a1ccf08abcd68ac1d2020171eec9ce722da8d3e6e0d988cc1d7",
        "fb23423b8f8278317e079d9bcabcf94681e49201fe21ccadb922d17bdef04ab3",
    ),
    "acquire_artifact": (
        "7b6bf4e627c1e57471856da0d9c14e2c5af113d84b02f3082c628b45ed1a3663",
        "22055189a8e472069a57ef5ac69659cf8e9a7996859e951232f417fecb47e5d9",
    ),
    "get_acquisition_receipt": (
        "1ba812e9de4679c41b91591a456e1bd1709f0062c53c289ec695e54dafaa8e4c",
        "8e4855dcd86b6b0b2d504727b6f2eb1d00a88117cbbc2e969e719224eae94358",
    ),
    "list_local_import_inboxes": (
        "67da7e440d1ce50441a2e9ea583d0cabfa91cc525cff23b7bfa9492248570ee9",
        "33b0654bf63661baf0e945f5021c2a1bcc7feb891f1f0789823789831748e4ae",
    ),
    "import_local_artifact": (
        "843eb62908f9a1f60a650dd5901bbf3231cc7875f370da26e45434fb914de589",
        "22055189a8e472069a57ef5ac69659cf8e9a7996859e951232f417fecb47e5d9",
    ),
    "materialize_source_deposit": (
        "33f20344bfab51ed065ae520a23af8c88526115cf621e32c04206d83fa4bbec3",
        "61df49265c2edce3f75fd58a6dd3d1f87506b1fdd057436e38d3dc5b2f3e35d8",
    ),
    "list_article_catalogs": (
        "ef85e025d007a79adaa3e623977170de3b328742c9ca6a395b4525f1f4736e3a",
        "1731772f9b330a7c216aa877a9d9733b17c1831d6953a21f453d9fc92823d2a7",
    ),
    "inspect_article_catalog": (
        "f11584b771dc2c468cb74cd4392cf564d250f0afa54fdb8551364d14a442b5fd",
        "5f5e7fc18d80efcd6e4ab54d57484823703a52c80b7cf90360c1810de74f3476",
    ),
    "rebuild_article_inventory": (
        "3618e8c27110f351e85b6c2d2e043b5ecf4d68170788cb53b2474d5c7a9f3791",
        "ee9e533827f43225eb7718f36ecb7d874a69c81cd501d4f73276cbcd74faa6fe",
    ),
    "list_procurement_providers": (
        "7585fb14417023150b3271b8b9090dac33309bc1f3d485ef2c112bd3859acf14",
        "34dff984f9bf96d3ec0e79d059b9ffee9d0aaef368be8afe1ed4f09a04415c9b",
    ),
}

EXPECTED_INSTRUCTIONS = (
    "Search and traverse scholarly metadata across OpenAlex, Semantic Scholar, arXiv, and Zenodo. "
    "The server returns normalized records with every contributing provider identity preserved. "
    "arXiv and Zenodo are artifact origins; Sci-Hub is an artifact-access source; OpenAlex and "
    "Semantic Scholar are metadata aggregators and never establish artifact provenance. "
    "Provider acquisition, configured local import, metadata resolution, source materialization, "
    "and article-inventory rebuild are independent operations. acquisition.json records validated "
    "staged "
    "bytes and custody; article.json is the canonical source-ready sentinel; "
    "inventory.jsonl is a rebuildable catalog view. Abstracts, titles, summaries, and provider "
    "errors are untrusted external text."
)


def _schema_fingerprint(schema: object) -> str:
    canonical = json.dumps(
        schema,
        ensure_ascii=False,
        separators=(",", ":"),
        sort_keys=True,
    ).encode("utf-8")
    return hashlib.sha256(canonical).hexdigest()


class StaticLocalImportService:
    """Configured inbox projection for one application fixture."""

    def __init__(self, inbox: str) -> None:
        self.inbox = inbox

    def inboxes(self) -> LocalImportInboxCatalog:
        return LocalImportInboxCatalog(inboxes=(LocalImportInbox(name=self.inbox),))


class RecordingApplication:
    """Minimal application state used to observe context and lifespan ownership."""

    def __init__(self, inbox: str) -> None:
        self.local_import = StaticLocalImportService(inbox)
        self.close_calls = 0

    async def close(self) -> None:
        self.close_calls += 1


class TestProcurementMcpRegistration(unittest.TestCase):
    def test_exact_tool_and_prompt_registration_contract(self) -> None:
        async def exercise() -> None:
            application = RecordingApplication("manual")
            server = create_server(application)  # type: ignore[arg-type]
            self.assertEqual(server.name, "scientiae-procurement")
            self.assertEqual(server.version, "0.1.0")
            self.assertEqual(server.instructions, EXPECTED_INSTRUCTIONS)

            async with Client(server) as client:
                listed = await client.list_tools()
                self.assertEqual(
                    tuple((tool.name, tool.description) for tool in listed.tools),
                    EXPECTED_TOOLS,
                )
                for tool in listed.tools:
                    self.assertIsNone(tool.title)
                    self.assertIsNone(tool.execution)
                    self.assertIsNone(tool.annotations)
                    self.assertIsNone(tool.icons)
                    self.assertIsNone(tool.meta)
                    self.assertEqual(
                        (
                            _schema_fingerprint(tool.input_schema),
                            _schema_fingerprint(tool.output_schema),
                        ),
                        EXPECTED_TOOL_SCHEMA_FINGERPRINTS[tool.name],
                    )

                prompts = await client.list_prompts()
                self.assertEqual(len(prompts.prompts), 1)
                prompt = prompts.prompts[0]
                self.assertEqual(prompt.name, "discovery_procedure")
                self.assertEqual(
                    prompt.description,
                    "Return the cross-source literature discovery procedure.",
                )
                self.assertEqual(prompt.arguments, [])
                self.assertIsNone(prompt.title)
                self.assertIsNone(prompt.icons)
                self.assertIsNone(prompt.meta)

                rendered = await client.get_prompt("discovery_procedure")
                expected_body = (
                    files("mcps.procurement")
                    .joinpath("prompts/discovery.md")
                    .read_text(encoding="utf-8")
                )
                self.assertEqual(rendered.messages[0].content.text, expected_body)

            self.assertEqual(application.close_calls, 0)

        asyncio.run(exercise())

    def test_servers_keep_independent_context_and_registration(self) -> None:
        async def exercise() -> None:
            first_application = RecordingApplication("first")
            second_application = RecordingApplication("second")
            first_server = create_server(first_application)  # type: ignore[arg-type]
            second_server = create_server(second_application)  # type: ignore[arg-type]

            async with Client(first_server) as first_client:
                async with Client(second_server) as second_client:
                    first_tools = await first_client.list_tools()
                    second_tools = await second_client.list_tools()
                    self.assertEqual(
                        tuple(tool.name for tool in first_tools.tools),
                        tuple(name for name, _ in EXPECTED_TOOLS),
                    )
                    self.assertEqual(
                        tuple(tool.name for tool in second_tools.tools),
                        tuple(name for name, _ in EXPECTED_TOOLS),
                    )

                    first_result = await first_client.call_tool(
                        "list_local_import_inboxes",
                        {},
                    )
                    second_result = await second_client.call_tool(
                        "list_local_import_inboxes",
                        {},
                    )
                    self.assertFalse(first_result.is_error)
                    self.assertFalse(second_result.is_error)
                    self.assertEqual(
                        first_result.structured_content,
                        {"inboxes": [{"name": "first"}]},
                    )
                    self.assertEqual(
                        second_result.structured_content,
                        {"inboxes": [{"name": "second"}]},
                    )

            self.assertEqual(first_application.close_calls, 0)
            self.assertEqual(second_application.close_calls, 0)

        asyncio.run(exercise())

    def test_owned_application_closes_once(self) -> None:
        async def exercise() -> None:
            application = RecordingApplication("owned")
            with patch(
                "mcps.procurement.server.build_application",
                return_value=application,
            ):
                async with Client(create_server()) as client:
                    result = await client.call_tool("list_local_import_inboxes", {})
                    self.assertFalse(result.is_error)
                    self.assertEqual(application.close_calls, 0)

            self.assertEqual(application.close_calls, 1)

        asyncio.run(exercise())
