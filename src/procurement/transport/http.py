"""Async HTTP, retry, and rate-limit mechanisms for providers."""

from __future__ import annotations

import asyncio
import hashlib
import json
import os
import random
import time
from collections.abc import Awaitable, Callable, Mapping
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from datetime import datetime, timezone
from email.utils import parsedate_to_datetime
from functools import partial
from pathlib import Path
from typing import Any, BinaryIO, TypeVar

import httpx
from filelock import FileLock, Timeout as FileLockTimeout

from jsonl_engine.publication import PinnedPublicationRoot
from procurement.errors import ProviderHttpError, ProviderPayloadError, ProviderRateLimitError
from procurement.limits import MAX_API_RESPONSE_BYTES
from procurement.domain.acquisition.planning import is_safe_artifact_url
from procurement.runtime.concurrency import await_boundary
from procurement.storage.safety import require_current

Clock = Callable[[], float]
Sleeper = Callable[[float], Awaitable[None]]
UtcNow = Callable[[], datetime]
_T = TypeVar("_T")
_DOWNLOAD_CHUNK_BYTES = 1024 * 1024
_RATE_CLOCK_ENV = "CDXSCI_PROCUREMENT_RATE_CLOCK"
_SENSITIVE_QUERY_PARAMETERS = frozenset(
    {"access_token", "api-key", "api_key", "apikey", "key", "mailto", "token"}
)


def default_rate_clock_path() -> Path:
    """Return the shared rate-clock file, honoring an explicit environment override."""

    override = os.environ.get(_RATE_CLOCK_ENV, "").strip()
    if override:
        return Path(override)
    return Path.home() / ".Codex" / "procurement" / "rate-clock.json"

DEFAULT_BROWSER_USER_AGENTS: tuple[str, ...] = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:125.0) Gecko/20100101 Firefox/125.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:125.0) Gecko/20100101 Firefox/125.0",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Safari/605.1.15",
)


def random_browser_user_agent() -> str:
    """Return a random modern desktop browser User-Agent."""

    return random.choice(DEFAULT_BROWSER_USER_AGENTS)


def browser_headers(
    *,
    user_agent: str | None = None,
    accept: str = "*/*",
) -> dict[str, str]:
    """Generate standard desktop browser headers without personal identity markers."""

    ua = user_agent or random_browser_user_agent()
    return {
        "User-Agent": ua,
        "Accept": accept,
        "Accept-Language": "en-US,en;q=0.9",
        "Accept-Encoding": "gzip, deflate, br",
        "Sec-Fetch-Dest": "document",
        "Sec-Fetch-Mode": "navigate",
        "Sec-Fetch-Site": "none",
        "Sec-Fetch-User": "?1",
        "Upgrade-Insecure-Requests": "1",
    }


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
class HttpDownload:
    """One streamed decoded response stored at a caller-owned private path."""

    url: str
    media_type: str
    fetched_at: datetime
    bytes: int
    sha256: str
    digests: tuple[tuple[str, str], ...]


@dataclass(frozen=True, slots=True)
class RequestPolicy:
    """Bounded request timing and retry policy."""

    min_interval_seconds: float = 0.0
    jitter_seconds: float = 0.0
    timeout_seconds: float = 30.0
    max_attempts: int = 3
    backoff_seconds: float = 0.4
    retry_statuses: frozenset[int] = field(
        default_factory=lambda: frozenset({500, 502, 503, 504})
    )
    rate_limit_statuses: frozenset[int] = field(default_factory=lambda: frozenset({429}))
    retry_rate_limits: bool = False
    max_retry_after_seconds: float = 120.0
    cooldown_on_429_seconds: float = 60.0
    max_decoded_body_bytes: int = MAX_API_RESPONSE_BYTES

    def __post_init__(self) -> None:
        if self.min_interval_seconds < 0 or self.timeout_seconds <= 0:
            raise ValueError("request timing values must be positive")
        if self.jitter_seconds < 0:
            raise ValueError("jitter_seconds must not be negative")
        if self.max_attempts < 1:
            raise ValueError("max_attempts must be at least one")
        if (
            self.backoff_seconds < 0
            or self.max_retry_after_seconds < 0
            or self.cooldown_on_429_seconds < 0
        ):
            raise ValueError("retry timing values must not be negative")
        if self.max_decoded_body_bytes < 1:
            raise ValueError("max_decoded_body_bytes must be at least one")


