# Doccer K5b contract — finite positive ground saturation

Runstamp 20260809_215158. **Status: implemented; K5b closed; harness 2091→2324.**

This brief supersedes the provisional K5b rule-carrier and saturation language in the
[D40 correction](sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md) and the K5b
handoff in the
[D43 K5a contract](sol-doccer-k5a-contract-20260809_193131.md). It does not reopen K5a identity,
support, or `FactReference`. K5b remains a sibling of K6 and is not a prerequisite for K7.

Inputs:

- the implemented D43 carriers under `src/doccer/Facts/`;
- the [decision canon](../planning/decisions.md), especially D40 and D43;
- the [architectural expansion workplan](../planning/architecture-expansion-workplan.md);
- the [deferred Lean packet](sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md); and
- the K4c hierarchy diamond retained by the
  [structural contract](sol-doccer-k4c-structural-contract-20260805_194514.md).

## 1. Disposition

K5b is a finite positive closure engine over the landed K5a semantic values. Its public rule
carrier is a finite immutable set of **ground rules**, not a callback over an evolving store and
not a variable-bearing rule language.

~~~text
GroundRule          one finite positive implication stated entirely in FactKey values
SaturationProblem   exact initial SupportHypergraph + canonical finite GroundRule set
SaturationResult    exact problem stamp + newly frozen result SupportHypergraph
FactSaturation      static owner of Saturate(problem)
~~~

An adapter may match variables, evaluate guards, or compile a domain rule outside K5b, but the
kernel receives the resulting finite ground implications. That boundary makes positivity,
finiteness, and store independence true by construction while deferring a reusable schema or rule
IR until at least two adapters demonstrate the same vocabulary.

## 2. Ground rule value

`GroundRule` is an immutable value with:

~~~text
GroundRule
  required conclusion FactKey
  required ordinal rule ID
  immutable ordered premise FactKey tuple
  immutable ordered non-null parameter-string tuple
  immutable ordered non-negative occurrence-ordinal tuple
~~~

Every key and sequence element is non-null. Premise order and duplicates are significant evidence.
A duplicate premise does not consume a second resource: a rule is enabled when every premise
position names a fact present in the reached set. The empty premise tuple is a zero-arity rule and
is enabled at the initial step.

Rule ID, parameters, and occurrences do not affect enablement. They distinguish support evidence.
Two ground rules with the same premise and conclusion keys but different rule IDs, parameters, or
occurrence tuples remain alternative supports. Exact duplicate ground rules collapse.

Ground-rule equality and canonical order compare conclusion key, ordinal rule ID, ordered premise
keys, ordered parameters, and ordered occurrence ordinals. The key order is D43's representational
`FactKey` order and carries no semantic priority.

`GroundRule` is already grounded. It contains no variables, matcher, guard, delegate, access to the
current fact store, or method that can emit further proposals. Adapter-side compilation is outside
the fixed-point claim.

## 3. Problem basis and finite universe

`SaturationProblem.Create(initial, rules)` retains the exact supplied `SupportHypergraph` as its
initial evidence basis and snapshots the finite ground-rule sequence. Consequently it also retains:

- the initial graph's exact `CanonicalFactTable`;
- the initial graph's exact compatible-master `SpanBatch`; and
- the initial graph's supplied support edges.

All facts in the initial table are initial facts whether or not they have support. Existing support
edges are evidence to preserve, not rules to execute. A zero-premise `GroundRule` is different: it
is executable and contributes a new support edge when enabled.

Problem construction validates every premise and conclusion geometry against the initial table's
master and every occurrence ordinal against the exact retained `SpanBatch`. It canonicalizes and
deduplicates ground rules independently of supply order. It does not require premise or conclusion
keys to exist in the initial fact table.

For one problem, the finite candidate universe is derived rather than separately configured:

\[
U = F_0 \cup
    \{\operatorname{conclusion}(r) \mid r\in R\} \cup
    \{p \mid r\in R,\ p\in\operatorname{premises}(r)\}.
\]

Here `F0` is the initial table's semantic `FactKey` set and `R` is the snapshotted finite rule set.
Rules cannot create fresh keys outside `U` because their conclusions are already ground values.
A key appearing only in a disabled rule is part of the candidate universe but not automatically a
member of the result.

## 4. Positive closure semantics

For `X` contained in `U`, define:

\[
T(X) = X \cup
  \{\operatorname{conclusion}(r) \mid
    r\in R \land \operatorname{premises}(r)\subseteq X\}.
\]

Tuple inclusion here means that every ordered premise position names a value in `X`; it does not
erase the tuple retained later as evidence. `T` is inflationary and monotone. K5b returns the least
fixed point above the initial facts:

\[
F^* = \operatorname{lfp}_{F_0}(T).
\]

