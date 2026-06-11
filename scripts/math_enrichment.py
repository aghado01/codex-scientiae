import json
import sys
from collections import defaultdict
from pathlib import Path

# Common LaTeX math fonts found in PDFs (Computer Modern Math Italic, Symbols, Extensions)
# CMR (Roman) is excluded by default as it is often used for standard text or numbers,
# but can be added if your specific PDFs use it exclusively for math.
MATH_FONTS = ["CMMI", "CMSY", "CMEX", "CMM", "Math", "Symbol"]

def is_math_font(font_name):
    if not font_name:
        return False
    return any(math_indicator in font_name for math_indicator in MATH_FONTS)

def extract_and_wrap_math(json_filepath):
    with open(json_filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Group output by page number, preserving document order within each page
    pages = defaultdict(list)

    def traverse(node):
        """Recursively collect paragraphs and formulas, grouped by page number."""
        if isinstance(node, dict):
            page = node.get("page number", 0)

            # Capture display equations from formula nodes
            if node.get("type") == "formula":
                content = node.get("content", "").strip()
                if content:
                    pages[page].append(f"$$\n{content}\n$$")

            # Reconstruct paragraph text from child spans, wrapping math fonts
            elif node.get("type") == "paragraph":
                kids = node.get("kids", [])
                if kids:
                    para_text = ""
                    for kid in kids:
                        text = kid.get("content", "")
                        font = kid.get("font", "")
                        stripped_text = text.strip()
                        if stripped_text and is_math_font(font):
                            para_text += text.replace(stripped_text, f"${stripped_text}$")
                        else:
                            para_text += text
                    if para_text.strip():
                        pages[page].append(para_text)
                else:
                    # Fallback: paragraph has no kids but has direct content
                    content = node.get("content", "").strip()
                    if content:
                        pages[page].append(content)

            # Continue traversing down the tree
            for value in node.values():
                traverse(value)

        elif isinstance(node, list):
            for item in node:
                traverse(item)

    traverse(data)
    return pages

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python math_enrichment.py <path_to_docling.json>")
        sys.exit(1)

    json_path = Path(sys.argv[1])
    pages = extract_and_wrap_math(json_path)

    scratch_dir = json_path.parent / ".scratch"
    scratch_dir.mkdir(exist_ok=True)

    # Write monolithic temp_math.md for triage overview
    mono_lines = ["--- ENRICHED TEXT OUTPUT ---"]
    for page_num in sorted(pages.keys()):
        mono_lines.append(f"\n[Page {page_num}]\n")
        for item in pages[page_num]:
            clean = item.replace(" . ", ".").replace(" ,", ",")
            mono_lines.append(clean)
            mono_lines.append("")
    (scratch_dir / "temp_math.md").write_text("\n".join(mono_lines), encoding="utf-8")

    # Write per-page math artifacts coordinated with page_NNN.md slice filenames
    for page_num in sorted(pages.keys()):
        page_lines = [f"[Page {page_num}]\n"]
        for item in pages[page_num]:
            clean = item.replace(" . ", ".").replace(" ,", ",")
            page_lines.append(clean)
            page_lines.append("")
        page_file = scratch_dir / f"page_{page_num:03d}_math.md"
        page_file.write_text("\n".join(page_lines), encoding="utf-8")

    print(f"[Written: temp_math.md + {len(pages)} page_NNN_math.md files → {scratch_dir}]", file=sys.stderr)
