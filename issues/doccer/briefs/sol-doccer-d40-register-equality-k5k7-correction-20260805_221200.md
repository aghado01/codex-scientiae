# Doccer D40 correction — codepoint registers, graph equality, and K5–K7 sibling lanes

Status before correction: D39 closes K4c with 1976 contract checks green. The post-K4 review in
[opus-doccer-k3k4-review-k5k7-notes](../discussions/opus-doccer-k3k4-review-k5k7-notes.md)
finds no algorithmic defect in K3/K4, but exposes one equality inconsistency and several stale or
conflated premises in the K5–K7 plan. This brief corrects those premises before K5 source work.

> **Supersession note (2026-08-09):** D43 and the
> [K5a contract brief](sol-doccer-k5a-contract-20260809_193131.md) supersede D40's provisional K5a
> carrier/reference shape and the K5a-attributed rule-signature and Lean-gate handoff in section 6.
> K5a now owns immutable canonical fact/support values and the narrow `FactReference` only; it
> exposes no executable rule carrier or fixed-point claim. A future K5b contract owns the positive
> rule signature, worklist, saturation semantics, executable diamond witness, and assurance-gate
> reapplication after the K5a source carriers land. D40 remains authoritative for its terminology
> correction, K4 equality correction, structurally positive K5b direction, and K5/K6/K7 sibling
> sequencing. Where the two briefs conflict on K5a or the K5b handoff, D43 controls.

## 1. Register is codepoint-address terminology; mathematics is a channel

MarkPig's historical `doccer/legwork` material used **Unicode register** natively for a named span
of codepoint addresses, or a named family of such spans. Its unified sweep classified character
atoms by locating their scalar values in registers under three UCD families:

~~~text
Block
Script
GeneralCategory
~~~

Its Tier-1 “register exclusivity” invariant meant that each character position receives exactly
one register value from each family. The old `SpanBatch` sketch consequently showed optional
`BlockIds`, `ScriptIds`, and `CategoryCodes`. A register is the codepoint-address object;
classification is the atom fact produced by membership in it. Neither meant a linguistic
register, a canonical math language, or a semantic-value namespace.

The archaeological trail is explicit: MarkPig's `VALIDATION-MATRIX.md` defines exclusivity as one
Block, Script, and Category per character; `SCHEMA.md` names `unicode_register` with a
`{ kind, name, range? }` record and those three optional result columns; and `UNIFIED-SWEEP.md`
calls block/script/category the Unicode register tags.

The application design currently stored under the legacy **math-register** name instead defines a
canonical mathematical manuscript language, including delimiter and spelling rules. Its preferred
canonical term is **math channel**: mathematics is one language channel interleaved with prose,
not a codepoint-address register. Existing repository paths retain the legacy name until that
separate migration lands. A math-channel adapter can consume Doccer primitives, but the channel is
not a Doccer register, fact ontology, or prerequisite.

D40 therefore reserves *register* in Doccer for codepoint-address semantics and uses *math channel*
for the canonical mathematical language:

- codepoint registers and the Unicode classifications derived from them stay in the independent
  F-UCD lane pending a pinned data-provenance and representation record;
- a channel's language or canonical-notation contract remains adapter data and policy;
- canonical semantic values belong at K5 fact grain; and
- occurrence metadata and derivation evidence do not silently enter canonical fact identity.

The old combined “register/value/metadata columns” question is split rather than answered with one
new `SpanBatch` column. The math channel creates no K5 dependency, and D40 does not pre-decide the
eventual F-UCD register carrier or serialization.

## 2. Candidate graphs are values on one exact occurrence basis

`CandidateRegionGraph.Equals` already means:

~~~text
same exact SpanBatch reference
+ same window
+ same candidate ordinal set
~~~

Before D40, `PartitionView`, segmentation internals, and path-selection construction nevertheless
used graph-object reference identity. Two graph values could compare equal while their otherwise
identical partitions compared unequal, and a policy built over one was refused by the other.

That additional wrapper identity carries no occurrence information: graph ordinals are assigned by
the exact `SpanBatch`, and graph equality does not admit a compatible-but-distinct batch. D40 makes
graph value equality the graph-basis compatibility relation throughout K4:

- views and results still retain the actual graph object supplied by their caller;
- partition equality/hash use graph value equality plus the ordered ordinal path;
- constructors accept a policy/view/partition stamped by an equal graph definition;
- a distinct or merely compatible source batch remains foreign; and
- policy objects, problems, and results retain their own exact object stamps where those objects
  carry snapshotted judgment or execution evidence.

This is a coherence correction to D34–D37, not a weakening across occurrence bases or the explicit
identity-forgetting projection to `LocatedRelation`.

## 3. K5 splits identity/support from saturation

K5 now has two chips:

~~~text
K5a  canonical fact identity + occurrence/support separation + narrow derivation reference
K5b  finite positive saturation over the K5a carriers
~~~

K5a must freeze the representation of an adapter-defined canonical value key, but it does not wait
for F-UCD codepoint-register data or the math channel. The governing separation remains:

~~~text
occurrence row       what evidence was observed, where, and by which producer
canonical fact       one identity per geometry + fact kind/domain + canonical value key
support edge         rule application + ordered premise fact IDs + occurrence evidence
metadata             evidence unless a named fact schema deliberately promotes it into value
~~~

