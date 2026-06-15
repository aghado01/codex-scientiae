#!/usr/bin/env python3
"""Forward renderability repair for compendium main docs.

Makes math render per STANDARDS.md: $ inline, $$ block.
Repairs broken spans — never strips delimiters to leave bare LaTeX.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

COMPENDIA = Path(__file__).resolve().parents[1]

SKIP_LINE = re.compile(r"^(#{1,6}\s|!\[|\s*- \[|```|\[Page )")

PROSE_IN_MATH = re.compile(
    r"\s+(?:"
    r"\.|,|;|:|\?|!"
    r"|where|whenever|since|because|which|that|then|thus|hence|therefore"
    r"|In particular|Moreover|Similarly|Clearly|Note that|We have|Let us|For all"
    r"|is called|is defined|denote|denotes|forms|such that|if and only if"
    r"|and similarly|resp\.|respectively"
    r")\s+",
    re.I,
)

BARE_CMD = re.compile(
    r"(?<![\\$A-Za-z])"
    r"(mathcal|mathbb|mathrm|mathbf|mathit|mathfrak|operatorname|text)"
    r"\{",
)

STAR_SUB = re.compile(r"(?<![A-Za-z\\])\*(?=\{)")
LETTER_STAR_SUB = re.compile(r"([A-Za-z\\beta])\*(?=\{)")

LATEX_CMD_START = re.compile(
    r"\\(?:mathcal|mathbb|mathrm|mathbf|mathit|frac|sum|prod|int|min|max|lim|"
    r"sup|inf|hat|tilde|bar|vec|sqrt|left|right|text|mathrm|coloneqq|subset|"
    r"supset|in|notin|leq|geq|neq|equiv|sim|cong|otimes|oplus|wedge|vee|"
    r"forall|exists|partial|nabla|infty|to|mapsto|cdot|times|tag|begin|end|"
    r"bigcup|bigcap|bigoplus|bigsqcup|mathrm|operatorname|dots|intercal)"
)

# Mathematical alphanumeric symbols (italic/bold Unicode planes)
MATH_UNICODE_RUN = re.compile(r"[\U0001d400-\U0001d7ff]+")

DOC_PATCHES: dict[str, list[tuple[str, str]]] = {
    "GRE1995": [
        (
            r"\$\$\s*\n=\s*\\int\s*_\s*\{\s*B\s*\}.*?\n\$\$",
            "$$\n\\int_A \\pi(dx) \\int_B P(x, dx') = "
            "\\int_B \\pi(dx') \\int_A P(x', dx). \\tag{1}\n$$",
        ),
    ],
    "WLK2008": [
        (
            r"\$\$\s*\nP\s*\(\s*t\s*_\s*\{\s*1\s*\}.*?\n\$\$\s*,\s*t\s*_\s*\{\s*n\s*\}\s*\)\s*\n\$\$",
            "$$\nP(t_1, \\ldots, t_n) = \\frac{1}{n!}"
            "\\exp\\left(-\\int_0^T \\lambda(u)\\,du\\right)"
            "\\prod_{i=1}^n \\lambda(t_i)\n$$",
        ),
        (
            r"\$\$\s*\nP\s*\(\s*t\s*_\s*\{\s*1\s*\}\s*,\s*\\dots\s*\n\$\$",
            "$$\nP(t_1, \\ldots, t_n) = "
            "\\frac{n!}{T^n \\prod_{i=1}^n \\lambda(t_i)} "
            "\\exp\\left(-\\int_0^T \\lambda(u)\\,du\\right)\n$$",
        ),
        (
            r"\$\$\s*\\tag\{2\}\s*\$\$",
            "",
        ),
        (
            r"FILL_ME_IN",
            r"\\int_0^T \\lambda(u)\\,du",
        ),
    ],
}


def math_unicode_to_ascii(ch: str) -> str:
    o = ord(ch)
    planes = [
        (0x1D400, 26, "A"),
        (0x1D41A, 26, "a"),
        (0x1D434, 26, "A"),
        (0x1D44E, 26, "a"),
        (0x1D468, 26, "A"),
        (0x1D482, 26, "a"),
    ]
    for base, span, start in planes:
        if base <= o < base + span:
            return chr(ord(start) + (o - base))
    return ch


def convert_math_unicode_runs(text: str) -> str:
    def repl(m: re.Match[str]) -> str:
        run = "".join(math_unicode_to_ascii(c) for c in m.group(0))
        return f"${run}$"

    text = text.replace("⟨", r"$\langle$")
    text = text.replace("⟩", r"$\rangle$")
    text = text.replace("ℝ", r"$\mathbb{R}$")
    text = text.replace("→", r"$\to$")
    return MATH_UNICODE_RUN.sub(repl, text)


def fix_subscript_unicode(s: str) -> str:
    s = s.replace("_{leq}", r"_{\leq}")
    s = s.replace("_{geq}", r"_{\geq}")
    s = re.sub(r"(?<![\\a-zA-Z])leq(?=_|\{)", r"\\leq", s)
    s = re.sub(r"(?<![\\a-zA-Z])geq(?=_|\{)", r"\\geq", s)
    s = re.sub(r"\\\\coloneqq", r"\\coloneqq", s)
    s = re.sub(r"\\beta\\_", r"\\beta_", s)
    return s


def fix_latex_body(s: str) -> str:
    s = STAR_SUB.sub("_", s)
    s = LETTER_STAR_SUB.sub(r"\1_{", s)
    s = re.sub(r"([A-Za-z])\*\\(xi|beta|alpha|lambda|mu|sigma)", r"\1_{\\\2}", s)
    s = re.sub(r"b_\{\{", r"b_{", s)
    s = re.sub(r"beta_\{\{", r"beta_{", s)
    s = BARE_CMD.sub(r"\\\1{", s)
    s = fix_subscript_unicode(s)
    s = re.sub(r"\\_(\{)", r"_\1", s)
    s = re.sub(r"\{\s+", "{", s)
    s = re.sub(r"\s+\}", "}", s)
    s = re.sub(r"_\s*\{", "_{", s)
    s = re.sub(r"\^\s*\{", "^{", s)
    s = re.sub(r"\\\s+lim\s+\\sup", r"\\limsup", s)
    s = re.sub(r"\\\s+lim\s+\\inf", r"\\liminf", s)
    s = re.sub(r"F\*\{", r"F_{", s)
    s = re.sub(r"\[x\]\*\{", r"[x]_{", s)
    while True:
        new = re.sub(r"\$([^$]+)\$", r"\1", s)
        if new == s:
            break
        s = new
    # compact spaced OCR in block math: \theta ^ { ( k ) } -> \theta^{(k)}
    s = re.sub(r"\^\s*\{\s*([^}]+?)\s*\}", r"^{\1}", s)
    s = re.sub(r"_\s*\{\s*([^}]+?)\s*\}", r"_{\1}", s)
    s = re.sub(r"\(\s+([^)]+?)\s+\)", r"(\1)", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s


def split_prose_from_math_span(inner: str) -> list[tuple[str, str]]:
    inner = inner.strip()
    if not PROSE_IN_MATH.search(inner):
        return [("math", fix_latex_body(inner))]

    parts: list[tuple[str, str]] = []
    pos = 0
    for m in PROSE_IN_MATH.finditer(inner):
        before = inner[pos : m.start()].strip()
        if before:
            parts.append(("math", fix_latex_body(before)))
        parts.append(("prose", m.group(0).strip()))
        pos = m.end()
    tail = inner[pos:].strip()
    if tail:
        if tail.endswith(".") and LATEX_CMD_START.search(tail[:-1] or tail):
            body = tail[:-1].strip()
            if body:
                parts.append(("math", fix_latex_body(body)))
            parts.append(("prose", "."))
        else:
            parts.append(("math", fix_latex_body(tail)))
    return parts


def is_mistaken_english_wrap(inner: str) -> bool:
    s = inner.strip().rstrip(".")
    if not s or re.search(r"\\|[_^{}=<>+\-*/|0-9]", s):
        return False
    return bool(re.fullmatch(r"[A-Za-z][A-Za-z\s,':;.\-]*", s))


def repair_inline_dollars(text: str) -> str:
    def repl(m: re.Match[str]) -> str:
        inner = m.group(1)
        if is_mistaken_english_wrap(inner):
            return inner.strip()
        inner = fix_subscript_unicode(inner)
        pieces = split_prose_from_math_span(inner)
        out: list[str] = []
        for kind, chunk in pieces:
            if kind == "prose":
                out.append(chunk)
            elif chunk:
                out.append(f"${chunk}$")
        return " ".join(out)

    return re.sub(r"\$([^$\n]+)\$", repl, text)


def convert_alt_delimiters(text: str) -> str:
    text = re.sub(r"\\\((.+?)\\\)", lambda m: f"${m.group(1).strip()}$", text)
    text = re.sub(
        r"\\\[(.+?)\\\]",
        lambda m: f"$$\n{m.group(1).strip()}\n$$",
        text,
        flags=re.DOTALL,
    )
    return text


def wrap_bare_latex_in_prose(line: str) -> str:
    if SKIP_LINE.match(line.strip()) or "$$" in line or line.strip().startswith("|"):
        return line
    if "$" in line:
        return line
    if not LATEX_CMD_START.search(line) and not re.search(r"\\[a-zA-Z]", line):
        return line

    clauses = re.split(r"(?<=[.;])\s+", line)
    out: list[str] = []
    for clause in clauses:
        c = clause.strip()
        if not c:
            continue
        if re.search(r"\\[a-zA-Z]", c):
            c = re.sub(
                r"((?:\\[a-zA-Z]+(?:\{[^}]*\}|\[[^\]]*\]|_[{^][^}\s]*|"
                r"\^[^{][^}\s]*)?)+(?:\s*(?:[=<>+\-*/,:;]|\\[a-zA-Z]+|"
                r"\{[^}]*\}|_[{^][^}]*|\^[^{][^}]*)+)*)",
                lambda m: f"${fix_latex_body(m.group(1))}$"
                if LATEX_CMD_START.search(m.group(1))
                else m.group(1),
                c,
            )
        out.append(c)
    return " ".join(out)


def repair_math_block(body: str) -> str:
    lines: list[str] = []
    for raw in body.splitlines():
        ln = raw.strip()
        if not ln:
            continue
        lines.append(fix_latex_body(ln))
    return "\n".join(lines)


def fix_shattered_display_math(text: str) -> str:
    """Merge display math split across $$ line breaks."""
    text = re.sub(
        r"\$\$\s*\n([^$]+?)\n\$\$\s*,\s*([^$\n]+?)\s*\n\$\$",
        lambda m: f"$$\n{fix_latex_body(m.group(1) + ', ' + m.group(2))}\n$$",
        text,
        flags=re.DOTALL,
    )
    return text


def split_math_segments(text: str) -> list[tuple[str, str]]:
    segs: list[tuple[str, str]] = []
    i = 0
    while i < len(text):
        start = text.find("$$", i)
        if start == -1:
            segs.append(("prose", text[i:]))
            break
        if start > i:
            segs.append(("prose", text[i:start]))
        end = text.find("$$", start + 2)
        if end == -1:
            segs.append(("math", text[start + 2 :]))
            break
        segs.append(("math", text[start + 2 : end]))
        i = end + 2
    return segs


ARTICLE_WRAP = re.compile(r"\$A\$\s+(?=[a-z])")

# Glue allowed between adjacent $...$ fragments when both sides look math-like.
MATH_GLUE = re.compile(
    r"(?:"
    r"\s+"
    r"|[:=,;+\-*/<>()\[\]{}|]"
    r"|∈|⊆|⊂|×|→|·|≤|≥|∪|∩|⊕|⊗|∧|∨|∀|∃|∅|∇|∂|∫|∑|∏|⊏|⊐|⊑|⊒|≈|≃|≅|≡|≠|∼|⋅|…"
    r"|\\[a-zA-Z]+"
    r")+"
)

ENGLISH_WORD = re.compile(r"^[a-z]{3,}$")

MATHISH = re.compile(r"[\\_^{}=<>+\-*/|0-9]")


def unwrap_article_wraps(line: str) -> str:
    return ARTICLE_WRAP.sub("A ", line)


def span_looks_mathish(inner: str) -> bool:
    s = inner.strip()
    if not s:
        return False
    if ENGLISH_WORD.fullmatch(s):
        return False
    if MATHISH.search(s):
        return True
    return len(s) <= 2 and s.isalnum()


def unwrap_inner_dollars_in_span(span: str) -> str:
    if not (span.startswith("$") and span.endswith("$") and span.count("$") >= 2):
        return span
    inner = span[1:-1]
    while True:
        new = re.sub(r"\$([^$\n]+)\$", r"\1", inner)
        if new == inner:
            break
        inner = new
    cleaned = fix_latex_body(inner)
    return f"${cleaned}$" if cleaned else span


def flatten_nested_inline_dollars(line: str) -> str:
    return re.sub(r"\$[^$\n]+\$", lambda m: unwrap_inner_dollars_in_span(m.group(0)), line)


def merge_adjacent_inline_spans(line: str) -> str:
    """Merge only when both adjacent spans look like math tokens, not English."""
    if "$$" in line:
        return line
    prev = None
    while prev != line:
        prev = line

        def merge_pair(m: re.Match[str]) -> str:
            left, right = m.group(1), m.group(3)
            lbody, rbody = left[1:-1].strip(), right[1:-1].strip()
            if not (span_looks_mathish(lbody) and span_looks_mathish(rbody)):
                return m.group(0)
            merged = fix_latex_body(f"{lbody} {rbody}")
            return f"${merged}$" if merged else m.group(0)

        line = re.sub(
            r"(\$[^$\n]+\$)(" + MATH_GLUE.pattern + r")(\$[^$\n]+\$)",
            merge_pair,
            line,
        )
    return line


def repair_fragmented_inline(line: str) -> str:
    if SKIP_LINE.match(line.strip()) or "$$" in line or line.strip().startswith("|"):
        return line
    line = unwrap_article_wraps(line)
    line = flatten_nested_inline_dollars(line)
    for _ in range(6):
        merged = merge_adjacent_inline_spans(line)
        if merged == line:
            break
        line = merged
        line = flatten_nested_inline_dollars(line)
    return line


def apply_doc_patches(text: str, doc_id: str) -> str:
    for pattern, repl in DOC_PATCHES.get(doc_id, []):
        if not repl:
            text = re.sub(pattern, "", text, flags=re.DOTALL)
        else:
            text = re.sub(pattern, lambda _m, r=repl: r, text, count=1, flags=re.DOTALL)
    return text


def render(segs: list[tuple[str, str]]) -> str:
    out: list[str] = []
    for kind, body in segs:
        if kind == "math":
            cleaned = repair_math_block(body)
            if cleaned:
                out.append("$$")
                out.append(cleaned)
                out.append("$$")
        else:
            chunk = convert_math_unicode_runs(body)
            chunk = convert_alt_delimiters(chunk)
            chunk = repair_inline_dollars(chunk)
            for line in chunk.splitlines():
                line = repair_fragmented_inline(line)
                out.append(wrap_bare_latex_in_prose(line))
    text = "\n".join(out)
    while "\n\n\n" in text:
        text = text.replace("\n\n\n", "\n\n")
    return text.rstrip() + "\n"


def repair_file(path: Path) -> bool:
    before = path.read_text(encoding="utf-8", errors="replace")
    text = fix_shattered_display_math(before)
    text = apply_doc_patches(text, path.stem)
    after = render(split_math_segments(text))
    if after != before:
        path.write_text(after, encoding="utf-8")
        return True
    return False


def doc_paths(compendium: str) -> list[Path]:
    root = COMPENDIA / compendium
    return sorted(
        p
        for p in root.glob("*.md")
        if p.name != "_CONTENTS.md" and not p.name.startswith("_")
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Repair math renderability in compendia")
    parser.add_argument(
        "compendia",
        nargs="*",
        default=["bars", "intersections"],
        help="Compendium folder names (default: bars intersections)",
    )
    args = parser.parse_args(argv)

    for comp in args.compendia:
        paths = doc_paths(comp)
        if not paths:
            print(f"— {comp}: no docs", file=sys.stderr)
            continue
        print(f"\n=== {comp} ===")
        for path in paths:
            changed = repair_file(path)
            print(f"{'OK' if changed else '—'} {path.stem}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
