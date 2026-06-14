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

    # Write per-page table artifacts
    by_page = defaultdict(list)
    for page_num, table_idx, md_table in results:
        by_page[page_num].append((table_idx, md_table))

    for page_num in sorted(by_page.keys()):
        # Write the artifacts file
        page_lines = [f"[Page {page_num}] — Tables\n"]
        for table_idx, md_table in by_page[page_num]:
            page_lines.append(f"### Table_{table_idx}")
            page_lines.append(md_table)
            page_lines.append("")
        page_file = scratch_dir / f"page_{page_num:03d}_tables.md"
        page_file.write_text("\n".join(page_lines), encoding="utf-8")

        # Update the manifest file
        manifest_file = scratch_dir / f"manifest_{page_num:03d}.md"
        manifest_lines = []
        if not manifest_file.exists():
            manifest_lines.append(f"# Manifest: Page {page_num:03d}\n")
        else:
            manifest_lines.append("\n")

        manifest_lines.append("## REPLACE_TABLES")
        for table_idx, md_table in by_page[page_num]:
            manifest_lines.append(f"- USE_ARTIFACT: page_{page_num:03d}_tables.md#Table_{table_idx}")
            manifest_lines.append("  REPLACE_FROM: `FILL_ME_IN`")
            manifest_lines.append("  REPLACE_TO: `FILL_ME_IN`")
        
        with open(manifest_file, "a", encoding="utf-8") as f:
            f.write("\n".join(manifest_lines) + "\n")

    print(f"[Tables: Wrote artifacts and updated {len(by_page)} manifest_NNN.md files → {scratch_dir}]", file=sys.stderr)