Because `U` is finite, closure terminates after at most \(|U \setminus F_0|\) strict fact additions. A fair
agenda schedule and direct repeated scanning therefore reach the same `F*`. Rule order, initial
fact proposal order, initial support order, and worklist insertion order are not semantic.

K5b makes no claim about how long adapter-side grounding takes. Its termination claim begins only
after `SaturationProblem.Create` has received a finite rule sequence.

## 5. Complete support semantics

Support completeness is defined from the final fact closure rather than from whichever derivation
happened to discover a fact first. Let `rebase(E0, F*)` project every initial support ordinal to its
initial `FactKey` and then resolve that key in the final canonical table. The result edge set is:

\[
E^* = \operatorname{rebase}(E_0,F^*) \cup
  \{\operatorname{edge}(r,F^*) \mid
    r\in R \land \operatorname{premises}(r)\subseteq F^*\}.
\]

`edge(r,F*)` resolves the rule's conclusion and ordered premise keys to final table-local ordinals
and copies its rule ID, parameters, and occurrence ordinals unchanged. Therefore:

- every fact in \(F^* \setminus F_0\) has at least one enabled-rule support edge;
- initial facts may remain unsupported;
- every enabled ground rule contributes support even when its conclusion was initial or reached
  earlier through another rule;
- exact duplicate supports collapse while every distinct alternative remains; and
- support completeness is independent of worklist order.

An unseeded cycle derives nothing. A cycle reached from an initial or zero-arity fact contributes
its finite enabled edges. A self-rule contributes an edge only when its premise fact is reached.
K5b retains the finite cyclic hypergraph; it does not unfold proof trees.

K5b's soundness is relative to the admitted problem: every derived fact corresponds to a supplied
ground rule whose premises are reached. Doccer does not certify that an adapter grounded its domain
rule correctly or that the rule describes a true domain implication.

## 6. Canonical freeze and exact identity

Worklist membership is semantic `FactKey` value, never a provisional or final fact ordinal.
Canonical ordinals can shift whenever a newly reached key sorts before an existing row, as the D43
harness already demonstrates.

`FactSaturation.Saturate(problem)` therefore uses two semantic phases:

1. compute `F*` and the enabled ground-rule set in key space; then
2. create a new `CanonicalFactTable`, resolve every initial and derived support through that final
   table, and create a new `SupportHypergraph` over the problem's same exact occurrence batch.

The operation never mutates or extends the initial table or graph. It always returns a newly frozen
fact table and support graph, including for a semantic no-op. Existing `FactReference` values remain
valid only for their original exact table and are never rebound. A caller that needs a result-table
reference explicitly looks up the semantic key and constructs a new `FactReference`.

`SaturationResult` retains the exact `SaturationProblem` reference and the result
`SupportHypergraph`; its fact table is the graph's exact `Facts` value. No iteration count, queue
order, first-derivation marker, or scheduler trace is semantic result evidence.

## 7. Bounded executable witness

Use the K4c four-node hierarchy diamond:

~~~text
a -> b -> d
 \-> c ->/
~~~

The initial graph contains four unsupported `Parent` facts. A finite adapter fixture supplies four
ground `parent-is-ancestor` rules and two ground `ancestor-parent-transitive` rules:

~~~text
Parent(a,b)                         => Ancestor(a,b)
Parent(b,d)                         => Ancestor(b,d)
Parent(a,c)                         => Ancestor(a,c)
Parent(c,d)                         => Ancestor(c,d)
Ancestor(a,b), Parent(b,d)          => Ancestor(a,d)
Ancestor(a,c), Parent(c,d)          => Ancestor(a,d)
~~~

The result contains four Parent facts, five Ancestor facts, and six rule support edges.
`Ancestor(a,d)` is one canonical fact with two ordered alternative supports. Rule, initial-fact,
and initial-support permutations must produce the same canonical fact and edge sequences.

This is the executable counterpart of K5a's manually supplied diamond. Hierarchy semantics remain
fixture-owned; Doccer sees only finite ground implications.

## 8. Implementation and assurance gate

The reference implementation belongs under `src/doccer/Facts/` and has no performance contract. A
direct agenda/worklist implementation is checked against an independently written repeated-scan or
powerset closure oracle.

The implementation chip must cover:

- construction refusal for a null initial graph or rule/sequence elements, blank rule IDs, invalid
  geometry, and negative or out-of-basis occurrence ordinals;
- snapshot behavior for every caller-owned sequence;
- exact duplicate rule collapse and preservation of every rule/parameter/occurrence distinction;
- the empty problem, unsupported initial facts, zero-premise rules, duplicate premises, self-rules,
  reachable cycles, and unreachable cycles;
