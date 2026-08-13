# TeXdig ledger — completed

Newest first. Evidence pointers are to commits, discussion docs, and artifact runs.

- **2026-08-13 — planning canon minted** (this tier): decisions/roadmap/ledger seeded from the
  0.2/0.3 remediation arc; Sol-plan decisions restated for owner re-ruling.
- **2026-08-13 — runstamp convention settled** (`7816325`): owner ruled `YYYYMMDD_HHmmss[_NN]`;
  AGENTS.md rule 4 + tests/README.md aligned; corrigendum on the source brief
  (`issues/infrastructure/briefs/artifact-writing-hygiene-and-housekeeping-20261108_224907.md`).
- **2026-08-13 — B-wave spot-check round**: two agy verification passes (waves 0–2, then B0–B3)
  confirmed every implemented claim at file level; close-list re-ranked (configured/baseline
  authority promoted and split 4-and-4); gauntlet single-file blind spot, dead-code undercount,
  determinism self-evidence gap, and 0.2-schema stem-collision risk identified. Reports in
  session scratchpads; substance folded into [roadmap.md](roadmap.md).
- **2026-08-13 — B-wave landed** (`573e050`, `texdig-census/0.3`): B0 contract lock (nine-store
  surface, occurrence/scope/summon/binding/disposition/invocation DTOs, tri-state signatures);
  B1 occurrence traversal (route-derived ids, diamond/repeat distinctness, explicit cycle cuts,
  deferred occurrences); B2 chronological binding machine (scopes: global/document/brace-group/
  environment/begingroup; immutable `\let` capture; conservative deferral); B3 site-time
  invocation attachment (`m/o/O{default}/s`, include-family full-filename evidence); atomic
  9-store publication; legacy `compile/{macros,traversal}.ts` deleted. Root-relative resolution
  parity landed in procurement (`latex.py`) and logistics with tests. Verified 211/211 across 14
  containers; two-run byte determinism (mini_article); 3-doc gauntlet 77,572 schema-valid rows,
  zero defects (`artifacts/test-runs/20261308_02*` — mis-stamped, see T13).
- **2026-08-12 — 0.2 waves 0–2 landed** (`09b5468`): physical-token-only census; buffered-bytes
  tree digest recomputed with mismatch refusal; strict decoding; ordinal sort + case-collision
  refusal; kind-specific witness equivalence (`witness-equivalence.ts`); span
  validate-don't-repair primitives (`core/spans.ts`); six normative stores schema-registered in
  jsonl_engine; exhaustive emission validation; atomic no-clobber publish; 11-store deferred
  surface. Verified 103/103 across 7 containers.
- **2026-08-12 — Sol swarm review → 0.2 plan approved**
  ([discussion](../discussion/sol-review-remediation-part-1.md)): 10 P1 / no P0 — census
  evidence could be false while gates passed. Eight-wave remediation plan approved by owner;
  supersedes the agy cut-2/3 sequencing.
- **2026-08-12 — cut-1 maturation** (pre-review, same day): utensils backfill (local-frame
  cases-in-math resolved; corpus 99.79% agreed); catcode arbitration; PS worker
  (`run-census.ps1`) + batch adapter; ph-zigzag 11/11 and kisungyou 23/23 collections batched;
  expansion lane v1 + cut-2 slice (macros/traversal/seq) — **superseded and deleted by 0.2/0.3**,
  retained as rewrite inputs in history only.
- **2026-08-12 — cut-1 census engine landed**
  ([brief](../briefs/engine-cut1-census-20260811_021819.md)): Gemini first cut cross-examined and
  rebuilt — real witness fusion, computed agreement, include graph on entity rows; first light
  2111.15058v3 = 5527/5547 agreed.
- **2026-08-10 — stage-1 output contract** (`a214fd4`→`80dd0f0`): three-tier store structure,
  id grammar, ordinal doctrine, four gates; agy contract cross-exam absorbed
  ([brief](../briefs/agy-stage1-contract-crossexam-20260811_021819.md)).
- **2026-08-09 — TeXdig founded** ([thread](../notes/TeXdig-chat-019fe5a1-923c-70b1-bc06-0e1f1389f9c0.md)):
  reboot ruling, five boundary stakes, unified-latex + latex-utensils substrate.
