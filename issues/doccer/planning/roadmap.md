# Doccer roadmap — what is ahead

Living document — current truth, corrected in place, holding only work **not yet done**.
Decisions and the question ledger live in [decisions.md](decisions.md); completed roadmap items
move to [ledger.md](ledger.md); arguments in the runstamped briefs under
[../briefs/](../briefs/); evidence in [../discussions/](../discussions/).

## Current state (2026-08-09)

Engine at `src/doccer` (`CodexSci.Doccer`), canon **D1–D44**, contract harness **2324 checks
green** (`dotnet run --project brewery/doccer/Doccer.Tests.csproj`). The capability inventory is
`src/doccer/README.md` — the in-repo contract surface; the completed-item record is the
[ledger](ledger.md). Legacy implementation Tranches 0–3 are done: the initial text/claim substrate
is complete; the lift vocabulary lacks only materialize, and the first D8 measure is landed. Delivery:
`build-doccer.ps1` →
`packages/doccer` with `doccer.manifest.json` as provenance (`packages/` is untracked; refreshes
are local-only). The post-Allen literature review, factory analysis, and formalization audit are
now synthesized in the [architectural expansion workplan](architecture-expansion-workplan.md).
K0 is closed as D25. K1 is closed by D26 and D28: the immutable private-13-bit
`AllenRelationSet`, Boolean/converse surface, canonical `AllenCompose`, literal table, independent
\(D_6\) oracle, JEPD closure, finite-gap boundary, and durable validation-filter migration are
implemented and exhaustively checked. The expansion workplan orders the remaining implementation.
D27 and its
[sequencing brief](../briefs/sol-doccer-k1b-k4-resequencing-20260804_184200.md) reconcile the K1b–K4
chip boundaries so temporary consumer APIs are not introduced merely to be replaced by the next
carrier. D29 and the
[joint K2 contract](../briefs/sol-doccer-k2-joint-contract-20260804_214547.md) freeze the exact
occurrence bases, reference `ComposePairs`, one-way Allen-image abstraction, pairing residue, and
Lean-gate disposition. K2a is closed by D30 and its
[implementation report](../briefs/sol-doccer-k2a-claim-selection-20260804_221441.md): immutable
exact-batch selection algebra, explicit ordered/coverage projections, and selection-backed
grouping/cadence/suppression are implemented. K2b is closed by D31 and its
[implementation report](../briefs/sol-doccer-k2b-claim-pair-view-20260805_022512.md): the exact
pair carrier, direct composition, complete middle witnesses, executable Allen bridge, and the one
terminal-join transition are implemented. K2c is closed by D32 and its
[implementation report](../briefs/sol-doccer-k2c-pairing-result-20260805_093203.md): exact
role selections, named compatibility policy, strict top-only stack matching, complete
identity-bearing match/fault residue, and explicit paired-region projection are implemented.
K2 is closed. D33 and its
[joint K3/K4a contract](../briefs/sol-doccer-k3-k4a-joint-contract-20260805_105443.md) freeze the
concrete located basis, graph projection, shared geometry-reachability boundary, identity-bearing
path results, and specialize-before-generalizing selection course. D34 and its
[peer-review adjudication](../briefs/sol-doccer-k3-k4a-review-adjudication-20260805_151759.md)
correct the false K4b-to-K4c dependency, split the core/result gates, and make the exact-batch to
compatible-geometry seam, ordinal stability scope, K4c hygiene debt, and empty-admitting sequential
predicate explicit. D35 and its
[joint-core report](../briefs/sol-doccer-k3-k4a-core-20260805_182229.md) implement the
compatible-master/exact-window located algebra, exact-selection candidate graph, explicit
identity-forgetting projection, and bounded algebra/rebase/projection assurance. K3 and the K4a
core are closed. D36 and its
[K4a result report](../briefs/sol-doccer-k4a-results-20260805_184359.md) add exact-graph-stamped
reachability diagnostics, validated ordinal partitions, the named first-ordinal result, distinct
gap/dead-end residuals, and the independent bounded path oracle. K4a is closed. D37 and its
[K4b report](../briefs/sol-doccer-k4b-additive-path-selection-20260805_191324.md) close the default
flat-path lane with exact admissibility, snapshotted nonnegative additive costs, global minimum
complete-path selection, lexicographic ordinal ties, complete decision/residual evidence, and an
independent 16,384-problem optimizer oracle. K4b is closed. D38 and its
[K4c contract](../briefs/sol-doccer-k4c-structural-contract-20260805_194514.md) split validators,
admission, parenthood, and resolution before source work. D39 and its
[K4c results](../briefs/sol-doccer-k4c-structural-results-20260805_201030.md) implement exact
packing/cover/laminar views, inclusion-maximal admission, explicit and nearest-container hierarchy,
and resolution incidence/aggregation under independent bounded oracles. K4c is closed. D40 and its
[correction brief](../briefs/sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md)
then remove the accidental codepoint-register/math-channel dependency, make exact-basis graph
value equality coherent across K4, split K5a identity/support from K5b saturation, and make K5 and
K6 sibling lanes toward K7. Existing `math-register` paths retain that legacy name pending the
separate terminology migration. D41 and its
[round-2 capability excavation](../briefs/sol-doccer-expansion-round2-adjudication-20260806_093159.md)
leave that K sequence unchanged. The owner-amended decision treats ThermoMapper as a source of
transferable concepts/patterns/capabilities rather than Doccer policy, adds independent V0/V1 and
A0–A2 lanes plus a per-capability HPC repertoire, retains the F2 fingerprint-portability gate,
and splits F7–F9 by their actual carrier dependencies: correspondence versus origin production,
exact/rolling hash versus candidate index/sketch, and counted/online versus fitted/ranked feature
views. No source surface or harness count
changed in D41; ThermoMapper-facing repair guidance lives in the ThermoMapper repository.

