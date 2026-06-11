import re
import sys
from pathlib import Path

PAGE_MARKER = re.compile(r'^\[Page (\d+)\]$', re.MULTILINE)

def split_pages(md_path):
    md_path = Path(md_path)
    text = md_path.read_text(encoding="utf-8")

    markers = list(PAGE_MARKER.finditer(text))
    if not markers:
        print("No [Page N] markers found in document.", file=sys.stderr)
        sys.exit(1)

    scratch_dir = md_path.parent / ".scratch"
    scratch_dir.mkdir(exist_ok=True)

    slices = []

    # Preamble: anything before the first [Page N] marker
    if markers[0].start() > 0:
        preamble = text[:markers[0].start()].strip()
        if preamble:
            slices.append(("000", preamble))

    # Each page: from its marker to the next marker (or end of file)
    for i, marker in enumerate(markers):
        page_num = int(marker.group(1))
        start = marker.start()
        end = markers[i + 1].start() if i + 1 < len(markers) else len(text)
        chunk = text[start:end].strip()
        slices.append((f"{page_num:03d}", chunk))

    written = []
    for num, content in slices:
        out_file = scratch_dir / f"page_{num}.md"
        out_file.write_text(content + "\n", encoding="utf-8")
        written.append(str(out_file))
        print(f"  {out_file.name}")

    print(f"\n[{len(written)} page files written to {scratch_dir}]", file=sys.stderr)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python split_pages.py <path_to_PAPER.md>")
        sys.exit(1)
    split_pages(sys.argv[1])
