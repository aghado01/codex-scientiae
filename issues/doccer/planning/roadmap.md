# Doccer roadmap — what is ahead

Living document — current truth, corrected in place, holding only work **not yet done**.
Decisions and the question ledger live in [decisions.md](decisions.md); completed roadmap items
move to [ledger.md](ledger.md); arguments in the runstamped briefs under
[../briefs/](../briefs/); evidence in [../discussions/](../discussions/).

## Current state (2026-08-05)

Engine at `src/doccer` (`CodexSci.Doccer`), canon **D1–D37**, contract harness **1914 checks
green** (`dotnet run --project brewery/doccer/Doccer.Tests.csproj`). The capability inventory is
`src/doccer/README.md` — the in-repo contract surface; the completed-item record is the
[ledger](ledger.md). Legacy implementation Tranches 0–3 are done: the substrate is complete, the
lift vocabulary lacks only materialize, and the first D8 measure is landed. Delivery:
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
independent 16,384-problem optimizer oracle. K4b is closed. K4c structural-family hygiene is active
next.

## Sequencing doctrine

Engines first; **codex-scientiae adapters last**. scriba-scientiae was aborted — codex is
renovated from the inside, so its converter/LaTeX lanes are the living lanes, and they become
thin consumers of doccer only after the doccer-native surface exists. Contracts gate work;
consumers witness (D14). Per-topic containment: `planning/` = living truth (decisions, roadmap,
ledger); `briefs/` = one small runstamped brief per chip iteration, guidance + that chip's
report appended on completion; `discussions/` = captured evidence.

## Queue

The detailed dependencies, tranche gates, and non-goals live in the
[architectural expansion workplan](architecture-expansion-workplan.md). The compact execution
order is:

1. **K4c structural-family hygiene:** K4b's first exact flat-path executor is closed by D37; it
   creates no dependency from K4c. Add packing, cover, selection-backed and basis/policy-stamped
   laminar validation, explicit nearest-container projection, multiple-parent hierarchy, and
   resolution incidence. Keep family-specific executors separate; consider a common selection
   abstraction only after K4c supplies actual comparison evidence. Further flat-path objectives
   such as partial paths or signed/vector scores remain separately named future chips, not hidden
   extensions of D37.
2. **Facts and support (K5):** once register/value/metadata identity closes, separate observed
   occurrences, canonical facts, support hyperedges, and finite positive saturation. This open
   identity question does not block K0-K4.
3. **Origins and materialization (K6-K7):** define typed output-to-source origin relations before
   closing D7's final lift with ordered output pieces, a new immutable master, residuals, and
   composed stage origins. `OffsetMap` becomes a restricted monotone single-source view, not the
   universal transform carrier.
4. **Cross-carrier integration demonstrations (K8):** re-run pairing, ambiguous token paths,
   budgeted flat chunks, fixed bounded macro substitution with composed origins, and explicitly
   bounded dynamic expansion as one integrated suite. Their first bounded witnesses already land
   with K2, K3/K4, and K6/K7; K8 proves composition across the completed kernel.
5. **Downstream and optional branches:** stable carrier identities unlock CLI wire forms, durable
   adapters, persistence, and indexes. A fixed linear-ET compiler may follow K7; uncertain QSTR
   networks branch from K1 only when a real consumer appears. Neither is on the kernel critical
   path.

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
universal no-false-negative equivalence load-bearing. D33–D37 leave K3/K4a and the first K4b
executor on direct finite reference semantics. D37 reapplies the global-optimum trigger and keeps
Lean deferred under one closed finite-DAG additive recurrence plus exhaustive differential
evidence. Reapply again before a second/optimized path backend, generalized objective algebra,
nontrivial partial-path guarantee, or K4c global optimum/equivalence claim.

**First CLI verbs (D13) remain deferred pending surface design.** The operational terminology is
still a catalog, not a contract, and the wire format waits for stable carrier identities and the
latent-manuscript node-stream schema. The current `inspect`/`relate` commands remain disposable
developer diagnostics. Durable adapters remain last: PowerShell veneers and LaTeX consumers become
thin clients only after the relevant Doccer surface stabilizes.

Other independent closures remain available under D14: the F-UCD data-provenance record, a callable
runtime Tier-1 law runner if demanded, and early `OffsetMap` pressure tests that do not pre-empt the
K6 origin contract.

Maturity-gated beyond that: F2 persisted batches → F4 indexed joins → F5 Tier-2/3 agreement
scoring → F6 markdown adapter and the mdnav succession (oracle harness on the doc-dive
fixtures; exceed mdnav precisely at its collapse points; conserve its instrument virtues).

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

- See [decisions.md § Open](decisions.md): register/value/metadata columns (entangled with the
  math-register design), the meaning of "register" in sol's Tier-1 list, and the named
  per-line terminator-kind view (unscheduled). All Tranche-2 stragglers are closed — see the
  [ledger](ledger.md).

## Standing context for future sessions

- Decision canon, this roadmap, and the ledger are the entry points; `src/doccer/README.md` is
  the in-repo contract surface and must stay in agreement.
- MarkPig legwork = historical evidence, never amended. mdnav relation = succession + spec
  witness, no cross-talk (its three strata: pseudo-parsing → supplanted eventually; instrument
  verbs → spec witness; doc-dive skill semantics → permanently above the engine).
- Doccer is expected to graduate cross-project; anything a graduated doccer would need must live
  in the C# surface, not PowerShell (D13 boundary test).
