"""Async HTTP, retry, and rate-limit mechanisms for providers."""

from __future__ import annotations

import asyncio
import json
import time
from collections.abc import Awaitable, Callable, Mapping
from dataclasses import dataclass, field
from datetime import datetime, timezone
from email.utils import parsedate_to_datetime
from typing import Any

import httpx

from procurement.errors import ProviderHttpError, ProviderPayloadError, ProviderRateLimitError
from procurement.limits import MAX_API_RESPONSE_BYTES

Clock = Callable[[], float]
Sleeper = Callable[[float], Awaitable[None]]
UtcNow = Callable[[], datetime]
_SENSITIVE_QUERY_PARAMETERS = frozenset(
    {"access_token", "api-key", "api_key", "apikey", "key", "mailto", "token"}
)


@dataclass(frozen=True, slots=True)
class HttpDocument:
    """HTTP-decoded payload bytes consumed by a provider parser and retrieval facts."""

    url: str
    media_type: str
    fetched_at: datetime
    body: bytes
    text: str

    def json(self) -> Any:
        return json.loads(self.body)


@dataclass(frozen=True, slots=True)
class RequestPolicy:
    """Bounded request timing and retry policy."""

    min_interval_seconds: float = 0.0
    timeout_seconds: float = 30.0
    max_attempts: int = 3
    backoff_seconds: float = 0.4
    retry_statuses: frozenset[int] = field(
        default_factory=lambda: frozenset({500, 502, 503, 504})
    )
    rate_limit_statuses: frozenset[int] = field(default_factory=lambda: frozenset({429}))
    retry_rate_limits: bool = False
    max_retry_after_seconds: float = 30.0
    max_decoded_body_bytes: int = MAX_API_RESPONSE_BYTES

    def __post_init__(self) -> None:
        if self.min_interval_seconds < 0 or self.timeout_seconds <= 0:
            raise ValueError("request timing values must be positive")
        if self.max_attempts < 1:
            raise ValueError("max_attempts must be at least one")
        if self.backoff_seconds < 0 or self.max_retry_after_seconds < 0:
            raise ValueError("retry timing values must not be negative")
        if self.max_decoded_body_bytes < 1:
            raise ValueError("max_decoded_body_bytes must be at least one")


class RateLimiter:
    """Per-key monotonic request clocks shared by concurrent provider calls."""

    def __init__(self, *, clock: Clock = time.monotonic, sleep: Sleeper = asyncio.sleep) -> None:
        self._clock = clock
        self._sleep = sleep
        self._last_request: dict[str, float] = {}
        self._locks: dict[str, asyncio.Lock] = {}

    async def wait(self, key: str, interval_seconds: float) -> None:
        if interval_seconds <= 0:
            return
        lock = self._locks.setdefault(key, asyncio.Lock())
        async with lock:
            now = self._clock()
            last = self._last_request.get(key)
            if last is not None:
                remaining = interval_seconds - (now - last)
                if remaining > 0:
                    await self._sleep(remaining)
            self._last_request[key] = self._clock()


