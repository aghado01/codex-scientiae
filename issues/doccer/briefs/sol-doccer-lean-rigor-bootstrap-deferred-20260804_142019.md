# Doccer Lean rigor bootstrap brief — deferred, burden-triggered theory lane

Runstamp 20260804_142019. **Status: deferred.** This brief preserves the proposed Lean rigor
harness, audits the first version of the pattern in ThermoMapper, and states the condition under
which Doccer should revive it. It is guidance for a future chip, not authorization to scaffold a
Lean project now.

Inputs:

- [architectural expansion workplan](../planning/architecture-expansion-workplan.md);
- [formalization audit and proof-obligation inventory](../discussions/sol-doccer-formalization-audit-and-lean-obligations-20260803.md);
- [D29 joint K2 contract](sol-doccer-k2-joint-contract-20260804_214547.md);
- [ICDT 2025 ET close read](../discussions/fable-et-framework-close-read-20260803.md);
- [ThermoMapper rigor-harness README](../../../../ThermoMapper/lean/README.md),
  [enthymeme sources](../../../../ThermoMapper/lean/enthymemes/), and
  [meta-CI gate](../../../../ThermoMapper/lean/scripts/meta-ci.ps1).

## 1. Disposition

Doccer does not presently need a Lean project in order to implement the next kernel tranches.
The law registry remains useful, but it must choose the least expensive honest assurance medium
for each claim:

~~~text
executable counterexample
finite exhaustive certificate
independent reference implementation
C# property / differential test
external theorem with explicit hypotheses
Lean theorem
deterministic policy contract (not a theorem at all)
~~~

Lean is selected only when its burden meaningfully changes or protects implementation. It is not
the default badge of rigor, and a theorem being small or attractive is not by itself an activation
reason.

Consequences now:

- no Lean scaffold is on the active Doccer critical path;
- no C# contract waits merely for a formal restatement of standard algebra;
- K0 records claims, carriers, and their assurance medium without requiring a theorem file;
- the C# reference implementation and independent finite oracles remain the first line of defense;
- this brief is the restart packet if a later tranche crosses the activation threshold in §5.

## 2. What the ThermoMapper experiment got right

The core idea is worth preserving.

### 2.1 Retrospective formalization is the right orientation

ThermoMapper works backward from implemented engineering to the mathematical contracts on which
it relies. Calling the result a sibling of `tests/`—a theory-level unit-test harness—keeps the
formalization subordinate to the product rather than making the product a demonstration vehicle
for a proof assistant.

That is also the right posture for Doccer. Its proof subjects should be named public laws such as
"this rebase preserves composition" or "this compressed origin representation denotes ordinary
relation composition," not an attempt to formalize documents, parsers, or all of QSTR.

### 2.2 Epistemic promotion is better than pretending sketches are proofs

The three ThermoMapper stages separate:

1. informal candidate statements;
2. statements Lean actually elaborates while proofs may still use `sorry`;
3. declarations whose proof obligations are discharged.

That separation is honest and useful. Requiring an enthymeme to compile is especially valuable:
many apparent mathematical insights fail first because their quantifiers, carrier, or hypotheses
cannot be stated coherently. Stable declaration names also make proof completion a change in
confidence rather than a redefinition of the claim.

### 2.3 Formalization paid for itself when statement pressure changed the design

The highest-value ThermoMapper findings happened before or beside proof completion:

- The proposed Potts monotonicity argument named Griffiths inequalities too loosely. Restating
  the obligation exposed the actual route through the Edwards–Sokal/random-cluster representation,
  FKG positive association, and the load-bearing condition `q ≥ 1`.
- The theorem concerned the ideal equilibrium expectation, while the implementation consumed a
  noisy finite-sample estimate. That distinction exposed a real invalid-filtration hazard and a
  need for explicit monotonization or a stability certificate.
- Separating monotone reparameterization from the choice of slice distinguished an invariant
  change of speed from a lossy change of path. This was an architectural distinction, not proof
  ornament.
- The proved PKWang threshold lemma collapsed stochastic-looking apparatus to the deterministic
  condition `Hcum > T * log 2`, making an implementation reduction explicit.

These are the exemplars for Doccer. Proof work earns priority when theorem-statement pressure
finds a missing hypothesis, invalid equivalence, wrong carrier, or removable mechanism.

### 2.4 Quarantine deep inputs; prove the local plumbing

