"""Directory-copy evidence from a retained source-tree fingerprint."""

from __future__ import annotations

import posixpath
from collections import defaultdict
from dataclasses import dataclass
from typing import Sequence

from procurement.source.tree import TreeFile


@dataclass(frozen=True, slots=True)
class DuplicateSourceCopy:
    """A directory's files mapped to equal paths below a canonical directory."""

    directory: str
    canonical_directory: str
    entrypoint: str
    canonical_entrypoint: str
    files: tuple[TreeFile, ...]


def inspect_source_copies(
    files: Sequence[TreeFile],
    candidates: Sequence[str],
    *,
    main_tex: str = "",
) -> tuple[tuple[DuplicateSourceCopy, ...], tuple[str, ...]]:
    """Compare same-named entrypoints and their complete directory file sets.

    Nested candidate directories are compared separately, so an ancestor's file
    set excludes those copies. Every remaining relative path, size, and digest
    must agree. Individual equal files and differently named entrypoints are
    never collapsed. Empty directories do not participate in tree identity.
    """

    by_name: dict[str, list[str]] = defaultdict(list)
    for candidate in candidates:
        by_name[posixpath.basename(candidate)].append(candidate)
    copies: list[DuplicateSourceCopy] = []
    conflicts: list[str] = []

    def order(path: str) -> tuple[int, bytes]:
        return path.count("/"), path.encode("utf-16-be", "surrogatepass")

    for peers in by_name.values():
        if len(peers) < 2:
            continue
        roots = {posixpath.dirname(candidate): candidate for candidate in peers}
        projected: dict[str, list[TreeFile]] = {directory: [] for directory in roots}
        for item in files:
            directory = posixpath.dirname(item.path)
            while directory not in roots:
                if not directory:
                    break
                directory = posixpath.dirname(directory)
            if directory in roots:
                relative = item.path[len(directory) + 1 :] if directory else item.path
                projected[directory].append(
                    TreeFile(path=relative, bytes=item.bytes, sha256=item.sha256)
                )
        equivalents: dict[tuple[TreeFile, ...], list[str]] = defaultdict(list)
        for directory, records in projected.items():
            signature = tuple(
                sorted(records, key=lambda item: item.path.encode("utf-16-be", "surrogatepass"))
            )
            equivalents[signature].append(roots[directory])
        if len(equivalents) > 1:
            conflicts.extend(peers)
        for signature, matches in equivalents.items():
            if len(matches) < 2:
                continue
            matches.sort(key=order)
            canonical = main_tex if main_tex in matches else matches[0]
            for candidate in matches:
                if candidate != canonical:
                    copies.append(
                        DuplicateSourceCopy(
                            directory=posixpath.dirname(candidate) or ".",
                            canonical_directory=posixpath.dirname(canonical) or ".",
                            entrypoint=candidate,
                            canonical_entrypoint=canonical,
                            files=signature,
                        )
                    )
    return (
        tuple(sorted(copies, key=lambda item: order(item.entrypoint))),
        tuple(sorted(conflicts, key=order)),
    )
