"""Offline provider payload-mapping contracts."""

from __future__ import annotations

import asyncio
import base64
import json
import unittest

import httpx

from procurement.transport.http import HttpClient
from procurement.models import SearchRequest
from procurement.providers.arxiv import ArxivProvider, build_search_query
from procurement.providers.openalex import OpenAlexProvider
from procurement.providers.semanticscholar import SemanticScholarProvider
from procurement.providers.zenodo import ZenodoProvider, strip_html
from procurement.configuration import ProviderHttpSettings, RuntimeSecrets

OPENALEX_WORK = {
    "id": "https://openalex.org/W2144044408",
    "doi": "https://doi.org/10.1007/S00454-004-1146-Y",
    "title": "Computing Persistent Homology",
    "publication_year": 2004,
    "publication_date": "2004-12-01",
    "updated_date": "2026-01-02T03:04:05Z",
    "cited_by_count": 1620,
    "referenced_works_count": 2,
    "referenced_works": ["https://openalex.org/W1", "https://openalex.org/W2"],
    "authorships": [
        {"author": {"display_name": "Afra Zomorodian"}},
        {"author": {"display_name": "Gunnar Carlsson"}},
    ],
    "primary_location": {
        "source": {"display_name": "Discrete & Computational Geometry"},
        "pdf_url": None,
        "landing_page_url": "https://arxiv.org/abs/math/0508341",
    },
    "best_oa_location": {
        "pdf_url": "https://example.test/paper.pdf",
        "landing_page_url": "https://doi.org/10.1007/s00454-004-1146-y",
    },
    "locations": [],
    "ids": {
        "openalex": "https://openalex.org/W2144044408",
        "doi": "https://doi.org/10.1007/s00454-004-1146-y",
    },
    "abstract_inverted_index": {"Persistent": [0], "homology": [1], "is": [2], "computable": [3]},
    "topics": [{"display_name": "Topological and Geometric Data Analysis"}],
}

SEMANTIC_SCHOLAR_WORK = {
    "paperId": "abc123def",
    "externalIds": {"DOI": "10.1007/S00454-004-1146-Y", "ArXiv": "2008.10579", "CorpusId": 99},
    "url": "https://www.semanticscholar.org/paper/abc123def",
    "title": "Compressive Phase Retrieval",
    "abstract": "We study compressive phase retrieval.",
    "year": 2020,
    "publicationDate": "2020-08-24",
    "venue": "NeurIPS",
    "authors": [{"authorId": "1", "name": "Paul Hand"}, {"authorId": "2", "name": "Vladislav Voroninski"}],
    "citationCount": 42,
    "referenceCount": 30,
    "tldr": {"model": "x", "text": "A short summary."},
    "openAccessPdf": {"url": "https://arxiv.org/pdf/2008.10579", "status": "GREEN"},
    "fieldsOfStudy": ["Computer Science", "Mathematics"],
}

ZENODO_WORK = {
    "id": 1234567,
    "doi": "10.5281/zenodo.1234567",
    "metadata": {
        "title": "Sample Zenodo Dataset and Paper Source",
        "description": "<p>This is a <em>test</em> description.</p>",
        "publication_date": "2026-05-15",
        "resource_type": {"type": "publication"},
        "creators": [{"name": "Hand, Paul"}, {"name": "Voroninski, Vladislav"}],
        "keywords": ["topology", "data science"],
    },
    "links": {"html": "https://zenodo.org/records/1234567"},
    "files": [
        {
            "key": "paper.pdf",
            "links": {"self": "https://zenodo.org/api/records/1234567/files/paper.pdf/content"},
        }
    ],
}

ARXIV_FEED = """<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:arxiv="http://arxiv.org/schemas/atom"
      xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/">
  <opensearch:totalResults>4823</opensearch:totalResults>
  <opensearch:startIndex>0</opensearch:startIndex>
  <opensearch:itemsPerPage>2</opensearch:itemsPerPage>
  <entry>
    <id>http://arxiv.org/abs/2008.10579v1</id>
    <title>Neural
      Manifolds</title>
    <summary>We study   the geometry
      of population activity.</summary>
    <published>2020-08-24T17:59:00Z</published>
    <updated>2020-09-01T00:00:00Z</updated>
    <author><name>Ada Lovelace</name></author>
    <author><name>Alan Turing</name></author>
    <arxiv:primary_category term="q-bio.NC"/>
    <category term="q-bio.NC"/>
    <category term="cs.LG"/>
    <arxiv:doi>10.1234/example.5678</arxiv:doi>
    <link title="pdf" href="http://arxiv.org/pdf/2008.10579v1"/>
  </entry>
  <entry>
    <id>http://arxiv.org/abs/math.GT/0309136</id>
    <title>An Old Style Paper</title>
    <summary>Legacy identifier scheme.</summary>
    <published>2003-09-08T00:00:00Z</published>
    <author><name>Henri Poincare</name></author>
    <arxiv:primary_category term="math.GT"/>
    <category term="math.GT"/>
  </entry>
</feed>"""


