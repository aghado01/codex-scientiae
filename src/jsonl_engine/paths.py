"""Repository root resolution.

find_repository_root walks up from __file__ for AGENTS.md, .git, or Directory.Build.props, and
raises when none is found. The working directory is not consulted. The nearest sentinel wins, so a
git worktree carrying its own AGENTS.md resolves to that worktree.

RepoPaths caches the root for the process. resolve() joins against it; relative_to_root() returns
forward-slash paths relative to it.
"""

import os
from typing import Optional


def find_repository_root(start_path: Optional[str] = None) -> str:
    """
    Dynamically resolves the repository root directory by walking up from start_path
    (defaulting to __file__'s location) until locating sentinel markers (AGENTS.md, .git, Directory.Build.props).
    Fails fast with RuntimeError if no sentinel marker is found.
    """
    if start_path is None:
        start_path = os.path.dirname(os.path.abspath(__file__))
        
    current = os.path.abspath(start_path)
    while current:
        if any(os.path.exists(os.path.join(current, sentinel)) for sentinel in ("AGENTS.md", ".git", "Directory.Build.props")):
            return current
        parent = os.path.dirname(current)
        if parent == current:
            break
        current = parent
        
    raise RuntimeError(
        f"Could not locate repository root sentinels (AGENTS.md, .git, Directory.Build.props) "
        f"walking up from '{start_path}'"
    )


class RepoPaths:
    """
    Repository path helper for resolving schema roots and artifact directories.
    """
    _root: Optional[str] = None

    @classmethod
    def root(cls) -> str:
        if cls._root is None:
            cls._root = find_repository_root()
        return cls._root

    @classmethod
    def resolve(cls, *relative_parts: str) -> str:
        """Resolves relative path parts against the dynamic repository root."""
        return os.path.abspath(os.path.join(cls.root(), *relative_parts))

    @classmethod
    def relative_to_root(cls, full_path: str) -> str:
        """Returns a portable forward-slash relative path from the repository root."""
        rel = os.path.relpath(full_path, cls.root())
        return rel.replace("\\", "/")
