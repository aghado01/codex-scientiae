"""
Validation pass for repaired page slices.

Checks each page_NNN.md in .scratch/ against codex-scientiae STANDARDS.md rules.
Read-only: writes a validation_report.md to .scratch/ and exits 1 if issues found.

Checks performed (all unambiguous — no false-positive risk):
  1. OCR ligatures still present (ﬁ ﬂ ﬃ ﬀ ﬄ)
  2. Alternate math delimiters \\[ \\] \\( \\) instead of $ / $$
  3. KaTeX / web-renderer macros (\\color, \\vspace, \\hspace, etc.)
  4. Floating bare equation numbers "(N)" on their own line outside a $$ block
  5. Unclosed $$ display-math blocks (opened but never closed)

Does NOT check:
  - Undelimited prose math (too context-dependent, high false-positive rate)
  - Heading hierarchy (content-dependent, checked after assembly)
  - Hard line-breaks (handled by Phase 6 ligature/wrap pass)
"""

import re
import sys
from pathlib import Path

LIGATURES = {"ﬁ": "fi", "ﬂ": "fl", "ﬃ": "ffi", "ﬀ": "ff", "ﬄ": "ffl"}

ALT_DELIMITERS = re.compile(r"\\\[|\\\]|\\\(|\\\)")
KATEX_MACROS = re.compile(r"\\(color|vspace|hspace|pagecolor|definecolor)\s*\{")
FLOATING_EQ_NUM = re.compile(r"^\s*\(\d+\)\s*$")


def check_page(path: Path) -> list[tuple[int, str]]:
    issues = []
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    in_code_block = False
    in_display_math = False
    display_open_line = None

    for i, line in enumerate(lines, 1):
        # Track fenced code blocks — skip all checks inside them
        stripped = line.strip()
        if stripped.startswith("```"):
            in_code_block = not in_code_block

        if in_code_block:
            continue

        # 1. OCR ligatures
        for lig, replacement in LIGATURES.items():
            if lig in line:
                issues.append((i, f"OCR ligature '{lig}' (→ '{replacement}'): …{line.strip()[:70]}"))

        # 2. Alternate math delimiters
        if ALT_DELIMITERS.search(line):
            issues.append((i, f"Alternate math delimiter \\[ \\] or \\( \\) — use $ or $$: …{line.strip()[:70]}"))

        # 3. KaTeX / web-specific macros
        m = KATEX_MACROS.search(line)
        if m:
            issues.append((i, f"Web-renderer macro '\\{m.group(1)}' not valid per STANDARDS §1: …{line.strip()[:70]}"))

        # 4. Floating equation number on its own line (outside display math)
        if FLOATING_EQ_NUM.match(line) and not in_display_math:
            issues.append((i, f"Floating equation number '{line.strip()}' — use \\tag{{N}} inside $$...$$"))

        # 5. Track $$ open/close for unclosed-block detection
        if stripped == "$$":
            if not in_display_math:
                in_display_math = True
                display_open_line = i
            else:
                in_display_math = False
                display_open_line = None

    if in_display_math:
        issues.append((display_open_line, "Unclosed $$ display-math block (no matching closing $$)"))

    return issues


def validate_scratch(scratch_dir: Path, target_pages: list[str] = None) -> int:
    if target_pages:
        page_files = []
        for p in target_pages:
            pf = scratch_dir / p
            if pf.exists():
                page_files.append(pf)
    else:
        page_files = sorted(scratch_dir.glob("page_???.md"))

    if not page_files:
        print(f"No page_*.md files found in {scratch_dir} matching criteria", file=sys.stderr)
        sys.exit(1)

    paper_name = scratch_dir.parent.name
    sections = []
    total = 0

    for pf in page_files:
        issues = check_page(pf)
        if issues:
            block = [f"## {pf.name}\n"]
            for line_no, msg in issues:
                block.append(f"- Line {line_no}: {msg}")
            block.append("")
            sections.append("\n".join(block))
            total += len(issues)

    header = [f"# Validation Report — {paper_name}\n"]
    if total == 0:
        header.append("All targeted page slices passed validation.\n")
    else:
        header.append(
            f"> **{total} issue(s)** across {len([s for s in sections])} page file(s). "
            f"Address in page slices before running assemble_pages.py.\n"
        )

    report_text = "\n".join(header) + "\n" + "\n".join(sections)

    report_file = scratch_dir / "validation_report.md"
    report_file.write_text(report_text, encoding="utf-8")
    print(report_text)
    print(f"\n[Report written to {report_file}]", file=sys.stderr)

    return total


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python validate_pages.py <scratch_dir> [page_001.md page_002.md ...]")
        sys.exit(1)

    scratch_dir = Path(sys.argv[1])
    target_pages = sys.argv[2:] if len(sys.argv) > 2 else None

    exit_code = validate_scratch(scratch_dir, target_pages)
    sys.exit(0 if exit_code == 0 else 1)