class HttpClient:
    """Owned HTTPX client with injected rate and retry state."""

    def __init__(
        self,
        client: httpx.AsyncClient | None = None,
        *,
        rate_limiter: RateLimiter | None = None,
        sleep: Sleeper = asyncio.sleep,
        utc_now: UtcNow = lambda: datetime.now(timezone.utc),
    ) -> None:
        self._client = client or httpx.AsyncClient(follow_redirects=True)
        self._owns_client = client is None
        self._limiter = rate_limiter or RateLimiter(sleep=sleep)
        self._sleep = sleep
        self._utc_now = utc_now

    async def close(self) -> None:
        if self._owns_client:
            await self._client.aclose()

    async def get(
        self,
        url: str,
        *,
        params: Mapping[str, Any] | None = None,
        headers: Mapping[str, str] | None = None,
        rate_key: str | None = None,
        policy: RequestPolicy = RequestPolicy(),
    ) -> httpx.Response:
        key = rate_key or httpx.URL(url).host
        last_error: Exception | None = None
        for attempt in range(1, policy.max_attempts + 1):
            await self._limiter.wait(key, policy.min_interval_seconds)
            try:
                request = self._client.build_request(
                    "GET",
                    url,
                    params=params,
                    headers=headers,
                    timeout=policy.timeout_seconds,
                )
                response = await self._client.send(request, stream=True)
            except httpx.TransportError as exc:
                last_error = exc
                if attempt == policy.max_attempts:
                    raise ProviderHttpError(
                        f"network request failed for {key}: {type(exc).__name__}"
                    ) from exc
            else:
                if 200 <= response.status_code < 300:
                    return await self._bounded_response(response, policy)
                await response.aclose()
                message = self._response_message(response)
                if response.status_code in policy.rate_limit_statuses:
                    if not policy.retry_rate_limits or attempt == policy.max_attempts:
                        raise ProviderRateLimitError(message, status_code=response.status_code)
                    delay = self._retry_after_seconds(
                        response,
                        default=policy.backoff_seconds * (2 ** (attempt - 1)),
                    )
                    if delay > policy.max_retry_after_seconds:
                        raise ProviderRateLimitError(message, status_code=response.status_code)
                    last_error = ProviderRateLimitError(
                        message,
                        status_code=response.status_code,
                    )
                    await self._sleep(delay)
                    continue
                if response.status_code not in policy.retry_statuses or attempt == policy.max_attempts:
                    raise ProviderHttpError(message, status_code=response.status_code)
                last_error = ProviderHttpError(message, status_code=response.status_code)
                delay = policy.backoff_seconds * (2 ** (attempt - 1))
                if response.status_code == 503:
                    delay = self._retry_after_seconds(response, default=delay)
                if delay > policy.max_retry_after_seconds:
                    raise ProviderHttpError(message, status_code=response.status_code)
                await self._sleep(delay)
                continue
            await self._sleep(policy.backoff_seconds * (2 ** (attempt - 1)))
        raise ProviderHttpError(f"request attempts exhausted for {key}: {last_error}")

    async def _bounded_response(
        self,
        response: httpx.Response,
        policy: RequestPolicy,
    ) -> httpx.Response:
        """Buffer at most the configured HTTP-decoded entity bytes."""

        content_length = response.headers.get("content-length")
        if content_length is not None:
            try:
                declared_length = int(content_length)
            except ValueError:
                declared_length = None
            if (
                declared_length is not None
                and declared_length > policy.max_decoded_body_bytes
            ):
                await response.aclose()
                raise ProviderPayloadError(
                    "provider response exceeds the decoded-body limit for "
                    f"{self._evidence_url(response.url)}"
                )

        chunks: list[bytes] = []
        total = 0
        try:
            async for chunk in response.aiter_bytes():
                total += len(chunk)
                if total > policy.max_decoded_body_bytes:
                    raise ProviderPayloadError(
                        "provider response exceeds the decoded-body limit for "
                        f"{self._evidence_url(response.url)}"
                    )
                chunks.append(chunk)
        except ProviderPayloadError:
            raise
        except httpx.HTTPError as exc:
            raise ProviderHttpError(
                "provider response stream failed for "
                f"{self._evidence_url(response.url)}: {type(exc).__name__}"
            ) from exc
        finally:
            await response.aclose()

        decoded_headers = [
            (name, value)
            for name, value in response.headers.multi_items()
            if name.casefold() not in {"content-encoding", "content-length"}
        ]
        return httpx.Response(
            response.status_code,
            headers=decoded_headers,
            content=b"".join(chunks),
            request=response.request,
            extensions=response.extensions,
        )

    async def get_json(self, url: str, **kwargs: Any) -> Any:
        response = await self.get(url, **kwargs)
        try:
            return response.json()
        except (json.JSONDecodeError, UnicodeDecodeError, ValueError) as exc:
            raise ProviderPayloadError(
                f"provider returned invalid JSON from {self._evidence_url(response.url)}"
            ) from exc

    async def get_document(self, url: str, **kwargs: Any) -> HttpDocument:
        """Return the exact HTTP-decoded payload bytes handed to provider parsers."""

        response = await self.get(url, **kwargs)
        media_type = response.headers.get("content-type", "application/octet-stream")
        media_type = media_type.split(";", 1)[0].strip().casefold()
        return HttpDocument(
            url=self._evidence_url(response.url),
            media_type=media_type,
            fetched_at=self._utc_now(),
            body=response.content,
            text=self._strict_text(response),
        )

    @staticmethod
    def _evidence_url(url: httpx.URL) -> str:
        """Return a request URL with common credential parameters redacted."""

        parameters = [
            (
                key,
                "REDACTED" if key.casefold() in _SENSITIVE_QUERY_PARAMETERS else value,
            )
            for key, value in url.params.multi_items()
        ]
        return str(httpx.URL(url.copy_with(query=None), params=parameters))

    async def get_text(self, url: str, **kwargs: Any) -> str:
        response = await self.get(url, **kwargs)
        return self._strict_text(response)

    @classmethod
    def _strict_text(cls, response: httpx.Response) -> str:
        try:
            return response.content.decode(response.encoding or "utf-8", errors="strict")
        except (LookupError, UnicodeDecodeError) as exc:
            raise ProviderPayloadError(
                f"provider returned undecodable text from {cls._evidence_url(response.url)}"
            ) from exc

    def _retry_after_seconds(self, response: httpx.Response, *, default: float) -> float:
        value = response.headers.get("retry-after")
        if not value:
            return default
        try:
            return max(0.0, float(value))
        except ValueError:
            try:
                retry_at = parsedate_to_datetime(value)
            except (TypeError, ValueError, OverflowError):
                return default
            if retry_at.tzinfo is None:
                retry_at = retry_at.replace(tzinfo=timezone.utc)
            now = self._utc_now()
            if now.tzinfo is None:
                now = now.replace(tzinfo=timezone.utc)
            return max(0.0, (retry_at - now).total_seconds())

    @classmethod
    def _response_message(cls, response: httpx.Response) -> str:
        return (
            f"provider request failed (HTTP {response.status_code}) "
            f"for {cls._evidence_url(response.url)}"
        )
