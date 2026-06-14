#!/usr/bin/env python3
"""Build compendia/intersections/_CONTENTS.md from doc headings (# ## ###)."""

from __future__ import annotations

import re
from pathlib import Path

INTERSECTIONS = Path(__file__).resolve().parents[1]
DOCS = [
    "GLL2026",
    "GVPB2025",
    "MMO2019",
    "MNO2019",
    "MR2026",
    "RVH2020",
    "SGL2022",
    "TKH2022",
]

SKIP_RE = re.compile(
    r"acknowledg|funding|data availability|reproducibility|"
    r"declaration of competing|article info|conflict of interest",
    re.I,
)


def slugify(text: str) -> str:
    t = text.strip().lower()
    t = re.sub(r"[∗†‡]", "", t)
    t = re.sub(r"[^\w\s-]", "", t)
    t = re.sub(r"\s+", "-", t)
    return t.strip("-")


def parse_doc(path: Path) -> tuple[str, list[tuple[int, str]]]:
    title = path.stem
    headings: list[tuple[int, str]] = []
    has_h1 = False
    for line in path.read_text(encoding="utf-8").splitlines():
        m = re.match(r"^(#{1,3})\s+(.+)$", line)
        if not m:
            continue
        lvl = len(m.group(1))
        text = m.group(2).strip()
        if lvl == 1:
            title = text
            has_h1 = True
            continue
        if text.lower() == "contents" or SKIP_RE.search(text):
            continue
        headings.append((lvl, text))
    if not has_h1 and headings and headings[0][0] == 2:
        title = headings[0][1]
        headings = headings[1:]
    return title, headings


def render_doc(doc_id: str, title: str, headings: list[tuple[int, str]]) -> list[str]:
    lines = [f"## [{title}]({doc_id}.md)", ""]
    for lvl, text in headings:
        indent = "  " * (lvl - 2)
        slug = slugify(text)
        lines.append(f"{indent}- [{text}]({doc_id}.md#{slug})")
    lines.append(f"- [References](references/{doc_id}.md)")
    lines.append("")
    return lines


def main() -> None:
    out = ["# INTERSECTIONS", ""]
    for doc_id in DOCS:
        path = INTERSECTIONS / f"{doc_id}.md"
        title, headings = parse_doc(path)
        out.extend(render_doc(doc_id, title, headings))
    (INTERSECTIONS / "_CONTENTS.md").write_text("\n".join(out), encoding="utf-8")
    print(f"Wrote {INTERSECTIONS / '_CONTENTS.md'} ({len(out)} lines)")


if __name__ == "__main__":
    main()
