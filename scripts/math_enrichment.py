import json
import sys

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

    enriched_paragraphs = []

    def traverse(node):
        """Recursively search for paragraph nodes and reconstruct their text."""
        if isinstance(node, dict):
            # If we hit a paragraph, reconstruct its text from its children (kids)
            if node.get("type") == "paragraph":
                kids = node.get("kids", [])
                if kids:
                    para_text = ""
                    for kid in kids:
                        text = kid.get("content", "")
                        font = kid.get("font", "")

                        # Strip trailing spaces for cleaner wrapping, add back after
                        stripped_text = text.strip()
                        if stripped_text and is_math_font(font):
                            # Wrap the math, preserving the original spacing
                            para_text += text.replace(stripped_text, f"\\( {stripped_text} \\)")
                        else:
                            para_text += text

                    if para_text.strip():
                        enriched_paragraphs.append(para_text)
                else:
                    # Fallback if the paragraph has no kids but has direct content
                    content = node.get("content", "").strip()
                    if content:
                        enriched_paragraphs.append(content)

            # Continue traversing down the tree
            for value in node.values():
                traverse(value)

        elif isinstance(node, list):
            for item in node:
                traverse(item)

    traverse(data)
    return enriched_paragraphs

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python math_enricher.py <path_to_docling.json>")
        sys.exit(1)

    paragraphs = extract_and_wrap_math(sys.argv[1])

    print("--- ENRICHED TEXT OUTPUT ---")
    for p in paragraphs:
        # Basic cleanup of OCR artifacts
        clean_p = p.replace(" . ", ".").replace(" ,", ",")
        print(clean_p)
        print()
