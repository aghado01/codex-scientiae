# End-to-End Document Repair Pipeline

You are an automated document repair agent. Your task is to convert raw Docling Markdown exports into `codex-scientiae` compliant Markdown using the Python extraction scripts and JSON sidecar artifacts.

Execute the workflow sequentially. Never skip a phase.

### Prerequisites: Python, Helper scripts, Layout

1. There is a locally installed repo `.venv` for the Python executable. Use it for running all scripts.

2. Python helper scripts are found under `scripts/`:

   ```
   scripts/math_enrichment.py     ← extract display equations and math-font spans from JSON
   scripts/reconstruct_tables.py  ← reconstruct pipe tables from JSON
   scripts/split_pages.py         ← split raw PAPER.md into per-page slices in .scratch/
   scripts/clean_mechanical.py    ← scrub mechanical OCR artifacts from page slices in-place
   scripts/apply_manifest.py      ← deterministic execution engine for targeted manifest repairs
   scripts/validate_pages.py      ← check repaired slices against STANDARDS before assembly
   scripts/assemble_pages.py      ← join repaired page slices and write final output files
   scripts/generate_toc.py        ← extract headings and automatically build/inject Contents
   scripts/read_span.py           ← read file segments by exact byte range to save context tokens
   ```

3. Workflow items live under `ingestion/` with a directory structure parallel to their `codex-scientiae` endpoints, e.g. `ingestion/compendia/clustering/NDK2016/` mirrors `compendia/clustering/` (without the final paper file, which is written only after repair is complete).

4. Each paper folder has a `.scratch/` subdirectory that holds all intermediate artifacts for that paper:

   ```
   ingestion/compendia/{topic}/{PAPER}/.scratch/
     temp_math.md          ← math enrichment monolith (triage overview only)
     temp_tables.md        ← table reconstruction monolith (triage overview only)
     page_001_tables.md    ← table artifacts for page 1 (used during per-page repair)
     ...
     manifest_001.md       ← triage / repair manifest (auto-generated, agent edits this)
     page_000.md           ← preamble (content before first [Page 1] marker, if any)
     page_001.md           ← page 1 slice
     page_002.md           ← page 2 slice
     ...
     validation_report.md  ← standards check output (produced in Phase 5)
   ```

   The Python scripts create `.scratch/` automatically on first run.

---

### Phase 1: Artifact Generation

Run both JSON-based scripts against the paper's `.json` sidecar. Each script writes its output to `.scratch/` and also prints to stdout.

```
python scripts/math_enrichment.py    ingestion/.../PAPER/PAPER.json
python scripts/reconstruct_tables.py ingestion/.../PAPER/PAPER.json
```

Artifacts produced:
- `.scratch/temp_math.md` & `temp_tables.md` — monolithic extractions (use for triage overview only)
- `.scratch/page_NNN_tables.md` — per-page table artifact
- `.scratch/manifest_NNN.md` — auto-generated per-page manifests containing exact text spans (RAW vs FIX) and table replacement templates. **This is your primary work surface.**

---

### Phase 2: Page Splitting

Split the raw source markdown into per-page slice files under `.scratch/`. This is the working surface for all subsequent repair operations.

```
python scripts/split_pages.py ingestion/.../PAPER/PAPER.md
```

The script splits on `[Page N]` boundary markers. Each slice file retains the `[Page N]` marker as its first line so page provenance is clear during repair. Content before the first marker (if any) is written to `page_000.md`.

---

### Phase 2.5: Mechanical Pre-Cleaning

Before beginning manual triage or manifest editing, run the deterministic cleanup script on the page slices to scrub common OCR artifacts:

```
python scripts/clean_mechanical.py ingestion/.../PAPER/.scratch/
```

This ensures your target baseline is clean.

---

### Phase 3: Manifest Triage & Repair

**CRITICAL DIRECTIVE**: To ensure maximum token efficiency, agents must **NEVER** manually edit the `page_NNN.md` slices. You must **NEVER** regenerate paragraphs. All edits must be done via exact string replacements in the `manifest_NNN.md` file!

Work through the document in chunks of 5-10 pages at a time.

For each page in the chunk:
1. Open the auto-generated `.scratch/manifest_NNN.md`.
2. Provide the `FILL_ME_IN` anchors for `REPLACE_TABLES` based on unique strings surrounding the broken table in `page_NNN.md`.
3. Add any additional manual micro-edits for OCR garbage, inline math missed by Docling, or metadata deletions using the manifest syntax (see below).
4. Run the execution engine to modify the page slice deterministically:
   ```
   python scripts/apply_manifest.py ingestion/.../PAPER/.scratch/manifest_NNN.md
   ```

#### Manifest Syntax Rules
The Python scripts auto-populate the manifest, but you can append your own manual edits.

**REPAIR_PROSE and REPAIR_MATH**
Use for exact string replacements. The `RAW` string must match the markdown content exactly (the engine is whitespace-agnostic but character-strict).
```markdown
## REPAIR_PROSE
- RAW: ```
  Buzsa ´ ki
  ```
  FIX: ```
  Buzsáki
  ```
```

**DELETE**
To delete text, just provide an empty `FIX` block:
```markdown
## DELETE
- RAW: ```
  doi:10.1371/journal
  ```
  FIX: ```
  ```
```

