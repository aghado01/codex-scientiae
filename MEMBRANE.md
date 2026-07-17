┌──────────────────────────────────────────────────────────────────────────────────┐
│ MCP CLIENT (Claude Code / Cursor) "this connection IS your session" │
│ — injects restoration_procedure prompt (PROCEDURE.md) into the agent's context │
└───────────────────────────────────┬────────────────────────────────────────────────┘
│ JSON-RPC 2.0, newline-delimited, one compact
│ object per line. UTF-8 no-BOM, OWNED at the
│ .NET level (StreamReader/Writer on std{in,out}).
│ stdout = protocol frames ONLY; all logs → stderr.
▼
┌──────────────────────────────────────────────────────────────────────────────────┐
│ src/mcp-server.ps1 (pure-PowerShell stdio server, ServerInfo codex-membrane) │
│ │
│ main loop ──► initialize ──► discovery walk = the handshake (cached Readiness) │
│ │ tools/list · prompts/list · prompts/get · ping │
│ └──► tools/call ─► Invoke-ToolGuarded ─► Invoke-Tool (switch, 26 ops) │
│ (3>&1 4>&1 5>&1 6>&1: strays → stderr, never a frame) │
│ │
│ roots: -Root = ingestion/ (read + repair boundary) │
│ -CompendiaRoot = compendia/ (publish target) │
│ dot-sources: serving.ps1 · restructure.ps1 · preprocess.ps1 │
│ finalize.ps1 · md-repair.ps1 · publish.ps1 │
└───────────────────────────────────┬────────────────────────────────────────────────┘
│ every tool is PAPER-ADDRESSED → depth-invariant
│ (one doc = depth-1, whole batch = depth-n, same code)
▼
┌──────────────────────────────────────────────────────────────────────────────────┐
│ ARTIFACTS ON DISK = GROUND TRUTH (tools return projections, never the file) │
│ │
│ ingestion/{slug}/{slug}.json ......... raw IR (the export, body-blind survey unit)│
│ ingestion/{slug}/.runs/{stamp}/ (runstamped; newest wins) │
│ {slug}.chunks.jsonl ............... enriched chunk stream ◄── the live object │
│ {slug}.jidx ....................... seek index (get_slice by id) │
│ + leases · staged proposals · .ledger.jsonl milestones · audit log │
│ compendia/{topic}/ ................... {slug}.md · references/ · images/{slug}/ │
│ · \_CONTENTS.md (published corpus) │
└──────────────────────────────────────────────────────────────────────────────────┘

THE WORKFLOW THE 26 TOOLS DRIVE ──────────────────────────────────────────────────

┌─ 0. SURVEY (body-blind) ──────────────────────────────────────────────────┐
│ list_documents · get_batch_summary · get_summary · get_inventory · search │
│ get_hotspots · get_audit · get_enrichables (scope= narrows it) │
└───────────────────────────────┬───────────────────────────────────────────┘
│
▼
┌─ 1. PREPROCESS ───────────────────────────────────────────────────────────┐
│ preprocess paper → seven-stage pipeline: raw {slug}.json → enriched │
│ chunk stream + sidecars in a FRESH .runs/{stamp}/ (every call = new │
│ run; continue/pin existing work via the other tools, {paper}@{run}) │
└───────────────────────────────┬───────────────────────────────────────────┘
▼
┌─ 2. THE REPAIR LOOP (hold nothing between iterations) ────────────────────┐
│ │
│ ORCHESTRATOR (the seeing agent) WORKER (per unit, depth-1 = self) │
│ ┌──────────────────────────────┐ ┌─────────────────────────────┐ │
│ │ get_batch_summary re-ground │ │ get_slice see it + the │ │
│ │ │ │ │ work_order │ │
│ │ ▼ decide │ │ │ (structural-before- │ │
│ │ dispatch budget_bytes │──ptrs─►│ ▼ content, all issues) │ │
│ │ (pointers, NEVER content, │ │ restructure if needed: │ │
│ │ leased, sorted by │ │ retype_chunk / split_chunk│ │
│ │ ascending agreement) │ │ / merge_chunks (re-orient)│ │
│ │ ▲ │ │ │ │ │
│ │ apply paper fold clean │◄─done─│ ▼ propose_edit (surgical)│ │
│ │ proposals, hold flagged, │ │ propose_repair (last │ │
│ │ clear leases, log │ │ resort, whole chunk) │ │
│ │ │ │ │ stack until → clean │ │
│ │ └── repeat until │ └─────────────┬───────────────┘ │
│ │ dispatch empty │ │ stuck? │
│ └──────────────────────────────┘ ▼ │
│ ESCALATE: request_review / │
│ (release = free abandoned leases) mark_unrecoverable │
└───────────────────────────────┬───────────────────────────────────────────┘
▼
┌─ 3. CLOSE THE LOOP ───────────────────────────────────────────────────────┐
│ finalize paper ──► serialize stream → {slug}.md + references/ in run dir│
│ │ (pending>0 ⇒ provisional) │
│ ▼ │
│ review_document paper ──► the ONE sanctioned holistic read (content IS │
│ │ the return); catch → propose_edit → apply │
│ ▼ │
│ publish paper topic ──► promote into compendia/{topic}/ (dry_run first; │
│ refuses while pending>0 unless force). │
│ figures_omitted ⇒ returns ![](…) snippets │
└───────────────────────────────┬───────────────────────────────────────────┘
▼
┌─ 4. POST-PROMOTION (byte-offset lane — raw .md, no JSON/IR left) ─────────┐
│ repair_headings path detect over-promoted headings, auto-demote │
│ │ confident ones, emit {offset,length,raw} list │
│ ▼ │
│ splice_md path off len replacement expect=raw land a hand-authored fix │
│ │ (offsets shift after each splice → re-run repair_headings) │
│ ▼ │
│ update_doc_contents path regenerate "## Contents" from KEEP headings │
└────────────────────────────────────────────────────────────────────────────┘

The three laws underneath it all: Navigate-don't-scan · Slice-don't-slurp ·
Edit-don't-regenerate. "Do not git commit" — apply folds proposals, it is
NOT a commit; the git commit is the user's, at a milestone they choose.
