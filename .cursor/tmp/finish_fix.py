#!/usr/bin/env python3
from pathlib import Path
import re
import importlib.util

spec = importlib.util.spec_from_file_location(
    "fix", Path(__file__).parent / "fix_headers.py"
)
fix = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fix)
BARS = fix.BARS

WLK_TOC = """## Contents

- [Abstract](#abstract)
- [Keywords](#keywords)
- [1. Introduction](#1-introduction)
- [2. Overview of BARS](#2-overview-of-bars)
  - [2.1. MCMC in BARS](#21-mcmc-in-bars)
  - [2.2. Normal and Poisson implementations of BARS](#22-normal-and-poisson-implementations-of-bars)
- [3. Overview of code](#3-overview-of-code)
  - [3.1. User-defined parameters](#31-user-defined-parameters)
  - [3.2. Read data](#32-read-data)
  - [3.3. Find initial knot set](#33-find-initial-knot-set)
  - [3.4. Run MCMC](#34-run-mcmc)
  - [3.5. Obtain estimates](#35-obtain-estimates)
  - [3.6. Obtain posterior intervals](#36-obtain-posterior-intervals)
  - [3.7. Write results](#37-write-results)
  - [Results are written into a series of files](#results-are-written-into-a-series-of-files)
  - [3.8. External subroutines for BARS](#38-external-subroutines-for-bars)
- [4. R and S wrappers](#4-r-and-s-wrappers)
  - [Output](#output)
  - [Optional Output](#optional-output)
- [5. Pseudo-code](#5-pseudo-code)
  - [5.1. Function: BARS for Poisson count data](#51-function-bars-for-poisson-count-data)
  - [5.2. Function: MCMC](#52-function-mcmc)
  - [5.3. Function: Fit Poisson regression model](#53-function-fit-poisson-regression-model)
  - [5.4. Function: Generate random coefficient vector](#54-function-generate-random-coefficient-vector)
- [References](references/WLK2008.md)
"""


def strip_acknowledgements(text: str) -> str:
    text = re.sub(
        r"\n## Acknowledgements?\n[\s\S]*$",
        "\n",
        text,
        flags=re.I,
    )
    return text.rstrip() + "\n"


def main() -> None:
    wlk = BARS / "WLK2008.md"
    text = wlk.read_text(encoding="utf-8")
    text = fix.demote_jss_subsections(text)
    text = strip_acknowledgements(text)
    text = fix.replace_contents_block(text, WLK_TOC.strip())
    wlk.write_text(text, encoding="utf-8")
    print("Fixed WLK2008.md")

    tn = BARS / "TN2020.md"
    text = tn.read_text(encoding="utf-8")
    text = strip_acknowledgements(text)
    headings = fix.parse_headings(text)
    toc = fix.build_toc(headings, "references/TN2020.md")
    text = fix.replace_contents_block(text, toc)
    tn.write_text(text, encoding="utf-8")
    print("Fixed TN2020.md")

    for fn, refs in [
        ("BD2005.md", "references/BD2005.md"),
        ("BM2021.md", "references/BM2021.md"),
        ("GRE1995.md", "references/GRE1995.md"),
        ("DMGK2001.md", "references/DMGK2001.md"),
    ]:
        p = BARS / fn
        text = p.read_text(encoding="utf-8")
        headings = fix.parse_headings(text)
        toc = fix.build_toc(headings, refs)
        text = fix.replace_contents_block(text, toc)
        p.write_text(text, encoding="utf-8")
        print(f"Fixed {fn}")

    refs_wls = BARS / "references" / "WLS2008.md"
    lines = refs_wls.read_text(encoding="utf-8").splitlines()
    clean = []
    for line in lines:
        if line.startswith("# Affiliation"):
            break
        clean.append(line)
    refs_wls.write_text("\n".join(clean).rstrip() + "\n", encoding="utf-8")
    print("Trimmed references/WLS2008.md")


if __name__ == "__main__":
    main()
