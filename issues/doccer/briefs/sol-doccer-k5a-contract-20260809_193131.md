# Doccer K5a contract — canonical facts and support identity

Runstamp 20260809_193131. **Status: contract frozen as D43; source implementation pending.**

This brief supersedes the provisional K5a carrier and assurance language in the
[D40 correction](sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md) and the
pre-D43 K5a workplan. D40's K5/K6 sibling sequencing remains in force. D43 narrows K5a to immutable
fact canonicalization and support evidence; K5b alone owns executable rules, worklist scheduling,
and least-fixed-point claims.

Inputs:

- [decision canon](../planning/decisions.md), especially D25 and D40;
- [architectural expansion workplan](../planning/architecture-expansion-workplan.md);
- [formalization audit](../discussions/sol-doccer-formalization-audit-and-lean-obligations-20260803.md);
- [compositional-kernel formalism review](../discussions/sol-doccer-compositional-kernel-and-formalisms-20260804.md);
- [K4c structural contract](sol-doccer-k4c-structural-contract-20260805_194514.md); and
- [deferred Lean restart packet](sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md).

## 1. Disposition

K5a introduces four distinct values:

~~~text
SpanBatch             existing exact occurrence table
CanonicalFactTable    one semantic fact per master-relative FactKey
SupportHypergraph     alternative and joint support over one exact fact/occurrence basis
FactReference         exact fact-table identity retained without a support graph
~~~

K5a adds no rule carrier and no `Saturate` implementation. A support edge is immutable supplied
evidence, not an executable callback and not a claim that Doccer has verified the adapter's domain
reasoning. K5b will later define positive rule execution over these values.

The existing `SpanBatch` is the claim-occurrence table. K5a does not duplicate its ordinals,
producer metadata, or immutable ownership in a new `ClaimOccurrenceTable` type.

## 2. Fact-key identity

One master-relative semantic key has this shape:

~~~text
FactKey
  domain       required ordinal string
  kind         required ordinal string
  geometry     immutable ordered tuple of TextSpan
  value key    immutable ordered tuple of non-null strings
~~~

The identity law is:

~~~text
semantic fact identity = compatible TextMaster value + FactKey value
~~~

`domain` names the adapter-owned semantic namespace and carries any schema/version distinction
required to interpret the value components. `kind` names the fact within that domain. Doccer uses
exact ordinal string equality and performs no Unicode normalization, case folding, culture-sensitive
comparison, or adapter-value parsing.

The value key is an ordered string tuple rather than an arbitrary object, injected comparer,
unframed composite string, JSON payload, or byte encoding. The tuple supplies framing without
freezing F2 persistence or CLI wire conventions. The empty tuple is the unit/no-payload key.
Adapters own canonical, culture-independent construction of each component.

Geometry is an ordered tuple because predicate argument positions are significant and the first
Parent/Ancestor witness is already binary. Geometry is not normalized as a `SpanSet`; order and
duplicates remain visible. Zero geometry arguments are admitted for master-global facts. Each
extent is validated on the retained master and may be empty because facts may describe boundaries
or epsilon-like items; this does not admit zero-width `SpanClaim` occurrences.

`SpanRecord.Source`, `Priority`, `Level`, collected `RuleId`, and other producer metadata remain
occurrence/support evidence. They enter fact identity only when an adapter deliberately promotes a
value into the named domain's fact key.

## 3. Canonical fact table

`CanonicalFactTable` retains one `TextMaster` and one row per distinct `FactKey`. Construction
snapshots every supplied sequence, validates all geometry, and collapses exact duplicate keys.

Canonical enumeration is independent of proposal order. The total order is domain, kind, geometry
arity and ordered `(Start, End)` coordinates, then value arity and ordinal string components.
This order is representational, not semantic priority.

Two fact tables are value-equal when their masters are compatible and their canonical key
sequences are equal. Adding unrelated facts may change table-local ordinals; no ordinal is a
durable or cross-table identifier. F2 owns any persisted fact identity.

`FactReference` is the exact evidence handle:

~~~text
FactReference = exact CanonicalFactTable reference + validated fact ordinal
~~~

Two value-equal but separately constructed tables do not make their references interchangeable.
The referenced `FactKey` is the explicit projection back to semantic identity, analogous to the
existing distinction between exact occurrence identity and identity-forgetting geometry.

## 4. Support hypergraph

One `SupportHypergraph` retains:

- one exact `CanonicalFactTable` reference;
- one exact frozen `SpanBatch` occurrence basis whose master is compatible with the fact master;
  and
- an immutable set of structurally validated support edges.

A fact table is independently usable and a fact may have no support edge. Constructing a support
graph does not retroactively make support part of fact identity.

