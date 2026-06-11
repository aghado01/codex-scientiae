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
   scripts/validate_pages.py      ← check repaired slices against STANDARDS before assembly
   scripts/assemble_pages.py      ← join repaired page slices and write final output files
   ```

3. Workflow items live under `ingestion/` with a directory structure parallel to their `codex-scientiae` endpoints, e.g. `ingestion/compendia/clustering/NDK2016/` mirrors `compendia/clustering/` (without the final paper file, which is written only after repair is complete).

4. Each paper folder has a `.scratch/` subdirectory that holds all intermediate artifacts for that paper:

   ```
   ingestion/compendia/{topic}/{PAPER}/.scratch/
     temp_math.md          ← math enrichment monolith (triage overview only)
     temp_tables.md        ← table reconstruction monolith (triage overview only)
     page_001_math.md      ← math artifacts for page 1 (used during per-page repair)
     page_001_tables.md    ← table artifacts for page 1 (used during per-page repair)
     page_002_math.md      ← math artifacts for page 2
     ...                     (files only written for pages that have math / tables)
     manifest.md           ← triage / repair manifest (produced in Phase 3)
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
- `.scratch/temp_math.md` — monolithic math enrichment, all pages concatenated (use for triage overview only)
- `.scratch/page_NNN_math.md` — per-page math artifact, one file per page that contains math; page number zero-padded to three digits matching the `page_NNN.md` slice names
- `.scratch/temp_tables.md` — monolithic table reconstruction, all tables with page annotations (use for triage overview only)
- `.scratch/page_NNN_tables.md` — per-page table artifact, one file per page that contains tables

The math artifacts are organized by page: each `page_NNN_math.md` begins with `[Page N]` matching the corresponding slice file. Inline `$...$` wrapping appears only when Docling recorded math-font metadata on text spans; if absent, inline math must be identified manually from context.

---

### Phase 2: Page Splitting

Split the raw source markdown into per-page slice files under `.scratch/`. This is the working surface for all subsequent repair operations.

```
python scripts/split_pages.py ingestion/.../PAPER/PAPER.md
```

The script splits on `[Page N]` boundary markers. Each slice file retains the `[Page N]` marker as its first line so page provenance is clear during repair. Content before the first marker (if any) is written to `page_000.md`.

After splitting, `.scratch/` contains `page_001.md`, `page_002.md`, … (plus `page_000.md` if there is a preamble). All repair work in Phase 3 targets these slice files, not the monolithic source.

---

### Phase 3: Triage & Manifest

Read the source `PAPER.md` and the monolithic `temp_math.md` / `temp_tables.md` artifacts for an overview of the paper. Produce `.scratch/manifest.md` with five sections. Every line not explicitly listed in a section is implicitly `KEEP_VERBATIM` — do not touch it in later phases.

Use `temp_math.md` and `temp_tables.md` only during this triage phase. During Phase 4 repair, load per-page artifacts (`page_NNN_math.md`, `page_NNN_tables.md`) one page at a time instead.

**DELETE** — blocks to remove entirely. List each as a description with enough identifying text to locate it (section header, first sentence of block). Typical candidates:
- Journal metadata headers (citation info, DOI logos, editor names, dates, copyright)
- Funding / grant statements and competing-interests declarations
- Ethics statements, author contributions, supporting information listings
- bioRxiv / PLoS running-header boilerplate scattered across pages
- `[Page N]` markers and `doi:10.xxxx/...` annotation lines
- OCR debris after figure images (axis labels, panel letters, cluster counts, numerical noise)

**FIX_IMAGES** — broken image path patterns. Typically `images/imageFileN.png` → `images/PAPER/imageFileN.png`. List each distinct broken pattern and its replacement.

**REPLACE_TABLES** — each flattened or misformatted table. For each entry record:
- Location (section heading + table caption fragment)
- Replacement pipe table from `temp_tables.md` (note when manual correction was needed because script output was degenerate)

**REPAIR_PROSE** — specific targeted text substitutions for OCR character garbling, hyphenation join artifacts, and page-break sentence joins that are too context-specific for a global replace-all. Typical candidates:
- Accented characters garbled by OCR: `Buzsa ´ ki` → `Buzsáki`
- Hyphenation join artifacts from PDF line-breaks: `overand under-clustering` → `over- and under-clustering`
- Page-break sentence joins with missing or duplicated words
- Garbled dashes or punctuation within specific prose spans

Do not use REPAIR_PROSE for patterns that occur uniformly across the document — those belong in Phase 4's mechanical pass. REPAIR_PROSE is for fixes that require surrounding context to locate unambiguously.

**REPAIR_MATH** — each garbled or missing equation. For each entry record:
- Location (page number + section heading + surrounding prose fragment, enough to be unambiguous)
- Raw OCR text as found in source
- Clean LaTeX replacement derived from `temp_math.md` or reconstructed from context

Apply STANDARDS.md encoding: inline math as `$...$`, display math as `$$\n...\n$$` on its own lines, numbered equations use `\tag{N}`. No KaTeX-specific macros.

Example manifest structure:

```markdown
# Repair Manifest — PAPER

## DELETE
- Journal metadata header (page_001, ~lines 1–10): PLoS ONE citation block, editor/dates/copyright
- Funding sidebar (page_004): begins "The authors declare..."
- [Page N] markers: all occurrences throughout document
- OCR debris after Fig 1 (page_003): axis label fragments, panel letters

## FIX_IMAGES
- `images/imageFile6.png` → `images/NDK2016/imageFile6.png`

## REPLACE_TABLES
- Table 1 (page_005, Sec 2.3): use temp_tables.md Table 1; additionally wrap Name column with math

## REPAIR_PROSE
- page_002, Intro para 3: `Buzsa ´ ki` → `Buzsáki`
- page_006, Discussion: `overand under-clustering` → `over- and under-clustering`

## REPAIR_MATH
- page_003, Sec 2.3 "First template matching", variance formula
  Raw: `s : ¼ ﬃﬃﬃﬃ P N i ¼ 1 var ð x i Þ q`
  Fix: `$s = \sqrt{\sum_{i=1}^N \text{var}(x_i)}$`
```

