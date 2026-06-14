"""Repair OCR noise in HTR2005.md math blocks."""
from __future__ import annotations

import re
from pathlib import Path

PATH = Path(__file__).resolve().parents[1] / "HTR2005.md"


def strip_intertext(s: str) -> str:
    s = re.sub(r"\\intertext\s*\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}", "", s)
    return s


def strip_dot_phi_garbage(s: str) -> str:
    # OCR runs of \dot{\phi} noise
    s = re.sub(r"(?:\\colon\s*\\dot\s*\{\\phi\}[\s\\colon\{\}_a-z]*){3,}", "", s)
    s = re.sub(r"\\dot\s*\{\\phi\}[\s\\colon\{\}_a-z]*", "", s)
    return s


def strip_space_padding_garbage(s: str) -> str:
    # Lines that are mostly backslash-space padding from OCR
    if re.search(r"(?:\\ \ ){20,}", s):
        s = re.sub(r"\\ \s*(?:\\ \s*){10,}", "", s)
    return s


def fix_subscripts(s: str) -> str:
    s = re.sub(r"([A-Za-z])\*\{", r"\1_{", s)
    s = re.sub(r"\\_", "_", s)
    return s


def compact_latex_spacing(s: str) -> str:
    s = re.sub(r"\s+", " ", s)
    s = re.sub(r"\s*\\\s*", r"\\", s)
    s = re.sub(r"\s*([=+\-*/,:;])\s*", r" \1 ", s)
    s = re.sub(r"\s{2,}", " ", s)
    return s.strip()


def remove_prose_in_math(s: str) -> str:
    lines = [ln.strip() for ln in s.splitlines()]
    kept: list[str] = []
    for ln in lines:
        if not ln:
            continue
        # drop obvious OCR prose fragments inside math
        if re.match(r"^(This is our key recursion|L\s+us define|j\s*=\s*&\s*l_|Note that this expression is independent)", ln):
            continue
        if re.search(r"\\text\s*\{\s*(?:Note that|Depending on whether|while segment|variant|Summing over)", ln):
            continue
        if re.search(r"(?:lof the vidonee|n i s w a y|f o r e n \$ r \$|w i t i o l|o n v e r s g g)", ln, re.I):
            continue
        kept.append(ln)
    return "\n".join(kept)


def clean_math_block(body: str) -> str:
    body = strip_intertext(body)
    body = strip_dot_phi_garbage(body)
    body = strip_space_padding_garbage(body)
    body = fix_subscripts(body)
    body = remove_prose_in_math(body)
    # drop duplicate consecutive lines
    lines = [ln for ln in body.splitlines() if ln.strip()]
    deduped: list[str] = []
    for ln in lines:
        if not deduped or ln != deduped[-1]:
            deduped.append(ln)
    body = "\n".join(deduped)
    return body.strip()


def _r(s: str) -> str:
    return s


