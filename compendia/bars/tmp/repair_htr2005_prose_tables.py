"""Repair figures, prose math, and Table 2 in HTR2005.md."""
from __future__ import annotations

import re
from pathlib import Path

PATH = Path(__file__).resolve().parents[1] / "HTR2005.md"

# Caption-authoritative mapping: figure number -> best imageFile (OCR order ≠ figure number)
FIGURE_IMAGES: dict[int, str | None] = {
    1: "imageFile1.png",
    2: "imageFile3.png",
    3: "imageFile2.png",
    4: "imageFile4.png",
    5: None,
    6: None,
    7: "imageFile7.png",
    8: "imageFile8.png",
    9: None,
    10: "imageFile10.png",
    11: "imageFile11.png",
    12: "imageFile13.png",
    13: "imageFile12.png",
    14: "imageFile14.png",
    15: "imageFile15.png",
    16: "imageFile16.png",
    17: "imageFile17.png",
    18: "imageFile18.png",
}

FIGURE_CAPTIONS: dict[int, str] = {
    1: "Figure 1: [GL: low Gaussian noise] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).",
    2: "Figure 2: [GM: medium Gaussian noise] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).",
    3: "Figure 3: [GM: medium Gaussian noise] data with Bayesian regression $\\pm 1$ std. deviation.",
    4: "Figure 4: [GH: high Gaussian noise] data.",
    5: "Figure 5: [GH: high Gaussian noise] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).",
    6: "Figure 6: [GH: high Gaussian noise] data with Bayesian regression $\\pm 1$ std. deviation.",
    7: "Figure 7: Posterior segment number probability $P(k \\mid y)$ for medium Gaussian noise (GM, black), high Cauchy noise (CH, blue), medium Cauchy noise with Gaussian regression (CMwG, green), aberrant gene copy # of chromosome 1 (Gen(3,1), red), normal gene copy # of chromosome 9 (Gen(5,9), pink).",
    8: "Figure 8: [CM: medium Cauchy noise] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).",
    9: "Figure 9: [CH: high Cauchy noise] data.",
    10: "Figure 10: [CH: high Cauchy noise] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).",
    11: "Figure 11: [CH: high Cauchy noise] data with Bayesian regression $\\pm 1$ std. deviation.",
    12: "Figure 12: [CMwG: medium Cauchy noise] data (blue), but with Gaussian PCR (black), BP (red), and variance $\\pm 1$ std (green).",
    13: "Figure 13: [GM: medium Gaussian noise] $\\log P(y)$ (blue) and $\\hat{k}$ (green) as function of $\\sigma$ and our estimate $\\hat{\\sigma}$ of $(\\arg)\\max_{\\sigma} P(y)$ and $\\hat{k}(\\hat{\\sigma})$ (black triangles).",
    14: "Figure 14: [CMwG: medium Cauchy noise] with Gaussian regression, $\\log P(y)$ (blue) and $\\hat{k}$ (green) as function of $\\sigma$ and our estimate $\\hat{\\sigma}$ of $(\\arg)\\max_{\\sigma} P(y)$ and $\\hat{k}(\\hat{\\sigma})$ (black triangles).",
    15: "Figure 15: [Gen31: Aberrant gene copy # of chromosome 1] data (blue), PCR (black), BP (red), and variance $\\pm 1$ std (green).",
    16: "Figure 16: [Gen31: Aberrant gene copy # of chromosome 1] data with Bayesian regression $\\pm 1$ std.-deviation.",
    17: "Figure 17: [Gen31: Aberrant gene copy # of chromosome 1] $\\log P(y)$ (blue) and $\\hat{k}$ (green) as function of $\\sigma$ and our estimate $\\hat{\\sigma}$ of $(\\arg)\\max_{\\sigma} P(y)$ and $\\hat{k}(\\hat{\\sigma})$ (black triangles).",
    18: "Figure 18: [Gen59: normal gene copy # of chromosome 9] with Bayesian regression.",
}

