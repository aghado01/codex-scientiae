"""Shared record factories for JSONL engine tests."""

from __future__ import annotations


def article(slug: str = "1105.4224v1") -> dict:
    """Return a minimal object satisfying ``codex-scientiae/article/0.1``."""
    return {
        "schema": "codex-scientiae/article/0.1",
        "state": "source-ready",
        "slug": slug,
        "initialized_utc": "2026-08-07T00:00:00Z",
        "title": "Quantum Chaos",
        "authors": ["Author"],
        "abstract": "Abstract...",
        "identifiers": {"arxiv": "1105.4224", "arxiv_versioned": slug, "doi": None},
        "categories": ["cs.CL"],
        "primary_category": "cs.CL",
        "published": None,
        "updated": None,
        "evidence": {
            "provider_metadata": [],
            "latex_source": {
                "entrypoint": "main.tex",
                "selection": "single-candidate",
                "declarations": {"title_tex": None, "authors_tex": [], "doi": None},
            },
            "package_control_files": [],
        },
        "source_forms": [
            {
                "role": "latex-source-archive",
                "path": f"{slug}.tar.gz",
                "format": "application/gzip",
                "bytes": 1,
                "sha256": "0" * 64,
                "archive_kind": "tar+gzip",
            },
            {
                "role": "latex-source-tree",
                "path": f"{slug}-tex",
                "format": "application/x-latex-source-tree",
                "derived_from": f"{slug}.tar.gz",
                "entrypoint": "main.tex",
                "entrypoint_selection": "single-candidate",
                "files": 1,
                "tex_files": 1,
                "sha256": "1" * 64,
            },
        ],
        "validation": {
            "status": "valid",
            "validated_utc": "2026-08-07T00:00:00Z",
            "publication": "published-new-tree",
            "checks": [
                {"name": "gzip-readable", "outcome": "passed", "archive_kind": "tar+gzip"},
                {
                    "name": "entrypoint-unambiguous",
                    "outcome": "not-applicable",
                    "reason": "entrypoint named explicitly; the ambiguity scan did not run",
                },
            ],
        },
    }
