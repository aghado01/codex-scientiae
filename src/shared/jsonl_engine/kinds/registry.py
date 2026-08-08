"""The registry category: a store whose rows register a population under a key.

A registry is not merely a store that happens to carry a header. It has fixed semantics, and they
are what make the category worth privileging:

    keyed      each row registers one member, addressed by pointers the schema declares
    unique     one row per key; a duplicate is an error, never last-wins
    ordered    rows emitted in canonical order, not in whatever order they arrived
    derived    a materialized view, rebuilt wholesale, never reconciled
    headered   the header declares what population this registers

Ordered plus derived is the payoff: a registry is byte-reproducible from its population. The same
members in any discovery order produce the same bytes and therefore the same SHA-256, which turns
the .sig into a fingerprint of the population rather than only a corruption check.

Identity and order are separate declarations. Identity is intrinsic to a record -- what makes it
that member rather than another -- so the schema declares it via x-identity. Order is how one
registry presents its population, so the kind declares it via ORDER, and two registries over one
schema may reasonably differ. ORDER defaults to identity, which is the common case; identity is
always appended as the final tiebreak so the ordering is total even when ORDER terms are not
unique, because a partial order would leave the bytes non-reproducible.

Fact gathering is not here. Enumerating a population -- walking a catalog root for child manifests,
listing schema files -- is run-layout knowledge, and this package disclaims it. rebuild() takes an
iterable of records and never learns where they came from.
"""

from typing import Any, Dict, Iterable, List, Optional, Sequence, Tuple

from ..engine import Discipline
from ..ordering import KeyComparison, SortField, sort_tuple
from ..pointer import MISSING, resolve
from .base import BaseStore


class DuplicateEntry(ValueError):
    """Two members of a population resolved to one key."""


