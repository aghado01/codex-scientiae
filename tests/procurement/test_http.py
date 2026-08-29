"""HTTP retry and rate-state contracts."""

from __future__ import annotations

import asyncio
import gzip
import os
import tempfile
import threading
import unittest
from datetime import datetime, timezone
from pathlib import Path
from unittest import mock

import httpx
from filelock import FileLock

from jsonl_engine.publication import PinnedPublicationRoot
import procurement.transport.http as procurement_http
from procurement.errors import ProviderHttpError, ProviderPayloadError, ProviderRateLimitError
from procurement.transport.http import (
    HttpClient,
    RateLimiter,
    RequestPolicy,
    default_rate_clock_path,
)


class TestRateLimiter(unittest.TestCase):
    def test_state_is_injected_and_keyed(self) -> None:
        now = [0.0]
        sleeps: list[float] = []

        async def sleep(seconds: float) -> None:
            sleeps.append(seconds)
            now[0] += seconds

        async def exercise() -> None:
            limiter = RateLimiter(clock=lambda: now[0], sleep=sleep)
            await limiter.wait("a", 1.0)
            await limiter.wait("b", 1.0)
            await limiter.wait("a", 1.0)

        asyncio.run(exercise())
        self.assertEqual(sleeps, [1.0])

    def test_jitter_and_penalize_extend_waits(self) -> None:
        now = [0.0]
        sleeps: list[float] = []

        async def sleep(seconds: float) -> None:
            sleeps.append(seconds)
            now[0] += seconds

        async def exercise() -> None:
            limiter = RateLimiter(
                clock=lambda: now[0],
                sleep=sleep,
                jitter_generator=lambda max_j: max_j * 0.5,
            )
            await limiter.wait("a", 1.0, jitter_seconds=0.4)
            await limiter.wait("a", 1.0, jitter_seconds=0.4)
            limiter.penalize("a", 10.0)
            await limiter.wait("a", 1.0, jitter_seconds=0.0)

        asyncio.run(exercise())
        self.assertEqual(sleeps, [1.2, 11.0])

    def test_file_backed_clock_is_shared_across_instances(self) -> None:
        now = [1000.0]
        sleeps: list[float] = []

        async def sleep(seconds: float) -> None:
            sleeps.append(seconds)
            now[0] += seconds

        async def exercise(path: Path) -> None:
            first = RateLimiter(
                clock=lambda: now[0], sleep=sleep, state_path=path
            )
            second = RateLimiter(
                clock=lambda: now[0], sleep=sleep, state_path=path
            )
            await first.wait("arxiv", 1.0)
            await second.wait("arxiv", 1.0)
            first.penalize("arxiv", 10.0)
            await second.wait("arxiv", 1.0)

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(Path(root) / "rate-clock.json"))
        self.assertEqual(sleeps, [1.0, 11.0])

    def test_corrupt_clock_file_is_treated_as_empty(self) -> None:
        async def exercise(path: Path) -> None:
            path.write_text("not-json", encoding="utf-8")
            limiter = RateLimiter(
                clock=lambda: 5.0,
                sleep=lambda _seconds: asyncio.sleep(0),
                state_path=path,
            )
            await limiter.wait("arxiv", 1.0)

        with tempfile.TemporaryDirectory() as root:
            path = Path(root) / "rate-clock.json"
            asyncio.run(exercise(path))
            payload = path.read_text(encoding="utf-8")
        self.assertIn('"arxiv":5.0', payload.replace(" ", ""))

    def test_file_clock_lock_wait_does_not_block_the_event_loop(self) -> None:
        async def exercise(path: Path) -> None:
            lease = FileLock(f"{path}.lock", timeout=2)
            lease.acquire()
            limiter = RateLimiter(
                clock=lambda: 1.0,
                sleep=lambda _seconds: asyncio.sleep(0),
                state_path=path,
                lock_timeout=2,
            )
            task = asyncio.create_task(limiter.wait("arxiv", 1.0))
            ticks = 0

            async def ticker() -> None:
                nonlocal ticks
                for _ in range(5):
                    await asyncio.sleep(0.01)
                    ticks += 1

            tick = asyncio.create_task(ticker())
            try:
                await asyncio.sleep(0.05)
                self.assertFalse(task.done())
                self.assertGreater(ticks, 0)
            finally:
                lease.release()
            await asyncio.wait_for(task, timeout=1)
            await tick

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(Path(root) / "rate-clock.json"))

    def test_default_rate_clock_path_honors_environment(self) -> None:
        with mock.patch.dict(
            os.environ, {"CODEX_PROCUREMENT_RATE_CLOCK": "clock.json"}, clear=False
        ):
            self.assertEqual(default_rate_clock_path(), Path("clock.json"))


