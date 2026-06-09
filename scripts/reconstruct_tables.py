import json
import sys
from collections import defaultdict

def extract_tables_from_docling(json_filepath):
    """
    Parses a Docling JSON export to locate 'type': 'table' nodes and
    reconstructs them into valid Markdown pipe tables based on row/column indices.
    """
    with open(json_filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # We iterate over all blocks in the Docling JSON structure
    # The JSON provided is flat in its text summary but structured internally
    # We will assume a standard recursive search for node types
    tables_found = []

    def search_for_tables(node):
        if isinstance(node, dict):
            if node.get("type") == "table":
                tables_found.append(node)
            for value in node.values():
                search_for_tables(value)
        elif isinstance(node, list):
            for item in node:
                search_for_tables(item)

    search_for_tables(data)

    markdown_tables = []

    for table_idx, table_node in enumerate(tables_found):
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

        markdown_tables.append("\n".join(md_lines))

    return markdown_tables

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python table_reconstructor.py <path_to_docling.json>")
        sys.exit(1)

    md_tables = extract_tables_from_docling(sys.argv[1])

    print(f"Found {len(md_tables)} tables.\n")
    for i, md_table in enumerate(md_tables):
        print(f"--- Table {i+1} ---")
        print(md_table)
        print("\n")
