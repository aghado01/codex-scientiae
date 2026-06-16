import re
from pathlib import Path

BARE = re.compile(r"(?<!\$)\\[a-zA-Z]")
text = Path(__file__).resolve().parents[1] / "WLK2008.md"
lines = text.read_text(encoding="utf-8").splitlines()
in_math = False
for i, ln in enumerate(lines, 1):
    s = ln.strip()
    if s == "$$":
        in_math = not in_math
        continue
    if in_math:
        continue
    if BARE.search(ln) and "$" not in ln:
        print(i, ln[:140])
