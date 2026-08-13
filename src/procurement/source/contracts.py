"""Shared source-processing limits and exception contracts."""

from __future__ import annotations

from dataclasses import dataclass

from procurement.errors import SourceMaterializationError


class SourceArchiveError(SourceMaterializationError):
    """A source archive could not be safely expanded."""


class LatexSourceError(SourceMaterializationError):
    """An expanded LaTeX source tree did not satisfy the source contract."""


@dataclass(frozen=True, slots=True)
class ArchiveLimits:
    """Resource boundaries applied during extraction and source inspection."""

    max_archive_bytes: int = 4 * 1024 * 1024 * 1024
    max_gzip_payload_bytes: int = 4 * 1024 * 1024 * 1024
    max_extracted_bytes: int = 4 * 1024 * 1024 * 1024
    max_member_bytes: int = 4 * 1024 * 1024 * 1024
    max_entries: int = 100_000
    max_component_bytes: int = 255
    max_path_bytes: int = 4096
    max_tex_bytes: int = 32 * 1024 * 1024
    max_resolved_bytes: int = 64 * 1024 * 1024
    max_input_depth: int = 32

    def __post_init__(self) -> None:
        positive = (
            "max_archive_bytes",
            "max_gzip_payload_bytes",
            "max_extracted_bytes",
            "max_member_bytes",
            "max_entries",
            "max_component_bytes",
            "max_path_bytes",
            "max_tex_bytes",
            "max_resolved_bytes",
        )
        for name in positive:
            value = getattr(self, name)
            if type(value) is not int or value <= 0:
                raise ValueError(f"{name} must be a positive integer")
        if type(self.max_input_depth) is not int or self.max_input_depth < 0:
            raise ValueError("max_input_depth must be a non-negative integer")
        if self.max_member_bytes > self.max_extracted_bytes:
            raise ValueError("max_member_bytes cannot exceed max_extracted_bytes")


__all__ = ["ArchiveLimits", "LatexSourceError", "SourceArchiveError"]
