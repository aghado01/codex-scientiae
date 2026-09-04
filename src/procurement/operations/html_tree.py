"""Page-requisite HTML tree retrieval and fingerprinting.

HTML artifacts are one confined directory named ``{slug}-html``. The landing document is
``{slug}.html``; same-prefix figures are siblings or descendants. Links are not rewritten.
"""

from __future__ import annotations

import hashlib
import os
import stat
from collections.abc import Iterable
from dataclasses import dataclass, replace
from datetime import datetime
from html.parser import HTMLParser
from urllib.parse import urldefrag, urljoin, urlsplit, urlunsplit

from jsonl_engine.publication import PinnedPublicationRoot
from procurement.domain.acquisition.planning import ChecksumExpectation, is_safe_artifact_url
from procurement.domain.deposits import is_portable_leaf, validate_deposit_slug
from procurement.errors import (
    AcquisitionConflictError,
    AcquisitionError,
    ArtifactUnavailableError,
    ProviderHttpError,
)
from procurement.storage.safety import is_link_or_reparse, require_current
from procurement.transport.http import HttpClient, RequestPolicy, browser_headers

HTML_PARTIAL_LEAF = ".html.part"
_ARXIV_PAPER_MARKER = "ltx_document"
_SRC_ATTRIBUTES: dict[str, tuple[str, ...]] = {
    "audio": ("src",),
    "embed": ("src",),
    "image": ("href", "src"),
    "img": ("src", "srcset"),
    "object": ("data",),
    "source": ("src", "srcset"),
    "use": ("href",),
    "video": ("poster", "src"),
}


@dataclass(frozen=True, slots=True)
class HtmlTreeIdentity:
    """Measured members of one HTML source tree."""

    entrypoint: str
    files: int
    bytes: int
    sha256: str
    members: tuple[str, ...]
    fetched_at: datetime | None = None


