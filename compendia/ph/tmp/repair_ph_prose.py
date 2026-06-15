#!/usr/bin/env python3
"""Low-level ph formatting: ligatures, page markers, OCR typography, hard-wrap merge."""

from __future__ import annotations

import re
from pathlib import Path

PH = Path(__file__).resolve().parents[1]

MAIN_DOCS = sorted(
    p.stem
    for p in PH.glob("*.md")
    if p.name != "_CONTENTS.md" and not p.name.startswith("_")
)

# Longest ligature sequences first.
LIGATURE_REPLACEMENTS: list[tuple[str, str]] = [
    ("ﬃ", "ffi"),
    ("ﬄ", "ffl"),
    ("ﬀ", "ff"),
    ("ﬁ", "fi"),
    ("ﬂ", "fl"),
    ("ﬅ", "ft"),
    ("ﬆ", "st"),
]

UMLAUT_MAP = {
    "a": "ä",
    "o": "ö",
    "u": "ü",
    "A": "Ä",
    "O": "Ö",
    "U": "Ü",
}

ACUTE_MAP = {
    "a": "á",
    "e": "é",
    "i": "í",
    "o": "ó",
    "u": "ú",
    "A": "Á",
    "E": "É",
    "I": "Í",
    "O": "Ó",
    "U": "Ú",
}

PAGE_HEADER_CITE_RE = re.compile(
    r"^\[\s*(\d+)\s*\]\s+([A-Z].{40,})$"
)
INLINE_CITE_RE = re.compile(r"\[\s*(\d+)\s*\]")
STRUCTURAL_RE = re.compile(
    r"^(#{1,6}\s|!\[|\|[-|]|\*\*[^*]+\*\*\s*$|```|\[?\^|\$\$|<!--)"
)
SENTENCE_END_RE = re.compile(r"[.!?:;)\]\"'»]$")


def fix_typography(text: str) -> str:
    for old, new in LIGATURE_REPLACEMENTS:
        text = text.replace(old, new)

    def umlaut_after(m: re.Match[str]) -> str:
        return UMLAUT_MAP.get(m.group(1), m.group(0))

    def umlaut_before(m: re.Match[str]) -> str:
        return UMLAUT_MAP.get(m.group(1), m.group(0))

    text = re.sub(r"¨([aouAOU])", umlaut_after, text)
    text = re.sub(r"([aouAOU])¨", umlaut_before, text)

    def acute_after(m: re.Match[str]) -> str:
        return ACUTE_MAP.get(m.group(1), m.group(0))

    text = re.sub(r"´([aeiouAEIOU])", acute_after, text)

    # Common OCR artifacts
    text = re.sub(r"http:/(?!/)", "http://", text)
    text = re.sub(r"https:/(?!/)", "https://", text)
    text = text.replace(" ,", ",")
    text = text.replace(" .", ".")
    text = INLINE_CITE_RE.sub(r"[\1]", text)
    return text


PAGE_MARKER_RE = re.compile(r"^\[Page \d+\]\s*$")


def demote_page_header_citations(lines: list[str]) -> list[str]:
    """Drop PDF running-header lines like '[ 24 ] The persistent Hodge...'."""
    return [ln for ln in lines if not PAGE_HEADER_CITE_RE.match(ln.strip())]


def is_structural_line(line: str) -> bool:
    s = line.strip()
    if not s:
        return True
    if PAGE_MARKER_RE.match(s):
        return True
    if STRUCTURAL_RE.match(s):
        return True
    if s.startswith("- [") and "](#" in s:
        return True
    if re.match(r"^-\s+\[[\w+\-]+\]", s):
        return True
    if re.match(r"^\[\d+\]\s*$", s):
        return True
    return False


def ends_sentence(line: str) -> bool:
    s = line.rstrip()
    if not s:
        return True
    if s.endswith("$$"):
        return True
    return bool(SENTENCE_END_RE.search(s))


def should_merge(prev: str, curr: str, in_math: bool) -> bool:
    if in_math:
        return False
    if not prev.strip() or not curr.strip():
        return False
    if is_structural_line(prev) or is_structural_line(curr):
        return False
    if prev.rstrip().endswith("$$") or curr.strip().startswith("$$"):
        return False
    if re.match(r"^#{1,6}\s", curr):
        return False
    if ends_sentence(prev):
        return False
    # Avoid merging into display math or list items
    if curr.lstrip().startswith("- "):
        return False
    return True


def merge_hard_wraps(lines: list[str]) -> list[str]:
    out: list[str] = []
    in_math = False

    for line in lines:
        stripped = line.strip()
        if stripped == "$$":
            in_math = not in_math
            out.append(line)
            continue

        if out and should_merge(out[-1], line, in_math):
            prev = out[-1].rstrip()
            nxt = line.strip()
            joiner = "" if prev.endswith("-") else " "
            if prev.endswith("-"):
                prev = prev[:-1]
            out[-1] = prev + joiner + nxt
            continue

        out.append(line)
    return out


def remove_page_markers(lines: list[str]) -> list[str]:
    return [ln for ln in lines if not PAGE_MARKER_RE.match(ln.strip())]


def collapse_blank_lines(lines: list[str]) -> list[str]:
    out: list[str] = []
    blanks = 0
    for line in lines:
        if line.strip() == "":
            blanks += 1
            if blanks <= 2:
                out.append("")
            continue
        blanks = 0
        out.append(line.rstrip())
    while out and out[-1].strip() == "":
        out.pop()
    return out


def repair_text(text: str, *, merge_wraps: bool = True, strip_page_headers: bool = True) -> str:
    text = fix_typography(text)
    lines = text.splitlines()
    lines = remove_page_markers(lines)
    if strip_page_headers:
        lines = demote_page_header_citations(lines)
    if merge_wraps:
        lines = merge_hard_wraps(lines)
    lines = collapse_blank_lines(lines)
    return "\n".join(lines) + "\n"


def process_file(path: Path, *, merge_wraps: bool = True) -> tuple[int, int]:
    before = path.read_text(encoding="utf-8", errors="replace")
    is_ref = "references" in path.parts
    after = repair_text(
        before,
        merge_wraps=merge_wraps,
        strip_page_headers=not is_ref,
    )
    if after != before:
        path.write_text(after, encoding="utf-8")
    return len(before), len(after)


def main() -> None:
    targets: list[Path] = [PH / f"{doc_id}.md" for doc_id in MAIN_DOCS]
    targets.extend(sorted(PH.glob("references/*.md")))

    for path in targets:
        if not path.exists():
            continue
        # Skip aggressive wrap-merge on very large docs (math-heavy; do typography only)
        merge = path.stat().st_size < 350_000
        b, a = process_file(path, merge_wraps=merge)
        delta = a - b
        mode = "typo+wrap" if merge else "typo"
        if delta:
            print(f"OK {path.name}: {b} -> {a} bytes ({delta:+d}, {mode})")
        else:
            print(f"— {path.name}: unchanged ({mode})")


if __name__ == "__main__":
    main()
