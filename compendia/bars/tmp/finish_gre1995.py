#!/usr/bin/env python3
"""Finish renderability repair for GRE1995.md only."""

from __future__ import annotations

import re
from pathlib import Path

DOC = Path(__file__).resolve().parents[1] / "GRE1995.md"


def compact_latex(s: str) -> str:
    s = s.strip()
    s = re.sub(r"\\\s+([a-zA-Z]+)", r"\\\1", s)
    s = re.sub(r"_\s*\{\s*", r"_{", s)
    s = re.sub(r"\^\s*\{\s*", r"^{", s)
    s = re.sub(r"\{\s+", "{", s)
    s = re.sub(r"\s+\}", "}", s)
    s = re.sub(r"\s*\|\s*", r" \\mid ", s)
    s = re.sub(r"\s+", " ", s)
    s = re.sub(r"\s*([=+\-*/,:;])\s*", r"\1", s)
    s = re.sub(r"([=+\-*/,:;])(?=[A-Za-z\\])", r"\1 ", s)
    return s.strip()


def compact_display_blocks(text: str) -> str:
    out: list[str] = []
    in_math = False
    buf: list[str] = []
    for line in text.splitlines():
        if line.strip() == "$$":
            if in_math:
                body = "\n".join(compact_latex(ln) for ln in buf if ln.strip())
                out.append("$$")
                if body:
                    out.append(body)
                out.append("$$")
                buf = []
                in_math = False
            else:
                in_math = True
            continue
        if in_math:
            buf.append(line)
        else:
            out.append(line)
    if in_math and buf:
        out.append("$$")
        out.extend(compact_latex(ln) for ln in buf if ln.strip())
        out.append("$$")
    return "\n".join(out) + "\n"


def fix_section_refs(text: str) -> str:
    # Only "$ 3" OCR section marks (space after $), not math like $50$
    text = re.sub(r"\$\s+(\d+(?:\.\d+)?(?:-\d+)?)\b", r"§\1", text)
    text = re.sub(r"\b8\s+(\d+(?:\.\d+)?)\b", r"§\1", text)
    text = re.sub(r"§(\d+)-(\d+)", r"§\1.\2", text)
    text = re.sub(r"§(\d+)\s+(\d+)", r"§\1.\2", text)
    return text