class TestOpenAlexProvider(unittest.TestCase):
    def test_reconstructs_abstract_and_preserves_source(self) -> None:
        record = OpenAlexProvider.map_work(OPENALEX_WORK)
        self.assertEqual(record.doi, "10.1007/s00454-004-1146-y")
        self.assertEqual(record.arxiv_id, "math/0508341")
        self.assertEqual(record.abstract, "Persistent homology is computable")
        self.assertEqual(record.authors, ("Afra Zomorodian", "Gunnar Carlsson"))
        self.assertEqual(record.reference_count, 2)
        self.assertEqual(record.sources[0].identifier, "W2144044408")

    def test_normalizes_provider_keys(self) -> None:
        self.assertEqual(OpenAlexProvider.normalize_key("https://openalex.org/W42"), "W42")
        self.assertEqual(OpenAlexProvider.normalize_key("https://doi.org/10.1/X"), "doi:10.1/x")
        self.assertEqual(OpenAlexProvider.normalize_key("10.1/X"), "doi:10.1/x")


class TestSemanticScholarProvider(unittest.TestCase):
    def test_maps_graph_fields_and_crosswalks(self) -> None:
        record = SemanticScholarProvider.map_work(SEMANTIC_SCHOLAR_WORK)
        self.assertEqual(record.doi, "10.1007/s00454-004-1146-y")
        self.assertEqual(record.arxiv_id, "2008.10579")
        self.assertEqual(record.tldr, "A short summary.")
        self.assertEqual(record.citation_count, 42)
        self.assertEqual(record.concepts, ("Computer Science", "Mathematics"))

    def test_normalizes_typed_and_bare_keys(self) -> None:
        self.assertEqual(SemanticScholarProvider.normalize_key("DOI:10.1/x"), "DOI:10.1/x")
        self.assertEqual(
            SemanticScholarProvider.normalize_key("10.1000/x"),
            "DOI:10.1000/x",
        )
        self.assertEqual(
            SemanticScholarProvider.normalize_key("https://doi.org/10.1000/X"),
            "DOI:10.1000/x",
        )
        self.assertEqual(SemanticScholarProvider.normalize_key("2008.10579"), "ARXIV:2008.10579")


class TestArxivProvider(unittest.TestCase):
    def test_parses_atom_without_injecting_markers_into_metadata(self) -> None:
        feed = ArxivProvider.parse_feed(ARXIV_FEED)
        self.assertEqual(feed.total, 4823)
        self.assertEqual(len(feed.works), 2)
        record = feed.works[0]
        self.assertEqual(record.title, "Neural Manifolds")
        self.assertEqual(record.abstract, "We study the geometry of population activity.")
        self.assertEqual(record.doi, "10.1234/example.5678")
        self.assertEqual(record.categories, ("q-bio.NC", "cs.LG"))
        self.assertEqual(record.sources[0].identifier, "2008.10579v1")

    def test_handles_legacy_identifier_and_synthesizes_pdf_url(self) -> None:
        record = ArxivProvider.parse_feed(ARXIV_FEED).works[1]
        self.assertEqual(record.arxiv_id, "math.GT/0309136")
        self.assertEqual(record.pdf_url, "https://arxiv.org/pdf/math.GT/0309136")

    def test_builds_categories_and_date_window_as_provider_expression(self) -> None:
        request = SearchRequest(
            query="topology",
            categories=("math.AT", "cs.CG"),
            date_from="2020-01-01",
            date_to="2020-12-31",
        )
        self.assertEqual(
            build_search_query(request),
            "(topology) AND (cat:math.AT OR cat:cs.CG) AND submittedDate:[202001010000 TO 202012312359]",
        )


class TestZenodoProvider(unittest.TestCase):
    def test_maps_record_and_pdf_manifest(self) -> None:
        record = ZenodoProvider.map_work(ZENODO_WORK)
        self.assertEqual(record.doi, "10.5281/zenodo.1234567")
        self.assertEqual(record.authors, ("Hand, Paul", "Voroninski, Vladislav"))
        self.assertEqual(record.abstract, "This is a test description.")
        self.assertEqual(record.pdf_url, "https://zenodo.org/api/records/1234567/files/paper.pdf/content")
        self.assertEqual(record.concepts, ("topology", "data science"))

    def test_html_extraction_decodes_and_collapses_text(self) -> None:
        self.assertEqual(strip_html("<p>A &amp; <b>B</b></p>"), "A & B")
        self.assertEqual(
            strip_html("<p>First</p><p>Second<br>line</p><ul><li>Third</li></ul>"),
            "First Second line Third",
        )

    def test_anonymous_search_clamps_page_size_to_provider_limit(self) -> None:
        observed_size: str | None = None

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal observed_size
            observed_size = request.url.params.get("size")
            return httpx.Response(200, json={"hits": {"hits": [], "total": 0}})

        async def exercise() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                provider = ZenodoProvider(
                    HttpClient(raw),
                    ProviderHttpSettings(
                        base_url="https://zenodo.example/api/records",
                        min_interval_seconds=0,
                        timeout_seconds=1,
                    ),
                )
                await provider.search(SearchRequest(query="geometry", limit=100))

        asyncio.run(exercise())
        self.assertEqual(observed_size, "25")


