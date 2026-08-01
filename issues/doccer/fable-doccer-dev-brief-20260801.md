# Doccer development brief — resolutions and sequencing

**2026-08-01 · Fable.** Synthesizes [sol-doccer-next-steps.md](sol-doccer-next-steps.md) (gap
taxonomy), [grok-doccer-review-20260802.md](grok-doccer-review-20260802.md) (open-question
analysis), a full code review of `src/doccer` (contract harness passing, 954 checks), and a
conceptual comparison against mdnav (`D:\aghado01\utils\skills-dev\doc-dive\mdnav`). Decisions
marked **D#** are adoptable now with a stated principle; items marked **F#** are deferred with a
named maturation trigger. Nothing here reopens the engine-before-car posture; it sequences it.

**Canon and locality (rev 2, 2026-08-01):** the MarkPig legwork documents
(`D:\aghado01\MarkBrain\MarkPig\doccer\legwork\`) are **historical evidence** — consulted and
cited, never amended. New design decisions are recorded here in `issues/doccer/`; this brief and
its successors are the canon. Rev 2 also restates the governing doctrine (§2) after the original
phrasing proved ambiguous, and incorporates D11 and the F1 contract shape from
[grok-offsetmap-unicode.md](grok-offsetmap-unicode.md).

---

## 1. Framing: what mdnav is to doccer

mdnav is a second independent partial rediscovery of doccer (after masks.ps1) — immutable
sources, half-open spans in one address space, digest-guarded anchors, a ledger stamped with the
grain that produced it, explicit residuals (`PREAMBLE`, `BODY`, `UNBROKEN`). Two tools
re-deriving overlapping fragments of the same substrate is empirical support for the abstraction.
But the relation is **succession, not integration** — no cross-talk, no span exchange, no bridge.

mdnav is three strata in one file, and only one of them is doccer's business:

| stratum | what it is | fate |
|---|---|---|
| structural pseudo-parsing | `analyze`, `constructRuns`, `noiseSpans` — line-regex scanning with baked-in conflict resolution | **supplanted** by a doccer markdown adapter, eventually |
| reading instrument | partition bases, depth/extent, anchors, coverage ledger, elision-with-placeholders, grain signatures | **spec witness** for a future doccer-based car; the verbs become queries over claims |
| skill semantics | admission test, proposal lifecycle, attrition sweep, reverse walk (in README/notes prose, never in code) | **stays above the engine permanently** — reasoning-agent discipline, out of scope by the same boundary that keeps meaning out of the engine |

The bottom stratum is where mdnav commits the representation collapse doccer exists to fix: one
kind per run, first match wins, fence state global. A fenced block inside a blockquote is
silently "blockquote"; setext headings can be *suspected* but never *disagree* with ATX claims;
multi-line HTML is reported rather than represented; the H1-vs-breaks `aligned` verdict is a
scalar shadow of an Allen join. Each collapse point is a claim-pair doccer expresses natively —
that list is the succession's value proposition, and §F6 makes it the acceptance criterion.

What transfers **conceptually** from mdnav, independent of any code path:

- **Measurement, not classification** — mdnav reports composition and cadence and refuses to
  label; the same posture one level down resolves the atom-taxonomy dispute (D4).
- **Invariant-coordinate arithmetic** — unit counts are not comparable across a grain change, so
  all coverage arithmetic happens in bytes and every measure is stamped with its basis. This is
  the level-projection contract doccer hasn't written yet (D7).
- **Named measures with declared parts** — cadence = (gaps between construct starts; median, cv,
  span fraction; paragraphs excluded, with a reason). The template for density (D8).
- **Identity/staleness discipline** — schema version, content hash as authority with an mtime
  fast path, explicit stale-anchor warnings, derived anchors preserved across refresh keyed on
  hash. Field-tested prior art for the persisted-batch format (F2).
- **Advice, never gates** — delimiter candidates and noise warnings go to stderr as observations;
  the reader decides. Maps onto validation severity tiers rather than hard failures.

## 2. Governing doctrine

Nearly every open question falls to one principle, already implicit in the code. Restated in
rev 2: the original "claims carry evidence; queries carry policy" read as if policy *lives* in
the query layer, which would smuggle domain judgment into the engine. Corrected:

> **Claims carry evidence. Queries execute named policies and return results. Orchestration
> selects policies and interprets results.** The representation never pre-resolves. The engine
> implements every resolution mechanism — suppression scoping, admission ordering,
> intra-geometry resolution, coarser typing — as an explicit, deterministic, parameterized
> operation, and executes whichever policy the caller names; it never selects one. All judgment
> — which query, which policy, what the result means, what happens next — belongs to
> orchestration (rule tables, consumers, the reasoning agent).

One distinction keeps this from collapsing into "policy = post-hoc filtering of results": policy
has two moments, and orchestration owns the *choice* at both. Some policies must flow **into** a
query as arguments, because they change what is computed rather than how results are filtered —
scoped collection alters match semantics (a match that would bridge an excluded gap never exists
in any result set to be filtered afterward), and laminar admission is order-dependent over the
whole claim set (no filter over a full join reproduces it). If the engine did not host those
mechanisms, every consumer would reimplement geometry to express its policy — the Frankenstein
failure again. Other policy operates **on** results, in orchestration, where it always did.
Documented defaults (e.g. max-priority admission, D2) are conventions in the query contract for
callers that don't care; relying on one is still the caller's act.

masks.ps1 failed by resolving at representation time (normalization = policy fused into data).
mdnav succeeded at instrument scale by measuring and deferring judgment to the reader. The
current `SpanBatch`/`SpanSet`/`Laminarizer` split already conforms; this brief elevates it from
habit to contract. D2, D3, D4, D5, and D11 below are instances, not separate rulings.

## 3. Resolved now — decision records

### D1 — Fingerprint identity (defect, fix first)
`TextMaster.Fingerprint` hashes via `Encoding.Unicode`, whose replacement fallback maps every
lone surrogate to U+FFFD (verified: `0xD800` and `0xDC00` both encode to `FD FF`). Two masters
differing only in which unpaired surrogate they contain — a distinction `TextTopology` preserves
as first-class atoms — fingerprint identically and pass `IsCompatibleWith`.
**Decision:** hash raw UTF-16 code units (`MemoryMarshal.AsBytes(text.AsSpan())`); if
fingerprints ever persist cross-platform, fix endianness explicitly. Add a harness check that
lone-high vs lone-low surrogate masters differ.
**Principle:** identity must distinguish everything the topology distinguishes.

### D2 — Laminar equal-geometry resolution
**Decision:** max-priority *admission* of geometry groups stays as the documented default;
equal-extent claims ride as groups (already true); a future `ResolutionPolicy` is an explicit
query parameter operating *within* an accepted geometry — no data-model change. Document that
greedy admission guarantees determinism, not any global optimum; determinism is the contract.
**Source:** grok Q1; code conforms.

### D3 — Suppression
**Decision:** no claim ever carries `is_mask`. Suppression = a derived `SpanSet` plus a named
query policy. The legwork's "suppression bitmap" is an *acceleration* of that query, never a
claim property; idempotence laws attach to the query. A code-block claim suppresses heading
recognition in one query and is the primary target of a language collector in another.
**Source:** sol §3, grok Q3; `RegexCollector` scope already embodies it.

### D4 — Atom taxonomy, runs, and the LUT
**Decision:** the tiling carries **facts only** — span, scalar value, Unicode category,
validity, line. No intrinsic four-way word/punct/ws/newline type. Any coarser typing and all run
emission are **derived views parameterized by an explicit break-key**; a run carries the key
values it broke on and nothing else. This dissolves the Lu→Ll contradiction (category is a
per-atom fact; a run keyed on atom-class carries no single category). The UCD version becomes
recorded metadata on the topology; block/script tables, if added, ship as data with their own
version stamp. The 64 KB LUT is an implementation strategy for computing facts, out of the
contract entirely.
**Source:** sol §3, grok Q2; mdnav precedent (measurement, not classification).

### D5 — Priority
**Decision:** inventory pattern priority is *default evidence recorded on the claim*; resolution
order is query policy. Same shape as D2/D3 — an instance of the doctrine.
**Source:** sol §3, grok.

### D6 — Collector execution scope
**Decision:** drop the syntactic loader rules (a line-level pattern need not contain `^...$`).
`SpanLevel` is claim metadata only. Execution scope — whole-master, per-line, per-region — is an
explicit collector parameter. "Run a recognizer independently within each line" is thereby
assigned to collectors, removing one of the five conflated "lift" meanings.
**Consequence:** the JSONL inventory loader spec must be revised before implementation
(sequenced in Tranche 2 after this record).
**Source:** sol §3.

### D7 — Lift vocabulary and the cross-grain invariant
**Decision:** five named operations, never one verb:
1. **Project** — character span → intersected line range (exists: `TextTopology.Project`);
2. **Group** — finer claims → one derived coarser claim (algebra; output stamped with basis);
3. **RunWithin** — collector execution mode (D6);
4. **Rebase** — slice-local coordinates → parent master. The slice→parent map is total and
   bijective, so **`TextSlice` can be implemented honestly before any general OffsetMap**;
5. **Materialize** — create a child master from a slice (new identity, new revision line).

Standing invariant (from mdnav): all cross-grain arithmetic is stated in master coordinates, and
every derived claim or measure is stamped with the basis that produced it.
**Source:** sol §2, grok Q5; mdnav byte-invariant coverage.

### D8 — Density
**Decision:** there will never be a generic `Density` verb. Ship individually named measures,
each declaring numerator, denominator, window basis, boundary policy, and exclusions. First
named measure: **gap-cadence** (median gap, cv, span fraction over claim starts), which has a
worked example and validated behavior in mdnav. Others (coverage-per-window, claims-per-window,
register recognitions within admitted regions) follow as consumers demand them.
**Source:** sol §2, grok Q6; mdnav cadence as template.

### D9 — Contract minutiae from the code review
- Document `TextTopology.Project`'s empty-span convention (returns the one-line range containing
  the position) as a decision, not an accident.
- `RegexCollector` validates rules at load time (probe each pattern for empty-match capability)
  so a rule like `foo|` fails naming the rule before the sweep, instead of throwing mid-batch.
- The reference `Join` carries an explicit no-performance-contract note in its public surface.

### D10 — Engine boundary as a generative test
**Decision:** adopt the admission-test form (from the doc-dive notes) as the gate for engine
additions, replacing enumerated non-goals: *is it deterministic; does it eliminate repeated
mechanical work; does it preserve literal source material; does it avoid deciding what the
material means?* A feature failing the last belongs in an adapter or the consumer. An
enumeration lists instances; this is the rule that generates them.

### D11 — Unicode normalization posture
**Decision:** the engine never normalizes. `TextMaster` and the topology builder accept text
exactly as given (current behavior); the default form is identity. Normalization —
NFC/NFD/NFKC/NFKD — is an explicit producer step, `original → (map, normalizedMaster)`, chosen
by orchestration; compatibility forms are documented as **lossy transforms** whose loss the map
records rather than hides (ﬁ→fi, fullwidth→halfwidth, U+212B→U+00C5 are not recoverable). The
old Markdig ASCII transliterator is a higher-level anchors/search tool and stays out of the
substrate entirely. A grapheme-cluster tiling, if ever wanted, is a derived view over the scalar
atoms (per D4), never a replacement — claims may legally begin between a base and its combining
mark, and the map must be able to say so.
**Principle:** the master you analyze is exactly the text you intended to analyze; any change of
form is explicit, mappable, and optional.
**Source:** [grok-offsetmap-unicode.md](grok-offsetmap-unicode.md); legwork UNIFIED-SWEEP/SCHEMA
concur (historical evidence); code conforms.

## 4. Deferred — with named triggers

### F1 — OffsetMap (general form) — contract shape drafted
[grok-offsetmap-unicode.md](grok-offsetmap-unicode.md) upgrades the requirements sketch to a
candidate contract. Point queries return a sum type — `Exact(offset) | Range(start,end) |
Unmapped` — because a bare `int` forces an invented bias and silently discards non-uniqueness.
Storage is an ICU-Edits-style segment list (`Identity | Expand | Contract | Delete | Insert`,
identity runs coalesced). Span projection always names a policy (`Clip | Expand | Drop |
Residual | Refuse`), with **Residual** the claims-compatible default posture: mapped pieces plus
an explicit residual claim, never a pretended-total projection. Exactness laws hold only on
preserved coordinates; maps must compose (normalize ∘ edit-plan) without changing reported
statuses; same-master rebase stays a separate total bijective operation (D7.4 unaffected). The
edge-case table in that document (é NFC/NFD interiors, Hangul jamo, ﬁ ligature, partial-unit
residuals) becomes acceptance tests the moment an implementation appears. Unicode normalization
(D11) joins edit plans as a primary motivating consumer. Do **not** implement a naïve map first.
**Trigger unchanged:** the first real consumer — the masks.ps1 rebirth / LaTeX macro-expansion
migration, or an explicit normalization request — forces implementation; the shape above is what
it implements against.

### F2 — Persisted batch format
Freezes master identity, UCD version, interned tables, metadata typing, schema evolution — after
the in-memory schema settles.
**Trigger:** first cross-process consumer (a CLI pipeline stage, or PS-session boundary).
**Design donor:** the mdnav sidecar (§1) for identity/staleness/derived-anchor policy.

### F3 — Byte addressing
`Encoding SourceEncoding` beside a decoded string cannot give exact byte pointers; needs original
bytes or a decode map, reconciled with OffsetMap rather than bolted onto `TextMaster`.
**Trigger:** a consumer requiring byte-exact source reproduction or byte provenance. Note for the
succession (F6): mdnav guarantees "read = literal source bytes"; whether the successor inherits
that guarantee or redefines read as re-encoded decoded text (recording BOM/encoding anomalies at
index time) is itself the question that activates this item — it is a successor-design decision,
not an engine prerequisite. Note per grok-offsetmap-unicode: the encoding map (bytes ↔ code
units) and the Unicode-form map (F1/D11) are distinct objects with different failure modes; keep
their contracts separate.

### F4 — Indexed joins and priority-aware lookup
Pure acceleration; semantics are the contract.
**Trigger:** Tier-2 tests freeze join/lookup semantics; then replace the O(n·m) reference freely.

### F5 — Tier-2/3 completion and agreement scoring
Direct-vs-derived matching, tolerances, agreement scores, suppression exceptions.
**Trigger:** the first honest pair of independent claim producers for the same structure — e.g.
ATX + setext heading collectors, or engine-vs-Markdig. The markdown adapter (F6) creates it.

### F6 — mdnav succession (the markdown car)
**Trigger:** Phase-2 exit plus a markdown region inventory.
**Shape:** collector inventory reproduces mdnav's index (fence-scoped headings, breaks,
blockquote runs, noise species as claim kinds); instrument verbs become queries — outline =
laminar view filtered at depth, coverage = SpanSet arithmetic over a read ledger, marks = kind
selection, profile = named density measures.
**Acceptance:** two-population oracle harness against mdnav on the doc-dive fixture corpus
(CRLF, multibyte, fenced heading-like text, setext, headingless, chat-shape deviations) — match
where mdnav is right, and *exceed it precisely at the collapse points*: quote-nested fences,
setext/ATX disagreement as preserved claim conflict, multi-line HTML as real spans, H1×breaks as
an Allen join reporting which units cross which segments.
**Conserve the instrument virtues:** zero-ceremony CLI, stdout/stderr discipline, stamped
non-overwriting runs, artifacts-outside-corpus refusal, elision-with-placeholders, refusal to
classify. The doc-dive *skill* is untouched throughout — it simply retargets the successor's
verbs when they exist.

## 5. Sequencing

Ordering rationale: identity before algebra, decisions-as-data before code (so implementation
never freezes un-decided semantics), substrate before views, views before consumers, and every
deferred contract pulled by a real consumer rather than pushed by completeness.

**Tranche 0 — correctness (hours).** D1 fingerprint fix + regression check; D9 load-time rule
validation and contract notes.

**Tranche 1 — decision canon (days).** The decision records D2–D8, D10–D11 live **here**, in
`issues/doccer/`; the MarkPig legwork is historical evidence — cited, never amended. Remaining
Tranche-1 work: reflect the decisions into `src/doccer/README.md` (the in-repo contract
surface), and keep the ledger current as new questions resolve. Cheapest tranche, highest
leverage: it unblocks every implementation tranche and closes the tensions sol §3 identified
(atom taxonomy, run key, suppression, priority, loader rules, LUT framing).

**Tranche 2 — Phase-1 substrate completion (specified work, no new questions).** Full `SpanBatch`
columns with interned type/language/pass IDs; atoms enriched per D4 (facts + derived-run views);
suppression queries per D3 with idempotence laws; inventory loader per revised D6 spec; Tier-1
invariants (reconstruction, registers, line consistency, suppression, resolution).

**Tranche 3 — safe subset of the deferred families.** `TextSlice` + Rebase (D7.4–5, the bijective
special case); Group/Project per D7 with basis stamping; gap-cadence as the first named measure
(D8); priority-aware sorted lookup ordering (still reference-speed).

**Tranche 4 — first cars, validation by use.** Reborn masks.ps1 as a typed PS convenience layer
over the DLL (per sol §5: no interval algorithms in PowerShell; every set operation delegates);
re-express the old mask tests against the DLL; migrate LaTeX consumers with behavioral
equivalence as witness, never as spec authority. This tranche generates the honest OffsetMap
requirements (F1) as a byproduct.

**Tranche 5 — maturity-gated.** F1 general OffsetMap → F2 persisted batches → F4 indexed joins →
F5 Tier-2/3 with agreement scoring → F6 markdown adapter and mdnav succession.

## 6. Question ledger

| # | question | status | resolution / what answers it later |
|---|---|---|---|
| Q1 | equal-geometry priority rule | **resolved** | D2 — max-priority admission default; policy hook at query time |
| Q2 | atom taxonomy incoherence (Lu→Ll, unclassifiable categories) | **resolved** | D4 — facts-only tiling; runs = derived views with explicit break-key |
| Q3 | `is_mask` intrinsic vs query | **resolved** | D3 — always query policy; bitmap = acceleration |
| Q4 | global vs query priority | **resolved** | D5 — default evidence on claim; order is policy |
| Q5 | loader syntactic rules | **resolved** | D6 — execution scope is a collector parameter |
| Q6 | "lift" conflation | **resolved** | D7 — five named ops; cross-grain invariant |
| Q7 | density ambiguity | **resolved** | D8 — named measures only; cadence first |
| Q8 | 64 KB LUT status | **resolved** | D4 — implementation strategy, out of contract |
| Q9 | coverage invariant strength | **resolved** (already) | cursor-based check in code beats sum-of-lengths |
| Q10 | fingerprint vs lone surrogates | **resolved** (defect) | D1 — hash raw code units |
| Q11 | OffsetMap honest form | contract shape drafted | F1 — sum-type points, segment storage, Residual-default projection; first consumer implements |
| Q12 | persisted batch format | deferred | F2 — first cross-process consumer; mdnav sidecar as donor |
| Q13 | byte addressing | deferred | F3 — byte-exact reproduction consumer; a successor-design decision |
| Q14 | indexed join strategy | deferred | F4 — after Tier-2 freezes semantics |
| Q15 | agreement-score vocabulary | deferred | F5 — first independent producer pair |
| Q16 | what supplants mdnav, and when | deferred, shaped | F6 — Phase-2 exit + markdown inventory; oracle harness defined |
| Q17 | normalization: silent vs explicit | **resolved** | D11 — engine never normalizes; explicit new-master + map; identity default |

---

## Tranche 0 report

**2026-08-01 · Fable (chip).** All three items landed; harness green at 959 checks (954 prior +
5 new).

- **D1** — `TextMaster.Fingerprint` now hashes the raw UTF-16 code units via
  `SHA256.HashData(MemoryMarshal.AsBytes(text.AsSpan()))`; the `Encoding.Unicode` encode (whose
  replacement fallback collapsed every lone surrogate to U+FFFD) is gone. The host-endianness
  caveat is recorded in a comment at the hash site. New checks: lone-high vs lone-low surrogate
  masters with identical id/revision/length get distinct fingerprints and fail
  `IsCompatibleWith` (2 checks).
- **D9, load-time validation** — `RegexCollector.CollectInto` now materializes and validates
  every rule before any matching begins: the duplicate-id check plus an empty-match probe
  (`regex.Match(string.Empty).Success`) that throws `ArgumentException` naming the rule id. A
  defective rule (`foo|`) therefore fails the batch atomically instead of throwing mid-sweep
  after earlier rules already added claims. Context-dependent empty matches (e.g. bare
  lookarounds) can evade the probe; the retained mid-sweep guard in `AddMatches` remains the
  backstop for those. New checks: `foo|` rejected at load time, the exception names the rule id,
  and the builder is left with zero claims (3 checks).
- **D9, contract notes** — `TextTopology.Project` now carries an XML doc stating the empty-span
  convention (project to the one-line range containing the position, never an empty range) as
  deliberate contract with its rationale; `IntervalJoins.Join`'s XML doc states explicitly that
  the method carries no performance contract and consumers must not rely on its time or
  allocation characteristics.
