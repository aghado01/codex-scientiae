"""HTML page-requisite confine, retrieve, and acquisition outcomes."""

from __future__ import annotations

import asyncio
import tempfile
import unittest
from datetime import datetime, timezone
from pathlib import Path

import httpx

from jsonl_engine.publication import PinnedPublicationRoot
from procurement.domain.acquisition.planning import (
    ArtifactAcquisitionRequest,
    ArtifactPlan,
    PlannedArtifact,
    RetrievalCandidate,
)
from procurement.domain.acquisition.receipts import HTML_TREE_FORMAT
from procurement.domain.metadata import ArtifactReference
from procurement.domain.procure import ProcureRequest
from procurement.operations.html_tree import (
    collect_html_requisites,
    confine_html_requisite,
    fingerprint_html_tree,
    html_entrypoint_leaf,
    html_join_base,
    html_prefix_path,
    html_tree_leaf,
    is_arxiv_html_paper,
    relative_html_member,
)
from procurement.operations.acquisition import AcquisitionService
from procurement.providers.base import Capability, ProviderRole
from procurement.providers.catalog import ProviderBinding, ProviderCatalog
from procurement.storage.acquisitions import AcquisitionStore
from procurement.storage.roots import ConfiguredRootDescriptor, ConfiguredRootKind
from procurement.transport.http import HttpClient, RequestPolicy
from tests.procurement.test_acquisition import (
    StaticPlanningProvider,
    opened_acquisition_store,
)

NOW = datetime(2026, 8, 11, 12, 0, tzinfo=timezone.utc)
SLUG = "2008.10579v1"
PAPER = (
    b"<!doctype html><html class=\"ltx_document\"><body>"
    b"<article class=\"ltx_document\">"
    b"<img src=\"x1.png\">"
    b"<link rel=\"stylesheet\" href=\"https://static.arxiv.org/theme.css\">"
    b"<a href=\"https://arxiv.org/pdf/2008.10579v1\">pdf</a>"
    b"<img src=\"../escape.png\">"
    b"<img src=\"/pdf/2008.10579v1\">"
    b"</article></body></html>"
)
PNG = b"\x89PNG\r\n\x1a\n" + b"\x00" * 24
CHROME = b"<!doctype html><html><body>HTML is not available for this paper.</body></html>"


def _plan() -> ArtifactPlan:
    return ArtifactPlan(
        artifact=ArtifactReference(
            provider="arxiv",
            identifier=SLUG,
            provider_roles=("artifact-origin", "artifact-access", "metadata-authority"),
        ),
        deposit_slug=SLUG,
        requested=("html",),
        payloads=(
            PlannedArtifact(
                kind="html",
                target_leaf=f"{SLUG}-html",
                media_type=HTML_TREE_FORMAT,
                payload_kind="html",
                minimum_bytes=16,
                maximum_bytes=1024 * 1024,
                candidates=(
                    RetrievalCandidate(
                        candidate_id="arxiv-html",
                        url=f"https://arxiv.org/html/{SLUG}",
                        allowed_hosts=("arxiv.org",),
                    ),
                ),
            ),
        ),
    )


def _service(http: HttpClient, store: AcquisitionStore) -> AcquisitionService:
    planner = StaticPlanningProvider(_plan())
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
    return AcquisitionService(
        registry,
        http,
        store,
        provider_policies={"arxiv": RequestPolicy(max_attempts=1, max_decoded_body_bytes=1024 * 1024)},
    )


