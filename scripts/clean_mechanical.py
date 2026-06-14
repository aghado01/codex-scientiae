#!/usr/bin/env python3
r"""
clean_mechanical.py

Cleans common OCR and extraction artifacts from markdown files in-place:
1. Strips \intertext{...} lines inside $$ display math blocks.
2. Strips degenerate alignment '&' chains inside $$ display math blocks.
3. Strips char-per-line sequences (lines with <= 2 non-whitespace characters) in prose,
   while preserving list markers, headings, blockquotes, and math operators.
4. Collapses 3+ consecutive spaces in prose (outside display math, code blocks, and tables).

Usage:
  python scripts/clean_mechanical.py <file_or_directory_path>
"""

import sys
import re
from pathlib import Path

# Match lines containing only &, \\, and whitespace, with at least one &
DEGENERATE_AMP = re.compile(r'^\s*(?:&\s*|\\\\\s*)*$')

def should_strip_short_line(line: str) -> bool:
    stripped = line.strip()
    if not stripped:
        return False
    
    # Count non-whitespace characters
    non_ws = ''.join(stripped.split())
    if len(non_ws) > 2:
        return False
    
    # Preserve list markers: numbers (e.g. "1.", "1)"), letters ("a.", "a)"), or roman numerals ("i.", "iv)")
    if re.match(r'^\s*(?:\d+|[a-zA-Z]|[ivxldcmIVXLDCM]+)[\.)]\s*$', line):
        return False
    # Preserve markdown bullets ("-", "*", "+")
    if re.match(r'^\s*[-*+]\s*$', line):
        return False
    # Preserve markdown headings ("#", "##")
    if re.match(r'^\s*#+\s*$', line):
        return False
    # Preserve blockquotes (">")
    if re.match(r'^\s*>\s*$', line):
        return False
        
    # Preserve standalone math operators, brackets, punctuation symbols
    allowed_symbols = set('+-=<>*/^_~\\|!?:,.()[]{}%$&;`\'"')
    if set(non_ws).issubset(allowed_symbols):
        return False
        
    return True

def clean_content(text: str) -> str:
    lines = text.splitlines()
    cleaned_lines = []
    
    in_display_math = False
    in_code_block = False
    first_h1_seen = False
    
    for line in lines:
        stripped = line.strip()
        
        # Track code blocks
        if stripped.startswith("```"):
            in_code_block = not in_code_block
            cleaned_lines.append(line)
            continue
            
        if in_code_block:
            cleaned_lines.append(line)
            continue
            
        # Track display math blocks
        if stripped.startswith("$$"):
            in_display_math = not in_display_math
            cleaned_lines.append(line)
            continue
            
        if in_display_math:
            # 1. Strip \intertext{...} lines
            if '\\intertext{' in line:
                continue
                
            # 2. Strip degenerate & chains
            if '&' in stripped and DEGENERATE_AMP.match(stripped):
                continue
                
            # Strip \[ and \] if they are injected inside $$
            if stripped in ['\\[', '\\]']:
                continue
                
            cleaned_lines.append(line)
        else:
            # 3. Strip short char-per-line sequences
            if should_strip_short_line(line):
                continue

            # 4. Collapse 3+ consecutive spaces in prose, avoiding markdown tables
            if '|' not in line:
                line = re.sub(r' {3,}', ' ', line)

            # 5. Normalise bullet characters
            # "- • text"  →  "- text"  (Docling emits both a markdown dash and a unicode bullet)
            # "• text"    →  "- text"  (standalone unicode bullet → markdown list marker)
            line = re.sub(r'^(\s*)-\s+•\s+', r'\1- ', line)
            line = re.sub(r'^(\s*)•\s+', r'\1- ', line)

            # 6. Heading Demotion
            # Keep first H1 as document title, demote all subsequent H1s to H2
            if line.startswith('# '):
                if not first_h1_seen:
                    first_h1_seen = True
                else:
                    line = '#' + line

            # 7. Math Delimiter Standardization
            # Convert \( and \) to $, and \[ and \] to $$
            line = line.replace('\\(', '$').replace('\\)', '$')
            if stripped == '\\[' or stripped == '\\]':
                line = line.replace('\\[', '$$').replace('\\]', '$$')

            cleaned_lines.append(line)
            
    return '\n'.join(cleaned_lines) + '\n'

def process_path(path: Path):
    if path.is_file():
        if path.suffix.lower() == '.md':
            print(f"Cleaning mechanical artifacts in: {path.name}")
            orig_text = path.read_text(encoding='utf-8')
            cleaned_text = clean_content(orig_text)
            if orig_text != cleaned_text:
                path.write_text(cleaned_text, encoding='utf-8')
                print(f"  -> Modified {path.name}")
            else:
                print(f"  -> No changes needed for {path.name}")
    elif path.is_dir():
        for sub_path in sorted(path.glob('**/*.md')):
            # Skip hidden folders / scratch unless specifically requested (we allow scratch since it holds page slices)
            if any(part.startswith('.') and part != '.scratch' for part in sub_path.parts):
                continue
            process_path(sub_path)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python scripts/clean_mechanical.py <file_or_directory_path>")
        sys.exit(1)
        
    target = Path(sys.argv[1])
    if not target.exists():
        print(f"Error: Path '{target}' does not exist.")
        sys.exit(1)
        
    process_path(target)
    print("Mechanical cleaning pass complete.")