**REPLACE_TABLES**
The Python script will emit the artifact path. You must provide a unique `REPLACE_FROM` string (e.g., the table caption) and `REPLACE_TO` string (e.g., the text immediately after the broken table).
```markdown
## REPLACE_TABLES
- USE_ARTIFACT: page_005_tables.md#Table_1
  REPLACE_FROM: `Table 1. Overview of datasets`
  REPLACE_TO: `These results indicate`
```

---

### Phase 4: Spot Checking & Polish

After running `apply_manifest.py` on a chunk of pages, you must **read through the modified `page_NNN.md` files** to spot-check your work. Look for:
- Lingering OCR errors
- Unclosed math blocks
- Inline math that Docling completely missed (no `math_font` metadata)

**Crucial Rule for Agents:** If mistakes are caught during the spot check, you must **not** regenerate the file or paragraph manually. Instead, simply append a new targeted string edit to the `manifest_NNN.md` (e.g., under `REPAIR_PROSE` or `REPAIR_MATH`) and re-run `apply_manifest.py manifest_NNN.md`. 

The `apply_manifest.py` engine is idempotent and safe to run multiple times.

---

### Phase 5: Validation

Before moving to the next chunk or assembling, run the validation script against the repaired page slices. This is a read-only standards check.

```
python scripts/validate_pages.py ingestion/.../PAPER/.scratch/
```

The script checks each `page_NNN.md` for OCR ligatures, alternate math delimiters (`\\[`), KaTeX macros, and unclosed `$$` blocks.
A `validation_report.md` is written to `.scratch/`.

If the report lists issues: read the flagged `page_NNN.md`, add the fix to the manifest, re-run `apply_manifest.py`, and re-run validation until it passes.

---

### Phase 6: Assembly

Once validation passes, run the assembly script to produce the final output files:

```
python scripts/assemble_pages.py \
    ingestion/.../PAPER/.scratch/ \
    compendia/{topic}/PAPER.md
```

The script:
1. Reads all `page_NNN.md` files from `.scratch/` in sorted order
2. Strips the leading `[Page N]` marker
3. Joins slices with a blank line between pages
4. Detects a `## References` or `# References` heading and splits the document there
5. Writes the body to `compendia/{topic}/PAPER.md`
6. Writes the references section to `compendia/{topic}/references/PAPER.md` with the canonical heading `# References — PAPER`

---

### Phase 7: Post-Assembly Passes

Three operations on the assembled `compendia/{topic}/PAPER.md`.

**Ligature and Line-Break Pass** — two mechanical find-replace operations:

1. **OCR ligatures**: replace `ﬁ` → `fi`, `ﬂ` → `fl`, `ﬃ` → `ffi`, `ﬀ` → `ff`, `ﬄ` → `ffl`. Use `replace_all: true`.
2. **Hard mid-paragraph line-breaks**: where a paragraph has been hard-wrapped (a newline mid-sentence with no blank line separating it), join the lines. Only fix wraps that break prose flow; do not touch headings, list items, or captions.

**CONTENTS Section** — run the automated TOC generator on the assembled document to build and inject the contents block:

```
python scripts/generate_toc.py compendia/{topic}/PAPER.md [--h3]
```

This automatically extracts all `##` (and optionally `###`) headings, builds the hierarchical links, and injects the `## Contents` section right before the first `##` section.

Remember to manually verify or add the References link pointing to the references sidecar:
```markdown
- [References](references/PAPER.md)
```

**References Sidecar Formatting** — open `compendia/{topic}/references/PAPER.md` and apply standard formatting:
- Italic journal names
- Remove any `[Page N]` residue from page-boundary joins
- Verify the heading is `# References — PAPER`

---

### In-Context Byte-Span Reading

For textbooks or large files containing local sentinel files mapping anchors to byte ranges (e.g. `contents_byte_spans.json`), avoid reading the entire document to inspect small sections.

Instead, query target sections by running `read_span.py`:

```
python scripts/read_span.py --file <file_path> --start <start_byte> --end <end_byte>
```

This reduces token costs by loading only the necessary range into context.

---

### Edit Discipline: Surgical Edits Over Full Rewrites

**Rule:** Never use `write_to_file` with `Overwrite: true` on a file that already exists and has partially-correct content. Always prefer `multi_replace_file_content` or `replace_file_content` with the smallest target span that uniquely identifies the broken content.

**Why it matters:** Full rewrites discard context, destroy any edits made outside the agent's view, and make diffs unreviable. Pointed edits are auditable, reversible, and composable.

**Correct approach for each artifact type:**

| Artifact | Wrong | Right |
|----------|-------|-------|
| References sidecar with OCR artifacts | `write_to_file` (full replacement) | `multi_replace_file_content` — one chunk per broken entry |
| Assembled body with a garbled block | Reassemble from scratch | `replace_file_content` targeting the exact garbled span |
| Page slice with a bad line | Re-apply full manifest | Add a targeted `REPAIR_PROSE` entry for that line only |
| Post-assembly accent fix | Rewrite paragraph | A single `replace_file_content` for the exact string `Poincare´` → `Poincaré` |

**Overwrite is only justified when:**
- The file does not yet exist (creation, not edit).
- The corruption is so total that no target strings are recoverable (e.g., a file of pure `\text { } \text { }` garbage with no prose anchor points).

**In practice:**
- Identify the exact broken byte-span first (read the file, find the unique string).
- Write the smallest `TargetContent` that matches exactly once.
- Apply via `multi_replace_file_content` with as many non-contiguous chunks as needed in a single call.
