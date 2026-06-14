"""Extract figure mapping and Table 2 from archive JSON."""
from __future__ import annotations

import json
import re
from pathlib import Path

JSON = Path(__file__).resolve().parents[3] / ".archive/compendia/ph/HTR2005/HTR2005.json"


def walk(node, figs: list[tuple[str, str]]) -> None:
    if isinstance(node, dict):
        t = node.get("type")
        if t == "image":
            src = node.get("source", "").split("/")[-1]
            if src:
                figs.append(("img", src))
        elif t == "paragraph":
            c = node.get("content", "")
            if re.match(r"Figure \d+:", c):
                figs.append(("cap", c))
        for k in ("kids", "rows"):
            if k in node:
                for child in node[k]:
                    if isinstance(child, dict) and "cells" in child:
                        for cell in child["cells"]:
                            walk(cell, figs)
                    else:
                        walk(child, figs)
    elif isinstance(node, list):
        for item in node:
            walk(item, figs)


def main() -> None:
    j = json.loads(JSON.read_text(encoding="utf-8"))
    figs: list[tuple[str, str]] = []
    walk(j, figs)

    pending: list[str] = []
    by_fig: dict[int, tuple[list[str], str]] = {}
    for t, v in figs:
        if t == "img":
            pending.append(v)
        else:
            m = re.match(r"Figure (\d+):", v)
            if m:
                n = int(m.group(1))
                if n not in by_fig:
                    by_fig[n] = (pending[:], v)
                pending = []

    print("=== FIGURE MAPPING ===")
    for n in sorted(by_fig):
        imgs, cap = by_fig[n]
        print(f"{n}: {imgs}")

    print("\n=== TABLE 2 ===")

    def dump_table(node):
        if isinstance(node, dict):
            if node.get("type") == "table" and node.get("number of columns") == 11:
                for row in node["rows"]:
                    cells = []
                    for c in row["cells"]:
                        txt = c["kids"][0]["content"] if c.get("kids") else ""
                        cells.append(txt.replace("|", "\\|"))
                    print("|" + "|".join(cells) + "|")
                return True
            for v in node.values():
                if isinstance(v, (dict, list)) and dump_table(v):
                    return True
        elif isinstance(node, list):
            for item in node:
                if dump_table(item):
                    return True
        return False

    dump_table(j)


if __name__ == "__main__":
    main()
