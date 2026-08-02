# Doccer development brief — resolutions and sequencing

> **Containment correction (2026-08-01):** this founding-run brief accreted the decision canon,
> ledger, and roadmap — the wrong containment. Those now live as living documents under
> [../planning/](../planning/) ([decisions.md](../planning/decisions.md),
> [roadmap.md](../planning/roadmap.md)), corrected in place as current truth. This file remains
> the **run record** of the session that minted D1–D15. Briefs henceforth are small: one per
> chip iteration — the guidance, plus that chip's report appended on completion.

**2026-08-01 · Fable.** Synthesizes [sol-doccer-next-steps.md](../discussions/sol-doccer-next-steps.md) (gap
taxonomy), [grok-doccer-review-20260802.md](../discussions/grok-doccer-review-20260802.md) (open-question
analysis), a full code review of `src/doccer` (contract harness passing, 954 checks), and a
conceptual comparison against mdnav (`D:\aghado01\utils\skills-dev\doc-dive\mdnav`). Decisions
marked **D#** are adoptable now with a stated principle; items marked **F#** are deferred with a
named maturation trigger. Nothing here reopens the engine-before-car posture; it sequences it.

**Canon and locality (rev 2, 2026-08-01):** the MarkPig legwork documents
(`D:\aghado01\MarkBrain\MarkPig\doccer\legwork\`) are **historical evidence** — consulted and
cited, never amended. New design decisions are recorded here in `issues/doccer/`; this brief and
its successors are the canon. Rev 2 also restates the governing doctrine (§2) after the original
phrasing proved ambiguous, and incorporates D11 and the F1 contract shape from
[grok-offsetmap-unicode.md](../discussions/grok-offsetmap-unicode.md). Rev 3 adds D12: the engine is a library
of composable primitives, never a pipeline that must run end-to-end for simple jobs.

**Runstamp and lineage (rev 4, 2026-08-01):** this brief is run `20260801_222912` (UTC of its
first commit), and briefs carry runstamps in their filenames from here on. Within a run the
brief **accumulates** — new decision records, ledger rows, and chip reports are appended;
existing records are not rewritten. A substantive re-decision **closes the run**: it mints a new
runstamped brief that declares `supersedes: <prior file>`, restates what changed and why, and
leaves the prior brief untouched as history. Newest stamp = current canon; each run's ledger
says where every question stood at that stamp. Same discipline as the membrane's
`.runs/{stamp}` and mdnav's stamped runs — nothing is overwritten, earlier runs survive for
comparison. (Honest note: revs 2–3 of this run rewrote §2 and Tranche 1 in place before this
rule existed; those prior states live in git at `09642901` and `f78ff2f3`. The append-only rule
binds from rev 4 onward.)

**Layout (rev 5, 2026-08-01; corrected in place same day):** each issue topic owns its briefs —
they live **flat** in `issues/<topic>/briefs/`, no per-run subdirectories, chronology carried by
the filename's runstamp suffix so a directory listing reads in order. Topic evidence and
discussion docs live in `issues/<topic>/discussions/` (this run: `issues/doccer/briefs/` and
`issues/doccer/discussions/`); briefs link to them relatively. (Trace: initially a repo-global
`issues/briefs/`; the user moved to per-topic scoping for locality.) Rev 5 also discharges the
open Tranche-1 item: the decision canon is now reflected into `src/doccer/README.md`, the
in-repo contract surface.

**Judgment note (rev 5, 2026-08-01):** append-only is for *decisions and reports*, not an
absolutism over every sentence. Where accretion would obscure current understanding — framing
prose, stale caveats — correcting in place is legitimate, because the runstamped-run mechanism
and git are the history. The test: does the old text record a decision someone may need to
trace, or a state of understanding now known false? Trace-worthy → amend with the change
declared; false → correct. (Memory files sit outside these rules entirely: memories state
current truth and are rewritten in place.)

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
**Source:** [grok-offsetmap-unicode.md](../discussions/grok-offsetmap-unicode.md); legwork UNIFIED-SWEEP/SCHEMA
concur (historical evidence); code conforms.

### D12 — À la carte primitives, not a pipeline
The engine's ambition is the full realization; its *engineering* must expose well-posed
primitives that compose into that realization and are usable individually. "Full doccer" —
sweep → collect → validate → laminarize → tiered acceptance — is one composition, never the
entry price. The dependency ladder:

```text
TextSpan / Allen relations        pure, zero dependencies
SpanSet                           + master identity
SpanBatch + scoped collectors     + typed claims
LaminarView / joins               + structure derivation
Validation tiers / inventories    + cross-examination
```

**Decision:**
1. Every rung is usable without the rungs above it — set algebra without claims, claims without
   laminar views, collection without validation tiers.
2. Construction cost scales with what is touched. `TextMaster.Create` becomes cheap: fingerprint
   and topology are computed on first use and cached; future atom enrichment (D4), inventory
   loading, and tier machinery must never move work into constructors or gate the algebra.
3. The master-identity floor is **not** negotiable down — every span-carrying object stays bound
   to its master (the masks.ps1 length-only-universe accident is the failure this prevents).
   Identity is cheap once the fingerprint is lazy and same-instance comparison short-circuits by
   reference.
4. Evidence and cross-examination (multi-collector disagreement, Tier-2/3 scoring) attach to
   compositions that ask for them, never to primitive use.
5. **Masters scale down with the job.** A `TextMaster` is a coordinate space, not "the
   document": minting one over an isolated math span or a macro-expansion site is first-class
   and (post lazy substrate) near-free, and the same primitives apply unchanged at any extent.
   The floor governs *mixing*, not *extent* — spans on a fragment-local master refuse to
   validate against the parent, so the forgotten-base-offset bug class becomes a loud
   incompatibility error instead of silent corruption. Lineage back to a parent is opt-in
   (D7.4/D7.5 slice map + rebase), needed only when results must return to parent coordinates;
   an unlinked local master is honest by construction.

**Witness:** LaTeX macro expansion — comment claims − verbatim claims = expandable region;
scoped collect; edit at spans. Rungs 1–3, nothing above; an offset map only if the job wants
coordinates carried across the rewrite. Runnable either on the parent master with scoped
collection or on a fragment-local master with identical rungs — the consumer's choice.
**Consequence (immediate):** the current `TextMaster` constructor eagerly computes SHA-256 and
the full scalar tiling — a monolith tax charged at the door for small jobs. Make both lazy.
**Source:** user directive 2026-08-01; sol-discussion layering (interval set / coordinate space /
text spans / region layers / edit plans) concurs.

### D13 — The doccer-native surface: CLI and DLL own the à la carte tools *(appended rev 5)*
**Context:** doccer is expected to graduate — into its own project, or a cross-project utility
consumed by other projects for their own reasons (the HDBSCAN payload precedent). The
C#/PowerShell boundary is therefore a **portability boundary**, not a convenience split.
**Decision:**
1. Atomic tools that can be stated domain-agnostically in doccer's own vocabulary surface on the
   **doccer-native surface**: the DLL at *operation* granularity (rich in-process composition),
   the CLI at *task* granularity — verbs that complete a small à la carte job in one invocation
   (derive a region set from claims, collect with an inventory within a scope, evaluate a small
   span-algebra expression, validate spans). The masks.ps1-descended operations are the first
   candidates.
2. The CLI stays domain-agnostic by taking domain knowledge as **data** — rule inventories and
   scope files (`doccer collect --rules latex-rules.jsonl --scope prose.json`) — never as flags
   or verbs (no `--latex`, ever).
3. The PowerShell layer is **site-local ergonomics and domain adapters only**: thin wrappers,
   inventory assembly, workflow glue. Boundary test: **if it would be lost when doccer
   graduates, it was in the wrong layer.** A capability other projects would need to reimplement
   must not live in PS.
4. This does not reopen the sol-discussion warning against CLI-per-algebra-primitive
   chattiness — that warning stands. DLL = operation grain; CLI = task grain; the D12 lazy
   substrate keeps per-invocation cost proportional to the job.
5. **Consequence:** CLI atomic tools need a minimal span/claim **wire format** (JSONL over
   stdio) — deliberately smaller than, and prior to, F2's archival batch format; F2 later
   subsumes it rather than duplicating it.
**Supersedes in part:** the Tranche-4 phrasing (rev 3) naming the reborn masks.ps1 "the
canonical à la carte surface." Current reading: the canonical à la carte surface is the
doccer-native CLI/DLL; the masks.ps1 rebirth is a thin site-local veneer over it. The Tranche-4
text stands unedited above, per the rev-4 lineage rule.
**Witness:** agents are first-class CLI consumers — mdnav demonstrates the zero-ceremony CLI
instrument form for agent workflows; doccer's atomic verbs serve the same reach-for-a-tool
pattern, and F6's instrument car later builds on this same surface rather than a parallel one.
**Source:** user directive 2026-08-01.

**D13 addendum — engineering precedent: ThermoMapper `user-repl`** *(appended rev 5)*.
Snapshot: `D:\aghado01\project-snapshots\ThermoMapper\src_20260701_122622_tree.md` (shards
s059–s065). An accessibility surface over a declarative engine backend, implementing **no hot
path** — verified in the code, and the transferable facts for doccer's CLI:
1. `SubcommandRouter` — ~40 lines of hand-rolled verb dispatch, root help, exit codes; zero
   framework dependencies. Doccer's CLI wants exactly this shape, not a command framework.
2. Per-verb command files (`GraphHealthCommand` et al.) contain only: flag parsing (explicit
   loop), input materialization, engine calls (`GraphHealth.Evaluate`,
   `SpcGraphBuilder.BuildResult` — all in engine namespaces), typed persistence, human summary
   to stdout, errors to stderr. The command's judgment is *which inputs, where to write, what to
   print* — never *how to compute*.
3. `UserReplJsonContext` — the wire format declared once: a source-generated JSON context
   enumerating every payload the CLI reads/writes, with payload shapes as **CLI-owned records**,
   not leaked engine types. This is the D13.5 wire-format consequence, field-tested; doccer's
   span/claim JSONL context takes the same form.
4. Presets (`SpcPreset`, `HdbscanPreset`) and `RunManifest` — domain knowledge and run
   provenance as data; the `extract`/`graph-health` verbs **rehydrate from a manifest** without
   recomputing, CLI flags as explicit overrides. Doccer analog: inventories + scope files in,
   claims out, with run manifests when verbs produce artifacts.
5. The session objects (`SpcUserSession`) are the in-process convenience twin over the same
   engine — the DLL-grain surface; their fluent style is incidental, the division is the point.
Naming note (user): "userrepl" is a misnomer — it is a CLI facade, not a REPL. Doccer's surface
should be named for what it is.

### D14 — Gating doctrine: contracts gate; consumers witness *(appended rev 5)*
**Context:** Tranche-2 scoping and the F-item triggers had drifted toward "wait for a consumer"
as if consumer arrival *authorizes* engine work. That misreads engines-first: the SHAPE-era spec
witnesses were **anticipated** consumers, not awaited ones.
**Decision:**
1. The only gate on implementing engine capability is **contract closure**. A contract closable
   from first principles is closed by design — anticipate the consumer, don't wait for one.
2. Consumers **validate and prioritize**; they never authorize and never scope-cut. An F-item's
   "trigger: first consumer" is a prioritization default for contracts whose remaining open
   questions are best answered by a real consumer's shapes — not a permission condition. Any
   F-item may be pulled forward the moment its contract closes honestly without one.
3. What stays absolutely gated is implementing *against an open contract* (D10: extend
   contracts first). "No consumer yet" is never by itself a reason to leave a fundamental
   architectural gap; "contract not closed" always is.
**Consequences:** register/value/metadata columns remain outside Tranche 2 because their
contracts are open — closing them is schedulable design work, not an indefinite wait. Unicode
block/script classification is **decision-gated, not consumer-gated**: a UCD data-provenance
record (pinned version, tables shipped as versioned data with their own stamp, facts computed
lazily per D12) closes the contract, after which the capability lands as coherent engine work.
**Source:** user directive 2026-08-01 — "anticipate-the-consumer"; waiting for *contracts* is
good practice, waiting for *consumers* is not the doctrine.

### D15 — PerLine excludes the terminator; terminator identity stays evidence *(appended)*
**Decision:** `ExecutionScope.PerLine` matches within each line's **content extent**
(`GetLineSpan(includeLineBreak: false)`), not the full line extent. A line break is a boundary,
not content. The decisive argument is determinism (D10): `.` matches `\r` but not `\n`, so with
the terminator inside the region a pattern like `#.*$` claims a trailing `\r` under CRLF and not
under LF — the same content under two newline conventions would yield different claim text.
grep/sed line semantics and mdnav's content slicing are precedent. A rule that needs the
terminator uses `WholeMaster` (or an explicit include option if one ever passes the admission
test).
**Terminator identity is not erased — it is substrate evidence.** Terminator codepoints are
first-class atoms; a line's terminator span is exactly its extent minus its content extent.
Excluding it from PerLine is a matching-*scope* choice, not information loss. The bookkeeping
the user gestured at — per-line awareness of *which* terminator (LF / CRLF / CR / NEL / LS / PS
/ unterminated-EOF) — is a derived line fact in the D4 mold, schedulable any time under D14 with
zero new state; mdnav's document-level `CRLF/LF/mixed` flag is the precedent, per-line is the
doccer-native refinement. Deliberately not implemented now.
**Implemented with this record:** collector region change, XML docs, and harness pins — CRLF/LF
claim-text equality, terminator unreachable under PerLine, reachable under WholeMaster (harness
1263).
**Source:** Tranche 2 flagged question 3; user confirmation 2026-08-01.

## 4. Deferred — with named triggers

### F1 — OffsetMap (general form) — contract shape drafted
[grok-offsetmap-unicode.md](../discussions/grok-offsetmap-unicode.md) upgrades the requirements sketch to a
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

**Tranche 2 — Phase-1 substrate completion (specified work, no new questions).** Lazy substrate
per D12 (fingerprint and topology on first use; reference fast-path in compatibility checks);
full `SpanBatch` columns with interned type/language/pass IDs; atoms enriched per D4 (facts +
derived-run views); suppression queries per D3 with idempotence laws; inventory loader per
revised D6 spec; Tier-1 invariants (reconstruction, registers, line consistency, suppression,
resolution). All guarded by D12: enrichment lands as lazy computation or derived views, never
constructor work.

**Tranche 3 — safe subset of the deferred families.** `TextSlice` + Rebase (D7.4–5, the bijective
special case); Group/Project per D7 with basis stamping; gap-cadence as the first named measure
(D8); priority-aware sorted lookup ordering (still reference-speed).

**Tranche 4 — first cars, validation by use.** Reborn masks.ps1 as a typed PS convenience layer
over the DLL — the canonical à la carte surface: thin cmdlets over rungs 1–3 of the D12 ladder
(per sol §5: no interval algorithms in PowerShell; every set operation delegates);
re-express the old mask tests against the DLL; migrate LaTeX consumers with behavioral
equivalence as witness, never as spec authority. This tranche generates the honest OffsetMap
requirements (F1) as a byproduct.

**Tranche 5 — maturity-gated.** F1 general OffsetMap → F2 persisted batches → F4 indexed joins →
F5 Tier-2/3 with agreement scoring → F6 markdown adapter and mdnav succession.

**Sequencing amendment (appended rev 5, 2026-08-01):** two changes to the Tranche 4/5 reading.
(1) The scriba-scientiae spin-out was **aborted**; codex-scientiae is being renovated from the
inside, at least for the time being. The converter/LaTeX lanes here are the living lanes again,
and the earlier caveat about migrating a possibly-superseded lane is moot. (2) User directive —
**codex-scientiae adapters come last.** The operative order after Tranche 3: (a) doccer-native
CLI verbs and primitives, harvested from what work in codex-scientiae *and other sources*
implies belongs in doccer as domain-agnostic utilities (D13 surface, D14 anticipate-the-consumer);
then (b) only once that surface exists, the codex-scientiae adapters — the masks.ps1 veneer and
LaTeX-consumer adaptations — as thin consumers of it. Tranche 4's adapter items are deferred
accordingly; its CLI/wire-format items move ahead of them. F1's forcing consumer is now expected
to arise from the in-place renovation, whenever an edit-plan need first appears. First things
first: engine and native surface, then adapters.

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
| Q18 | monolith risk — must simple jobs pay the full treatment? | **resolved** | D12 — à la carte primitives; lazy substrate; identity floor stays |
| Q19 | where do à la carte tools surface — PS helpers or doccer-native? | **resolved** | D13 — CLI (task grain, inventories as data) + DLL (operation grain); PS = site-local veneer; graduation test |
| Q20 | does engine work wait for consumers? | **resolved** | D14 — contracts gate, consumers witness; F-triggers are prioritization defaults, not permission |
| Q21 | when do codex-scientiae adapters land? | **resolved** | Sequencing amendment — CLI + primitives first (harvested, anticipate-the-consumer); adapters last as thin consumers; scriba abort noted |
| Q22 | PerLine region: terminator in or out? | **resolved** | D15 — content extent only (CRLF/LF determinism); terminator = substrate evidence; per-line terminator-kind view = future derived fact |

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

## D12 lazy-substrate report

**2026-08-01 · Fable.** The D12 immediate consequence landed; harness green at 967 checks
(959 prior + 8 new).

- **Lazy fingerprint and topology** — `TextMaster`'s constructor no longer computes anything
  beyond argument validation and field assignment. `Fingerprint` and `Topology` are each backed
  by a `Lazy<T>` (thread-safe default mode), computed on first access and cached. The D1 hash is
  unchanged — SHA-256 over `MemoryMarshal.AsBytes(text.AsSpan())`, host-endianness caveat kept at
  the hash site.
- **Reference fast-path** — `IsCompatibleWith` returns true via `ReferenceEquals` before touching
  any field, so same-instance algebra (every `SpanSet` op between sets bound to one master) never
  forces the fingerprint. Distinct instances still take the full field-by-field comparison,
  fingerprint included; validation semantics are unchanged.
- **Primitive path audited** — `ValidateSpan`/`IsScalarBoundary` read `Text` directly (unchanged);
  the only engine reads of the lazy values are `Validation` atom sweeps (a composition that asks
  for topology) and `SpanSet.GetHashCode` (forces the fingerprint only when a set is actually
  hashed — accepted, left as is).
- **Observability** — the projects are split (the tests csproj references `Doccer.csproj` rather
  than compiling engine sources), so internal `FingerprintIsCreated`/`TopologyIsCreated` flags
  (`Lazy<T>.IsValueCreated`) are exposed to the harness via `InternalsVisibleTo("doccer.tests")`
  in the engine csproj. New checks: same-master algebra creates neither value, `GetLineSpan`
  forces topology only, and a same-id distinct-instance comparison forces fingerprint only
  (8 checks).

## Tranche 2 report

**2026-08-01 · Fable.** The remainder of Tranche 2 landed in five commits; harness green at
**1257 checks** (967 at the start of this tranche, +290). The lazy-substrate item was already
discharged in the D12 report above, so this covers the other five. Every commit was green before
it was made.

### What landed

**1. Interned batch columns (`SpanBatch`).** `Kinds`, `Sources` and `RuleIds` are now
`InternedColumn`: per-row integer IDs into a first-appearance-ordered table of distinct values,
built at `Freeze` — the one point where the claim set stops growing. Equal values share one table
entry and one ID; a nullable column records `InternedColumn.NullId` for absent values. The public
`SpanRecord` surface is unchanged (`Kind`, `Source`, `RuleId` still read as strings, now through
the column indexer), and the interned columns are public so columnar consumers can group or
persist by ID. IDs are batch-local and carry no cross-batch meaning — F2 will have to say what, if
anything, makes them portable.

**2. Derived run views (D4).** `TextTopology.EmitRuns(breakKey, comparer?)` emits the maximal atom
runs agreeing on an explicit key. A run is exactly `(Span, Key, AtomCount)` — no "run category"
field, which is the point: a run keyed on something other than category has no single category,
and naming the key on the run is what dissolves the Lu→Ll contradiction. `AtomFacts` holds the
built-in selectors — `Category`, `CategoryClass`, `IsValidScalar`, `LineIndex` — and a
tuple-returning selector breaks on several facts at once. `CategoryClass` is the seven UCD major
classes (L/M/N/P/S/Z/C), a mechanical fold over `UnicodeCategory` needing no data table. Emission
is a method, never cached and never constructor work; the selector is evaluated once per atom.

**3. Suppression queries (D3).** `Suppression.Excluded(batch, suppressor)` derives the region the
nominated claims cover; `Suppression.Admitted` is its dual, the master extent minus that region,
and is the set to hand a scoped collector. Both are compositions over `SpanSet.FromClaims` plus the
complement — no new mechanism — so further composition stays in the same algebra (several
suppressors union their excluded regions; narrowing to a prior region is an intersection). The XML
docs carry the rule that suppression is a query policy and never a claim property, and that the
legwork's suppression bitmap would be an acceleration of this query.

**4. Execution scope and the JSONL inventory loader (D6/D7, D13).** `ExecutionScope` lands on
`PatternRule` as the run-within operation: `WholeMaster` (default) or `PerLine`. `SpanLevel` stays
claim metadata and is independent of it — a `Line`-level rule may still sweep the whole master, and
the harness pins that. The rule-level scope and the caller's `SpanSet` **compose by intersecting
admitted regions**: the rule proposes regions, the caller admits regions, and each surviving piece
is matched on its own, so line extents stay separated through the intersection.
`PatternRuleLoader.LoadFile(path)` and `Load(lines, origin)` read a JSONL inventory with loud
per-line failure — schema violation, unknown enum value or regex option, uncompilable pattern,
empty-capable pattern, duplicate id — each throwing `PatternRuleLoadException` carrying origin and
1-based line, message formatted `origin:line: detail`. Blank lines are tolerated and still counted,
so provenance matches an editor. Patterns carry no syntactic obligations (D6 dropped `^...$`): a
per-line rule says so with its scope. The empty-match probe is now one implementation
(`RegexCollector.CompileAndProbe`) shared by in-code collection and the loader. Per the D13
addendum the schema is declared once: `PatternRuleDocument` is a loader-owned record, camelCase on
the wire, unknown members disallowed, serialized through the source-generated `DoccerJsonContext`
that a CLI surface will extend with span and claim payloads rather than duplicate.

**5. Tier-1 invariants.** Twelve fixtures chosen for boundary behaviour — every line-terminator
form (LF, CRLF as one break, lone CR, NEL, LS, PS), SMP scalars, both lone surrogates, a combining
sequence against its precomposed twin, NBSP, and the empty and trailing-break degenerate cases —
each assert gapless tiling, exact concatenation back to the source text, every atom's `LineIndex`
equalling `GetLineIndex` of its start, line extents partitioning `[0, length)`, and every offset
lying in its own line's extent. Run views tile exactly under every break-key exercised, including
a composite and a constant key. Resolution determinism: `Laminarizer.Extract` over a 60-claim
randomized batch with repeated geometries and tied priorities yields identical accepted/residue
ordinals and an identical flattened tree twice over, a filtered extraction is equally
reproducible, and replaying the same claims into a fresh batch resolves identically — determinism
belongs to the ordering rules, not to one object's identity. Suppression laws (idempotence,
complement duality, policy-not-property, and non-intersection with scoped collection) and
interning round-trip complete the set.