ThermoMapper's confidence-pushforward work demonstrates a sound factoring pattern: state a deep
external stability result at a narrow boundary, then prove the small event-inclusion and measure
monotonicity argument locally. This avoids both extremes—reformalizing an entire field and hiding
all local reasoning behind a citation.

For Doccer, the analogue is to cite established interval or relation-algebra results while proving
only the adapter between those results and Doccer's unusual carrier, identity, or origin choices.

### 2.5 Small, operationally named lemmas are the right grain

The successful PKWang theorem is a better model than an unfinished umbrella theorem. A future
Doccer obligation should normally identify one public consequence and one counterexample boundary.
If its statement needs a miniature general-purpose library before it can mention the behavior being
protected, the obligation has probably been pitched too high.

## 3. What the first harness iteration taught by failing

This is an audit of the harness mechanics, not a proposal to renovate ThermoMapper in this Doccer
chip. No ThermoMapper files were changed.

### 3.1 The taxonomy drifted across prose, paths, and module names

The README names `proto-lemmas`, while several source comments and the meta-CI synopsis say
`prelemmas`; only `proto-lemmas/` exists. The physical source directory is `enthymemes/`, while
Lean imports and the gate use `Enthymemes/`. Windows resolves that casing today, but the repository
shape is not portable to a case-sensitive checkout.

Lesson: one spelling and case must be canonical, mechanically checked, and used in prose links as
well as module imports.

### 3.2 The advertised gate currently fails before it can audit the ledger

On 2026-08-04, running `meta-ci.ps1 -NoBuild` stopped because it unconditionally enumerates a
`lean/Lemmas/` directory that does not exist. The root `Lemmas.lean` file exists, but the script
expects both. A gate that assumes its own optional directories cannot report the state it was
created to police.

Lesson: bootstrap validation must work in the empty state. It should create nothing implicitly,
treat absent optional tiers coherently, and give one complete audit rather than fail on its first
filesystem assumption.

### 3.3 The default aggregate does not cover every source

`Enthymemes.lean` imports six modules but omits `Stability.lean`. Because the Lake default target
builds the aggregate, a green default build does not establish that every checked-in theorem file
elaborates. Hand-maintained aggregate imports need an orphan check.

Lesson: compare registered modules, aggregate imports, and actual `*.lean` files in both
directions. A source may not exist outside the build graph silently.

### 3.4 Tier membership became stale

`PKWangA.lean` contains declarations with zero `sorry`s and is explicitly marked
promotion-ready, but remains under `enthymemes/`. Conversely, `Ascent.lean`, `Bifiltration.lean`,
and `PottsGriffiths.lean` contain no declarations and are proto-lemma placeholders wearing the
compiled-tier location.

The distinction is conceptually sound; file movement is a weak state machine when the strict gate
is not continuously enforced.

Lesson: promotion status should be explicit data checked against source facts, not inferred only
from a directory move that humans must remember to perform.

### 3.5 A sorried definition is more dangerous than an unfinished theorem

`PKWangB.lean` gives `localHCum` and `globalHCum` bodies of `sorry` and correctly declines to state
the downstream theorem. Such a definition can make later theorems compile about a fictional
function while hiding the missing construction under an apparently usable constant.

Lesson: the compiled-obligation tier may apologize for proofs, not for public definitions.
Definitions belong in the trusted model layer; otherwise quantify over the missing object and make
its required properties hypotheses, or leave the item in the proto ledger.

### 3.6 Zero `sorry` does not mean assumption-free

`Stability.lean` intentionally declares opaque stand-ins and an axiom for an external stability
theorem. Its local plumbing theorems are genuinely proved, but their trust boundary includes that
axiom. A source scan that reports only `sorry` counts cannot distinguish:

- a theorem proved from definitions;
- a theorem proved from accepted Lean foundations;
- a theorem proved conditionally from a named external result;
- a theorem that depends transitively on an accidental project axiom.

Lesson: promotion needs an assumption report—normally `#print axioms` or an equivalent environment
inspection—and an allowlist. Named external hypotheses are legitimate, but they must remain visible
in the obligation record and theorem API.

### 3.7 Text scanning is useful but not a semantic ledger

The gate counts the token `sorry` in source text, including comments, and recognizes only a selected
set of declaration forms. It cannot attribute an apology to a theorem, identify transitive axioms,
or prove that a compiled module is in an aggregate.

Lesson: text checks are suitable for cheap hygiene. The compiler and environment must supply the
semantic facts; the obligation ledger supplies intent.

