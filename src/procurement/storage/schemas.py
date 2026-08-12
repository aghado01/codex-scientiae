"""Procurement schema catalog layered over the repository infrastructure schemas."""

from __future__ import annotations

import os
from collections.abc import Iterable
from functools import lru_cache
from importlib.resources import files
from pathlib import Path

from jsonl_engine.schemas import SchemaCatalog


class ProcurementSchemaCatalog(SchemaCatalog):
    """Catalog containing engine-owned infrastructure and procurement-owned schemas."""

    def __init__(self, additional_search_paths: Iterable[str | Path] = ()) -> None:
        roots = (
            files("jsonl_engine").joinpath("schemas"),
            files("procurement").joinpath("schemas"),
            *additional_search_paths,
        )
        search_paths: list[str] = []
        seen: set[str] = set()
        for root in roots:
            path = os.path.abspath(os.fspath(root))
            key = os.path.normcase(path)
            if key not in seen:
                seen.add(key)
                search_paths.append(path)
        super().__init__(search_paths=search_paths)


@lru_cache(maxsize=1)
def get_procurement_schema_catalog() -> ProcurementSchemaCatalog:
    """Return the process-wide procurement schema catalog."""

    return ProcurementSchemaCatalog()


__all__ = ["ProcurementSchemaCatalog", "get_procurement_schema_catalog"]