D42 then splits D41's overloaded V-lane assurance row into the vector carrier, prefix-scan
refinement, harvest bridge, future packed `SpanSet` equivalence, and future D3
suppression-bitmap equivalence. V0/V1 remain independently available and Lean remains deferred.
A packed region or suppression backend advertised as interchangeable over arbitrary inputs is now
a presumptive optimization-pressure activation; the exact obligation and cheaper-certificate
check are recorded in the
[deferred Lean addendum](../briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md)
and [design inquiry](../discussions/sol-doccer-material-basis-and-public-composability-20260806_105530.md).

D43 and its
[K5a contract brief](../briefs/sol-doccer-k5a-contract-20260809_193131.md) then supersede the
provisional K5a shape: `SpanBatch` remains the exact occurrence table; compatible master plus
required domain/kind, ordered geometry, and canonical string-value tuples define semantic facts;
canonical fact tables deduplicate and order those values; exact fact-table/occurrence bases retain
ordered alternative support; and K7 receives only a narrow exact-table `FactReference`. K5a adds
no executable rule or fixed-point claim. The law registry now separates `K5-FACT-SUPPORT` from
K5b's `K5-SATURATE`. The implementation chip then landed the carriers as `src/doccer/Facts/` —
`FactKey`, `CanonicalFactTable` plus `FactReference`, and `SupportEdge` plus
`SupportHypergraph` — with the
manual hierarchy-diamond witness and the full D43 exit gate (harness 1976→2091; **K5a closed**).

D44 and its
[K5b saturation brief](../briefs/sol-doccer-k5b-saturation-contract-20260809_215158.md) freeze and
implement the executable lane against those actual carriers. K5b consumes one exact initial
support graph plus finite data-only `GroundRule` implications, computes the least positive closure
in `FactKey` space, retains every enabled support, and only then freezes a new canonical table and
remaps all evidence to final ordinals. Unsupported initial facts, zero-arity rules, and finite
cycles are explicit; callbacks, variables, negation, selection, and stage observation remain
outside the contract. The `K5-SATURATE` gate was reapplied and deferred because this finite ground
signature makes its hypotheses structural. The direct worklist, 24 seed/support/rule permutations,
executable hierarchy diamond, and independent 256-program powerset oracle close K5b (harness
2091→2324). K6 is now the default K execution lane.

