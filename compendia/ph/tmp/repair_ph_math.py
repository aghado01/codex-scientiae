#!/usr/bin/env python3
"""Math hygiene + OCR repair for ph compendium main docs."""

from __future__ import annotations

import re
from pathlib import Path

PH = Path(__file__).resolve().parents[1]

DOCS = sorted(
    p.stem
    for p in PH.glob("*.md")
    if p.name != "_CONTENTS.md" and not p.name.startswith("_")
)

GARBAGE_MATH_LINE = re.compile(
    r"(?:\\text\s*\{\s*(?:ator\.|affix|F i x)|"
    r"C o n s i d o n|t h o f l o w i n g|t h o w o l o n|"
    r"the closest point in the subset|Let\s+A\s*_\s*\{\s*j\s*\}\s*=\s*1\s+\\text)",
    re.I,
)

UNICODE_TO_LATEX = {
    "∈": r"\in",
    "≤": r"\leq",
    "≥": r"\geq",
    "×": r"\times",
    "·": r"\cdot",
    "→": r"\to",
    "←": r"\leftarrow",
    "↦": r"\mapsto",
    "∞": r"\infty",
    "±": r"\pm",
    "≠": r"\neq",
    "≈": r"\approx",
    "⊂": r"\subset",
    "⊆": r"\subseteq",
    "⊃": r"\supset",
    "⊇": r"\supseteq",
    "⊗": r"\otimes",
    "⊕": r"\oplus",
    "∧": r"\wedge",
    "∨": r"\vee",
    "∀": r"\forall",
    "∃": r"\exists",
    "∑": r"\sum",
    "∏": r"\prod",
    "∫": r"\int",
    "∂": r"\partial",
    "∇": r"\nabla",
    "µ": r"\mu",
    "ν": r"\nu",
    "σ": r"\sigma",
    "ρ": r"\rho",
    "λ": r"\lambda",
    "β": r"\beta",
    "α": r"\alpha",
    "γ": r"\gamma",
    "δ": r"\delta",
    "ε": r"\varepsilon",
    "ζ": r"\zeta",
    "η": r"\eta",
    "θ": r"\theta",
    "κ": r"\kappa",
    "μ": r"\mu",
    "ξ": r"\xi",
    "π": r"\pi",
    "φ": r"\varphi",
    "χ": r"\chi",
    "ψ": r"\psi",
    "ω": r"\omega",
    "Γ": r"\Gamma",
    "Δ": r"\Delta",
    "Λ": r"\Lambda",
    "Σ": r"\Sigma",
    "Φ": r"\Phi",
    "Ω": r"\Omega",
    "∆": r"\Delta",
}

DOC_PATCHES: dict[str, list[tuple[str, str]]] = {
    "BCKL2010": [
        (
            r"\$\$\s*\n\s*\\text \{ator\.\}.*?\n\s*\$\$",
            "$$\nm = \\left\\lfloor C_1 \\left( \\frac{L(2\\beta + d)}{\\delta C_0 d \\psi_n} \\right)^{d/\\beta} \\right\\rfloor\n$$",
        ),
        (
            r"\$\$\s*\n\s*& \\quad \\text \{the closest point.*?\n\s*\$\$",
            "$$\nA_j = \\left\\{ x \\in \\mathbb{M} \\mid \\rho(x_{i_j}, x) = \\min_{k=1,\\ldots,m} \\rho(x_{i_k}, x) \\right\\}. \\tag{3.10}\n$$",
        ),
        (
            r"\$\$\s*\n\\cdots.*?C o n s i d o n.*?\n\s*\$\$",
            "$$\n\\cdots \\xrightarrow{\\partial} C_{k+1} \\xrightarrow{\\partial} C_k \\xrightarrow{\\partial} C_{k-1} \\cdots \\xrightarrow{\\partial} C_1 \\xrightarrow{\\partial} C_0\n$$",
        ),
    ],
}

