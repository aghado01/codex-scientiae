from pathlib import Path

lines = Path(__file__).resolve().parents[1].joinpath("WLK2008.md").read_text(encoding="utf-8").splitlines()
in_math = False
for i, ln in enumerate(lines, 1):
    s = ln.strip()
    if s == "$$":
        in_math = not in_math
        print(f"{i:4} {'MATH' if in_math else '----'}  {ln[:80]}")
    elif i <= 620 and (in_math or '\\' in ln):
        if '\\' in ln:
            print(f"{i:4} {'MATH' if in_math else 'TEXT'} {ln[:80]}")
