#!/usr/bin/env python3
"""Fix MMO2019 figures, GLL2026 algorithm, SGL2022 appendices/TOC/conclusions."""

from __future__ import annotations

import re
from pathlib import Path

INTERSECTIONS = Path(__file__).resolve().parents[1]
ARCHIVE = INTERSECTIONS.parents[1] / ".archive" / "compendia" / "ph"

FIGURE_IMAGES = {
    1: "imageFile1",
    2: "imageFile2",
    3: "imageFile3",
    4: "imageFile4",
    5: "imageFile5",
    6: "imageFile7",
    7: "imageFile8",
    8: "imageFile9",
    9: "imageFile10",
}

JUNK_LINE = re.compile(
    r"^("
    r"\d+/\d+$|"
    r"\d+\.\d+$|"
    r"^\d+$|"
    r"Birth$|Death$|"
    r"Time \(s\)$|Frequency \(Hz\)$|"
    r"x\(t\)$|"
    r"\([a-h]\)$|"
    r"glyph\[.*\]$|"
    r"\[Page \d+\]$|"
    r"EEG, SNR.*$|"
    r"Periodogram.*$|"
    r"SNR.* Point Cloud$|"
    r"SNR.* Persistence Diagram$|"
    r"Distribution of.*$|"
    r"Infinity Norm$|"
    r"Max Persistence$|"
    r"^\*{3,}.*\*{3,}$"
    r")",
    re.I,
)


def is_figure_junk(line: str) -> bool:
    s = line.strip()
    if not s:
        return True
    if s.startswith("![") and ("### Analysis" in s or "The image is" in s or len(s) > 200):
        return True
    if JUNK_LINE.match(s):
        return True
    if re.match(r"^0\.\d+$", s) or re.match(r"^[\d\.]+,$", s):
        return True
    if s in {"080", "444", "kNN", "ln(", ")", "(", ","}:
        return True
    return False


