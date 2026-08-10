"""Rebuild a catalog-root inventory.jsonl from explicit article.json paths.

The engine does not walk the filesystem looking for deposits. A caller enumerates direct-child
article sentinels, hands their paths here, and receives a wholesale registry rebuild. Each path
must be ``{catalog}/{slug}/article.json`` with a matching article slug.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from typing import Any, Dict, List, Sequence

from .kinds.inventory import InventoryRegistry
from .reader import read_json


class InventoryRebuildError(ValueError):
    """A catalog rebuild refused an article path or population."""


@dataclass(frozen=True)
class InventoryRebuildResult:
    catalog_dir: str
    inventory_path: str
    article_count: int
    slugs: List[str]

    def as_dict(self) -> Dict[str, Any]:
        # Prefer article_count over count: PowerShell ETS Count shadows a NoteProperty named count.
        return {
            "catalog_dir": self.catalog_dir,
            "inventory_path": self.inventory_path,
            "article_count": self.article_count,
            "slugs": list(self.slugs),
        }


def _catalog_root(catalog_dir: str) -> str:
    root = os.path.realpath(catalog_dir)
    if not os.path.isdir(root):
        raise InventoryRebuildError(f"catalog directory is not a directory: '{catalog_dir}'")
    return root


def _load_article_at_catalog_path(catalog_root: str, article_path: str) -> Dict[str, Any]:
    full = os.path.realpath(article_path)
    if not os.path.isfile(full):
        raise InventoryRebuildError(f"article path is not a file: '{article_path}'")
    if os.path.basename(full) != "article.json":
        raise InventoryRebuildError(
            f"article path must be named article.json, got '{os.path.basename(full)}'"
        )

    parent = os.path.dirname(full)
    try:
        relative_parent = os.path.relpath(parent, catalog_root)
    except ValueError as exc:
        raise InventoryRebuildError(
            f"article path escapes the catalog directory: '{article_path}'"
        ) from exc
    relative_parent = relative_parent.replace("\\", "/")
    if relative_parent in (".", "") or relative_parent.startswith("../") or "/" in relative_parent:
        raise InventoryRebuildError(
            "article.json must live in a direct child of the catalog directory: "
            f"'{article_path}'"
        )

    record = read_json(full)
    if not isinstance(record, dict):
        raise InventoryRebuildError(f"article.json must be one JSON object: '{article_path}'")
    slug = record.get("slug")
    if not isinstance(slug, str) or slug != relative_parent:
        raise InventoryRebuildError(
            f"article slug {slug!r} does not match its direct parent '{relative_parent}': "
            f"'{article_path}'"
        )
    return record


def rebuild_inventory(
    *,
    catalog_dir: str,
    article_paths: Sequence[str],
) -> InventoryRebuildResult:
    """Validate article paths and rebuild ``inventory.jsonl`` under ``catalog_dir``."""
    root = _catalog_root(catalog_dir)
    registry = InventoryRegistry(target_dir=root)
    articles: List[Dict[str, Any]] = []
    seen_paths = set()
    for raw_path in article_paths:
        if not isinstance(raw_path, str) or not raw_path.strip():
            raise InventoryRebuildError("article path entries must be non-empty strings")
        full = os.path.realpath(raw_path)
        if full in seen_paths:
            raise InventoryRebuildError(f"duplicate article path in rebuild input: '{raw_path}'")
        seen_paths.add(full)
        articles.append(_load_article_at_catalog_path(root, full))

    inventory_path = registry.rebuild(articles)
    slugs = [str(article["slug"]) for article in articles]
    slugs.sort()
    return InventoryRebuildResult(
        catalog_dir=root,
        inventory_path=inventory_path,
        article_count=len(articles),
        slugs=slugs,
    )


def load_article_paths_json(path: str) -> List[str]:
    """Read a staged JSON array of article.json paths (may be empty)."""
    payload = read_json(path, require_object=False)
    if not isinstance(payload, list):
        raise InventoryRebuildError(
            f"article-paths JSON must be an array of strings: '{path}'"
        )
    paths: List[str] = []
    for index, item in enumerate(payload):
        if not isinstance(item, str) or not item.strip():
            raise InventoryRebuildError(
                f"article-paths JSON entry {index} must be a non-empty string: '{path}'"
            )
        paths.append(item)
    return paths
