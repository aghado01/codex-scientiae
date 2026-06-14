#!/usr/bin/env python3
"""Repair bars compendium bodies (misc-pass standards). No hub _CONTENTS update."""

from __future__ import annotations

import re
from pathlib import Path

BARS = Path(__file__).resolve().parents[1]
DOCS = sorted(
    p.stem
    for p in BARS.glob("*.md")
    if p.name != "_CONTENTS.md" and not p.name.startswith("_")
)

SKIP_SECTION_RE = re.compile(
    r"acknowledg|funding|data availability|declaration of competing|"
    r"reproducibility|article info|conflict of interest",
    re.I,
)

JUNK_HEADING_RE = re.compile(
    r"^results are written into a series of files$|^output$|^optional output$|^output:$",
    re.I,
)

AUTHOR_LINE_RE = re.compile(
    r"^(?:\*\*)?[A-Z][\w'.-]+(?:\s+[A-Z][\w'.-]+)+(?:\*\*)?"
    r"(?:\s+and\s+(?:\*\*)?[A-Z][\w'.-]+(?:\s+[A-Z][\w'.-]+)*(?:\*\*)?)?\s*$"
)
AFFIL_RE = re.compile(
    r"university|department|institute|@|\.edu|\.ac\.|carnegie mellon|pittsburgh|"
    r"biostatistics branch|national institute|bristol|tsinghua|ann arbor|"
    r"cmu\.edu|stat\.cmu",
    re.I,
)
EMAIL_RE = re.compile(r"^[a-z0-9._+-]+@[a-z0-9.-]+\.[a-z]{2,}", re.I)


def slugify(text: str) -> str:
    t = text.strip().lower()
    t = re.sub(r"[^\w\s$-]", "", t)
    t = re.sub(r"\s+", "-", t)
    return t.strip("-")


def read_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8", errors="replace").splitlines()


def write_lines(path: Path, lines: list[str]) -> None:
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def remove_pre_contents_boilerplate(lines: list[str]) -> list[str]:
    """Drop author/affiliation/email lines between title and ## Contents."""
    out: list[str] = []
    before_contents = True
    for line in lines:
        if re.match(r"^## Contents\s*$", line):
            before_contents = False
            while out and out[-1].strip() == "":
                out.pop()
            out.append(line)
            continue

        if before_contents:
            if re.match(r"^#\s+", line) and not out:
                out.append(line)
                continue
            s = line.strip()
            if not s:
                if out and out[-1].strip() != "":
                    out.append(line)
                continue
            if AUTHOR_LINE_RE.match(s):
                continue
            if AFFIL_RE.search(s) and len(s) < 200:
                continue
            if EMAIL_RE.match(s):
                continue
            if re.match(r"^[a-z]+@[a-z]", s):
                continue
            if re.match(r"^[A-Z][a-z]+ [A-Z][a-z]+$", s):
                continue
            if re.match(r"^[A-Za-z].+ and [A-Za-z]", s) and len(s) < 80:
                continue

        out.append(line)
    return out


def strip_tail_acknowledgements(lines: list[str]) -> list[str]:
    out: list[str] = []
    for line in lines:
        if re.match(r"^Acknowledgements\.\s", line.strip(), re.I):
            continue
        out.append(line)
    while out and out[-1].strip() == "":
        out.pop()
    return out


def demote_wlk_junk_headings(lines: list[str]) -> list[str]:
    out: list[str] = []
    for line in lines:
        m = re.match(r"^###\s+(.+)$", line)
        if m and JUNK_HEADING_RE.match(m.group(1).strip()):
            out.append(f"**{m.group(1).strip()}**")
            continue
        out.append(line)
    return out