class _WorkerDownloadSink:
    """Write and hash one bounded stream on a dedicated filesystem worker."""

    def __init__(
        self,
        destination: str,
        algorithms: tuple[str, ...],
        publication_root: PinnedPublicationRoot,
    ) -> None:
        self._destination = destination
        self._algorithms = algorithms
        self._publication_root = publication_root
        self._executor = ThreadPoolExecutor(
            max_workers=1,
            thread_name_prefix="procurement-download",
        )
        self._handle: BinaryIO | None = None
        self._digesters: dict[str, Any] = {}
        self._total = 0
        self._owns_destination = False

    def _submit(self, function: Callable[..., _T], *args: object):
        loop = asyncio.get_running_loop()
        return loop.run_in_executor(self._executor, partial(function, *args))

    async def _run(self, function: Callable[..., _T], *args: object) -> _T:
        """Settle one worker operation before propagating any cancellation."""

        future = self._submit(function, *args)
        return await await_boundary(future)

    def _open(self) -> None:
        self._handle = self._publication_root.open_file(self._destination, "xb")
        self._owns_destination = True
        self._digesters = {name: hashlib.new(name) for name in self._algorithms}

    def _write(self, chunk: bytes) -> None:
        if self._handle is None:
            raise RuntimeError("download sink is not open")
        written = self._handle.write(chunk)
        if written != len(chunk):
            raise OSError(
                f"short artifact write ({written} of {len(chunk)} bytes): "
                f"'{self._destination}'"
            )
        for digester in self._digesters.values():
            digester.update(chunk)
        self._total += written

    def _finish(self) -> tuple[int, tuple[tuple[str, str], ...]]:
        if self._handle is None:
            raise RuntimeError("download sink is not open")
        try:
            self._handle.flush()
            os.fsync(self._handle.fileno())
        finally:
            self._handle.close()
            self._handle = None
        return self._total, tuple(
            (name, self._digesters[name].hexdigest()) for name in self._algorithms
        )

    def _abort(self) -> None:
        if self._handle is not None:
            try:
                self._handle.close()
            finally:
                self._handle = None
        if self._owns_destination:
            try:
                self._publication_root.unlink(self._destination)
            except FileNotFoundError:
                pass

    async def open(self) -> None:
        await self._run(self._open)

    async def write(self, chunk: bytes) -> None:
        await self._run(self._write, chunk)

    async def finish(self) -> tuple[int, tuple[tuple[str, str], ...]]:
        return await self._run(self._finish)

    async def abort(self) -> None:
        await self._run(self._abort)

    def shutdown(self) -> None:
        """Release the idle worker after its file boundary has settled."""

        self._executor.shutdown(wait=True, cancel_futures=True)


class RateLimiter:
    """Per-key request clocks, optionally file-locked across processes."""

    def __init__(
        self,
        *,
        clock: Clock | None = None,
        sleep: Sleeper = asyncio.sleep,
        jitter_generator: Callable[[float], float] | None = None,
        state_path: str | Path | None = None,
        lock_timeout: float = 60.0,
    ) -> None:
        if lock_timeout <= 0:
            raise ValueError("lock_timeout must be positive")
        self._state_path = Path(state_path) if state_path is not None else None
        if clock is None:
            self._clock = time.time if self._state_path is not None else time.monotonic
        else:
            self._clock = clock
        self._sleep = sleep
        self._jitter_generator = jitter_generator or (
            lambda max_j: random.uniform(0, max_j) if max_j > 0 else 0.0
        )
        self._last_request: dict[str, float] = {}
        self._locks: dict[str, asyncio.Lock] = {}
        self._lock_timeout = lock_timeout

    async def wait(
        self,
        key: str,
        interval_seconds: float,
        jitter_seconds: float = 0.0,
    ) -> None:
        if interval_seconds <= 0 and jitter_seconds <= 0:
            return
        lock = self._locks.setdefault(key, asyncio.Lock())
        async with lock:
            jitter = self._jitter_generator(jitter_seconds) if jitter_seconds > 0 else 0.0
            effective_interval = interval_seconds + jitter
            if self._state_path is None:
                now = self._clock()
                last = self._last_request.get(key)
                if last is not None:
                    remaining = effective_interval - (now - last)
                    if remaining > 0:
                        await self._sleep(remaining)
                self._last_request[key] = self._clock()
                return
            remaining = await self._run_sync(self._reserve, key, effective_interval)
            if remaining > 0:
                await self._sleep(remaining)

    def penalize(self, key: str, seconds: float) -> None:
        """Lock out subsequent requests on this key for a cooldown period."""

        if seconds <= 0:
            return
        if self._state_path is None:
            now = self._clock()
            current = self._last_request.get(key, now)
            self._last_request[key] = max(current, now) + seconds
            return
        self._mutate_state(lambda data: self._penalize_state(data, key, seconds))

    async def _run_sync(self, function: Callable[..., _T], *args: object) -> _T:
        loop = asyncio.get_running_loop()
        future = loop.run_in_executor(None, partial(function, *args))
        return await await_boundary(future)

    def _reserve(self, key: str, effective_interval: float) -> float:
        def mutate(data: dict[str, float]) -> float:
            now = self._clock()
            last = data.get(key)
            next_ok = now if last is None else max(now, last + effective_interval)
            data[key] = next_ok
            return max(0.0, next_ok - now)

        return self._mutate_state(mutate)

    def _penalize_state(self, data: dict[str, float], key: str, seconds: float) -> None:
        now = self._clock()
        current = data.get(key, now)
        data[key] = max(current, now) + seconds

    def _mutate_state(self, mutator: Callable[[dict[str, float]], _T]) -> _T:
        if self._state_path is None:
            raise RuntimeError("rate clock has no state path")
        path = self._state_path
        path.parent.mkdir(parents=True, exist_ok=True)
        lease = FileLock(f"{path}.lock", timeout=self._lock_timeout)
        try:
            lease.acquire()
        except FileLockTimeout as exc:
            raise ProviderHttpError(
                f"could not acquire shared rate clock within {self._lock_timeout}s"
            ) from exc
        try:
            data = _read_rate_clock(path)
            result = mutator(data)
            _write_rate_clock(path, data)
            return result
        finally:
            lease.release()


