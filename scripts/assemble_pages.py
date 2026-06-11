import re
import sys
from pathlib import Path

PAGE_MARKER = re.compile(r'^\[Page \d+\]\n?', re.MULTILINE)
REFS_HEADING = re.compile(r'^#{1,2}\s+References\b', re.MULTILINE | re.IGNORECASE)

def assemble_pages(scratch_dir, body_out_path, refs_out_path=None):
    scratch_dir = Path(scratch_dir)
    body_out_path = Path(body_out_path)

    if refs_out_path is None:
        refs_out_path = body_out_path.parent / "references" / f"{body_out_path.stem}.md"
    else:
        refs_out_path = Path(refs_out_path)

    page_files = sorted(scratch_dir.glob("page_???.md"))
    if not page_files:
        print(f"No page_*.md files found in {scratch_dir}", file=sys.stderr)
        sys.exit(1)

    chunks = []
    for pf in page_files:
        content = pf.read_text(encoding="utf-8")
        # Strip the leading [Page N] marker from each slice
        content = PAGE_MARKER.sub("", content, count=1).strip()
        if content:
            chunks.append(content)

    full_text = "\n\n".join(chunks)

    # Split off References section if present
    refs_match = REFS_HEADING.search(full_text)
    if refs_match:
        body = full_text[:refs_match.start()].rstrip()
        refs_body = full_text[refs_match.start():]

        canonical_heading = f"# References — {body_out_path.stem}"
        refs_body = REFS_HEADING.sub(canonical_heading, refs_body, count=1)

        refs_out_path.parent.mkdir(parents=True, exist_ok=True)
        refs_out_path.write_text(refs_body.strip() + "\n", encoding="utf-8")
        print(f"References  → {refs_out_path}")
    else:
        body = full_text
        print("No References section detected — writing body only.", file=sys.stderr)

    body_out_path.parent.mkdir(parents=True, exist_ok=True)
    body_out_path.write_text(body.strip() + "\n", encoding="utf-8")
    print(f"Body        → {body_out_path}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python assemble_pages.py <scratch_dir> <body_output.md> [refs_output.md]")
        sys.exit(1)

    refs_arg = sys.argv[3] if len(sys.argv) > 3 else None
    assemble_pages(sys.argv[1], sys.argv[2], refs_arg)
