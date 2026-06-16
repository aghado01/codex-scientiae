#!/usr/bin/env python3
"""Build compendia/bars/_CONTENTS.md from doc headings (# ## ###)."""

from __future__ import annotations

import re
from pathlib import Path

BARS = Path(__file__).resolve().parents[1]
COMPENDIA = BARS.parent / "COMPENDIA.md"

# Canonical main docs (WLK2008 only — WLS2008 was a filename misnomer for the same paper)
DOCS = [
    "BD2005",
    "BM2021",
    "DMGK2001",
    "GRE1995",
    "HTR2005",
    "HYK2024",
    "MRA2015",
    "TN2020",
    "WLK2008",
]

SKIP_RE = re.compile(
    r"acknowledg|funding|data availability|reproducibility|"
    r"declaration of competing|article info|conflict of interest",
    re.I,
)

JUNK_HEADING_RE = re.compile(r"^output:?$", re.I)

EXTRA_LINKS: dict[str, list[str]] = {
    "MRA2015": ["- [Appendices and Code](references/MRA2015.appendices.md)"],
}


def slugify(text: str) -> str:
    t = text.strip().lower()
    t = re.sub(r"[∗†‡]", "", t)
    t = re.sub(r"[^\w\s$-]", "", t)
    t = re.sub(r"\s+", "-", t)
    return t.strip("-")


def parse_doc(path: Path) -> tuple[str, list[tuple[int, str]]]:
    title = path.stem
    headings: list[tuple[int, str]] = []
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        m = re.match(r"^(#{1,4})\s+(.+)$", line)
        if not m:
            continue
        lvl = len(m.group(1))
        text = m.group(2).strip()
        if lvl == 1:
            title = text
            continue
        if text.lower() == "contents" or SKIP_RE.search(text) or JUNK_HEADING_RE.match(text):
            continue
        if lvl > 3:
            lvl = 3
        headings.append((lvl, text))
    return title, headings


def render_doc(doc_id: str, title: str, headings: list[tuple[int, str]]) -> list[str]:
    lines = [f"## [{title}]({doc_id}.md)", ""]
    for lvl, text in headings:
        indent = "  " * (lvl - 2)
        slug = slugify(text)
        lines.append(f"{indent}- [{text}]({doc_id}.md#{slug})")
    for extra in EXTRA_LINKS.get(doc_id, []):
        lines.append(extra)
    lines.append(f"- [References](references/{doc_id}.md)")
    lines.append("")
    return lines


def update_compendia_bars(entries: list[tuple[str, str]]) -> None:
    """Sync ### BARS paper list in compendia/COMPENDIA.md with canonical H1 titles."""
    text = COMPENDIA.read_text(encoding="utf-8")
    lines = [f"- [{title}](bars/{doc_id}.md)" for doc_id, title in entries]
    block = "### BARS\n\n" + "\n".join(lines) + "\n"
    pattern = re.compile(r"### BARS\n\n.*?(?=\n### )", re.S)
    if not pattern.search(text):
        raise SystemExit("COMPENDIA.md: ### BARS section not found")
    text = pattern.sub(block.rstrip() + "\n", text, count=1)
    COMPENDIA.write_text(text, encoding="utf-8")
    print(f"Updated {COMPENDIA} (BARS section, {len(entries)} papers)")


def main() -> None:
    out = ["# BARS", ""]
    entries: list[tuple[str, str]] = []
    for doc_id in DOCS:
        path = BARS / f"{doc_id}.md"
        title, headings = parse_doc(path)
        entries.append((doc_id, title))
        out.extend(render_doc(doc_id, title, headings))
    (BARS / "_CONTENTS.md").write_text("\n".join(out), encoding="utf-8")
    print(f"Wrote {BARS / '_CONTENTS.md'} ({len(out)} lines)")
    update_compendia_bars(entries)


if __name__ == "__main__":
    main()
