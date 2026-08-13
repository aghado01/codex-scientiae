"""Source-processing limit contracts."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from procurement.source.contracts import ArchiveLimits
from procurement.source.tree import fingerprint_source_tree


def _limits(**overrides: int) -> ArchiveLimits:
    values = {
        "max_archive_bytes": 1024 * 1024,
        "max_gzip_payload_bytes": 1024 * 1024,
        "max_extracted_bytes": 1024 * 1024,
        "max_member_bytes": 1024 * 1024,
        "max_entries": 100,
        "max_component_bytes": 255,
        "max_path_bytes": 4096,
        "max_tex_bytes": 1024 * 1024,
        "max_resolved_bytes": 1024 * 1024,
        "max_input_depth": 16,
    }
    values.update(overrides)
    return ArchiveLimits(**values)


class SourceContractTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)

    def test_limit_configuration_rejects_non_integer_and_inconsistent_values(self) -> None:
        with self.assertRaisesRegex(ValueError, "positive integer"):
            ArchiveLimits(max_entries=True)
        with self.assertRaisesRegex(ValueError, "non-negative integer"):
            ArchiveLimits(max_input_depth=False)
        with self.assertRaisesRegex(ValueError, "cannot exceed"):
            ArchiveLimits(max_extracted_bytes=1, max_member_bytes=2)

        tree = self.root / "wrong-limits"
        tree.mkdir()
        (tree / "file.txt").write_bytes(b"x")
        with self.assertRaisesRegex(TypeError, "ArchiveLimits"):
            fingerprint_source_tree(tree, limits=False)  # type: ignore[arg-type]


if __name__ == "__main__":
    unittest.main()