TABLE_2 = """### Table 2: Regression summary

| Name | $\\sigma$ | $n$ | P | $\\hat{\\nu}$ | $\\hat{\\rho}$ | $\\hat{\\sigma}$ | $\\log E$ | $(ll-\\mathbb{E})/\\sigma_{ll}$ | $\\hat{k}$ | $C_{\\hat{k}}(\\pm 1)$ |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| GL | 0.10 | 100 | G | $-0.01$ | 0.69 | 0.18 | 39 | 4.9 | $3\\mid 3$ | 74%$(0 \\mid 20)$ |
| GM | 0.32 | 100 | G | $-0.03$ | 0.73 | 0.35 | $-48$ | 1.2 | $3\\mid 3$ | 44%$(0 \\mid 29)$ |
| GH | 1.00 | 100 | G | $-0.10$ | 1.15 | 1.03 | $-156$ | 0.3 | $3\\mid 4$ | 13%$(10 \\mid 12)$ |
| CL | 0.10 | 100 | C | $-0.02$ | 0.58 | 0.09 | $-17$ | 1.0 | $3\\mid 3$ | 69%$(0 \\mid 21)$ |
| CM | 0.32 | 100 | C | $-0.09$ | 0.70 | 0.27 | $-127$ | 0.8 | $3\\mid 3$ | 38%$(0 \\mid 27)$ |
| CH | 1.00 | 100 | C | $-0.20$ | 0.99 | 0.86 | $-234$ | 0.9 | $3\\mid 4$ | 12%$(11 \\mid 11)$ |
| GMwC | 0.32 | 100 | C | 0.00 | 0.49 | 0.17 | $-70$ | 1.5 | $3\\mid 3$ | 27%$(0 \\mid 26)$ |
| CMwG | 0.32 | 100 | G | 0.01 | 1.24 | 1.22 | $-160$ | 2.9 | $5\\mid 8$ | 8%$(8 \\mid 8)$ |
| Gen31 | — | 769 | G | 0.55 | 0.45 | 0.30 | $-283$ | $-1.5$ | $15\\mid 34$ | 6%$(6 \\mid 6)$ |
| Gen59 | — | 483 | G | 1.05 | 0.47 | 0.44 | $-336$ | $-2.3$ | $1\\mid 1$ | 8%$(0 \\mid 6)$ |
"""


def build_figure_gallery() -> str:
    blocks: list[str] = []
    for n in range(1, 19):
        cap = FIGURE_CAPTIONS[n]
        img = FIGURE_IMAGES[n]
        if img:
            blocks.append(f"![{cap}](<HTR2005/{img}>)")
        blocks.append("")
        blocks.append(cap)
        blocks.append("")
    return "\n".join(blocks).rstrip() + "\n"


def replace_figure_block(text: str) -> str:
    start = text.index("### Table 1: Regression algorithm in pseudo C code")
    end = text.index("\nThree segment Gaussian with low noise.")
    table1_end = text.index("\n", text.index("See [Hut05a] for complete pseudo-C code.", start)) + 1
    gallery = build_figure_gallery()
    return text[:table1_end] + "\n" + gallery + text[end:]


def replace_table2(text: str) -> str:
    m = re.search(r"Table 2: Regression summary\n\n.*?(?=\n\ncritical steps)", text, flags=re.DOTALL)
    if not m:
        m = re.search(r"Table 2: Regression summary\n\n.*?(?=\ncritical steps)", text, flags=re.DOTALL)
    if not m:
        raise RuntimeError("Table 2 block not found")
    return text[: m.start()] + TABLE_2 + "\n" + text[m.end() :]