class TestProviderMetadataEvidence(unittest.TestCase):
    def test_each_provider_preserves_the_exact_decoded_api_payload(self) -> None:
        bodies = {
            "openalex": json.dumps(OPENALEX_WORK, separators=(",", ":")).encode(),
            "semanticscholar": json.dumps(SEMANTIC_SCHOLAR_WORK, separators=(",", ":")).encode(),
            "arxiv": ARXIV_FEED.encode(),
            "zenodo": json.dumps(ZENODO_WORK, separators=(",", ":")).encode(),
        }

        def handler(request: httpx.Request) -> httpx.Response:
            host = request.url.host
            if host == "openalex.example":
                name = "openalex"
                content_type = "application/json"
            elif host == "semanticscholar.example":
                name = "semanticscholar"
                content_type = "application/json"
            elif host == "arxiv.example":
                name = "arxiv"
                content_type = "application/atom+xml"
            else:
                name = "zenodo"
                content_type = "application/json"
            return httpx.Response(200, content=bodies[name], headers={"content-type": content_type})

        async def exercise() -> dict[str, bytes]:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                client = HttpClient(raw)
                providers = {
                    "openalex": (
                        OpenAlexProvider(
                            client,
                            ProviderHttpSettings(
                                base_url="https://openalex.example",
                                min_interval_seconds=0,
                                timeout_seconds=1,
                            ),
                        ),
                        "W2144044408",
                    ),
                    "semanticscholar": (
                        SemanticScholarProvider(
                            client,
                            ProviderHttpSettings(
                                base_url="https://semanticscholar.example",
                                secondary_base_url="https://recommendations.example",
                                min_interval_seconds=0,
                                timeout_seconds=1,
                            ),
                        ),
                        "abc123def",
                    ),
                    "arxiv": (
                        ArxivProvider(
                            client,
                            ProviderHttpSettings(
                                base_url="https://arxiv.example/api/query",
                                min_interval_seconds=0,
                                timeout_seconds=1,
                            ),
                        ),
                        "2008.10579v1",
                    ),
                    "zenodo": (
                        ZenodoProvider(
                            client,
                            ProviderHttpSettings(
                                base_url="https://zenodo.example/api/records",
                                min_interval_seconds=0,
                                timeout_seconds=1,
                            ),
                        ),
                        "1234567",
                    ),
                }
                return {
                    name: base64.b64decode((await provider.get_metadata(identifier)).response.body_base64)
                    for name, (provider, identifier) in providers.items()
                }

        self.assertEqual(asyncio.run(exercise()), bodies)

    def test_openalex_key_is_sent_but_redacted_from_evidence_url(self) -> None:
        observed_url: httpx.URL | None = None

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal observed_url
            observed_url = request.url
            return httpx.Response(200, json=OPENALEX_WORK)

        async def exercise():
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                provider = OpenAlexProvider(
                    HttpClient(raw),
                    ProviderHttpSettings(
                        base_url="https://openalex.example",
                        min_interval_seconds=0,
                        timeout_seconds=1,
                    ),
                    RuntimeSecrets(
                        contact_email="contact@example.test",
                        openalex_api_key="TOPSECRET",
                    ),
                )
                return await provider.get_metadata("W2144044408")

        result = asyncio.run(exercise())
        assert observed_url is not None
        self.assertEqual(observed_url.params["api_key"], "TOPSECRET")
        self.assertEqual(observed_url.params["mailto"], "contact@example.test")
        self.assertIn("api_key=REDACTED", result.response.url)
        self.assertIn("mailto=REDACTED", result.response.url)
        self.assertNotIn("TOPSECRET", result.response.url)
        self.assertNotIn("contact%40example", result.response.url)

    def test_semantic_scholar_key_does_not_infer_a_higher_rate_limit(self) -> None:
        async def exercise():
            async with httpx.AsyncClient(
                transport=httpx.MockTransport(lambda request: httpx.Response(200))
            ) as raw:
                provider = SemanticScholarProvider(
                    HttpClient(raw),
                    ProviderHttpSettings(
                        base_url="https://semanticscholar.example",
                        secondary_base_url="https://recommendations.example",
                        min_interval_seconds=1.1,
                        timeout_seconds=1,
                    ),
                    RuntimeSecrets(semantic_scholar_api_key="TOPSECRET"),
                )
                return provider._policy

        policy = asyncio.run(exercise())
        self.assertEqual(policy.min_interval_seconds, 1.1)
        self.assertTrue(policy.retry_rate_limits)

    def test_runtime_secret_representation_never_contains_key_material(self) -> None:
        secrets = RuntimeSecrets(
            openalex_api_key="OPENALEX-TOPSECRET",
            semantic_scholar_api_key="S2-TOPSECRET",
        )

        representation = repr(secrets)
        self.assertNotIn("OPENALEX-TOPSECRET", representation)
        self.assertNotIn("S2-TOPSECRET", representation)