Also reflected into `src/doccer/README.md`, the in-repo contract surface.

### What was skipped, and why

Framed per D14, which landed in this run just before this report: the gate on each of these is an
open contract, not an absent consumer, and closing them is schedulable design work.

- **Register, language, value and metadata columns** — their contracts are open, so implementing
  them would be implementing against an open contract (D10). Nothing was invented for them. The
  interning mechanism itself is column-agnostic, so closing those contracts later is an addition,
  not a rework.
- **Unicode block and script tables** as break-key facts — decision-gated, exactly as D14 states:
  a UCD data-provenance record (pinned version, tables as versioned data with their own stamp,
  facts computed lazily per D12) closes the contract, after which they land as ordinary
  `AtomFacts` selectors. `EmitRuns` needs no change to accept them — a break-key is a function of
  an atom, and a block or script selector is one more such function. Recorded in the README's
  absent list.
- **"Registers" in sol's Tier-1 list** — no register machinery exists in this engine, so there was
  nothing to write an invariant against. Not invented; noted here instead. Whether "register" in
  that list meant a claim-kind register, a math-register notion carried over from the corpus
  lanes, or something else is itself unresolved.

### Flagged questions — contracts to extend before the next tranche assumes an answer

1. **Columnar surface visibility.** The interned columns are public; `Starts`, `Ends`, `Levels`
   and `Priorities` remain internal as they were. Whether the whole columnar surface is public
   contract, or only the interned part, is undecided. Per D14 this is closable by design now —
   F2 is the prioritization default, not the permission.