PROSE_SKIP_RE = re.compile(
    r"^(#{1,6}\s|!\[|\s*- \[|```|\[Page |\*\*[^*]+\*\*\s*$)"
)
LATEX_PROSE_RE = re.compile(
    r"\\(?:left|right|frac|sum|min|max|mathbb|mathrm|mathbf|mathcal|hat|tilde|"
    r"psi|rho|beta|delta|infty|to|cdot|tag|coloneqq|begin|end|intertext)"
)


def compact_math_braces(body: str) -> str:
    body = re.sub(r"\{\s+", "{", body)
    body = re.sub(r"\s+\}", "}", body)
    body = re.sub(r"_\s*\{", "_{", body)
    body = re.sub(r"\^\s*\{", "^{", body)
    body = re.sub(r"_\s+([A-Za-z0-9])", r"_\1", body)
    body = re.sub(r"\^\s+([A-Za-z0-9])", r"^\1", body)
    body = re.sub(r"\\\s+lim\s+\\sup", r"\\limsup", body)
    body = re.sub(r"\\\s+lim\s+\\inf", r"\\liminf", body)
    body = re.sub(r"\\\s+mathbb\s*\{", r"\\mathbb{", body)
    body = re.sub(r"\\\s+mathrm\s*\{", r"\\mathrm{", body)
    body = re.sub(r"\\\s+mathbf\s*\{", r"\\mathbf{", body)
    body = re.sub(r"\\\s+mathcal\s*\{", r"\\mathcal{", body)
    body = re.sub(r"\\\s+hat\s*\{", r"\\hat{", body)
    body = re.sub(r"\\\s+tilde\s*\{", r"\\tilde{", body)
    body = re.sub(r"\\\s+sum\s*", r"\\sum ", body)
    body = re.sub(r"\\\s+min\s*", r"\\min ", body)
    body = re.sub(r"\\\s+max\s*", r"\\max ", body)
    body = re.sub(r"\\\s+to\s*", r"\\to ", body)
    body = re.sub(r"\\\s+cdot\s*", r"\\cdot ", body)
    body = re.sub(r"\\\s+left\s*\(", r"\\left(", body)
    body = re.sub(r"\\\s+right\s*\)", r"\\right)", body)
    body = re.sub(r"\\\s+left\s*\[", r"\\left[", body)
    body = re.sub(r"\\\s+right\s*\]", r"\\right]", body)
    body = re.sub(r"\\\s+left\s*\\", r"\\left\\", body)
    body = re.sub(r"\\\s+right\s*\\", r"\\right\\", body)
    body = re.sub(r"\(\s+(\d+(?:\s*\.\s*\d+)*)\s+\)", _tag_repl, body)
    body = re.sub(r"(?<![\\])coloneqq", r"\\coloneqq", body)
    body = re.sub(r"\\L\s+l", r"\\ell", body)
    body = re.sub(r"F\*\{", r"F_{", body)
    body = re.sub(r"\[x\]\*\{", r"[x]_{", body)
    body = re.sub(r"\]\*\{", r"]_{", body)
    body = re.sub(r"\\\s+coloneqq", r"\\coloneqq", body)
    return body


def _tag_repl(m: re.Match[str]) -> str:
    num = re.sub(r"\s+", "", m.group(1))
    return rf"\\tag{{{num}}}"


def strip_spurious_dollars(body: str) -> str:
    while True:
        new = re.sub(r"\$([^$]+)\$", r"\1", body)
        if new == body:
            break
        body = new
    return body


