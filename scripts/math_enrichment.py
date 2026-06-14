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
                    pages[page].append(("REPAIR_MATH", content, f"$$\n{content}\n$$"))

            # Reconstruct paragraph text from child spans, wrapping math fonts
            elif node.get("type") == "paragraph":
                kids = node.get("kids", [])
                if kids:
                    raw_para_text = ""
                    fix_para_text = ""
                    for kid in kids:
                        text = kid.get("content", "")
                        font = kid.get("font", "")
                        stripped_text = text.strip()
                        raw_para_text += text
                        if stripped_text and is_math_font(font):
                            # Don't double wrap if it already appears wrapped
                            if (stripped_text.startswith('$') and stripped_text.endswith('$')) or \
                               (stripped_text.startswith('\\(') and stripped_text.endswith('\\)')):
                                fix_para_text += text
                            else:
                                fix_para_text += text.replace(stripped_text, f"${stripped_text}$")
                        else:
                            fix_para_text += text
                    if raw_para_text.strip() != fix_para_text.strip():
                        pages[page].append(("REPAIR_PROSE", raw_para_text, fix_para_text))

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

    # Write per-page manifests
    for page_num in sorted(pages.keys()):
        manifest_file = scratch_dir / f"manifest_{page_num:03d}.md"
        
        lines = []
        if not manifest_file.exists():
            lines.append(f"# Manifest: Page {page_num:03d}\n")
        else:
            lines.append("\n")

        # Group by type
        by_type = defaultdict(list)
        for t, raw, fix in pages[page_num]:
            by_type[t].append((raw, fix))
            
        for t in ["REPAIR_MATH", "REPAIR_PROSE"]:
            if t in by_type:
                lines.append(f"## {t}")
                for raw, fix in by_type[t]:
                    lines.append("- RAW: ```")
                    lines.append(raw)
                    lines.append("```")
                    lines.append("  FIX: ```")
                    lines.append(fix)
                    lines.append("```")
                lines.append("")
                
        with open(manifest_file, "a", encoding="utf-8") as f:
            f.write("\n".join(lines) + "\n")

    print(f"[Math Enrichment: Wrote to {len(pages)} manifest_NNN.md files → {scratch_dir}]", file=sys.stderr)