## Sequencing doctrine

Engines first; **codex-scientiae adapters last**. scriba-scientiae was aborted — codex-scientiae is
renovated from the inside, so its converter/LaTeX lanes are the living lanes, and they become
thin consumers of doccer only after the doccer-native surface exists. Contracts gate work;
consumers witness (D14). Per-topic containment: `planning/` = living truth (decisions, roadmap,
ledger); `briefs/` = one small runstamped brief per chip iteration, guidance + that chip's
report appended on completion; `discussions/` = captured evidence.

## Queue

The detailed dependencies, tranche gates, and non-goals live in the
[architectural expansion workplan](architecture-expansion-workplan.md). The compact execution
order is:

1. **Origin execution lane (K6):** add output-to-tagged-source origin relations over one exact
   tagged origin basis. K5b is closed and does not block K6.
2. **Materialization (K7):** after K6, close D7's final lift with positive-material ordered output
   pieces, a new immutable master, residuals, and composed stage origins. K7 has only an optional
   K5a `FactReference` seam; it does not require saturation. `OffsetMap` becomes a restricted
   monotone single-source view, not the universal transform carrier.
3. **Cross-carrier integration demonstrations (K8):** re-run pairing, ambiguous token paths,
   budgeted flat chunks, fixed bounded macro substitution with composed origins, and explicitly
   bounded dynamic expansion as one integrated suite. Their first bounded witnesses already land
   with K2, K3/K4, and K6/K7; K8 proves composition across the completed kernel.
4. **Downstream commitments and optional branches:** stable carrier identities unlock the
   committed separate CLI module and its wire forms, durable adapters, persistence, and indexes.
   Most substantial F8/F9 implementations retain a post-K
   execution default, but no family has a blanket K8 type dependency: F7a correspondence,
   F8a/F8b low-level contracts, and F9a views over current populations are independent; F7b/F7c
   and fact/origin feature recipes wait only for the carriers they name. D8/D10 decide kernel
   versus adjacent placement one named capability at a time. A fixed linear-ET compiler may follow
   K7; uncertain QSTR networks branch from K1 only when a real consumer appears.

**Independent V/A lanes:** V0 may now close the compatible-master/exact-window UTF-16 code-unit
Boolean-vector contract, unit residual, chunk carry, and direct/harvest exits. Its portable V1
implementation follows independently and precedes any V2 accelerated backend. D42 requires V0 to
state carrier, scan, and harvest obligations separately; V2 reapplies scan refinement per backend,
while packed `SpanSet` and suppression-query equivalence remain separate future gates. A0
may establish named dense/sparse time and allocation baselines now; A1's word-skipping
`ClaimSelection` walker
and A2's reconstruct-once `PathSelection` recurrence may then land under the frozen D30/D37
oracles. The per-capability HPC repertoire records span destinations, exact allocation, flat
layouts, operation/worker scratch, bounded heaps, online reductions, deterministic parallel state, and
reference/fast pairing—not a common framework. These lanes do not change K6's default priority or
expose D20 numeric columns. Their evidence policy is Doccer's, not ThermoMapper's.

**Parallel witness/census lane:** provisional PowerShell adapters may continue to reach directly
into the packaged DLL during the latex-ingest rewrite. They remain site-local, disposable research
instruments whose specimens test the vocabulary and expose missing compositions. They do not
freeze the public surface or postpone the ordered kernel work above.

