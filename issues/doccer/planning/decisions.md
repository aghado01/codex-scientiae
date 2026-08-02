# Doccer decision canon

Living document — states what is decided **now**, corrected in place as decisions evolve (the
judgment rule: amendments preserve decisions; this file need not preserve every sentence). The
full arguments live in the minting run's brief
([fable-doccer-dev-brief-20260801_222912](../briefs/fable-doccer-dev-brief-20260801_222912.md))
and the evidence in [../discussions/](../discussions/). The MarkPig legwork is historical
evidence — cited, never amended. `src/doccer/README.md` is the in-repo contract surface and must
agree with this file.

## Doctrine

- **Claims carry evidence. Queries execute named policies and return results. Orchestration
  selects policies and interprets results.** The representation never pre-resolves; the engine
  hosts resolution mechanisms as explicit, deterministic, parameterized operations and never
  selects among them. Some policy flows *into* queries (scoped matching and laminar admission
  change what is computed); the rest operates on results in orchestration.
- **Contracts gate; consumers witness (D14).** Contract closure is the only gate on engine work.
  A contract closable from first principles is closed by design — anticipate the consumer.
  "First consumer" triggers are prioritization defaults, never permission. Implementing against
  an open contract is the one forbidden move (D10).
- **Engine boundary — the admission test (D10):** deterministic; eliminates repeated mechanical
  work; preserves literal source material; decides nothing about meaning. Failing the last test
  puts a feature in an adapter or the consumer.

## Decisions

| # | decision | status |
|---|---|---|
| D1 | Fingerprint hashes raw UTF-16 code units — identity distinguishes everything the topology distinguishes (incl. which lone surrogate) | implemented |
| D2 | Laminar equal-geometry groups admitted by max priority as the *documented default*; a future `ResolutionPolicy` is a query parameter, not a data-model change; determinism, not optimality, is the contract | implemented (default) |
| D3 | Suppression is a query policy, never a claim property (`is_mask` dead); `Suppression.Admitted`/`Excluded` compositions; the legwork bitmap = acceleration of that query | implemented |
| D4 | Atom tiling carries **facts only** (span, scalar, category, validity, line); coarser typing and run emission are derived views under an explicit break-key; a run carries the key it broke on, nothing else; UCD version = recorded metadata; the 64 KB LUT = implementation strategy, out of contract | implemented (`EmitRuns` + `AtomFacts`; block/script pending F-UCD) |
| D5 | Pattern priority = default evidence recorded on the claim; resolution order = query policy | implemented |
| D6 | No syntactic obligations on patterns; `SpanLevel` = claim metadata only; execution scope (`WholeMaster`/`PerLine`/region set) = explicit collector parameter; rule scope ∩ caller scope | implemented |
| D7 | Five lift operations named separately — project, group, run-within, rebase, materialize; all cross-grain arithmetic in master coordinates, every derived measure basis-stamped; slice→parent rebase is total+bijective and does not wait for OffsetMap | project + run-within implemented; rest = Tranche 3 |
| D8 | Never a generic `Density` verb — individually named measures declaring numerator, denominator, window basis, boundary policy, exclusions; gap-cadence first (mdnav template) | pending (Tranche 3) |
| D9 | Contract minutiae: `Project` empty-span convention documented; load-time rule validation (empty-match probe names the rule); `Join` carries a no-performance-contract note | implemented |
| D10 | Engine additions gated by the admission test (see Doctrine) | standing |
| D11 | The engine never normalizes Unicode: identity default; normalization = explicit producer `original → (map, normalizedMaster)`; NFKC/NFKD documented lossy; ASCII transliteration stays out of the substrate; grapheme clusters = derived view over scalar atoms if ever wanted | standing (code conforms) |
| D12 | Library of primitives, never a pipeline: every ladder rung usable without rungs above; construction cost scales with what is touched (lazy fingerprint/topology); **masters scale down** — a `TextMaster` is a coordinate space, not "the document", fragment-local masters first-class; identity floor governs *mixing not extent*; lineage (slice map/rebase) opt-in; evidence/cross-examination attaches to compositions that ask | implemented (lazy substrate landed) |
| D13 | À la carte tools surface doccer-native: DLL = operation grain, CLI = task grain with domain knowledge as **data** (inventories/scope files, never flags); PS layer = site-local veneer + adapters only; boundary test = "lost on graduation ⇒ wrong layer"; minimal JSONL wire format precedes and feeds F2. Engineering precedent: ThermoMapper `user-repl` (no hot path; hand-rolled router; wire format declared once in a source-generated JSON context with CLI-owned records; presets/manifests as data; rehydrate-not-recompute) | standing; CLI verbs not yet built |
| D14 | Gating doctrine (see Doctrine) | standing |
| D15 | `PerLine` matches the line's **content extent** — terminator excluded (CRLF/LF claim-text determinism; `.` matches `\r`); terminator codepoints remain first-class atoms (exclusion is scope, not erasure); per-line terminator-kind view = named future derived fact | implemented |

