# Harvest seed read — site records and first-mint evidence

Run: 2026-08-02, in-session (Fable). Basis: codex-scientiae `d870f8a`; utils `775905f` (mdnav).
Sources: the four genealogy files named in [roadmap](../planning/roadmap.md) queue item 1.
Lens: what each operation improvises → which primitive (D1–D24) subsumes it, or what it implies.
Dispositions: **covered** (exists in the surface) · **superseded** (workaround dies on adoption) ·
**adapter** (stays site-local by D10) · **candidate** (new engine-shaped demand) · **F-witness**
(registry entry for a deferred family).

## masks.ps1 — `src/shared/masks.ps1` (258)

| site | improvises | doccer mapping | disposition |
|---|---|---|---|
| `Get-NormalizedSpans` | span normal form: clamp, reversed-tolerate, drop-empty, sort, merge overlap+adjacency | `SpanSet.Create` normalization (D17) | covered |
| surrogate snap (edges snapped outward) | codepoint-safe span edges | engine is code-unit-honest (D1); snapping = a site *policy*, not engine behavior | adapter policy |
| `New-Mask` (text, regex) | regex overlay → span set | `RegexCollector` → `SpanBatch` → `SpanSet.FromClaims` | covered |
| `Complement/Union/Intersect/Sub-Mask` | the set algebra | `SpanSet.{Complement,Union,Intersect,Subtract}` | covered |
| `Test-MaskEmpty/Equal`, `Get-MaskCoverage` | predicates + covered-length | set equality/count; coverage = a D8-family named measure | covered / measure candidate |
| `Get-MaskedText` (blank-to-space) | length-preserving region isolation so a later regex can't fuse across boundaries | scoped collection — the collector "matches per admitted region, cannot bridge exclusions" *by construction* | superseded |
| `Get-MaskDensity` | count/locate register within a region | scoped collect + count; thresholds stay in consumers (D10) | covered |
| `Split-AtLevel` | line units with offsets | line topology + D21 `ByLine`. **Nugget:** leaves CR in unit text — a D15 divergence (latent bug class the engine kills) | covered |
| `Move-Mask` / `Limit-Mask` | change-of-basis; window restrict + rebase | D19 `ToParent`/`ToChild`, including the intersect-with-window-first recipe, exactly | covered |

The file's own fence ("no SoA columns, no LUT, no rule-table runner — escalate, don't build")
enumerates precisely what doccer built. Rediscovery confirmed wholesale.

## latex.ps1 — `src/latex-ingest/latex.ps1` (403)

| site | improvises | doccer mapping | disposition |
|---|---|---|---|
| `RxMathStructure`, `RxInlineDollar`, verbatim/comment registers, ligature `[ﬀ-ﬄ]`, U+FFFD, `\intertext`, glyph-leak, bare-number-row, self-cancel | domain register overlays | inventory rules — the LaTeX inventory pack, domain knowledge as **data** (D13) | covered |
| `Get-TexCommentMask` (raw − code), `TexExpandable` (¬(code∪comments)), `TexProse` (¬(math∪code∪comments)) | overlay compositions | SpanSet algebra / Suppression compositions (D3) | covered |
| `Test-IsMath`, `Get-TextProseWordCount`, `Test-TextSentenceInMath` | scoped density + threshold | scoped collect + count; `≤2`/`≥4` thresholds stay consumer (D10, D23 precedent) | covered |
| `Get-TextInteriorMask` | capture-group interiors as spans | collector capture-group claims (D9 validates identity) | covered |
| `Get-LatexBalance` | stateful depth scan: escape/command skipping, combined-literal interval policy, signed residuals | no primitive — scalar seam diagnostics stay site-local; the *span* side falls to the pairing lift below | adapter + pairing witness |
| `Get-EnvironmentSpans` + `Get-EnvironmentBalance` | stack-pairing `\begin/\end` into region spans; name-aware nesting faults `{unclosed_begin, dangling_end, mismatched_end}` | **missing algebra op — pairing lift** (witnesses 1–2); fault residue operationalizes "non-laminar residue = the defect inventory" | candidate |
| `Get-Unclosed…`/`Get-UnbalancedDelimiterSpans` | fault → repair-hint span (fault index to end) | derived from pairing faults; hint assembly = adapter | adapter |
| `DanglingOperator` (layout-strip + longest-first suffix + boundary guard), `DegenerateSubstack` (inner predicate), glyph fix-map | valid-but-wrong soft policies | consumer policy over collected claims (D10); fix maps = adapter data | adapter |
| `Get-MaskSpanRecords` | spans → `{start,end}` records | the D13 JSONL wire format | covered |
| `Get-NormalizedProse` | comparison-normalization (lossy, compare-only) | explicit normalization producer posture (D11); no map needed while compare-only | adapter |