def repair_prose(text: str) -> str:
    reps: list[tuple[str, str]] = [
        ("onedimensional", "one-dimensional"),
        (r"σ =0 \. 1", r"$\\sigma=0.1$"),
        (r"σ =0 \. 32", r"$\\sigma=0.32$"),
        (r"σ =1", r"$\\sigma=1$"),
        (r"σ =0\.1", r"$\\sigma=0.1$"),
        (r"σ =0\.32", r"$\\sigma=0.32$"),
        (r"low σ =0 \. 1", r"low $\\sigma=0.1$"),
        (r"medium σ =0 \. 32", r"medium $\\sigma=0.32$"),
        (r"high σ =1", r"high $\\sigma=1$"),
        (r"P \( y \| µ , t ,k \)", r"$P(y \\mid \\mu, t, k)$"),
        (r"P \( y \| σ \)", r"$P(y \\mid \\sigma)$"),
        (r"P \( k \| y \)", r"$P(k \\mid y)$"),
        (r"P \( k \| y ,σ \)", r"$P(k \\mid y, \\sigma)$"),
        (r"log P \( y \| σ \)", r"$\\log P(y \\mid \\sigma)$"),
        (r"log P \( k \| y \)", r"$\\log P(k \\mid y)$"),
        (r"log P \( y \)", r"$\\log P(y)$"),
        (r"log-evidence log P \( y \| σ \)", r"log-evidence $\\log P(y \\mid \\sigma)$"),
        (r"ˆ k", r"$\\hat{k}$"),
        (r"ˆ σ", r"$\\hat{\\sigma}$"),
        (r"ˆ µ", r"$\\hat{\\mu}$"),
        (r"ˆ t", r"$\\hat{t}$"),
        (r"ˆ ν", r"$\\hat{\\nu}$"),
        (r"ˆ ρ", r"$\\hat{\\rho}$"),
        (r"ˆ f", r"$\\hat{f}$"),
        (r"σ HML", r"$\\sigma_{\\mathrm{HML}}$"),
        (r"argmax σ", r"$\\arg\\max_{\\sigma}$"),
        (r"\( 1 ,y 1 \) ,.., \(100 ,y 100 \)", r"$(1,y_1),\\ldots,(100,y_{100})$"),
        (r"f 1 \.\.f 25 = − 1, f 26 \.\.f 50 = \+1, and f 51 \.\.f 100 = 0", r"$f_1..f_{25}=-1$, $f_{26}..f_{50}=+1$, and $f_{51}..f_{100}=0$"),
        (r"Data y t", r"Data $y_t$"),
        (r"B t := ˆ k p =1 B pt", r"$B_t := \\sum_{p=1}^{\\hat{k}} B_{pt}$"),
        (r"B t :=", r"$B_t :=$"),
        (r"B 25 = 100%\) and t 2 =50 \( B 25 =99", r"$B_{25}=100\\%$) and $t_2=50$ ($B_{25}=99"),
        (r"t 1 =25", r"$t_1=25$"),
        (r"t 2 =50", r"$t_2=50$"),
        (r"B 50 =87%\)", r"$B_{50}=87\\%$)"),
        (r"B 49 =12% and B 50 =10%", r"$B_{49}=12\\%$ and $B_{50}=10\\%$"),
        (r"ˆ µ 1 = − 0 \. 98 ≈− 1, ˆ µ 2 =0 \. 97 ≈ 1, ˆ µ 3 = 0 \. 01 ≈ 0", r"$\\hat{\\mu}_1=-0.98\\approx -1$, $\\hat{\\mu}_2=0.97\\approx 1$, $\\hat{\\mu}_3=0.01\\approx 0$"),
        (r"σ/ √ 25=2%", r"$\\sigma/\\sqrt{25}=2\\%$"),
        (r"σ/ √ 50 ≈ 1 \. 4%", r"$\\sigma/\\sqrt{50}\\approx 1.4\\%$"),
        (r"σ/ √ 25=20%", r"$\\sigma/\\sqrt{25}=20\\%$"),
        (r"σ/ √ 50 ≈ 14%", r"$\\sigma/\\sqrt{50}\\approx 14\\%$"),
        (r"ˆ µ t", r"$\\hat{\\mu}_t$"),
        (r"y 50", r"$y_{50}$"),
        (r"y 51", r"$y_{51}$"),
        (r"t =16, t =48 , 49, and t =86 , 89 , 90", r"$t=16$, $t=48,49$, and $t=86,89,90$"),
        (r"t =49", r"$t=49$"),
        (r"ˆ t 1 =25 and ˆ t 2 =51", r"$\\hat{t}_1=25$ and $\\hat{t}_2=51$"),
        (r"ˆ t 1 = 14", r"$\\hat{t}_1=14$"),
        (r"y 14:35", r"$y_{14:35}$"),
        (r"Var\[ µ ′ t \| \.\. \]", r"$\\sqrt{\\mathrm{Var}[\\mu'_t \\mid ..]}$"),
        (r"Var\[ µ ′ t \| y , ˆ k \]", r"$\\mathrm{Var}[\\mu'_t \\mid y, \\hat{k}]$"),
        (r"µ ′", r"$\\mu'$"),
        (r"µ q = σ", r"$\\mu_q=\\sigma$"),
        (r"µ =\( µ 1 ,\.\.\.,µ k \)", r"$\\mu=(\\mu_1,\\ldots,\\mu_k)$"),
        (r"t =\( t 0 ,\.\.\.,t k \)", r"$t=(t_0,\\ldots,t_k)$"),
        (r"0= t 0 <t 1 <\.\.\.<t k − 1 <t k = n", r"$0=t_0<t_1<\\cdots<t_{k-1}<t_k=n$"),
        (r"f = \( f 1 ,\.\.\.,f n \)", r"$f=(f_1,\\ldots,f_n)$"),
        (r"P \( µ , t ,k \)", r"$P(\\mu, t, k)$"),
        (r"ρ 2", r"$\\rho^2$"),
        (r"σ 2", r"$\\sigma^2$"),
        (r"O \( k max n 2 \)", r"$O(k_{\\max} n^2)$"),
        (r"O \( n 2 \)", r"$O(n^2)$"),
        (r"O \( k max n \)", r"$O(k_{\\max} n)$"),
        (r"k 0 ≪ n", r"$k_0 \\ll n$"),
        (r"P \( k<k 0 \| y \)", r"$P(k<k_0 \\mid y)$"),
        (r"P \( k ≥ k 0 \| y \)", r"$P(k \\geq k_0 \\mid y)$"),
        (r"P \( k 0 \| y \)", r"$P(k_0 \\mid y)$"),
        (r"1 2 log n", r"$\\tfrac{1}{2}\\log n$"),
        (r"log E \(GM\)", r"$\\log E(\\mathrm{GM})$"),
        (r"log E \(GMwC\)", r"$\\log E(\\mathrm{GMwC})$"),
        (r"e 48 − 70 < 10 − 9", r"$e^{48-70}<10^{-9}$"),
        (r"e 127 − 160 < 10 − 14", r"$e^{127-160}<10^{-14}$"),
        (r"C ˆ k \( C ˆ k − 1 ,C ˆ k \+1 \)", r"$C_{\\hat{k}}(C_{\\hat{k}-1},C_{\\hat{k}+1})$"),
        (r"t = 89 \.\. 408", r"$t=89..408$"),
        (r"t = 87 and 641", r"$t=87$ and $641$"),
        (r"t =535 \.\. 565", r"$t=535..565$"),
        (r"t =510 \.\. 599", r"$t=510..599$"),
        (r"Fig\. 2 and 3", r"Fig. 2 and 4"),
        (r"Figure 3 is still essentially", r"Figure 4 is still essentially"),
        (r"regression curve in Figure 3 is", r"regression curve in Figure 4 is"),
        (r"For high Cauchy noise \( σ =1, Figure 9\)", r"For high Cauchy noise ($\\sigma=1$, Figure 10)"),
        (r"recovers three segments \(Figure 10\)", r"recovers three segments (Figure 10)"),
        (r"Bayesian regression in Figure 11 identifies", r"The Bayesian regression in Figure 12 identifies"),
        (r"Figure 13 we study", r"Figure 14 we study"),
        (r"in Figure 2\. In Figure 13", r"in Figure 2. In Figure 14"),
        (r"Posterior probability of the number of segments P \( k \| y \) \. One of the most\n\n", ""),
        (r"\(levels\) at all\. Amazingly", r"(levels) at all. Amazingly"),
        (r"it own segment", r"its own segment"),
        (r"4 th segment", r"4th segment"),
        (r"ﬁxing", "fixing"),
    ]
    for old, new in reps:
        text = re.sub(old, new, text)
    # rejoin Var paragraph break
    text = text.replace(
        "as can better be seen in the (kink of the) green\n\n$\\sqrt{\\mathrm{Var}[\\mu'_t \\mid ..]}$ curve",
        "as can better be seen in the (kink of the) green $\\sqrt{\\mathrm{Var}[\\mu'_t \\mid ..]}$ curve",
    )
    text = text.replace(
        "it is nearly impossible to see any segment\n\n(levels) at all.",
        "it is nearly impossible to see any segment (levels) at all.",
    )
    return text


def main() -> None:
    text = PATH.read_text(encoding="utf-8")
    text = replace_figure_block(text)
    text = replace_table2(text)
    text = repair_prose(text)
    PATH.write_text(text, encoding="utf-8")
    print("wrote", PATH)


if __name__ == "__main__":
    main()
