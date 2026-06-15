#!/usr/bin/env python3
"""Bottom-up ph repair: heading hierarchy + per-doc ## Contents. No hub _CONTENTS.

Philosophy: OCR often marks *body* content as headings (authors, lemmas, definitions).
Those are reformatted to plain prose or bold lead-ins — never deleted as noise.
"""

from __future__ import annotations

import re
from pathlib import Path

PH = Path(__file__).resolve().parents[1]

DOCS = sorted(
    p.stem
    for p in PH.glob("*.md")
    if p.name != "_CONTENTS.md" and not p.name.startswith("_")
)

# True section boilerplate — omit from per-doc TOC only (body may keep ## for now).
SKIP_SECTION_RE = re.compile(
    r"acknowledg|funding|data availability|reproducibility|"
    r"declaration of competing|article info|conflict of interest|"
    r"categories and subject|general terms|^keywords$|"
    r"^bibliography$|^table of contents$|^a dissertation$|"
    r"ai usage statement",
    re.I,
)

# Semantic labels that are body content, not document sections.
BODY_LABEL_RE = re.compile(
    r"^(Definition|Lemma|Theorem|Notation|Proposition|Corollary|Remark|Example|"
    r"Case \d|Proof of|Proof of the|Algorithm \d|Figure \d|Output|• output|"
    r"Summary of the procedure|Declarations|Aligning step)",
    re.I,
)

AUTHOR_LINE_RE = re.compile(
    r"^(?:\*\*)?[A-Z][\w'.´\-]+(?:\s+[A-Z][\w'.´\-]+)+(?:\*\*)?"
    r"(?:\s+and\s+(?:\*\*)?[A-Z][\w'.´\-]+(?:\s+[A-Z][\w'.´\-]+)*(?:\*\*)?)?\s*$"
)
AFFIL_RE = re.compile(
    r"university|department|institute|@|\.edu|\.ac\.|school of|faculty of|"
    r"disclaimer|author manuscript|dissertation submitted|"
    r"corresponding author|faculty of science",
    re.I,
)
DATE_LINE_RE = re.compile(
    r"^(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d",
    re.I,
)
METADATA_LINE_RE = re.compile(
    r"^(date|received|accepted|published|communicated by|edited by|"
    r"2000 mathematics subject|key words and phrases|support for the|"
    r"commun\.)",
    re.I,
)


def slugify(text: str) -> str:
    t = text.strip().lower()
    t = re.sub(r"[∗†‡´]", "", t)
    t = re.sub(r"[^\w\s$-]", "", t)
    t = re.sub(r"\s+", "-", t)
    return t.strip("-")


def is_procedure_step(text: str) -> bool:
    return bool(re.match(r"^\d+\.\s+\w+\s+step\b", text, re.I))


def is_numbered_body_label(text: str) -> bool:
    return bool(
        re.match(
            r"^\d+\.\s+(Proposition|Corollary|Remark|Lemma|Theorem)\s*$",
            text.strip(),
            re.I,
        )
    )


def is_body_label(text: str) -> bool:
    t = text.strip()
    return bool(
        BODY_LABEL_RE.match(t)
        or is_numbered_body_label(t)
        or is_procedure_step(t)
    )


def reformat_fragment_heading(text: str) -> str | None:
    """OCR merged subsection title with trailing sentence fragment."""
    m = re.match(r"^(\d+(?:\.\d+)*)\.\s+([^\.]+)\.\s+(.+)$", text.strip())
    if not m:
        return None
    tail = m.group(3).strip()
    if len(tail) > 55:
        return None
    return f"**{m.group(1)}. {m.group(2).strip()}.** {tail}"