REPLACEMENTS: list[tuple[str, str]] = [
    (
        "a target distribution of interest. In Bayesian inference, this is the posterior distribution for the parameters given the data, and in the present context of model determination; 'parameters' include the indicator k for the model itself, as well as tation; we construct a Markov transition kernel P(x,dx' ) that is aperiodic and irreducible; and satisfies detailed balance:",
        "Let $\\pi(dx)$ denote a target distribution of interest. In Bayesian inference, this is the posterior distribution for the parameters given the data, and in the present context of model determination, 'parameters' include the indicator $k$ for the model itself, as well as the parameter vector $\\theta^{(k)}$ specific to that model. In Markov chain Monte Carlo computation, we construct a Markov transition kernel $P(x,dx')$ that is aperiodic and irreducible, and satisfies detailed balance:",
    ),
    (
        "$$\n= \\int _ { B } \\int _ { A } \\pi ( d x ^ { \\prime } ) P ( x ^ { \\prime } , d x ) ,\n$$",
        "$$\n\\int_A \\pi(dx)\\, P(x,B) = \\int_B \\pi(dx')\\, P(x',A). \\tag{1}\n$$",
    ),
    (
        "Then; with probability sampler and\n\n$$\n\\min \\left \\{ 1 , \\frac { \\pi ( x _ { T } | x _ { - T } ) q _ { T } ( x _ { T } , x ) } { \\pi ( x _ { T } | x _ { - T } ) q _ { T } ( x _ { T } ^ { \\prime } ; x ) } \\right \\}\n$$",
        "Then, with probability\n\n$$\n\\min\\left\\{1,\\, \\frac{\\pi(x'_T \\mid x_{-T})\\, q_T(x'_T, x)}{\\pi(x_T \\mid x_{-T})\\, q_T(x_T, x)}\\right\\}\n$$",
    ),
    (
        "As usual probability of acceptance will be denoted by am(x, x' ), and is left undefined at present; the objective of the following analysis is to derive an expression for %m(x, x') which achieves the stated aim of attaining detailed balance within each move type.",
        "As usual with Hastings algorithms, the proposal is not automatically accepted. The probability of acceptance will be denoted by $\\alpha_m(x,x')$, and is left undefined at present; the objective of the following analysis is to derive an expression for $\\alpha_m(x,x')$ which achieves the stated aim of attaining detailed balance within each move type.",
    ),
    (
        "$$\n\\int _ { A } \\pi ( d x ) \\left | _ { B } q _ { m } ( x , d x ^ { \\prime } ) \\alpha _ { m } ( x , x ^ { \\prime } ) = \\left | _ { B } \\pi ( d x ^ { \\prime } ) \\right | _ { A } q _ { m } ( x ^ { \\prime } , d x ) \\alpha _ { m } ( x ^ { \\prime } , x )\n$$",
        "$$\n\\int_A \\pi(dx) \\int_B q_m(x,dx')\\, \\alpha_m(x,x') = \\int_B \\pi(dx') \\int_A q_m(x',dx)\\, \\alpha_m(x',x). \\tag{4}\n$$",
    ),
    (
        "$$\n\\int _ { A } \\pi ( d x ) \\int _ { B } q _ { m } ( x , d x ^ { \\prime } ) \\alpha _ { m } ( x , x ^ { \\prime } ) & = \\int _ { A } \\int _ { B } \\xi _ { m } ( d x , d x ^ { \\prime } ) \\\\ & = \\int _ { B } \\int _ { A } \\xi _ { m } ( d x ^ { \\prime } , d x ) \\\\ & = \\int _ { B } \\pi ( d x ^ { \\prime } ) \\int _ { A } q _ { m } ( x )\n$$",
        "$$\n\\begin{aligned}\n\\int_A \\pi(dx) \\int_B q_m(x,dx')\\, \\alpha_m(x,x') &= \\int_A \\int_B \\xi_m(dx,dx') \\\\\n&= \\int_B \\int_A \\xi_m(dx',dx) \\\\\n&= \\int_B \\pi(dx') \\int_A q_m(x',dx)\\, \\alpha_m(x',x)\n\\end{aligned}\n$$",
    ),
    (
        "for each m, A, B, and to achieve this we choose %m(x, x) as follows.",
        "for each $m$, $A$, $B$, and to achieve this we choose $\\alpha_m(x,x')$ as follows.",
    ),
    (
        "Suppose that we have a countable collection of candidate models { Alk, k € % }. Model Ak has a vector 0(k) of unknown parameters; assumed to lie in 9\" , where the dimension nk may vary from model to model.  With obvious changes; our methods would apply to an arbitrary collection of parameter subspaces:  We observe data y There is a natural hierarchical structure expressed by modelling the joint distribution of (k, 0(), y) as",
        "Suppose that we have a countable collection of candidate models $\\{M_k, k \\in \\mathcal{K}\\}$. Model $M_k$ has a vector $\\theta^{(k)}$ of unknown parameters, assumed to lie in $\\Theta_k$, where the dimension $n_k$ may vary from model to model. With obvious changes, our methods would apply to an arbitrary collection of parameter subspaces. We observe data $y$. There is a natural hierarchical structure expressed by modelling the joint distribution of $(k, \\theta^{(k)}, y)$ as",
    ),
    (
        "$$\np ( k , \\theta ^ { ( k ) } , y ) = p ( k ) p ( \\theta ^ { ( k ) } | k ) p ( y | k , \\theta ^ { ( k ) } ) ,\n$$",
        "$$\np(k, \\theta^{(k)}, y) = p(k)\\, p(\\theta^{(k)} \\mid k)\\, p(y \\mid k, \\theta^{(k)}).\n$$",
    ),
    (
        "Thus 0() is a vector of length nx = 2k + 1.",
        "Thus $\\theta^{(k)}$ is a vector of length $n_k = 2k + 1$.",
    ),
    (
        "Bayesian inference about k and will be based on the joint posterior 0(k)|y), which is the target of the Markov chain Monte Carlo computations described below. It will often be appropriate to factorise this as 0(k) p(k,",
        "Bayesian inference about $k$ and $\\theta^{(k)}$ will be based on the joint posterior $p(k, \\theta^{(k)} \\mid y)$, which is the target of the Markov chain Monte Carlo computations described below. It will often be appropriate to factorise this as $p(\\theta^{(k)} \\mid k, y)\\, p(k \\mid y)$, with",
    ),
    (
        "$$\n\\min \\left \\{ 1 , ( \\text {likelihood ratio} ) \\times \\frac { ( s _ { j + 1 } - s _ { j } ) ( s _ { j } - s _ { j - 1 } ) } { ( s _ { j + 1 } - s _ { j } ) ( s _ { j } - s _ { j - 1 } ) } \\right \\} .\n$$",
        "$$\n\\min\\left\\{1,\\, (\\text{likelihood ratio}) \\times \\frac{(s_{j+1}-s'_j)(s'_j-s_{j-1})}{(s_{j+1}-s_j)(s_j-s_{j-1})}\\right\\}.\n$$",
    ),
    (
        "We first choose a position $* for the proposed new step, uniformly distributed on [0L]",
        "We first choose a position $s^*$ for the proposed new step, uniformly distributed on $[0,L]$",
    ),
    (
        "and the Jacobian is which is not a step function: Figure 2 shows the posterior distribution of k, the number of steps:",
        "and the Jacobian is $1/(u\\, h'_j\\, h'_{j+1})$.\n\nFigure 2 shows the posterior distribution of $k$, the number of steps:",
    ),
    (
        "The birth and death acceptance probabilities are respectively $\\min(1, R)$ and $\\min(1, R^{-1})$, where\n\n$$\nR = \\frac{B\\{q\\alpha_j,\\, q(1-\\alpha_j)\\}^{\\#S_j}}\n",
        "The birth and death acceptance probabilities are respectively $\\min(1, R)$ and $\\min(1, R^{-1})$, where\n\n$$\nR = \\frac{B\\{q\\alpha_j,\\, q(1-\\alpha_j)\\}^{\\#S_j}}\n",
    ),
    (
        "In the general notation of $ 2, the model indicator k is g, while the   parameter vector 0(k) is 9 01, 0n), of dimension ng = n + d(g) + 1. d(g)",
        "In the general notation of §2, the model indicator $k$ is $g$, while the parameter vector $\\theta^{(k)}$ is $(\\theta_1, \\ldots, \\theta_n)$, of dimension $n_g = n + d(g) + 1$.",
    ),
    (
        "Jumping to a new partition necessitates a change also to the vector a, since its length has to increase or decrease by 1. Our proposal for the additional component is Gaussian on a logit scale; and takes account of the numbers of binary responses influenced by each of the relevant %j. Specifically, suppose that a proposed birth Sj into subgroups Sj1 and $j2 Let aj be the current value, and aj1, %j2 the new values for the two subgroups. Then we set splits",
        "Jumping to a new partition necessitates a change also to the vector $\\alpha$, since its length has to increase or decrease by 1. Our proposal for the additional component is Gaussian on a logit scale, and takes account of the numbers of binary responses influenced by each of the relevant $\\alpha_j$. Specifically, suppose that a proposed birth splits $S_j$ into subgroups $S_{j1}$ and $S_{j2}$. Let $\\alpha_j$ be the current value, and $\\alpha_{j1}$, $\\alpha_{j2}$ the new values for the two subgroups. Then we set",
    ),
    (
        "In particular, in $ 3 we introduce à novel class",
        "In particular, in §3 we introduce a novel class",
    ),
    (
        "- Remark 2 The method allows great flexibility to the algorithm designer to the structure of the problem at hand. Intuition can be used to choose moves that plausibly induce a heavy burden of algebraic and analytic work to establish validity. exploit good",
        "- Remark 2. The method allows great flexibility to the algorithm designer to exploit the structure of the problem at hand. Intuition can be used to choose moves that plausibly induce good mixing behaviour, while not imposing a heavy burden of algebraic and analytic work to establish validity.",
    ),
    (
        "Remark 3. Although as usual with Hastings methods, the distribution T need not be normalised, relative   normalising constants between different   subspaces are needed. Specifically, while it is not necessary that the distributions Ik) are properly normalised, there must be only one unknown multiplicative constant among all such priors; unless only posteriors conditional on k are needed. Detailed balance  between different   subspaces   could not be   achieved   otherwise, apparently missed   by Grenander & Miller (1994).",
        "Remark 3. Although as usual with Hastings methods, the distribution $\\pi$ need not be normalised, relative normalising constants between different subspaces are needed. Specifically, while it is not necessary that the prior distributions $p(\\theta^{(k)} \\mid k)$ are properly normalised, there must be only one unknown multiplicative constant among all such priors, unless only posteriors conditional on $k$ are needed. Detailed balance between different subspaces could not be achieved otherwise, a point apparently missed by Grenander & Miller (1994).",
    ),
]


def apply_replacements(text: str) -> str:
    for old, new in REPLACEMENTS:
        if old not in text:
            continue
        text = text.replace(old, new)
    return text


def fix_inline_prose(text: str) -> str:
    subs = [
        (r"\b0\(k\)", r"$\\theta^{(k)}$"),
        (r"\b0\(\)", r"$\\theta^{(k)}$"),
        (r"\bp\(k\|y\)", r"$p(k \\mid y)$"),
        (r"\bp\(k,y\)", r"$p(k \\mid y)$"),
        (r"\bam\(", r"$\\alpha_m("),
        (r"\bqm\(", r"$q_m("),
        (r"\bπ\(", r"$\\pi("),
    ]
    for pat, repl in subs:
        text = re.sub(pat, repl, text)
    return text


def main() -> None:
    text = DOC.read_text(encoding="utf-8")
    text = apply_replacements(text)
    text = fix_section_refs(text)
    text = compact_display_blocks(text)
    text = fix_inline_prose(text)
    while "\n\n\n" in text:
        text = text.replace("\n\n\n", "\n\n")
    DOC.write_text(text.rstrip() + "\n", encoding="utf-8")
    print("OK", DOC)


if __name__ == "__main__":
    main()