### 3.8 Nested CI that never runs is documentation, not enforcement

ThermoMapper's README accurately notes that workflows below the repository root are inert. Strict
validation is optional (`-Validate`) and no enclosing workflow is identified as invoking it. This
explains why promotion-ready, unstated, orphaned, and missing-directory states can coexist.

Lesson: when the future Doccer harness is activated, its strict audit must be called from the actual
repository gate. Until then, do not build elaborate local CI machinery whose enforcement status is
ambiguous.

### 3.9 Moving modules made references decay

The intended invariant was that declaration names remain stable on promotion. Module paths do not:
moving a file from `Enthymemes` to `Lemmas` changes imports, aggregate membership, and prose links.
Current comments already refer to a `Lemmas.PKWang` destination that has not landed.

Lesson: use stable module paths and promote a ledger status, or make the move completely mechanical
and validate every reference. Doccer should prefer the former.

### 3.10 Broad imports make a speculative lane expensive

Several files import all of Mathlib, and the README records an approximately eight-minute cold
elaboration cost. That may be justified for analysis-heavy ThermoMapper results; Doccer's first
finite-order and relation proofs should require much narrower imports.

Lesson: pin the toolchain only when the first obligation is selected, use the smallest imports that
support it, and keep cache/bootstrap cost out of ordinary C# work.

## 4. Enhanced Doccer harness design, when activated

### 4.1 Keep proof status in a ledger, not in a file move

A small future layout is enough:

~~~text
lean/
  README.md
  lean-toolchain
  lakefile.toml
  obligations.md                 human-readable canon
  Doccer/
    Model/                       definitions; no sorry, no project axioms
    Obligations/                 stable theorem modules
    Oracles/                     executable finite models
  DoccerAll.lean                 every registered module
  DoccerChecked.lean             only obligations accepted as proved/certified
  scripts/check.ps1
~~~

An obligation module stays at one path. Promotion updates its proof and ledger status; it does not
move the module. `DoccerAll` proves that every registered source elaborates. `DoccerChecked` is the
consumer-safe aggregate. The checker refuses unregistered files, missing registered files, and a
checked theorem with unapproved assumptions.

Do not create this layout until one obligation passes the activation gate.

### 4.2 Give every obligation an operational identity

The initial ledger may remain Markdown. Each record should contain:

| Field | Meaning |
| --- | --- |
| ID | Stable name such as `DOC-ORIGIN-003` |
| Claim | Quantified mathematical statement in prose |
| Carrier | Exact Doccer sort and basis assumptions |
| Implementation consequence | API, invariant, optimization, or refusal affected |
| Status | proposed · compiling · proved · finite-certified · external · withdrawn |
| Assurance | Lean · exhaustive oracle · C# property · counterexample · citation · policy |
| Assumptions | Standard, external, classical, decidability, finiteness, injectivity, etc. |
| Artifact | Lean declaration, generator, test, or cited theorem |
| C# correspondence | Public member and contract-harness law |
| Reactivation trigger | Concrete implementation event that makes stronger evidence necessary |

This is the law registry promised by K0. Most rows need never acquire a Lean artifact.

### 4.3 Separate model definitions, external hypotheses, and proofs

- `Model/` contains the smallest mathematical representation of the C# carrier, independently
  written rather than transliterated from implementation control flow.
- Missing constructions never receive sorried definitions.
- Deep cited results appear as theorem parameters where practical. If a project axiom is necessary,
  it lives under an unmistakable `Doccer.External` namespace with a citation and ledger entry.
- Every checked declaration receives an assumption report. Ordinary Lean foundations and approved
  external inputs are distinguished.
- No generated C# and no runtime dependency on Lean belongs in the bootstrap.

### 4.4 Make the first gate boring and total

The future checker should, in one run:

1. validate directory and filename casing;
2. compare the ledger, disk files, `DoccerAll`, and `DoccerChecked`;
3. compile all registered modules;
4. reject `sorry` in model or checked modules;
5. report apologies per declaration in compiling modules;
6. report axioms for checked declarations against an allowlist;
7. validate obligation-to-C# links;
8. run from the repository's real CI entry point.

The empty harness must pass. A compiling but unfinished obligation may make `DoccerAll` green while
remaining absent from `DoccerChecked`.

## 5. Burden-of-proof activation gate

Lean work begins only when a named obligation meets at least one of these conditions:

1. **Signature pressure:** whether the claim is true changes a public carrier, operator, result
   type, direction, identity, or compatibility check.
