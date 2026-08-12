"""Build a catalog-root inventory from explicit or discovered article sentinels.

Discovery admits only physical ``{catalog}/{slug}/article.json`` files. Catalog, child, and
article paths may not traverse links or reparse points. Manifest reads are bounded and verify that
the opened file generation remains at the named path for the complete read.

An existing ``inventory.jsonl`` is refused unless ``force`` is true.
"""

from __future__ import annotations

import os
import stat
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, List, Sequence

from .kinds.inventory import InventoryRegistry
from .publication import PinnedPublicationRoot
from .reader import loads

MAX_ARTICLE_MANIFEST_BYTES = 4 * 1024 * 1024
MAX_ARTICLE_PATHS_BYTES = 4 * 1024 * 1024
MAX_CATALOG_CHILDREN = 100_000
_REPARSE_POINT = getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0x400)


class InventoryCatalogError(ValueError):
    """A catalog inventory operation refused a path, population, read, or overwrite."""


@dataclass(frozen=True)
class InventoryCatalogResult:
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


def _is_link_or_reparse(info: os.stat_result) -> bool:
    return stat.S_ISLNK(info.st_mode) or bool(
        getattr(info, "st_file_attributes", 0) & _REPARSE_POINT
    )


def _same_file_generation(left: os.stat_result, right: os.stat_result) -> bool:
    if left.st_ino or right.st_ino:
        return (
            left.st_dev == right.st_dev
            and left.st_ino == right.st_ino
            and left.st_size == right.st_size
        )
    return (
        left.st_dev == right.st_dev
        and left.st_size == right.st_size
        and getattr(left, "st_ctime_ns", None) == getattr(right, "st_ctime_ns", None)
    )


def _same_snapshot(left: os.stat_result, right: os.stat_result) -> bool:
    fields = ("st_dev", "st_ino", "st_size", "st_mtime_ns", "st_ctime_ns")
    return all(getattr(left, field, None) == getattr(right, field, None) for field in fields)


def _path_components(path: str) -> List[str]:
    absolute = Path(os.path.abspath(path))
    current = absolute.anchor
    components: List[str] = []
    if current:
        components.append(current)
    for part in absolute.parts:
        if part == absolute.anchor:
            continue
        current = os.path.join(current, part) if current else part
        components.append(current)
    return components


def _assert_no_link_traversal(path: str, *, label: str) -> os.stat_result:
    final: os.stat_result | None = None
    for component in _path_components(path):
        try:
            info = os.stat(component, follow_symlinks=False)
        except OSError as exc:
            raise InventoryCatalogError(f"{label} is not accessible: '{path}'") from exc
        if _is_link_or_reparse(info):
            raise InventoryCatalogError(
                f"{label} must not traverse a symbolic link or reparse point: '{component}'"
            )
        final = info
    if final is None:
        raise InventoryCatalogError(f"{label} is not accessible: '{path}'")
    return final


def _catalog_root(catalog_dir: str) -> str:
    if not isinstance(catalog_dir, str) or not catalog_dir.strip():
        raise InventoryCatalogError("catalog directory must be a non-empty string")
    root = os.path.abspath(catalog_dir)
    info = _assert_no_link_traversal(root, label="catalog directory")
    if not stat.S_ISDIR(info.st_mode):
        raise InventoryCatalogError(f"catalog directory is not a directory: '{catalog_dir}'")
    return root


def _read_bounded_regular_file(path: str, *, label: str, max_bytes: int) -> bytes:
    try:
        named_before = os.stat(path, follow_symlinks=False)
    except OSError as exc:
        raise InventoryCatalogError(f"{label} is not a readable file: '{path}'") from exc
    if _is_link_or_reparse(named_before) or not stat.S_ISREG(named_before.st_mode):
        raise InventoryCatalogError(
            f"{label} must be a physical non-reparse file: '{path}'"
        )
    if named_before.st_size > max_bytes:
        raise InventoryCatalogError(
            f"{label} exceeds the {max_bytes}-byte limit: '{path}'"
        )

    flags = os.O_RDONLY | getattr(os, "O_BINARY", 0) | getattr(os, "O_NOFOLLOW", 0)
    try:
        descriptor = os.open(path, flags)
    except OSError as exc:
        raise InventoryCatalogError(f"{label} is not a readable file: '{path}'") from exc

    try:
        with os.fdopen(descriptor, "rb") as handle:
            opened_before = os.fstat(handle.fileno())
            if not stat.S_ISREG(opened_before.st_mode) or not _same_file_generation(
                named_before, opened_before
            ):
                raise InventoryCatalogError(
                    f"{label} changed before it could be read: '{path}'"
                )
            raw = handle.read(max_bytes + 1)
            opened_after = os.fstat(handle.fileno())
    except InventoryCatalogError:
        raise
    except OSError as exc:
        raise InventoryCatalogError(f"{label} could not be read: '{path}'") from exc

    if len(raw) > max_bytes:
        raise InventoryCatalogError(f"{label} exceeds the {max_bytes}-byte limit: '{path}'")
    if len(raw) != opened_after.st_size or not _same_snapshot(
        opened_before, opened_after
    ):
        raise InventoryCatalogError(f"{label} changed while it was being read: '{path}'")
    try:
        named_after = os.stat(path, follow_symlinks=False)
    except OSError as exc:
        raise InventoryCatalogError(f"{label} disappeared after it was read: '{path}'") from exc
    if _is_link_or_reparse(named_after) or not _same_file_generation(
        opened_after, named_after
    ):
        raise InventoryCatalogError(f"{label} path changed while it was being read: '{path}'")
    return raw


