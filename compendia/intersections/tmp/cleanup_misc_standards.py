#!/usr/bin/env python3
"""Normalize compendia/intersections docs: headings, TOC, strip boilerplate, references sidecar link."""

from __future__ import annotations

import re
from pathlib import Path

INTERSECTIONS = Path(__file__).resolve().parents[1]
DOCS = [
    "TKH2022",
    "GLL2026",
    "GVPB2025",
    "MR2026",
    "RVH2020",
    "MNO2019",
    "MMO2019",
    "SGL2022",
]

SKIP_SECTION_RE = re.compile(
    r"acknowledg|funding|data availability|declaration of competing|"
    r"reproducibility|article info|conflict of interest",
    re.I,
)

JUNK_HEADING_RE = re.compile(
    r"^(vasileios maroulas|joshua l mike|christopher oballe|"
    r"distributions of persistence diagrams|maroulas, mike, and oballe|"
    r"algorithm \d+ .+)$",
    re.I,
)

BOILERPLATE_LINE_RE = [
    re.compile(r"^V C The Author", re.I),
    re.compile(r"^Contact:\s", re.I),
    re.compile(r"^Availability and implementation:", re.I),
    re.compile(r"^Con[fﬂ]ict of Interest", re.I),
    re.compile(r"^Editor:\s*$", re.I),
    re.compile(r"^[∗†‡]\s"),
    re.compile(r"^Correspondence:\s", re.I),
    re.compile(r"^These authors contributed equally", re.I),
    re.compile(r"^E-mail address:\s", re.I),
    re.compile(r"^Supported in part by NSF", re.I),
    re.compile(r"^Yale University,", re.I),
    re.compile(r"^Sherrerd Hall,", re.I),
    re.compile(r"^School of Mathematical", re.I),
    re.compile(r"^State Key Laboratory", re.I),
    re.compile(r"^Chenming Gao\s", re.I),
    re.compile(r"^Keywords\s*:\s", re.I),
    re.compile(r"^vmaroula@|mikejosh@|coballe@", re.I),
    re.compile(r"^Department of Mathematics", re.I),
    re.compile(r"^Computational Mathematics", re.I),
    re.compile(r"^Thomas Thorne, Paul Kirk", re.I),
    re.compile(r"^Nicholas Sale,", re.I),
    re.compile(r"^Matteo Rucco\s*$", re.I),
    re.compile(r"^Vasileios Maroulas Farzana", re.I),
    re.compile(r"^Yuri Gardinazzi,", re.I),
    re.compile(r"^Patrick Rebeschini\s*,", re.I),
]

SUBSECTION_RE = re.compile(
    r"^(\d+\.\d+(?:\.\d+)?\.?|[A-Z]\.\s|"
    r"Lemma \d+|Appendix [A-Z]:|[0-9]+\. resampling)",
    re.I,
)

ROMAN_SUBSECTION_RE = re.compile(r"^[A-G]\.\s", re.I)


def slugify(text: str) -> str:
    t = text.strip().lower()
    t = re.sub(r"[∗†‡]", "", t)
    t = re.sub(r"[^\w\s-]", "", t)
    t = re.sub(r"\s+", "-", t)
    return t.strip("-")


def is_boilerplate_line(line: str) -> bool:
    s = line.strip()
    if not s:
        return False
    return any(p.search(s) for p in BOILERPLATE_LINE_RE)


def heading_level(text: str, doc_id: str) -> int:
    """Return markdown heading level 2-4 for section text."""
    t = text.strip()
    if SKIP_SECTION_RE.search(t) or JUNK_HEADING_RE.search(t):
        return 2
    if re.match(r"^abstract$|^keywords$|^contents$", t, re.I):
        return 2
    if doc_id == "SGL2022":
        if re.match(r"^(I{1,3}|IV)\.\s", t):
            return 2
        if ROMAN_SUBSECTION_RE.match(t):
            return 3
        if re.match(r"^Appendix [A-Z]:", t, re.I):
            return 2
        if re.match(r"^\d+\.\s", t):
            return 3
        if re.match(r"^1\. resampling", t, re.I):
            return 3
        return 2
    if SUBSECTION_RE.match(t):
        return 3
    if re.match(r"^\d+\s", t) or re.match(r"^\d+\.\s", t):
        return 2
    return 2


def normalize_hash_headings(lines: list[str], doc_id: str) -> list[str]:
    """Convert mixed # headings to proper hierarchy."""
    out: list[str] = []
    title_set = False
    for line in lines:
        m = re.match(r"^(#{1,4})\s+(.+)$", line)
        if not m:
            out.append(line)
            continue
        hashes, text = m.group(1), m.group(2).strip()
        if not title_set and len(hashes) == 1:
            out.append(f"# {text}")
            title_set = True
            continue
        if not title_set and len(hashes) >= 2:
            # TKH2022: first ## is title
            out.append(f"# {text}")
            title_set = True
            continue
        if JUNK_HEADING_RE.search(text) or SKIP_SECTION_RE.search(text):
            # mark for section skip — keep heading for cutter
            lvl = 2
        else:
            lvl = heading_level(text, doc_id)
        out.append(f"{'#' * lvl} {text}")
    return out


def first_boilerplate_index(lines: list[str]) -> int | None:
    for i, line in enumerate(lines):
        m = re.match(r"^#{2,4}\s+(.+)$", line)
        if m and SKIP_SECTION_RE.search(m.group(1).strip()):
            return i
    return None


