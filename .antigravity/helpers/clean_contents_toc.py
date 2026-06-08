#!/usr/bin/env python3
"""Clean the CONTENTS.md TOC entries.
Replace patterns like "— 19 (bytes 614-11366)" with "— bytes 614-11366".
"""
import re
from pathlib import Path

repo_root = Path(r"C:\Users\azrie\PDenv\UserGithub\codex-scientiae")
contents_path = repo_root / "codices" / "Grimmett2006" / "Chapters" / "CONTENTS.md"

text = contents_path.read_text(encoding='utf-8')
# Regex: em dash or two hyphens, optional spaces, number, optional spaces, (bytes start-end)
pattern = re.compile(r"(—|--)\s*\d+\s*\(bytes\s+(\d+-\d+)\)")
new_text = pattern.sub(r"— bytes \2", text)
# Also handle cases where there is a stray dash before bytes without parentheses (unlikely)
contents_path.write_text(new_text, encoding='utf-8')
print(f"Cleaned TOC entries in {contents_path}")