def fix_math_ocr_artifacts(body: str) -> str:
    """Repair OCR star-subscripts and spurious $ inside math blocks."""
    body = re.sub(r"(?<![A-Za-z\\])\*(?=\{|\[)", "_", body)
    body = re.sub(r"\\_(\{)", r"_\1", body)
    body = re.sub(r"\$B _\{", r"B_{", body)
    body = re.sub(r"\$B_([a-z0-9]+)\$", r"B_\1", body)
    body = re.sub(r"\$\s*\\mathrm\{cl\}\s*\$", r"\\mathrm{cl}", body)
    body = re.sub(r"\\text\{Sol\}\\_", r"\\text{Sol}_", body)
    body = re.sub(r"\\bigcap\*(?=\{)", r"\\bigcap_", body)
    body = re.sub(r"\\bigcup\*(?=\{)", r"\\bigcup_", body)
    body = re.sub(r"iSol\*(?=\{)", r"iSol_", body)
    body = re.sub(r"\\rho\^\{\\sqsubset\}\s*\\in\s+B\*s", r"\\rho^{\\sqsubset} \\in B_s", body)
    body = re.sub(r"\\rho\^\{\\sqsupset\}\s*\\in\s+\$B_e\$", r"\\rho^{\\sqsupset} \\in B_e", body)
    return body


def clean_math_block(body: str) -> str:
    lines: list[str] = []
    for raw in body.splitlines():
        ln = raw.strip()
        if not ln:
            continue
        if GARBAGE_MATH_LINE.search(ln):
            continue
        if re.match(r"^\\sim\s*$", ln):
            continue
        lines.append(ln)

    if not lines:
        return ""

    body = "\n".join(lines)
    body = strip_spurious_dollars(body)
    body = fix_math_ocr_artifacts(body)
    body = compact_math_braces(body)
    return body.strip()


def latexify_span(text: str) -> str:
    out = text
    for ch, cmd in UNICODE_TO_LATEX.items():
        out = out.replace(ch, cmd + " ")
    out = re.sub(r"\s+", " ", out).strip()
    out = re.sub(r"_\s*\{\s*([^}]+?)\s*\}", r"_{\1}", out)
    out = re.sub(r"\^\s*\{\s*([^}]+?)\s*\}", r"^{\1}", out)
    out = re.sub(r"\s*_\s*([A-Za-z0-9]+)", r"_\1", out)
    out = re.sub(r"\s*\^\s*([A-Za-z0-9+\-]+)", r"^\1", out)
    return out


def enrich_prose_segment(seg: str) -> str:
    if not seg.strip():
        return seg

    def wrap_match(m: re.Match[str]) -> str:
        inner = m.group(0)
        if re.fullmatch(r"[A-Za-z]+", inner) and inner.lower() in {
            "a", "i", "x", "y", "p", "q", "n", "m", "k", "j", "f", "g", "h",
        }:
            return inner
        return f"${latexify_span(inner)}$"

    seg = re.sub(
        r"(?<![\\\$A-Za-z])([A-Za-z](?:\s*[_^]\s*(?:\{[^}]+\}|[A-Za-z0-9+\-]+))+)",
        wrap_match,
        seg,
    )
    seg = re.sub(
        r"(?<![\$A-Za-z])([µνσρλβαγδεζηθικξπφχψωΓΔΛΣΦΩ∂∇]"
        r"(?:\s*[_^]\s*(?:\{[^}]+\}|[A-Za-z0-9]+))*)",
        wrap_match,
        seg,
    )
    for ch, cmd in UNICODE_TO_LATEX.items():
        if ch in "∈≤≥×·→←⊂⊆⊃⊇⊗⊕∧∨":
            seg = re.sub(
                rf"(?<!\$)\s*{re.escape(ch)}\s*(?!\$)",
                lambda _m, c=cmd: f" ${c}$ ",
                seg,
            )
    seg = re.sub(r"\$\s+\$", " ", seg)
    seg = re.sub(r"\$([^$]+)\$\s*\$([^$]+)\$", r"$\1 \2$", seg)
    seg = re.sub(r"\s{2,}", " ", seg)
    return seg