def merge_wlk_keywords(lines: list[str]) -> list[str]:
    """Fold ## Keywords into abstract; remove Keywords section."""
    out: list[str] = []
    keywords: str | None = None
    in_keywords = False
    in_abstract = False
    abstract_done = False

    for line in lines:
        if re.match(r"^## Keywords\s*$", line):
            in_keywords = True
            continue
        if in_keywords:
            if line.startswith("## "):
                in_keywords = False
                if keywords:
                    out.append("")
                    out.append(f"**Keywords:** {keywords}")
                    out.append("")
                keywords = None
            else:
                s = line.strip()
                if s:
                    keywords = s if keywords is None else f"{keywords} {s}"
                continue
        if re.match(r"^## Abstract\s*$", line):
            in_abstract = True
            abstract_done = False
            out.append(line)
            continue
        if in_abstract and line.startswith("## ") and not abstract_done:
            in_abstract = False
            abstract_done = True
        out.append(line)

    if keywords:
        # Keywords was last section (shouldn't happen)
        out.append("")
        out.append(f"**Keywords:** {keywords}")
    return out


def collect_headings(lines: list[str]) -> list[tuple[int, str, str]]:
    items: list[tuple[int, str, str]] = []
    for line in lines:
        m = re.match(r"^(#{2,4})\s+(.+)$", line)
        if not m:
            continue
        lvl = len(m.group(1))
        text = m.group(2).strip()
        if text.lower() == "contents":
            continue
        if SKIP_SECTION_RE.search(text) or JUNK_HEADING_RE.search(text):
            continue
        items.append((lvl, text, slugify(text)))
    return items


def rebuild_contents(lines: list[str], doc_id: str) -> list[str]:
    out: list[str] = []
    i = 0
    while i < len(lines):
        if re.match(r"^## Contents\s*$", lines[i]):
            i += 1
            while i < len(lines) and (
                lines[i].strip() == ""
                or re.match(r"^(\s*)- ", lines[i])
            ):
                i += 1
            continue
        out.append(lines[i])
        i += 1

    insert_at = 1
    if len(out) > 1 and out[1].strip() == "":
        insert_at = 2
    if insert_at == 1 and len(out) > 1:
        # blank line between title and Contents
        out = out[:1] + [""] + out[1:]
        insert_at = 2

    headings = collect_headings(out)
    contents = ["## Contents", ""]
    for lvl, text, slug in headings:
        indent = "  " * (lvl - 2)
        contents.append(f"{indent}- [{text}](#{slug})")
    contents.append(f"- [References](references/{doc_id}.md)")
    contents.append("")
    return out[:insert_at] + contents + out[insert_at:]


def split_mra2015_references() -> None:
    ref_path = BARS / "references" / "MRA2015.md"
    text = read_lines(ref_path)
    cut = None
    for i, line in enumerate(text):
        if line.strip() == "# Appendix A":
            cut = i
            break
    if cut is None:
        print("MRA2015: no appendix split needed")
        return

    bib = text[:cut]
    appendix = text[cut:]
    while bib and bib[-1].strip() == "":
        bib.pop()

    write_lines(ref_path, bib)

    app_path = BARS / "references" / "MRA2015.appendices.md"
    normalized: list[str] = ["# MRA2015 — Appendices and Code", ""]
    for line in appendix:
        if re.match(r"^#\s+Curriculum Vitae\s*$", line.strip(), re.I):
            break
        if re.match(r"^#\s+", line):
            normalized.append(re.sub(r"^#\s+", "## ", line))
        else:
            normalized.append(line)
    write_lines(app_path, normalized)
    print(f"MRA2015: split references ({len(bib)} lines) + appendices ({len(normalized)} lines)")


def process_doc(doc_id: str) -> None:
    path = BARS / f"{doc_id}.md"
    lines = read_lines(path)
    before = len(lines)

    lines = remove_pre_contents_boilerplate(lines)
    lines = strip_tail_acknowledgements(lines)

    if doc_id == "WLK2008":
        lines = demote_wlk_junk_headings(lines)
        lines = merge_wlk_keywords(lines)

    lines = rebuild_contents(lines, doc_id)
    write_lines(path, lines)
    print(f"OK {doc_id}: {before} -> {len(lines)} lines")


def main() -> None:
    split_mra2015_references()
    for doc_id in DOCS:
        process_doc(doc_id)


if __name__ == "__main__":
    main()
