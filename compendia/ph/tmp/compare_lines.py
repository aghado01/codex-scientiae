#!/usr/bin/env python3
import subprocess
from pathlib import Path

PH = Path(__file__).resolve().parents[1]
for p in sorted(PH.glob("*.md")):
    if p.name.startswith("_"):
        continue
    cur = len(p.read_text(encoding="utf-8").splitlines())
    head = subprocess.run(
        ["git", "show", f"HEAD:{p.as_posix()}"], capture_output=True, text=True
    )
    if head.returncode != 0:
        print(f"{p.stem}: current={cur} HEAD=missing")
        continue
    h = len(head.stdout.splitlines())
    delta = cur - h
    flag = " ***" if delta < -200 else ""
    print(f"{p.stem}: {h} -> {cur} ({delta:+d}){flag}")
