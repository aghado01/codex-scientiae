"""Source-validation evidence projected into article manifests."""

from __future__ import annotations

from dataclasses import asdict
from typing import Any

from procurement.source.extraction import ArchiveExtraction
from procurement.source.latex import LatexSourceInspection


def build_source_findings(
    extraction: ArchiveExtraction,
    inspection: LatexSourceInspection,
) -> dict[str, Any]:
    """Build the closed seven-probe ledger consumed by article publication."""

    checks: list[dict[str, Any]] = [
        {
            "name": "gzip-readable",
            "outcome": "passed",
            "archive_kind": extraction.archive_kind,
        }
    ]
    if extraction.archive_kind == "tar+gzip" and extraction.omitted_case_collisions:
        checks.append(
            {
                "name": "archive-members-confined",
                "outcome": "waived",
                "reason": (
                    "later regular-file members collide by portable case with an "
                    "earlier file and were left in the archive"
                ),
                "entries": extraction.archive_entries,
                "omitted": [
                    {"kept": kept, "omitted": omitted}
                    for kept, omitted in extraction.omitted_case_collisions
                ],
            }
        )
    elif extraction.archive_kind == "tar+gzip":
        checks.append(
            {
                "name": "archive-members-confined",
                "outcome": "passed",
                "entries": extraction.archive_entries,
            }
        )
    else:
        checks.append(
            {
                "name": "archive-members-confined",
                "outcome": "not-applicable",
                "reason": "single-payload gzip archive has no members to confine",
                "archive_kind": extraction.archive_kind,
            }
        )
    checks.extend(
        (
            {
                "name": "no-links-or-reparse-points",
                "outcome": "passed",
                "files": inspection.file_count,
            },
            {
                "name": "tex-valid-utf8",
                "outcome": "passed",
                "tex_files": inspection.tex_file_count,
            },
        )
    )
    if inspection.entrypoint_selection == "explicit":
        checks.append(
            {
                "name": "entrypoint-unambiguous",
                "outcome": "not-applicable",
                "reason": "entrypoint named explicitly; the ambiguity scan did not run",
                "selection": inspection.entrypoint_selection,
                "entrypoint": inspection.entrypoint,
            }
        )
    else:
        checks.append(
            {
                "name": "entrypoint-unambiguous",
                "outcome": "passed",
                "selection": inspection.entrypoint_selection,
                "entrypoint": inspection.entrypoint,
            }
        )
    if inspection.duplicate_copies:
        checks[-1]["duplicate_sources"] = {
            "basis": "relative-path-size-sha256",
            "compile_root": ".",
            "paths_preserved": True,
            "copies": [
                {
                    "directory": copy.directory,
                    "canonical_directory": copy.canonical_directory,
                    "entrypoint": copy.entrypoint,
                    "canonical_entrypoint": copy.canonical_entrypoint,
                    "files": [asdict(item) for item in copy.files],
                }
                for copy in inspection.duplicate_copies
            ],
        }
    if inspection.unresolved_inputs:
        checks.append(
            {
                "name": "literal-inputs-resolved",
                "outcome": "waived",
                "reason": "literal input targets are missing from the source tree",
                "unresolved": [
                    {
                        "command": item.command,
                        "literal": item.literal,
                        "referenced_by": item.referenced_by,
                    }
                    for item in inspection.unresolved_inputs
                ],
            }
        )
    else:
        checks.append(
            {
                "name": "literal-inputs-resolved",
                "outcome": "passed",
                "unresolved": [],
            }
        )
    checks.append(
        {
            "name": "document-environment-present",
            "outcome": "passed",
            "basis": "resolved-input-text",
        }
    )
    embedded = inspection.embedded_metadata
    return {
        "checks": checks,
        "declarations": {
            "title_tex": embedded.title_tex,
            "authors_tex": list(embedded.authors_tex),
            "doi": embedded.doi,
        },
        "package_control_files": [
            {
                "path": item.path,
                "bytes": item.bytes,
                "sha256": item.sha256,
            }
            for item in inspection.package_control_files
        ],
    }


__all__ = ["build_source_findings"]
