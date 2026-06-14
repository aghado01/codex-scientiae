#!/usr/bin/env python3
"""Audit bars compendium against misc-pass standards."""

from __future__ import annotations

import re
from pathlib import Path

BARS = Path(__file__).resolve().parents[1]
DOCS = sorted(
    p.stem
    for p in BARS.glob("*.md")
    if p.name != "_CONTENTS.md" and not p.name.startswith("_")
)

SKIP_RE = re.compile(
    r"acknowledg|funding|data availability|reproducibility|"
    r"declaration of competing|article info|conflict of interest",
    re.I,
)


def audit_doc(doc_id: str) -> dict:
    path = BARS / f"{doc_id}.md"
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    issues: list[str] = []

    h1 = None
    has_contents = False
    has_ref_link = False
    bad_hash = []  # lines with single # that aren't title
    headings = {"##": 0, "###": 0, "####": 0}
    boilerplate_sections = []
    inline_refs = 0
    author_lines = 0

    for i, line in enumerate(lines, 1):
        if re.match(r"^## Contents\s*$", line):
            has_contents = True
        if "references/" in line and "References]" in line:
            has_ref_link = True
        m = re.match(r"^(#{1,4})\s+(.+)$", line)
        if m:
            lvl, text = len(m.group(1)), m.group(2).strip()
            if lvl == 1:
                if h1 is None:
                    h1 = text
                else:
                    bad_hash.append((i, text[:60]))
            elif lvl == 2:
                headings["##"] += 1
                if SKIP_RE.search(text):
                    boilerplate_sections.append((i, text))
            elif lvl == 3:
                headings["###"] += 1
            elif lvl == 4:
                headings["####"] += 1
        if re.match(r"^\[1\]", line.strip()):
            inline_refs += 1
        if i <= 15 and not line.startswith("#") and not line.startswith("-") and not line.startswith("!"):
            s = line.strip()
            if s and re.search(r"university|@|department|,\s", s, re.I) and len(s) < 120:
                author_lines += 1

    if not h1:
        issues.append("no H1 title")
    if not has_contents:
        issues.append("missing ## Contents")
    if not has_ref_link:
        issues.append("Contents missing References sidecar link")
    if bad_hash:
        issues.append(f"{len(bad_hash)} extra # headings (not title)")
    if boilerplate_sections:
        issues.append(f"boilerplate sections: {[t for _, t in boilerplate_sections]}")
    if inline_refs:
        issues.append(f"{inline_refs} inline [1] reference lines in body")
    if author_lines:
        issues.append(f"~{author_lines} author/affiliation lines near top")

    ref_path = BARS / "references" / f"{doc_id}.md"
    if not ref_path.exists():
        issues.append("missing references/ sidecar")

    # tail ack prose (not heading)
    tail = "\n".join(lines[-5:])
    if re.search(r"acknowledg", tail, re.I) and "Acknowledgements." in tail:
        issues.append("acknowledgement prose at end of body")

    return {
        "id": doc_id,
        "lines": len(lines),
        "h1": (h1 or "")[:50],
        "h2": headings["##"],
        "h3": headings["###"],
        "issues": issues,
    }


def audit_contents() -> list[str]:
    issues = []
    text = (BARS / "_CONTENTS.md").read_text(encoding="utf-8")
    listed = re.findall(r"\]\((\w+)\.md\)", text)
    for doc in listed:
        if doc == "references":
            continue
        if not (BARS / f"{doc}.md").exists():
            issues.append(f"_CONTENTS links missing file: {doc}.md")
    # depth-3 links
    h3_links = len(re.findall(r"^  - \[", text, re.M))
    if h3_links == 0:
        issues.append("_CONTENTS has no ###-level (indented) subsection links")
    return issues


def main():
    print("=== BARS compendium audit (misc-pass standards) ===\n")
    for doc_id in DOCS:
        r = audit_doc(doc_id)
        status = "OK" if not r["issues"] else "ISSUES"
        print(f"{r['id']}: {status} ({r['lines']} lines, ##={r['h2']}, ###={r['h3']})")
        for iss in r["issues"]:
            print(f"  - {iss}")

    print("\n=== _CONTENTS.md ===")
    for iss in audit_contents():
        print(f"  - {iss}")

    # docs in _CONTENTS but not on disk
    contents = (BARS / "_CONTENTS.md").read_text(encoding="utf-8")
    for m in re.finditer(r"## \[([^\]]+)\]\((\w+)\.md\)", contents):
        title, did = m.group(1), m.group(2)
        if not (BARS / f"{did}.md").exists():
            print(f"  - missing main doc for entry: {did} ({title[:40]}...)")

    # ### count per doc for TOC depth comparison
    print("\n=== Per-doc ### headings (for _CONTENTS depth-3) ===")
    for doc_id in DOCS:
        n = sum(
            1
            for ln in (BARS / f"{doc_id}.md")
            .read_text(encoding="utf-8", errors="replace")
            .splitlines()
            if ln.startswith("### ")
        )
        if n:
            print(f"  {doc_id}: {n} ### headings")


if __name__ == "__main__":
    main()