class _RequisiteCollector(HTMLParser):
    """Collect page-requisite URLs; skip navigation, scripts, and stylesheets."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.urls: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        names = _SRC_ATTRIBUTES.get(tag.casefold())
        if names is None:
            return
        by_name = {key.casefold(): value for key, value in attrs}
        for name in names:
            raw = by_name.get(name)
            if not raw:
                continue
            if name == "srcset":
                self.urls.extend(_split_srcset(raw))
            else:
                self.urls.append(raw.strip())


def _split_srcset(value: str) -> list[str]:
    urls: list[str] = []
    for item in value.split(","):
        token = item.strip().split(None, 1)
        if token:
            urls.append(token[0])
    return urls


def html_tree_leaf(slug: str) -> str:
    """Return the deposit directory leaf for one HTML tree."""

    return f"{validate_deposit_slug(slug)}-html"


def html_entrypoint_leaf(slug: str) -> str:
    """Return the landing-document leaf inside one HTML tree."""

    return f"{validate_deposit_slug(slug)}.html"


def html_prefix_path(landing_url: str) -> str:
    """Return the confined URL path prefix for one HTML landing route."""

    path = urlsplit(landing_url).path
    if not path or path == "/":
        raise AcquisitionError("HTML landing URL is missing a path")
    return path.rstrip("/") or "/"


_FILE_LIKE_SUFFIXES = (
    ".gif",
    ".htm",
    ".html",
    ".jpeg",
    ".jpg",
    ".pdf",
    ".png",
    ".svg",
    ".xhtml",
    ".xml",
)


def html_join_base(final_url: str) -> str:
    """Return the URL join base so directory landings keep sibling requisites."""

    parts = urlsplit(final_url)
    if parts.path.endswith("/"):
        return final_url
    last = parts.path.rsplit("/", 1)[-1].casefold()
    if any(last.endswith(suffix) for suffix in _FILE_LIKE_SUFFIXES):
        return final_url
    return urlunsplit((parts.scheme, parts.netloc, f"{parts.path}/", parts.query, parts.fragment))


def is_html_document(head: str) -> bool:
    """Return whether a decoded prefix looks like an HTML document."""

    folded = head.casefold()
    return "<html" in folded or "<!doctype html" in folded


def is_arxiv_html_paper(head: str) -> bool:
    """Return whether a decoded prefix looks like a LaTeXML arXiv HTML paper."""

    return is_html_document(head) and _ARXIV_PAPER_MARKER in head.casefold()


def html_probe_accepts(head: str, *, provider: str) -> bool:
    """Return whether a landing body is an acceptable HTML artifact for one provider."""

    if provider.casefold() == "arxiv":
        return is_arxiv_html_paper(head)
    return is_html_document(head)


def collect_html_requisites(document: str) -> tuple[str, ...]:
    """Return unique raw requisite URLs from one HTML document, in document order."""

    parser = _RequisiteCollector()
    parser.feed(document)
    parser.close()
    seen: set[str] = set()
    urls: list[str] = []
    for raw in parser.urls:
        if raw not in seen:
            seen.add(raw)
            urls.append(raw)
    return tuple(urls)


def confine_html_requisite(
    raw: str,
    *,
    base: str,
    prefix_path: str,
    allowed_hosts: Iterable[str],
) -> str | None:
    """Return one same-prefix HTTPS URL, or None when the reference is out of bounds."""

    if not raw or not raw.strip() or raw.strip().startswith(("data:", "javascript:", "mailto:")):
        return None
    allowed = frozenset(host.casefold().strip(".") for host in allowed_hosts)
    joined, _fragment = urldefrag(urljoin(base, raw.strip()))
    parsed = urlsplit(joined)
    if parsed.query:
        return None
    host = (parsed.hostname or "").casefold().strip(".")
    if not is_safe_artifact_url(joined) or host not in allowed:
        return None
    path = parsed.path
    prefix = prefix_path.rstrip("/") or "/"
    if path != prefix and not path.startswith(f"{prefix}/"):
        return None
    remainder = "" if path == prefix or path == f"{prefix}/" else path[len(prefix) + 1 :]
    if remainder:
        parts = remainder.split("/")
        if any(part in {".", ".."} or not is_portable_leaf(part) for part in parts):
            return None
    return urlunsplit((parsed.scheme, parsed.netloc, path, "", ""))


def relative_html_member(url: str, *, prefix_path: str, entrypoint: str) -> str | None:
    """Map a confined URL onto a tree-relative portable path, or None for the landing itself."""

    path = urlsplit(url).path
    prefix = prefix_path.rstrip("/") or "/"
    if path == prefix or path == f"{prefix}/":
        return None
    if not path.startswith(f"{prefix}/"):
        return None
    relative = path[len(prefix) + 1 :]
    if not relative or relative == entrypoint:
        return None
    return relative


def _read_head(root: PinnedPublicationRoot, leaf: str, *, limit: int = 8192) -> str:
    require_current(root, label="HTML tree", error=AcquisitionConflictError)
    try:
        with root.open_leaf(leaf, "rb") as handle:
            raw = handle.read(limit)
    except OSError as exc:
        raise AcquisitionError(f"HTML entrypoint could not be read: '{root.absolute(leaf)}'") from exc
    try:
        return raw.decode("utf-8", errors="strict")
    except UnicodeDecodeError as exc:
        raise ArtifactUnavailableError("HTML payload is not valid UTF-8") from exc


def fingerprint_html_tree(
    root: PinnedPublicationRoot,
    *,
    entrypoint: str,
) -> HtmlTreeIdentity:
    """Fingerprint one retained HTML tree without following links or reparses."""

    entrypoint = validate_deposit_slug(entrypoint)
    records: list[tuple[str, int, str]] = []
    portable_paths: set[str] = set()

    def scan(directory: PinnedPublicationRoot, prefix: str) -> None:
        directory.assert_current()
        directory_before = directory.stat_root()
        try:
            entries = directory.list_names()
        except OSError as exc:
            raise AcquisitionConflictError(
                f"HTML tree cannot be enumerated: '{directory.path}'"
            ) from exc
        for name in entries:
            relative = f"{prefix}/{name}" if prefix else name
            if any(not is_portable_leaf(part) for part in relative.split("/")):
                raise AcquisitionError(f"HTML tree contains a non-portable path: {relative!r}")
            portable_key = relative.casefold()
            if portable_key in portable_paths:
                raise AcquisitionError(
                    f"HTML tree contains duplicate or case-colliding paths: {relative!r}"
                )
            portable_paths.add(portable_key)
            try:
                info = directory.stat_leaf(name)
            except OSError as exc:
                raise AcquisitionConflictError(
                    f"HTML tree entry cannot be measured: '{directory.absolute(name)}'"
                ) from exc
            if is_link_or_reparse(info):
                raise AcquisitionError(
                    "HTML tree contains a symbolic link or reparse point: "
                    f"'{directory.absolute(name)}'"
                )
            if stat.S_ISDIR(info.st_mode):
                with directory.pin_child(name) as child:
                    scan(child, relative)
                continue
            if not stat.S_ISREG(info.st_mode):
                raise AcquisitionError(
                    f"HTML tree entry is not a regular file: '{directory.absolute(name)}'"
                )
            digest = hashlib.sha256()
            size = 0
            with directory.open_leaf(name, "rb") as handle:
                before = os.fstat(handle.fileno())
                while chunk := handle.read(1024 * 1024):
                    size += len(chunk)
                    digest.update(chunk)
                after = os.fstat(handle.fileno())
            if size != after.st_size or before.st_mtime_ns != after.st_mtime_ns:
                raise AcquisitionConflictError(
                    f"HTML tree file changed while it was measured: '{directory.absolute(name)}'"
                )
            records.append((relative, size, digest.hexdigest()))
        directory_after = directory.stat_root()
        directory.assert_current()
        if (
            directory_before.st_mtime_ns != directory_after.st_mtime_ns
            or getattr(directory_before, "st_ctime_ns", None)
            != getattr(directory_after, "st_ctime_ns", None)
        ):
            raise AcquisitionConflictError(
                f"HTML tree directory changed while it was scanned: '{directory.path}'"
            )

    root.assert_current()
    scan(root, "")
    root.assert_current()
    if not records:
        raise AcquisitionError(f"HTML tree is empty: '{root.path}'")
    members = tuple(relative for relative, _, _ in records)
    if entrypoint not in members and entrypoint.casefold() not in {
        member.casefold() for member in members
    }:
        raise AcquisitionError(f"HTML tree is missing entrypoint {entrypoint!r}")
    records.sort(key=lambda item: item[0].encode("utf-16-be", "surrogatepass"))
    witnessed = [f"{relative}\0{size}\0{digest}\n".encode("utf-8") for relative, size, digest in records]
    return HtmlTreeIdentity(
        entrypoint=entrypoint,
        files=len(records),
        bytes=sum(size for _, size, _ in records),
        sha256=hashlib.sha256(b"".join(witnessed)).hexdigest(),
        members=members,
    )


def validate_html_tree(
    root: PinnedPublicationRoot,
    *,
    entrypoint: str,
    minimum_bytes: int,
    maximum_bytes: int,
    expected_bytes: int | None = None,
    provider: str | None = None,
) -> HtmlTreeIdentity:
    """Validate one HTML tree's entrypoint marker and measured identity."""

    identity = fingerprint_html_tree(root, entrypoint=entrypoint)
    if identity.bytes < minimum_bytes:
        raise AcquisitionError(f"HTML tree is smaller than {minimum_bytes} bytes")
    if identity.bytes > maximum_bytes:
        raise AcquisitionError(f"HTML tree exceeds the configured {maximum_bytes}-byte limit")
    if expected_bytes is not None and identity.bytes != expected_bytes:
        raise AcquisitionError(
            f"HTML tree has {identity.bytes} bytes; expected {expected_bytes}"
        )
    head = _read_head(root, entrypoint)
    if provider is None:
        if not is_html_document(head):
            raise AcquisitionError("HTML entrypoint lacks an HTML document marker")
    elif not html_probe_accepts(head, provider=provider):
        raise AcquisitionError("HTML entrypoint is not an acceptable paper document")
    return identity


