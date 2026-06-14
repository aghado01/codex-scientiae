from pathlib import Path
import re

p = Path(__file__).resolve().parents[1] / "TKH2022.md"
for i, l in enumerate(p.read_text(encoding="utf-8").splitlines()):
    if "cknowledg" in l.lower() or "unding" in l or "eproduc" in l.lower():
        print(i, repr(l[:80]))