class TestHtmlConfine(unittest.TestCase):
    def test_join_base_appends_slash_for_directory_landings(self) -> None:
        base = html_join_base(f"https://arxiv.org/html/{SLUG}")
        self.assertTrue(base.endswith("/"))
        confined = confine_html_requisite(
            "x1.png",
            base=base,
            prefix_path=html_prefix_path(f"https://arxiv.org/html/{SLUG}"),
            allowed_hosts=("arxiv.org",),
        )
        self.assertEqual(confined, f"https://arxiv.org/html/{SLUG}/x1.png")

    def test_join_base_keeps_file_like_landings(self) -> None:
        url = f"https://arxiv.org/html/{SLUG}/{SLUG}.html"
        self.assertEqual(html_join_base(url), url)

    def test_skips_cdn_navigation_and_escape(self) -> None:
        prefix = html_prefix_path(f"https://arxiv.org/html/{SLUG}")
        base = html_join_base(f"https://arxiv.org/html/{SLUG}")
        hosts = ("arxiv.org",)
        self.assertIsNone(
            confine_html_requisite(
                "https://static.arxiv.org/theme.css",
                base=base,
                prefix_path=prefix,
                allowed_hosts=hosts,
            )
        )
        self.assertIsNone(
            confine_html_requisite(
                "../escape.png",
                base=base,
                prefix_path=prefix,
                allowed_hosts=hosts,
            )
        )
        self.assertIsNone(
            confine_html_requisite(
                "/pdf/2008.10579v1",
                base=base,
                prefix_path=prefix,
                allowed_hosts=hosts,
            )
        )

    def test_parser_ignores_script_style_and_anchors(self) -> None:
        urls = collect_html_requisites(PAPER.decode("utf-8"))
        self.assertEqual(urls, ("x1.png", "../escape.png", "/pdf/2008.10579v1"))

    def test_relative_member_skips_the_landing_and_keeps_figures(self) -> None:
        prefix = html_prefix_path(f"https://arxiv.org/html/{SLUG}")
        self.assertIsNone(
            relative_html_member(
                f"https://arxiv.org/html/{SLUG}",
                prefix_path=prefix,
                entrypoint=f"{SLUG}.html",
            )
        )
        self.assertEqual(
            relative_html_member(
                f"https://arxiv.org/html/{SLUG}/x1.png",
                prefix_path=prefix,
                entrypoint=f"{SLUG}.html",
            ),
            "x1.png",
        )

    def test_arxiv_paper_marker(self) -> None:
        self.assertTrue(is_arxiv_html_paper(PAPER.decode("utf-8")))
        self.assertFalse(is_arxiv_html_paper(CHROME.decode("utf-8")))

    def test_fingerprint_is_stable_under_member_reorder(self) -> None:
        with tempfile.TemporaryDirectory() as root:
            tree = Path(root) / "tree"
            tree.mkdir()
            (tree / f"{SLUG}.html").write_bytes(PAPER)
            (tree / "x1.png").write_bytes(PNG)
            with PinnedPublicationRoot(tree) as pinned:
                first = fingerprint_html_tree(pinned, entrypoint=f"{SLUG}.html")
            (tree / "x1.png").write_bytes(PNG)
            with PinnedPublicationRoot(tree) as pinned:
                second = fingerprint_html_tree(pinned, entrypoint=f"{SLUG}.html")
            self.assertEqual(first.sha256, second.sha256)
            self.assertEqual(first.files, 2)
            self.assertEqual(first.entrypoint, f"{SLUG}.html")
            self.assertEqual(html_tree_leaf(SLUG), f"{SLUG}-html")
            self.assertEqual(html_entrypoint_leaf(SLUG), f"{SLUG}.html")


