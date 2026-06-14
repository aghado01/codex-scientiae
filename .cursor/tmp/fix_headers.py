#!/usr/bin/env python3
"""Fix heading hierarchy and regenerate ## Contents for bars compendium main docs."""
from __future__ import annotations

import re
from pathlib import Path

BARS = Path(__file__).resolve().parents[1]

# Lines matching these become plain text (SCHEMA: remove uninformative sections)
STRIP_SECTION_RE = re.compile(
    r"^## (Acknowledgments?|Funding|Conflict of Interest.*)$", re.I
)

# Pseudo-code / OCR junk headings -> demote to bold label lines (not headings)
PSEUDO_H2_RE = re.compile(
    r"^## (comment:|input:|output:|repeat|• output:?|• Output|• Optional Output)$"
)


def slugify(text: str) -> str:
    s = text.strip().lower()
    s = re.sub(r"[^\w\s$-]", "", s)
    s = re.sub(r"\s+", "-", s)
    return s


def heading_level(line: str) -> int | None:
    m = re.match(r"^(#{1,6})\s+(.+)$", line)
    return len(m.group(1)) if m else None


def parse_headings(body: str) -> list[tuple[int, str, str]]:
    """Return (level, title, anchor) for each heading line."""
    out: list[tuple[int, str, str]] = []
    for line in body.splitlines():
        m = re.match(r"^(#{1,6})\s+(.+)$", line)
        if not m:
            continue
        level = len(m.group(1))
        title = m.group(2).strip()
        if title.lower() == "contents":
            continue
        out.append((level, title, slugify(title)))
    return out


def build_toc(headings: list[tuple[int, str, str]], refs_link: str | None) -> str:
    lines = ["## Contents", ""]
    for level, title, anchor in headings:
        if level == 1:
            continue
        indent = "  " * (level - 2)
        lines.append(f"{indent}- [{title}](#{anchor})")
    if refs_link:
        lines.append(f"- [References]({refs_link})")
    lines.append("")
    return "\n".join(lines)


def demote_jss_subsections(text: str) -> str:
    """WLS2008 / WLK2008: numbered subsections under ## N. -> ###."""
    patterns = [
        (r"^## (2\.\d+\..*)$", r"### \1"),
        (r"^## (3\.\d+\..*)$", r"### \1"),
        (r"^## (5\.\d+\..*)$", r"### \1"),
        (r"^## Results are written into a series of files$", r"### Results are written into a series of files"),
        (r"^## User-defined prior on number of knots$", r"### User-defined prior on number of knots"),
        (r"^## Optional Output$", r"### Optional Output"),
        (r"^## • Output$", r"### Output"),
        (r"^## • Optional Output$", r"### Optional Output"),
        (r"^## • output:$", r"#### output:"),
        (r"^## comment:$", r"#### comment:"),
        (r"^## input:$", r"#### input:"),
        (r"^## output:$", r"#### output:"),
        (r"^## repeat$", r"#### repeat"),
    ]
    for pat, repl in patterns:
        text = re.sub(pat, repl, text, flags=re.M)
    return text


def demote_tn2020(text: str) -> str:
    text = re.sub(r"^## (3\.\d+\.\d+ .*)$", r"#### \1", text, flags=re.M)
    text = re.sub(r"^## (2\.\d+\.\d+ .*)$", r"#### \1", text, flags=re.M)
    text = re.sub(r"^## (4\.\d+ .*)$", r"### \1", text, flags=re.M)
    text = re.sub(r"^## (3\.\d+ .*)$", r"### \1", text, flags=re.M)
    text = re.sub(r"^## (2\.\d+ .*)$", r"### \1", text, flags=re.M)
    text = re.sub(
        r"^### 2\.1 13 C Metabolic Flux Analysis 13$",
        r"### 2.1 $^{13}$C Metabolic Flux Analysis",
        text,
        flags=re.M,
    )
    text = re.sub(
        r"^### 3\.2 13 C MFA",
        r"### 3.2 $^{13}$C MFA",
        text,
        flags=re.M,
    )
    text = re.sub(
        r"^### 4\.2 Recovering bidirectional reaction steps from 13 C data$",
        r"### 4.2 Recovering bidirectional reaction steps from $^{13}$C data",
        text,
        flags=re.M,
    )
    return text


def extract_tn2020_references() -> None:
    path = BARS / "TN2020.md"
    text = path.read_text(encoding="utf-8")
    m = re.search(r"\n## References\n", text)
    if not m:
        return
    refs_body = text[m.end() :].strip()
    refs_path = BARS / "references" / "TN2020.md"
    refs_path.write_text(f"# References — TN2020\n\n{refs_body}\n", encoding="utf-8")
    print("Created references/TN2020.md")


def demote_hyk2024(text: str) -> str:
    text = re.sub(r"^## (2\.\d+ .*)$", r"### \1", text, flags=re.M)
    return text


def demote_htr2005(text: str) -> str:
    return re.sub(
        r"^## Table 1: Regression algorithm in pseudo C code$",
        r"### Table 1: Regression algorithm in pseudo C code",
        text,
        flags=re.M,
    )


