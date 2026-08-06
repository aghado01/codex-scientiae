# Models-removed trace — chip brief

**Status:** briefed 2026-07-23 · commissioned from the reboot design session
**Parent artifacts:** [sol-reboot-distillate.md](./sol-reboot-distillate.md) (§2 verdicts, §3 stitched pipeline, §7 addendum — the frame this brief executes)

## Mission

Trace what OpenDataLoader-PDF and MinerU accomplish **with their trained models
removed, taken together**, and produce the inventories + jurisdiction map that
constrain what remains for clustering and reasoning agents in the codex-scientiae
reboot.

## The frame (from the design session)

The subtraction is asymmetric: ODL minus models retains nearly its entire
deterministic path; MinerU minus models retains its assembly half (span binding,
geometric line recovery, para_split continuation, discarded_blocks, cross-page
merging). The composite yields two maps at once:

- **The deterministic floor** — what automation alone demonstrably achieves.
- **The hole census** — MinerU's model inventory is an empirical census of the
  subproblems where determinism was insufficient (layout roles, reading order,
  formulas, tables, OCR); ODL's magic constants mark where document-conditioned
  regimes should replace universal thresholds (the beta lesson, generalized).

Remaining reboot design = fill each hole with {document-conditioned discovery,
posterior inference, agent} instead of {trained net, fixed constant}.

## Inputs — the map; do not re-derive

- `issues/sol-opendataloader-vs-minerU.md` — cross-examination with commit-pinned
  source links (2026-07-22).
- `issues/sol-minerU-breakdown.md` — MinerU architecture breakdown.
- `issues/src-reorg/sol-reboot-distillate.md` — verdicts C5/C7 (claims to verify),
  §3 pipeline (jurisdiction target), §5 borrowings ledger.
- Codebases (READ-ONLY): `D:\aghado01\packages\opendataloader-pdf` (Java core under
  `java/opendataloader-pdf-core/`), `D:\aghado01\packages\MinerU` (`mineru/`).
- Known entry points (line numbers dated 2026-07-22 — re-locate, don't trust):
  - ODL: `processors/DocumentProcessor.java` (~174, ten-step pipeline),
    `processors/readingorder/XYCutPlusPlusSorter.java` (~25).
  - MinerU: `mineru/model/layout/pp_doclayoutv2.py` (~719, learned pairwise
    reading-order head), `mineru/backend/pipeline/pipeline_magic_model.py` (~70),
    `mineru/backend/pipeline/para_split.py` (~417),
    `mineru/backend/pipeline/model_json_to_middle_json.py` (~216).

## Deliverable

One report: `issues/src-reorg/models-removed-trace.md`, containing:

1. **Deterministic floor inventory** — union across both systems, stage by stage.
   Columns: stage · decision made · evidence consumed · mechanism · system(s) ·
   borrow verdict (adopt / adapt / skip, one clause why).
2. **Constants census** — ODL primarily; MinerU's heuristic thresholds too
   (para_split has several). Columns: constant · site (path:line) · role ·
   load-bearing? (verify empirically-in-code, cf. beta) · document-conditioned
   replacement sketch (one clause).
3. **Model census** — each learned component (MinerU; ODL's optional VLM for
   completeness). Columns: model · I/O contract · what surrounding deterministic
   code assumes from its output · **hole interface** (what any replacement —
   clustering/inference/agent — must emit to slot in).
4. **Jurisdiction map** — floor pieces → borrow list; holes → {clustering /
   posterior inference / agent-semantic-interpretation}, keyed to the distillate §3
   stage numbers.

## Verifications owed (from distillate §2)

- **C7:** XYCutPlusPlusSorter default `beta = 2.0` effectively disables cross-layout
  detection; computed density-ratio preference unused. Verify against current source;
  report verified/refuted with path:line.
- **C5:** PP-DocLayoutV2 contains a learned pairwise reading-order head (boxes+classes
  → pairwise logits → votes → rank). Confirm location and mechanism.

## Method and constraints

- READ-ONLY on both package repos; the only file written is the report (and the
  work-log entry below).
- Solo work — no subagent dispatch (standing rule).
- Focus MinerU's `pipeline` backend (the deterministic assembly path); the `vlm`
  backend is out of scope except to note its boundary.
- Use Sol's pointers to jump, not crawl; prefer context-mode tools (ctx_batch_execute
  / ctx_execute) for bulk greps and stats so raw code stays out of conversation
  except where judgment requires reading it.
- Epistemic marks throughout: **[code path:line]** for observed; **[inferred]** for
  judgment. Never present an inference as a code fact.
- Style: terse tables + short prose, matching the distillate.

## Work log

**2026-07-23 — COMPLETE.** Report delivered at [models-removed-trace.md](./models-removed-trace.md)
(4 sections as briefed + §0 verification block). Method: existing maps consumed via
context-mode index; source verification direct, READ-ONLY honored on both repos.

- **Commit alignment:** local checkouts are exactly the maps' pinned commits (ODL
  `5717af9`, MinerU `79d6d8d`) — Sol's pointers re-verified in place; all four
  entry-point line numbers in this brief re-located *exactly* (no drift).
- **C7 VERIFIED, sharpened:** at `beta = 2.0` the cross-layout branch is
  *mathematically unreachable* (threshold `= 2×maxWidth`, candidates `≤ maxWidth`),
  not just "effectively disabled" [XYCutPlusPlusSorter.java:50, :166, :177]; the
  density preference is threaded through recursion but never read, and the javadoc
  "used as tiebreaker" [:328] is false — gap ties go vertical [:348].
- **C5 VERIFIED:** learned transformer encoder head at `pp_doclayoutv2.py:719`;
  geometry via learned relation-bias embedding [:334-388]; decode = sigmoid →
  pairwise votes → argsort → rank [:935-947].
- **Surprises:** (1) MinerU wraps a substantial *deterministic* relabel pass around
  the layout model inside the model file itself [pp_doclayoutv2.py:1373-1490] —
  header/footer/number anchor propagation with 30%/70% page bands; (2) formula-number
  `\tag{}` attachment and sub/superscript recovery are fully deterministic in MinerU
  [formula_number.py, span_pre_proc.py:536]; (3) ODL's TriageProcessor preserves
  comments for two deliberately disabled signals — a shipped mini decision-ledger;
  (4) the dead constants (beta, density) sit exactly where universal values couldn't
  be found — the feature shipped switched off, which strengthens the beta lesson.
- **Brief errata:** none material. One nit: `model_json_to_middle_json.py:216` is
  `finalize_middle_json_from_preproc` (the final-pass entry is `result_to_middle_json`
  at :238); the breakdown doc's described "final document pass" spans both.
- **Not committed:** the parent artifacts (this brief, the distillate) are untracked
  in the main tree; committing the report alone would dangle references — left for
  the user's next batch commit.
