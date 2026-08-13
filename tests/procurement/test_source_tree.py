"""Retained source-tree fingerprint contracts."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from jsonl_engine.deposit import _fingerprint_tree as deposit_fingerprint_tree
from procurement.source.tree import fingerprint_source_tree


class SourceTreeTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)

    def test_tree_fingerprint_is_sorted_and_deterministic(self) -> None:
        tree = self.root / "fingerprint"
        tree.mkdir()
        (tree / "z.tex").write_bytes(b"z")
        (tree / "A.txt").write_bytes(b"a")
        sub = tree / "sub"
        sub.mkdir()
        (sub / "b.tex").write_bytes(b"b")

        first = fingerprint_source_tree(tree)
        second = fingerprint_source_tree(tree)
        self.assertEqual(first, second)
        self.assertEqual(("A.txt", "sub/b.tex", "z.tex"), tuple(item.path for item in first.files))
        deposit_hash, deposit_count, deposit_tex = deposit_fingerprint_tree(str(tree))
        self.assertEqual(
            (deposit_hash, deposit_count, deposit_tex),
            (first.sha256, first.count, first.tex_count),
        )


if __name__ == "__main__":
    unittest.main()