- a key-order-shift adversary proving that initial and derived supports remap through semantic keys;
- enabled-support completeness even when the conclusion was reached earlier;
- rule, seed, and support permutations;
- the executable hierarchy diamond; and
- an exhaustive small finite program census against an independent closure/support oracle.

The `K5-SATURATE` Lean gate is reapplied and discharged without activation. The public carrier is
finite data and its operator is structurally positive; the standard finite monotone fixed-point
argument cannot presently choose a different signature. Direct reference C#, the independent
bounded oracle, permutation tests, and the explicit theorem above own the first implementation.

Reapply before a parallel, incremental, compressed, or alternate saturation backend claims the
same fact and complete-support result, or before a variable-bearing/callback rule carrier claims
the same termination or order-independence theorem. A future compiler from a schema language to
`GroundRule` has its own soundness obligation and does not silently inherit K5b's claim.

## 9. Explicit non-goals

K5b does not add:

- a variable-bearing Horn/Datalog grammar, unification, pattern matcher, or guard language;
- an arbitrary delegate or whole-store callback;
- negation, absence tests, deletion, aggregation, winner selection, priority, or stage observation;
- fresh identifiers, function terms, or conclusions outside the finite ground-rule universe;
- agenda order, first derivation, or iteration count as semantic evidence;
- proof-tree unfolding, a selected proof path, semiring evaluation, or `SupportReference`;
- incremental, streaming, parallel, persisted, distributed, or multi-batch saturation;
- persisted fact/rule IDs or a wire format;
- K6 origin semantics, K7 materialization, or a K5b dependency for either; or
- a correctness claim for adapter-side rule grounding.

Selected/nonmonotone results may seed a later `SaturationProblem`, but no least-fixed-point claim
crosses that orchestration boundary.

## 10. Landing gate and handoff

The contract-only chip closed when D44, the assurance registry, workplan, roadmap, ledger, engine
README, D40 supersession note, and deferred Lean packet agreed. Its harness remained at 2091
because no K5b source surface landed in that chip.

The following implementation chip owns `GroundRule`, `SaturationProblem`, `SaturationResult`,
`FactSaturation.Saturate`, and the bounded witness. K6 remains independently available throughout.

## Implementation report (2026-08-09)

The D44 surface lands in `src/doccer/Facts/Saturation.cs`:

- `GroundRule` is a sealed immutable value with a required conclusion and ordinal rule ID plus
  snapshotted ordered premise, parameter, and occurrence tuples. Its equality, hash, and internal
  canonical comparison cover every evidence distinction; construction rejects null keys and
  sequence elements, blank IDs, and negative occurrences.
- `SaturationProblem.Create` retains the exact initial `SupportHypergraph`, validates every
  rule-named geometry and exact-batch occurrence ordinal, then snapshots, canonically orders, and
  deduplicates the finite rule sequence. Missing premise and conclusion keys remain legal members
  of the derived candidate universe rather than implicit initial facts.
- `FactSaturation.Saturate` uses a semantic-`FactKey` agenda to compute the least positive closure.
  It then independently enumerates every rule enabled by the final closure, creates a new
  `CanonicalFactTable`, remaps initial and rule evidence through keys, and freezes a new
  `SupportHypergraph` over the problem's same exact `SpanBatch`.
- `SaturationResult` has nonpublic construction and retains the exact problem reference, result
  graph, and that graph's exact fact table. It exposes no scheduler trace or first-derivation data.

The harness covers the full §8 gate: constructor refusals and immutable snapshots; exact rule and
support collapse with every distinction axis retained; empty/no-op freezing; unsupported seeds;
zero-arity and duplicate-premise rules; enabled self-rules, reached cycles, and unseeded cycles;
disabled universe keys; support for initial and previously reached conclusions; initial-edge
rebasing under a canonical-key order shift; exact `FactReference` non-rebinding; all 24 seed ×
initial-support × rule permutations; and the executable hierarchy diamond with four Parent facts,
five Ancestor facts, six enabled supports, and two alternatives for `Ancestor(a,d)`.

An independently written powerset closed-superset oracle exhausts all 256 programs formed from
the four seed sets and all subsets of the complete two-fact zero/unary ground-rule vocabulary. It
checks both least closure and the final enabled-support set against the worklist result. Harness
2091→2324 with zero build warnings. The delivered-payload smoke gate now requires every named K5a
and K5b carrier to remain public and checks the K5b constructor/property and static
`SaturationProblem.Create`/`FactSaturation.Saturate` entry-point shape.

No non-goal was touched: no variables, callbacks, guards, negation, deletion, aggregation,
priority, proof-tree unfolding, schema compiler, persistence, alternate backend, or Lean
activation landed. D44 and `K5-SATURATE` are marked implemented; K5b is closed and K6 becomes the
default K execution lane.
