"""JSON Pointer (RFC 6901) resolution over parsed JSON values.

One addressing syntax, used in two places that must agree: the properties a registry keys its rows
on, and the projection a shell caller asks for. A pointer is the right currency for both because it
is declarable in a schema document and typeable at a prompt, and because it addresses nested values
without inventing a second path syntax.

    ""            the whole document
    "/slug"       a top-level property
    "/a/0/b"      through an array index
    "/a~1b"       a property literally named "a/b"   (~1 is '/', ~0 is '~')

Leaf module: stdlib only, no package imports.
"""

from __future__ import annotations

from typing import Any, Iterator, Sequence, Tuple

__all__ = ["PointerError", "parse", "resolve", "exists", "MISSING"]


class PointerError(ValueError):
    """A pointer was malformed, or did not resolve against a document."""


class _Missing:
    """Sentinel distinguishing "absent" from a legitimately stored None."""

    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __repr__(self) -> str:
        return "MISSING"

    def __bool__(self) -> bool:
        return False


MISSING = _Missing()


def parse(pointer: str) -> Tuple[str, ...]:
    """Split a pointer into its reference tokens, unescaped.

    Raises rather than guessing: a pointer that does not start with '/' is a common mistake for a
    property name, and silently treating "slug" as "/slug" would make "a/b" mean something no
    reader expects.
    """
    if not isinstance(pointer, str):
        raise PointerError(f"JSON Pointer must be a string, got {type(pointer).__name__}")
    if pointer == "":
        return ()
    if not pointer.startswith("/"):
        raise PointerError(
            f"JSON Pointer must be empty or start with '/': {pointer!r} "
            f"(did you mean '/{pointer}'?)"
        )
    # Unescape in this order: ~1 before ~0, or "~01" would decode to "/" instead of "~1".
    return tuple(
        token.replace("~1", "/").replace("~0", "~") for token in pointer[1:].split("/")
    )


def _descend(value: Any, token: str, pointer: str) -> Any:
    if isinstance(value, dict):
        return value.get(token, MISSING)
    if isinstance(value, (list, tuple)):
        if token == "-":
            # RFC 6901 addresses the element after the last, which exists only for insertion.
            return MISSING
        if not token.isdigit():
            raise PointerError(
                f"JSON Pointer {pointer!r} indexes an array with a non-numeric token {token!r}"
            )
        index = int(token)
        return value[index] if index < len(value) else MISSING
    return MISSING


def resolve(document: Any, pointer: str, default: Any = MISSING) -> Any:
    """Resolve `pointer` against `document`, returning `default` when it does not exist.

    Absence returns rather than raises, because a pointer over heterogeneous records is routinely
    a question ("does this row have one?") rather than an assertion. Callers that need presence
    enforced compare against MISSING, which is distinct from a stored null.
    """
    value: Any = document
    for token in parse(pointer):
        value = _descend(value, token, pointer)
        if value is MISSING:
            return default
    return value


def exists(document: Any, pointer: str) -> bool:
    """Whether `pointer` resolves, distinguishing a missing value from a stored null."""
    return resolve(document, pointer) is not MISSING


def resolve_all(document: Any, pointers: Sequence[str]) -> Iterator[Any]:
    """Resolve several pointers in order. Convenience for composite keys."""
    for pointer in pointers:
        yield resolve(document, pointer)
