"""Async HTTP, retry, and rate-limit mechanisms for providers."""

from __future__ import annotations

import asyncio
import json
import time
from collections.abc import Awaitable, Callable, Mapping
from dataclasses import dataclass, field
from typing import Any

import httpx

from procurement.errors import ProviderHttpError, ProviderPayloadError, ProviderRateLimitError

Clock = Callable[[], float]
Sleeper = Callable[[float], Awaitable[None]]


@dataclass(frozen=True, slots=True)
class RequestPolicy:
    """Bounded request timing and retry policy."""

    min_interval_seconds: float = 0.0
    timeout_seconds: float = 30.0
    max_attempts: int = 3
    backoff_seconds: float = 0.4
    retry_statuses: frozenset[int] = field(default_factory=lambda: frozenset({500, 502, 504}))
    rate_limit_statuses: frozenset[int] = field(default_factory=lambda: frozenset({429, 503}))

    def __post_init__(self) -> None:
        if self.min_interval_seconds < 0 or self.timeout_seconds <= 0:
            raise ValueError("request timing values must be positive")
        if self.max_attempts < 1:
            raise ValueError("max_attempts must be at least one")


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
    ) -> None:
        self._client = client or httpx.AsyncClient(follow_redirects=True)
        self._owns_client = client is None
        self._limiter = rate_limiter or RateLimiter(sleep=sleep)
        self._sleep = sleep

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
                response = await self._client.get(
                    url,
                    params=params,
                    headers=headers,
                    timeout=policy.timeout_seconds,
                )
            except httpx.TransportError as exc:
                last_error = exc
                if attempt == policy.max_attempts:
                    raise ProviderHttpError(f"network request failed for {key}: {exc}") from exc
            else:
                if 200 <= response.status_code < 300:
                    return response
                message = self._response_message(response)
                if response.status_code in policy.rate_limit_statuses:
                    raise ProviderRateLimitError(message, status_code=response.status_code)
                if response.status_code not in policy.retry_statuses or attempt == policy.max_attempts:
                    raise ProviderHttpError(message, status_code=response.status_code)
                last_error = ProviderHttpError(message, status_code=response.status_code)
            await self._sleep(policy.backoff_seconds * (2 ** (attempt - 1)))
        raise ProviderHttpError(f"request attempts exhausted for {key}: {last_error}")

    async def get_json(self, url: str, **kwargs: Any) -> Any:
        response = await self.get(url, **kwargs)
        try:
            return response.json()
        except (json.JSONDecodeError, UnicodeDecodeError, ValueError) as exc:
            raise ProviderPayloadError(f"provider returned invalid JSON from {response.url}") from exc

    async def get_text(self, url: str, **kwargs: Any) -> str:
        response = await self.get(url, **kwargs)
        try:
            return response.text
        except UnicodeDecodeError as exc:
            raise ProviderPayloadError(f"provider returned undecodable text from {response.url}") from exc

    @staticmethod
    def _response_message(response: httpx.Response) -> str:
        body = response.text.strip().replace("\r", " ").replace("\n", " ")[:500]
        suffix = f": {body}" if body else ""
        return f"provider request failed (HTTP {response.status_code}) for {response.url}{suffix}"
