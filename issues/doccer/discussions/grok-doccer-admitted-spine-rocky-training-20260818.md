# Admitted spine as Doccer witness (Rocky training)

**Date:** 2026-08-18.
**Status:** design note / census find. No engine mint. No durable adapter.
**Occasion:** pdf-prose Macy/Shannon extract. Page stage admits a linear spine; Doccer is meant to run *during IR assembly*, not over emitted markdown. Markdig head-to-head (F6) stays later. Whole-book master is a future scale exam.

**Posture:** recipes and a disposable witness now. The same recipes are the intended E2E path later (admit → collect/pair/suppress/materialize → JSONL). Promote a verb or kernel mechanism only after a composition-refusal argument (roadmap census rules).

F1 pressure-test brief (contract lessons, not a D-number): [sol-doccer-f1-shannon-spine-pressure-20260818](../briefs/sol-doccer-f1-shannon-spine-pressure-20260818.md).

Related: [src/doccer/README.md](../../../src/doccer/README.md), [status-registry](../planning/status-registry.md), [F1 OffsetMap](../planning/decisions.md) (drafted), [F6 markdown adapter](../planning/decisions.md), [grok-offsetmap-unicode](grok-offsetmap-unicode.md).

## The bet

Doccer discovers spans from a small delimiter inventory and named policies. It is not a parser. Residue stays visible. A flatten that leaves delimiter-shaped evidence on one `TextMaster` lets those faculties do the lifting a transcript parser would otherwise own (turns, quotes, cues, notes, specials, render).

pdf-prose owns **admission** (letters, reading order, furniture, image holes, newline hyphens). Doccer owns **the admitted string**. Markdown is a later consumer of the IR.

## Capability map (closed kernel vs this job)

K0–K7 and V0/V1 are closed (2751 checks). Incompleteness is missing families and narrow policies, not hollow APIs.

### Coordinate and identity

