#!/usr/bin/env python3
"""
generate_toc.py

Extracts H2 (##) and H3 (###) headers from a markdown file and automatically
inserts/updates a Table of Contents (TOC) block right before the first H2 heading.

If a TOC block (starting with '## Contents' or '## Table of Contents') already
exists, the script will replace it with the updated TOC.

Usage:
  python scripts/generate_toc.py <markdown_file_path> [--h3]
"""

import sys
import re
from pathlib import Path

def slugify(heading_text: str) -> str:
    # 1. Check if the heading text contains an HTML anchor tag, e.g. <a id="sec-1-1">
    anchor_match = re.search(r'<a\s+id="([^"]+)">', heading_text)
    if anchor_match:
        return anchor_match.group(1)
        
    # 2. Otherwise, strip any HTML tags to get the raw text
    clean_text = re.sub(r'<[^>]+>', '', heading_text)
    
    # 3. Slugify the raw text: lowercase, replace spaces/punctuation with hyphens
    slug = clean_text.lower().strip()
    slug = re.sub(r'[\s\.\,\(\)\[\]\{\}\:\/\?\!\#\+\*\=\&]+', '-', slug)
    slug = re.sub(r'-+', '-', slug)
    return slug.strip('-')

def clean_label(heading_text: str) -> str:
    # Remove HTML tags (like <a id="...">) and clean up whitespace
    clean_text = re.sub(r'<[^>]+>', '', heading_text)
    return clean_text.strip()

def build_toc(lines: list, include_h3: bool) -> tuple[str, int, int]:
    """
    Finds all headings and builds the TOC markdown.
    Also returns the start and end line indices of an existing TOC block (if found).
    """
    toc_entries = []
    
    existing_toc_start = -1
    existing_toc_end = -1
    
    in_code_block = False
    in_display_math = False
    
    first_h2_idx = -1
    
    for idx, line in enumerate(lines):
        stripped = line.strip()
        
        # Skip inside code blocks
        if stripped.startswith("```"):
            in_code_block = not in_code_block
            continue
        if in_code_block:
            continue
            
        # Skip inside display math
        if stripped.startswith("$$"):
            in_display_math = not in_display_math
            continue
        if in_display_math:
            continue
            
        # Check for existing TOC header to replace
        if stripped in ["## Contents", "## Table of Contents"]:
            existing_toc_start = idx
            # Scan forward to find where the TOC block ends (empty line or next heading)
            for j in range(idx + 1, len(lines)):
                next_stripped = lines[j].strip()
                # TOC ends when we hit another heading or a line that isn't a list item or empty
                if next_stripped.startswith('#') or (next_stripped and not next_stripped.startswith('-') and not next_stripped.startswith('*') and not re.match(r'^\s*\d+\.', next_stripped)):
                    existing_toc_end = j
                    break
            else:
                existing_toc_end = len(lines)
            continue
            
        # Match headings
        if stripped.startswith('## '):
            heading_text = line.split('## ', 1)[1]
            # Make sure this isn't the Contents heading itself
            if clean_label(heading_text) in ["Contents", "Table of Contents"]:
                continue
                
            if first_h2_idx == -1:
                first_h2_idx = idx
                
            label = clean_label(heading_text)
            anchor = slugify(heading_text)
            toc_entries.append(f"- [{label}](#{anchor})")
            
        elif include_h3 and stripped.startswith('### '):
            heading_text = line.split('### ', 1)[1]
            label = clean_label(heading_text)
            anchor = slugify(heading_text)
            toc_entries.append(f"  - [{label}](#{anchor})")
            
    toc_block = "## Contents\n\n" + '\n'.join(toc_entries) + "\n"
    return toc_block, existing_toc_start, existing_toc_end, first_h2_idx

def process_file(file_path: Path, include_h3: bool):
    content = file_path.read_text(encoding='utf-8')
    lines = content.splitlines()
    
    toc_block, start_idx, end_idx, first_h2_idx = build_toc(lines, include_h3)
    
    if start_idx != -1:
        # Replace existing TOC block
        print(f"Updating existing Table of Contents in: {file_path.name}")
        new_lines = lines[:start_idx] + [toc_block] + lines[end_idx:]
    elif first_h2_idx != -1:
        # Inject TOC before the first H2 heading
        print(f"Injecting Table of Contents before first H2 heading in: {file_path.name}")
        new_lines = lines[:first_h2_idx] + ["", toc_block, ""] + lines[first_h2_idx:]
    else:
        print(f"No H2 headings found in {file_path.name}. Cannot generate TOC.", file=sys.stderr)
        return
        
    new_content = '\n'.join(new_lines) + '\n'
    # Normalize double blank lines around injected TOC block
    new_content = re.sub(r'\n{3,}', '\n\n', new_content)
    
    file_path.write_text(new_content, encoding='utf-8')
    print("Table of Contents generated successfully.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python scripts/generate_toc.py <markdown_file_path> [--h3]")
        sys.exit(1)
        
    target_path = Path(sys.argv[1])
    if not target_path.exists() or not target_path.is_file():
        print(f"Error: File '{target_path}' does not exist or is not a file.", file=sys.stderr)
        sys.exit(1)
        
    include_h3 = "--h3" in sys.argv
    process_file(target_path, include_h3)