2. **Regex options and determinism.** An explicit `options` list in an inventory is applied
   **literally**; `CultureInvariant` is the fallback only when the field is absent (matching the
   existing `PatternRule` default). Taking the list literally avoids fusing policy into data, but
   it also lets an inventory write `["IgnoreCase"]` and get culture-sensitive matching, which sits
   badly against D10's determinism criterion. Forcing `CultureInvariant` is the alternative;
   neither is chosen here.
3. **What a per-line region is.** `PerLine` uses `TextTopology.GetLineExtent`, so the line break is
   *inside* the region and visible to the pattern. This follows D6's wording ("within each line
   extent") and keeps one definition of a line, but `GetLineSpan(includeLineBreak: false)` is the
   live alternative and deserves an explicit record either way.
4. **Built-in fact selectors are typed delegates, not an enum.** An enum would force every built-in
   to a common key type — boxed, or lossy `int`, or a union — which would put the run's key back in
   the "meaning depends on something the run doesn't carry" position D4 removed. Typed selectors
   keep each key at the fact's own type. Recorded as a shape choice, not a decision record.
5. **`PatternRule`'s positional parameter list changed** — `scope` is inserted after `level`, before
   `priority`. All in-repo call sites passed four positional arguments, so nothing broke, but any
   out-of-repo caller passing `priority` positionally would silently rebind. Worth a note if the
   engine is consumed before it graduates.

