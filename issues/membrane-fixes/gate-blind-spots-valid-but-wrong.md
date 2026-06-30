# Membrane gate blind-spots: detecting valid-but-wrong math

**Status:** IMPLEMENTED 2026-06-30 — all detectors incl. the `prose_seam_merge` cross-chunk pass; suite 341 green.
**Origin:** polishing `corpora/voroninski/1611.03935v1` (PhaseMax) to demo-clean, 2026-06-30
**Engine:** `src/fidelity.ps1`, `src/latex.ps1`
**Related:** `voroninski-1611-demo-clean` (memory), the `no-magic-string-structural-heuristics` principle,
`first-light-voroninski-findings` (the prior three root-cause gaps in `Get-LatexBalance`)

---

## Implementation status (2026-06-30)

**Landed.** The `severity` field is on every signature row (`src/fidelity.ps1`): the frozen gate
`Get-CorruptionType` filters to `hard` (corpus A/B differential byte-identical — the legacy `glyph[...]` in
1109.4499v1 confirmed glyph detection had to be *soft*), the new `Get-SoftReviewType` reads the `soft` band,
and `Invoke-Fidelity` routes a soft match to `needs_review`. Six soft detectors shipped in `src/latex.ps1`
with span localizers, playbook recipes (`src/playbook.ps1`), and pinned regressions (`tests/detectors.Tests.ps1`):
`glyph_name_leak`, `dangling_operator` (T1); `text_sentence_in_math`, `bare_number_row` (T2); `degenerate_structure`,
`hallucinated_subexpr` (T3). `get_hotspots` now falls back to `review_reason` for the work-list `type`
(`src/serving.ps1`). Real-world read-only check on 2008.10579v1 (873 chunks): hard-gate count unchanged (29);
new soft flags = glyph 37, text_sentence 13 (~85%+ precision on eyeball — mostly theorem/proof prose merged
into formulas), dangling 1 — all previously shipped as `faithful`.

**N3 subsumed by routing.** Because soft signals grade `needs_review`, they already appear in
`Get-FinalReview`'s flagged list (it includes `needs_review`) and in `dispatch`/`get_hotspots` — no separate
`tells` field was needed. They behave exactly like the existing `needs_review` kinds (cleared on `apply` at the
worker's discretion; the apply gate stays hard-only, so a low-confidence soft signal never strands a chunk).

**`prose_seam_merge` (T2a) — LANDED 2026-06-30.** The cross-chunk pass is built as `Set-SeamMergeFlags`
(`src/fidelity.ps1`), run over the ordered chunk list inside `Invoke-Fidelity` before the per-chunk grading
loop. Because it needs neighbours (not per-chunk content), it is NOT a signature-table row: it sets a stored
`seam_merge {start,end}` field — like `level_uncertain` / `math_dirt` — that the grader (a new
`needs_review` branch) and the inventory (`Get-ChunkIssues` reads the stored span) consume, so a cross-chunk
signal flows through the body-blind per-chunk serving layer. Signal: a formula's `\text{}` prose (normalized,
≥12 chars) appearing verbatim at a NON-formula neighbour's seam edge (`Get-NormalizedProse` strips the
`\text{}`/`$…$`/punctuation difference). `apply` clears `seam_merge` on a merged fix (`src/serving.ps1`); the
recipe is in `src/playbook.ps1`; tests in `tests/detectors.Tests.ps1` (+ the playbook-coverage count → 18,
3 needs_review kinds). Live read-only check on 2008.10579v1: **20 seam merges** (`\text{In the first
inequality, we used}`, `\text{Then the following all hold:}`, …), 4 of which headline as `prose_seam_merge`
(the rest co-fire a higher-precedence soft signal and carry seam in their work-order). Note: the catch in the
brief that word-count alone cannot separate short merges (chunk 36) from legit `\text{}` is exactly why this is
the *verbatim-neighbour* signal, not a length threshold.

---

## Root finding