## md-repair.ps1 — `src/audits/md-repair.ps1` (221)

| site | improvises | doccer mapping | disposition |
|---|---|---|---|
| `Get-MdLineIndex` | **byte**-offset line index, CRLF-aware content extents | engine lines are code-unit; this lane needs on-disk bytes — **F3 witness #1** | F-witness |
| fence toggle in `Get-MdHeadings` | "never read inside a fence" | collect fences → excluded scope (D3/D6) | superseded |
| heading regex + level/text | heading claims | collector rule | covered |
| `Get-MdHeadingVerdict` cascade | caption/label/furniture/section *meaning* | fails D10 on purpose — permanent consumer | adapter (by design) |
| `Set-MdSpan` | byte-exact splice with `-Expect` stale-anchor guard, `byte_delta` | **F1 edit application + F3 bytes**; `-Expect` = content-witness staleness (D1/F2 kin) | F-witness |
| `Repair-MdHeadings` back-to-front ordering | manual offset-drift dodge for batch edits | precisely the job F1's segment list does | F-witness |
| `Update-MdContents` | block extent (heading → next heading), preserve one line, regenerate, splice | partition-extent geometry + F1 splice; slugs via the one shared engine | covered + F-witness |

## mdnav.mjs — `utils/skills-dev/doc-dive/mdnav` (1165)

| site | improvises | doccer mapping | disposition |
|---|---|---|---|
| line table (byte offsets, CRLF/lone census, newline kind) | byte line index + terminator census | **F3 witness #2**; doc-level newline flag = the D15 named-view precedent | F-witness |
| fence state machine (char + length + closing rules) | fence pairing | **pairing witness #3** — parameterized open/close matching | candidate |
| ATX claims, breaks (prev-blank context), frontmatter, maxLine | structural collectors | collector rules (multiline where context-dependent) | covered |
| setext SUSPECTS (reported, never resolved) | two-producer ambiguity surfaced as data | F5's honest pair, already named in canon | F-witness |
| `subtreeEnd` derivation | tree-as-query over flat claims | the D12 thesis, operational | partition family |
| `activeAt` + `virtualRoot` (PREAMBLE/BODY) + `unitEnd`/`spanFor` | **total partition** at a selection policy; synthetic filler units; "nothing silently dropped" | generalization of D21 `ByLine` totality to claim-selected bases | **candidate** |
| `segmentsOf` (breaks basis), `computeWindows` (size + boundary-snap policy + UNBROKEN blob report) | alternate partition bases; declared boundary policy | same family; window snap = D8/D21-style named policy | candidate |
| anchors `Dnnn:Hnnnn@digest`, stale warnings, mtime/size fast path | identity + staleness | D1 kin; F2 sidecar donor (already canon) | covered / F-witness |
| `noiseSpans` (line-scoped; per-match `Buffer.byteLength` code-unit→byte conversion; keep-outer dedup; test+keep species) | scoped collect + containment dedup + evidence-carrying claims | collector + laminar admission (D2); byte conversion = **F3 witness #3**; keep-fragment = claim evidence + policy | covered + F-witness |
| strip/elide (placeholders ≥1 KiB, elided ledger, "elided ≠ covered") | suppression with evidence-preserving elision | Suppression + exclusions-recorded-as-evidence (D23 kin) | covered doctrine |
| `constructRuns` (ordered LINE_KIND first-match, run merge, SINGLETON no-merge, fence absorption) | per-line classify + run emission | PerLine collect with priority + `EmitRuns` break-key (D4) | covered |
| `cadence()` | gap statistics | D23 — the transcription source | covered |
| `compositionOf` (unit ∩ runs − noise, bucket %, top-3 ≥5%) | composition-by-kind within a window | D8-family named-measure candidate ("composition") | measure candidate |
| `coverage` (mergeSpans, coveredWithin, per-basis tallies, unread/partial) | set arithmetic + coverage measure + partition join | SpanSet + D8 coverage measure + partition views | covered / measure |
| `locate` `anchorAt` binary search; `marks` containing-heading | containment attribution | D24 `FindContaining` | covered |
| `grainOf` (per-depth count + median) | partition-size stats | D8-family (upper-median convention shared with D23) | measure candidate |
| workdir/LATEST/LAST, `assertNotDiscoverable`, inventory, reads ledger | run management, artifact hygiene | the D13 CLI car — instrument virtues canon already vows to conserve (F6) | CLI car |