async def _download_member(
    http: HttpClient,
    url: str,
    root: PinnedPublicationRoot,
    relative: str,
    *,
    allowed_hosts: tuple[str, ...],
    rate_key: str,
    policy: RequestPolicy,
    hash_algorithms: tuple[str, ...] = (),
):
    parts = relative.split("/")
    if len(parts) == 1:
        return await http.download_to(
            url,
            root.absolute(parts[0]),
            publication_root=root,
            allowed_hosts=allowed_hosts,
            headers=browser_headers(),
            rate_key=rate_key,
            policy=policy,
            hash_algorithms=hash_algorithms,
        )
    parent = "/".join(parts[:-1])
    root.mkdir_relative(parent, parents=True, exist_ok=True)
    with root.pin_descendant(parent) as nested:
        return await http.download_to(
            url,
            nested.absolute(parts[-1]),
            publication_root=nested,
            allowed_hosts=allowed_hosts,
            headers=browser_headers(),
            rate_key=rate_key,
            policy=policy,
            hash_algorithms=hash_algorithms,
        )


async def retrieve_html_tree(
    http: HttpClient,
    *,
    landing_url: str,
    allowed_hosts: tuple[str, ...],
    tree_root: PinnedPublicationRoot,
    entrypoint: str,
    prefix_path: str,
    provider: str,
    rate_key: str,
    policy: RequestPolicy,
    maximum_tree_bytes: int,
    minimum_entrypoint_bytes: int,
    expected_entrypoint_bytes: int | None = None,
    checksum: ChecksumExpectation | None = None,
) -> HtmlTreeIdentity:
    """Download one landing document and its same-prefix requisites into a private tree."""

    entrypoint = validate_deposit_slug(entrypoint)
    algorithms = (checksum.algorithm,) if checksum is not None else ()
    try:
        landing = await http.download_to(
            landing_url,
            tree_root.absolute(entrypoint),
            publication_root=tree_root,
            allowed_hosts=allowed_hosts,
            headers=browser_headers(accept="text/html,application/xhtml+xml;q=0.9,*/*;q=0.8"),
            rate_key=rate_key,
            policy=policy,
            hash_algorithms=algorithms,
        )
    except ProviderHttpError as exc:
        if exc.status_code == 404:
            raise ArtifactUnavailableError(
                f"HTML landing is absent at {landing_url}"
            ) from exc
        raise
    if landing.bytes < minimum_entrypoint_bytes:
        raise ArtifactUnavailableError(
            f"HTML landing is smaller than {minimum_entrypoint_bytes} bytes"
        )
    if expected_entrypoint_bytes is not None and landing.bytes != expected_entrypoint_bytes:
        raise AcquisitionError(
            f"HTML landing has {landing.bytes} bytes; expected {expected_entrypoint_bytes}"
        )
    if checksum is not None:
        observed = dict(landing.digests).get(checksum.algorithm)
        if observed != checksum.digest:
            raise AcquisitionError("downloaded HTML does not match its provider checksum")
    head = _read_head(tree_root, entrypoint)
    if not html_probe_accepts(head, provider=provider):
        raise ArtifactUnavailableError("HTML landing is not an acceptable paper document")

    try:
        with tree_root.open_leaf(entrypoint, "rb") as handle:
            document = handle.read().decode("utf-8", errors="strict")
    except UnicodeDecodeError as exc:
        raise ArtifactUnavailableError("HTML payload is not valid UTF-8") from exc

    base = html_join_base(landing.url)
    total = landing.bytes
    seen: set[str] = {urldefrag(landing.url)[0].casefold()}
    for raw in collect_html_requisites(document):
        confined = confine_html_requisite(
            raw,
            base=base,
            prefix_path=prefix_path,
            allowed_hosts=allowed_hosts,
        )
        if confined is None:
            continue
        key = confined.casefold()
        if key in seen:
            continue
        relative = relative_html_member(
            confined,
            prefix_path=prefix_path,
            entrypoint=entrypoint,
        )
        if relative is None:
            continue
        seen.add(key)
        remaining = maximum_tree_bytes - total
        if remaining < 1:
            raise AcquisitionError(
                f"HTML tree exceeds the configured {maximum_tree_bytes}-byte limit"
            )
        member_policy = replace(policy, max_decoded_body_bytes=remaining)
        download = await _download_member(
            http,
            confined,
            tree_root,
            relative,
            allowed_hosts=allowed_hosts,
            rate_key=rate_key,
            policy=member_policy,
        )
        total += download.bytes
        if total > maximum_tree_bytes:
            raise AcquisitionError(
                f"HTML tree exceeds the configured {maximum_tree_bytes}-byte limit"
            )

    identity = fingerprint_html_tree(tree_root, entrypoint=entrypoint)
    if identity.bytes > maximum_tree_bytes:
        raise AcquisitionError(
            f"HTML tree exceeds the configured {maximum_tree_bytes}-byte limit"
        )
    return HtmlTreeIdentity(
        entrypoint=identity.entrypoint,
        files=identity.files,
        bytes=identity.bytes,
        sha256=identity.sha256,
        members=identity.members,
        fetched_at=landing.fetched_at,
    )
