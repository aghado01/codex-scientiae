"""The registry category: a store whose rows register a population under a key.

A registry is not merely a store that happens to carry a header. It has fixed semantics, and they
are what make the category worth privileging:

    keyed      each row registers one member, addressed by properties the schema declares
    unique     one row per key; a duplicate is an error, never last-wins
    ordered    rows emitted in canonical key order, not in whatever order they arrived
    derived    a materialized view, rebuilt wholesale, never reconciled
    headered   the header declares what population this registers

Ordered plus derived is the payoff: a registry is byte-reproducible from its population. The same
members in any discovery order produce the same bytes and therefore the same SHA-256, which turns
the .sig into a fingerprint of the population rather than only a corruption check. Two runs can be
compared by one hash. A general store cannot offer that, because its order is whatever the caller
appended.

Fact gathering is not here. Enumerating a population -- walking a catalog root for child manifests,
listing schema files -- is run-layout knowledge, and this package disclaims it. rebuild() takes an
iterable of records and never learns where they came from. A plain iterable is the whole seam; a
collector protocol would be ceremony for something that needs none.
"""

from typing import Any, Dict, Iterable, List, Optional, Sequence, Tuple

from ..engine import Discipline
from .base import BaseStore


class DuplicateEntry(ValueError):
    """Two members of a population resolved to one key."""


class Registry(BaseStore):
    """A keyed, unique, canonically ordered, wholly rebuilt store.

    Identity comes from the record schema's x-identity declaration rather than from a class
    attribute here, so shape and addressing live in one document. A kind whose schema declares none
    cannot be a registry and is refused at construction.
    """

    # A registry is rebuilt, never extended: reconciling a materialized view against a population
    # is strictly harder than recomputing it, and the recomputation is what makes the bytes
    # reproducible.
    DISCIPLINE: Discipline = Discipline.CREATE

    # A registry always declares itself. This is the first kind for which the header is not
    # optional -- a bare list of rows does not say what population it claims to cover.
    EMIT_HEADER: bool = True
    HEADER_SCHEMA: str = "registry.header.schema.json"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.RECORD_SCHEMA is None:
            raise TypeError(
                f"Registry kind '{self.KIND}' declares no RECORD_SCHEMA; a registry keys its rows "
                f"on schema-declared identity and cannot exist without one."
            )
        self.identity: Sequence[str] = self.schemas.identity_of(self.RECORD_SCHEMA)
        if not self.identity:
            raise TypeError(
                f"Schema '{self.RECORD_SCHEMA}' for registry kind '{self.KIND}' declares no "
                f"x-identity, so its rows cannot be keyed, deduplicated, or ordered."
            )
        self._entry_count = 0

    def add(self, record: Dict[str, Any]) -> None:
        """Not available on a registry. Use rebuild()."""
        raise TypeError(
            f"Registry '{self.KIND}' is rebuilt from a population, not accumulated. add()/write() "
            f"would append in arrival order without a uniqueness check, which is precisely what "
            f"this category exists to prevent. Use rebuild(entries)."
        )

    def write(self, stem: Optional[str] = None, filename: Optional[str] = None) -> str:
        """Not available on a registry. Use rebuild()."""
        self.add({})  # raises with the explanation

    def key_of(self, record: Dict[str, Any]) -> Tuple[Any, ...]:
        """The identity tuple addressing one record.

        Kept as a tuple of the declared property values rather than hashed into a single token:
        this is what rows are sorted by, and a digest sorts in an order with no meaning to anyone
        reading the store. A fixed-width address derived from these values belongs alongside
        identity, not instead of it, and waits for a consumer that needs to join across artifacts.
        """
        missing = [p for p in self.identity if p not in record]
        if missing:
            raise KeyError(
                f"Record is missing identity {missing} declared by '{self.RECORD_SCHEMA}' "
                f"for registry kind '{self.KIND}'"
            )
        return tuple(record[p] for p in self.identity)

    def header_base(self) -> Dict[str, Any]:
        """The base header without created_at.

        A wall clock in the header would make an unchanged population produce different bytes on
        every rebuild, which is exactly the reproducibility that ordering and wholesale rebuild
        exist to provide. When the write happened is the .sig's business; this row describes the
        population.
        """
        return {"__type__": "header", "kind": self.KIND, "version": self.VERSION}

    def header_fields(self) -> Dict[str, Any]:
        """Beyond the base header: what addresses this population and how many members it holds.

        Deliberately not the population's source. A root path inside an artifact is a locality
        claim that stops being true when the tree moves; provenance belongs in the .sig's metadata
        block, which is scoped to the write rather than to the store.
        """
        return {"identity": list(self.identity), "count": self._entry_count}

    def collate(self, entries: Iterable[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Validate, key, refuse duplicates, and return the population in canonical key order."""
        by_key: Dict[Tuple[Any, ...], Dict[str, Any]] = {}
        for entry in entries:
            record = self.validate_record(entry)
            key = self.key_of(record)
            if key in by_key:
                raise DuplicateEntry(
                    f"Duplicate entry in registry '{self.KIND}': two members resolve to "
                    f"{dict(zip(self.identity, key))}"
                )
            by_key[key] = record
        return [by_key[k] for k in sorted(by_key, key=_sort_key)]

    def rebuild(
        self,
        entries: Iterable[Dict[str, Any]],
        *,
        stem: Optional[str] = None,
        filename: Optional[str] = None,
    ) -> str:
        """Rebuild this registry from `entries`. Returns the path written.

        Buffered by construction: uniqueness and ordering both need the whole population before
        the first row can be emitted. A registry is precisely the case where you need the set in
        hand, which is why it does not stream.
        """
        ordered = self.collate(entries)
        self._entry_count = len(ordered)

        with self.open_writer(stem=stem, filename=filename) as writer:
            for record in ordered:
                writer.append(record)
            writer.commit()
        return writer.output_path


def _sort_key(key: Tuple[Any, ...]) -> Tuple[Tuple[int, str], ...]:
    """Order identity tuples deterministically across mixed value types.

    Python refuses to compare a str with an int, and identity values come from JSON, where a
    property can legitimately hold either across two records. Ordering by (type-rank, string form)
    is total, stable, and independent of the host's locale -- which matters, because this ordering
    is what makes a registry's bytes reproducible.
    """
    ranked = []
    for value in key:
        if value is None:
            ranked.append((0, ""))
        elif isinstance(value, bool):
            ranked.append((1, str(value)))
        elif isinstance(value, (int, float)):
            ranked.append((2, f"{value:>040.10f}"))
        else:
            ranked.append((3, str(value)))
    return tuple(ranked)