The first public basis deliberately admits one occurrence batch. Current collection already
supports multiple producers through occurrence metadata, and every K2/K4 witness supplies one
exact batch. A future tagged multi-batch support basis requires a named composition witness; K5a
does not pre-empt K6's distinct tagged-origin design.

One support edge retains:

~~~text
SupportEdge
  conclusion fact ordinal
  required rule ID
  ordered premise fact ordinals
  ordered parameter strings
  ordered originating occurrence ordinals
~~~

All fact and occurrence ordinals are validated against the retained exact bases. Inputs are
snapshotted. Premise, parameter, and occurrence order is significant and duplicates are preserved
inside one edge. An exact duplicate edge collapses; a different rule, premise path, parameter
tuple, or occurrence tuple remains an alternative support for the same conclusion.

Empty-premise and empty-occurrence edges are admitted as named zero-arity seeds. Cycles and
self-support are representable because recursive fixed-point provenance is a hypergraph, not
necessarily a proof tree. K5a promises structural well-formedness only. K5b must ensure every fact
it derives has a support produced by its admitted positive rule execution.

Semiring provenance remains a later evaluated/quotiented view. It cannot replace the primary
hypergraph because ordinary commutative annotations discard rule identity and premise order.

## 5. K7 seam

K7's optional narrow derivation seam is a `FactReference`, not a support-edge reference. An output
piece may retain the exact canonical fact that justified it without retaining or selecting among
the fact's alternative supports. `Materialize` does not inspect a support graph to realize a plan.

A future exact proof-path requirement must introduce a separately named `SupportReference`. It may
not silently widen `FactReference` or make K7 depend on K5b saturation.

## 6. Assurance split and Lean disposition

D43 replaces the combined registry row with two obligations:

| ID | Owner now | Activation boundary |
|---|---|---|
| `K5-FACT-SUPPORT` | direct immutable construction, adversarial validation, value/equality laws, and proposal-permutation tests | alternate, persisted, compressed, or incremental fact/support storage claims the same extensional identity without complete differential evidence |
| `K5-SATURATE` | K5b reference worklist, rule/seed permutations, the standard finite monotone fixed-point theorem, and the hierarchy diamond | a proof can change the K5b public rule carrier, or a parallel/incremental backend claims semantic equivalence |

The D40 signature-pressure reapplication is discharged without activating Lean. K5a exposes no
executable rule signature and makes no least-fixed-point claim. K5b must reapply the gate when its
positive rule carrier freezes. An arbitrary whole-store callback that can observe absence, delete,
select winners, or inspect stage order cannot satisfy `K5-SATURATE`.

## 7. Bounded K5a witness

Use the K4c four-node hierarchy diamond, but supply the conclusion and its support paths directly:

~~~text
a -> b -> d
 \-> c ->/
~~~

The K5a witness constructs four Parent facts and one `Ancestor(a,d)` fact. Two supplied support
edges for the ancestor retain the ordered paths through `b` and `c`. This establishes identity and
evidence behavior without performing saturation. K5b later derives the same result under seed and
rule permutations.

The implementation gate must additionally cover:

- empty and nonempty tables, zero-geometry facts, and empty located extents;
- duplicate fact proposals collapsing under every proposal permutation;
- distinctions caused by domain, kind, geometry arity/order/value, and value-key arity/components;
- compatible-master value equality and incompatible-master refusal;
- exact fact-table and occurrence-batch reference boundaries;
- two alternative supports retained beside one conclusion and exact duplicate support collapse;
- empty-premise seeds, cyclic support representation, and stable canonical fact enumeration;
- missing conclusion/premise facts, invalid occurrence ordinals, and incompatible occurrence
  masters refused;
- caller-owned geometry, value, premise, parameter, and occurrence sequences snapshotted; and
- `FactReference` remaining valid and interpretable without a `SupportHypergraph`.

## 8. Explicit non-goals

K5a does not add:

- an executable rule abstraction, worklist, `Saturate`, or fixed-point result;
- negation, absence tests, deletion, winner selection, consolidation, or stage ordering;
- a generic semiring or weighted-proof API;
- a second claim-occurrence table or a tagged multi-batch occurrence basis;
- a persisted/global fact ID, JSON/binary wire format, or public private-layout contract;
- arbitrary object payloads, caller comparers, or engine-owned domain canonicalizers;
- support-graph acyclicity or adapter-semantic soundness claims;
- origins, correspondence, rewrite plans, or materialization; or
- F-UCD register data or a math-channel ontology.

## 9. Landing gate and handoff

The contract chip closes when D43, the assurance split, this workplan, the roadmap, ledger, engine
README, and deferred Lean packet agree. The harness remains at 1976 checks because no source
surface lands.

The following implementation chip owns the K5a C# values and bounded witness. K5b contract work
begins only after those carriers close; K6 remains independently available throughout.