**Lean rigor is deferred and burden-triggered.** The
[bootstrap brief](../briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md) records the
ThermoMapper retrospective, corrected harness design, obligation triage, and restart procedure.
Activate it only when proof pressure can change a public signature, license an optimization or
stage fusion, resolve an exact-versus-lax boundary, or support a nontrivial global guarantee.
D29 records that the K2 Allen-image inclusion is an obligation but not an activation: reference
composition and C# witness/property tests own it until an optimized or generalized backend makes
universal no-false-negative equivalence load-bearing. D33–D44 leave K3/K4a and the first K4b/K4c
executor on direct finite reference semantics. D37 reapplies the global-optimum trigger and keeps
Lean deferred under one closed finite-DAG additive recurrence plus exhaustive differential
evidence. D39 reapplies the structural gate and keeps Lean deferred under direct validators,
explicit relations, a non-optimal greedy reference policy, and bounded differential oracles.
D43 discharges D40's K5a review without activation because K5a exposes immutable identity/support
values, not a rule carrier or fixed-point guarantee. D44 reapplies and defers K5b under finite
data-only ground implications, an explicit positive operator, and landed direct-oracle assurance.
Reapply for a variable-bearing/callback rule carrier or alternate, compressed,
parallel/incremental saturation backend. Also reapply before a
second/optimized path or structural backend, generalized objective/carrier,
nontrivial partial-path guarantee, global structural optimum, hierarchy closure/reduction law, or
resolution-map composition/equivalence claim. D42 splits D41's V-lane gate: carrier signature,
prefix-scan refinement, and harvest soundness/completeness are distinct obligations, and V2
reapplies refinement per backend. Bit packing or a peer carrier is not automatic activation.
A future packed `SpanSet` or D3 suppression bitmap advertised as interchangeable over
arbitrary inputs presumptively meets optimization pressure; its chip must activate the smallest
obligation unless a cheaper complete certificate or a weaker claim honestly closes the gate.

**The separate public CLI module over the public capability library/engine is committed by D13;
its first durable vertical slice remains
deferred.** The [CLI-module return packet](../briefs/sol-doccer-cli-module-deferred-20260809_180623.md)
records the one-way module boundary, ThermoMapper `user-repl` lift, donor defects to avoid, and
reactivation gate. A later distribution may pair an executable host for declarative-engine and CLI
capabilities with selectively referenceable .NET assemblies/components. Exact assembly splits,
host topology, command grammar, and carrier-specific wire forms wait for stable identities;
the latent-manuscript node-stream schema gates document-stream commands, not the module or an
independently closed low-level carrier. Minimal cross-process wire work precedes and informs F2.
The current `inspect`/`relate` commands remain disposable developer diagnostics. Durable adapters
remain last: PowerShell veneers and LaTeX consumers become thin clients only after the relevant
Doccer surface stabilizes.

Other independent closures remain available under D14: V0/V1, the A0–A2 measured backend lane,
F7a correspondence, F8a/F8b low-level contract or current-carrier witnesses, F9a counted/online
views over current populations, the F-UCD data-provenance record, a callable runtime Tier-1 law
runner if demanded, and early `OffsetMap` pressure tests that do not pre-empt K6 origins.

Maturity-gated beyond that: F2 persisted batches (after fingerprint algorithm/version/canonical
byte order) → F4 indexed joins → F5 Tier-2/3 agreement scoring → F6 markdown adapter and the mdnav
succession (oracle harness on the doc-dive fixtures; exceed mdnav precisely at its collapse
points; conserve its instrument virtues). Broader F8 signature/index/sketch and F9 fitted/search
implementations retain post-K priority; F7 transform-origin/promotion and fact/origin feature
recipes are scheduled by K6/K7/K5 carrier dependencies rather than K8 as a blanket. D14 permits
pulling forward any independently closed, witnessed capability.

## Standing practice — the abductive census

