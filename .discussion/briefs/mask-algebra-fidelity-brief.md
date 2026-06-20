# Brief — mask-algebra fidelity (precision by construction)

Implementer's brief for hardening the detection layer. Companion to
[`membrane-upgrade-plan.md`](membrane-upgrade-plan.md) (it becomes the substrate under Tracks 3–4) and
[`doccer-membrane-integration.md`](doccer-membrane-integration.md) (it lifts doccer's *calculus*, not its
engine). Cold-handoff-ready.

**Two kinds of discipline, on purpose.** The algebra disciplines the detectors (precision by construction,
not by supervision). A bounded set of construction constraints disciplines the algebra (so the
discipline-layer never grows into the engine we explicitly refuse to build). The second is the section that
keeps this honest — read *Implementation discipline* and *Non-goals* as load-bearing, not boilerplate.

## Why — precision by complement, not by supervision

The corruption detectors are the admitted 80/20 layer (the integration note: "we did the predicate
consolidation — the 80/20"). The fix is **not** a labeled should-match corpus babysitting brittle patterns —
that measures precision, it doesn't create it, and supervision is alien to a codebase whose whole thesis is
*discipline by construction* (a worker slice physically can't return a body; it isn't told not to). The
detectors should earn precision the same way.

The construction is **precision-by-complement**: don't write the precise pattern — write a *coarse overlay*
(high recall, easy to keep stable) and **subtract** to isolate the target. Exactness lives in the set
operation, not the regex. Worked proof, on the bug already reproduced (`Test-IsMath` calling a legit
multi-environment formula "prose"):

- Old: strip `\commands`, count 4+-letter words ≤ 2. Environment names (`aligned`, `cases`, `array`) leak →
  false `prose_in_formula`. Patching the strip-list is whack-a-mole (miss `\texttt` next week).
- Mask-algebra: `math_structure` is the **overlay** (`$…$`, `\cmd{…}`, `\begin{…}…\end{…}`, sub/superscript
  groups, delimiter runs); prose-in-formula is *natural-language density in the **complement** of that
  overlay*. Environment names live **inside** the overlay, so they're masked out, never counted — **the false
  positive is gone by construction**, not because anyone remembered to strip them.

`math_dirt` already *is* one instance of this — `density ∧ ¬($…$ mask)` is overlay-and-complement. The work
is generalizing that one hand-built instance into a named, closed calculus the other detectors compose from.

## Layer 0 — the closed primitive set (this is the whole algebra)

A `Mask` is a **normalized span set**: a sorted, disjoint, half-open `[start,end)` list of offsets over a
string. One representation, one enforced invariant. The closed operation set — and nothing beyond it:

| op | signature | note |
|---|---|---|
| `New-Mask text pattern` | (string, regex) → Mask | overlay: coarse match → spans |
| `Complement mask len` | (Mask, int) → Mask | everything not covered |
| `Sub a b` / `Intersect` / `Union` | (Mask, Mask) → Mask | set algebra; output re-normalized |
| `Density mask|register window` | → number/spans | rolling count (the doccer density) |
| `At-Level text level` | (string, SpanLevel) → unit list | the level lens (below) |

**Purity.** Every op is a pure function `(string|Mask) → Mask|number` — no I/O, no state, no side effects.
This is what makes them composable and reason-about-able; it is also the discipline that keeps the algebra
small (a stateful "mask manager" is the first step toward the engine — forbidden).

**Algebraic laws are the algebra's own validation** (intrinsic, total — *not* a labeled corpus): `Complement
∘ Complement = id`, `Sub A A = ∅`, `Union A (Complement A) = full`, `Intersect A (Complement A) = ∅`, De
Morgan, `normalize` idempotent. These hold by the math, over any input — check *these*, not sampled strings.

## The new primitive — `SpanLevel`, made explicit

doccer's load-bearing observation (gemini-doccer #3): the membrane's ops are *level-mixed without declaring
it*. Discipline rule: **every detector declares the level it runs at**, and the level is a parameter, never
an implicit assumption. Mixing levels is a bug.

- **Character** — UTF-16 offsets into the string (delimiter balance).
- **Line** — newline split within a chunk (fence/alignment pairing, token-shatter density).
- **MultiLine** — a chunk or an id-range (formula/block extent).

It is an *interpretation layer over the strings already held*, not a new data structure.

## The detectors, rebuilt (overlay → complement → level)

Each names its overlay(s), the complement, the level, and the failure it dissolves:

- **prose_in_formula** (MultiLine): `Density(prose_words, Complement(math_structure_overlay))`. Env-name leak
  gone by construction (worked above).
- **unwrapped_math** (Character): `Density(MathLatexRx, Sub(Sub(content, $…$_mask), prose_context_mask))` —
  the existing `math_dirt`, refined by also subtracting a prose-context overlay (hyphenated `α-helix`, unit
  glyphs, isolated symbols). Kills the prose-symbol false positive.
- **gibberish** (Line): single-char-token density over a window — tunable, catches short shatters the old
  `{6,}` count missed, and (alphabetic-only) stops false-firing on spaced number runs.
- **alignment_outside_env** (Line/MultiLine): `(?<!\\)&` ∈ `Complement(environment_overlay)`, evaluated
  **level-local** — a bare `&` in a region no environment span covers is flagged even when another env exists
  elsewhere in the chunk, fixing the old whole-chunk recall hole.

## The pincer — intrinsic validation, bounded

The validation worth trusting is structural, not bolted on: two **independent** derivations that must coincide.

- **top-down** — MultiLine extent → Lines → Character balance (drill in to isolate).
- **bottom-up** — Character atoms → reconstruct Line spans → reconstruct the MultiLine extent.

Impossibility queries are predicates over this overlay geometry ("these masks may not overlap," "this
complement must be empty"); **the pincer is the strongest one — top-down and bottom-up must coincide, and a
disagreement *is* the impossibility firing.** Not new machinery: Track 2's hotspot detector already runs a
baby pincer (per-chunk balance vs joined balance; disagreement = fragmentation). Generalized, Tracks 3–4 stop
being separate — they are two readouts of one pincer: **agreement ranks, contradiction gates.**

Discipline: the pincer is **exactly two passes and a coincidence test** — not an N-way weighted ensemble, not
a tunable soup. Where a tolerance is genuinely needed it is named and defaulted, not pervasive.

## Implementation discipline (the discipline of the discipline)

The guardrails that keep the algebra from becoming the engine:

1. **One module home.** A single new `masks.ps1` (the closed primitive set + `SpanLevel`); `latex.ps1` /
   `fidelity.ps1` / `normalize.ps1` *consume* it. Logic does not scatter — `masks.ps1` is to spans what
   `latex.ps1` is to math predicates.
2. **One representation, enforced.** Normalized span set (sorted, disjoint, half-open). Every op returns
   normal form; construction merges overlaps. No ad-hoc span shapes anywhere else.
3. **Totality.** Ops are defined on empty / full / boundary masks and never throw on valid input;
   zero-length spans normalize away.
4. **Codepoint safety carries in** (the standing invariant — see [[membrane-codepoint-safety]]). Offsets are
   UTF-16 code units, consistent with `Get-LatexBalance`; **operations never split a surrogate pair at a
   boundary** (SMP math 𝔼/𝕊 is two code units — a span edge lands between codepoints, never inside one). All
   content stays on the explicit UTF-8-no-BOM I/O backbone; masks do no I/O.
5. **Boundedness honors the no-engine line.** Inputs are KB chunks / small id-ranges → O(n) passes, a mask is
   a handful of spans. Forbid quadratic span growth. This stays *lightweight interval ops*, not a sweep.
6. **Incremental, behavior-preserving-or-better migration.** Port **one** detector first — `prose_in_formula`,
   the reproduced bug — slotted behind the already-consolidated `latex.ps1` predicates so call sites don't
   churn. Prove it on the known cases, then port the next. No big-bang rewrite.
7. **Validation is intrinsic + differential, never supervisory.** (a) the algebraic laws above; (b) the
   reproduced cases as *worked proofs* (we already demonstrated `Test-IsMath` by reproduction, not by a
   corpus); (c) an A/B **diff of the work-list** against the current detectors over the 22-doc corpus —
   match-or-reduce false flags, never increase misses. None of these is a labeled should-match set.

## Compatibility — don't break the membrane's delicate mechanics

The algebra is pure and fenced, so the *substrate* disturbs nothing on its own; all risk is at the **seam**
where a rebuilt detector plugs into its existing consumers. The membrane's mechanics depend on the detectors'
*contracts at consumption*, not their internals — keep these fixed-or-better and nothing downstream falls
apart. A ported detector MUST preserve:

1. **The merge-gate decision.** `Get-CorruptionType` gates `propose_repair` (reject), `apply`
   (only-clean-merges), `propose_edit` (report). The A/B diff must compare the **accept/reject decision per
   chunk**, not just the flag count — a repair accepted today must not start rejecting. And the detector must
   agree with `apply`'s content normalization (`Repair-MathAlignment`/`Convert-MathToLatex`/
   `Optimize-MathContent`): a blessed repair must survive normalization **still blessed** — verify the
   `detector ∘ normalize` fixed point, or `apply` oscillates (stage clean → normalize → re-flags).
2. **Cross-derivation consistency (the drift the consolidation closed).** The detector is read in three places
   — chunk grading (`fidelity.ps1`), the gate (`serving.ps1`), the assembled scanner (`md-cleanup.ps1`
   `Find-MathClosureIssues`) — via the shared `latex.ps1` predicates. Port **all three atomically**; a partial
   port reopens the "lying scanner." The algebra **replaces** the predicate's shared-home role, it is not a
   second home beside it.
3. **Frozen shared-signal contracts.** `math_dirt` and `Get-LatexBalance` outputs feed the freshly-landed
   hotspots/dispatch code (the `math_dirt ≥ 2` density gate; balance for joins). Re-implementing
   `unwrapped_math` must preserve `math_dirt`'s output, or update those consumers in lockstep and re-verify
   hotspots. Treat these as fixed output contracts.

(1)–(3) are the membrane-specific contracts the port must explicitly verify; the purity / totality /
boundedness / codepoint-safe-offset constraints above cover the rest by construction — restated as the
mechanics they guard: no persisted masks (ids renumber under split/merge), total on partial/mid-repair
content, O(n) at the hot gate.

## Non-goals (the fence — what we are NOT building)

Explicit, with teeth — if an op seems to need any of these, it is **out of scope; escalate, don't build it**:

- No SoA columns, no `DocPlane`, no RLE/bit-plane masks over GB.
- No 64 KB classification LUT, no hex-native addressing, no BPE export.
- No general declarative rule-table runner / recursive language re-sweep.
- No persisted mask sidecars (masks are computed lazily, in memory, like the hotspot overlay).

The calculus on the strings already held, full stop. doccer remains the substrate to *mine*, not to *import*.

## Files touched

| File | Change |
|---|---|
| `src/masks.ps1` (new) | the closed primitive set + `SpanLevel`; pure, no I/O |
| `src/latex.ps1` | `Test-IsMath` / `Test-AlignmentOutsideEnv` re-expressed via masks (first port) |
| `src/fidelity.ps1` | `Get-CorruptionType` predicates consume masks; gibberish → token-density |
| `src/normalize.ps1` | `math_dirt` re-expressed as an explicit `Sub`/`Complement` (it already is one, unnamed) |

No membrane tool-surface change — this is preprocess/fidelity internals; `mcp-server.ps1` is untouched.

## Sequencing

This is the **substrate beneath Tracks 3–4**: agreement-score is the pincer's agreement readout, the
impossibility gate is its contradiction readout — both inherit the algebra's precision. Do it *before or
with* Track 3 (a cross-derivation score is only as good as the derivations). Orthogonal to Track 2, whose
join-balance test is the first pincer instance and can later re-express on these primitives.