## Synthesis

**The queued verb pair is confirmed by density.** Every file improvises regex→spans under
scope/suppression (→ `collect`: file + inventory + scope in, claims JSONL out), and three of four
carry the set algebra (→ a `spans` algebra verb: union/intersect/subtract/complement +
coverage/equality over claim-sets). `SpanSet` already holds the complete op surface for the
latter. Inventory packs surfaced ready-made: the LaTeX registers and the markdown construct
rules, both currently living as `$script:Rx*` variables and `LINE_KIND` tables — exactly the
domain-knowledge-as-data D13 prescribes.

**One genuinely new engine-shaped operation emerged: the pairing lift.** Three independent
witnesses (name-aware `\begin/\end` nesting; `\left/\right` sizing pairs; markdown fences with
char/length/close rules). Shape: open-claim and close-claim populations → paired-region claims
plus a fault residue (`unclosed`, `dangling`, `mismatched`). Deterministic, mechanical,
meaning-free — passes the D10 admission test — and the fault residue makes the "non-laminar
residue is the defect inventory" thesis operational. Candidate for a drafted contract (D14
proactive-closure slot); not a CLI verb yet.

**Second candidate, weaker: total-partition views** — selection policy → total partition with
derived extents and synthetic filler units (mdnav's PREAMBLE/BODY discipline), over multiple
bases (claims-at-policy, breaks, fixed windows with a declared boundary policy). It is the
claim-basis generalization of D21 `ByLine` totality; one deep witness (mdnav's core geometry)
plus md-repair's Contents-block extent. Registry until a second consumer bites.

**F-family witness tallies** (abstract triggers → named witnesses):

| family | witnesses from this read | posture |
|---|---|---|
| F1 OffsetMap / edit plans | `Set-MdSpan`, back-to-front batch application, Contents splice — all in a **live lane** — plus the graveyard `repair_*` farm (~30 scripts) | trigger effectively met; contract already drafted |
| F3 byte addressing | md-repair byte line index + splice; mdnav byte offsets throughout + per-match code-unit→byte conversion | three witnesses; successor-design decision per canon, but demand is now concrete |
| F5 agreement | setext suspects; the H1-vs-breaks `aligned` readout (a two-basis agreement fact mdnav already computes) | seed evidence for the honest pair |
| F2 persisted batches | mdnav sidecar (donor, known); inventory.json/reads.jsonl | unchanged — CLI manifests first |
| F6 markdown adapter | `LINE_KIND` + noise species + fence rules = the collector inventory F6 names | unchanged |
| F-UCD | no new demand sighted in these four | unchanged |

**Nuggets worth keeping:** `Split-AtLevel` leaves CR inside unit text (D15 divergence — the
engine's content-extent discipline kills this bug class); the surrogate snap-outward is a site
policy the engine correctly does not share; `Get-MaskedText` blank-to-space and md-repair's
fence toggle are both scoped-collection workarounds that die on adoption; mdnav's noise dedup is
laminar containment admission in the wild.

## First-mint proposal (evidence basis; user ratifies)

Mint exactly the queued pair — `collect` and the span-algebra verb — at task grain with
inventories as data. The pairing lift goes to contract drafting as the next decision candidate.
Total-partition views and the named-measure growth (composition, coverage, partition-size
stats) enter the future-consumer registry, which for now lives as the tables above; graduation
follows the standing abductive census.