| Faculty | Use on an admitted spine | Gap / pressure |
|---|---|---|
| `TextMaster` | One master per work (Shannon, a Wiener essay); optional whole-book master as A0 | Host-endian fingerprint; F2 before persist |
| `TextTopology` | Ligature / unpaired surrogate / line grain stay honest | No Block/Script (F-UCD). GC + major class only |
| `EmitRuns` | Letter vs punct vs space; line extents | `FB00–FB06` are `OtherLetter` — classifier or inventory, not UCD yet |
| `TextSlice` | Talk slice on a book master; rebase child→parent | Parent→child is partial and loud |
| Allen / `LocatedRelation` | After flatten, cue **Meets**/**Before** a float hole; line *n* to *n+1* | No “near.” Page proximity dies at admission |

### Recognition

| Faculty | Use | Gap / pressure |
|---|---|---|
| `PatternRule` + `RegexCollector` | Inventory: `«»`, `[n]`, `Figure N`, `Name:`, footnote digits. `PerLine` or `WholeMaster`. Scoped by `Suppression.Admitted` | **PerLine cannot see the next line.** Setext, list interruption, ATX-vs-paragraph are not this collector |
| `Utf16UnitMask` + harvest | Today’s `Specials`: non-ASCII, ligatures, SHY, isolated surrogates | Classifier stamp is adapter |
| `SpanBatch` | All families on one ordinal universe | No extra payload column. Speaker name is span text or a later fact |

### Relating and isolating

| Faculty | Use | Gap / pressure |
|---|---|---|
| `ClaimSelection` / `Suppression` | Body channel = complement of marker/caption/note suppressors. Same claims remain queryable under another question | A1 walker when the book master is real |
| `ClaimPairView` | Cue vs hole; note marker vs note body | Public API is occurrence edges, not qualitative Allen-image |
| `Pairing.Pair` | Macy `«…»`. Strict stack, **top only**. Faults: unclosed / dangling / mismatched | Never searches below the top opener. CommonMark emphasis will not collapse to this. Do not silently widen `Pair` |
| `GapCadence` | Cadence of `Name:` in a discussion window | Thresholds stay orchestration |
| `Packing` / `Cover` / `Laminar` / `Hierarchy` | Year ⊃ talk ⊃ turn. Crossing is `Laminarizer` residue | No inferred parenthood without a named policy |
| `Segmentation` / `PathSelection` | Outline seeds as a complete partition of the book window minus plates | Complete path only. Gaps stay `CoverageGaps`. Prefer `PackingView` over widening D37 to partial paths |

### Facts, origins, rewrite

| Faculty | Use | Gap / pressure |
|---|---|---|
| K5 facts / saturation | Optional: “this span is talk s-0018” with outline+geometry support | No transcript ontology. No negation/variables |
| K6 origins | Admission → spine → render | Exact-middle compose; no automatic slot lifting |
| K7 `Materialize` | `textRender`: Copy ASCII; OriginMapped or Synthetic for `fi` / `\uXXXX`; elide SHY | **No OffsetMap.** Can emit the render master; cannot yet project a render-side claim back onto lossless under a named policy. F1; this job is the shaping consumer |

## Census finds (2026-08-18)

### Latent path — recipe, no engine work

- **Consecutive-start partition:** from this delimiter to the next (`Name:` turns; later maybe setext blocks). Grouping + next start, or candidate edges + first-ordinal path. Residue = preamble before first start, tail after last. **Recipe now.** If three adapters need the same 15 lines, reconsider a named helper — not before.
- Scoped collect: `Suppression.Admitted(Q)` then `RegexCollector`.
- Caption = cue claim `Meets`/`Before` a flatten-inserted hole span.
- Talk hierarchy = laminar family + `NearestContainers`.

### Missing example — inventory / store

- Macy/Wiener `PatternRule` JSONL (`«»`, `Figure N`, `Name:`, `\[\d+\]`, footnote digits). First non-markdown inventory.
- Render plan table: today’s `non-ascii.json` as a K7 plan builder (expand / elide / keep / escape). Still adapter data.

### Missing mechanism — composition-refusal required before mint

1. **F1 OffsetMap** (already drafted). Shannon forces Expand (`FB02`→`fl`, `\u2014`, surrogate escape), Delete (SHY), Identity elsewhere. Need `Exact | Range | Unmapped`, map compose, Residual projection. Harden on this catalog before NFC.
2. **Next-line scope.** Recipe first: `EmitRuns(LineIndex)` + `LocatedRelation` on consecutive lines + policy. If that stays ugly after one witness, a named `ExecutionScope.LineAndNext` is a contract candidate. Do not make `RegexCollector` a parser.
3. **Delimiter stack vs top-only pairing.** Second, separately named stack policy later if Markdig emphasis demands it. Reference `Pair` stays top-only.
4. **Run-on environments.** LaTeX `\begin/\end` pairs. Turns do not. Keep consecutive-start a recipe until setext/lists share it.
5. **Local flanking.** Adapter inspects previous/next `AtomFacts` and emits only flanking `*` as open/close, then pairs. Kernel harvest only if a second consumer wants the same neighborhood.

### Permanent adapter / page-stage policy

- Speaker identity, folio y-band, image sidecar, HTML-block state machines, any repair (insert a missing `»`, weld `1.` to the next line).

## Flatten contract (so the witness is honest)

Stage 1 must leave delimiter-shaped spans:

- original `⟨n⟩` / `[n]`
- `«` `»`
- `Figure N`
- `Name:` as text (not already `**Pitts.**`)
- footnote markers
- float holes as explicit spans, not vanished gaps
- outline cuts as seeds (facts with geometry are enough)

Raw page concatenation (running headers, folios) poisons the master. Pre-bolding speakers burns the turn specimen. Newline hyphens belong to admission, not Doccer.

Macy geometry that must **not** enter the master: image bboxes, top-8% bands, XY-cut cells. Those are page-stage. A ragged table left in the spine is a bad flatten, not a Doccer zone.

## E2E later, recipe now

Intended automation (not built):

```text
pdf-prose admit (per page) → spine master (per work)
  → inventory collect
  → pair / suppress / consecutive-start / laminar
  → K7 materialize render
  → JSONL IR (seq, claims, textEscaped, textRender, specials)
markdown ← consumer of IR
```

Until that pipeline exists, each step is a documented recipe or a disposable `packages/doccer` DLL witness. Do not merge Doccer into `pdf-prose.ps1`. Do not mint verbs for consecutive-start or “transcript parser.”

K8 can use Shannon as a real integrated specimen (pairing residue + fixed substitution with origins) instead of only toys. The 735-page master is A0/scale after the flatten is clean.

## Rocky order

1. Witness: admitted Shannon body master, inventory, pair `«»`, suppress markers, materialize, diff `textRender`. Catalog OffsetMap cases.
2. F1 on that catalog (ligature / SHY / `\u` / surrogate). Not NFC first.
3. Consecutive-start recipe for turns, written down, not a verb.
4. Book master as A0 (same inventory, plates as coverage gaps).
5. Markdig inventory on fixtures, faculty by faculty (ATX collect, fence pair, emphasis vs top-only, setext vs next-line). F5 is the scoreboard; F6 is the adapter.

## Witness run (2026-08-18)

Disposable recipe, not the E2E pipeline:

- `src/pdf-prose/inventories/macy-spine.jsonl`
- `src/pdf-prose/witness-doccer-spine.ps1`
- report: `ingestion/staging/macy-cybernetics-1946-1953/1950/doccer-spine-witness.json`

Admission: 196 blocks (`body` + `page-marker` + `float-caption`) plus 1 `U+FFFC` hole. Spine 86 859 units. Headers/folios dropped.

| Collect | n |
|---|---:|
| `guillemet-open` / `guillemet-close` | 51 / 51 |
| `page-marker` | 36 |
| `figure-cue` | 2 (`Figure 22` in prose + caption) |
| `float-hole` | 1 |
| `speaker-start` | 191 |

**Pairing.** 50 matches, 1 dangling `»`, 1 unclosed `«`, 0 mismatches. Not a count bug: offset 8812 is German-facing `»The«` (`00BB The 00AB`). The dangling `»` empties nothing; the following `«` binds the next real closer and the mismatch walks the rest of the spine until a leftover `«` at 84034. Residue did its job. Inventory policy later: either a second pair kind for `»…«`, or facing-aware compatibility — do not widen reference `Pair`.

**Suppression.** 36 page-markers excluded; admitted coverage 86 679 (spine minus `[n]`).

**Turns (recipe).** Consecutive-start on `Name:` from first `Pitts:` (7526) through closing `McCulloch:` (85 765–end). Counts: Pitts 43, Shannon 42, Savage 25, Licklider 24, McCulloch 23, Teuber 9, Mead 8, Wiener 6, Bateson 5, Hutchinson 4, Bigelow 2. Lecture preamble before 7526 is the intended residue.

**Materialize.** K7 plan 1141 pieces; output equals joined IR `textRender` plus `\uFFFC` for the hole (`renderMatch=true`, 88 052 units). OffsetMap catalog from this run: **Identity 776, Expand 365, Delete 0** (no soft hyphens). Expands seen: ligature `fi`/`fl`, default `\uXXXX` (including the hole), letters kept as Identity copies.

**Harvest.** Unit mask over render-specials units: 375 admitted spans, 0 boundary residue. IR listed 376 specials (one keep or adjacent merge — not investigated).

F1 still unbuilt; the Expand/Identity catalog is the shaping input.

## Witness run 2 — facing + OffsetMap probes (same day)

Word-local `»The«` pre-pass over-fit: it ate `» word «` boundaries between adjacent French-looking marks (27 false Germans). The book is diaphanes (Zurich–Berlin). The marks are **German `»…«` throughout**, including long quotations (`»That is wonderful…?«`) and `»language.«` (trailing period). Unicode LEFT `«` / RIGHT `»` are labels, not open/close.

Recipe now: run both conventions through unchanged `Pairing.Pair`; keep the one with more matches and fewer faults.

| Convention | matches | faults |
|---|---:|---:|
| `french-ab-bb` (`«` open, `»` close) | 50 | 2 |
| `german-bb-ab` (`»` open, `«` close) | **51** | **0** |

Chosen: `german-bb-ab`. Balanced. `Pair` was not widened.

**OffsetMap recipe** (not the F1 kernel): segments from the K7 plan with `src`/`dst` ranges; point query returns `Exact | Range | Unmapped`.

| Probe | src | result |
|---|---:|---|
| identity-interior | 17 | Exact → 17 |
| ligature-expand `fl` | 269 | Range [269, 271) |
| float-hole `\uFFFC` | 1739 | Range [1742, 1748) |
| default-escape | 4768 | Range [4781, 4787) |
| letter-keep | 10176 | Exact → 10231 |

5/5. `offsetMapDstLen` = render 88 052. Delete still 0 (no SHY). F1 should ingest this catalog: Identity → Exact, 1→n rewrite → Range, elide → Unmapped. No NFC in this job.

## Non-goals

Page geometry in Allen. Clustering in Doccer. Widening `Pair` or `PathSelection` to win Markdig. A durable PDF adapter inside `src/doccer`. Treating markdown as the Doccer input.