2. **Optimization pressure:** an index, packed representation, incremental algorithm, compression,
   stage fusion, or compiled backend relies on semantic equivalence with the reference model.
3. **Boundary pressure:** exact equality versus one-way inclusion, functional versus
   relation-valued behavior, or canonical versus merely deterministic output remains genuinely
   uncertain after a counterexample search.
4. **Global guarantee pressure:** Doccer is about to promise completeness, confluence,
   associativity of evidence-bearing structures, order independence, or a universal bound that
   finite testing cannot establish.
5. **Novelty pressure:** the multi-source origin/support construction has no sufficiently close
   external theorem and its law is load-bearing for materialization.

Lean does **not** activate merely because:

- a finite table can be regenerated exhaustively;
- the claim is standard relation or finite-set algebra;
- an executable counterexample already fixes the contract boundary;
- the operation is a caller-selected policy rather than algebra;
- formalization would be intellectually tidy but would not change implementation or assurance.

Before starting, the chip brief must say which activation condition applies and what decision the
proof can change. If the answer is "none," retain the obligation in the ledger.

### 5.1 D29 gate application — exact pairs to qualitative Allen composition

D29 identifies a genuine cross-carrier obligation:

\[
\alpha(\operatorname{ComposePairs}(R,S))
\subseteq
\alpha(R)\mathbin{\operatorname{AllenCompose}}\alpha(S),
\]

where \(R\) and \(S\) are exact pair relations over an identical middle batch and \(\alpha\)
collects the Allen relations realized by actual edges. This is not equality and does not license
qualitative table cells to create exact pair edges.

The obligation does **not** activate Lean for the reference K2b chip:

- signature pressure is absent: the direction and exact middle-basis hypothesis are now frozen;
- boundary pressure is resolved: loss of middle-identity correlation and the adjacent-gap
  counterexample both refute the converse;
- the proof is a direct witness chase over standard finite relation composition;
- D28 already supplies independent atomic-triad assurance;
- a direct reference `ComposePairs`, independent nested relation oracle, and C# property tests can
  expose mistakes in Doccer's basis and occurrence plumbing.

Record it as an executable/refinement obligation now. Reapply **optimization pressure** before a
compressed, indexed, incremental, or independently implemented pair backend uses qualitative
summaries to omit exact work and claims universal no-false-negative equivalence. Reapply
**signature or boundary pressure** if equality replaces inclusion, the exact middle-basis
hypothesis changes, or `AllenImage` becomes a generalized public abstraction. At either event,
the small Lean theorem can license an implementation decision rather than merely restate the
reference behavior.

D31 has now discharged the reference-side burden exactly as planned. The implementation is a
direct middle-ordinal join, differential-checked across all 256 bounded relation compositions and
4,096 associative triples; all 3,375 six-boundary middle paths satisfy the atomic bridge before
the union-level inclusion is checked. Middle-correlation loss and the complete four-boundary
adjacent-gap carrier independently refute the converse. This evidence closes K2b without changing
the gate: Lean remains deferred until a different backend or stronger public claim makes the
theorem load-bearing.

D32 introduces no new Lean activation. Strict stack pairing is one finite deterministic scan, its
top-only mismatch behavior is frozen by the source witness, and an independent abstract oracle
agrees on all 5,461 two-key words through length six while direct checks cover the complete
match/residue partition and forward one-to-one noncrossing invariants. Reassess only before an
optimized, parallel, incremental, or recovery-bearing backend claims equivalence with this
reference policy; formalizing the lone implementation now would not choose or license a different
design.

### 5.2 D33 gate application — located closure and flat paths

D33 freezes the exact-window basis, the graph-to-geometry projection, and the distinction between
Boolean boundary reachability and identity-bearing graph paths. None activates Lean for the joint
K3/K4a reference chips:

- direct finite set/matrix semantics define `Seq` and consuming reachability;
- standard relation laws have an independent bounded C# oracle;
- `TextSlice` is the already-witnessed injective translation, and no generalized map API lands;
- parallel-edge collapse is an explicit projection counterexample, not an unresolved equivalence;
- `FirstOrdinalCompletePath` promises a deterministic complete witness when one exists, not an
  optimum.

Reapply **optimization/global-guarantee pressure** during K4b before a public best-cost,
maximum-weight, or optimized/reference-equivalence claim lands. Reapply **boundary pressure** if a
generalized map or objective algebra makes exact equality reusable. The policy's domain meaning and
tie preference remain outside theorem work.