class TestBrowserHeaders(unittest.TestCase):
    def test_browser_headers_omits_email_and_generates_desktop_defaults(self) -> None:
        headers = procurement_http.browser_headers()
        self.assertIn("User-Agent", headers)
        self.assertIn("Mozilla/5.0", headers["User-Agent"])
        self.assertNotIn("mailto", headers["User-Agent"])
        self.assertNotIn("@", headers["User-Agent"])
        self.assertEqual(headers["Sec-Fetch-Dest"], "document")
        self.assertEqual(headers["Sec-Fetch-Mode"], "navigate")


class TestHttpClient(unittest.TestCase):
    def test_owned_client_enables_http2(self) -> None:
        client = HttpClient()
        try:
            pool = client._client._transport._pool
            self.assertTrue(getattr(pool, "_http2", False))
        finally:
            asyncio.run(client.close())

    def test_get_follows_only_bounded_same_host_safe_redirects(self) -> None:
        calls: list[str] = []

        def handler(request: httpx.Request) -> httpx.Response:
            calls.append(str(request.url))
            if request.url.path == "/start":
                return httpx.Response(302, headers={"location": "/result"})
            return httpx.Response(200, json={"ok": True})

        async def exercise() -> object:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                return await HttpClient(raw).get_json("https://provider.example/start")

        self.assertEqual(asyncio.run(exercise()), {"ok": True})
        self.assertEqual(
            calls,
            ["https://provider.example/start", "https://provider.example/result"],
        )

    def test_get_rejects_off_host_and_plaintext_routes_before_requesting_them(self) -> None:
        calls: list[str] = []

        def handler(request: httpx.Request) -> httpx.Response:
            calls.append(str(request.url))
            return httpx.Response(
                302,
                headers={"location": "https://other.example/result?api_key=secret"},
            )

        async def off_host() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                await HttpClient(raw).get_json(
                    "https://provider.example/start",
                    params={"api_key": "secret"},
                )

        with self.assertRaisesRegex(ProviderHttpError, "left its allowed hosts") as raised:
            asyncio.run(off_host())
        self.assertEqual(calls, ["https://provider.example/start?api_key=secret"])
        self.assertNotIn("secret", str(raised.exception))

        calls.clear()

        async def plaintext() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                await HttpClient(raw).get_json("http://provider.example/start")

        with self.assertRaisesRegex(ProviderHttpError, "HTTPS or loopback HTTP"):
            asyncio.run(plaintext())
        self.assertEqual(calls, [])

    def test_get_rejects_downgrade_missing_location_and_redirect_exhaustion(self) -> None:
        cases = (
            (
                "downgrade",
                lambda request: httpx.Response(
                    302,
                    headers={"location": "http://provider.example/plaintext"},
                ),
                5,
                "HTTPS-to-HTTP downgrade",
                1,
            ),
            (
                "missing-location",
                lambda request: httpx.Response(302),
                5,
                "omitted Location",
                1,
            ),
            (
                "exhausted",
                lambda request: httpx.Response(302, headers={"location": "/again"}),
                1,
                "exceeded 1 redirects",
                2,
            ),
        )

        for name, handler, maximum, pattern, expected_calls in cases:
            with self.subTest(name=name):
                calls = 0

                def counted(request: httpx.Request) -> httpx.Response:
                    nonlocal calls
                    calls += 1
                    return handler(request)

                async def exercise() -> None:
                    async with httpx.AsyncClient(
                        transport=httpx.MockTransport(counted)
                    ) as raw:
                        await HttpClient(raw).get_json(
                            "https://provider.example/start",
                            max_redirects=maximum,
                        )

                with self.assertRaisesRegex(ProviderHttpError, pattern):
                    asyncio.run(exercise())
                self.assertEqual(calls, expected_calls)

    def test_download_preflight_guards_fail_before_network_or_file_mutation(self) -> None:
        calls = 0

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal calls
            calls += 1
            return httpx.Response(200, content=b"unused")

        async def exercise(root: Path) -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                client = HttpClient(raw)
                with self.assertRaisesRegex(TypeError, "active PinnedPublicationRoot"):
                    await client.download_to(
                        "https://provider.example/payload",
                        "payload.part",
                        publication_root=object(),  # type: ignore[arg-type]
                        allowed_hosts=("provider.example",),
                    )

                inactive = PinnedPublicationRoot(root)
                with self.assertRaisesRegex(ProviderPayloadError, "retained directory"):
                    await client.download_to(
                        "https://provider.example/payload",
                        "inactive.part",
                        publication_root=inactive,
                        allowed_hosts=("provider.example",),
                    )

                with PinnedPublicationRoot(root) as output_root:
                    with self.assertRaisesRegex(ValueError, "at least one allowed host"):
                        await client.download_to(
                        "https://provider.example/payload",
                        str(root / "empty-host.part"),
                            publication_root=output_root,
                            allowed_hosts=(),
                        )

                    occupied = root / "occupied.part"
                    occupied.write_bytes(b"occupant")
                    with self.assertRaisesRegex(FileExistsError, "already exists"):
                        await client.download_to(
                            "https://provider.example/payload",
                            str(occupied),
                            publication_root=output_root,
                            allowed_hosts=("provider.example",),
                        )
                    self.assertEqual(occupied.read_bytes(), b"occupant")

                    with self.assertRaisesRegex(ValueError, "unsupported download hash"):
                        await client.download_to(
                            "https://provider.example/payload",
                            str(root / "unsupported.part"),
                            publication_root=output_root,
                            allowed_hosts=("provider.example",),
                            hash_algorithms=("not-a-hash",),
                        )

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(Path(root)))
        self.assertEqual(calls, 0)

    def test_request_policy_rejects_nonsensical_boundaries(self) -> None:
        invalid = (
            {"min_interval_seconds": -1},
            {"jitter_seconds": -1},
            {"timeout_seconds": 0},
            {"max_attempts": 0},
            {"backoff_seconds": -1},
            {"max_retry_after_seconds": -1},
            {"cooldown_on_429_seconds": -1},
            {"max_decoded_body_bytes": 0},
        )
        for values in invalid:
            with self.subTest(values=values), self.assertRaises(ValueError):
                RequestPolicy(**values)

    def test_download_refuses_content_encoding_without_residue(self) -> None:
        class EncodedBody(httpx.AsyncByteStream):
            async def __aiter__(self):
                yield gzip.compress(b"encoded artifact")

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(
                200,
                stream=EncodedBody(),
                headers={"content-encoding": "gzip", "content-length": "36"},
            )

        async def exercise(destination: Path) -> None:
            with PinnedPublicationRoot(destination.parent) as output_root:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    with self.assertRaisesRegex(
                        ProviderPayloadError,
                        "must not use content encoding",
                    ):
                        await HttpClient(raw).download_to(
                            "https://provider.example/payload",
                            str(destination),
                            publication_root=output_root,
                            allowed_hosts=("provider.example",),
                            policy=RequestPolicy(max_attempts=1),
                        )
            self.assertFalse(os.path.lexists(destination))

        with tempfile.TemporaryDirectory() as root:
            asyncio.run(exercise(Path(root) / "encoded.part"))

    def test_download_bounds_each_worker_write_even_for_one_giant_transport_chunk(self) -> None:
        payload = b"x" * (2 * procurement_http._DOWNLOAD_CHUNK_BYTES + 17)
        write_sizes: list[int] = []
        original_write = procurement_http._WorkerDownloadSink._write

        class GiantBody(httpx.AsyncByteStream):
            async def __aiter__(self):
                yield payload

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(200, stream=GiantBody())

        def observed_write(sink, chunk: bytes) -> None:
            write_sizes.append(len(chunk))
            original_write(sink, chunk)

        async def exercise(destination: Path) -> None:
            with PinnedPublicationRoot(destination.parent) as output_root:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    result = await HttpClient(raw).download_to(
                        "https://provider.example/payload",
                        str(destination),
                        publication_root=output_root,
                        allowed_hosts=("provider.example",),
                        policy=RequestPolicy(
                            max_attempts=1,
                            max_decoded_body_bytes=len(payload),
                        ),
                    )
            self.assertEqual(result.bytes, len(payload))

        with tempfile.TemporaryDirectory() as root, mock.patch.object(
            procurement_http._WorkerDownloadSink,
            "_write",
            observed_write,
        ):
            asyncio.run(exercise(Path(root) / "payload.part"))

        self.assertEqual(sum(write_sizes), len(payload))
        self.assertLessEqual(max(write_sizes), procurement_http._DOWNLOAD_CHUNK_BYTES)

    def test_download_fsync_does_not_block_the_event_loop(self) -> None:
        entered = threading.Event()
        release = threading.Event()
        loop_thread: list[int] = []
        fsync_threads: list[int] = []

        def blocking_fsync(descriptor: int) -> None:
            del descriptor
            fsync_threads.append(threading.get_ident())
            entered.set()
            if not release.wait(2):
                raise AssertionError("event loop did not remain responsive during download fsync")

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(200, content=b"bounded payload")

        async def exercise(destination: Path) -> None:
            loop_thread.append(threading.get_ident())
            with PinnedPublicationRoot(destination.parent) as output_root:
                async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                    task = asyncio.create_task(
                        HttpClient(raw).download_to(
                            "https://provider.example/payload",
                            str(destination),
                            publication_root=output_root,
                            allowed_hosts=("provider.example",),
                            policy=RequestPolicy(max_attempts=1),
                        )
                    )
                    self.assertTrue(await asyncio.to_thread(entered.wait, 1))
                    await asyncio.sleep(0)
                    self.assertFalse(task.done())
                    release.set()
                    result = await asyncio.wait_for(task, timeout=1)
            self.assertEqual(result.bytes, len(b"bounded payload"))

        try:
            with tempfile.TemporaryDirectory() as root, mock.patch(
                "procurement.transport.http.os.fsync", side_effect=blocking_fsync
            ):
                asyncio.run(exercise(Path(root) / "payload.part"))
        finally:
            release.set()
        self.assertEqual(len(fsync_threads), 1)
        self.assertNotEqual(loop_thread[0], fsync_threads[0])

    def test_retries_only_bounded_transient_statuses(self) -> None:
        attempts = 0
        sleeps: list[float] = []

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal attempts
            attempts += 1
            return httpx.Response(502 if attempts == 1 else 200, json={"ok": True})

        async def sleep(seconds: float) -> None:
            sleeps.append(seconds)

        async def exercise() -> object:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                client = HttpClient(raw, sleep=sleep)
                return await client.get_json(
                    "https://provider.example/test",
                    policy=RequestPolicy(max_attempts=2, backoff_seconds=0.25),
                )

        self.assertEqual(asyncio.run(exercise()), {"ok": True})
        self.assertEqual(attempts, 2)
        self.assertEqual(sleeps, [0.25])

    def test_rate_limit_fast_fails_without_retry(self) -> None:
        attempts = 0

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal attempts
            attempts += 1
            return httpx.Response(429, text="slow down")

        async def exercise() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                await HttpClient(raw).get_json(
                    "https://provider.example/test",
                    policy=RequestPolicy(max_attempts=3),
                )

        with self.assertRaises(ProviderRateLimitError):
            asyncio.run(exercise())
        self.assertEqual(attempts, 1)

    def test_evidence_preserves_body_and_redacts_query_credentials(self) -> None:
        body = b'{"ok":true}'
        fetched_at = datetime(2026, 8, 11, tzinfo=timezone.utc)

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(200, content=body, headers={"content-type": "application/json"})

        async def exercise():
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                return await HttpClient(raw, utc_now=lambda: fetched_at).get_document(
                    "https://provider.example/work",
                    params={"api_key": "secret", "select": "id,title"},
                )

        document = asyncio.run(exercise())
        self.assertEqual(document.body, body)
        self.assertEqual(document.fetched_at, fetched_at)
        self.assertIn("api_key=REDACTED", document.url)
        self.assertNotIn("secret", document.url)

    def test_error_messages_redact_query_credentials(self) -> None:
        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(
                400,
                text="echo api_key=secret x-api-key=TOPSECRET private@example.test",
            )

        async def exercise() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                await HttpClient(raw).get_json(
                    "https://provider.example/work",
                    params={"api_key": "secret", "mailto": "private@example.test"},
                )

        with self.assertRaises(ProviderHttpError) as raised:
            asyncio.run(exercise())
        message = str(raised.exception)
        self.assertIn("api_key=REDACTED", message)
        self.assertIn("mailto=REDACTED", message)
        self.assertNotIn("secret", message)
        self.assertNotIn("TOPSECRET", message)
        self.assertNotIn("private%40example", message)
        self.assertNotIn("private@example", message)

    def test_invalid_json_error_redacts_query_credentials(self) -> None:
        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(200, content=b"not-json")

        async def exercise() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                await HttpClient(raw).get_json(
                    "https://provider.example/work",
                    params={"api_key": "secret"},
                )

        with self.assertRaises(ProviderPayloadError) as raised:
            asyncio.run(exercise())
        self.assertIn("api_key=REDACTED", str(raised.exception))
        self.assertNotIn("secret", str(raised.exception))

    def test_evidence_is_the_exact_http_decoded_payload_used_by_the_parser(self) -> None:
        payload = b'{"decoded":true}'
        encoded = gzip.compress(payload)

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(
                200,
                content=encoded,
                headers={
                    "content-type": "application/json",
                    "content-encoding": "gzip",
                },
            )

        async def exercise():
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                return await HttpClient(raw).get_document("https://provider.example/work")

        document = asyncio.run(exercise())
        self.assertEqual(document.body, payload)
        self.assertEqual(document.json(), {"decoded": True})
        self.assertNotEqual(document.body, encoded)

    def test_chunked_response_is_rejected_at_the_decoded_body_limit(self) -> None:
        class ChunkedBody(httpx.AsyncByteStream):
            async def __aiter__(self):
                yield b"1234"
                yield b"5678"

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(200, stream=ChunkedBody())

        async def exercise() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                await HttpClient(raw).get_document(
                    "https://provider.example/work",
                    policy=RequestPolicy(max_decoded_body_bytes=7),
                )

        with self.assertRaisesRegex(ProviderPayloadError, "decoded-body limit"):
            asyncio.run(exercise())

    def test_compressed_response_is_limited_after_http_decoding(self) -> None:
        payload = b"decoded-payload"
        encoded = gzip.compress(payload)

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(
                200,
                content=encoded,
                headers={"content-encoding": "gzip"},
            )

        async def exercise() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                await HttpClient(raw).get_document(
                    "https://provider.example/work",
                    policy=RequestPolicy(max_decoded_body_bytes=len(payload) - 1),
                )

        with self.assertRaisesRegex(ProviderPayloadError, "decoded-body limit"):
            asyncio.run(exercise())

    def test_declared_oversized_response_is_rejected_before_consumption(self) -> None:
        class UnreadBody(httpx.AsyncByteStream):
            iterated = False

            async def __aiter__(self):
                type(self).iterated = True
                yield b"never read"

        def handler(request: httpx.Request) -> httpx.Response:
            return httpx.Response(
                200,
                headers={"content-length": "100"},
                stream=UnreadBody(),
            )

        async def exercise() -> None:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                await HttpClient(raw).get_document(
                    "https://provider.example/work",
                    policy=RequestPolicy(max_decoded_body_bytes=10),
                )

        with self.assertRaisesRegex(ProviderPayloadError, "decoded-body limit"):
            asyncio.run(exercise())
        self.assertFalse(UnreadBody.iterated)

    def test_provider_specific_rate_limit_retry_honors_retry_after(self) -> None:
        attempts = 0
        sleeps: list[float] = []

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal attempts
            attempts += 1
            if attempts == 1:
                return httpx.Response(429, headers={"retry-after": "2"})
            return httpx.Response(200, json={"ok": True})

        async def sleep(seconds: float) -> None:
            sleeps.append(seconds)

        async def exercise() -> object:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                return await HttpClient(raw, sleep=sleep).get_json(
                    "https://provider.example/work",
                    policy=RequestPolicy(
                        max_attempts=2,
                        retry_rate_limits=True,
                    ),
                )

        self.assertEqual(asyncio.run(exercise()), {"ok": True})
        self.assertEqual(attempts, 2)
        self.assertEqual(sleeps, [2.0])

    def test_service_unavailable_is_a_transient_retry_not_a_rate_limit(self) -> None:
        attempts = 0
        sleeps: list[float] = []

        def handler(request: httpx.Request) -> httpx.Response:
            nonlocal attempts
            attempts += 1
            if attempts == 1:
                return httpx.Response(503, headers={"retry-after": "3"})
            return httpx.Response(200, json={"ok": True})

        async def sleep(seconds: float) -> None:
            sleeps.append(seconds)

        async def exercise() -> object:
            async with httpx.AsyncClient(transport=httpx.MockTransport(handler)) as raw:
                return await HttpClient(raw, sleep=sleep).get_json(
                    "https://provider.example/work",
                    policy=RequestPolicy(max_attempts=2),
                )

        self.assertEqual(asyncio.run(exercise()), {"ok": True})
        self.assertEqual(sleeps, [3.0])