def is_metadata_line(text: str) -> bool:
    s = text.strip()
    if not s:
        return False
    if AUTHOR_LINE_RE.match(s):
        return True
    if re.match(r"^[A-Z][A-Z\s,\-–\.∗\*]+$", s) and len(s) < 200:
        return True
    if AFFIL_RE.search(s) and len(s) < 300:
        return True
    if DATE_LINE_RE.match(s):
        return True
    if METADATA_LINE_RE.search(s) and len(s) < 300:
        return True
    if re.match(r"^[A-Z][a-z]+ [A-Z][a-z]+$", s) and len(s) < 80:
        return True
    if re.match(r"^\d+,\d+", s) or re.match(r".*\\\*$", s):
        return True
    return False


def heading_target_level(text: str) -> int:
    t = text.strip()
    if is_body_label(t) or is_metadata_line(t):
        return 0  # not a section heading

    if re.match(
        r"^(abstract|introduction|acknowledgment|acknowledgements|summary|"
        r"conclusion|discussions?|bibliography|appendix|preliminaries|"
        r"background|overview|experiments?|materials and methods|"
        r"results|discussion|motivation)",
        t,
        re.I,
    ):
        return 2

    if re.match(r"^CHAPTER\s+\d", t, re.I):
        return 2

    if re.match(r"^[IVX]+\.\s", t):
        return 2
    if re.match(r"^[A-Z]\.\s", t):
        return 3

    m = re.match(r"^([A-Z])(?:\.(\d+(?:\.\d+)*))?\s+", t)
    if m and m.group(2):
        depth = m.group(2).count(".") + 2
        return min(depth + 1, 4)
    if m and not m.group(2) and re.match(r"^[A-Z]\s", t):
        return 2

    m = re.match(r"^(\d+(?:\.\d+)*)\s*[\.\)]?\s*", t)
    if m:
        depth = m.group(1).count(".") + 1
        return min(depth + 1, 4)

    return 2


def read_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8", errors="replace").splitlines()


def write_lines(path: Path, lines: list[str]) -> None:
    while lines and lines[-1].strip() == "":
        lines.pop()
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def demote_extra_h1(lines: list[str]) -> list[str]:
    """Keep first # as title; reformat other # lines to sections or plain metadata."""
    out: list[str] = []
    seen_title = False
    for line in lines:
        m = re.match(r"^#\s+(.+)$", line)
        if not m:
            out.append(line)
            continue
        text = m.group(1).strip()
        if not seen_title:
            seen_title = True
            out.append(line)
            continue
        if text.lower() == "contents":
            continue
        if is_metadata_line(text) or is_body_label(text):
            out.append(text)
            continue
        lvl = heading_target_level(text)
        if lvl == 0:
            frag = reformat_fragment_heading(text)
            out.append(frag if frag else f"**{text}**")
            continue
        out.append("#" * lvl + " " + text)
    return out


def demote_body_labels_to_prose(lines: list[str]) -> list[str]:
    """Turn mistaken ##/###/#### semantic labels into bold body lead-ins."""
    out: list[str] = []
    for line in lines:
        m = re.match(r"^(#{2,4})\s+(.+)$", line)
        if not m:
            out.append(line)
            continue
        text = m.group(2).strip()
        frag = reformat_fragment_heading(text)
        if frag:
            out.append(frag)
            continue
        if is_body_label(text) or is_metadata_line(text):
            out.append(f"**{text}**")
            continue
        out.append(line)
    return out


def promote_plain_section_headings(lines: list[str]) -> list[str]:
    """Promote 'N. Title. prose', 'N.N. Title. prose', and 'Abstract. prose' lines."""
    out: list[str] = []
    for line in lines:
        s = line.strip()
        m = re.match(r"^Abstract\.\s+(.+)$", s, re.I)
        if m:
            out.append("## Abstract")
            out.append("")
            out.append(m.group(1))
            continue
        m = re.match(r"^(\d+(?:\.\d+)*)\.\s+([^\.]{4,120})\.\s+(.+)$", s)
        if m and len(m.group(3)) >= 60:
            depth = m.group(1).count(".") + 1
            lvl = min(depth + 1, 4)
            out.append("#" * lvl + f" {m.group(1)}. {m.group(2).strip()}")
            out.append("")
            out.append(m.group(3))
            continue
        out.append(line)
    return out


