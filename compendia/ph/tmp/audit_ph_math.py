#!/usr/bin/env python3
"""Audit math/OCR hygiene across ph main docs."""

from __future__ import annotations

import re
from pathlib import Path

PH = Path(__file__).resolve().parents[1]

BARE_UNICODE_MATH = re.compile(
    r"(?<!\$)[µνσρ∆λ∈≤≥×·∀∃∑∏∫∂∇αβγδεζηθικμξπφχψωΓΔΛΣΦΩ±∞≈≠⊂⊆⊃⊇→←↦⊗⊕⊥∧∨](?!\$)"
)
LIGATURE_RE = re.compile(r"[ﬁﬂﬃﬀﬄ]")
SPACED_LATEX = re.compile(r"\\\s+[_^{]|[_^]\s+\{")
BROKEN_MATH_PROSE = re.compile(
    r"\\text\s*\{\s*(?:ator\.|affix|Let\s+contiguous|F i x)",
    re.I,
)
BARE_SUBSCRIPT = re.compile(r"(?<!\$)\b([A-Za-z])\s+_\s*\{\s*([^}]+)\s*\}(?!\$)")
ORPHAN_DOLLAR = re.compile(r"(?<!\$)\$(?!\$)(?!\s*[\w\\{])")


def audit(path: Path) -> dict:
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()
    math_blocks = 0
    in_math = False
    for ln in lines:
        if ln.strip() == "$$":
            in_math = not in_math
            if in_math:
                math_blocks += 1
    return {
        "id": path.stem,
        "lines": len(lines),
        "bare_unicode": len(BARE_UNICODE_MATH.findall(text)),
        "ligatures": len(LIGATURE_RE.findall(text)),
        "spaced_latex": len(SPACED_LATEX.findall(text)),
        "broken_math_prose": len(BROKEN_MATH_PROSE.findall(text)),
        "bare_subscript": len(BARE_SUBSCRIPT.findall(text)),
        "math_blocks": math_blocks,
        "dollar_count": text.count("$"),
    }


def main() -> None:
    docs = sorted(
        p for p in PH.glob("*.md") if p.name != "_CONTENTS.md" and not p.name.startswith("_")
    )
    rows = [audit(p) for p in docs]
    print("id           bare_uni lig  spaced broken bare_sub $$blocks $count lines")
    for r in sorted(rows, key=lambda x: -(x["bare_unicode"] + x["broken_math_prose"] * 50)):
        print(
            f"{r['id']:<12} {r['bare_unicode']:8} {r['ligatures']:4} "
            f"{r['spaced_latex']:6} {r['broken_math_prose']:6} {r['bare_subscript']:8} "
            f"{r['math_blocks']:7} {r['dollar_count']:6} {r['lines']:5}"
        )


if __name__ == "__main__":
    main()
