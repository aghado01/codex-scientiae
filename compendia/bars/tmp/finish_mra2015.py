#!/usr/bin/env python3
"""Finish MRA2015 appendices sidecar: headings + strip CV."""

from __future__ import annotations

import re
from pathlib import Path

APP = Path(__file__).resolve().parents[1] / "references" / "MRA2015.appendices.md"


def heading_level(text: str) -> int:
    t = text.strip()
    if re.match(r"^Appendix [AB]\b", t, re.I):
        return 2
    if re.match(r"^Curriculum Vitae", t, re.I):
        return 0
    if re.match(r"^Code$", t, re.I):
        return 3
    if re.match(r"^Derivation of Sampling Schemes$", t, re.I):
        return 3
    if re.match(r"^A\.\d", t) or re.match(r"^B\.\d", t):
        return 3
    if re.match(r"^\d+\.\s", t):
        return 4
    return 3


def main() -> None:
    lines = APP.read_text(encoding="utf-8", errors="replace").splitlines()
    out: list[str] = []
    for line in lines:
        m = re.match(r"^#{1,4}\s+(.+)$", line)
        if m:
            text = m.group(1).strip()
            if re.match(r"^Curriculum Vitae", text, re.I):
                break
            if text.startswith("MRA2015"):
                out.append(f"# {text}")
                continue
            lvl = heading_level(text)
            if lvl == 0:
                break
            out.append(f"{'#' * lvl} {text}")
        else:
            out.append(line)
    while out and out[-1].strip() == "":
        out.pop()
    APP.write_text("\n".join(out) + "\n", encoding="utf-8")
    print(f"OK appendices: {len(out)} lines")


if __name__ == "__main__":
    main()