def _read_bounded_catalog_file(
    publication_root: PinnedPublicationRoot,
    child: str,
    leaf: str,
    *,
    label: str,
    max_bytes: int,
) -> bytes:
    """Read one direct-child file through the pinned catalog generation."""

    path = os.path.join(publication_root.path, child, leaf)
    try:
        named_before = publication_root.stat_child_file(child, leaf)
    except OSError as exc:
        raise InventoryCatalogError(f"{label} is not a readable file: '{path}'") from exc
    if _is_link_or_reparse(named_before) or not stat.S_ISREG(named_before.st_mode):
        raise InventoryCatalogError(
            f"{label} must be a physical non-reparse file: '{path}'"
        )
    if named_before.st_size > max_bytes:
        raise InventoryCatalogError(
            f"{label} exceeds the {max_bytes}-byte limit: '{path}'"
        )

    try:
        with publication_root.open_child_file(child, leaf, "rb") as handle:
            opened_before = os.fstat(handle.fileno())
            if not stat.S_ISREG(opened_before.st_mode) or not _same_file_generation(
                named_before, opened_before
            ):
                raise InventoryCatalogError(
                    f"{label} changed before it could be read: '{path}'"
                )
            raw = handle.read(max_bytes + 1)
            opened_after = os.fstat(handle.fileno())
    except InventoryCatalogError:
        raise
    except OSError as exc:
        raise InventoryCatalogError(f"{label} could not be read: '{path}'") from exc

    if len(raw) > max_bytes:
        raise InventoryCatalogError(f"{label} exceeds the {max_bytes}-byte limit: '{path}'")
    if len(raw) != opened_after.st_size or not _same_snapshot(
        opened_before, opened_after
    ):
        raise InventoryCatalogError(f"{label} changed while it was being read: '{path}'")
    try:
        named_after = publication_root.stat_child_file(child, leaf)
    except OSError as exc:
        raise InventoryCatalogError(f"{label} disappeared after it was read: '{path}'") from exc
    if _is_link_or_reparse(named_after) or not _same_file_generation(
        opened_after, named_after
    ):
        raise InventoryCatalogError(f"{label} path changed while it was being read: '{path}'")
    return raw


def _direct_child_slug(catalog_root: str, article_path: str) -> tuple[str, str]:
    if not isinstance(article_path, str) or not article_path.strip():
        raise InventoryCatalogError("article path entries must be non-empty strings")
    full = os.path.abspath(article_path)
    if os.path.basename(full) != "article.json":
        raise InventoryCatalogError(
            f"article path must be named article.json, got '{os.path.basename(full)}'"
        )
    parent = os.path.dirname(full)
    try:
        relative_parent = os.path.relpath(parent, catalog_root)
    except ValueError as exc:
        raise InventoryCatalogError(
            f"article path escapes the catalog directory: '{article_path}'"
        ) from exc
    relative_parent = relative_parent.replace("\\", "/")
    if (
        relative_parent in (".", "", "..")
        or relative_parent.startswith("../")
        or "/" in relative_parent
    ):
        raise InventoryCatalogError(
            "article.json must live in a direct child of the catalog directory: "
            f"'{article_path}'"
        )
    return full, relative_parent