The fidelity gate `Get-CorruptionType` (`src/fidelity.ps1:142`) is a first-match scan over the ordered
`$script:CorruptionSignatures` table (`src/fidelity.ps1:104`). **Every signature in that table tests
structural _validity_** — unbalanced delimiters/environments, alignment-tab-outside-environment, whole-chunk
prose-vs-math mislabel. Balance is *necessary but not sufficient* for a correct transcription, and nothing in
the table tests sufficiency.

Result: a chunk that is **structurally valid LaTeX but semantically wrong** grades `faithful`, reaches the
deliverable, and is never surfaced for review. The gate's own `agreement` score may dip, but `agreement` only
*ranks* the work-list — it never *gates* (`src/fidelity.ps1:236`). So these defects are invisible to
`flagged`/`pending` and pass `finalize`.

This is the engine-level statement of the standing "membrane-clean ≠ clean deliverable" finding.

---

## Evidence — the 1611.03935v1 cluster

All of the following graded `faithful`. The first was the paper's central equation.

| # | Chunk | Corruption | Why the gate passed it |
|---|---|---|---|
| 1 | 12 | **PhaseMax LP destroyed**: `\max_{\substack{s . t . \\ s . t .}} \langle \phi, x \rangle` — objective + both constraints gone, replaced by a degenerate `\substack` of bare text | braces balance; `\max`,`\langle`,`\substack` ⇒ `Test-IsMath`=true (`src/latex.ps1:102`) ⇒ neither `unbalanced_delimiters` nor `prose_in_formula` fires |
| 2 | 33 | **OCR-hallucinated row** appended to Lemma 3: `\\ \\ \sum_{i=1}^{n} \log\|k_i - k_i - i\| + \log\|i - a_i\| + …` (symbols `k_i` appear nowhere else; `k_i - k_i` ≡ 0) | valid sums/logs/`\|…\|`; balances. No signal for self-cancelling / out-of-vocabulary subexpressions |
| 3 | 36 | **prose-tail-merge**: `… \right ] \\ \text{we will take} \delta_1 < K .` (duplicate of chunk 37's "Later, we will take δ₁ < K") | prose is **sheltered inside `\text{}`** — see below |
| 4 | 42 | **prose-tail-merge, truncated**: `… 3\epsilon \\ 1/2 , \epsilon & = 2\delta/(9\pi) . \text{Further, choose} \delta_0 \text{such that} \delta_1 <` (ends on a dangling `<`) | sheltered prose + dangling operator; both unmodelled |
| 5 | 44 | **prose-tail-merge, truncated mid-word**: `… . \\ \delta_1^{-2}\log\delta_1^{-1} \text{for a sufficiently large} c_0 , \text{then} P(E_1) ≥ … . \text{Using standa}` | sheltered prose, truncated token `standa` |
| 6 | 49 | **duplicated lead-in row + stray page number**: `\begin{aligned} e_1 \, \text{and} x_1 & = \cos\theta\,e_1 + \sin\theta\,e_2 . \ \text{The expected value is} \\ … \\ & \quad 4 \end{aligned}` (first row dupes chunk 48's tail; trailing `& \quad 4` is a page number) | sheltered prose at the seam; a bare integer on its own aligned row |

Also seen in sibling papers (not 1611): **`glyph[…]` literal leaks** (`glyph[negationslash]`,
`glyph[lscript]`, `glyph[greaterorequalslant]` — 43× in 2008.10579v1, 22× in 1807.04261v1) and
**hallucinated VLM figure captions** ("temperature distribution … 1°C" on an optimization-landscape figure).

### Why the `\text{}` cases are invisible (the precise mechanism)

`prose_in_formula` fires when a formula chunk is *not math* per `Test-IsMath` (`src/fidelity.ps1:121`).
`Test-IsMath` (`src/latex.ps1:102`) counts prose-words (`RxProseWord = [A-Za-z]{4,}`) in the **complement of
the math-structure overlay** and returns `prose ≤ 2`. But `RxMathStructure` (`src/latex.ps1:76`, the
`\[A-Za-z]+\s*\{[^{}]*\}` branch) matches `\cmd{...}` **including its braced interior** — so the natural
language inside `\text{we will take}` is *inside* the structure mask and never reaches the prose counter.

Legitimate math `\text{}` is a short label (`s.t.`, `where`, `for all`, `if`, `otherwise`). A `\text{}`
carrying a sentence fragment is corruption — but the current detector cannot tell them apart, because it only
counts **un-sheltered** prose. This is exactly why chunk 14 (whose `\intertext` prose spilled *outside*
`\text{}`/`$…$`, and which also had an unbalanced `(`) was the *only* member of this family the gate caught.

---

## Architectural spine — don't move the frozen gate

The first-match gate `Get-CorruptionType` is **pinned by the corpus A/B differential** (the legacy baseline of
3 papers; see `tests/corpus.Tests.ps1`). New detectors must not silently re-grade those baselines.

**Mechanism: add a `severity` field to each signature row.**

- `Get-CorruptionType` (the gate → `suspect`) filters to `severity = 'hard'`. Every existing row is `hard`,
  so the frozen verdict and precedence are **unchanged**.
- A new path (extend `Invoke-Fidelity`, `src/fidelity.ps1:314`) checks `severity = 'soft'` rows and routes a
  match to the **existing `needs_review` lane** (`src/fidelity.ps1:333-345`), the same grade already used for
  `heading_level_unknown` and `unwrapped_math` — faithful content the agent still reviews. Soft signals never
  touch accept/reject.
- `Get-ChunkIssues` (the inventory/dispatch derivation, `src/fidelity.ps1:163`) reads **all** rows
  (hard + soft), so the composed work-order surfaces every issue. One table, two derivations — the existing
  discipline holds.

This keeps the zero-FP wins on the hard gate while letting the lower-confidence structural tells ride the
review lane without perturbing the pinned baseline.

---

## Proposed detectors (tiered)

Each new row follows the existing shape (`type` / `Test {param($type,$content)…}` / `Diag`), plus `severity`,
and a `Get-IssueSpans` case (`src/fidelity.ps1:66`) for localization.

### Tier 1 — deterministic, ~0 false-positive, ship first

**T1a · `glyph_name_leak`** — `severity = 'hard'`
```
Test = { param($t,$c) $c -match 'glyph\[[a-z]+\]' }
Diag = { param($t,$c) ([regex]::Matches($c,'glyph\[([a-z]+)\]') | % { $_.Groups[1].Value }) -join ',' }
```
Repair recipe = a fixed `glyph[name] → \cmd` substitution map (`negationslash→\neq`, `lscript→\ell`,
`greaterorequalslant→\geq`, `lessorequalslant→\leq`, `negationslash`, …; extend as the corpus surfaces more).
No judgment, no FP (no legitimate text contains `glyph[...]`). Clears the 65 leaks in 2008/1807 immediately.

**T1b · `dangling_operator`** — `severity = 'soft'`
A math chunk whose content, after trimming trailing whitespace / `\\` / `\end{...}` / `\quad`, terminates on
an infix or relational operator token (`< > = \le \leq \ge \geq \neq \approx \to + - \pm \times \cdot \div`).
Structural: the math is grammatically incomplete (an operator with no right operand at end-of-chunk).
```
Test = { param($t,$c) $t -eq 'formula' -and (Test-DanglingOperator $c) }   # new predicate in latex.ps1
```
FP guard: only fire at **end-of-chunk** (a row ending in `+` mid-`aligned` with a continuation row is fine —
that's not the chunk's final token). Catches chunk 42 (`δ_1 <`) exactly.

### Tier 2 — principled, needs cross-chunk context

**T2a · `prose_seam_merge`** — `severity = 'soft'` (the real fix for tail-merge)
A formula chunk whose edge prose (head row or tail row, including `\text{}` interiors) appears **verbatim** as
the suffix/prefix of the adjacent prose chunk. This is a cross-chunk seam check, so it lives as an
assembled-level pass — a **sibling to `Find-MathClosureIssues`** (the existing assembled closure scanner
referenced in `src/fidelity.ps1:19`), not a per-chunk row. Highest precision: legitimate math `\text{}`
(`where`, `s.t.`) does not duplicate a neighbouring paragraph. Reliably catches chunks 36, 49, and the head/
tail half of 42/44.

**T2b · `text_sentence_in_math`** — `severity = 'soft'` (per-chunk partial of T2a)
Reuse the existing `Get-TextInteriorMask` (`src/latex.ps1:105`): measure prose-word density **inside** `\text{}`
blocks of a formula and flag when total sheltered prose-words exceed a sentence threshold (≈4). Catches the
heavier merges (44: "for a sufficiently large … then … Using standa"; 42: "Further choose such that") on their
own. Marginal on the short clauses (36) — those need T2a. Document this coverage gap; do not lower the
threshold into FP territory (legit `\text{}` annotations cluster at 1-2 words).

**T2c · `bare_number_row`** — `severity = 'soft'`, cheap add
An `aligned`/`array` row that is a lone integer (e.g. `\\ & \quad 4`) — a page/footnote number leaked into
math. Catches the chunk-49 trailing artifact.

### Tier 3 — defer to the agent tier + upstream converter

These are genuinely *semantic* and outside a deterministic gate's reach:

- **`hallucinated_subexpr`** — self-cancelling `X - X`, repeated identical terms, symbols absent from the rest
  of the document (chunk 33). A narrow `X - X` rule is cheap and high-precision but low-recall; full
  hallucination detection is undecidable here. Optional flag-only.
- **`degenerate_structure`** — `\substack`/`\max`/`\min`/`\arg…` with no math atoms in the body (chunk 12, the
  worst single defect). Narrow and targetable, but "is this equation semantically complete" generalizes to
  undecidable. Worth a *specific* degenerate-pattern rule, not a general one.
- **`vlm_caption`** — boilerplate image alt-text ("The image is a graph that shows…") and captions whose
  vocabulary is disjoint from the document. This is really an upstream captioner problem; the correct home is
  the future non-hallucinating converter, with at most a flag-only signal here.

**Boundary statement:** "is this the *correct* equation/caption?" cannot be gated deterministically — it
belongs to the agent review pass and the upstream PdfPig/geometry converter. What the gate *can* gain is the
**structural tells** of corruption (Tiers 1-2): glyph leaks, dangling operators, smuggled sentences, seam
duplication, stray number-rows. That converts "silently faithful" into "surfaced for review," which is the
whole scope.

---

## Coverage check (which detector catches which defect)

| Defect | T1a glyph | T1b dangling | T2a seam | T2b text-sentence | T2c bare-num | Tier 3 |
|---|:--:|:--:|:--:|:--:|:--:|:--:|
| 12 PhaseMax LP | | | | | | ✓ (degenerate) |
| 33 hallucinated row | | | | | | ✓ (subexpr) |
| 36 `we will take` | | | ✓ | ~ | | |
| 42 `Further, choose … <` | | ✓ | ✓ | ✓ | | |
| 44 `Using standa` | | | ✓ | ✓ | | |
| 49 lead-in + `\quad 4` | | | ✓ | ~ | ✓ | |
| glyph leaks (2008/1807) | ✓ | | | | | |

Tiers 1-2 cover the entire tail-merge class (the bulk of what was hand-fixed). Tier 3 holds the two
genuinely-semantic cases.

---

## Test & corpus-pinning plan

- New per-signature predicates → unit cases in `tests/detectors.Tests.ps1` (where the delimiter/interval
  classes are already pinned), each with a positive fixture drawn from the chunk evidence above and a negative
  fixture from a legitimate `\text{}`/operator-break.
- **Corpus A/B invariance:** add an assertion that `Get-CorruptionType` (hard gate only) returns identical
  verdicts on the 3 baseline papers before/after — the `severity` filter must be a no-op on existing rows.
- Re-grade the voroninski set after landing Tier 1-2 and diff the new `needs_review` counts; spot-check for
  false positives on the already-clean 1611.03935v1.
- Playbook coverage (`src/playbook.ps1`): each new soft type needs a repair recipe so dispatch can route it
  (the same coverage test that forced `unclosed_environment`'s recipe).

---

## Sequencing recommendation

1. **Tier 1** (`glyph_name_leak` hard + `dangling_operator` soft) — small, zero/near-zero FP, immediate
   corpus-wide value (65 glyph leaks alone). Land with the `severity` field + the corpus-A/B invariance test.
2. **Tier 2a** (`prose_seam_merge` assembled pass) — the principled fix for the class we actually hit; heavier
   because it needs the seam, but it's the one that earns its keep.
3. **Tier 2b/2c** as cheap follow-ons.
4. **Tier 3** only as flag-only, or leave to the agent tier / converter rebuild.

---

## Companion scope: arming the agent's semantic read (the irreducible half)

The detectors above catch *structural tells*. But the two worst defects (the destroyed PhaseMax LP, the
hallucinated Lemma-3 row) have **no deterministic signal** — they were caught only by *reading the math for
sense*. We agree that catch is irreducibly the agent's job. The problem is the workflow neither **delegates**
it explicitly nor **equips** the agent to do it. Two structural reasons:

1. **The law of exposure blinds the worker** (`src/PROCEDURE.md:10-22`). "You repair what you are shown,
   where you are shown it... Never load a document to look for what to fix." A `faithful` chunk is never
   dispatched, so no worker ever reads chunk 12. This is correct for scaling — but it means the per-unit loop
   *cannot* catch an unflagged semantic defect, by construction.
2. **The one holistic read is unarmed.** `review_document` / `Get-FinalReview` (`src/finalize.ps1:113`) is the
   sole pass over the assembled body — but it returns the full body plus only the **`flagged`** chunks
   (suspect/needs_review/needs_repair, finalize.ps1:116). The semantic misses are `faithful`, so they are
   absent from the targeted list, and the framing (`PROCEDURE.md:110-112`, tool desc `mcp-server.ps1:57`) is a
   soft "anything you catch, fix" with **no statement of what to look for** and **no statement that `faithful`
   is unverified**.

These nudge surfaces mirror each other and must stay in lockstep (the "never fork the workflow" rule,
`playbook.ps1:8`): PROCEDURE.md prose ↔ `playbook.ps1` recipe data ↔ MCP tool descriptions ↔ `Get-FinalReview`
output. A change to one is a change to all four.

### N1 · Make the delegation explicit (the meta-nudge — highest leverage, lowest cost)

Add to the `review_document` framing (`PROCEDURE.md:110`, `mcp-server.ps1:57`):

> `faithful` means the chunk's LaTeX is **structurally valid** — delimiters, environments and labels balance.
> It does **not** mean the math is correct. The gate never reads an equation for sense; that is *this pass's*
> job. Read every display equation as a mathematical statement, not a string.

Naming the handoff is most of the fix: the agent reasons far better about a defect class once it knows the
machine explicitly did **not** check it.

### N2 · A semantic-completeness checklist for the holistic read

Replace "anything you catch" with the concrete tells (the ones used to find these). In `PROCEDURE.md` step 2,
terse in the tool description:

- **Completeness** — does each equation parse as a *complete* statement, or does it end mid-operator (`… <`),
  carry a degenerate construct (`\substack{s.t.}`, a `\max`/`\min` with no objective), or read as thinner than
  its label implies (a numbered display that is just "operator + one atom")?
- **`\text{}` sentences** — does any `\text{}` inside math read as a *sentence fragment*, especially one that
  duplicates the surrounding paragraph? That prose was merged in from the next line; it belongs to the
  neighbour, not the equation.
- **Symbol provenance** — a symbol that appears in exactly one equation and **nowhere else** in the document
  (`k_i`) is a hallucination tell. Real notation is introduced, then used.
- **Figure captions** — does the caption plausibly describe *this paper's* subject? A phase-retrieval landscape
  captioned "temperature distribution … 1°C" is a VLM hallucination, not a figure.

### N3 · Compose the soft detectors into an attention list (the join between the two halves — code)

Extend `Get-FinalReview` (`src/finalize.ps1:113`) to return a new **`tells`** array alongside `flagged`:
the `faithful` chunks where a Tier-1/2 *soft* detector fired (`dangling_operator`, `text_sentence_in_math`,
`prose_seam_merge`, `glyph_name_leak`). The soft signals then **don't have to gate** — they *focus* the
holistic read: "these N faithful chunks have structural tells; read them first." This is the payoff for the
`severity='soft'` design: the deterministic layer can't decide these, but it can point the agent's eyes.
`get_hotspots` / `dispatch` keep returning only hard+soft *flagged* work; `tells` is review-only.

### N4 · Source is ground truth (capability nudge — the move that actually fixed eq 1)

The workflow never tells the agent that the **LaTeX source is fetchable and authoritative**. Add to the
playbook / `PROCEDURE.md`:

> When an equation reads as destroyed or truncated and the paper is on arXiv, acquire its source
> (`codex-scholar acquire id=<arxiv> artifacts=["source"]` → `.tar.gz` in `_inbox`) and restore the equation
> from the `.tex`. **Do not reconstruct the paper's mathematics from memory.** The acquisition lane is part of
> the repair toolkit, not just intake.

This makes the converter-loss recovery loop (acquire → verify/restore) a sanctioned, documented move rather
than something an agent has to invent.

### N5 · A bounded seam carve-out for the worker

The law of exposure forbids "looking around," but tail-merge corruption *straddles* the chunk boundary. Sanction
a single `get_slice id context=1` glance at the **seam** when a fix is boundary-local — the duplicated prose
belongs to the adjacent chunk and confirms the deletion. Add to the per-unit loop (`PROCEDURE.md:57-79`) and to
the `intertext` / new `prose_seam_merge` recipes. Narrow and explicit, so it doesn't erode the navigate-don't-scan
discipline.

### N6 · New `playbook.ps1` recipes (nudges-as-data)

Each new issue type from the detector scope needs a `fix` fragment (`src/playbook.ps1:22`), written to teach the
*noticing*, mirrored into PROCEDURE.md's prose playbook:

| type | `structural` | `fix` (draft) |
|---|---|---|
| `glyph_name_leak` | `$false` | "Literal `glyph[name]` font-name leaked as text: substitute via the map (`negationslash→\neq`, `lscript→\ell`, …) at each span. Deterministic — no judgment." |
| `dangling_operator` | `$false` | "Equation ends on an operator with no right-hand side — the converter truncated the tail. If the continuation is the next chunk, `merge_chunks`; else restore from source (N4) or `request_review`. Never invent the missing side." |
| `prose_seam_merge` | `$false` | "A sentence fragment (often inside `\text{}`) was merged into the equation from the adjacent line. Glance at the seam (`context=1`); the prose belongs to the neighbour — `propose_edit` the tail to empty." |
| `bare_number_row` | `$false` | "A lone integer on its own aligned row (`\\ & \quad 4`) is a page/footnote number that leaked into the math: delete the row." |
| `degenerate_structure` | `$false` | "A `\substack`/`\max`/`\min` with no math body — the real equation was destroyed by the converter. This is not repairable in place: restore from source (N4) or `mark_unrecoverable`." |

### Nudge sequencing

N1 + N2 are **prose-only** edits to PROCEDURE.md and the tool description — zero code, immediate, ship with
Tier 1. N6 lands with each detector. N3 is the one code change and should follow the soft-detector
implementation (it consumes their output). N4 + N5 are prose carve-outs, ship anytime.

---

## Open questions

- Should `glyph_name_leak` repair be auto-applied (deterministic map) or routed through `propose_edit` for an
  audit trail? (Leaning auto, logged.)
- `dangling_operator` token set — start narrow (relational only) and widen, or full infix set from day one?
- Is the assembled seam pass (T2a) better folded into the existing `Find-MathClosureIssues`, or a new
  sibling scanner? (Affects where cross-chunk neighbour access is wired.)
- **N3:** does `tells` belong in `review_document` only, or also as a low-priority band in `dispatch` so a swarm
  can *optionally* work them (vs. reserving them for the single armed reader)? Trade-off: swarm throughput vs.
  spending the holistic reader's judgement where it's scarcest.
- **N5:** is a `context=1` seam glance enough, or does `prose_seam_merge` need the membrane to *quote* the
  neighbour's overlapping text in the work-order so the worker needn't slice at all?