def wrap_spaced_latex_tokens(line: str) -> str:
    """Wrap OCR tokens separated by double spaces that contain LaTeX."""
    parts = re.split(r"(  +)", line)
    out: list[str] = []
    for part in parts:
        if re.fullmatch(r"  +", part):
            out.append(" ")
            continue
        tok = part.strip()
        if not tok:
            continue
        if "$" in tok:
            out.append(tok)
        elif re.search(r"\\[a-zA-Z]|[_\^{}]|\\multimap|\\coloneqq", tok):
            out.append(f"${tok}$")
        elif re.fullmatch(r"[A-Za-z]", tok):
            out.append(f"${tok}$")
        else:
            out.append(tok)
    return " ".join(out)


def enrich_prose_line(line: str) -> str:
    if PROSE_SKIP_RE.match(line.strip()):
        return line
    if line.strip().startswith("|"):
        return line
    if "  " in line and "\\" in line:
        return wrap_spaced_latex_tokens(line).rstrip()
    if "\\" in line:
        return line.rstrip()

    parts = re.split(r"(\$[^$]+\$)", line)
    out: list[str] = []
    for part in parts:
        if part.startswith("$") and part.endswith("$"):
            out.append(part)
        else:
            out.append(enrich_prose_segment(part))
    return "".join(out)


def split_math_segments(text: str) -> list[tuple[str, str]]:
    segments: list[tuple[str, str]] = []
    i = 0
    while i < len(text):
        start = text.find("$$", i)
        if start == -1:
            segments.append(("prose", text[i:]))
            break
        if start > i:
            segments.append(("prose", text[i:start]))
        end = text.find("$$", start + 2)
        if end == -1:
            segments.append(("math", text[start + 2 :]))
            break
        segments.append(("math", text[start + 2 : end]))
        i = end + 2
    return segments


def restore_inline_latex(line: str) -> str:
    """Re-wrap bare LaTeX fragments that lost $ delimiters."""
    if PROSE_SKIP_RE.match(line.strip()):
        return line
    if "$$" in line:
        return line
    if not re.search(r"\\[a-zA-Z]|_[{\[]", line):
        return line
    if "$" in line:
        return line
    line = re.sub(
        r"(?<!\$)(\\(?:mathcal|mathbb|mathrm|mathbf|hat|psi|rho|beta|delta|infty|coloneqq|min|max|sum)\{[^}]+\})(?!\$)",
        r"$\1$",
        line,
    )
    line = re.sub(
        r"(?<!\$)([A-Za-z](?:_\{[^}]+\}|\^\{[^}]+\})+)(?!\$)",
        r"$\1$",
        line,
    )
    return line