def fix_mra2015(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    in_chapter = False
    chapter_section_titles = {
        "Introduction",
        "Nonparametric Regression",
        "Spatially Adaptive Smoothing",
        "Spatially Adaptive Smoothing for Spectral Analysis",
        "Application",
    }
    for line in lines:
        m = re.match(r"^(#{1,6})\s+(.+)$", line)
        if not m:
            out.append(line)
            continue
        level, title = len(m.group(1)), m.group(2).strip()
        if title == "MRA2015":
            out.append(
                "# Spatially Adaptive Bayesian Penalized Splines for Nonparametric Regression"
            )
            continue
        if title == "Contents":
            out.append(line)
            continue
        if title.startswith("Chapter "):
            in_chapter = True
            out.append(line)
            continue
        if re.match(r"^\d+\.\d+\.\d+", title):
            out.append(f"#### {title}")
            continue
        if re.match(r"^\d+\.\d+", title):
            out.append(f"### {title}")
            continue
        if in_chapter and title in chapter_section_titles:
            out.append(f"### {title}")
            continue
        if level == 2 and title not in ("Abstract",) and not title.startswith("Chapter "):
            # keep ## Abstract, ## Chapter N, ## Appendix-style if any
            if re.match(r"^\d", title):
                out.append(f"### {title}")
                continue
        out.append(line)
    return "\n".join(out)


def strip_sections(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    skip = False
    for line in lines:
        if STRIP_SECTION_RE.match(line):
            skip = True
            continue
        if skip:
            if re.match(r"^## ", line) or re.match(r"^# ", line):
                skip = False
            else:
                continue
        if PSEUDO_H2_RE.match(line):
            label = line[3:].strip()
            out.append(f"**{label}**")
            continue
        out.append(line)
    # drop trailing ## References block in main body (sidecar)
    text = "\n".join(out)
    text = re.sub(r"\n## References\n[\s\S]*$", "\n", text)
    return text.rstrip() + "\n"


def replace_contents_block(text: str, new_toc: str) -> str:
    pat = re.compile(r"## Contents\n(?:.*?\n)(?=## )", re.S)
    if not pat.search(text):
        raise ValueError("No ## Contents block found")
    return pat.sub(lambda _m: new_toc + "\n", text, count=1)


def fix_wls_front_matter(text: str) -> str:
    title = (
        "# An Implementation of Bayesian Adaptive Regression Splines (BARS) "
        "in C with S and R Wrappers"
    )
    # Remove old header through first ## Abstract, rebuild
    m = re.search(r"\n## Abstract\n", text)
    if not m:
        raise ValueError("WLS: no Abstract")
    rest = text[m.start() + 1 :]  # keep ## Abstract...
    meta = """\
Garrick Wallstrom, University of Pittsburgh

Jeffrey Liebner, Carnegie Mellon University

Robert E. Kass, Carnegie Mellon University

*Journal of Statistical Software*, June 2008, Volume 26, Issue 1. http://www.jstatsoft.org/

"""
    fig = "![Figure 1](<images/WLS2008/imageFile1.png>)\n\n"
    return title + "\n\n" + meta + "## Contents\n\nPLACEHOLDER\n\n" + fig + rest


def process(path: Path, refs_link: str | None, transform) -> None:
    text = path.read_text(encoding="utf-8")
    if path.name == "WLS2008.md":
        text = fix_wls_front_matter(text)
    text = transform(text)
    text = strip_sections(text)
    headings = parse_headings(text)
    toc = build_toc(headings, refs_link)
    text = replace_contents_block(text, toc)
    path.write_text(text, encoding="utf-8")
    print(f"Updated {path.name}")


def fix_wlk_toc_only(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    text = demote_jss_subsections(text)
    text = strip_sections(text)
    headings = parse_headings(text)
    toc = build_toc(headings, "references/WLK2008.md")
    text = replace_contents_block(text, toc)
    path.write_text(text, encoding="utf-8")
    print(f"Updated {path.name}")


def fix_bm2021_toc(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    headings = parse_headings(text)
    toc = build_toc(headings, "references/BM2021.md")
    text = replace_contents_block(text, toc)
    path.write_text(text, encoding="utf-8")


def fix_bd2005_toc(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    headings = parse_headings(text)
    toc = build_toc(headings, "references/BD2005.md")
    text = replace_contents_block(text, toc)


def fix_gre1995_toc(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    headings = parse_headings(text)
    toc = build_toc(headings, "references/GRE1995.md")
    text = replace_contents_block(text, toc)


def fix_dmgk_toc(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    headings = parse_headings(text)
    toc = build_toc(headings, "references/DMGK2001.md")
    text = replace_contents_block(text, toc)


def main() -> None:
    extract_tn2020_references()
    fix_wlk_toc_only(BARS / "WLK2008.md")
    process(BARS / "WLS2008.md", "references/WLS2008.md", demote_jss_subsections)
    process(BARS / "TN2020.md", "references/TN2020.md", demote_tn2020)
    process(BARS / "HYK2024.md", "references/HYK2024.md", demote_hyk2024)
    process(BARS / "HTR2005.md", "references/HTR2005.md", demote_htr2005)

    mra = BARS / "MRA2015.md"
    text = fix_mra2015(mra.read_text(encoding="utf-8"))
    headings = parse_headings(text)
    toc = build_toc(headings, "references/MRA2015.md")
    text = replace_contents_block(text, toc)
    mra.write_text(text, encoding="utf-8")
    print("Updated MRA2015.md")

    for fn, refs in [
        ("BD2005.md", "references/BD2005.md"),
        ("BM2021.md", "references/BM2021.md"),
        ("GRE1995.md", "references/GRE1995.md"),
        ("DMGK2001.md", "references/DMGK2001.md"),
    ]:
        p = BARS / fn
        text = p.read_text(encoding="utf-8")
        headings = parse_headings(text)
        toc = build_toc(headings, refs)
        text = replace_contents_block(text, toc)
        p.write_text(text, encoding="utf-8")
        print(f"Updated {fn}")


if __name__ == "__main__":
    main()
