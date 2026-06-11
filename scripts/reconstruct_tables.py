import json
import sys
from collections import defaultdict
from pathlib import Path

def extract_tables_from_docling(json_filepath):
    """
    Parses a Docling JSON export to locate 'type': 'table' nodes and
    reconstructs them into valid Markdown pipe tables based on row/column indices.
    Returns a list of (page_num, table_idx, md_table) tuples.
    """
    with open(json_filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)

    tables_found = []  # list of (page_num, table_node)

    def search_for_tables(node):
        if isinstance(node, dict):
            if node.get("type") == "table":
                page_num = node.get("page number", 0)
                tables_found.append((page_num, node))
            for value in node.values():
                search_for_tables(value)
        elif isinstance(node, list):
            for item in node:
                search_for_tables(item)

    search_for_tables(data)

    results = []  # list of (page_num, table_idx, md_table)

    for table_idx, (page_num, table_node) in enumerate(tables_found):
        # Dictionary mapping (row_idx, col_idx) to cell content
        table_grid = defaultdict(str)
        max_row = 0
        max_col = 0

        # Iterate through the table rows and cells
        rows = table_node.get("rows", [])
        for row in rows:
            if row.get("type") != "table row": continue

            for cell in row.get("cells", []):
                if cell.get("type") != "table cell": continue

                # Get coordinates (Docling 1-indexes rows/cols)
                row_num = cell.get("row_number", 1) - 1
                col_num = cell.get("column_number", 1) - 1

                max_row = max(max_row, row_num)
                max_col = max(max_col, col_num)

                # Extract text content from the cell's kids
                cell_text = []
                for kid in cell.get("kids", []):
                    if kid.get("type") == "paragraph":
                        cell_text.append(kid.get("content", "").strip())

                # Join with spaces, clean up floating periods from OCR
                combined_text = " ".join(cell_text)
                combined_text = combined_text.replace(" . ", ".").replace(" .", ".")

                table_grid[(row_num, col_num)] = combined_text

        # Reconstruct into Markdown string
        md_lines = []
        for r in range(max_row + 1):
            row_vals = []
            for c in range(max_col + 1):
                val = table_grid.get((r, c), "")
                row_vals.append(val)

            # Format row
            md_lines.append("| " + " | ".join(row_vals) + " |")

            # Add header separator after row 0
            if r == 0:
                separator = ["---"] * (max_col + 1)
                md_lines.append("|" + "|".join(separator) + "|")

        results.append((page_num, table_idx + 1, "\n".join(md_lines)))

    return results

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python reconstruct_tables.py <path_to_docling.json>")
        sys.exit(1)

    json_path = Path(sys.argv[1])
    results = extract_tables_from_docling(json_path)

    scratch_dir = json_path.parent / ".scratch"
    scratch_dir.mkdir(exist_ok=True)

    # Write monolithic temp_tables.md for triage overview
    mono_lines = [f"Found {len(results)} tables.\n"]
    for page_num, table_idx, md_table in results:
        mono_lines.append(f"--- Table {table_idx} (page {page_num}) ---")
        mono_lines.append(md_table)
        mono_lines.append("\n")
    (scratch_dir / "temp_tables.md").write_text("\n".join(mono_lines), encoding="utf-8")

    # Write per-page table artifacts coordinated with page_NNN.md slice filenames
    by_page = defaultdict(list)
    for page_num, table_idx, md_table in results:
        by_page[page_num].append((table_idx, md_table))

    for page_num in sorted(by_page.keys()):
        page_lines = [f"[Page {page_num}] — Tables\n"]
        for table_idx, md_table in by_page[page_num]:
            page_lines.append(f"--- Table {table_idx} ---")
            page_lines.append(md_table)
            page_lines.append("")
        page_file = scratch_dir / f"page_{page_num:03d}_tables.md"
        page_file.write_text("\n".join(page_lines), encoding="utf-8")

    print(f"[Written: temp_tables.md + {len(by_page)} page_NNN_tables.md files → {scratch_dir}]", file=sys.stderr)
