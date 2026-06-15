#!/usr/bin/env python3
import re
from pathlib import Path

BARS = Path(__file__).resolve().parents[1]
BARE = re.compile(r"(?<!\$)\\[a-zA-Z]")
SKIP = {"GRE1995"}

for p in sorted(BARS.glob("*.md")):
    if p.name.startswith("_"):
        continue
    if p.stem in SKIP:
        continue
    in_math = False
    for i, ln in enumerate(p.read_text(encoding="utf-8").splitlines(), 1):
        s = ln.strip()
        if s == "$$":
            in_math = not in_math
            continue
        if in_math:
            continue
        if ln.count("$") % 2 == 1:
            print(f"{p.stem}:{i}:ODD  {ln[:120]}")
        if BARE.search(ln) and "$" not in ln:
            print(f"{p.stem}:{i}:BARE {ln[:120]}")
