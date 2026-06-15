#!/usr/bin/env python3
import re
from pathlib import Path

DOC = Path(__file__).resolve().parents[1] / "TN2020.md"
text = DOC.read_text(encoding="utf-8")
text = text.replace(
    "$p(h i ; M i \\mid g)$",
    r"$p(\nu, \chi_i, \mathcal{M}_i \mid g)$",
)
DOC.write_text(text, encoding="utf-8")
print("fixed")
