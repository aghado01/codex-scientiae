# DevOps brief — resumable stages, the run ledger, and generational GC

Runstamp 20260807_135748. Emerged from the jsonl_engine / ref-graph session of 2026-08-07, which
surfaced the pipeline-shape findings below as a side effect of auditing converter artifacts. No
`issues/devops/planning/` canon exists yet; when it does, the durable decisions belong there and this
runstamped brief stays a record of the reasoning.

## Purpose

The conversion pipeline has two persistence points — the article sentinel and the terminal run
directory — so no intermediate stage can be resumed or run in isolation. Every development cycle
costs a full end-to-end run, which proliferates near-identical artifact copies with no way to reclaim
them.

End-to-end-as-default is deliberate and stays the default. It is what surfaces systemic problems:
both real defects found on 2026-08-07 came from tracing emitted artifacts across 43 papers, not from
stage-local inspection, and in both cases the offending function is locally correct. Fixing stages in
blind isolation accumulates pathologies across sessions. The work below makes full runs cheap and
partial runs *legible*; it does not make partial runs the norm.

## Findings that shape the work

- **A stage is resumable exactly where its inputs are persisted artifacts.** The count of resumable
  stages equals the count of persisted intermediates. Unpacking already became once-not-per-run by
  this mechanism: `article.json` persists and is a prerequisite.
- **Persisting the ref-graph's inputs is the stage-boundary work for latex-ingest.** `Build-LatexRefGraph`
  consumes `$maps.*`, `$LtxRefSites`, `$citeMap`, and `$AllLabels` — all in-memory. None is
  irreducibly ephemeral; all four are observations of the source. Persist them and that stage runs
  standalone against fixed inputs.
- **Full runs are expensive because everything recomputes.** Attack cost before adding partial-run
  machinery: with intermediates persisted and input hashes recorded, a full run costs about what the
  changed stage costs, and most of the pressure toward partial runs disappears.

## Contract

### Sparse partial runs

- A partial run's directory contains only what its stages regenerated. Preceding artifacts are not
  copied forward.
- `.sig` records `resumed_from`, naming the run that supplied the inputs. A reader traces back to
  investigate.
- That field is a **reachability edge**, not only a breadcrumb — see GC below.
- A run must be self-describing about whether it is end-to-end or partial, and which stages were
  regenerated. Without it the failure mode is not a broken run but a run that *looks* comparable and
  is not, which corrupts a retrace rather than interrupting it.

### The run ledger

Append-only, one level above the runstamp directories, appended by each run.

- It is a **ledger, not a catalog**. A catalog is a rebuildable materialized view; this one outlives
  its sources — once a generation is collected, its row is the only record the run existed. That is
  what makes append-only correct rather than stylistic.
- First consumer of the engine's `APPEND` discipline, which is implemented and so far unexercised.
- **Order is content.** `pin` then `unpin` is a different history from the reverse. This is the first
  kind for which that holds, and it forbids canonical sort. Specifically it forbids the PowerShell
  `Add-JsonlStoreRecords` policy path, which reads, merges, **re-sorts**, and rewrites — on a ledger
  that silently reorders history. The Python `APPEND` path preserves order but copies the whole file
  per append; at one row per run that cost is negligible.
- Mutation is by row: `pin` / `unpin` / `collected` are events, and current state is a replay rather
  than a field.

**Decided:** the ledger is **per-module**, sitting above `{stamp}` under a `{module}`, and is appended
by each new run as part of the `runs` operational jurisdiction. Repo-wide is not ruled out later, but
per-module keeps writes uncontended and matches where run addressing already lives.

Two consequences of that jurisdiction.

`run-paths.ps1` currently declares itself *"pure path work — no crawler, no document identity, no lane
knowledge, no filesystem discovery beyond enumerating the runs root itself."* Appending JSONL rows is
not path work. So either that module grows a content-writing responsibility and amends its own header,
or the ledger gets a sibling module inside the same jurisdiction and `run-paths.ps1` stays pure. The
second keeps a true statement true; the first keeps the jurisdiction in one file.

Placement relative to the GC sweep matters more than it looks. If the ledger sits *inside* `runs/`,
every sweep has to know not to delete it. If it sits beside `runs/`, the sweep target is cleanly
`runs/*` and the ledger is structurally out of reach — which is the right relationship, since the
ledger is what survives collection.