def repair_mmo_figures(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        m = re.match(r"^Figure (\d+):\s*(.+)$", lines[i].strip())
        if m:
            num = int(m.group(1))
            caption = f"Figure {num}: {m.group(2)}"
            img = FIGURE_IMAGES.get(num)
            block = []
            if img:
                block.append(f"![Figure {num}](<MMO2019/{img}.png>)")
                block.append("")
            block.append(caption)
            block.append("")
            # drop backward junk until prose/image marker
            while out and (
                is_figure_junk(out[-1])
                or out[-1].strip().startswith("![")
                or out[-1].strip() in {"(a)", "(b)", "(c)", "(d)", "(e)", "(f)", "(g)", "(h)"}
            ):
                out.pop()
            out.extend(block)
            i += 1
            continue
        if not is_figure_junk(lines[i]) or lines[i].strip().startswith("![image"):
            stripped = lines[i].strip()
            if stripped.startswith("![image") and "The image" not in stripped:
                out.append(lines[i])
            elif not is_figure_junk(lines[i]):
                out.append(lines[i])
        i += 1
    return "\n".join(out) + "\n"


GLL_ALGO_BLOCK = """### Algorithm 1 Two-step Mapper algorithm

**Input:** A point set $X \\subseteq \\mathbb{R}^2$, clustering parameter $\\delta$, overlap ratio $\\theta_{ov}$

**Output:** Mapper graph $G$ of $X$

1. Construct the initial Mapper graph $G$
2. Set $V_{split} = \\emptyset$
3. for each point set $X_i$ corresponding to the node $v_i$ in $G$ do
4. &nbsp;&nbsp;&nbsp;&nbsp;Compute the number of intervals $S_i$ corresponding to $X_i$
5. &nbsp;&nbsp;&nbsp;&nbsp;if $S_i \\geq 2$ then
6. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Add the node $v_i$ to $V_{split}$
7. &nbsp;&nbsp;&nbsp;&nbsp;end if
8. end for
9. Merge nodes in $V_{split}$ that belong to the same connected component in $G$ into a single node
10. for each point set $X_i$ corresponding to the node $v_i$ in $V_{split}$ do
11. &nbsp;&nbsp;&nbsp;&nbsp;Construct the Mapper subgraph $G_i$ corresponding to $X_i$ using $f^{\\perp}$
12. &nbsp;&nbsp;&nbsp;&nbsp;for each point set $X_{nei}$ corresponding to neighboring node $v_{nei}$ of $v_i$ in $G$ do
13. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Merge all nodes in $G_i$ where their corresponding point sets intersect with $X_{nei}$ into a single node
14. &nbsp;&nbsp;&nbsp;&nbsp;end for
15. &nbsp;&nbsp;&nbsp;&nbsp;Replace $v_i$ with all nodes from $G_i$
16. end for
17. Add edges to $G$ according to the edge addition rule of the Mapper algorithm
18. return $G$

Next, we compute the covariance matrix $\\Sigma = (\\sigma_{i,j})$ of the centralized point set $X$,

$$
\\sigma _ { i , j } = \\langle x _ { i } - x _ { c } , \\ x _ { j } - x _ { c } \\rangle , \\text { where } x _ { i } , \\ x _ { j } \\in X . \\tag {3}
$$

The eigenvector corresponding to the largest eigenvalue of $\\Sigma$ is denoted by $w_p$ and defines the principal direction. The filter function $f$ is then defined as the projection of a data point $x$ onto $w_p$:

$$
f ( x ) = \\langle x - x _ { c } , \\, w _ { p } \\rangle .
$$
"""


def repair_gll_algorithm(text: str) -> str:
    start = text.find(
        "In this paper, we employ linear projections as filter functions"
    )
    end = text.find("### 4.1.1. Generation of the Mapper graph")
    if start == -1 or end == -1:
        return text

    prefix = text[:start]
    # keep centroid definition before algorithm
    centroid = """$$
x _ { c } = \\frac { 1 } { m } \\sum _ { i = 1 } ^ { m } x _ { i } .
$$

"""
    suffix = text[end:]
    # remove duplicate centroid/covariance debris from suffix start if needed
    suffix = re.sub(
        r"^\\$\\$\\s*\\n\\s*\\$\\$\\s*\\n",
        "",
        suffix,
        count=1,
        flags=re.M,
    )
    return prefix + centroid + GLL_ALGO_BLOCK + "\n" + suffix


def extract_sgl_appendices(archive_text: str) -> str:
    lines = archive_text.splitlines()
    start = None
    end = None
    for i, line in enumerate(lines):
        if line.startswith("## Appendix A:"):
            start = i
        if start is not None and line.startswith("[1] "):
            end = i
            break
    if start is None:
        return ""
    chunk = lines[start:end if end else len(lines)]

    cleaned: list[str] = []
    skip_fig29 = False
    for line in chunk:
        if line.startswith("## Appendix"):
            skip_fig29 = False
            cleaned.append(line)
            continue
        if "FIG. 29." in line:
            cleaned.append(line)
            skip_fig29 = False
            continue
        if line.strip().startswith("![") and "image 29" in line:
            cleaned.append("![FIG. 29](SGL2022/imageFile29.png)")
            skip_fig29 = True
            continue
        if skip_fig29 and line.strip() in {"-", "+", ""}:
            continue
        if re.match(r"^FIG\. \d+\.", line):
            cleaned.append(line)
            continue
        if is_figure_junk(line) or line.strip().startswith("[Page"):
            continue
        if line.strip() == "$$" and cleaned and cleaned[-1].strip() == "$$":
            continue
        cleaned.append(line)

    # fix bootstrap numbered list
    text = "\n".join(cleaned)
    text = text.replace(
        "## 1. resampling S with replacement N B times to obtain",
        "### Bootstrap procedure\n\n1. Resample $S$ with replacement $N_B$ times to obtain",
    )
    text = text.replace(
        "samples S 1 ,...,S N B each of size N ; then",
        "samples $S_1,\\ldots,S_{N_B}$, each of size $N$; then",
    )
    text = re.sub(
        r"^\$\$\s*\n2 \. \\text \{computing\}",
        "2. Compute",
        text,
        flags=re.M,
    )
    return text.strip() + "\n"


SGL_CONCLUSIONS_TAIL = """
Other statistics on persistence diagrams, such as Fréchet variance [37], might show finite-size scaling behaviour directly; however this is computationally expensive to measure.

- Finally, we note that there have been a variety of different filtrations used to compute the persistent homology of configurations of lattice spin models. It would be interesting to see how these perform and complement one another on a single data set.
"""


def repair_sgl2022(main_text: str, archive_text: str) -> str:
    # truncate at conclusions heading and rebuild
    idx = main_text.find("## IV. CONCLUSIONS AND DISCUSSION")
    if idx == -1:
        return main_text
    head = main_text[:idx]
    concl_match = re.search(
        r"(## IV\. CONCLUSIONS AND DISCUSSION\n\n.*?non-linear\. On the other hand, the non-parametric knearest neighbours approach generally produces good results, with a clear asymptotic approach towards the expected finite-size scaling behaviour in all cases\.)",
        main_text,
        re.S,
    )
    if not concl_match:
        concl_match = re.search(
            r"(## IV\. CONCLUSIONS AND DISCUSSION\n\n.*?finite-size scaling behaviour in all cases\.)",
            main_text,
            re.S,
        )
    conclusions = concl_match.group(1) if concl_match else "## IV. CONCLUSIONS AND DISCUSSION\n"
    conclusions = conclusions + SGL_CONCLUSIONS_TAIL.strip() + "\n\n"
    appendices = extract_sgl_appendices(archive_text)
    body = head + conclusions + "\n" + appendices
    return rebuild_sgl_toc(body)


def rebuild_sgl_toc(text: str) -> str:
    headings: list[tuple[int, str]] = []
    for line in text.splitlines():
        m = re.match(r"^(#{2,4})\s+(.+)$", line)
        if not m or m.group(2).strip().lower() == "contents":
            continue
        headings.append((len(m.group(1)), m.group(2).strip()))

    def slug(t: str) -> str:
        t = t.lower()
        t = re.sub(r"[^\w\s-]", "", t)
        return re.sub(r"\s+", "-", t).strip("-")

    toc = ["## Contents", ""]
    for lvl, title in headings:
        indent = "  " * (lvl - 2)
        toc.append(f"{indent}- [{title}](#{slug(title)})")
    toc.append("- [References](references/SGL2022.md)")
    toc.append("")

    # replace existing contents
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        if lines[i].strip() == "## Contents":
            i += 1
            while i < len(lines) and (
                not lines[i].startswith("## ")
                or lines[i].strip() == "## Contents"
            ):
                if lines[i].startswith("## ") and "Contents" not in lines[i]:
                    break
                i += 1
            out.extend(toc)
            continue
        out.append(lines[i])
        i += 1
    return "\n".join(out) + "\n"


def main():
    mmo_path = INTERSECTIONS / "MMO2019.md"
    mmo_path.write_text(repair_mmo_figures(mmo_path.read_text(encoding="utf-8")), encoding="utf-8")
    print("MMO2019 figures cleaned")

    gll_path = INTERSECTIONS / "GLL2026.md"
    gll_path.write_text(repair_gll_algorithm(gll_path.read_text(encoding="utf-8")), encoding="utf-8")
    print("GLL2026 algorithm repaired")

    sgl_main = INTERSECTIONS / "SGL2022.md"
    sgl_archive = ARCHIVE / "SGL2022" / "SGL2022.md"
    sgl_main.write_text(
        repair_sgl2022(
            sgl_main.read_text(encoding="utf-8"),
            sgl_archive.read_text(encoding="utf-8"),
        ),
        encoding="utf-8",
    )
    print("SGL2022 appendices restored + TOC rebuilt")


if __name__ == "__main__":
    main()
