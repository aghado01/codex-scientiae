"""Normalize LaTeX and strip figure-axis OCR debris from HTR2005.md."""
from __future__ import annotations

import re
from pathlib import Path

PATH = Path(__file__).resolve().parents[1] / "HTR2005.md"

IMAGE_RE = re.compile(r"^!\[([^\]]*)\]\(<HTR2005/imageFile(\d+)\.png>\)\s*$")
FIGURE_CAPTION_RE = re.compile(r"^Figure (\d+): (.+)$")
HEADING_RE = re.compile(r"^#{1,4} ")

GARBAGE_LABELS = frozenset(
    {
        "log(evidence)",
        "ML#segments",
        "MLSgments",
        "Estimate",
        "sqrt(varseg)",
        "P(k|y)",
        "CMwG",
        "Gen(5,9)",
        "Gen(3,1)",
    }
)

LIGATURES = {
    "Speciﬁc": "Specific",
    "Eﬃcient": "Efficient",
    "eﬃcient": "efficient",
    "ﬁxed": "fixed",
    "ﬁtting": "fitting",
    "ﬁrst": "first",
    "ﬁnal": "final",
    "signiﬁcance": "significance",
    "signiﬁcant": "significant",
    "diﬀerent": "different",
    "diﬃcult": "difficult",
    "deﬁne": "define",
    "deﬁned": "defined",
    "deﬁnes": "defines",
    "conﬁdence": "confidence",
    "suﬃcient": "sufficient",
    "inﬂuence": "influence",
    "inﬂuences": "influences",
    "misspeciﬁcation": "misspecification",
    "modiﬁed": "modified",
    "identiﬁes": "identifies",
    "identiﬁed": "identified",
    "oﬀ": "off",
    "ﬂat": "flat",
    "on-the-ﬂy": "on-the-fly",
    "brieﬂy": "briefly",
    "ﬁnd": "find",
    "ﬁt": "fit",
    "ﬁgure": "figure",
    "ﬁgures": "figures",
    "speciﬁcation": "specification",
    "Diﬀerent": "Different",
    "ﬁxing": "fixing",
    "abberation": "aberration",
    "reﬁne": "refine",
    "diﬀerences": "differences",
}


def is_garbage_line(line: str) -> bool:
    s = line.strip()
    if not s:
        return False
    if s in GARBAGE_LABELS:
        return True
    if re.fullmatch(r"- -\d+", s):
        return True
    if re.fullmatch(r"-?\d+\.?\d*", s):
        return True
    if re.fullmatch(r"\d{3,4}", s):
        return True
    return False


def normalize_latex_body(body: str) -> str:
    body = body.replace("\\_", "_")
    body = re.sub(r"\\text\s*\{\s*", r"\\text{", body)
    body = re.sub(r"_\s*\{\s*", r"_{", body)
    body = re.sub(r"\^\s*\{\s*", r"^{", body)
    body = re.sub(r"\{\s+", "{", body)
    body = re.sub(r"\s+\}", "}", body)
    body = re.sub(r"\\prod\s*_\s*\{", r"\\prod_{", body)
    body = re.sub(r"\\arg\s*\\max\s*_\s*\{", r"\\arg\\max_{", body)
    body = re.sub(r"\\binom\s*\{\s*", r"\\binom{", body)
    body = re.sub(r"\\frac\s*\{\s*", r"\\frac{", body)
    body = re.sub(r"\\sqrt\s*\{\s*", r"\\sqrt{", body)
    # primes: \mu^{'} or \mu^{\prime} -> \mu'
    body = re.sub(r"(\w)\s*\^\{\s*'\s*\}", r"\1'", body)
    body = re.sub(r"(\w)\s*\^\{\s*\\prime\s*\}", r"\1'", body)
    body = re.sub(r"\\prime\b", "'", body)
    body = re.sub(r"P\s*\(\s*", "P(", body)
    body = re.sub(r"(?<!\^)\s*\)\s*(?!\^)", ")", body)
    body = re.sub(r"\s*\|\s*", r" \\mid ", body)
    body = re.sub(r"\\mid\s+\\mid", r"\\mid", body)
    body = re.sub(r"\s*\\colon\s*", r" \\colon ", body)
    body = re.sub(r"\s*\\cdot\s*", r" \\cdot ", body)
    body = re.sub(r"\s*=\s*", r" = ", body)
    body = re.sub(r"\s*\+\s*", r" + ", body)
    body = re.sub(r"\s*-\s*", r" - ", body)
    body = re.sub(r"\s*\^\s*\{\s*", r"^{", body)
    body = re.sub(r"_\s*\{\s*([^}]+)\s*\}", r"_{\1}", body)
    body = re.sub(r"\^\s*\{\s*([^}]+)\s*\}", r"^{\1}", body)
    body = re.sub(r"\\hat\s*\{\s*", r"\\hat{", body)
    body = re.sub(r"\\widehat\s*\{\s*", r"\\widehat{", body)
    body = re.sub(r"e\s*\^\s*\{\s*-\s*", r"e^{-", body)
    body = re.sub(r"\{\s*\\sigma\s*_\s*\{([^}]+)\}\s*\^\{\s*'\s*\}\s*\}", r"{\\sigma_{\1}'}", body)
    body = re.sub(r"  +", " ", body)
    return body.strip()