### 5.3 D34 gate application — review corrections do not add theorem claims

D34 narrows identities, stability, and chip gates rather than strengthening a mathematical
guarantee:

- `CandidateRegionGraph` and its results use one exact frozen batch reference, while
  `LocatedRelation` uses compatible-master/equal-window geometry values; the explicit projection
  forgets identity by construction;
- first-ordinal path determinism is promised only on that exact occurrence basis, not under batch
  reconstruction or insertion reordering;
- located `CanSeq` is direct endpoint equality and deliberately admits diagonal empties, unlike
  Allen `Meets`;
- the joint-core and K4a-result chips have separate finite reference/oracle gates; and
- K4b and K4c are sibling lanes, so execution priority creates no proof obligation or abstraction
  theorem between them.

None crosses the burden gate. D39 later supplies K4c's executable policy/basis/selection stamps and
maximal-not-maximum counterexample without a formal optimality proof. Reapply the existing gate if
either sibling publishes another global optimum, generalized objective/carrier, or
optimized/reference equivalence.

### 5.4 D37 gate reapplication — one additive path optimum remains reference-owned

D37 fires the named K4b trigger by promising the global minimum nonnegative additive cost among
complete admissible paths. The gate is therefore reapplied rather than waved through as ordinary
policy choice. It still does not activate Lean:

- the carrier is the already finite, strictly consuming candidate DAG;
- the objective is one closed `Int64` sum with construction-time nonnegativity and total-sum
  bounds, not a generalized algebra or opaque whole-path callback;
- production is the direct descending-boundary Bellman recurrence and no second public backend
  claims equivalence; and
- an independent oracle enumerates complete paths for all 128 admissibility masks crossed with all
  128 binary cost tables (16,384 problems), checking both score and lexicographic tie outcome.

The public guarantee is consequently reference-owned by a transparent recurrence plus differential
evidence. Reactivate before another/optimized backend claims equivalence, signed or generalized
objectives become shared infrastructure, partial paths acquire a nontrivial guarantee, or K4c
attempts to reuse the recurrence as a cross-family theorem.

### 5.5 D39 gate reapplication — direct structural definitions remain executable

D39 reapplies the K4c gate across packing, total cover, laminar validation/admission, explicit and
nearest-container hierarchy, and resolution incidence/aggregation. It does not activate Lean:

- packing, cover, and laminarity are direct finite validators checked against independent pairwise,
  unit-cell, and alternating-endpoint predicates on all 1,024 bounded interval subsets;
- greedy laminar admission promises deterministic inclusion-maximality only, agrees with an
  independent oracle on 4,096 mask/priority problems, and carries an executable counterexample to
  maximum cardinality;
- hierarchy and resolution edges are explicit retained data, with 4,096 directed-graph and 2,048
  endpoint-mask checks rather than a closure, reduction, composition, or inferred-edge theorem;
  and
- nearest-container projection is one direct reference implementation over nonempty laminar
  occurrence groups with an explicit equal-geometry tie rule.

Reactivate before a global structural optimum, optimized/incremental validator, hierarchy
closure/reduction equivalence, resolution-map composition or coverage-preservation law, generalized
structural carrier, or cross-family selector makes one of these definitions load-bearing beyond its
direct implementation.

## 6. Current Doccer triage

