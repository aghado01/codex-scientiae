import re
SKIP = re.compile(
    r"^(acknowledg|funding|data availability|declaration of competing|"
    r"reproducibility|article info|conflict of interest)\b",
    re.I,
)
text = "Acknowledgements"
print("search", SKIP.search(text))
line = "## Acknowledgements"
m = re.match(r"^#{2,4}\s+(.+)$", line)
print("match", m, m.group(1) if m else None)
if m:
    print("skip", SKIP.search(m.group(1).strip()))
