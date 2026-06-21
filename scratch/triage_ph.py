import re
import sys
from pathlib import Path

compendia_path = Path("compendia/ph")
references_path = compendia_path / "references"

LIGATURES = ["ﬁ", "ﬂ", "ﬃ", "ﬀ", "ﬄ"]
ALT_DELIMITERS = re.compile(r"\\\[|\\\]|\\\(|\\\)")
KATEX_MACROS = re.compile(r"\\(color|vspace|hspace|pagecolor|definecolor)\s*\{")
FLOATING_EQ_NUM = re.compile(r"^\s*\(\d+\)\s*$")

def triage_file(p: Path):
    content = p.read_text(encoding='utf-8')
    lines = content.splitlines()
    
    issues = []
    
    # 1. Heading hierarchy check
    h_levels = []
    has_contents = False
    contents_start = -1
    contents_links = []
    
    in_code_block = False
    in_display_math = False
    display_open_line = None
    
    h1_count = 0
    h2_after_h1 = True
    hierarchy_errors = []
    
    # Track headings
    for idx, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped.startswith("```"):
            in_code_block = not in_code_block
            continue
        if in_code_block:
            continue
            
        if stripped.startswith("$$"):
            in_display_math = not in_display_math
            continue
        if in_display_math:
            continue
            
        # Check headings
        if stripped.startswith("# "):
            h1_count += 1
            h_levels.append((idx, 1, stripped))
        elif stripped.startswith("## "):
            h_levels.append((idx, 2, stripped))
            if stripped == "## Contents" or stripped == "## Table of Contents":
                has_contents = True
                contents_start = idx
        elif stripped.startswith("### "):
            h_levels.append((idx, 3, stripped))
        elif stripped.startswith("#### "):
            h_levels.append((idx, 4, stripped))
            
        # Math & ligatures validation
        for lig in LIGATURES:
            if lig in line:
                issues.append(f"Line {idx}: OCR Ligature '{lig}' found: {line[:50]}")
                
        if ALT_DELIMITERS.search(line):
            issues.append(f"Line {idx}: Alternate math delimiters (\\( or \\[) found: {line[:50]}")
            
        if KATEX_MACROS.search(line):
            issues.append(f"Line {idx}: KaTeX / web-specific macro found: {line[:50]}")
            
        if FLOATING_EQ_NUM.match(line) and not in_display_math:
            issues.append(f"Line {idx}: Floating equation number found: {stripped}")
            
    # Heading hierarchy validation
    if h1_count > 1:
        hierarchy_errors.append(f"Multiple H1 headings ({h1_count}) found.")
    elif h1_count == 0:
        hierarchy_errors.append("No H1 heading found.")
        
    last_level = 1
    for idx, lvl, text in h_levels:
        if lvl == 1 and idx != h_levels[0][0]:
            hierarchy_errors.append(f"Line {idx}: H1 heading '{text}' is not at the top of the file.")
        if lvl > last_level + 1:
            hierarchy_errors.append(f"Line {idx}: Heading level skipped from H{last_level} to H{lvl}: '{text}'")
        last_level = lvl
        
    # Check Contents links
    if has_contents and contents_start != -1:
        # scan for links in contents
        for idx in range(contents_start, len(lines)):
            line = lines[idx].strip()
            if line.startswith("## ") and not (line.startswith("## Contents") or line.startswith("## Table of Contents")):
                break
            # Find links like [References](references/PAPER.md) or [Introduction](#introduction)
            links = re.findall(r'\[([^\]]+)\]\(([^)]+)\)', line)
            for text, url in links:
                contents_links.append((idx + 1, text, url))
                
        ref_link_found = False
        for l_idx, text, url in contents_links:
            if "references/" in url:
                ref_link_found = True
                expected_url = f"references/{p.name}"
                if url != expected_url:
                    issues.append(f"Line {l_idx}: Contents references link points to '{url}' but expected '{expected_url}'")
        if not ref_link_found:
            issues.append("Contents section has no link to the references sidecar file.")
    else:
        issues.append("Missing '## Contents' section.")
        
    # Check sidecar references file
    ref_file = references_path / p.name
    if not ref_file.exists():
        issues.append(f"Sidecar references file '{ref_file.name}' is missing.")
    else:
        ref_content = ref_file.read_text(encoding='utf-8')
        ref_lines = ref_content.splitlines()
        if not ref_lines:
            issues.append(f"Sidecar references file '{ref_file.name}' is empty.")
        else:
            expected_ref_h1 = f"# References — {p.stem}"
            actual_ref_h1 = ref_lines[0].strip()
            if actual_ref_h1 != expected_ref_h1:
                issues.append(f"Sidecar references file '{ref_file.name}' has incorrect title: '{actual_ref_h1}' (expected '{expected_ref_h1}')")
            # Check for ligatures in references
            for r_idx, r_line in enumerate(ref_lines, 1):
                for lig in LIGATURES:
                    if lig in r_line:
                        issues.append(f"References sidecar Line {r_idx}: OCR Ligature '{lig}' found: {r_line[:50]}")
                        
    all_issues = hierarchy_errors + issues
    return all_issues

def main():
    papers = sorted([p for p in compendia_path.glob("*.md") if p.name != "_CONTENTS.md"])
    print(f"Triaging {len(papers)} papers in {compendia_path}...")
    
    total_issues = 0
    for p in papers:
        issues = triage_file(p)
        if issues:
            print(f"\n=== {p.name} ({len(issues)} issues) ===")
            for iss in issues:
                print(f"  - {iss}")
            total_issues += len(issues)
        else:
            print(f"  {p.name}: OK")
            
    print(f"\nTotal issues found: {total_issues}")

if __name__ == "__main__":
    main()