class TestHtmlAcquisition(unittest.TestCase):
    def test_downloads_landing_and_same_prefix_image(self) -> None:
        calls: list[str] = []

        def handler(request: httpx.Request) -> httpx.Response:
            calls.append(request.url.path)
            if request.url.path == f"/html/{SLUG}":
                return httpx.Response(
                    301,
                    headers={"location": f"https://arxiv.org/html/{SLUG}/"},
                )
            if request.url.path == f"/html/{SLUG}/":
                return httpx.Response(200, content=PAPER, headers={"content-type": "text/html"})
            if request.url.path == f"/html/{SLUG}/x1.png":
                return httpx.Response(200, content=PNG, headers={"content-type": "image/png"})
            return httpx.Response(404)

        async def exercise(root: str) -> None:
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    result = await _service(HttpClient(raw, utc_now=lambda: NOW), store).acquire(
                        ArtifactAcquisitionRequest(
                            provider="arxiv",
                            identifier=SLUG,
                            artifacts=("html",),
                        )
                    )
            self.assertEqual(result.outcomes[0].status, "acquired")
            self.assertEqual(result.outcomes[0].path, f"{SLUG}-html")
            form = result.manifest.forms[0]
            self.assertEqual(form.format, HTML_TREE_FORMAT)
            self.assertEqual(form.entrypoint, f"{SLUG}.html")
            self.assertEqual(form.files, 2)
            dest = Path(root) / SLUG / f"{SLUG}-html"
            self.assertTrue((dest / f"{SLUG}.html").is_file())
            self.assertTrue((dest / "x1.png").is_file())
            self.assertFalse((dest / "theme.css").exists())

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(root))
        self.assertIn(f"/html/{SLUG}/x1.png", calls)
        self.assertNotIn("/theme.css", " ".join(calls))
        self.assertNotIn("/pdf/", " ".join(calls))

    def test_404_is_unavailable(self) -> None:
        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(404)

        async def exercise(root: str):
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    return await _service(HttpClient(raw, utc_now=lambda: NOW), store).acquire(
                        ArtifactAcquisitionRequest(
                            provider="arxiv",
                            identifier=SLUG,
                            artifacts=("html",),
                        )
                    )

        with tempfile.TemporaryDirectory() as root:
            result = asyncio.run(exercise(root))
        self.assertEqual(result.outcomes[0].status, "unavailable")
        self.assertIsNone(result.manifest)

    def test_chrome_page_is_unavailable_and_fetches_no_assets(self) -> None:
        calls: list[str] = []

        def handler(request: httpx.Request) -> httpx.Response:
            calls.append(request.url.path)
            return httpx.Response(200, content=CHROME, headers={"content-type": "text/html"})

        async def exercise(root: str):
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    return await _service(HttpClient(raw, utc_now=lambda: NOW), store).acquire(
                        ArtifactAcquisitionRequest(
                            provider="arxiv",
                            identifier=SLUG,
                            artifacts=("html",),
                        )
                    )

        with tempfile.TemporaryDirectory() as root:
            result = asyncio.run(exercise(root))
        self.assertEqual(result.outcomes[0].status, "unavailable")
        self.assertEqual(calls, [f"/html/{SLUG}"])

    def test_429_is_an_error(self) -> None:
        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(429, headers={"retry-after": "2"})

        async def exercise(root: str):
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    return await _service(HttpClient(raw, utc_now=lambda: NOW), store).acquire(
                        ArtifactAcquisitionRequest(
                            provider="arxiv",
                            identifier=SLUG,
                            artifacts=("html",),
                        )
                    )

        with tempfile.TemporaryDirectory() as root:
            result = asyncio.run(exercise(root))
        self.assertEqual(result.outcomes[0].status, "error")

    def test_adopts_an_existing_valid_tree(self) -> None:
        async def exercise(root: str):
            dest = Path(root) / SLUG / f"{SLUG}-html"
            dest.mkdir(parents=True)
            (dest / f"{SLUG}.html").write_bytes(PAPER)
            (dest / "x1.png").write_bytes(PNG)
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(
                    transport=httpx.MockTransport(lambda request: httpx.Response(500))
                ) as raw:
                    return await _service(HttpClient(raw, utc_now=lambda: NOW), store).acquire(
                        ArtifactAcquisitionRequest(
                            provider="arxiv",
                            identifier=SLUG,
                            artifacts=("html",),
                        )
                    )

        with tempfile.TemporaryDirectory() as root:
            result = asyncio.run(exercise(root))
        self.assertEqual(result.outcomes[0].status, "already-present")
        self.assertEqual(result.manifest.forms[0].files, 2)

    def test_procure_default_includes_html(self) -> None:
        request = ProcureRequest(provider="arxiv", identifier=SLUG, catalog="inventory")
        self.assertEqual(request.artifacts, ("source", "pdf", "html"))

    def test_zenodo_one_file_html_becomes_a_one_member_tree(self) -> None:
        html = b"<!doctype html><html><body>zenodo paper</body></html>"

        class ZenodoPlanner:
            name = "zenodo"

            async def plan_artifact(self, request):
                return ArtifactPlan(
                    artifact=ArtifactReference(
                        provider="zenodo",
                        identifier="123",
                        provider_roles=("artifact-origin", "artifact-access", "metadata-authority"),
                    ),
                    deposit_slug="zenodo_123",
                    requested=("html",),
                    payloads=(
                        PlannedArtifact(
                            kind="html",
                            target_leaf="zenodo_123-html",
                            media_type=HTML_TREE_FORMAT,
                            payload_kind="html",
                            minimum_bytes=16,
                            maximum_bytes=1024 * 1024,
                            expected_bytes=len(html),
                            candidates=(
                                RetrievalCandidate(
                                    candidate_id="zenodo-self",
                                    url="https://zenodo.org/records/123/files/paper.html",
                                    allowed_hosts=("zenodo.org",),
                                ),
                            ),
                        ),
                    ),
                )

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(200, content=html, headers={"content-type": "text/html"})

        async def exercise(root: str):
            planner = ZenodoPlanner()
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
            with opened_acquisition_store(root) as store:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    service = AcquisitionService(
                        registry,
                        HttpClient(raw, utc_now=lambda: NOW),
                        store,
                        provider_policies={
                            "zenodo": RequestPolicy(max_attempts=1, max_decoded_body_bytes=1024 * 1024)
                        },
                    )
                    return await service.acquire(
                        ArtifactAcquisitionRequest(
                            provider="zenodo",
                            identifier="123",
                            artifacts=("html",),
                        )
                    )

        with tempfile.TemporaryDirectory() as root:
            result = asyncio.run(exercise(root))
            dest = Path(root) / "zenodo_123" / "zenodo_123-html" / "zenodo_123.html"
            self.assertEqual(dest.read_bytes(), html)
        self.assertEqual(result.outcomes[0].status, "acquired")
        form = result.manifest.forms[0]
        self.assertEqual(form.path, "zenodo_123-html")
        self.assertEqual(form.files, 1)
        self.assertEqual(form.entrypoint, "zenodo_123.html")