K5b's public rule surface must make positivity and monotonicity structural. A rule may match named
positive premises and propose facts/support; it may not inspect absence, delete facts, select a
winner, or observe stage order through an arbitrary whole-store callback while claiming order
independence.

### Bounded K5 witness

Use a four-node diamond from K4c's explicit hierarchy surface:

~~~text
a -> b -> d
 \-> c ->/
~~~

An adapter supplies positive `Parent => Ancestor` and transitive-ancestor rules. `Ancestor(a,d)` is
one canonical fact reached through two premise paths; saturation must retain two support edges
without duplicating the fact. Permuting rule and seed order must produce the same fact set. The
witness exercises fact deduplication, alternative support, fixed-point termination, and
rule-order independence without donating hierarchy semantics to the kernel.

## 4. K5 and K6 are siblings; K7 has only a narrow K5a seam

The former K5→K6 arrow was not a type dependency. Origins answer **where output material came
from**; support answers **why a fact or choice exists**. K6 can be designed from the selected output
pieces already supplied by K4b while K5 proceeds independently.

~~~text
K2/K4a -> K5a -> K5b
K4b ----------> K6 -> K7
K5a ----------------> K7   optional derivation-reference seam only
~~~

Full K5 saturation is not a prerequisite for K6 or `Materialize`. K7 may retain an optional narrow
derivation reference defined at K5a grain; it must not require a support graph to realize a plan.

## 5. K6 identity and empty-material posture

Origins are identity-bearing lineage, not geometry alone. K6 must introduce or name an exact
`OriginBasis`-style stamp containing ordered, tagged source slots. Two source slots may reference
value-compatible text while remaining different provenance identities.

- origin construction may use `TextMaster.IsCompatibleWith` to validate coordinates;
- identity-forgetting geometric projections may use compatible masters explicitly;
- `ComposeOrigins` requires the exact tagged middle origin basis/stage identity; and
- value-compatible text never substitutes source-slot identity implicitly.

K6/K7 do not reopen the nonempty-claim contract. Generated material has positive output extent;
deletion is absence or named plan residue; an empty output master has zero pieces. Synthetic or
deleted material is never represented as a zero-width `SpanBatch` claim, so K4 hierarchy and graph
algorithms continue to inherit nonempty claims from their exact occurrence basis.

## 6. Lean gate disposition

D40 reapplies the burden gate without activating Lean. Finite positive saturation has a standard
least-fixed-point argument, and the first implementation remains a direct worklist with
order-permutation C# tests plus an explicit external theorem and hypotheses. Formalization cannot
repair an API that admits nonmonotone callbacks; K5a must first make the rule restriction true by
construction.

Reapply at the K5a contract freeze because signature pressure is possible: if the public rule
surface cannot express and enforce the hypotheses needed for K5b's order-independence promise,
restrict the signature or weaken the promise before source work. Activate Lean when that proof can
choose the public rule carrier, or later when parallel/incremental saturation claims semantic
equivalence.

## 7. D40 landing gate

- remove the legacy math-register dependency, restore historical Tier-1 “register” to its
  codepoint-address meaning, and adopt math channel for the canonical mathematical language;
- migrate graph-basis compatibility and partition equality to `CandidateRegionGraph.Equals`
  without weakening exact `SpanBatch` identity;
- split K5a identity/support from K5b saturation and name the diamond witness;
- remove K5→K6, retain only the optional K5a→K7 derivation-reference seam;
- freeze K6 tagged-origin-basis strictness and K6/K7 nonempty-material posture;
- record the deferred Lean disposition and K5a reapplication condition; and
- align decisions, roadmap, workplan, ledger, README, prior affected briefs, source tests, and the
  delivered package.

No K5, K6, K7, F-UCD, persistence, adapter, math-channel source surface, or legacy-path rename
lands in D40.

## 8. Implementation report

Completed 2026-08-05 as D40. The living canon now reserves **register** for Doccer's historical
codepoint-address meaning, calls the resulting atom assignments **Unicode classifications**, and
uses **math channel** for the unrelated canonical mathematical language. Existing `math-register`
repository paths are legacy naming pending a separate migration. The stale combined blocker is
removed; K5a/K5b, the hierarchy-diamond witness, the K5/K6 sibling split, the optional K5a→K7 seam,
exact tagged origin basis, nonempty output material, and Lean reapplication posture are aligned
across decisions, roadmap, workplan, ledger, README, and the affected historical briefs.

The bounded K4 correction updates `PartitionView` equality/hash and segmentation/path graph checks
to use `CandidateRegionGraph.Equals`. Direct tests now accept partitions and policies built over an
equal graph definition while continuing to refuse another exact-batch basis. Policy, problem, and
result objects still retain their supplied evidence-bearing references. No public type was added or
removed.

The Doccer build completes with zero warnings and the contract harness remains **1976 checks
passed**. D40 closes the correction; K5a contract work is the default next chip and K6 contract
work is an independently available sibling.

## 9. Terminology amendment

D40 initially overcorrected the namespace collision by describing register as non-native to
Doccer. The project owner clarified immediately after landing that a register was originally a
native codepoint-address concept: distinct spans in the codepoint space. This amendment restores
that meaning and adopts math channel as the preferred term for the mathematical language. D40's
K4 equality correction and K5–K7 dependency decisions are unchanged.
