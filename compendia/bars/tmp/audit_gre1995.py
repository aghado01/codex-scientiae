#!/usr/bin/env python3
from pathlib import Path
import re

p = Path(__file__).resolve().parents[1] / "GRE1995.md"
text = p.read_text(encoding="utf-8")
BARE = re.compile(r"(?<!\$)\\[a-zA-Z]")
in_m = False
odd = bare = 0
for i, ln in enumerate(text.splitlines(), 1):
    if ln.strip() == "$$":
        in_m = not in_m
        continue
    if in_m:
        continue
    if ln.count("$") % 2 and "$" in ln:
        odd += 1
        print("odd", i, ln[:140])
    if BARE.search(ln) and "$" not in ln:
        bare += 1
        if bare <= 8:
            print("bare", i, ln[:140])
print("totals odd", odd, "bare", bare)