def repair_bckl2010_sections(text: str) -> str:
    """Holistically rebuild shattered §3.2–§4.1 blocks."""
    block = r"""We have the following result whose proof will be detailed in Section 6.1

**Lemma 3.1.** Let $z_i \in M$, $i = 1, \ldots, m$, be asymptotically equidistant. Let $\lambda = \lambda(m)$ be the largest number such that $\bigcup_{i=1}^{m} B_{z_i}(\lambda^{-1}) = M$, where $B_{z_i}(\lambda^{-1})$ is the closure of the geodesic ball of radius $\lambda^{-1}$ around $z_i$. Then there is a $C_1 > 0$ such that $\limsup_{m \to \infty} m\lambda(m)^{-d} \leq C_1$.

**3.2. An estimator.** Fix a $\delta > 0$ and let

$$
m = \left\lfloor C_1 \left( \frac{L(2\beta + d)}{\delta C_0 d \psi_n} \right)^{d/\beta} \right\rfloor
$$

where $C_1$ is a sufficiently large constant from Lemma 3.1, hence $m \leq n$ and $m \to \infty$ when $n \to \infty$ and for $s \in \mathbb{R}$, $[s]$ denotes the greatest integer part.

For the design points $\{x_i : i = 1, \ldots, n\}$ on $M$, assume that $x_{i_j} \in M$, $j = 1, \ldots, m$ is an asymptotically equidistant subset on $M$. Let $A_j$, $j = 1, \ldots, m$, be a partition of $M$ such that $A_j$ is the set of those $x \in M$ for which $x_{i_j}$ is the closest point in the subset $\{x_{i_1}, \ldots, x_{i_m}\}$. Thus, for $j = 1, \ldots, m$,

$$
A_j = \left\{ x \in \mathbb{M} \mid \rho(x_{i_j}, x) = \min_{k=1,\ldots,m} \rho(x_{i_k}, x) \right\}. \tag{3.10}
$$

Let $A_j$, $j = 1, \ldots, m$ be as in (3.10) and define $1_{A_j}(x)$ to be the indicator function on the set $A_j$ and consider the estimator

$$
\hat{f}(x) = \sum_{j=1}^{m} \hat{a}_j 1_{A_j}(x),
$$

where for $L > 0$, $0 < \beta \leq 1$,

$$
\hat{a}_j = \frac{\sum_{i=1}^{n} K_{\kappa, x_{i_j}}(x_i) y_i}{\sum_{i=1}^{n} K_{\kappa, x_{i_j}}(x_i)}, \quad K_{\kappa, x_{i_j}}(\omega) = \left(1-(\kappa\rho(x_{i_j},\omega))^\beta\right)_+, \quad \kappa = \left(\frac{C_0 \varphi_n}{L}\right)^{-1/\beta}
$$

and $s_+ = \max(s,0)$ for $s \in \mathbb{R}$. We remark that when $m$ is sufficiently large hence $\kappa$ is also large, the support set of $K_{\kappa, x_{i_j}}(\omega)$ is the closed geodesic ball $B_{x_{i_j}}(\kappa^{-1})$ around $x_{i_j}$ for $j = 1, \ldots, m$.

## 4. Main Results"""
    text = re.sub(
        r"We have the following result whose proof will be detailed in Section 6\.1.*?## 4\. Main Results",
        lambda _m: block,
        text,
        count=1,
        flags=re.DOTALL,
    )
    text = re.sub(
        r"\$\$\s*\n\s*\$B _\{z\}\$.*?\n\$\$\s*\nWe have the following",
        lambda _m: "Define the geodesic ball of radius $r > 0$ centered at $z \\in M$ by\n\n$$\nB_z(r) = \\{ x \\in \\mathbb{M} \\mid \\rho(x,z) \\leq r \\}.\n$$\n\nWe have the following",
        text,
        count=1,
        flags=re.DOTALL,
    )
    repl_41 = """Theorem 4.1. For the regression model (3.1) and the estimator (3.11), we have

$$
\\sup_{f \\in \\Lambda(\\beta,L)} \\mathbb{E} w\\left(\\psi_n^{-1}\\left\\|\\hat{f}-f\\right\\|_\\infty\\right) \\leq w(C_0), \\quad \\text{where } \\psi_n = (n^{-1}\\log n)^{\\beta/(2\\beta+d)}.
$$

as $n \\to \\infty$"""
    text = re.sub(
        r"Theorem 4\.1\. For the regression model \(3\.1\) and the estimator \(3\.11\), we have\s*\$\$\s*\n\\sup _.*?\\text \{ve the asymptotic minimum.*?\n\$\$\s*\nas n → 0",
        lambda _m: repl_41,
        text,
        count=1,
        flags=re.DOTALL,
    )
    text = re.sub(
        r"\$\$\s*\n\\lim _ \{ n \\to \\infty \} \$r _\{n\}\$.*?\n\$\$",
        lambda _m: "$$\n\\lim_{n \\to \\infty} r_n(w, \\beta, L) = w(C_0).\n$$",
        text,
        count=1,
        flags=re.DOTALL,
    )
    return text


