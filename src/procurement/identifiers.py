"""Canonical scholarly identifier operations."""

from __future__ import annotations

import re
from dataclasses import dataclass
from urllib.parse import unquote, urlparse

from procurement.errors import IdentifierError

_DOI_PREFIX = re.compile(r"^(?:(?:https?://)?(?:dx\.)?doi\.org/|doi:)\s*", re.IGNORECASE)
_DOI_IN_TEXT = re.compile(r"10\.\d{4,9}/[^\s<>\"']+", re.IGNORECASE)
_DOI_EXACT = re.compile(r"^10\.\d{4,9}/[^\s<>\"']+$", re.IGNORECASE)
_ARXIV_NEW = re.compile(r"^\d{2}(?:0[1-9]|1[0-2])\.\d{4,5}(?:v[1-9]\d*)?$", re.IGNORECASE)
_ARXIV_OLD = re.compile(
    r"^[a-z][a-z-]*(?:\.[a-z]{2})?/\d{2}(?:0[1-9]|1[0-2])\d{3}(?:v[1-9]\d*)?$",
    re.IGNORECASE,
)
_ARXIV_VERSION = re.compile(r"v([1-9]\d*)$", re.IGNORECASE)
_ZENODO = re.compile(r"^(?:(?:10\.5281/)?zenodo\.)?(\d+)$", re.IGNORECASE)


def normalize_doi(value: object | None) -> str | None:
    """Return the lowercase DOI payload without a resolver prefix."""

    if value is None:
        return None
    text = unquote(str(value)).strip()
    if not text:
        return None
    text = _DOI_PREFIX.sub("", text).strip()
    return text.casefold() or None


def extract_doi(value: object | None) -> str | None:
    """Extract and normalize the first DOI-shaped token in text."""

    if value is None:
        return None
    match = _DOI_IN_TEXT.search(str(value))
    if not match:
        return None
    candidate = match.group(0).rstrip(".,;:)]}")
    return normalize_doi(candidate)


def is_doi(value: object | None) -> bool:
    """Return whether a value is a complete DOI in a supported resolver form."""

    normalized = normalize_doi(value)
    return bool(normalized and _DOI_EXACT.fullmatch(normalized))


def normalize_arxiv_id(value: object | None) -> str | None:
    """Return a bare arXiv identifier, preserving a supplied version."""

    if value is None:
        return None
    text = unquote(str(value)).strip()
    if not text:
        return None
    text = re.sub(r"^arxiv:\s*", "", text, flags=re.IGNORECASE)
    if text.lower().startswith(("http://", "https://")):
        path = urlparse(text).path
        match = re.search(r"/(?:abs|pdf|html|src)/(.*)$", path, flags=re.IGNORECASE)
        if match:
            text = match.group(1)
    text = re.sub(r"\.pdf$", "", text, flags=re.IGNORECASE).strip("/")
    return text if is_arxiv_id(text) else None


def is_arxiv_id(value: object | None) -> bool:
    """Return whether a value is a modern or legacy arXiv identifier."""

    if value is None:
        return False
    text = str(value).strip()
    return bool(_ARXIV_NEW.fullmatch(text) or _ARXIV_OLD.fullmatch(text))


@dataclass(frozen=True, slots=True)
class ArxivIdentifier:
    """Versioned and versionless forms of an arXiv identifier."""

    versionless: str
    versioned: str
    version: int | None


def split_arxiv_id(value: object) -> ArxivIdentifier:
    """Split an arXiv identifier into stable and versioned forms."""

    normalized = normalize_arxiv_id(value)
    if normalized is None:
        raise IdentifierError(f"invalid arXiv identifier: {value!r}")
    match = _ARXIV_VERSION.search(normalized)
    if not match:
        return ArxivIdentifier(normalized, normalized, None)
    return ArxivIdentifier(normalized[: match.start()], normalized, int(match.group(1)))


def arxiv_identity(value: object) -> str:
    """Return the case-insensitive versionless arXiv identity key."""

    return split_arxiv_id(value).versionless.casefold()


@dataclass(frozen=True, slots=True)
class ZenodoIdentifier:
    """Canonical forms of a Zenodo record identifier."""

    record_id: str
    doi: str
    slug: str


def split_zenodo_id(value: object) -> ZenodoIdentifier:
    """Parse a Zenodo record number, shorthand, or DOI."""

    text = unquote(str(value)).strip()
    parsed = urlparse(text)
    if parsed.hostname and parsed.hostname.casefold() in {"zenodo.org", "www.zenodo.org"}:
        match = re.fullmatch(r"/(?:record|records)/(\d+)/?", parsed.path, re.IGNORECASE)
        if match:
            text = match.group(1)
    else:
        text = re.sub(r"^doi:\s*", "", text, flags=re.IGNORECASE)
        text = re.sub(
            r"^https?://(?:dx\.)?doi\.org/",
            "",
            text,
            flags=re.IGNORECASE,
        )
    match = _ZENODO.fullmatch(text)
    if not match:
        raise IdentifierError(f"invalid Zenodo identifier: {value!r}")
    record_number = int(match.group(1))
    if record_number < 1:
        raise IdentifierError(f"invalid Zenodo identifier: {value!r}")
    record_id = str(record_number)
    return ZenodoIdentifier(
        record_id=record_id,
        doi=f"10.5281/zenodo.{record_id}",
        slug=f"zenodo_{record_id}",
    )