class Registry(BaseStore):
    """A keyed, unique, canonically ordered, wholly rebuilt store."""

    # A registry is rebuilt, never extended: reconciling a materialized view against a population
    # is strictly harder than recomputing it, and the recomputation is what makes the bytes
    # reproducible.
    DISCIPLINE: Discipline = Discipline.CREATE

    # A registry always declares itself. This is the first kind for which the header is not
    # optional -- a bare list of rows does not say what population it claims to cover.
    EMIT_HEADER: bool = True
    HEADER_SCHEMA: str = "registry.header.schema.json"

    # Presentation order. Empty means "order by identity". Identity is appended as a tiebreak
    # either way, so a non-unique ORDER still yields a total order.
    ORDER: Sequence[SortField] = ()

    # How key values compare, for both uniqueness and ordering.
    KEY_COMPARISON: KeyComparison = KeyComparison.ORDINAL

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.RECORD_SCHEMA is None:
            raise TypeError(
                f"Registry kind '{self.KIND}' declares no RECORD_SCHEMA; a registry keys its rows "
                f"on schema-declared identity and cannot exist without one."
            )
        self.identity: Tuple[str, ...] = tuple(self.schemas.identity_of(self.RECORD_SCHEMA))
        if not self.identity:
            raise TypeError(
                f"Schema '{self.RECORD_SCHEMA}' for registry kind '{self.KIND}' declares no "
                f"x-identity, so its rows cannot be keyed, deduplicated, or ordered."
            )
        self._sort_fields: Tuple[SortField, ...] = self._resolve_order()
        self._entry_count = 0

    def _resolve_order(self) -> Tuple[SortField, ...]:
        """Presentation order, with identity appended so the result is always a total order."""
        declared = tuple(self.ORDER)
        seen = {field.pointer for field in declared}
        tiebreak = tuple(
            SortField(pointer) for pointer in self.identity if pointer not in seen
        )
        return declared + tiebreak

    # -- keying ---------------------------------------------------------------------------------

    def key_of(self, record: Dict[str, Any]) -> Tuple[Any, ...]:
        """The identity tuple addressing one record.

        A tuple of the declared values rather than a digest over them: this is what duplicate
        detection reports and what a reader recognises. A fixed-width address derived from these
        values belongs alongside identity rather than instead of it, and waits for a consumer that
        needs to join across artifacts.
        """
        values = []
        missing = []
        for pointer in self.identity:
            value = resolve(record, pointer)
            if value is MISSING:
                missing.append(pointer)
            values.append(value)
        if missing:
            raise KeyError(
                f"Record is missing identity {missing} declared by '{self.RECORD_SCHEMA}' "
                f"for registry kind '{self.KIND}'"
            )
        return tuple(values)

    def _dedupe_key(self, key: Tuple[Any, ...]) -> Tuple[Any, ...]:
        """The key as uniqueness sees it. Under a caseless comparison, folded."""
        return tuple(self.KEY_COMPARISON.fold(value) for value in key)

    def _sort_key(self, record: Dict[str, Any]) -> Tuple[Any, ...]:
        return sort_tuple(
            [resolve(record, field.pointer) for field in self._sort_fields],
            [field.descending for field in self._sort_fields],
            self.KEY_COMPARISON,
        )

    # -- header ---------------------------------------------------------------------------------

    def header_base(self) -> Dict[str, Any]:
        """The base header without created_at.

        A wall clock would make an unchanged population produce different bytes on every rebuild,
        which is exactly the reproducibility that ordering and wholesale rebuild exist to provide.
        When the write happened is the .sig's business; this row describes the population.
        """
        return {"__type__": "header", "kind": self.KIND, "version": self.VERSION}

    def header_fields(self) -> Dict[str, Any]:
        """What addresses this population, how it is ordered, and how many members it holds.

        Restated here so a reader learns the key and the order without resolving the record schema,
        and so a registry rebuilt under changed identity or ordering is detectable rather than
        merely different.

        Deliberately not the population's source: a root path inside an artifact is a locality
        claim that stops being true when the tree moves, and provenance belongs in the .sig
        metadata, which is scoped to the write rather than to the store.
        """
        fields: Dict[str, Any] = {
            "identity": list(self.identity),
            "count": self._entry_count,
        }
        if self.KEY_COMPARISON is not KeyComparison.ORDINAL:
            fields["key_comparison"] = self.KEY_COMPARISON.value
        if tuple(self.ORDER):
            fields["order"] = [
                {"pointer": field.pointer, "descending": field.descending}
                for field in self._sort_fields
            ]
        return fields

    # -- rebuilding -----------------------------------------------------------------------------

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

    def collate(self, entries: Iterable[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Validate, key, refuse duplicates, and return the population in canonical order."""
        by_key: Dict[Tuple[Any, ...], Dict[str, Any]] = {}
        for entry in entries:
            record = self.validate_record(entry)
            key = self._dedupe_key(self.key_of(record))
            if key in by_key:
                raise DuplicateEntry(
                    f"Duplicate entry in registry '{self.KIND}': two members resolve to "
                    f"{dict(zip(self.identity, key))}"
                    + (
                        f" under {self.KEY_COMPARISON.value} comparison"
                        if self.KEY_COMPARISON is not KeyComparison.ORDINAL
                        else ""
                    )
                )
            by_key[key] = record
        return sorted(by_key.values(), key=self._sort_key)

    def rebuild(
        self,
        entries: Iterable[Dict[str, Any]],
        *,
        stem: Optional[str] = None,
        filename: Optional[str] = None,
    ) -> str:
        """Rebuild this registry from `entries`. Returns the path written.

        Buffered by construction: uniqueness and ordering both need the whole population before the
        first row can be emitted. A registry is precisely the case where you need the set in hand,
        which is why it does not stream.
        """
        ordered = self.collate(entries)
        self._entry_count = len(ordered)

        with self.open_writer(stem=stem, filename=filename) as writer:
            for record in ordered:
                writer.append(record)
            writer.commit()
        return writer.output_path