def normalize_math_blocks(text: str) -> str:
    def repl_block(m: re.Match[str]) -> str:
        body = normalize_latex_body(m.group(1))
        return f"$$\n{body}\n$$"

    return re.sub(r"\$\$\s*\n(.*?)\n\$\$", repl_block, text, flags=re.DOTALL)


def normalize_inline_math(text: str) -> str:
    def repl_inline(m: re.Match[str]) -> str:
        inner = normalize_latex_body(m.group(1))
        return f"${inner}$"

    return re.sub(r"\$([^$\n]+)\$", repl_inline, text)


def fix_key_equations(text: str) -> str:
    replacements = [
        (
            r"\$\$\n\\text\{likelihood\}.*?\n\$\$",
            "$$\n\\text{likelihood}: \\quad P(y \\mid \\mu', \\sigma') := \\prod_{i=1}^{n} P(y_i \\mid \\mu'_i, \\sigma'_i) \\tag{1}\n$$",
        ),
        (
            r"\$\$\n\\text \{piecewise constant\} \\colon \\ \\mu _ \{ i \} \^ \{ \\prime \} = \\mu _ \{ q \}.*?\n\$\$",
            "$$\n\\text{piecewise constant}: \\quad \\mu'_i = \\mu_q \\quad \\text{and} \\quad \\sigma'_i = \\sigma_q \\quad \\text{for} \\quad t_{q-1} < i \\leq t_q \\quad \\forall q \\tag{2}\n$$",
        ),
        (
            r"\$\$\n\\text\{prior\} \\colon \\quad P \( \\mu _ \{ q \} \\mid \\nu , \\rho \).*?\n\$\$",
            "$$\n\\text{prior}: \\quad P(\\mu_q \\mid \\nu, \\rho) \\; \\forall q \\quad \\text{and} \\quad P(t \\mid k) \\quad \\text{and} \\quad P(k)\n$$",
        ),
        (
            r"\$\$\n# \\text \{ segments\} \\colon \\ P \( k \\mid y \).*?\n\$\$",
            "$$\n\\#\\text{segments}: \\quad P(k \\mid y) \\quad \\text{and} \\quad \\hat{k} = \\arg\\max_k P(k \\mid y)\n$$",
        ),
        (
            r"\$\$\n\\text\{boundaries\} \\colon \\ P \( t _ \{ q \} \\mid y , \\hat \{ k \} \).*?\n\$\$",
            "$$\n\\text{boundaries}: \\quad P(t_q \\mid y, \\hat{k}) \\quad \\text{and} \\quad \\hat{t}_q = \\arg\\max_{t_q} P(t_q \\mid y, \\hat{k})\n$$",
        ),
        (
            r"\$\$\n\\text\{segment level:\} \\quad P \( \\mu _ \{ q \} \\mid y , \\hat \{ t \} , \\hat \{ k \} \).*?\n\$\$",
            "$$\n\\text{segment level}: \\quad P(\\mu_q \\mid y, \\hat{t}, \\hat{k}) \\quad \\text{and} \\quad \\hat{\\mu}_q = \\int P(\\mu_q \\mid y, \\hat{t}, \\hat{k})\\, \\mu_q\\, d\\mu_q\n$$",
        ),
        (
            r"\$\$\n\\text\{regression curve:\} \\quad P \( \\mu _ \{ i \} \^ \{ \\prime \} \\mid y \).*?\n\$\$",
            "$$\n\\text{regression curve}: \\quad P(\\mu'_i \\mid y) \\quad \\text{and} \\quad \\hat{\\mu}'_i = \\int P(\\mu'_i \\mid y)\\, \\mu'_i\\, d\\mu'_i\n$$",
        ),
        (
            r"\$\$\n\\text\{uniform boundary prior\} \\colon \\ P \( t \\mid k \) = \\binom \{ n - 1 \} \{ k - 1 \} \^ \{ - 1 \}\n\$\$",
            "$$\n\\text{uniform boundary prior}: \\quad P(t \\mid k) = \\binom{n-1}{k-1}^{-1}\n$$",
        ),
        (
            r"\$\$\n\\text\{Gaussian noise\}.*?\n\$\$",
            "$$\n\\text{Gaussian noise}: \\quad P(y_i \\mid \\mu'_i, \\sigma'_i) = \\frac{1}{\\sqrt{2\\pi}\\,\\sigma'_i} \\exp\\!\\left(-\\frac{(y_i-\\mu'_i)^2}{2{\\sigma'_i}^2}\\right)\n$$",
        ),
        (
            r"\$\$\n\\text\{Gaussian prior\}.*?\n\$\$",
            "$$\n\\text{Gaussian prior}: \\quad P(\\mu_q \\mid \\nu, \\rho) = \\frac{1}{\\sqrt{2\\pi}\\,\\rho} \\exp\\!\\left(-\\frac{(\\mu_q-\\nu)^2}{2\\rho^2}\\right)\n$$",
        ),
        (
            r"\$\$\n\\text\{Cauchy noise\}.*?\n\$\$",
            "$$\n\\text{Cauchy noise}: \\quad P(y_i \\mid \\mu'_i, \\sigma'_i) = \\frac{1}{\\pi}\\,\\frac{\\sigma'_i}{{\\sigma'_i}^2 + (y_i-\\mu'_i)^2}\n$$",
        ),
        (
            r"\$\$\n\\text\{Cauchy prior\}.*?\n\$\$",
            "$$\n\\text{Cauchy prior}: \\quad P(\\mu_q \\mid \\nu, \\rho) = \\frac{1}{\\pi}\\,\\frac{\\rho}{\\rho^2 + (\\mu_q-\\nu)^2}\n$$",
        ),
        (
            r"\$\$\n\\text\{uniform boundary prior\}.*?\n\$\$",
            "$$\n\\text{uniform boundary prior}: \\quad P(t \\mid k) = \\binom{n-1}{k-1}^{-1}\n$$",
        ),
        (
            r"\$\$\n\\# \\text\{segments\}.*?\n\$\$",
            "$$\n\\#\\text{segments}: \\quad P(k \\mid y) \\quad \\text{and} \\quad \\hat{k} = \\arg\\max_k P(k \\mid y)\n$$",
        ),
        (
            r"\$\$\n\\text\{boundaries\}.*?\n\$\$",
            "$$\n\\text{boundaries}: \\quad P(t_q \\mid y, \\hat{k}) \\quad \\text{and} \\quad \\hat{t}_q = \\arg\\max_{t_q} P(t_q \\mid y, \\hat{k})\n$$",
        ),
        (
            r"\$\$\n\\text\{segment level:\}.*?\n\$\$",
            "$$\n\\text{segment level}: \\quad P(\\mu_q \\mid y, \\hat{t}, \\hat{k}) \\quad \\text{and} \\quad \\hat{\\mu}_q = \\int P(\\mu_q \\mid y, \\hat{t}, \\hat{k})\\, \\mu_q\\, d\\mu_q\n$$",
        ),
        (
            r"\$\$\n\\text\{regression curve:\}.*?\n\$\$",
            "$$\n\\text{regression curve}: \\quad P(\\mu'_i \\mid y) \\quad \\text{and} \\quad \\hat{\\mu}'_i = \\int P(\\mu'_i \\mid y)\\, \\mu'_i\\, d\\mu'_i\n$$",
        ),
        (
            r"\$\$\n\\text\{single segment\}.*?\n\$\$",
            "$$\n\\text{single segment}: \\quad P(y_{ij}, \\mu_m \\mid t_{m-1,m}, 1) = P(\\mu_m) \\prod_{t=i+1}^{j} P(y_t \\mid \\mu_m)\n$$",
        ),
        (
            r"\$\$\nP \( k \) \\, = \\, \\frac \{ 1 \} \{ k _ \{ \\max \} \}.*?\n\$\$",
            "$$\nP(k) = \\frac{1}{k_{\\max}} \\quad \\text{for} \\quad 1 \\leq k \\leq k_{\\max} \\quad \\text{and} \\quad 0 \\quad \\text{otherwise}\n$$",
        ),
        (
            r"\$\$\n\\text \{single segment\} \\colon \\, P \( y _ \{ i j \} , \\mu _ \{ m \} \\mid t _ \{ m - 1 , m \} , 1 \).*?\n\$\$",
            "$$\n\\text{single segment}: \\quad P(y_{ij}, \\mu_m \\mid t_{m-1,m}, 1) = P(\\mu_m) \\prod_{t=i+1}^{j} P(y_t \\mid \\mu_m)\n$$",
        ),
    ]
    for pattern, repl in replacements:
        text, n = re.subn(pattern, lambda _m, r=repl: r, text, flags=re.DOTALL)
        if n:
            print(f"fixed equation block ({n})")
    return text


