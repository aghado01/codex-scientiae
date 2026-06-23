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

The **live recipe** is delivered inline in the `work_order` on `get_slice`, pooled from `src/playbook.ps1`
(the single source of truth — 11 entries covering every issue type the membrane can emit). Work the whole
order in one pass; each recipe tells you whether the fix is structural (reframe first) or content (in-place
edit). Below is one worked example to show the shape; for every other type, the `work_order` carries the
recipe — do not duplicate them here (the drift surface that causes).

**Worked example — `intertext`:** a degenerate loop bolted onto a complete head. The real content is the
head; everything from the first `\intertext` (or the start of the verbatim repetition) is garbage.
`propose_edit` with `find` = the garbage tail, `replace` = empty. If a delimiter's partner was lost inside
the tail (the `seam`), add it back.

## Escalation

- **`request_review paper id message`** — you are uncertain. Surface it to the supervising
  user rather than guessing. This is not failure; it is the system working.
- **`mark_unrecoverable paper id reason`** — you tried and the content genuinely cannot be
  recovered from the export. Use sparingly: a high unrecoverable rate indicts the repair
  attempt, not the export. This is the rare terminal that hands off to re-extraction.

## Closing the loop — finalize → review → publish

When `dispatch` is empty for a document (all units faithful/repaired), close it out. These are
**tools**, not console commands — never shell out to do this.

1. **`finalize paper`** — serialize the repaired chunk stream into the deliverable
   (`{slug}.md` + `references/{slug}.md`) in the document's `.scratch/`. `pending > 0` means
   chunks are still flagged: the deliverable is provisional.
2. **`review_document paper`** — the one sanctioned holistic read. Returns the assembled body in
   full plus the still-flagged chunks. Anything you catch, fix with `propose_edit` on the named
   chunk → `apply` → review again.
3. **`publish paper topic`** — promote the finalized deliverable into `compendia/{topic}/`. It
   (re)finalizes, writes the body (figure links rewritten to `images/{slug}/`), the references
   sidecar, and the referenced figures, and upserts the `_CONTENTS.md` block. Always **`dry_run=true`
   first** to read the manifest. Refuses while `pending > 0` unless `force=true`.
   - **`figures_omitted`** — preprocessing strips images from the chunk stream, so finalize emits an
     image-less body. Publish places the real figure FILES under `images/{slug}/` and returns a
     ready `![…](…)` snippet per omitted figure. Splice each into the published body with
     `splice_md` (see below). This is the one stage publish cannot finish for you.
   - **`contents.action = appended`** — a new slug went to the end of `_CONTENTS.md`; reposition it
     by theme (the index ordering is a human curation act — publish never re-sorts).

## Post-promotion repair — the byte-offset lane (promoted markdown only)

After promotion there is no JSON/IR; you work the raw `.md` by byte-offset anchor, the markdown
analog of a chunk id. Path is repo-relative (e.g. `compendia/ph/{slug}.md`).

- **`repair_headings path`** — detect over-promoted headings; `apply=true` auto-demotes the
  confident ones (float captions, theorem labels → bold) back-to-front. Returns an **escalation
  list**, each with an `{offset, length, raw}` anchor.
- **`splice_md path offset length replacement expect`** — land a hand-authored fix (a heading
  escalation, or a `figures_omitted` snippet): replace `length` bytes at `offset`. Pass `expect`
  (the anchor's `raw`) so a shifted offset fails loudly instead of corrupting. After any splice the
  offsets below it shift — re-run `repair_headings` to re-anchor before the next.
- **`update_doc_contents path`** — regenerate the in-doc `## Contents` from the current KEEP
  headings, after you've demoted/spliced. `apply=true` rewrites it.
