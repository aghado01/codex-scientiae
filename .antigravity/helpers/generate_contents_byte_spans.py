#!/usr/bin/env python3
"""Generate a JSON file containing byte offset spans for each TOC entry in CONTENTS.md.
The script walks through all chapter markdown files, records the byte offset of every
<a id="..."> anchor, then matches the links in CONTENTS.md and produces a JSON
array with the following fields for each entry:
    - chapter: the markdown filename (e.g. "Chapter01.Random-Cluster Measures.md")
    - anchor: the anchor identifier (e.g. "sec-1-1")
    - startByte: inclusive start byte offset of the anchor tag
    - endByte: inclusive end byte offset of the section (up to the next anchor or EOF)
    - lineText: the original line from CONTENTS.md (trimmed)
The output is written to ``.antigravity/helpers/contents_byte_spans.json``.
"""
import os
import re
import json
import sys
from pathlib import Path

# ------------------------------------------------------------
# Configuration – adjust if the repository layout changes
# ------------------------------------------------------------
repo_root = Path(r"D:\aghado01\codex-scientiae")
contents_path = repo_root / "codices" / "Grimmett2006" / "Chapters" / "CONTENTS.md"
chapter_dir = repo_root / "codices" / "Grimmett2006" / "Chapters"
output_path = repo_root / ".antigravity" / "helpers" / "contents_byte_spans.json"

# ------------------------------------------------------------
# Helper: compute byte offsets of <a id="..."> tags in a file
# ------------------------------------------------------------
anchor_map = {}  # {chapter_filename: {anchor_id: start_byte}}
anchor_pattern = re.compile(r'<a\s+id="([^"]+)">')

for chapter_file in sorted(chapter_dir.glob("Chapter??*.md")):
    filename = chapter_file.name
    with chapter_file.open('rb') as f:
        data = f.read()  # raw bytes (UTF‑8)
    text = data.decode('utf-8')
    offsets = {}
    for match in anchor_pattern.finditer(text):
        anchor = match.group(1)
        # byte offset of the start of the match
        start_byte = len(text[:match.start()].encode('utf-8'))
        offsets[anchor] = start_byte
    anchor_map[filename] = offsets

# ------------------------------------------------------------
# Helper to obtain the end offset for a given anchor
# ------------------------------------------------------------
def get_end_offset(filename: str, anchor: str) -> int:
    anchors = sorted(anchor_map[filename].keys())
    idx = anchors.index(anchor)
    if idx + 1 < len(anchors):
        next_anchor = anchors[idx + 1]
        return anchor_map[filename][next_anchor] - 1
    else:
        # EOF offset – file size minus one (inclusive)
        return chapter_dir.joinpath(filename).stat().st_size - 1

# ------------------------------------------------------------
# Parse CONTENTS.md and collect entries
# ------------------------------------------------------------
entries = []
link_pattern = re.compile(r"\(([^)#]+)\.md#([^\)]+)\)")
with contents_path.open('r', encoding='utf-8') as f:
    for raw_line in f:
        line = raw_line.rstrip('\n')
        m = link_pattern.search(line)
        if not m:
            continue
        raw_file = m.group(1)  # may contain %20
        anchor_part = m.group(2)
        decoded_file = raw_file.replace('%20', ' ') + '.md'
        # Anchor may contain additional "#" fragments; keep the last segment
        anchor = anchor_part.split('#')[-1]
        if decoded_file in anchor_map and anchor in anchor_map[decoded_file]:
            start = anchor_map[decoded_file][anchor]
            end = get_end_offset(decoded_file, anchor)
            entry = {
                "chapter": decoded_file,
                "anchor": anchor,
                "startByte": start,
                "endByte": end,
                "lineText": line.strip()
            }
            entries.append(entry)

# ------------------------------------------------------------
# Write JSON output (pretty‑printed)
# ------------------------------------------------------------
output_path.parent.mkdir(parents=True, exist_ok=True)
with output_path.open('w', encoding='utf-8') as f:
    json.dump(entries, f, indent=2)
print(f"Generated JSON with {len(entries)} entries at {output_path}")