def normalize_figure_captions(text: str) -> str:
    def repl(m: re.Match[str]) -> str:
        num, body = m.group(1), m.group(2)
        body = re.sub(r"P\s*\(\s*k\s*\|\s*y\s*\)", r"$P(k \\mid y)$", body)
        body = re.sub(r"P\s*\(\s*y\s*\|\s*σ\s*\)", r"$P(y \\mid \\sigma)$", body)
        body = re.sub(r"1\s*/\s*2", r"$\\pm 1$ std", body)
        body = re.sub(r"std\.deviation", "std. deviation", body)
        return f"Figure {num}: {body}"

    return re.sub(r"^Figure (\d+): (.+)$", repl, text, flags=re.MULTILINE)


def clean_figure_section(lines: list[str]) -> list[str]:
    out: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        m_img = IMAGE_RE.match(line)
        if not m_img:
            out.append(line)
            i += 1
            continue

        _alt, file_num = m_img.groups()
        caption = None
        for j in range(i + 1, min(i + 40, len(lines))):
            m_cap = FIGURE_CAPTION_RE.match(lines[j].strip())
            if m_cap:
                caption = f"Figure {m_cap.group(1)}: {m_cap.group(2)}"
                break

        if caption:
            short = caption if len(caption) <= 120 else caption[:117] + "..."
            out.append(f"![{short}](<HTR2005/imageFile{file_num}.png>)")
        else:
            out.append(f"![Figure {file_num}](<HTR2005/imageFile{file_num}.png>)")
        out.append("")
        i += 1

        while i < len(lines):
            nxt = lines[i]
            stripped = nxt.strip()
            if not stripped:
                i += 1
                continue
            if IMAGE_RE.match(nxt) or FIGURE_CAPTION_RE.match(stripped) or HEADING_RE.match(nxt):
                break
            if is_garbage_line(nxt):
                i += 1
                continue
            if len(stripped) > 50 and " " in stripped and not stripped.startswith("|"):
                break
            i += 1
    return out