def relocate_metadata_before_contents(lines: list[str]) -> list[str]:
    """Place author/affiliation metadata between # title and ## Contents."""
    if not lines or not lines[0].startswith("# "):
        return lines

    title = lines[0]
    rest = lines[1:]
    metadata: list[str] = []
    body: list[str] = []
    i = 0
    while i < len(rest):
        line = rest[i]
        if re.match(r"^## Contents\s*$", line):
            break
        s = line.strip()
        if s and is_metadata_line(s):
            metadata.append(line)
            i += 1
            while i < len(rest) and rest[i].strip() == "":
                i += 1
            continue
        break

    # Also pull metadata sitting immediately after an existing Contents block.
    if i < len(rest) and re.match(r"^## Contents\s*$", rest[i]):
        i += 1
        while i < len(rest) and (rest[i].strip() == "" or re.match(r"^(\s*)- ", rest[i])):
            i += 1
        while i < len(rest):
            s = rest[i].strip()
            if not s:
                i += 1
                continue
            if is_metadata_line(s):
                metadata.append(rest[i])
                i += 1
                continue
            if re.match(r"^##\s+", rest[i]):
                break
            break

    body = rest[i:]
    if not metadata:
        return lines

    out = [title, ""]
    out.extend(metadata)
    out.append("")
    out.extend(body)
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
        if SKIP_SECTION_RE.search(text):
            continue
        if is_body_label(text) or is_metadata_line(text):
            continue
        if lvl > 4:
            lvl = 4
        items.append((lvl, text, slugify(text)))
    return items


def rebuild_contents(lines: list[str], doc_id: str) -> list[str]:
    out: list[str] = []
    i = 0
    while i < len(lines):
        if re.match(r"^## Contents\s*$", lines[i]):
            i += 1
            while i < len(lines) and (
                lines[i].strip() == "" or re.match(r"^(\s*)- ", lines[i])
            ):
                i += 1
            continue
        out.append(lines[i])
        i += 1

    insert_at = 1
    if len(out) > 1 and out[1].strip() == "":
        insert_at = 2
    while insert_at < len(out):
        s = out[insert_at].strip()
        if not s:
            insert_at += 1
            continue
        if is_metadata_line(s) and not out[insert_at].startswith("#"):
            insert_at += 1
            continue
        break
    if insert_at < len(out) and out[insert_at].strip() == "":
        insert_at += 1
    elif len(out) > 1 and insert_at == 1:
        out = out[:1] + [""] + out[1:]
        insert_at = 2

    headings = collect_headings(out)
    contents = ["## Contents", ""]
    for lvl, text, slug in headings:
        indent = "  " * (lvl - 2)
        contents.append(f"{indent}- [{text}](#{slug})")
    ref = PH / "references" / f"{doc_id}.md"
    if ref.exists() or not doc_id.startswith("REF-"):
        contents.append(f"- [References](references/{doc_id}.md)")
    contents.append("")
    return out[:insert_at] + contents + out[insert_at:]


def process_doc(doc_id: str) -> None:
    path = PH / f"{doc_id}.md"
    lines = read_lines(path)
    before = len(lines)

    lines = demote_extra_h1(lines)
    lines = promote_plain_section_headings(lines)
    lines = demote_body_labels_to_prose(lines)
    lines = relocate_metadata_before_contents(lines)
    lines = rebuild_contents(lines, doc_id)
    write_lines(path, lines)
    h2 = sum(1 for ln in lines if ln.startswith("## ") and not ln.startswith("## Contents"))
    h3 = sum(1 for ln in lines if ln.startswith("### "))
    print(f"OK {doc_id}: {before} -> {len(lines)} lines (##={h2}, ###={h3})")


def main() -> None:
    for doc_id in DOCS:
        process_doc(doc_id)


if __name__ == "__main__":
    main()
