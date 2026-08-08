"""Deterministic ordering and comparison of JSON values.

A registry's bytes are reproducible only if its rows sort the same way everywhere. That needs an
order that is *total* over the JSON type system -- Python refuses to compare a str with an int, and
a property can legitimately hold either across two records -- and *independent of the host*, which
rules out locale-sensitive collation.

The order across types is the JSON type order: null < false/true < number < string < array/object.
Within a type it is the natural one, with numbers compared numerically rather than lexically so 9
sorts before 10.

Leaf module: stdlib only, no package imports.
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from enum import Enum
from typing import Any, Sequence, Tuple

__all__ = ["KeyComparison", "SortField", "comparable", "sort_tuple"]


class KeyComparison(Enum):
    """How key values are compared for both uniqueness and ordering.

    ORDINAL            exact code-point comparison. The default, and the only one under which two
                       distinct strings are always two distinct keys.

    ORDINAL_IGNORE_CASE  caseless comparison via str.casefold, which is the Unicode operation for
                       caseless matching -- str.lower is not (it leaves e.g. 'ß' unequal to 'SS').
                       For populations keyed by something a case-insensitive filesystem produced,
                       where 'Foo.pdf' and 'foo.pdf' name one member. Under this comparison such a
                       pair is a duplicate and is refused, not silently merged.
    """

    ORDINAL = "ordinal"
    ORDINAL_IGNORE_CASE = "ordinal-ignore-case"

    def fold(self, value: Any) -> Any:
        """Normalize one value for comparison. Non-strings are unaffected."""
        if self is KeyComparison.ORDINAL_IGNORE_CASE and isinstance(value, str):
            return value.casefold()
        return value


@dataclass(frozen=True)
class SortField:
    """One term of a canonical ordering: where to look, and which direction.

    Separate from identity because they answer different questions. Identity is intrinsic to a
    record -- what makes it that member rather than another -- and belongs to the schema. Ordering
    is how one registry chooses to present its population, and two registries over the same schema
    may reasonably differ.
    """

    pointer: str
    descending: bool = False


# Rank of each JSON type, so values of different types never need to be compared directly.
_NULL, _BOOL, _NUMBER, _STRING, _COMPOSITE = range(5)


def comparable(value: Any) -> Tuple[int, float, str]:
    """A sort key for one JSON value: (type rank, numeric slot, text slot).

    The rank separates types, so only one of the remaining slots is ever significant and the two
    are never compared across kinds. Numbers occupy the numeric slot directly -- ints included, so
    large integers compare exactly rather than through a float that would lose precision.
    """
    if value is None:
        return (_NULL, 0, "")
    # bool is a subclass of int, so it has to be answered first.
    if isinstance(value, bool):
        return (_BOOL, int(value), "")
    if isinstance(value, (int, float)):
        return (_NUMBER, value, "")
    if isinstance(value, str):
        return (_STRING, 0, value)
    # Arrays and objects are unusual as key or sort values but not illegal. Serialized compactly
    # with sorted keys so the ordering is at least stable and independent of insertion order.
    return (_COMPOSITE, 0, json.dumps(value, sort_keys=True, separators=(",", ":")))


def sort_tuple(
    values: Sequence[Any],
    descending: Sequence[bool] = (),
    comparison: KeyComparison = KeyComparison.ORDINAL,
) -> Tuple[Any, ...]:
    """Build a sort key from `values`, honouring per-term direction and the comparison mode.

    Descending terms are inverted within the key rather than handled by reversing the sort, because
    a single sort has to mix directions across terms. Inversion is applied to the comparable tuple:
    numeric slots negate, and text slots invert through a wrapper that reverses str comparison.
    """
    key: list = []
    for index, value in enumerate(values):
        rank, number, text = comparable(comparison.fold(value))
        if index < len(descending) and descending[index]:
            key.append((-rank, -number, _Reversed(text)))
        else:
            key.append((rank, number, text))
    return tuple(key)


@dataclass(frozen=True, order=False)
class _Reversed:
    """A string that compares in reverse, so one sort can mix ascending and descending terms."""

    text: str

    def __lt__(self, other: "_Reversed") -> bool:
        return other.text < self.text

    def __le__(self, other: "_Reversed") -> bool:
        return other.text <= self.text

    def __gt__(self, other: "_Reversed") -> bool:
        return other.text > self.text

    def __ge__(self, other: "_Reversed") -> bool:
        return other.text >= self.text
