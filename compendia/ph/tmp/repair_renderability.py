#!/usr/bin/env python3
"""Forward repair: make math renderable per STANDARDS.md ($ inline, $$ block).

Repairs broken spans — never strips delimiters to leave bare LaTeX.
"""

from __future__ import annotations

import re
from pathlib import Path

PH = Path(__file__).resolve().parents[1]

DOCS = sorted(
    p.stem
    for p in PH.glob("*.md")
    if p.name != "_CONTENTS.md" and not p.name.startswith("_")
)

SKIP_LINE = re.compile(r"^(#{1,6}\s|!\[|\s*- \[|```|\[Page )")

# English / prose trapped inside $...$ by bad token-wrapping
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

LATEX_CMD_START = re.compile(
    r"\\(?:mathcal|mathbb|mathrm|mathbf|mathit|frac|sum|prod|int|min|max|lim|"
    r"sup|inf|hat|tilde|bar|vec|sqrt|left|right|text|mathrm|coloneqq|subset|"
    r"supset|in|notin|leq|geq|neq|equiv|sim|cong|otimes|oplus|wedge|vee|"
    r"forall|exists|partial|nabla|infty|to|mapsto|cdot|times|tag|begin|end|"
    r"bigcup|bigcap|bigoplus|bigsqcup|mathrm|operatorname)"
)


def fix_latex_body(s: str) -> str:
    """Fix OCR corruption inside a math span; keep it math."""
    s = STAR_SUB.sub("_", s)
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
    s = re.sub(r"\$([^$]+)\$", r"\1", s)  # nested $ inside math only
    s = re.sub(r"\s+", " ", s).strip()
    return s


def split_prose_from_math_span(inner: str) -> list[tuple[str, str]]:
    """Split a corrupted $ span into ('math'|'prose', text) pieces."""
    inner = inner.strip()
    if not PROSE_IN_MATH.search(inner):
        return [("math", fix_latex_body(inner))]

    parts: list[tuple[str, str]] = []
    pos = 0
    for m in PROSE_IN_MATH.finditer(inner):
        before = inner[pos : m.start()].strip()
        if before:
            parts.append(("math", fix_latex_body(before)))
        prose = m.group(0).strip()
        parts.append(("prose", prose))
        pos = m.end()
    tail = inner[pos:].strip()
    if tail:
        # trailing period after math command is prose punctuation
        if tail.endswith(".") and LATEX_CMD_START.search(tail[:-1] or tail):
            body = tail[:-1].strip()
            if body:
                parts.append(("math", fix_latex_body(body)))
            parts.append(("prose", "."))
        else:
            parts.append(("math", fix_latex_body(tail)))
    return parts


def fix_subscript_unicode(s: str) -> str:
    s = s.replace("_{leq}", r"_{\leq}")
    s = s.replace("_{geq}", r"_{\geq}")
    s = re.sub(r"(?<![\\a-zA-Z])leq(?=_|\{)", r"\\leq", s)
    s = re.sub(r"(?<![\\a-zA-Z])geq(?=_|\{)", r"\\geq", s)
    s = re.sub(r"\\\\coloneqq", r"\\coloneqq", s)
    return s


def is_mistaken_english_wrap(inner: str) -> bool:
    """$...$ that contains no LaTeX — OCR wrapped prose by mistake."""
    s = inner.strip().rstrip(".")
    if not s or re.search(r"\\|[_^{}=<>+\-*/|0-9]", s):
        return False
    return bool(re.fullmatch(r"[A-Za-z][A-Za-z\s,':;.\-]*", s))


def repair_inline_dollars(text: str) -> str:
    """Repair $...$ spans: fix content, eject prose, keep math wrapped."""

    def repl(m: re.Match[str]) -> str:
        inner = m.group(1)
        if is_mistaken_english_wrap(inner):
            return inner.strip()  # repair: prose should not be in math delimiters
        inner = fix_subscript_unicode(inner)
        pieces = split_prose_from_math_span(inner)
        out: list[str] = []
        for kind, chunk in pieces:
            if kind == "prose":
                word = chunk.strip(".,;:!? ")
                if word.lower() in {
                    "where", "whenever", "since", "thus", "hence", "therefore",
                    "moreover", "similarly", "clearly", "in", "particular",
                    "a", "set", "we", "define", "the", "mouth", "of",
                } or word in {"Since", "We", "A", "In", "Moreover"}:
                    out.append(word + ("" if chunk.endswith((" ", "")) else ""))
                else:
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
    """Wrap bare \\command expressions still outside $ delimiters."""
    if SKIP_LINE.match(line.strip()) or "$$" in line or line.strip().startswith("|"):
        return line
    if "$" in line:
        return line  # already partially wrapped; inline repair handled it

    # Full-line or clause with latex commands but no $
    if not LATEX_CMD_START.search(line) and not re.search(r"\\[a-zA-Z]", line):
        return line

    # Split on sentence boundaries; wrap latex-heavy clauses
    clauses = re.split(r"(?<=[.;])\s+", line)
    out: list[str] = []
    for clause in clauses:
        c = clause.strip()
        if not c:
            continue
        if re.search(r"\\[a-zA-Z]", c):
            # wrap contiguous latex runs
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
            chunk = convert_alt_delimiters(body)
            chunk = repair_inline_dollars(chunk)
            for line in chunk.splitlines():
                out.append(wrap_bare_latex_in_prose(line))
    text = "\n".join(out)
    while "\n\n\n" in text:
        text = text.replace("\n\n\n", "\n\n")
    return text.rstrip() + "\n"


def repair_doc(doc_id: str) -> bool:
    path = PH / f"{doc_id}.md"
    before = path.read_text(encoding="utf-8", errors="replace")
    after = render(split_math_segments(before))
    if after != before:
        path.write_text(after, encoding="utf-8")
        return True
    return False


def main() -> None:
    for doc_id in DOCS:
        changed = repair_doc(doc_id)
        print(f"{'OK' if changed else '—'} {doc_id}")


if __name__ == "__main__":
    main()
