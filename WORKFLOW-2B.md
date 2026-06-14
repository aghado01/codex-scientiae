# Swarm Delegation Pipeline (WORKFLOW-2B)

You are operating as the **Manager Agent** in an automated document repair swarm. Your task is to orchestrate the conversion of raw Docling Markdown exports into `codex-scientiae` compliant Markdown using Python scripts and parallel subagents ("Workers"). 

Because this pipeline uses deterministic manifest execution (`apply_manifest.py`), multiple subagents can operate on different pages concurrently without merge conflicts.

Execute the workflow sequentially.

### Prerequisites: Python, Helper scripts, Layout

1. There is a locally installed repo `.venv` for the Python executable. Use it for running all scripts.
2. Workflow items live under `ingestion/`.
3. The scratch folder `.scratch/` holds all intermediate page slices and manifests.

---

### Phase 1: Global Preparation (Manager)

As the Manager, your first job is to set up the workspace for the swarm.

1. **Generate Artifacts & Manifests**
   Run the extraction scripts. They will automatically create `manifest_NNN.md` files for any page containing math or tables.
   ```
   python scripts/math_enrichment.py    ingestion/.../PAPER/PAPER.json
   python scripts/reconstruct_tables.py ingestion/.../PAPER/PAPER.json
   ```

2. **Mechanical Cleaning**
   Scrub universal OCR artifacts so workers don't waste tokens fixing them. Run this on the unsplit primary Markdown document:
   ```
   python scripts/clean_mechanical.py ingestion/.../PAPER/PAPER.md
   ```

3. **Split Pages**
   Slice the cleaned document into working boundaries:
   ```
   python scripts/split_pages.py ingestion/.../PAPER/PAPER.md
   ```

4. **Identify Work Scope**
   List the contents of the `.scratch/` directory. Look for `manifest_NNN.md` files. 
   **Rule:** You will only spawn a subagent for pages that have a generated manifest file. Empty pages (no math/tables) can be quickly spot-checked later.

---

### Phase 2: Swarm Delegation (Manager → Workers)

For each `manifest_NNN.md` you identified, use the `invoke_subagent` tool to spawn a concurrent Worker agent.

**Worker Allocation:** 1 Worker per Page. 
*Note: If the document is large (e.g., >10 pages with manifests), delegate them in chunks of 5-10 workers at a time to avoid rate limits.*

**Subagent Prompt Template:**
> "You are responsible for document repair on `page_{NNN}`. 
> 1. Open `.scratch/manifest_{NNN}.md`. 
> 2. Read `.scratch/page_{NNN}.md` to understand context.
> 3. Provide `FILL_ME_IN` anchors for any `REPLACE_TABLES` entries.
> 4. Add `REPAIR_PROSE` and `REPAIR_MATH` entries for OCR debris or inline math that Docling missed. **DO NOT** manually edit `page_{NNN}.md`. Use exact string replacement in the manifest.
> 5. Send a message back to me when you have finished updating the manifest."

---

### Phase 3: Targeted Edit Execution (Workers)

Workers operate concurrently in the background. They must **never** manually edit the `page_NNN.md` slices. All edits are deterministic string replacements applied via the Python engine.
Because `apply_manifest.py` requires user permission to execute, workers should **not** run the script themselves. They simply edit the manifest and report back.

Once all subagents have sent their completion messages, proceed to Phase 4.

---

### Phase 4: Convergence & Spot Check (Manager)

Once the swarm has finished editing its batch of manifests:

1. **Execute Manifests in Batch**
   Run the engine on all manifests updated by the swarm:
   ```
   foreach ($i in @("004", "005", "007")) { python scripts/apply_manifest.py ingestion/.../PAPER/.scratch/manifest_$i.md }
   ```

2. **Validation**
   Run the read-only standards check:
   ```
   python scripts/validate_pages.py ingestion/.../PAPER/.scratch/
   ```
   If a page fails (e.g., a subagent missed an OCR ligature or unclosed math block), you (the Manager) must open the corresponding `manifest_NNN.md`, add the fix, and run `apply_manifest.py`. Re-validate until 0 errors.

2. **Spot Check & Polish**
   Read through the repaired `page_NNN.md` slices (especially the ones you didn't delegate to subagents). Look for:
   - Hyphenation artifacts or page-break word splits
   - Garbled accents
   
   If you spot an error, append it to that page's `manifest_NNN.md` and re-run `apply_manifest.py`.

---

### Phase 5: Assembly (Manager)

Once validation passes and the spot check is clean, produce the final output files:

1. **Assemble Slices**
   ```
   python scripts/assemble_pages.py \
       ingestion/.../PAPER/.scratch/ \
       compendia/{topic}/PAPER.md
   ```

2. **Ligature & Line-Break Pass**
   Open the assembled `PAPER.md` and apply universal find-replaces:
   - `ﬁ` → `fi`, `ﬂ` → `fl`, `ﬃ` → `ffi`, `ﬀ` → `ff`, `ﬄ` → `ffl`.
   - Rejoin hard mid-paragraph line-breaks if they break prose flow.

3. **Generate TOC**
   Inject the contents block:
   ```
   python scripts/generate_toc.py compendia/{topic}/PAPER.md [--h3]
   ```

4. **References Formatting**
   Open the sidecar `compendia/{topic}/references/PAPER.md` and verify the canonical heading `# References — PAPER` and italicize journal names.

5. **Edit Discipline — Surgical Edits Only**
   When fixing OCR artifacts in the assembled body or references sidecar, **never use a full file overwrite**. Use `multi_replace_file_content` with one chunk per broken span. Full overwrite is only justified if the file does not yet exist, or if the corruption leaves no recoverable anchor strings whatsoever. Pointed edits are auditable, reversible, and preserve any corrections already made outside the agent's view.