def strip_sections(lines: list[str]) -> list[str]:
    cut = first_boilerplate_index(lines)
    if cut is not None:
        lines = lines[:cut]

    out: list[str] = []
    for line in lines:
        m = re.match(r"^#{2,4}\s+(.+)$", line)
        if m and JUNK_HEADING_RE.search(m.group(1).strip()):
            continue
        if is_boilerplate_line(line):
            continue
        out.append(line)

    while out and out[-1].strip() in ("$$", ""):
        out.pop()
    return out


def fix_tkh_abstract(lines: list[str]) -> list[str]:
    out: list[str] = []
    in_abstract = False
    for line in lines:
        if re.match(r"^## Abstract\s*$", line):
            in_abstract = True
            out.append(line)
            continue
        if in_abstract and line.startswith("## ") and "Abstract" not in line:
            in_abstract = False
        if in_abstract and re.match(r"^#?Results", line):
            out.append(re.sub(r"^#?Results:\s*", "Results: ", line))
            continue
        out.append(line)
    return out


def remove_author_plaintext(lines: list[str]) -> list[str]:
    """Drop standalone author/affiliation lines between Contents and Abstract."""
    out: list[str] = []
    past_contents = False
    for line in lines:
        if re.match(r"^## Contents\s*$", line):
            past_contents = True
            out.append(line)
            continue
        if past_contents and not re.match(r"^##\s+", line) and not line.startswith("- "):
            s = line.strip()
            if not s:
                out.append(line)
                continue
            if re.match(r"^[A-Za-z].*(,| and )", s) and "@" not in s and len(s) < 160:
                continue
            if re.match(r"^[A-Z][a-z]+ [A-Z][a-z]+$", s):
                continue
            if re.match(r"^[a-z]+@[a-z]", s):
                continue
        out.append(line)
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


def build_contents(headings: list[tuple[int, str, str]], doc_id: str) -> list[str]:
    ref_name = "SGL2022.md" if doc_id == "SGL2022" else f"{doc_id}.md"
    lines = ["## Contents", ""]
    for lvl, text, slug in headings:
        indent = "  " * (lvl - 2)
        lines.append(f"{indent}- [{text}](#{slug})")
    lines.append(f"- [References](references/{ref_name})")
    lines.append("")
    return lines


def insert_contents(lines: list[str], doc_id: str) -> list[str]:
    if not lines:
        return lines
    # remove existing Contents block
    out: list[str] = []
    i = 0
    while i < len(lines):
        if re.match(r"^## Contents\s*$", lines[i]):
            i += 1
            while i < len(lines) and (
                lines[i].strip() == ""
                or lines[i].startswith("- ")
                or lines[i].startswith("  - ")
            ):
                i += 1
            continue
        out.append(lines[i])
        i += 1

    # find insert point: after title (and optional blank/image)
    insert_at = 1
    if len(out) > 1 and out[1].strip() == "":
        insert_at = 2
    # skip leading image line right after title
    if insert_at < len(out) and out[insert_at].startswith("!["):
        insert_at += 1
        if insert_at < len(out) and out[insert_at].strip() == "":
            insert_at += 1

    headings = collect_headings(out)
    contents = build_contents(headings, doc_id)
    return out[:insert_at] + contents + out[insert_at:]


def clean_title_footnotes(lines: list[str]) -> list[str]:
    out: list[str] = []
    for i, line in enumerate(lines):
        if i == 0 and line.startswith("# "):
            line = re.sub(r"\s*[∗†‡]\s*$", "", line)
        out.append(line)
    return out


def process_doc(doc_id: str) -> None:
    path = INTERSECTIONS / f"{doc_id}.md"
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    lines = clean_title_footnotes(lines)
    if doc_id == "TKH2022":
        lines = fix_tkh_abstract(lines)
        lines = [
            ln
            for ln in lines
            if not ln.startswith("![image 1]")
            and "Thomas Thorne, Paul Kirk" not in ln
        ]

    # demote single-hash body headings (GLL, GVPB)
    if doc_id in ("GLL2026", "GVPB2025"):
        new_lines: list[str] = []
        first = True
        for line in lines:
            if re.match(r"^#\s+", line) and not first:
                new_lines.append("#" + line)  # # -> ##
            elif re.match(r"^#\s+", line):
                new_lines.append(line)
                first = False
            else:
                new_lines.append(line)
        lines = new_lines

    lines = normalize_hash_headings(lines, doc_id)
    lines = strip_sections(lines)
    lines = remove_author_plaintext(lines)
    lines = insert_contents(lines, doc_id)

    path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"OK {doc_id}: {len(lines)} lines")


def fix_sgl_ref_casing():
    src = INTERSECTIONS / "references" / "SGL2022.MD"
    dst = INTERSECTIONS / "references" / "SGL2022.md"
    if src.exists() and not dst.exists():
        text = src.read_text(encoding="utf-8")
        if not text.startswith("# References"):
            text = "# References — SGL2022\n\n" + text
        dst.write_text(text, encoding="utf-8")
        src.unlink()
        print("Renamed references/SGL2022.MD -> SGL2022.md")


def main():
    fix_sgl_ref_casing()
    for doc_id in DOCS:
        process_doc(doc_id)


if __name__ == "__main__":
    main()