## Deferred families (F) — trigger = prioritization default, per D14

| # | family | state | default trigger |
|---|---|---|---|
| F1 | `OffsetMap` | contract shape **drafted**: point results `Exact \| Range \| Unmapped`; ICU-Edits-style segment list (`Identity/Expand/Contract/Delete/Insert`); span projection under a named policy (`Clip/Expand/Drop/Residual/Refuse`, **Residual** default posture); exactness laws on preserved coordinates; maps compose; acceptance edge-cases in [grok-offsetmap-unicode](../discussions/grok-offsetmap-unicode.md) | first edit-plan or normalization job |
| F2 | Persisted batch format | interning tables landed as groundwork; mdnav sidecar = identity/staleness design donor; subsumes the CLI wire format, not duplicates it | first cross-process consumer |
| F3 | Byte addressing | encoding map (bytes↔code units) is a distinct object from the Unicode-form map; reconcile with OffsetMap, never bolt onto `TextMaster` | byte-exact reproduction/provenance need; a successor-design decision |
| F4 | Indexed joins / lookup acceleration | semantics are the contract; pure acceleration | Tier-2 tests freeze semantics |
| F5 | Tier-2/3 acceptance, agreement scoring | needs an honest pair of independent producers (ATX vs setext natural) | markdown inventory exists |
| F6 | Markdown adapter + mdnav succession | oracle harness vs mdnav on doc-dive fixtures; exceed at the collapse points (quote-nested fences, setext/ATX disagreement, multi-line HTML, H1×breaks join); conserve instrument virtues; doc-dive skill retargets unchanged | Phase-2 exit + markdown inventory |
| F-UCD | Unicode block/script facts | decision-gated: needs a UCD data-provenance record (pinned version, tables as versioned data, lazily computed); then lands as ordinary `AtomFacts` selectors | schedulable any time (D14) |

## Question ledger

| # | question | resolution |
|---|---|---|
| Q1 | equal-geometry priority | D2 |
| Q2 | atom taxonomy / run-key incoherence | D4 |
| Q3 | `is_mask` intrinsic vs query | D3 |
| Q4 | global vs query priority | D5 |
| Q5 | loader syntactic rules | D6 |
| Q6 | "lift" conflation | D7 |
| Q7 | density ambiguity | D8 |
| Q8 | 64 KB LUT status | D4 |
| Q9 | coverage invariant strength | cursor-based check (pre-existing) |
| Q10 | fingerprint vs lone surrogates | D1 |
| Q11 | OffsetMap honest form | F1 (shape drafted) |
| Q12 | persisted batch format | F2 |
| Q13 | byte addressing | F3 |
| Q14 | indexed join strategy | F4 |
| Q15 | agreement-score vocabulary | F5 |
| Q16 | what supplants mdnav, when | F6 |
| Q17 | normalization silent vs explicit | D11 |
| Q18 | monolith risk / entry granularity | D12 |
| Q19 | where à la carte tools surface | D13 |
| Q20 | does engine work wait for consumers | D14 |
| Q21 | when codex-scientiae adapters land | roadmap — CLI + primitives first, adapters last |
| Q22 | PerLine terminator in or out | D15 |

## Open (no decision record yet)

- **T2-2 — inventory regex options:** applied literally today; proposed resolution = union with
  `CultureInvariant` always (culture-sensitivity never silently opted into). **Pending user
  confirmation.**
- **T2-1 — columnar surface visibility:** interned columns public; numeric columns internal.
  Pure design decision, closable any time.
- **T2-4 — fact selectors as typed delegates, not an enum:** shape choice made; promote to a
  record only if it should bind future selectors.
- **T2-5 — `PatternRule` positional order** (`scope` before `priority`): compat note if consumed
  before graduation.
- **Register/value/metadata columns:** contracts open; entangled with the math-register design —
  sequence deliberately, don't close from the doccer side alone.
- **"Register" in sol's Tier-1 list:** meaning itself unresolved.
- **Per-line terminator-kind view** (D15): named, unscheduled.
