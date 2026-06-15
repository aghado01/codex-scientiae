#!/usr/bin/env python3
"""Audit math renderability: bare LaTeX outside delimiters, odd $ counts."""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

COMPENDIA = Path(__file__).resolve().parents[1]
BARE = re.compile(r"(?<!\$)\\[a-zA-Z]")
MATH_UNICODE = re.compile(r"[\U0001d400-\U0001d7ff]")
FRAG_PAIR = re.compile(r"\$[^$\n]+\$\s+\$[^$\n]+\$")
ARTICLE_WRAP = re.compile(r"\$A\$\s+[a-z]")
NESTED_IN_SPAN = re.compile(r"\$[^$\n]*\$[A-Za-z0-9\\]+\$[^$\n]*\$")


def audit(path: Path) -> dict:
    text = path.read_text(encoding="utf-8", errors="replace")
    bare = odd = unicode_math = frag_pairs = article = nested = 0
    in_math = False
    for ln in text.splitlines():
        s = ln.strip()
        if s == "$$":
            in_math = not in_math
            continue
        if in_math:
            continue
        if BARE.search(ln) and "$" not in ln:
            bare += 1
        if ln.count("$") % 2 == 1:
            odd += 1
        unicode_math += len(MATH_UNICODE.findall(ln))
        frag_pairs += len(FRAG_PAIR.findall(ln))
        if ARTICLE_WRAP.search(ln):
            article += 1
        if NESTED_IN_SPAN.search(ln):
            nested += 1
    return {
        "id": path.stem,
        "bare": bare,
        "odd": odd,
        "unicode_math": unicode_math,
        "frag_pairs": frag_pairs,
        "article": article,
        "nested": nested,
        "blocks": text.count("$$") // 2,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("compendia", nargs="*", default=["bars", "intersections"])
    args = parser.parse_args(argv)

    for comp in args.compendia:
        paths = sorted(
            p
            for p in (COMPENDIA / comp).glob("*.md")
            if p.name != "_CONTENTS.md" and not p.name.startswith("_")
        )
        print(f"\n=== {comp} ===")
        print("id           bare odd frag article nested unicode")
        for p in paths:
            a = audit(p)
            if any(a[k] for k in ("bare", "odd", "frag_pairs", "article", "nested", "unicode_math")):
                print(
                    f"{a['id']:<12} {a['bare']:4} {a['odd']:4} {a['frag_pairs']:4} "
                    f"{a['article']:7} {a['nested']:6} {a['unicode_math']:7}"
                )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