REPLACEMENTS: dict[str, str] = {
    # split posterior
    r"\$\$\n\n\\text \{posterior\}.*?\$\$\n\nThe posterior":
    _r(r"""$$\n\text{posterior}: \; P(\mu, t, k \mid y) = \frac{P(y \mid \mu, t, k)\, P(\mu, t, k)}{P(y)} \tag{4}\n$$\n\nThe posterior"""),

    # equation (11) array with duplicate line
    r"\$\$\n\n\\begin\{array\}.*?\( 1 1 \).*?\$\$":
    "$$\n\\begin{aligned}\nP(y_{ij}, \\mu_{lm} \\mid t_{lm}, m-l) &= \\prod_{p=l+1}^{m} \\left[ P(\\mu_p) \\prod_{t=t_{p-1}+1}^{t_p} P(y_t \\mid \\mu_p) \\right] \\\\\n&= P(y_{ih}, \\mu_{lp} \\mid t_{lp}, p-l)\\, P(y_{hj}, \\mu_{pm} \\mid t_{pm}, m-p) \\quad (\\text{any } p) \\tag{11}\n\\end{aligned}\n$$",

    # Q recursion (12)-(13)
    r"\$\$\n\nThis is our key recursion\..*?\\text\{and\}\}\n\$\$":
    "$$\n\\begin{aligned}\nQ(y_{ij}, \\mu_{lm} \\mid m-l) &:= \\binom{j-i-1}{m-l-1}^{-1} \\!\\!\\sum_{t_{lm}: i=t_l<\\cdots<t_m=j} P(y_{ij}, \\mu_{lm} \\mid t_{lm}, m-l) \\\\\n\\stackrel{(a)}{=} & \\binom{j-i-1}{m-l-1}^{-1} \\!\\!\\sum_{t_{lm}} P(y_{ij}, \\mu_{lm} \\mid t_{lm}, m-l)\\, P(t_{lm} \\mid m-l) \\\\\n\\stackrel{(b)}{=} & \\sum_{t_{lm}} P(y_{ij}, \\mu_{lm} \\mid t_{lm}, m-l) \\\\\n\\stackrel{(c)}{=} & \\sum_{h=i+p-l}^{j+p-m} Q(y_{ih}, \\mu_{lp} \\mid p-l)\\, Q(y_{hj}, \\mu_{pm} \\mid m-p) \\tag{12}\n\\end{aligned}\n$$",

    # Q_t^r recursion (14)
    r"\$\$\n\nL \\text \{ us define more generally \}.*?\\text \{ term combines with the right or left\}\n\$\$":
    "$$\n\\begin{aligned}\nQ_t^r(y_{ij} \\mid m-l) &:= \\int Q(y_{ij}, \\mu_{lm} \\mid m-l)\\, \\mu_t^r\\, d\\mu_{lm} \\\\\n&= \\sum_{h=i+p-l}^{t-1} Q^0(y_{ih} \\mid p-l)\\, Q_t^r(y_{hj} \\mid m-p) + \\sum_{h=t}^{j+p-m} Q_t^r(y_{ih} \\mid m-p)\\, Q^0(y_{hj} \\mid m-p) \\tag{14}\n\\end{aligned}\n$$",

    # A_ij^r (16)
    r"\$\$\n\nA _ \{ i j \} \^ \{ r \}.*?\( 1 6 \).*?\\text \{the \} r \^ \{ t h \}.*?\n\$\$":
    "$$\nA_{ij}^r := Q_t^r(y_{ij} \\mid 1) = \\int P(\\mu_m) \\prod_{t=i+1}^{j} P(y_t \\mid \\mu_m)\\, \\mu_m^r\\, d\\mu_m, \\quad (0 \\leq i < j \\leq n) \\tag{16}\n$$",

    # segment level moments (22)
    r"\$\$\n\nj = & l _ \{ m \}.*?\n\$\$\n\nNote that this expression is independent":
    "$$\n\\widehat{\\mu_m^r} = \\mathbb{E}[\\mu_m^r \\mid y, \\hat{t}, \\hat{k}] = \\mathbb{E}[\\mu_m^r \\mid y_{ij}, \\hat{t}_{m-1,m}, 1] = \\frac{\\int P(y_{ij}, \\mu_m \\mid \\hat{t}_{m-1,m}, 1)\\, \\mu_m^r\\, d\\mu_m}{\\int P(y_{ij}, \\mu_m \\mid \\hat{t}_{m-1,m}, 1)\\, d\\mu_m} = \\frac{A_{ij}^r}{A_{ij}^0} \\tag{22}\n$$\n\nNote that this expression is independent",

    # regression curve c.i.
    r"\$\$\n\nP \( \\mu _ \{ t \} \^ \{ \\prime \} \| y , k \).*?\\intertext.*?\n\$\$":
    "$$\nP(\\mu_t' \\mid y, k) = \\sum_{m=1}^{k} \\sum_{i=0}^{t-1} \\sum_{j=t}^{n} P(\\mu_m, t_{m-1}=i, t_m=j \\mid y, k) \\tag{23}\n$$",

    # three-part factorization
    r"\$\$\n\n\( \\begin\{matrix\} n - 1 \\\\ k - 1 \\end\{matrix\} \) P \( y , \\mu , t _ \{ l \} , t _ \{ m \} \| k \).*?\n\$\$":
    "$$\n\\binom{n-1}{k-1} P(y, \\mu, t_l, t_m \\mid k) = Q(y_{0i}, \\mu_{0l} \\mid l)\\, Q(y_{ij}, \\mu_m \\mid m-l)\\, Q(y_{jn}, \\mu_{mk} \\mid k-m) \\tag{24}\n$$",

    # regression curve posterior
    r"\$\$\n\nP \( \\mu _ \{ t \} \^ \{ \\prime \} \| y , k \) \, = \, \\frac \{ 1 \} \{ L _ \{ k n \} \}.*?\n\$\$":
    "$$\nP(\\mu_t' \\mid y, k) = \\frac{1}{L_{kn}} \\sum_{m=1}^{k} \\sum_{i<t\\leq j} L_{m-1,i}\\, Q(y_{ij}, \\mu_m \\mid 1)\\, R_{k-m,j}\n$$",

    # F_ij^r
    r"\$\$\n\n\\widehat \{ \\mu _ \{ t \} \^ \{ \\prime \} \}.*?\\text \{while segment boundaries.*?\n\$\$":
    "$$\n\\widehat{\\mu_t^{\\prime r}} = \\sum_{i<t\\leq j} F_{ij}^r \\quad \\text{with} \\quad F_{ij}^r := \\frac{1}{L_{\\hat{k}n}} \\sum_{m=1}^{\\hat{k}} L_{m-1,i}\\, A_{ij}^r\\, R_{\\hat{k}-m,j} \\tag{24}\n$$",

    # log-likelihood
    r"\$\$\n\nl l \\, \\colon = \\, \\log P \( y \| \\hat \{ f \} \).*?\\intertext.*?\n\$\$":
    "$$\nll := \\log P(y \\mid \\hat{f}) = \\log P(y \\mid \\hat{\\mu}, \\hat{t}, \\hat{k}) = \\sum_{i=1}^{n} \\log P(y_i \\mid \\hat{\\mu}_i', \\sigma)\n$$",

    # Gauss/Cauchy ll stats
    r"\$\$\n\n\\ G a u s \{ \\colon \}.*?\n\$\$":
    "$$\n\\begin{aligned}\n\\text{Gauss:} \\quad & \\mathbb{E}[ll \\mid \\hat{f}] = \\frac{n}{2}\\log(2\\pi e \\hat{\\sigma}^2), \\quad \\mathrm{Var}[ll \\mid \\hat{f}] = \\frac{n}{2} \\\\\n\\text{Cauchy:} \\quad & \\mathbb{E}[ll \\mid \\hat{f}] = n\\log(4\\pi \\hat{\\sigma}), \\quad \\mathrm{Var}[ll \\mid \\hat{f}] = \\frac{n}{3}\\pi^2\n\\end{aligned}\n$$",

    # Gaussian single segment integral - remove garbage tail
    r"\$\$\n\nA _ \{ i j \} \^ \{ r \} \, = \, \\left \( \\frac \{ 1 \} \{ \\sqrt \{ 2 \\pi \} \\sigma \} \\right \).*?\\dot.*?\n\$\$":
    "$$\nA_{ij}^r = \\left(\\frac{1}{\\sqrt{2\\pi}\\,\\sigma}\\right)^d \\frac{1}{\\sqrt{2\\pi}\\,\\rho} \\int_{-\\infty}^{\\infty} \\exp\\!\\left(-\\frac{1}{2\\sigma^2}\\sum_{t=i+1}^{j}(y_t-\\mu_m)^2 - \\frac{1}{2\\rho^2}(\\mu_m-\\nu)^2\\right) \\mu_m^r\\, d\\mu_m\n$$",

    # equations 25-27 block
    r"\$\$\n\nP \( y _ \{ i j \} \| t _ \{ m - 1 , m \} \).*?\( 2 5 \).*?\n\$\$":
    "$$\nP(y_{ij} \\mid t_{m-1,m}) = A_{ij}^0 = \\frac{\\exp\\!\\left\\{\\frac{1}{2\\sigma^2}\\left[\\frac{(\\sum_t (y_t-\\nu))^2}{d+\\sigma^2/\\rho^2} - \\sum_t (y_t-\\nu)^2\\right]\\right\\}}{(2\\pi\\sigma^2)^{d/2}(1+d\\rho^2/\\sigma^2)^{1/2}} \\tag{25}\n$$",

    r"\$\$\n1 \( y _ \{ i j \} \| _ \{ m - 1 , m \} \).*?\\sim \\sigma \^ \{ 2 \} \\\\\n\$\$":
    "$$\n\\begin{aligned}\nA_{ij}^1 &= A_{ij}^0 \\cdot \\frac{\\rho^2(\\sum_t y_t) + \\sigma^2\\nu}{d\\rho^2+\\sigma^2} \\tag{26} \\\\\n\\mathbb{E}[\\mu_m \\mid y_{ij}, t_{m-1,m}] &= \\frac{A_{ij}^1}{A_{ij}^0} = \\frac{\\rho^2(\\sum_t y_t) + \\sigma^2\\nu}{d\\rho^2+\\sigma^2} \\approx \\frac{1}{d}\\sum_t y_t \\\\\n\\mathrm{Var}[\\mu_m \\mid y_{ij}, t_{m-1,m}] &= \\frac{A_{ij}^2}{A_{ij}^0} - \\left(\\frac{A_{ij}^1}{A_{ij}^0}\\right)^2 = \\left[\\frac{d}{\\sigma^2}+\\frac{1}{\\rho^2}\\right]^{-1} \\approx \\frac{\\sigma^2}{d} \\tag{27}\n\\end{aligned}\n$$",

    # remove shattered Var block with space garbage
    r"\$\$\n\nA _ \{ i j \} \^ \{ 1 \} & & A _ \{ \\rho \}.*?\n\$\$\n\nwhere Σ":
    "",

    # central moments
    r"\$\$\n\nE \[ \( \\mu _ \{ m \} - A _ \{ i j \} \^ \{ 1 \} / A _ \{ i j \} \^ \{ 0 \} \).*?\\intertext.*?\n\$\$":
    "$$\n\\mathbb{E}[(\\mu_m - A_{ij}^1/A_{ij}^0)^r \\mid y_{ij}, t_{m-1,m}] = \\frac{1\\cdot 3\\cdots(r-1)}{[d\\sigma^{-2}+\\rho^{-2}]^{r/2}} \\approx 1\\cdot 3\\cdots(r-1)\\cdot \\left(\\frac{\\sigma^2}{d}\\right)^{r/2}\n$$",

    # incremental mu update
    r"\$\$\n\n\\widehat \{ \\mu _ \{ t \+ 1 \} \^ \{ \\prime \\, r \} \}.*?\\intertext.*?\n\$\$":
    "$$\n\\widehat{\\mu_{t+1}^{\\prime r}} = \\widehat{\\mu_t^{\\prime r}} - \\sum_{i=0}^{t-1} F_{it}^r + \\sum_{j=t+1}^{n} F_{tj}^r\n$$",

    # hyper-ML (30) block cleanup
    r"\$\$\n\n\( \\hat \{ \\nu \} , \\hat \{ \\rho \} \).*?\\text \{variant\}.*?\n\$\$":
    "$$\n(\\hat{\\nu}, \\hat{\\rho}) \\approx \\arg\\max_{(\\nu,\\rho)} \\prod_{t=1}^{n} P(y_t \\mid \\hat{\\sigma}, \\nu, \\rho) \\quad \\text{with} \\\\\nP(y_t \\mid \\sigma, \\nu, \\rho) = \\int P(y_t \\mid \\mu, \\sigma)\\, P(\\mu \\mid \\nu, \\rho)\\, d\\mu \\tag{30}\n$$",

    # equation (31)
    r"\$\$\n\\hat \{ \\sigma \} \\approx \\arg \\max.*?\\text \{Note that the last expression is independent.*?\n\$\$":
    "$$\n\\hat{\\sigma} \\approx \\arg\\max_{\\sigma} \\prod_{t=1}^{n-1} P(y_{t+1}-y_t \\mid \\sigma) \\quad \\text{with} \\\\\nP(y_{t+1}-y_t=\\Delta \\mid \\sigma) \\approx \\int_{-\\infty}^{\\infty} P(y_{t+1}=a+\\Delta \\mid \\mu,\\sigma)\\, P(y_t=a \\mid \\mu,\\sigma)\\, da \\tag{31}\n$$",

    # quartile sigma estimate garbage
    r"\$\$\n\\hat \{ \\sigma \} \\approx \\frac \{ \[ \\Delta \].*?\\intertext.*?\n\$\$":
    "$$\n\\hat{\\sigma} \\approx \\frac{[\\Delta]_{3n/4} - [\\Delta]_{n/4}}{2\\beta} \\quad \\text{with } \\beta=2 \\text{ for Cauchy and } \\beta \\doteq 0.6744\\sqrt{2} \\text{ for Gauss,}\n$$",

    # trailing spurious close
    r"Acknowledgements\. Thanks to IOSI.*?\n\$\$\n$": "Acknowledgements. Thanks to IOSI for providing the gene copy # data and to Ivo Kwee for discussions.\n",
}