### Ledger delta

| # | question | status after Tranche 2 |
|---|---|---|
| Q2 | atom taxonomy / run key | **implemented** — `EmitRuns` + `AtomFacts`; block/script deferred on data provenance |
| Q3 | `is_mask` intrinsic vs query | **implemented** — `Suppression.Admitted`/`Excluded`, laws in the harness |
| Q5 | loader syntactic rules | **implemented** — `ExecutionScope` on the rule; no pattern syntax obligations |
| Q6 | "lift" conflation | project and run-within **implemented**; group, rebase, materialize open (Tranche 3) |
| Q12 | persisted batch format | still open, but interned columns and the declared-once JSON context are now the groundwork F2 builds on rather than duplicates |
| Q20 | does engine work wait for consumers? | applied — every Tranche-2 skip above is contract-gated, none consumer-gated |

## Tranche 2 reconciliation — D14 conformance pass

**2026-08-01 · Fable.** A follow-up pass to check that Tranche 2's output conforms to D14, which
was committed (`b0664ea3`) while Tranche 2 was in flight. Harness re-run green at **1257 checks**,
matching the count the Tranche 2 report states. No behaviour, API or test logic changed in this
pass.

**Brief integrity — intact, nothing repaired.** Exactly one copy each of D14 (§3), the sequencing
amendment (§5), ledger rows Q20 and Q21 (§6), and the `## Tranche 2 report` section. The second
`| Q20 |` row a naive count finds is the Tranche 2 report's own *Ledger delta* table, which is a
deliberate per-tranche delta, not a duplicated canonical row. The pass's premise of a worktree
merge did not apply: Tranche 2 was done directly on `main`, so `b0664ea3` and `414570e8` (D14, the
amendment, Q20/Q21) interleaved as ordinary commits rather than merging. Verified that none of the
five Tranche 2 commits swept up those concurrent edits — each touched only its own engine, harness
or documentation files.