| Obligation family | Best evidence now | Lean trigger later |
| --- | --- | --- |
| Allen classifier JEPD, converse, argument reversal | exhaustive finite C# classifier checks plus predicate review | only if a more general interval carrier is introduced |
| Canonical Allen weak-composition table | independent `D6` generator plus the published formalization | if Doccer attempts a generic qualitative-calculus proof API |
| Adjacent-gap failure of finite exact composition | smallest executable counterexample | none presently; the counterexample already fixes the contract |
| Exact claim-pair identity and associativity | D31 direct relation implementation, nested differential oracle, and all 4,096 bounded relation triples | if a packed witness representation inherits the same claim |
| Exact-pair Allen-image composition inclusion | D28 atomic-triad certificate plus D31 direct `ComposePairs`, 3,375 per-witness checks, union law, and two executable non-converses | before qualitative summaries drive optimized pruning with a universal no-false-negative claim, or if equality/generalized public abstraction is proposed |
| Witness-bearing composition | make no associativity promise yet | before normalization or bracket-independent evidence is promised |
| Strict stack match/residue partition and noncrossing | D32 direct scan, two concrete delimiter families, combined adversarial residue, and a 5,461-word independent bounded oracle | before an optimized/parallel/incremental implementation or a recovery policy claims equivalence |
| Located `Seq` identity, associativity, finite consuming closure, and exact slice rebase | D35 direct compatible-master/exact-window implementation; all 64 values, 4,096 compositions, and 262,144 triples on three boundaries; independent nested-pair/Floyd-Warshall oracles; exact rebase and test-only non-injective counterexample | before a compressed/incremental closure algorithm replaces it or a generalized map reopens the exact-versus-lax boundary |
| Flat graph reachability and identity-bearing reference path | D35–D36 close exact-batch graph/projection/result semantics, exact-basis ordinal determinism, a bounded independent path oracle, and parallel-edge/gap/dead-end/empty-window witnesses | before a packed/independent reachability backend claims equivalence, cross-batch invariance is proposed, or path preservation is generalized |
| Additive minimum-cost complete path | D37 direct descending-boundary DAG recurrence; nonnegative bounded `Int64` score domain; exact feasibility/objective/tie stamps; all 16,384 admissibility × binary-cost problems agree with independent complete-path enumeration | before another/optimized backend claims equivalence, signed/generalized objectives or nontrivial partial-path guarantees land, or cross-family reuse makes the recurrence load-bearing |
| K4c structural validation, explicit hierarchy/incidence, and greedy admission | D39 direct validators/relations; all 1,024 structural masks, 4,096 priority problems, valid bounded nearest-parent families, 4,096 directed graphs, and 2,048 resolution endpoint problems; explicit maximal-not-maximum and envelope-hole counterexamples | before a global optimum, optimized/incremental backend, hierarchy closure/reduction equivalence, resolution-map composition/coverage theorem, or generalized carrier |
| K5a canonical fact/support identity | D43 immutable reference construction, canonical-order/equality laws, adversarial exact-basis validation, proposal permutations, and a manually supplied two-support diamond | before an alternate, persisted, compressed, or incremental fact/support backend claims the same extensional identity without complete differential evidence |
| Positive finite saturation reaches one least fixed point | reference worklist plus order-permutation tests and standard theorem citation | before parallel/incremental saturation claims semantic equivalence |
| Direct-image maps are lax generally and exact under injectivity | encode the distinction in C# types/contracts and test counterexamples | if a generalized rebase/map API makes equality a reusable public law |
| Functional origins embed into relation-valued origins | reference relation tests | before origin compression, stage fusion, or functional fast paths |
| Multi-source origin composition | ordinary relational reference implementation first | leading future Lean candidate if K6/K7 semantics or optimization remain disputed |
| Output-piece partition and reconstruction | construction-time validation and adversarial tests | before fusing materialization stages or eliding intermediate masters |
| Linear-ET compilation | external equivalence theorem plus differential backend tests | before claiming evidence/origin-preserving fusion beyond the cited result |

This triage leaves no present theorem whose completion should block K5. D35–D36 close K3/K4a,
D37 closes the first K4b executor, and D39 closes K4c under finite reference assurance;
`AllenRelationSet`, `ClaimSelection`, `ClaimPairView`, and strict pairing were already landed.

## 7. Restart recipe

When an activation trigger fires:

1. Write one obligation record and a chip brief naming the implementation decision at stake.
2. Search for the smallest counterexample and the closest external theorem first.
3. Freeze the mathematical carrier independently of the C# representation.
4. Compile one statement with all hypotheses explicit; do not scaffold the whole inventory.
5. Add its C# reference law or differential fixture in the same chip.
6. Prove, weaken, or withdraw the claim.
7. Record the implementation consequence; promotion without a consequence is incomplete.
8. Expand the harness only when the second obligation demonstrates repeated infrastructure.

Likely first candidates, depending on which tranche supplies the trigger:

- K2 optimized pairs: exact-to-qualitative inclusion, if qualitative summaries become
  load-bearing for pruning or compression;
- K3 generalized maps: direct-image composition, lax generally and exact under injectivity;
- K4b alternate backends/objectives: recurrence equivalence or a generalized score algebra;
- K4c alternate backends/relations: structural optimum, hierarchy closure/reduction, or resolution
  composition and coverage preservation;
- K5 packed support: the exact equivalence relation required for bracket-independent witnesses;
- K6/K7 optimized origins: functional embedding and multi-stage relational composition.