def _read_rate_clock(path: Path) -> dict[str, float]:
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        return {}
    except (OSError, UnicodeError, json.JSONDecodeError, ValueError):
        return {}
    keys = payload.get("keys") if isinstance(payload, dict) else None
    if not isinstance(keys, dict):
        return {}
    parsed: dict[str, float] = {}
    for name, value in keys.items():
        if isinstance(name, str) and isinstance(value, (int, float)):
            parsed[name] = float(value)
    return parsed


def _write_rate_clock(path: Path, data: dict[str, float]) -> None:
    payload = json.dumps({"keys": data}, separators=(",", ":"), ensure_ascii=True)
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(payload + "\n", encoding="utf-8")
    os.replace(temporary, path)


class HttpClient:
    """Owned HTTPX client with injected rate and retry state."""

    def __init__(
        self,
        client: httpx.AsyncClient | None = None,
        *,
        rate_limiter: RateLimiter | None = None,
        sleep: Sleeper = asyncio.sleep,
        utc_now: UtcNow = lambda: datetime.now(timezone.utc),
        http2: bool = True,
    ) -> None:
        self._client = client or httpx.AsyncClient(follow_redirects=False, http2=http2)
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
        allowed_hosts: tuple[str, ...] | None = None,
        max_redirects: int = 5,
    ) -> httpx.Response:
        if max_redirects < 0:
            raise ValueError("max_redirects must not be negative")
        seed_request = self._client.build_request(
            "GET",
            url,
            params=params,
            headers=headers,
            timeout=policy.timeout_seconds,
        )
        seed_url = seed_request.url
        seed_host = (seed_url.host or "").casefold().strip(".")
        allowed = frozenset(
            host.casefold().strip(".")
            for host in (allowed_hosts if allowed_hosts is not None else (seed_host,))
        )
        if not allowed:
            raise ValueError("provider request requires at least one allowed host")
        if not is_safe_artifact_url(str(seed_url)) or seed_host not in allowed:
            raise ProviderHttpError(
                "provider route requires HTTPS or loopback HTTP on an allowed host at "
                f"{self._evidence_url(seed_url)}"
            )
        key = rate_key or seed_host
        last_error: Exception | None = None
        for attempt in range(1, policy.max_attempts + 1):
            current_url = seed_url
            previous_scheme: str | None = None
            response: httpx.Response | None = None
            try:
                for redirect_count in range(max_redirects + 1):
                    host = (current_url.host or "").casefold().strip(".")
                    scheme = current_url.scheme.casefold()
                    if previous_scheme == "https" and scheme == "http":
                        raise ProviderHttpError(
                            "provider redirect attempted an HTTPS-to-HTTP downgrade at "
                            f"{self._evidence_url(current_url)}"
                        )
                    if not is_safe_artifact_url(str(current_url)) or host not in allowed:
                        raise ProviderHttpError(
                            "provider route left its allowed hosts or safe transport at "
                            f"{self._evidence_url(current_url)}"
                        )
                    await self._limiter.wait(
                        rate_key or host,
                        policy.min_interval_seconds,
                        policy.jitter_seconds,
                    )
                    request = self._client.build_request(
                        "GET",
                        current_url,
                        headers=headers,
                        timeout=policy.timeout_seconds,
                    )
                    response = await self._client.send(
                        request,
                        stream=True,
                        follow_redirects=False,
                    )
                    if response.status_code not in {301, 302, 303, 307, 308}:
                        break
                    location = response.headers.get("location")
                    await response.aclose()
                    response = None
                    if not location:
                        raise ProviderHttpError(
                            "provider redirect omitted Location for "
                            f"{self._evidence_url(current_url)}"
                        )
                    if redirect_count == max_redirects:
                        raise ProviderHttpError(
                            f"provider route exceeded {max_redirects} redirects for "
                            f"{self._evidence_url(current_url)}"
                        )
                    previous_scheme = scheme
                    current_url = current_url.join(location)
            except httpx.TransportError as exc:
                last_error = exc
                if attempt == policy.max_attempts:
                    raise ProviderHttpError(
                        f"network request failed for {key}: {type(exc).__name__}"
                    ) from exc
            else:
                if response is None:
                    raise ProviderHttpError("provider route produced no response")
                if 200 <= response.status_code < 300:
                    return await self._bounded_response(response, policy)
                await response.aclose()
                message = self._response_message(response)
                if response.status_code in policy.rate_limit_statuses:
                    has_explicit_retry_after = bool(response.headers.get("retry-after"))
                    retry_default = policy.backoff_seconds * (2 ** (attempt - 1))
                    if not has_explicit_retry_after:
                        retry_default = max(policy.cooldown_on_429_seconds, retry_default)
                    delay = self._retry_after_seconds(response, default=retry_default)
                    self._limiter.penalize(key, delay)
                    if not policy.retry_rate_limits or attempt == policy.max_attempts:
                        raise ProviderRateLimitError(message, status_code=response.status_code)
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

    async def download_to(
        self,
        url: str,
        destination: str,
        *,
        publication_root: PinnedPublicationRoot,
        allowed_hosts: tuple[str, ...],
        headers: Mapping[str, str] | None = None,
        rate_key: str | None = None,
        policy: RequestPolicy = RequestPolicy(),
        hash_algorithms: tuple[str, ...] = (),
        max_redirects: int = 5,
    ) -> HttpDownload:
        """Stream one bounded response into an active pinned directory generation."""

        if not isinstance(publication_root, PinnedPublicationRoot):
            raise TypeError("download_to requires an active PinnedPublicationRoot")
        require_current(
            publication_root,
            label="artifact destination",
            error=ProviderPayloadError,
        )
        publication_root.direct_leaf(destination)
        allowed = frozenset(host.casefold().strip(".") for host in allowed_hosts)
        if not allowed:
            raise ValueError("download_to requires at least one allowed host")
        if publication_root.lexists(destination):
            raise FileExistsError(f"private download path already exists: '{destination}'")
        algorithms = tuple(dict.fromkeys(("sha256", *hash_algorithms)))
        try:
            for name in algorithms:
                hashlib.new(name)
        except ValueError as exc:
            raise ValueError(f"unsupported download hash algorithm: {exc}") from exc

        last_error: Exception | None = None
        for attempt in range(1, policy.max_attempts + 1):
            current_url = httpx.URL(url)
            previous_scheme: str | None = None
            response: httpx.Response | None = None
            sink: _WorkerDownloadSink | None = None
            completed = False
            try:
                for redirect_count in range(max_redirects + 1):
                    host = (current_url.host or "").casefold().strip(".")
                    scheme = current_url.scheme.casefold()
                    if previous_scheme == "https" and scheme == "http":
                        raise ProviderHttpError(
                            "artifact redirect attempted an HTTPS-to-HTTP downgrade at "
                            f"{self._evidence_url(current_url)}"
                        )
                    if not is_safe_artifact_url(str(current_url)) or host not in allowed:
                        raise ProviderHttpError(
                            "artifact route left its allowed hosts or safe transport at "
                            f"{self._evidence_url(current_url)}"
                        )
                    await self._limiter.wait(
                        rate_key or host,
                        policy.min_interval_seconds,
                        policy.jitter_seconds,
                    )
                    request = self._client.build_request(
                        "GET",
                        current_url,
                        headers=headers,
                        timeout=policy.timeout_seconds,
                    )
                    response = await self._client.send(
                        request,
                        stream=True,
                        follow_redirects=False,
                    )
                    if response.status_code not in {301, 302, 303, 307, 308}:
                        break
                    location = response.headers.get("location")
                    await response.aclose()
                    response = None
                    if not location:
                        raise ProviderHttpError(
                            f"artifact redirect omitted Location for {self._evidence_url(current_url)}"
                        )
                    if redirect_count == max_redirects:
                        raise ProviderHttpError(
                            f"artifact route exceeded {max_redirects} redirects for "
                            f"{self._evidence_url(current_url)}"
                        )
                    previous_scheme = scheme
                    current_url = current_url.join(location)

                if response is None:
                    raise ProviderHttpError("artifact route produced no response")
                if not 200 <= response.status_code < 300:
                    status = response.status_code
                    message = self._response_message(response)
                    retry_default = policy.backoff_seconds * (2 ** (attempt - 1))
                    has_explicit_retry_after = bool(response.headers.get("retry-after"))
                    if status in policy.rate_limit_statuses and not has_explicit_retry_after:
                        retry_default = max(policy.cooldown_on_429_seconds, retry_default)
                    retry_after = self._retry_after_seconds(response, default=retry_default)
                    await response.aclose()
                    response = None
                    if status in policy.rate_limit_statuses:
                        delay = retry_after
                        self._limiter.penalize(rate_key or host, delay)
                        error = ProviderRateLimitError(message, status_code=status)
                        if not policy.retry_rate_limits or attempt == policy.max_attempts:
                            raise error
                        if delay > policy.max_retry_after_seconds:
                            raise error
                        last_error = error
                        await self._sleep(delay)
                        continue
                    error = ProviderHttpError(message, status_code=status)
                    if status not in policy.retry_statuses or attempt == policy.max_attempts:
                        raise error
                    last_error = error
                    delay = retry_after if status == 503 else retry_default
                    if delay > policy.max_retry_after_seconds:
                        raise error
                    await self._sleep(delay)
                    continue

                if "content-encoding" in response.headers:
                    raise ProviderPayloadError(
                        "artifact response must not use content encoding for "
                        f"{self._evidence_url(response.url)}"
                    )
                try:
                    declared_length: int | None = int(
                        response.headers.get("content-length", "")
                    )
                except ValueError:
                    declared_length = None
                if declared_length is not None and declared_length > policy.max_decoded_body_bytes:
                    raise ProviderPayloadError(
                        "artifact response exceeds the decoded-body limit for "
                        f"{self._evidence_url(response.url)}"
                    )

                total = 0
                sink = _WorkerDownloadSink(destination, algorithms, publication_root)
                await sink.open()
                async for chunk in response.aiter_bytes(chunk_size=_DOWNLOAD_CHUNK_BYTES):
                    total += len(chunk)
                    if total > policy.max_decoded_body_bytes:
                        raise ProviderPayloadError(
                            "artifact response exceeds the decoded-body limit for "
                            f"{self._evidence_url(response.url)}"
                        )
                    # Awaiting each worker write bounds queued data to the current HTTP chunk.
                    await sink.write(chunk)
                written, digests = await sink.finish()
                if written != total:
                    raise ProviderPayloadError(
                        f"artifact response could not be stored completely for "
                        f"{self._evidence_url(response.url)}"
                    )
                if declared_length is not None and total != declared_length:
                    raise ProviderPayloadError(
                        f"artifact response was truncated for {self._evidence_url(response.url)}"
                    )
                require_current(
                    publication_root,
                    label="artifact destination",
                    error=ProviderPayloadError,
                )
                media_type = response.headers.get("content-type", "application/octet-stream")
                media_type = media_type.split(";", 1)[0].strip().casefold()
                completed = True
                return HttpDownload(
                    url=self._evidence_url(response.url),
                    media_type=media_type,
                    fetched_at=self._utc_now(),
                    bytes=total,
                    sha256=dict(digests)["sha256"],
                    digests=digests,
                )
            except (httpx.TransportError, httpx.StreamError) as exc:
                last_error = exc
                if attempt == policy.max_attempts:
                    raise ProviderHttpError(
                        f"artifact request failed: {type(exc).__name__}"
                    ) from exc
            finally:
                try:
                    if response is not None:
                        await response.aclose()
                finally:
                    if sink is not None:
                        try:
                            if not completed:
                                await sink.abort()
                        finally:
                            sink.shutdown()
            await self._sleep(policy.backoff_seconds * (2 ** (attempt - 1)))
        raise ProviderHttpError(f"artifact request attempts exhausted: {last_error}")

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
