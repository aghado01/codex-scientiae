import sys
import re
from pathlib import Path

def parse_manifest(manifest_path):
    content = manifest_path.read_text(encoding="utf-8")
    
    # Parse REPAIR blocks (Math & Prose)
    # Regex looks for:
    # - RAW: ```
    # {raw}
    # ```
    #   FIX: ```
    # {fix}
    # ```
    repair_pattern = re.compile(
        r'- RAW:\s*```\n(.*?)```\s*FIX:\s*```\n(.*?)```',
        re.DOTALL
    )
    repairs = repair_pattern.findall(content)
    
    # Parse REPLACE_TABLES blocks
    # - USE_ARTIFACT: {artifact}
    #   REPLACE_FROM: `{from}`
    #   REPLACE_TO: `{to}`
    table_pattern = re.compile(
        r'-\s*USE_ARTIFACT:\s*(.*?)\n\s*REPLACE_FROM:\s*`(.*?)`\n\s*REPLACE_TO:\s*`(.*?)`'
    )
    tables = table_pattern.findall(content)
    
    return repairs, tables

def get_table_artifact(artifact_link, scratch_dir):
    if "#" not in artifact_link:
        return ""
    filename, anchor = artifact_link.split("#", 1)
    artifact_path = scratch_dir / filename
    if not artifact_path.exists():
        return ""
    
    lines = artifact_path.read_text(encoding="utf-8").splitlines()
    table_lines = []
    in_table = False
    for line in lines:
        if line.startswith(f"### {anchor}"):
            in_table = True
            continue
        if in_table:
            if line.startswith("### "):
                break
            table_lines.append(line)
    return "\n".join(table_lines).strip()

def make_agnostic_regex(raw_str):
    escaped = re.escape(raw_str.strip())
    # Replace literal escaped spaces and newlines with \s+
    agnostic = re.sub(r'\\ ', r'\\s+', escaped)
    agnostic = re.sub(r'\\\n', r'\\s+', agnostic)
    return re.compile(agnostic)

def _fix_is_display_fenced(fix_clean):
    """Return True if fix_clean is a standalone $$...$$  display block."""
    lines = fix_clean.splitlines()
    return len(lines) >= 2 and lines[0].strip() == '$$' and lines[-1].strip() == '$$'

def _match_is_already_display_fenced(page_content, match_start, match_end):
    """Return True if the matched span is already wrapped in standalone $$ fence lines."""
    before = page_content[:match_start]
    after  = page_content[match_end:]
    before_ok = bool(re.search(r'\n\$\$[ \t]*\n[ \t]*$', before))
    after_ok  = bool(re.match(r'[ \t]*\n[ \t]*\$\$', after))
    return before_ok and after_ok

def _fix_is_inline_fenced(fix_clean):
    """Return True if fix_clean is $...$ or \(...\) inline block."""
    fix_clean = fix_clean.strip()
    return (fix_clean.startswith('$') and fix_clean.endswith('$') and not fix_clean.startswith('$$')) or \
           (fix_clean.startswith('\\(') and fix_clean.endswith('\\)'))

def _match_is_already_inline_fenced(page_content, match_start, match_end):
    """Return True if the matched span is already wrapped in $...$ or \(...\) inline."""
    before = page_content[:match_start].rstrip()
    after  = page_content[match_end:].lstrip()
    return (before.endswith('$') and after.startswith('$')) or \
           (before.endswith('\\(') and after.startswith('\\)'))

def _resolve_fix(fix_clean, page_content, match_start, match_end):
    """Strip redundant outer fences from fix_clean when the match is already fenced."""
    if _fix_is_display_fenced(fix_clean) and _match_is_already_display_fenced(page_content, match_start, match_end):
        lines = fix_clean.splitlines()
        return '\n'.join(lines[1:-1])   # inner content only
        
    if _fix_is_inline_fenced(fix_clean) and _match_is_already_inline_fenced(page_content, match_start, match_end):
        if fix_clean.startswith('$'):
            return fix_clean[1:-1]
        else:
            return fix_clean[2:-2]
            
    return fix_clean

def apply_manifest(manifest_path):
    manifest_path = Path(manifest_path)
    scratch_dir = manifest_path.parent
    
    # Deducing page_NNN.md from manifest_NNN.md
    page_filename = manifest_path.name.replace("manifest_", "page_")
    page_path = scratch_dir / page_filename
    
    if not page_path.exists():
        print(f"Error: {page_path} not found.", file=sys.stderr)
        sys.exit(1)
        
    repairs, tables = parse_manifest(manifest_path)
    page_content = page_path.read_text(encoding="utf-8")
    
    # 1. Apply Tables
    for artifact_link, replace_from, replace_to in tables:
        if replace_from == "FILL_ME_IN" or replace_to == "FILL_ME_IN":
            continue # Skipped by agent
            
        table_md = get_table_artifact(artifact_link, scratch_dir)
        
        from_idx = page_content.find(replace_from)
        if from_idx != -1:
            to_idx = page_content.find(replace_to, from_idx)
            if to_idx != -1:
                to_idx += len(replace_to)
                page_content = page_content[:from_idx] + "\n\n" + table_md + "\n\n" + page_content[to_idx:]
            else:
                print(f"Warning: REPLACE_TO anchor '{replace_to}' not found.", file=sys.stderr)
        else:
            print(f"Warning: REPLACE_FROM anchor '{replace_from}' not found.", file=sys.stderr)
            
    # 2. Apply Repairs (Math & Prose)
    for raw, fix in repairs:
        raw_clean = raw.strip()
        fix_clean = fix.strip()

        if not raw_clean:
            continue

        # Fast path: exact string match — use index so we know position for fence check
        idx = page_content.find(raw_clean)
        if idx != -1:
            end = idx + len(raw_clean)
            effective_fix = _resolve_fix(fix_clean, page_content, idx, end)
            page_content = page_content[:idx] + effective_fix + page_content[end:]
        else:
            # Fallback: whitespace-agnostic match — find first, then splice
            regex = make_agnostic_regex(raw_clean)
            match = regex.search(page_content)
            if match:
                effective_fix = _resolve_fix(fix_clean, page_content, match.start(), match.end())
                page_content = page_content[:match.start()] + effective_fix + page_content[match.end():]
            
    page_path.write_text(page_content, encoding="utf-8")
    print(f"Successfully applied {manifest_path.name} to {page_path.name}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python apply_manifest.py <path_to_manifest_NNN.md>")
        sys.exit(1)
        
    apply_manifest(sys.argv[1])