---

### Phase 4: Apply Manifest

Work through `manifest.md` and apply each entry as a targeted `Edit` operation on the relevant `page_NNN.md` slice file. Touch nothing outside the manifest.

**One page at a time.** Process pages sequentially. For each page:

1. Scan `manifest.md` to identify which sections have entries targeting this page.
2. If the page has any manifest entries: read `page_NNN.md` + `page_NNN_math.md` (if it exists) + `page_NNN_tables.md` (if it exists) into context.
3. Apply all manifest entries for this page, in section order: DELETE → FIX_IMAGES → REPLACE_TABLES → REPAIR_PROSE → REPAIR_MATH.
4. Finish all edits to this page, then move to the next page.

Do not hold multiple pages' slice files or artifact files in context simultaneously. The page-slice architecture exists to keep each repair unit small — loading all pages at once defeats the purpose.

Section-order rationale:

1. **DELETE** — remove structural junk first. Large block removals (headers, boilerplate, non-scientific sections, OCR figure debris) stabilize each page slice before any precision repairs. For scattered single-line patterns (`[Page N]` markers, doi lines), use `replace_all: true` across all affected slice files.

2. **FIX_IMAGES** — simple path pattern replacements. Do these before table and math repairs so you are not fixing paths in content that will be restructured. Use `replace_all: true` if the broken pattern is consistent across slices.

3. **REPLACE_TABLES** — delete each flattened table block and insert the pipe table from `page_NNN_tables.md` (with any noted manual corrections applied). Doing this before prose and math repairs means table parameter names are in place when math wrapping is applied in step 5.

4. **REPAIR_PROSE** — apply specific targeted prose substitutions (garbled accented characters, hyphenation join artifacts, page-break sentence joins). Do this before REPAIR_MATH so that the surrounding context used for math text-matching reflects the clean prose state.

5. **REPAIR_MATH** — replace each garbled equation with its clean LaTeX version. This is the most precise step and benefits from all prior deletions and prose fixes providing stable, unambiguous surrounding context. Consult `page_NNN_math.md` for the JSON-derived reference equations. For inline math wrapping of symbols and parameter names, wrap each identified instance individually.

---

### Phase 5: Validation

Before assembling, run the validation script against all repaired page slices. This is a read-only standards check — it never modifies files.

```
python scripts/validate_pages.py ingestion/.../PAPER/.scratch/
```

The script checks each `page_NNN.md` for:

1. **OCR ligatures** still present (`ﬁ` `ﬂ` `ﬃ` `ﬀ` `ﬄ`) — must be absent before assembly
2. **Alternate math delimiters** `\[` `\]` `\(` `\)` — must be `$` or `$$` per STANDARDS §1
3. **KaTeX / web-renderer macros** (`\color`, `\vspace`, `\hspace`, etc.) — not valid per STANDARDS §1
4. **Floating equation numbers** — a bare `(N)` on its own line outside a `$$` block should be `\tag{N}` inside the equation per STANDARDS §2
5. **Unclosed `$$` display-math blocks** — a `$$` open with no matching close

A `validation_report.md` is written to `.scratch/`. The script exits 0 (pass) or 1 (issues found).

If the report lists issues: fix them **one page at a time** — read the flagged `page_NNN.md`, apply the fix, move to the next flagged page. Do not load unflagged pages. Re-run validation after all fixes until it passes. Do not proceed to Phase 6 (Assembly) with outstanding validation failures.

The validator intentionally does NOT check heading hierarchy or prose-level math completeness — both are content-dependent and would produce false positives. Those are reviewed during Phase 7 after assembly.

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
2. Strips the leading `[Page N]` marker from each slice
3. Joins slices with a blank line between pages
4. Detects a `## References` or `# References` heading and splits the document there
5. Writes the body to `compendia/{topic}/PAPER.md`
6. Writes the references section to `compendia/{topic}/references/PAPER.md` with the canonical heading `# References — PAPER`

If no references section is detected, only the body file is written.

---

### Phase 7: Post-Assembly Passes

Three operations on the assembled `compendia/{topic}/PAPER.md`.

**Ligature and Line-Break Pass** — two mechanical find-replace operations:

1. **OCR ligatures**: replace `ﬁ` → `fi`, `ﬂ` → `fl`, `ﬃ` → `ffi`, `ﬀ` → `ff`, `ﬄ` → `ffl`. Use `replace_all: true`.
2. **Hard mid-paragraph line-breaks**: where a paragraph has been hard-wrapped (a newline mid-sentence with no blank line separating it), join the lines. Only fix wraps that break prose flow; do not touch headings, list items, or captions.

**CONTENTS Section** — insert a `## Contents` section immediately after the title and authors block. Include every remaining heading as a hierarchical list of anchor links. The References entry links to the sidecar file written in Phase 6:

```markdown
## Contents

- [Abstract](#abstract)
- [1. Introduction](#1-introduction)
- [2. Methodology](#2-methodology)
  - [2.1 ...](#21-)
  ...
- [References](references/PAPER.md)
```

**References Sidecar Formatting** — open `compendia/{topic}/references/PAPER.md` (already written by assemble_pages.py) and apply standard formatting:
- Italic journal names
- Remove any `[Page N]` residue from page-boundary joins
- Verify the heading is `# References — PAPER`
