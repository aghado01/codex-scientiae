"""HTTP retry and rate-state contracts."""

from __future__ import annotations

import asyncio
import gzip
import unittest
from datetime import datetime, timezone

import httpx

from procurement.errors import ProviderHttpError, ProviderPayloadError, ProviderRateLimitError
from procurement.http import HttpClient, RateLimiter, RequestPolicy


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


class TestHttpClient(unittest.TestCase):
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