def remove_orphan_lines(lines: list[str]) -> list[str]:
    """Drop lone axis ticks and empty table debris."""
    out: list[str] = []
    for ln in lines:
        if ln.strip() == "|" and (not out or out[-1].strip().startswith("|")):
            continue
        if is_garbage_line(ln) and out and (
            out[-1].startswith("Figure ") or out[-1].strip() == "" or IMAGE_RE.match(out[-1])
        ):
            continue
        out.append(ln)
    return out


def merge_split_description(lines: list[str]) -> list[str]:
    """Rejoin Description paragraph split by figure gallery."""
    start = None
    cont = None
    for idx, ln in enumerate(lines):
        if ln.startswith("Description.") and "with a large" in ln:
            start = idx
        if start is not None and ln.startswith("jump at the first"):
            cont = idx
            break
    if start is None or cont is None:
        return lines
    merged = lines[start].rstrip() + " " + lines[cont].strip()
    new_lines = lines[:start] + [merged] + lines[start + 1 : cont] + lines[cont + 1 :]
    print("merged split Description paragraph")
    return new_lines


def insert_missing_figure_captions(lines: list[str]) -> list[str]:
    """Add Figure 13/14 captions after sensitivity plots if absent."""
    inserts = {
        "12": "Figure 13: [GM: medium Gaussian noise] log-evidence $\\log P(y \\mid \\sigma)$ and segment number $\\hat{k}(\\sigma)$ as a function of $\\sigma$.",
        "14": "Figure 14: [CMwG: medium Cauchy noise] log-evidence and $\\hat{k}(\\sigma)$; outliers increase $\\hat{\\sigma}$ beyond the peak of $P(y \\mid \\sigma)$.",
    }
    out: list[str] = []
    i = 0
    while i < len(lines):
        out.append(lines[i])
        m = IMAGE_RE.match(lines[i])
        if m and m.group(2) in inserts:
            fig_num = m.group(2)
            cap = inserts[fig_num]
            fig_n = cap.split(":")[0].replace("Figure ", "")
            already = any(
                FIGURE_CAPTION_RE.match(lines[j].strip()) and lines[j].strip().startswith(f"Figure {fig_n}:")
                for j in range(max(0, i - 5), min(len(lines), i + 15))
            )
            if not already:
                out.append("")
                out.append(cap)
        i += 1
    return out


