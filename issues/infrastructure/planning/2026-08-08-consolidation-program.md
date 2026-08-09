# Consolidation program — latex-ingest legacy onto engine + shared primitives

Date 2026-08-08. A decomposition map, not a spec. Records how three related renovation threads relate and
sequence, so each can be brainstormed and executed as its own sub-project. Fits the `AGENTS.md` charter:
disentangle concerns, repair emergent bad patterns, separation of code and config.

## Origin

The extraction of reusable primitives from `latex-patch.ps1` (thread 1) surfaced a larger opportunity:
some hand-rolled latex-ingest legacy is now replaceable by primitives already built in the `jsonl_engine`
+ PowerShell client, and some latex-ingest *concepts* are waiting to be promoted into the engine as
structural archetypes. The organizing boundary across all three threads is one question: **what belongs
as a PS-native primitive, what should be replaced-by the engine, and what should be promoted-into it.**

## Decisive finding (reshapes thread 2)

The engine already *has* the catalogue machinery. `Registry` (base of `InventoryRegistry`) is keyed,
unique, canonically ordered, wholly rebuilt: `collate()` validates → keys by schema `x-identity` →
refuses duplicates → returns canonical order; `rebuild(entries)` writes a byte-reproducible
`inventory.jsonl` + `.sig`; `KeyComparison` carries the ordinal-sort/caseless-dedupe distinction. Brief
open-Q #4 ("the engine still lacks unique-key/canonical-sort") is effectively **resolved in Python**.
What is missing is only the **CLI surface**: no registry-rebuild verb exists (only `capabilities`,
`schemas`, `json`, `validate-json`, `deposit`, and readers). So thread 2 is *expose + migrate*, not a
from-scratch engine build — the same shape the `deposit` verb followed.

## The three threads

| # | What | Nature | Boundary | Depends on | Status |
|---|------|--------|----------|------------|--------|
| 1 | PS-native primitive extraction: `portable-path` (+`Test-PathWithinRoot`), `file-bytes`, `authored-jsonl` | Small; ready | Genuinely PS-side — hot-path safety + tolerant authored-JSONL the engine deliberately won't touch. **Leaves `inventory-catalog.ps1` untouched** (thread 2 retires it) | nothing | **spec written**, entering plan |
| 2 | Retire `inventory-catalog.ps1` onto the engine | Medium | Add a registry-rebuild CLI verb → migrate the caller via the PS client. Decision: headerless `inventory.jsonl` → engine's headered + `.sig` form (corpus wipe due, so supersession strands nothing) | engine (machinery exists), CLI verb | not started |
| 3 | Promote the **Ledger** archetype into the engine | Largest; design-heavy | Engine has `Registry` (rebuilt) + `ArticleManifest` (sentinel) but no append-only, outlives-its-sources store. `APPEND` discipline exists; the archetype + CATEGORY layer (brief §2) do not. Instances waiting: `probe-ledger.ps1`, devops run-ledger | engine archetype design | not started |

## Sequence: 1 → 2 → 3

- **1** clears underbrush, is independent, and makes the surrounding code legible for the rest.
- **2** uses machinery that already exists (needs only a CLI surface) and kills a self-declared
  placeholder — `inventory-catalog.ps1`'s own docstring says it is a stopgap "while the replacement
  shared JSONL substrate is still unintegrated."
- **3** is the deepest design (the brief's taxonomy work actually lands here) and benefits from 1 and 2
  being settled first. Intersects `issues/devops/briefs/opus-resumable-stages-run-ledger-…`.

Each thread runs its own spec → plan → implementation cycle.

## Pointers

- Thread 1 spec: [primitive-extraction-design](../../shared-primitives/planning/2026-08-08-primitive-extraction-design.md).
- Session synthesis: [opus-sol-session-synthesis-and-loose-ends](../../jsonl_engine/briefs/opus-sol-session-synthesis-and-loose-ends-20260808_141747.md).
- Taxonomy source (Ledger/Catalog/Exhibit, CATEGORY layer): [opus-engine-state-and-next-sequence](../../jsonl_engine/briefs/opus-engine-state-and-next-sequence-20260807_141055.md) §2, and the `opus-jsonl-engine-taxonomy-and-ref-graph` discussion.