The Allen classifier is intentionally not the default first proof. Its finite executable oracle is
cheaper, independent, and already sufficient to protect the initial implementation.

## 8. Done criteria for the eventual bootstrap chip

- Exactly one load-bearing obligation names the implementation decision it can change.
- The model contains no sorried definitions.
- The statement elaborates under a pinned toolchain and narrow imports.
- `DoccerAll` covers every registered source; `DoccerChecked` exposes only accepted results.
- The assumption report is explicit and approved.
- The corresponding C# reference law, oracle, or differential fixture is linked.
- The real repository gate runs the checker, including its empty and failure fixtures.
- No code generation, generic QSTR framework, or universal parser formalization is introduced.
- The roadmap records either the implementation change produced by the proof or the fact that the
  original contract survived it.

## 9. Deferred conclusion

ThermoMapper validates the *method*—formalization as a pressure test on load-bearing engineering—but
also shows that a proof harness has its own lifecycle cost and can accumulate misleading green
states. Doccer should keep the proof-obligation inventory now and defer the toolchain until a claim
crosses the burden gate.

The practical next step after D43 was K5a fact/support implementation, not Lean; that chip landed
2026-08-09 (harness 2091) with `K5-FACT-SUPPORT` owned by its direct construction, adversarial
validation, and proposal-permutation tests, exactly as registered. The first future proof
most likely to repay its cost is not a reproof of Allen's table, the unoptimized pair join, D35's
direct located closure, D37's sole additive recurrence, or D39's direct structural validators; it
is a law that licenses compression, pruning, generalized optimization, closure/composition, fusion,
or another independent backend without changing reference meaning. D29 names the pair-abstraction
candidate, D37 records the path trigger outcome, D39 records the structural outcome, and
origin/support machinery remains the other leading source.

## 2026-08-05 D40 gate reapplication

D40 splits K5a fact/support identity from K5b positive saturation and reapplies signature pressure
without activating Lean. The first implementation remains owned by a direct worklist,
order-permutation tests on the K4c diamond witness, and the standard finite monotone
least-fixed-point theorem under explicit hypotheses. K5a must make those hypotheses structural:
rules match present positive premises and propose additions, with no absence, deletion, winner, or
stage-order observation through arbitrary whole-store callbacks.

The then-open question was resolved by D43 below: K5a exposes no executable rule signature. K5b
reapplies this trigger when its positive rule carrier freezes. Activate if a proof can change that
carrier or later license parallel/incremental saturation; otherwise formalizing the sole direct
worklist would still add lifecycle cost without an implementation consequence.

## 2026-08-06 D42 V-lane and semantic-bitmap gate split

The round-two expansion adds a stronger future trigger to this restart packet. The
[source synthesis](../discussions/opus-doccer-expansion-round2.md) correctly notices that a
bitmap-backed `SpanSet` or D3 suppression query would promise equivalence between a packed
backend and an existing semantic reference over arbitrarily sized carriers. The
[D41 adjudication](sol-doccer-expansion-round2-adjudication-20260806_093159.md) correctly rejects
automatic activation merely because a bit carrier or second implementation exists. The
[material-basis/XOR inquiry](../discussions/sol-doccer-material-basis-and-public-composability-20260806_105530.md)
now supplies the missing reconciliation: separate the peer-carrier laws from the cross-carrier and
same-query equivalence laws.

The former single V0–V2 registry entry is split into five obligation families:

| Obligation | Reference claim | Present owner | Lean disposition |
|---|---|---|---|
| V0 vector carrier | basis/window/length identity, empties, compatibility, residual sort, and distinct direct/harvest exits | constructor laws, basis-refusal cases, and scalar reference values | statement/signature review at V0; no activation merely for minting the carrier |
| Prefix-scan refinement | pointwise XOR/parity, forward inclusive prefix parity, transitions, carry, logical tails, overlap rules, and chunk concatenation agree across implementations | per-bit V1 reference, exhaustive short laws, randomized chunk tests, and where applicable a complete linearity certificate | reapply at the public scan signature and for each V2/fused backend; activate if these executable methods cannot honestly own a universal claim |
| Harvest bridge | emitted offsets/spans/claims correspond to admitted set bits; scalar-boundary and classifier uncertainty become the declared residual rather than disappearing | direct reference harvest, reconstruction checks, boundary adversaries, and source-evidence validation | reapply if proof changes the result/residual signature or a fused path claims universal soundness/completeness |
| Packed `SpanSet` representation | point membership, normalization, and advertised Boolean operations are extensionally equal to the interval-list reference | existing `SpanSet` plus differential representation laws | presumptive optimization-pressure activation when an interchangeable arbitrary-master packed backend is proposed |
| D3 suppression bitmap | `Excluded` equals `Coverage(Q)` and `Admitted` equals its complement as `SpanSet` values for the same exact suppressor `ClaimSelection` \(Q\) | existing selection-backed suppression query plus differential region-equality laws | presumptive optimization-pressure activation when the bitmap becomes a second suppression implementation |