def process_math_blocks(text: str) -> str:
    def repl(m: re.Match[str]) -> str:
        body = clean_math_block(m.group(1))
        if not body:
            return ""
        return f"$$\n{body}\n$$"

    return re.sub(r"\$\$\s*\n(.*?)\n\$\$", repl, text, flags=re.DOTALL)


def apply_replacements(text: str) -> str:
    for pattern, repl in REPLACEMENTS.items():
        text, n = re.subn(pattern, lambda _m, r=repl: r, text, flags=re.DOTALL)
        if n:
            print(f"replaced: {pattern[:60]}... ({n})")
    return text


def main() -> None:
    text = PATH.read_text(encoding="utf-8")
    text = apply_replacements(text)
    text = process_math_blocks(text)

    # fix common inline OCR in prose-adjacent math
    text = text.replace("L*{", "L_{").replace("R*{", "R_{").replace("B*{", "B_{")
    text = text.replace("C*k", "C_k").replace("t*p", "t_p").replace("y*{", "y_{")
    text = text.replace("A^0*{", "A^0_{").replace("A^r*{", "A^r_{")
    text = text.replace("k*{\max}", "k_{\\max}").replace("k*{\\max}", "k_{\\max}")
    text = text.replace("L\\_{", "L_{").replace("R\\_{", "R_{")

    # ligatures in headings/contents
    for a, b in {
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
        "deﬁned": "defined",
        "deﬁnes": "defines",
        "conﬁdence": "confidence",
        "conﬁg": "config",
        "suﬃcient": "sufficient",
        "suﬀer": "suffer",
        "inﬂuence": "influence",
        "inﬂuences": "influences",
        "misspeciﬁcation": "misspecification",
        "modiﬁed": "modified",
        "modiﬁed": "modified",
        "piece- wise": "piecewise",
    }.items():
        text = text.replace(a, b)

    PATH.write_text(text, encoding="utf-8")
    print("wrote", PATH)


if __name__ == "__main__":
    main()
