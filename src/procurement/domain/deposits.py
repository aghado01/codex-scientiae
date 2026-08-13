"""Portable source-deposit identity validation."""

from __future__ import annotations

from procurement.identifiers import (
    artifact_slug,
    is_doi,
    normalize_doi,
    split_arxiv_id,
    split_zenodo_id,
)

_INVALID_PORTABLE_LEAF = frozenset('<>:"/\\|?*')
_WINDOWS_RESERVED_LEAVES = frozenset(
    ("CON", "PRN", "AUX", "NUL")
    + tuple(f"COM{number}" for number in range(1, 10))
    + tuple(f"LPT{number}" for number in range(1, 10))
)
PORTABLE_LEAF_PATTERN = (
    r"^(?!(?:[Cc][Oo][Nn]|[Pp][Rr][Nn]|[Aa][Uu][Xx]|[Nn][Uu][Ll]|"
    r"[Cc][Oo][Mm][1-9]|[Ll][Pp][Tt][1-9])(?:\.|$))(?!\.{1,2}$)"
    r"(?!.*[ .]$)[^<>:\"/\\|?*\u0000-\u001F]+$"
)
PORTABLE_LEAF_MAX_BYTES = 255
PORTABLE_LEAF_MAX_UTF16_UNITS = 255


def is_portable_leaf(
    value: object,
    *,
    max_utf8_bytes: int = PORTABLE_LEAF_MAX_BYTES,
    max_utf16_units: int = PORTABLE_LEAF_MAX_UTF16_UNITS,
) -> bool:
    """Return whether a value is one bounded cross-platform filesystem leaf."""

    if not isinstance(value, str):
        return False
    if not value or value in (".", "..") or value[-1] in (" ", "."):
        return False
    if any(
        ord(char) < 32
        or 0xD800 <= ord(char) <= 0xDFFF
        or char in _INVALID_PORTABLE_LEAF
        for char in value
    ):
        return False
    if value.split(".", 1)[0].upper() in _WINDOWS_RESERVED_LEAVES:
        return False
    try:
        utf8_length = len(value.encode("utf-8", "strict"))
        utf16_units = len(value.encode("utf-16-le", "strict")) // 2
    except UnicodeError:
        return False
    return utf8_length <= max_utf8_bytes and utf16_units <= max_utf16_units


def validate_deposit_slug(value: object) -> str:
    """Return one portable deposit-directory leaf."""

    if not isinstance(value, str):
        raise ValueError("deposit_slug must be a string")
    if value.split(".", 1)[0].upper() in _WINDOWS_RESERVED_LEAVES:
        raise ValueError("deposit_slug uses a reserved Windows directory name")
    if not is_portable_leaf(value):
        raise ValueError("deposit_slug must be one non-empty portable directory leaf")
    return value


def validate_artifact_deposit_reference(
    provider: str,
    deposit_slug: str,
    identifier: str,
) -> str:
    """Validate and canonicalize an artifact identity."""

    deposit_slug = validate_deposit_slug(deposit_slug)
    key = provider.casefold()
    if key == "arxiv":
        parsed = split_arxiv_id(identifier)
        if parsed.version is None:
            raise ValueError("an arXiv source deposit requires a versioned identifier")
        expected_slug = artifact_slug("arxiv", parsed.versioned)
        if deposit_slug != expected_slug:
            raise ValueError(
                f"arXiv deposit slug {deposit_slug!r} must match artifact leaf {expected_slug!r}"
            )
        return parsed.versioned
    if key == "zenodo":
        parsed = split_zenodo_id(identifier)
        if deposit_slug != parsed.slug:
            raise ValueError(
                f"Zenodo deposit slug {deposit_slug!r} must match artifact {parsed.slug!r}"
            )
        return parsed.record_id
    if key == "scihub":
        if not is_doi(identifier):
            raise ValueError("Sci-Hub artifact metadata fallback requires a complete DOI")
        return normalize_doi(identifier) or ""
    if not isinstance(identifier, str) or not identifier.strip():
        raise ValueError("artifact identifier must not be empty")
    return identifier.strip()


__all__ = [
    "PORTABLE_LEAF_MAX_BYTES",
    "PORTABLE_LEAF_MAX_UTF16_UNITS",
    "PORTABLE_LEAF_PATTERN",
    "is_portable_leaf",
    "validate_artifact_deposit_reference",
    "validate_deposit_slug",
]