def _load_article_at_catalog_path(
    catalog_root: str,
    article_path: str,
    *,
    publication_root: PinnedPublicationRoot,
) -> Dict[str, Any]:
    full, relative_parent = _direct_child_slug(catalog_root, article_path)
    parent = os.path.dirname(full)
    try:
        parent_before = publication_root.stat_child(relative_parent)
    except OSError as exc:
        raise InventoryCatalogError(f"article parent is not accessible: '{parent}'") from exc
    if _is_link_or_reparse(parent_before):
        raise InventoryCatalogError(
            f"article parent must not be a symbolic link or reparse point: '{parent}'"
        )
    if not stat.S_ISDIR(parent_before.st_mode):
        raise InventoryCatalogError(f"article parent is not a directory: '{parent}'")
    raw = _read_bounded_catalog_file(
        publication_root,
        relative_parent,
        "article.json",
        label="article.json",
        max_bytes=MAX_ARTICLE_MANIFEST_BYTES,
    )
    try:
        parent_after = publication_root.stat_child(relative_parent)
    except OSError as exc:
        raise InventoryCatalogError(f"article parent disappeared while reading: '{parent}'") from exc
    if _is_link_or_reparse(parent_after) or not _same_snapshot(
        parent_before, parent_after
    ):
        raise InventoryCatalogError(f"article parent changed while reading: '{parent}'")
    try:
        record = loads(raw, path=full)
    except Exception as exc:
        raise InventoryCatalogError(f"article.json is invalid JSON: '{article_path}': {exc}") from exc
    if not isinstance(record, dict):
        raise InventoryCatalogError(f"article.json must be one JSON object: '{article_path}'")
    slug = record.get("slug")
    if not isinstance(slug, str) or slug != relative_parent:
        raise InventoryCatalogError(
            f"article slug {slug!r} does not match its direct parent '{relative_parent}': "
            f"'{article_path}'"
        )
    return record


def _reject_portable_collisions(paths: Sequence[tuple[str, str]]) -> None:
    by_folded_slug: Dict[str, tuple[str, str]] = {}
    for path, slug in paths:
        folded = slug.casefold()
        prior = by_folded_slug.get(folded)
        if prior is not None:
            raise InventoryCatalogError(
                "article paths contain a portable case collision between "
                f"'{prior[1]}' and '{slug}': '{prior[0]}' and '{path}'"
            )
        by_folded_slug[folded] = (path, slug)


def _discover_article_paths(
    root: str,
    publication_root: PinnedPublicationRoot,
) -> List[str]:
    root_before = publication_root.stat_root()
    discovered: List[tuple[str, str]] = []
    try:
        names = publication_root.list_names()
    except OSError as exc:
        raise InventoryCatalogError(f"catalog directory could not be enumerated: '{root}'") from exc
    if len(names) > MAX_CATALOG_CHILDREN:
        raise InventoryCatalogError(
            f"catalog directory exceeds the {MAX_CATALOG_CHILDREN}-child limit: '{root}'"
        )
    names.sort(key=str.casefold)
    for name in names:
        child_path = os.path.join(root, name)
        try:
            info = publication_root.stat_child(name)
        except OSError as exc:
            raise InventoryCatalogError(
                f"catalog child could not be inspected: '{child_path}'"
            ) from exc
        if _is_link_or_reparse(info):
            raise InventoryCatalogError(
                "catalog child must not be a symbolic link or reparse point: "
                f"'{child_path}'"
            )
        if not stat.S_ISDIR(info.st_mode):
            continue
        article_path = os.path.join(child_path, "article.json")
        try:
            article_info = publication_root.stat_child_file(name, "article.json")
        except FileNotFoundError:
            continue
        except OSError as exc:
            raise InventoryCatalogError(
                f"catalog child article.json could not be inspected: '{article_path}'"
            ) from exc
        if _is_link_or_reparse(article_info) or not stat.S_ISREG(article_info.st_mode):
            raise InventoryCatalogError(
                f"catalog child article.json is not a physical non-reparse file: '{article_path}'"
            )
        discovered.append((os.path.abspath(article_path), name))

    root_after = publication_root.stat_root()
    if not _same_snapshot(root_before, root_after):
        raise InventoryCatalogError(f"catalog directory changed while it was enumerated: '{root}'")
    _reject_portable_collisions(discovered)
    return [path for path, _ in sorted(discovered, key=lambda item: item[1].casefold())]


def _catalog_pin(
    catalog_dir: str,
    retained: PinnedPublicationRoot | None,
) -> tuple[str, PinnedPublicationRoot, bool]:
    """Return one active catalog pin and whether this function opened it."""

    if retained is not None:
        requested = os.path.abspath(catalog_dir)
        if os.path.normcase(requested) != os.path.normcase(retained.path):
            raise InventoryCatalogError(
                "retained publication root does not own the requested catalog: "
                f"'{requested}'"
            )
        try:
            retained.assert_current()
        except (OSError, RuntimeError) as exc:
            raise InventoryCatalogError(
                f"configured catalog path no longer names its retained generation: "
                f"'{retained.path}'"
            ) from exc
        return retained.path, retained, False

    root = _catalog_root(catalog_dir)
    opened = PinnedPublicationRoot(root)
    try:
        opened.__enter__()
    except OSError as exc:
        raise InventoryCatalogError(f"catalog directory could not be pinned: '{root}'") from exc
    return root, opened, True


