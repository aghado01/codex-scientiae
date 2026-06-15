#!/usr/bin/env python3
import re
from pathlib import Path

BARE = re.compile(r"(?<!\$)\\[a-zA-Z]")
ROOT = Path(__file__).resolve().parents[1]

for doc in [
    "intersections/RVH2020.md",
    "ph/AL2026.md",
    "bars/GRE1995.md",
    "ph/DS2026.md",
]:
    p = ROOT / doc
    in_m = False
    for i, ln in enumerate(p.read_text(encoding="utf-8").splitlines(), 1):
        if ln.strip() == "$$":
            in_m = not in_m
            continue
        if in_m:
            continue
        if ln.count("$") % 2 and "$" in ln:
            print(f"{p.stem}:{i} odd-$: {ln[:140]}")
            break
    for i, ln in enumerate(p.read_text(encoding="utf-8").splitlines(), 1):
        if ln.strip() == "$$":
            in_m = not in_m
            continue
        if in_m:
            continue
        if BARE.search(ln) and "$" not in ln:
            print(f"{p.stem}:{i} bare: {ln[:140]}")
            break
