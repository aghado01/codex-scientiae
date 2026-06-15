#!/usr/bin/env python3
"""Quick renderability audit: bare LaTeX outside $ delimiters."""
from __future__ import annotations
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]  # compendia/ph/tmp -> compendia
BARE = re.compile(r"(?<!\$)\\[a-zA-Z]")


def audit(path: Path) -> dict:
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()
    bare = odd = 0
    in_math = False
    for ln in lines:
        s = ln.strip()
        if s == "$$":
            in_math = not in_math
            continue
        if in_math:
            continue
        if BARE.search(ln) and "$" not in ln:
            bare += 1
        d = ln.count("$")
        if d % 2 == 1:
            odd += 1
    return {"bare": bare, "odd": odd, "dollars": d}


for folder in ("ph", "bars"):
    d = ROOT / folder
    if not d.exists():
        continue
    print(f"\n=== {folder} ===")
    for p in sorted(d.glob("*.md")):
        if p.name.startswith("_"):
            continue
        a = audit(p)
        if a["bare"] > 5 or a["odd"] > 10:
            print(f"{p.stem:12} bare_lines={a['bare']:4} odd_$={a['odd']:4}")