Near-term the writer is PowerShell in the `runs` jurisdiction. If the ledger later becomes a declared
engine kind, it is the first `APPEND` member and the constraints above (order is content, no canonical
sort, no merge-rewrite path) become its kind declaration rather than a convention.

Still open: whether rows carry artifact hashes inline or point at the run's `.sig` files — inline
keeps the ledger self-sufficient after collection, pointers keep it small.

### Provenance and generational tracking

- `.sig` gains `resumed_from`, the set of stages regenerated, and the hashes of the inputs the stage
  consumed.
- A stage that records what it was built from can compare and skip when unchanged — make-style
  resumption using parts that already exist, not a new dependency system.
- Consequence worth having on its own: **"which stages are stale" becomes answerable without running
  anything**, which is what makes focused iteration tolerable.

### GC duty-cycle

Neither manual nor scheduled. **Pressure triggers the sweep; reachability decides what it takes.**

- A generation is evicted when nothing references it and nothing pins it.
- Resume-lineage pins ancestors automatically via `resumed_from`. Investigations pin explicitly.
- Duration rules are the wrong instrument: on 2026-08-07 the probe artifacts became worth keeping for
  a reason that did not exist when they were written, and any retention period had a fair chance of
  eating them first.
- GC appends its own `collected` rows, so a stamp cited in a brief months later resolves to "existed,
  collected on date X, resumed-from Y" rather than to nothing.

Open: whether a pin is a file inside the run directory or an entry in a central list — the first
survives relocation, the second is easier to audit. And whether the pressure threshold is measured in
count or bytes, which give very different answers across lanes that emit many small artifacts versus
few large ones.

### Deduplication

- `.sig` already carries a sha256 per artifact, so **a content address exists for every file** with
  no new machinery.
- Atomic publish makes hardlinking safe: temp-then-rename replaces the *directory entry* and never
  mutates the inode, so a shared artifact cannot change underneath a run that links it. An in-place
  writer would make hardlinking a corruption vector; this one makes it free, and deleting a run just
  drops the refcount.
- Composes with sparse runs rather than competing — sparse avoids writing the copies at all,
  hardlinks collapse the ones a genuine re-run produces identically.

## Taxonomy note

The ledger is a third store category beside catalog and exhibit, and it belongs on the
**infrastructure** side with catalog — invented by the project for its own logistics — rather than on
the evidence side with exhibits emitted by evidentiary proceedings.

That distinction is jsonl_engine architecture, not devops. It is recorded here only because this is
where it surfaced; the canon belongs in the engine's planning tier alongside the
catalog/exhibit/ledger split, the `CATEGORY` layer above `KIND`, and the observation that
`BaseArtifactRegistry` is named after one of its own categories.

One consequence *is* devops-owned, though: `artifacts/` currently means regenerable build output, and
`.gitignore` treats it as disposable wholesale. Exhibits are not regenerable — re-running a proceeding
produces a new exhibit, not the same one — so the directory name asserts a property half its contents
lack. That matters for GC: a sweep over a tree whose name promises regenerability reads as safe when
some of what it holds cannot be reproduced. Either the name changes, or evidence lives somewhere the
name doesn't lie about, or the retention rules carry the distinction the layout doesn't.

## Open questions to unpack

Stashed rather than guessed. Each is raised with its reasoning in the section noted.

1. **Ledger row content** — artifact hashes inline versus pointers to each run's `.sig`. Inline keeps
   the ledger self-sufficient after collection; pointers keep it small. (*The run ledger*)
2. **Ledger jurisdiction** — `run-paths.ps1` grows a content-writing responsibility and amends its
   "pure path work" header, or a sibling module owns the ledger and that file stays true. (*The run
   ledger*)
3. **Ledger placement** — inside `runs/` and excluded from every sweep by rule, or beside `runs/` and
   structurally out of the sweep's reach. (*The run ledger*)
4. **Pin representation** — a file inside the run directory, which survives relocation, or an entry in
   a central list, which is easier to audit. (*GC duty-cycle*)
5. **Pressure metric** — count or bytes. They give very different answers across lanes emitting many
   small artifacts versus few large ones. (*GC duty-cycle*)
6. **`artifacts/` semantics** — rename the tree, move evidence out of it, or carry the
   regenerable/non-regenerable distinction in the retention rules instead of the layout. (*Taxonomy
   note*)

## Not in scope

The ref-graph kind and its schema, the custom-counter map overlap, the `edge.site` join defect, and
the engine's container declaration. Each is prerequisite to or independent of the plumbing above and
carries its own reasoning.
