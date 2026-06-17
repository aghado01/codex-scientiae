# Restoration Procedure

This is the system. Follow it precisely — it is written so that an agent that remembers
nothing between steps can run it correctly. You *will* lose the thread mid-task; the
procedure and the artifacts are your memory. Trust them, not your recollection.

(Served to agents as the `restoration_procedure` MCP prompt by `mcp-server.ps1` — and the
canonical text of the workflow.)

## The law of exposure

You repair what you are shown, where you are shown it. Three rules, always:

1. **Navigate, don't scan.** Find work through the work-list (`get_hotspots`, `dispatch`)
   or `search`. Never load a document to look for what to fix — the tools surface it.
2. **Slice, don't slurp.** Pull exactly the unit you were pointed to with `get_slice`.
   There is no "give me the file." You hold one unit at a time.
3. **Edit, don't regenerate.** Repair with `propose_edit` — a surgical find/replace. Never
   reproduce a chunk you were shown; send only the change.

Content is for the unit in hand, at the moment you work it. Pointers and metadata are for
everything else.

## Ground truth

The artifacts on disk are the truth; tool calls return projections of them. If you are
unsure what state something is in, re-read it — never assume from memory. You can stop and
resume at any point by re-grounding from a projection; nothing is lost, because nothing is
held.

## The batch loop — orchestrator (the seeing agent)

Move a batch to completion by looping. You hold nothing between iterations.

1. **Re-ground.** `get_batch_summary` — per document: actionable / handoff / repaired /
   review_bytes. This is where the batch stands *now*. (Resuming a dead run is just this.)
2. **Decide.** Choose what to work next from the projection. Prefer documents with the most
   actionable work; honour any `review_pending` first.
3. **Fan out.** `dispatch budget_bytes=<B>` → a bundle of work-unit *pointers* within your
   token budget. Hand each pointer to a worker (a sub-agent). Pointers, never content — the
   worker pulls its own slice.
4. **Fan in.** When workers report done, `apply <paper>` per document — it folds their clean
   staged proposals into the stream and holds any still-flagged ones. Read the digest
   (applied N, held M).
5. **Repeat from 1.** Applied units re-grade to faithful and drop out of the next `dispatch`.
   Dispatched units are *leased*, so a later `dispatch` never re-hands them — `apply` when a
   round of workers reports done, not between every dispatch. Stop when `dispatch` returns
   empty across the batch.

A single document with no swarm is the same loop at depth 1: you are the worker; skip the
fan-out and run the repair loop yourself.

**Do not `git commit`.** The workflow writes artifacts and reports; `git add` is fine, the git
commit is the user's, at a milestone they choose. (The `apply` tool folds proposals into the
chunk stream — not a git commit. There is no "commit" in the membrane at all.)

## The per-unit repair loop — worker

You are handed one pointer: `{ paper, id, grade, corruption_type, seam, issues }`. Hold nothing else.
(`issues` is the multi-issue profile — *every* problem the deliverable carries, not just the gate's one.)

1. **See it.** `get_slice paper id` — the unit's content **and** its `work_order`: the composed,
   ordered list of every issue in the deliverable, each paired with its repair recipe. (For a span you
   were handed, `get_slice id=lo to_id=hi` — the order pools all members under the merge instruction.)
   This is everything you need.
2. **Work the whole order in one pass.** The `work_order` is ordered **structural-before-content**
   (retype / split / merge first, then content fixes — the "restructure first" rule of step 4). Resolve
   *every* issue it lists, then move on; `apply` re-grades and the deliverable converges when they all
   clear — one pass, not one re-dispatch per issue. `grade` / `corruption_type` / `seam` still name the
   gate's single verdict; the prose playbook below is the frame and the fallback for anything the recipe
   map does not yet carry.
3. **Repair in place.** `propose_edit paper id find=<exact garbage> replace=<fix>`. The
   response says whether the unit is now `clean` or still `flagged` (with the diagnostic).
   Stack edits until it reads `clean`. Send only diffs.
4. **Restructure first if the damage is structural** — a formula mis-typed as prose, one
   chunk that is really two, a fragment split across chunks: `retype_chunk` / `split_chunk` /
   `merge_chunks`, then re-ground (ids changed) and repair content.
5. **Report.** Your job is the one unit. When it reads `clean` you are done — `apply` is the
   orchestrator's. Return a one-line digest. If you cannot make it clean, see Escalation.

## The repair playbook — by `corruption_type`

This prose playbook is the frame and the fallback. Its machine-readable sibling (`src/playbook.ps1`) is
what the `work_order` pools into a per-deliverable recipe list; when an issue has no data-fied recipe yet,
fall back to the entry here.

- **fragmented_formula** — a block equation shattered across chunks. You are handed a `span` (e.g. `[lo..hi]`). Call `get_slice id=lo to_id=hi` to see all members. Structural repair first: `merge_chunks ids=[lo..hi]` into a single chunk. Re-ground (`get_slice`), then `propose_edit` to fix the join seams.
- **intertext** — a degenerate loop bolted onto a complete head. The real content is the
  head; everything from the first `\intertext` (or the start of the verbatim repetition) is
  garbage. `propose_edit` with `find` = the garbage tail, `replace` = empty. If a delimiter's
  partner was lost inside the tail (the `seam`), add it back.
- **unbalanced_delimiters** — one delimiter is open or extra. The `seam` names it
  (`paren=1` → one unclosed `(`; `lr=-1` → a dangling `\right`). Add or remove exactly that
  one; touch nothing else.
- **gibberish** — space-shattered text (`a o f i n t o`). The head is usually intact, the tail
  shattered. Repair the readable intent or delete the unrecoverable run.
- **ligature_residue** — `ﬁ ﬂ ﬃ` survivors → `fi fl ffi`. A direct substitution.
- **replacement_char** — `U+FFFD` marks a lost character. Restore from context if certain;
  else escalate.

## Escalation

- **`request_review paper id message`** — you are uncertain. Surface it to the supervising
  user rather than guessing. This is not failure; it is the system working.
- **`mark_unrecoverable paper id reason`** — you tried and the content genuinely cannot be
  recovered from the export. Use sparingly: a high unrecoverable rate indicts the repair
  attempt, not the export. This is the rare terminal that hands off to re-extraction.