def discover_article_paths(
    catalog_dir: str,
    *,
    publication_root: PinnedPublicationRoot | None = None,
) -> List[str]:
    """Return safe direct-child article sentinels through an optional retained catalog pin."""

    root, active_root, owned = _catalog_pin(catalog_dir, publication_root)
    try:
        paths = _discover_article_paths(root, active_root)
        if not active_root.path_is_current():
            raise InventoryCatalogError(
                f"catalog directory changed while it was enumerated: '{root}'"
            )
        return paths
    finally:
        if owned:
            active_root.__exit__(None, None, None)


def _inventory_occupancy(
    inventory_path: str,
    *,
    force: bool,
    publication_root: PinnedPublicationRoot,
) -> None:
    if not publication_root.lexists(inventory_path):
        return
    try:
        info = publication_root.stat_path(inventory_path)
    except OSError as exc:
        raise InventoryCatalogError(
            f"inventory path could not be inspected: '{inventory_path}'"
        ) from exc
    if _is_link_or_reparse(info) or not stat.S_ISREG(info.st_mode):
        raise InventoryCatalogError(
            f"inventory path is not a physical non-reparse file: '{inventory_path}'"
        )
    if not force:
        raise InventoryCatalogError(
            f"inventory already exists; pass force=True to overwrite: '{inventory_path}'"
        )


def build_inventory(
    *,
    catalog_dir: str,
    article_paths: Sequence[str] | None = None,
    force: bool = False,
    publication_root: PinnedPublicationRoot | None = None,
) -> InventoryCatalogResult:
    """Validate articles and publish ``inventory.jsonl`` under ``catalog_dir``.

    ``article_paths=None`` discovers safe direct-child sentinels. An explicitly supplied empty
    sequence publishes an empty inventory.
    """
    root, active_root, owned = _catalog_pin(catalog_dir, publication_root)
    try:
        registry = InventoryRegistry(target_dir=root, publication_root=active_root)
        inventory_path = registry.get_output_path()
        _inventory_occupancy(
            inventory_path,
            force=force,
            publication_root=active_root,
        )

        inputs = (
            _discover_article_paths(root, active_root)
            if article_paths is None
            else list(article_paths)
        )
        located = [_direct_child_slug(root, raw_path) for raw_path in inputs]
        _reject_portable_collisions(located)

        articles: List[Dict[str, Any]] = []
        seen_paths: set[str] = set()
        for raw_path in inputs:
            full = os.path.abspath(raw_path)
            portable_key = full.replace("\\", "/").casefold()
            if portable_key in seen_paths:
                raise InventoryCatalogError(f"duplicate article path in build input: '{raw_path}'")
            seen_paths.add(portable_key)
            articles.append(
                _load_article_at_catalog_path(
                    root,
                    full,
                    publication_root=active_root,
                )
            )

        try:
            published = registry.rebuild(articles, overwrite=force)
        except FileExistsError as exc:
            # The registry evaluates this create-only precondition while holding its artifact
            # lease. It closes the interval between the fast occupancy check and publication.
            raise InventoryCatalogError(
                f"inventory already exists; pass force=True to overwrite: '{inventory_path}'"
            ) from exc

        if not active_root.path_is_current():
            raise InventoryCatalogError(
                f"catalog directory changed during inventory publication: '{root}'"
            )
        slugs = sorted((str(article["slug"]) for article in articles), key=str.casefold)
        return InventoryCatalogResult(
            catalog_dir=root,
            inventory_path=published,
            article_count=len(articles),
            slugs=slugs,
        )
    finally:
        if owned:
            active_root.__exit__(None, None, None)


def load_article_paths_json(path: str) -> List[str]:
    """Read a bounded, stable JSON array of article paths."""
    full = os.path.abspath(path)
    raw = _read_bounded_regular_file(
        full,
        label="article-paths JSON",
        max_bytes=MAX_ARTICLE_PATHS_BYTES,
    )
    try:
        payload = loads(raw, path=full, require_object=False)
    except Exception as exc:
        raise InventoryCatalogError(f"article-paths JSON is invalid: '{path}': {exc}") from exc
    if not isinstance(payload, list):
        raise InventoryCatalogError(
            f"article-paths JSON must be an array of strings: '{path}'"
        )
    paths: List[str] = []
    for index, item in enumerate(payload):
        if not isinstance(item, str) or not item.strip():
            raise InventoryCatalogError(
                f"article-paths JSON entry {index} must be a non-empty string: '{path}'"
            )
        paths.append(item)
    return paths