“Presumptive” does not bypass §5's decision procedure. The chip brief must still search for a
counterexample, a close external theorem, and a cheaper complete certificate. It means the
optimization-pressure condition is genuinely met once arbitrary-input interchangeability is
claimed; bounded examples alone cannot silently discharge it. If a fixed-width implementation is
linear, equality on zero and every basis vector may be a complete finite certificate and should be
compared with Lean before scaffolding. Ordinary random differential tests are corroboration, not
that certificate.

### Candidate theorem kernel

The mathematical model should be smaller than any runtime layout:

- a finite ordered Boolean sequence with logical length;
- forward inclusive scan with explicit carry-in/carry-out;
- adjacent transition/difference;
- a boundary-event lattice with \(n+1\) boundaries for \(n\) units;
- normalized finite regions and their point-membership predicate; and
- partial event information interpreted as the set of all Boolean completions.

The first useful statements are:

1. prefix/transition inversion;
2. scan concatenation and final-carry agreement;
3. word/backend refinement to the reference scan, including logical-tail independence;
4. residual soundness: every completion agrees with the reported result outside the propagated
   uncertainty;
5. boundary-event scan/harvest reconstruction for normalized regions;
6. packed-region extensional equality; and
7. suppression-bitmap equality to `Coverage(Q)`/complement for one exact suppressor
   selection.

The last two should not be forced into one theorem. Packed `SpanSet` equality is a
representation theorem within the geometry carrier. Suppression is a query-refinement theorem
from an exact occurrence selection to `Coverage()` or its complement. Its result is
geometry, but the claim-to-coverage projection still does not commute generally with symmetric
difference or restore occurrence identity.

Lean proves the algorithmic/model refinement, not the processor, JIT, or dispatch mechanism. The
activation chip must therefore link the theorem to C# fixtures that exercise actual intrinsics,
fallback selection, remainder units, aliasing, poisoned tails, and unsupported hardware.

### Updated activation result

- V0 still does not activate the harness automatically. It must perform a statement pass because
  direction, carry, residual meaning, and harvest shape can change the public signature.
- V1 remains independently implementable as the portable reference with executable assurance.
- V2 reapplies the gate per backend rather than once for “SIMD” in the abstract.
- A future packed `SpanSet` or suppression bitmap advertised as semantically
  interchangeable is now a leading first-proof candidate and should normally activate the
  smallest corresponding obligation chip.
- A peer vector consumed directly, or harvested through an explicitly different result sort,
  makes no same-carrier equivalence claim merely by existing.

The overall harness status remains **deferred**. No V backend, packed `SpanSet`, or
suppression bitmap has landed, so no present implementation decision requires the toolchain.
D42 updates the trigger inventory and registry before that pressure arrives; it does not insert
Lean into the K5/K6 queue.

## 2026-08-09 D43 K5a fact/support assurance split

D43 separates the former combined `K5-SATURATE` registry row into `K5-FACT-SUPPORT` and
`K5-SATURATE`. K5a freezes finite immutable values only: compatible-master fact-key equality,
canonical fact deduplication/order, exact fact-table and `SpanBatch` evidence bases, ordered
alternative supports, and an exact-table `FactReference` that does not retain a support graph.
It adds no rule carrier, worklist, or least-fixed-point claim.

The K5a burden is therefore owned by direct reference construction, immutable snapshots,
adversarial basis refusal, structural equality checks, and proposal-permutation tests. Its manual
hierarchy diamond supplies one ancestor fact with two support paths; it does not infer them. No
proof pressure can presently change this signature, so Lean remains deferred.

K5b separately owns positive rule execution, finite saturation, support completeness for derived
facts, and fair-order independence. Reapply the activation gate when that public rule signature
freezes. An arbitrary whole-store callback remains inadmissible because formalization cannot make
absence observation, deletion, winner selection, or stage-order dependence monotone after the
fact.