**No `### Tranche 2 report — D14 correction note` was appended, because the report does not need
one.** The condition for that block was the report justifying an exclusion by consumer absence; it
does not. Grep over the report finds three uses of "consumer", all sound: one descriptive
("columnar consumers can group or persist by ID"), and two already stating the D14 position —
"the gate on each of these is an open contract, not an absent consumer, and closing them is
schedulable design work", plus the Q20 delta row. The honest reason is timing rather than
foresight: the brief changed on disk mid-tranche, D14 was read before the report was written, and
the skip rationale was rewritten from the chip's original "no closed contract and no consumer
(D10 admission test)" phrasing to contract-gating before the report was ever committed. The
original consumer-gated wording therefore never entered the canon. Recorded here so a later reader
does not go looking for a correction that has no target.

**Code sweep — two fixes, all in `src/doccer/README.md`.** The engine and harness sources carry no
consumer-gated rationale; the two "consumer" mentions there are descriptive, not gating
(`AllenRelation.Join`'s "consumers must not rely on" its performance characteristics, and
`InternedColumn`'s note that interning serves columnar consumers). The contract surface did carry
it, in text predating Tranche 2:

- the *Deliberately absent* preamble said those families have "drafted shapes waiting on their
  first real consumer" — now states that contract closure is the only gate, that a consumer
  prioritizes and validates but never authorizes, and that a named "first consumer" trigger reads
  as a prioritization default any item may be pulled ahead of;
- the `OffsetMap` bullet said "implementation waits for its first consumer" — now says its
  remaining open questions are the ones a real edit-plan or normalization job would settle best,
  making that job the prioritization default rather than a permission condition.

Scope note: those two lines were not introduced by the Tranche 2 diff, but they sit in the file it
touched, they are the in-repo contract surface, and they stated the doctrine D14 corrects. Fixed
in place under the rev-5 judgment note (framing prose, not a traceable decision).

**Flagged questions.** The five open questions Tranche 2 raised are already in this canon, stated
in full under *Flagged questions* in the Tranche 2 report immediately above. They are deliberately
**not** restated verbatim here: repeating them would put them in the canon twice, which is what
"surface once" exists to prevent. What this pass adds instead is which of them D14 makes
immediately actionable — under D14 none of the five is blocked on a consumer, so all five are
schedulable design work whenever they are picked up:

| # | question | shortest path to closure |
|---|---|---|
| 1 | columnar surface visibility (interned public, numeric internal) | pure design decision; D14 removes F2 as a precondition |
| 2 | inventory regex options taken literally vs forcing `CultureInvariant` | decide against D10's determinism criterion; no consumer input needed |
| 3 | whether a `PerLine` region includes the line break | decide between `GetLineExtent` and `GetLineSpan(false)`; record either way |
| 4 | built-in fact selectors as typed delegates rather than an enum | shape choice already made; promote to a record only if it should bind future selectors |
| 5 | `PatternRule` positional parameter order shifted (`scope` before `priority`) | no in-repo breakage; decide whether pre-graduation callers warrant a compatibility note |

Question 3 is the one worth taking first: it changes what a per-line rule *sees*, so every
inventory written before it is settled encodes an assumption about it.
