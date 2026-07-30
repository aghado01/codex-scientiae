The Table of Contents (TOC) generation logic in this codebase is primarily housed in finalize.ps1, with a secondary
audit/repair counterpart in md-repair.ps1 and structural segmentation in sections.ps1.

Here is a breakdown of where the code lives and the role each component plays:
──────

### 1. Primary TOC Generation during Finalization (finalize.ps1)

• File: finalize.ps1
• Anchor Slug Helper: finalize.ps1 (lines 20–24)
• TOC Assembly: finalize.ps1 (lines 192–225)

How it works:
During document finalization (converting internal intermediate representation chunks to the target Markdown
register):

1. Invoke-Finalize iterates through document chunks in a single pass.
2. For each live heading (type == 'heading'), it reads the section_level to calculate bullet indentation (' ' \*
   ($level - 1)).
3. It converts section titles into GitHub-style Markdown anchor slugs via ConvertTo-Anchor.
4. It builds a ## Contents block containing hierarchical Markdown links (e.g., - [Section Title](#section-title))
   and prepends it between front-matter and the main body.
   ──────

### 2. Audit & In-Place TOC Repair (md-repair.ps1)

• File: md-repair.ps1
• Anchor Slug Helper: md-repair.ps1 (lines 194–196)
• TOC Regeneration: md-repair.ps1 (lines 198–221)

How it works:
When headings are edited, demoted, or deleted post-ingestion, Update-MdContents parses an existing Markdown file's
H2+ headings (Get-MdHeadings) and regenerates the ## Contents section in-place to ensure no dead links or demoted
sections remain in the TOC. This logic is also exposed via the update_doc_contents MCP server tool in
mcp-server.ps1.
──────

### 3. Proto-TOC Structural Segmentation (sections.ps1)

• File: sections.ps1
• Lines: sections.ps1, sections.ps1, sections.ps1

How it works:
Extracts section hierarchies and builds an internal proto-TOC (body + back-matter section headings) during initial
layout analysis before finalization.