def repair_bckl_fragmented_blocks(text: str) -> str:
    """Fix $$/prose interleaving from prior bad pass."""
    fixes = [
        (
            r"\$\$\s*\nwhere C 1 is sufficiently.*?\n\$\$\s*\nA_j =",
            "$$\nm = \\left\\lfloor C_1 \\left( \\frac{L(2\\beta + d)}{\\delta C_0 d \\psi_n} \\right)^{d/\\beta} \\right\\rfloor\n$$\n\nwhere $C_1$ is a sufficiently large constant from Lemma 3.1, hence $m \\leq n$ and $m \\to \\infty$ when $n \\to \\infty$ and for $s \\in \\mathbb{R}$, $[s]$ denotes the greatest integer part.\n\n$$\nA_j =",
        ),
        (
            r"\$\$\s*\n\$A_j\$ = \\left\\{",
            "$$\nA_j = \\left\\{",
        ),
        (
            r"\\rho\(\$x_\{i_j\}\$, x\)",
            r"\\rho(x_{i_j}, x)",
        ),
        (
            r"\\rho\(\$x_\{i_k\}\$, x\)",
            r"\\rho(x_{i_k}, x)",
        ),
        (
            r"m = \\left\\lfloor \$C_1\$",
            r"m = \\left\\lfloor C_1",
        ),
        (
            r"\$C_0\$ d \\psi_n",
            r"C_0 d \\psi_n",
        ),
        (
            r"1 _ \{ \$A _\{j\}\$ \}",
            r"1_{A_j}",
        ),
        (
            r"\$\$\s*\n> 0,.*?\\text \{We remark when \}.*?\n\$\$\s*\nand s \+ =",
            "$$\n\\hat{a}_j = \\frac{\\sum_{i=1}^{n} K_{\\kappa, x_{i_j}}(x_i) y_i}{\\sum_{i=1}^{n} K_{\\kappa, x_{i_j}}(x_i)}, \\quad K_{\\kappa, x_{i_j}}(\\omega) = \\left(1-(\\kappa\\rho(x_{i_j},\\omega))^\\beta\\right)_+, \\quad \\kappa = \\left(\\frac{C_0 \\varphi_n}{L}\\right)^{-1/\\beta}\n$$\n\nwhere $s_+ = \\max(s,0)$ for $s \\in \\mathbb{R}$. We remark that when $m$ is also large, the support set of $K_{\\kappa, x_{i_j}}(\\omega)$ and",
        ),
    ]
    for pattern, repl in fixes:
        text = re.sub(pattern, lambda _m, r=repl: r, text, flags=re.DOTALL)
    return text


def render_segments(segments: list[tuple[str, str]]) -> str:
    out: list[str] = []
    for kind, body in segments:
        if kind == "math":
            cleaned = clean_math_block(body)
            if cleaned:
                out.append("$$")
                out.append(cleaned)
                out.append("$$")
        else:
            for line in body.splitlines():
                out.append(enrich_prose_line(line))
    text = "\n".join(out)
    while "\n\n\n" in text:
        text = text.replace("\n\n\n", "\n\n")
    return text.rstrip() + "\n"


def apply_doc_patches(text: str, doc_id: str) -> str:
    for pattern, repl in DOC_PATCHES.get(doc_id, []):
        text = re.sub(pattern, lambda _m, r=repl: r, text, flags=re.DOTALL)
    return text


def repair_doc(doc_id: str) -> tuple[int, int]:
    path = PH / f"{doc_id}.md"
    before = path.read_text(encoding="utf-8", errors="replace")
    text = before
    if doc_id == "BCKL2010":
        text = repair_bckl_fragmented_blocks(text)
    text = apply_doc_patches(text, doc_id)
    segments = split_math_segments(text)
    after = render_segments(segments)
    if after != before:
        path.write_text(after, encoding="utf-8")
    return len(before), len(after)


def main() -> None:
    for doc_id in DOCS:
        b, a = repair_doc(doc_id)
        if a != b:
            print(f"OK {doc_id}: {b} -> {a} bytes ({a - b:+d})")
        else:
            print(f"— {doc_id}: unchanged")


if __name__ == "__main__":
    main()
