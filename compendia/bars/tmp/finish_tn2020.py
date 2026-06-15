#!/usr/bin/env python3
"""Repair TN2020.md equations and OCR notation."""

from __future__ import annotations

import re
from pathlib import Path

DOC = Path(__file__).resolve().parents[1] / "TN2020.md"

EQ1 = """$$
p(\\nu \\mid g) = \\frac{p(g \\mid \\nu)\\, p(\\nu)}{\\int_{\\nu} p(g \\mid \\nu)\\, p(\\nu)\\, d\\nu} \\tag{1}
$$"""

EQ2 = """$$
p(\\Delta_k \\mid g) = \\sum_i p(\\Delta_k \\mid \\mathcal{M}_i, g)\\, p(\\mathcal{M}_i \\mid g)
= \\sum_i \\Delta_{k \\mid \\mathcal{M}_i}\\, p(\\mathcal{M}_i \\mid g) \\tag{2}
$$"""

EQ3 = """$$
p(\\mathcal{M}_i \\mid g) = \\frac{\\int_{\\chi_i} p(g \\mid \\nu, \\chi_i, \\mathcal{M}_i)\\, p(\\nu, \\chi_i \\mid \\mathcal{M}_i)\\, p(\\mathcal{M}_i)\\, d\\chi_i}
{\\sum_j \\int_{\\chi_j} p(g \\mid \\nu, \\chi_j, \\mathcal{M}_j)\\, p(\\nu, \\chi_j \\mid \\mathcal{M}_j)\\, p(\\mathcal{M}_j)\\, d\\chi_j} \\tag{3}
$$"""

EQ4 = """$$
p(\\nu, \\chi_i, \\mathcal{M}_i \\mid g) = \\frac{p(g \\mid \\nu, \\chi_i, \\mathcal{M}_i)\\, p(\\nu, \\chi_i \\mid \\mathcal{M}_i)\\, p(\\mathcal{M}_i)}
{\\sum_j \\int_{\\chi_j} p(g \\mid \\nu, \\chi_j, \\mathcal{M}_j)\\, p(\\nu, \\chi_j \\mid \\mathcal{M}_j)\\, p(\\mathcal{M}_j)\\, d\\chi_j} \\tag{4}
$$"""

EQ5 = """$$
p(\\Delta_k \\mid g) = \\sum_i \\int_{\\chi_i} \\Delta_{k \\mid \\mathcal{M}_i}\\, p(\\nu, \\chi_i, \\mathcal{M}_i \\mid g)\\, d\\chi_i \\tag{5}
$$"""

EQ6 = """$$
p(\\Delta_k \\mid g) = \\mathbb{E}_{p(\\mathcal{M} \\mid g)}[\\Delta_k] \\tag{6}
$$"""


def strip_corrupt_eq(text: str, needle: str, replacement: str) -> str:
    idx = text.find(needle)
    if idx < 0:
        print("MISSING", needle[:50])
        return text
    open_idx = text.rfind("$$", 0, idx)
    close_idx = text.find("$$", idx)
    if open_idx < 0 or close_idx < 0:
        print("NO DELIM", needle[:50])
        return text
    return text[:open_idx] + replacement + text[close_idx + 2 :]


def main() -> None:
    text = DOC.read_text(encoding="utf-8")

    text = strip_corrupt_eq(text, "p ( \\theta | \\eta )", EQ1)
    text = strip_corrupt_eq(text, "p ( \\Delta _ { k } | \\eta ) = \\sum _ { i } p", EQ2)
    text = strip_corrupt_eq(text, "p ( \\mathcal { M } _ { i } | \\eta ) = \\frac", EQ3)
    text = strip_corrupt_eq(text, "p ( \\theta _ { i } , \\mathcal { M } _ { i } | \\eta )", EQ4)
    text = strip_corrupt_eq(text, "p ( \\Delta _ { k } | \\eta ) = \\sum _ { i } \\Delta", EQ5)
    text = strip_corrupt_eq(text, "p ( \\Delta _ { k } | \\eta ) = \\mathbb { E }", EQ6)

    literal = [
        ("fM i g i", r"$\{\mathcal{M}_i\}_i$"),
        ("uni- or bidirectional", "uni- or bi-directional"),
        ("intraand inter-model", "intra- and inter-model"),
        ("singleand multi-model", "single- and multi-model"),
        ("interor intramodel", "inter- or intra-model"),
        ("intermodel", "inter-model"),
        ("Backand forward", "Back- and forward"),
        ("u 2 ½ 0 ; 1", r"$u \in [0,1]$"),
        ("c 2 ½ 0 ; 1", r"$c \in [0,1]$"),
        ("¼", "="),
        ("stateof-the-art", "state-of-the-art"),
        ("13 C MFA", r"$^{13}$C MFA"),
        ("13 C labeling", r"$^{13}$C labeling"),
        ("my means", "by means"),
        ("The class of C MFA", "The class of $^{13}$C MFA"),
        (
            "henceforth, we denote the net and exchange fluxes of model M i , and i , respectively",
            "henceforth, we denote the net and exchange fluxes of model $\\mathcal{M}_i$, $\\nu$ and $\\chi_i$, respectively",
        ),
        ("evaluating Eq. (6)", "evaluating Eq. (5)"),
        ("solving Eq. (6)", "solving Eq. (5)"),
    ]
    for old, new in literal:
        text = text.replace(old, new)

    # Icelandic p ð x j y Þ → $p(x \mid y)$
    def fix_prob(m: re.Match[str]) -> str:
        inner = m.group(1).strip()
        inner = inner.replace(" j ", r" \mid ")
        return f"$p({inner})$"

    text = re.sub(r"p ð ([^Þ]+) Þ", fix_prob, text)

    DOC.write_text(text, encoding="utf-8")
    print("OK", DOC)


if __name__ == "__main__":
    main()