def fix_table2(text: str) -> str:
    text = text.replace("Var [ ll | ˆ f ] 1 / 2", r"$\mathrm{Var}[ll \mid \hat{f}]^{1/2}$")
    text = text.replace("log P ( y )", r"$\log P(y)$")
    text = text.replace("ll - E [ ll | ˆ f ]", r"$ll - \mathbb{E}[ll \mid \hat{f}]$")
    text = text.replace("P ( ˆ k ( - 1 , +1) | y )", r"$P(\hat{k}\pm 1 \mid y)$")
    text = text.replace("C k ( - 1 , +1)", r"$C_{\hat{k}}(\pm 1)$")
    text = re.sub(r"\|\s*\n\n\|", "|\n", text)
    return text


def main() -> None:
    text = PATH.read_text(encoding="utf-8")
    for a, b in LIGATURES.items():
        text = text.replace(a, b)

    text = fix_key_equations(text)
    text = normalize_math_blocks(text)
    text = normalize_inline_math(text)
    text = normalize_figure_captions(text)
    text = fix_table2(text)

    lines = text.splitlines()
    lines = merge_split_description(lines)
    lines = clean_figure_section(lines)
    lines = insert_missing_figure_captions(lines)
    lines = remove_orphan_lines(lines)

    text = "\n".join(lines) + "\n"
    PATH.write_text(text, encoding="utf-8")
    print("wrote", PATH)


if __name__ == "__main__":
    main()