The demand census is **standing and abductive, never a read-everything sweep**. As doccer
integrates into live workflows (the latex-ingest end-to-end pass is the first named occasion),
every bespoke resolution encountered raises the question *"should this be reading doccer
instead?"* — hits become site records in the **future-consumer registry** (named witnesses
tagged to their F-families, replacing abstract triggers with counts), and helper utilities /
public-surface exposure grow opportunistically through the same evidence discipline that minted
the first verbs. The graveyard repair farm (`codex-scientiae-graveyard/legacy_code/tools`,
`repair_*` ×~30) is an evidence pool consulted when its family comes up — F1 edit plans — not
a gate on anything.

The object of the search, stated once: the engine's **latent path-space** — every capability
reachable by composing the primitives (D12 keeps that space open; verbs signpost dense routes
through it, never wall it off). A verb **names** a latent call path, making it a reachable
capability at task grain; the **capability surface** — the doccer public API — is the named
subset, carved from the path-space by witnessed demand. Census abduction therefore yields
finds of exactly two kinds: an **unnamed latent path** (the engine already composes it — a
verb candidate; `collect` and the span algebra are this kind, `SpanSet` being already
complete) or a **missing path** (no composition reaches it — an engine-contract candidate;
the pairing lift is this kind). The rewrite test's "refusal to collapse" is what
distinguishes the second kind from permanent adapter policy.

Process discipline for the census — three rules, all guarding one failure mode: **conflating
fact-finding research with conclusions**:

1. **Catalog before naming.** Capture the candidate, its contract shape, and its integration
   points first; promotion — a verb name, an implementation — is always a later, separate act
   of evaluation over the catalog, never simultaneous with capture. The catalog is a
   **research device, not code** — tabulated field observations, the way a naturalist pins
   specimens long before declaring taxonomy, and most specimens never become species. Its
   form is the site-record line already in use (where · what it improvises · suspected bin ·
   family tag), living in the discussion docs; it gets no schema, no tooling, and no home in
   the engine.
2. **Composition before extension.** Before any find is declared a missing mechanism, attempt
   to compose it from existing primitives plus a named policy. Success means it was a missing
   *example*, not a missing mechanism — the deliverable is a recipe (documentation or a store
   entry), never engine work. Every mechanism claim carries the failed-composition argument as
   a proof obligation. (The pairing lift passes: stack-discipline matching is not expressible
   as a composition of the current operations.)
3. **Residuals stay visible.** When a site needs a judgment — which claim wins, what "near"
   means, whether to rewrite — that judgment is orchestration. The engine exposes the evidence
   and the policy hooks, never the judgment. (The pairing fault residue is the template: the
   engine emits `unclosed`/`dangling`/`mismatched` as evidence; remedies belong to consumers.)

Census finds therefore land in four bins: **unnamed latent path** (verb candidate) · **missing
example** (recipe / store entry — cheap, no engine work) · **missing mechanism**
(engine-contract candidate, composition-refusal argued) · **permanent adapter policy**.

## Open questions in play

- See [decisions.md § Open](decisions.md): V0's exact public vector/classifier/harvest shape is
  independently active contract work; the per-line terminator-kind view remains
  unscheduled. D40 restores Doccer's historical register to its codepoint-address meaning and
  removes the unrelated math-channel dependency; `math-register` remains only the legacy
  repository name pending migration. D41 keeps post-hoc alignment evidence distinct from actual
  producer origins. D42 splits the V-lane formal obligations without activating Lean or changing
  the K queue. D43 closes K5a and its implementation; D44 closes K5b ground saturation and its
  implementation. All Tranche-2 stragglers are closed — see the
  [ledger](ledger.md).

## Standing context for future sessions

- Decision canon, this roadmap, and the ledger are the entry points; `src/doccer/README.md` is
  the in-repo contract surface and must stay in agreement.
- MarkPig legwork = historical evidence, never amended. mdnav relation = succession + spec
  witness, no cross-talk (its three strata: pseudo-parsing → supplanted eventually; instrument
  verbs → spec witness; doc-dive skill semantics → permanently above the engine).
- Doccer is expected to graduate cross-project; anything a graduated doccer would need must live
  in the C# surface, not PowerShell (D13 boundary test).
