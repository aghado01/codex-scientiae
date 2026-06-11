The core issue: I'm doing mechanical work (stripping `\intertext` loops, deleting char-per-line sequences, collapsing multi-spaces) that Python could do deterministically, burning tokens on dumb pattern-matching.

Let me make sure I understand the proposed fix correctly before touching anything.

**Current misstep:**

- `split_pages.py` produces raw per-page markdown from the JSON
- `math_enrichment.py` + `reconstruct_tables.py` run separately against the JSON and produce _separate big files_ — not per-page
- Then I have to reconcile the two and repair each page manually

**What you're proposing:**

1. The math/table scripts should produce **per-page output** directly from the JSON (e.g., `page_001.md` already has LaTeX-enriched math and reconstructed tables applied), so splitting and enrichment happen together in one pass
2. `split_pages.py` (or a successor) auto-initializes `manifest.md` with a keyed section per page
3. A new auto-repair pass in Python handles the mechanical patterns before I ever touch the files:
   - Strip `\intertext{...}` lines from `$$` blocks
   - Delete char-per-line sequences (1-2 char lines)
   - Collapse 3+ spaces outside math blocks
   - Delete `⎩ ⎭` artifact lines
   - Delete degenerate `& & & &` chains

That leaves me only handling genuinely ambiguous content: garbled math blocks needing reconstruction, table cell merging decisions, image path assignments, content judgment calls.

Is that the right picture? And specifically — are `math_enrichment.py` and `reconstruct_tables.py` currently producing per-page files already, or one big file each? That determines whether we're refactoring the split step or the enrichment scripts.

Good catch — U+23A9 and U+23AD are curly bracket lower/upper hooks, parts of large delimiter constructions in math. Not safe to auto-delete.

Revised list of patterns safe for automated stripping:

- `\intertext{...}` lines inside `$$` blocks — always noise from the OCR enrichment
- Char-per-line sequences — lines with ≤2 non-space characters that aren't math operators (`+`, `-`, `=`, etc.)
- Degenerate `& & & &` chains — `$$` blocks where most lines are just `&` tokens
- 3+ spaces in prose lines (outside `$$` blocks)

The ⎩ ⎭ characters should be left for manual review since they may be legitimate bracket fragments that need reconstruction context.

Now — do you want me to read the existing scripts before proposing changes, or do you already have a clear picture of what they currently do and just want the redesign spec?

That's a much cleaner mental model. Let me read the actual scripts and the workflow doc to see where the current implementation diverges from that intent.

`split_pages.py` is already working on the markdown, not the JSON — it splits on `[Page N]` markers exactly as you described. So that part is correct.

Let me check what `math_enrichment.py` produces to make sure it's also per-page:

Good news: the design is already correct. `split_pages.py` splits the raw `.md` by `[Page N]` markers, and `math_enrichment.py` already produces per-page `page_NNN_math.md` files from the JSON. No misstep there.

The actual gap is **manifest initialization**. After `split_pages.py` runs it knows all the page filenames but writes nothing to `manifest.md` — that gets created manually in Phase 3, which is where a big chunk of tokens go (reading the full paper + temp_math.md + temp_tables.md to draft it).

The fix is straightforward: at the end of `split_pages.py`, after writing all the page slices, auto-initialize `manifest.md` with the five canonical sections and a stub entry under each section for every page found. Then Phase 3 becomes filling in a pre-structured form rather than writing it from scratch.

A secondary improvement: while splitting, the script could scan each page chunk for known mechanical patterns and flag them in the manifest automatically — multi-spaces, `\intertext` lines in `$$` blocks, char-per-line sequences. That turns Phase 3 triage into review-and-confirm rather than discovery.

Want me to implement both enhancements to `split_pages.py`? The auto-init is a small addition; the pattern-detection pass is slightly more involved but still self-contained within that one script.

[user notes:]

Sonnet does not get it. definitely missing the point.

Ideas for tools:

1. Tool to extract markdown header lines at any header level from a markdown file in order to assist with writing TOC into a document

- can use a tool to insert TOC above the first `##` section of the document as well

2. Byte spans would be useful for programmatically reading masked or otherwise known regions
