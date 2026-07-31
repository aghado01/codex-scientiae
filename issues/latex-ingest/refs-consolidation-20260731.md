# Reference resolution: five passes, one fact — consolidating into a `refs` stage

**Status:** design brief, pre-implementation
**Date:** 2026-07-31
**Touches:** `src/latex-ingest/latex-ingest.ps1`, `src/latex-ingest/tex-docgraph.ps1`, `src/latex-ingest/stores/docgraph.json`

---

## 1. The finding

Five separate passes over one document derive overlapping reference facts. They disagree in
structure, one of them is computed and thrown away, and the gaps between them have been filled
downstream with post-hoc recovery rather than upstream guarantees.

| pass | derives | fate |
|---|---|---|
| `Build-LabelMaps` | `thm`, `eq`, `fig`, `tab` label→number | **`thm` DISCARDED** one line later; rest kept |
| `Convert-CrossRefEnvs` | `thm`, `sec` label→number; `types` label→display; `objects` | authoritative |
| `Resolve-CustomCounters` | custom counter label→value | kept |
| `tex-docgraph` | label→type, reference edges | separate artifact, **no numbers** |
| `Get-RefSemantics` | per-macro usage + cleveref relevance | separate scan of source |

### 1.1 The discarded numbering

`latex-ingest.ps1`:

```powershell
$maps = Build-LabelMaps $body        # numbers theorems into $maps.thm …
$maps.thm = $xref.thm                # … and this discards them, one line later
```

`Build-LabelMaps` runs a **flat** theorem counter — no `[section]` scoping, no shared counter
groups, no `\newtheorem` model. `Convert-CrossRefEnvs` runs the correct model. The flat result is
computed on every conversion and overwritten before anything reads it.

This is not merely wasted work. It is a second, *wrong* numbering implementation living one
assignment away from being load-bearing. Any future edit that reorders those two lines, or that
reads `$maps.thm` between them, silently produces wrong cross-reference numbers corpus-wide.

### 1.2 The gaps filled downstream instead of upstream

- The **subject index** originally recovered each object's label by string-searching the *rendered
  markdown*, because the object's optional-argument title was captured during the cross-ref walk —
  before the numbering table that walk builds existed. Fixed 2026-07-31 (`a08656ce`) by resolving
  the captured notes in memory afterward, through the same `Resolve-Refs` and maps. That fix is
  correct but is still a *second* resolution call bolted after the first, not a stage that resolves
  once and hands both consumers a finished model.
- The **docgraph** carries `label → type` but no numbers, so it cannot answer the one question a
  reference consumer actually asks ("what does `\cref{thm:x}` render as?"). It was built beside the
  tangle rather than replacing it, which is why it is a half-measure.
- `Get-RefSemantics` re-scans the source for the same macro family `Resolve-Refs` later rewrites.

---

## 2. What a consolidated stage owns

One stage, run once, producing a model that both **document assembly** and the **subject index /
TOC** consume. Nothing downstream re-derives, re-scans, or recovers from rendered output.

**Labels** — every declared target:

```
label -> { kind (env), display (Theorem), number (2.1), class (assertion|construction|commentary),
           identity (thm:weakfactor), source_file, char_offset }
```

**References** — every citation site:

```
{ macro (cref|Cref|ref|eqref|…), target(s), resolved_text, in_heading, source_file, char_offset }
```

**Derived, free:** the relevance probe (a fold over the reference sites, not a fresh scan); the
edge list (already implied by the reference sites); the per-kind tallies the oracle wants.

### 2.1 The ordering constraint that is real

A forward `\cref` cannot resolve during the walk that builds the numbering table. That is inherent,
not sloppiness. The stage therefore has **two phases**, both internal to it:

1. **collect** — walk the source once, assigning numbers under the counter model, recording every
   label declaration and every reference site verbatim
2. **resolve** — with the table complete, render every reference site's text

Consumers only ever see the post-resolve model. The current code exposes phase-1 output to
downstream consumers, which is precisely why they have to patch around it.

### 2.2 What collapses

- `Build-LabelMaps` — deleted; its eq/fig/tab counters move into collect, its thm counter dies
- `Convert-CrossRefEnvs` — keeps its *emission* role (rewriting `\begin{theorem}` to a bold run-in
  header); its map-building role moves into the stage
- `tex-docgraph` — becomes a **projection** of the model, not an independent scan
- `Get-RefSemantics` — becomes a fold over collected reference sites
- `Get-LatexSubjectIndex` — reads the model directly; keeps only the markdown lookup for
  `byte_start`, which genuinely cannot exist until the text is final

---

## 3. Naming

`docgraph` retires. The artifact is about **references** — their declaration, numbering and
resolution — not about document structure generally (sections already live in the TOC sidecar).

Candidate: `refs.ps1` exposing the model plus the resolver, emitting `{slug}.refs.jsonl`. If the
stage owns resolution and not just structure, "graph" names its data rather than its job — but
`refsgraph` is acceptable and reads clearly against the retiring name.

---

## 4. Migration order

The numbering model is what the figure-count oracle and every `\ref` in the corpus depend on. It is
the one part of latex-ingest where being quietly wrong is expensive, so each step must leave the
oracle verifiable.

1. **Pin current behaviour.** Golden test: for a fixture paper, assert the full resolved
   `label → number` table and the rendered text of every reference site. This is the invariant the
   refactor must not move. Without it, every later step is unfalsifiable.
2. **Delete the discarded `thm` numbering** from `Build-LabelMaps`. Pure subtraction, no behaviour
   change, removes the wrong-model-adjacent-to-live-code hazard. Golden test must not move.
3. **Extract collect+resolve** into the new stage, with `Convert-CrossRefEnvs` calling it rather
   than owning it. Emission stays where it is. Golden test must not move.
4. **Repoint consumers** — `Resolve-Refs`, `Get-LatexSubjectIndex`, oracle counts — at the model.
   Delete the post-hoc note-resolution added in `a08656ce`; it exists only to bridge the gap this
   step closes.
5. **Reduce `tex-docgraph` to a projection.** Its store (`stores/docgraph.json`) keeps the class
   taxonomy; the environment/sectioning/transparent lists become the collect phase's cues.
6. **Re-run the gauntlet** and compare oracle counts before/after across the battery, not just the
   fixture.

Steps 1–2 are safe and worth doing even if the rest is deferred.

---

## 5. Why this is worth doing before the standalone server

The standalone latex-ingest MCP server has to decide what a run *produces* and what downstream can
*consume*. A reference model that is authoritative, single-sourced and serialized to the run dir is
exactly the artifact that decision wants to be built against. Retrofitting it afterward means the
server's tool surface gets shaped around the current tangle.

It also removes the last reason the subject index needs the markdown for anything but offsets, which
is the remaining instance of the write-then-recover pattern in this lane.
