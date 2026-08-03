# Doccer formalization audit and Lean proof-obligation inventory

This is a companion to
[fable-doccer-formalizations-20260803.md](fable-doccer-formalizations-20260803.md)
and the kernel proposal in
[sol-doccer-expansion-deep-dive-20260802.md](sol-doccer-expansion-deep-dive-20260802.md).
It has two purposes:

1. distinguish exact formal identifications from restricted-fragment analogies and Doccer's own
   synthesis; and
2. identify the small mathematical claims that are worth treating as Lean "theory unit tests,"
   following the promotion pattern in
   [ThermoMapper's rigor harness](D:/aghado01/ThermoMapper/lean/README.md).

The main result is that there is no single received formalism for the whole kernel. There are,
however, direct formal homes for most individual sorts. The original artifact is the typed
assembly: claim identity, exact geometry, qualitative abstraction, located concatenation,
derivations, selection, materialization, and cross-master origins remain deliberately separate.

## 1. Status vocabulary

Literature connections in this area should be marked with one of four statuses.

| Status | Meaning |
| --- | --- |
| **Exact formalization** | The carrier and operations agree up to an explicitly stated encoding. |
| **Restricted-fragment formalization** | The literature formalizes a named sublanguage or result type, not the full Doccer layer. |
| **Algorithmic precedent** | The same optimization or evaluation pattern applies once Doccer supplies an objective and constraints. |
| **Doccer synthesis** | Existing mathematical pieces compose, but the many-sorted contract and engineering semantics are Doccer's. |

This distinction prevents a useful correspondence for one layer from becoming the claim that the
whole kernel is already present elsewhere.

## 2. The carrier boundary

For one master \(M\) with \(n\) addressable atoms, distinguish three endpoint carriers:

\[
P_M = \{0,\ldots,n\},
\qquad
L_M = \{(i,j)\in P_M^2\mid i\le j\},
\qquad
I_M = \{(i,j)\in P_M^2\mid i<j\}.
\]

- \(P_M\) is the boundary/point chain.
- \(L_M\) is the located-relation carrier. Its diagonal contains empty located extents and supplies
  the identity for sequence composition.
- \(I_M\) is the nonempty convex-interval carrier classified by the thirteen Allen atoms.

Claims form another carrier:

\[
C_M = ClaimId \times I_M \times Kind \times Payload \times Source \times \cdots .
\]

The geometry projection \(g:C_M\to I_M\) is not generally injective. Consequently, geometric
<code>Equal</code> is the diagonal identity on \(I_M\), but not on \(C_M\): two distinct claims may
have equal extents. Allen relation-algebra operations therefore belong on the geometry carrier or
its quotient, while evidence identity remains in a claim/fact layer.

This one separation resolves several apparent tensions in the literature map:

- document-spanner empties do not require empty Allen intervals;
- bag or provenance semantics do not replace claim occurrence identity;
- qualitative composition and exact witness joins can coexist without pretending to be the same
  operator.

## 3. Audit of the literature identifications

### 3.1 Document spanners

**Status: exact for an extractor/query subkernel; not the whole kernel.**

A document spanner is a program mapping a string to a set-valued relation whose attributes range
over position-specific half-open spans. That is a direct formal home for recognition programs and
their canonical extensional results:

~~~text
SpannerProgram<TSchema> : TextMaster -> SpanRelation<TSchema>
SpanRelation<TSchema>   : set-valued canonical tuples
SpanBatch               : identity-bearing evidence occurrences
~~~

The base formalism does not supply arbitrary claim payloads, occurrence IDs, multiple masters,
Allen networks, output rewriting, origin maps, retained suppression evidence, or an exact proof
graph. See
[Fagin et al., Document Spanners](https://s3.us.cloud-object-storage.appdomain.cloud/res-files/500-jacm15.pdf).

The difference result also needs its exact scope. Regular spanners are closed under difference and
complement; core spanners extended with substring-equality selection are not. This is a
representation-language closure result. It warns a compiler that an expression may leave the core
fragment; it does not prevent exact difference over finite materialized claim or region sets.

RGXlog is a close formalization of a positive span-only rule fragment: safe positive Datalog,
regex-formula EDBs, span-valued variables, and least-fixed-point semantics. It does not include
arbitrary adapter values, host callbacks, occurrence identity, negation, or materialized output.
The correct authors are Peterfreund, ten Cate, Fagin, and Kimelfeld
([RGXlog](https://drops.dagstuhl.de/storage/00lipics/lipics-vol127-icdt2019/LIPIcs.ICDT.2019.13/LIPIcs.ICDT.2019.13.pdf)).

Split-correctness supplies the right contract shape for chunk-local extraction:

\[
P = P_S \circ S,
\]

where local spans are rebased and results are merged. If the same extractor is used globally and
locally, the property is specifically self-splittability. Doccer must additionally name result
equality, duplicate reconciliation, origin/provenance merging, and residual boundary policy
([Split-Correctness](https://documentserver.uhasselt.be/bitstream/1942/29007/2/CameraReady.pdf)).

Two particularly direct follow-ons belong in the map:

- [Annotated Document Spanners](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ICDT.2020.8)
  combines spanners with semiring annotations.
- [A Framework for Extraction and Transformation of Documents](https://drops.dagstuhl.de/storage/00lipics/lipics-vol328-icdt2025/LIPIcs.ICDT.2025.18/LIPIcs.ICDT.2025.18.pdf)
  combines multispanners with regular string-to-string transformations and composition. It narrows
  the gap around macro expansion and discontinuous extraction, though it does not settle Doccer's
  cross-master origin semantics.

### 3.2 Finite discrete Allen semantics

**Status: exact after naming the carrier and the weak-representation convention.**

Let \(\varphi_M\) interpret unions of Allen atoms as binary relations over \(I_M\). Canonical
symbolic composition is a sound upper bound:

\[
\varphi_M(R \mathbin{;_A} S)
\supseteq
\varphi_M(R)\circ\varphi_M(S).
\]

This is a weak representation in Ligozat and Renz's 2004 sense. Later literature sometimes calls
mere upper-bound preservation a *feeble representation*, reserving stronger terminology for an
injective interpretation with the least representable upper approximation. The convention must be
named rather than presented as unambiguous standard terminology
([Ligozat and Renz](https://users.cecs.anu.edu.au/~jrenz/papers/ligozat-renz-pricai04.pdf);
[terminology comparison](https://arxiv.org/pdf/1606.09140)).

Three operations must remain distinct:

~~~text
ConcreteCompose(M, R, S)  exact witnesses on this master
AllenCompose(R, S)        the canonical symbolic table
AbstractCompose(M, R, S)  least atom-union covering the master's witnesses
~~~

The smallest counterexample to extensional composition uses
\(A=[0,1)\) and \(C=[2,3)\). Although \(A\) is Before \(C\), no nonempty \(B\)
satisfies \(A\) Before \(B\) and \(B\) Before \(C\). The canonical table nevertheless has
\(Before;Before=Before\).

Six boundaries remain an excellent table oracle. Three intervals have at most six distinct
endpoints, so rank-normalizing those endpoints preserves their Allen triad. Exhaustive \(D_6\)
enumeration can therefore regenerate every atomic table membership without making composition
extensional for every outer pair. Ghourabi and Takahashi prove table cells as inclusions under
interval-existence axioms, not exact composition over an arbitrary fixed finite master
([Ghourabi and Takahashi](https://arxiv.org/pdf/1804.01637)).

### 3.3 Located relations

**Status: exact Boolean-semiring/incidence-algebra identification.**

For \(A,B\subseteq L_M\), define shared-boundary concatenation by

\[
(i,j)\in A;B
\iff
\exists k.\ (i,k)\in A\land(k,j)\in B.
\]

Under the upper-triangular Boolean-matrix encoding,

\[
(A B)_{ij}=\bigvee_k A_{ik}\land B_{kj}.
\]

Union is Boolean addition, the diagonal is the identity, and star is reflexive-transitive closure.
This is the Boolean-semiring analogue of the incidence algebra of a chain. Strictly consuming
relations lie above the diagonal and are nilpotent on a finite chain.

Two qualifications matter:

- "Many consumes" is a hypothesis, not a theorem. Boolean closure is finite even with diagonal
  loops; consumption is what bounds path length and prevents infinitely many enumerated
  derivations/proofs.
- Valiant parsing uses the same triangular chart shape, but grammar entries and the
  grammar-induced product are not ordinary Boolean matrix multiplication and need not be
  associative. It is an algorithmic precedent, not an identity of algebras.

### 3.4 Pairing and nested words

**Status: exact precedent for a noncrossing matching relation.**

Nested words add a forward, partial one-to-one, noncrossing matching relation to a linearly ordered
word. This justifies keeping:

~~~text
MatchEdge != containing span != ParentEdge
~~~

Bare interval geometry does not determine a match. A correctly call/return-tagged word may,
however, induce its canonical matching by stack discipline. The relation may therefore be supplied
by an adapter or derived by a visibly-pushdown operation
([Alur and Madhusudan](https://www.cis.upenn.edu/~alur/Jacm09.pdf)).

### 3.5 Facts, occurrences, and provenance

**Status: exact inspiration for canonical annotated facts; not an identity with SpanBatch.**

A \(K\)-relation has one annotation per full tuple value. Under \(K=\mathbb N\), identical tuples
are aggregated into a multiplicity; they are not independently addressable occurrences. The
current <code>SpanBatch</code>, whose ordinals distinguish rows, is therefore better decomposed as:

~~~text
ClaimOccurrenceTable  stable occurrence IDs
CanonicalFactTable    one row per semantic fact key
SupportHypergraph     rule application + ordered premise IDs
SemiringView          evaluated/quotiented provenance
SpanSet               geometry-only coverage projection
~~~

Provenance polynomials deliberately quotient proof structure: premise order and rule identity may
be lost, and recursion can yield infinitely many proof trees even when the fact fixed point is
finite. The explicit support hypergraph should remain primary; semiring values are interpretations
of it
([Green, Karvounarakis, and Tannen](https://www.cs.ucdavis.edu/~green/papers/pods07.pdf)).

Why/witness provenance, how/derivation provenance, and where/origin provenance are separate
contracts.

### 3.6 Selection and multiresolution

**Status: exact graph/partition facts under restricted hypotheses; algorithms need a declared
objective.**

Flat, total, unlabelled partitions over one fixed admissible boundary basis correspond to subsets
of internal cut points. Refinement therefore gives a Boolean lattice, subject to the chosen order
orientation. Labels, overlap, hierarchy, budgets, or coupled admissibility constraints do not
automatically inherit that lattice.

The strict-crossing graph of nonempty intervals is a circle graph. Maximum-cardinality and
additive-weight independent sets therefore have polynomial algorithms
([Gavril](https://onlinelibrary.wiley.com/doi/10.1002/net.3230030305);
[weighted variant](https://globals.ieice.org/en_transactions/fundamentals/10.1587/e74-a_4_681/_p)).
This is not yet an "optimal Laminarizer": coverage, lexicographic priority, equal-geometry grouping,
required roots, hierarchy costs, and deterministic ties define different objectives.

Doccer's current
[Laminarizer](../../../src/doccer/Algebra/LaminarView.cs) is a deterministic greedy policy. Per
[D2](../planning/decisions.md), determinism rather than optimality is its contract. A circle-graph
solver is another possible <code>ResolutionPolicy</code>, not the implicit completion of the
current one.

### 3.7 Morphisms and origins

**Status: exact for total monotone boundary maps; broader lineage is relation-valued.**

Finite nonempty boundary chains and total monotone functions form the simplex category
\(\Delta\). Such a function factors through its image as a monotone surjection followed by a
monotone injection. <code>TextSlice.ToParent</code> is the injective case
([simplex category](https://stacks.math.columbia.edu/tag/0164)).

The drafted <code>OffsetMap</code> is not generally a \(\Delta\)-morphism: <code>Exact</code>,
<code>Range</code>, and <code>Unmapped</code> make it partial or relation-valued, while duplication
or reordering can exceed monotone functions altogether.

There is nevertheless a standard mathematical carrier for general origins:

\[
O_k\subseteq Atoms(M_{k+1})\times Atoms(M_k).
\]

These are morphisms in <code>Rel</code> and compose by relational composition. Multiple sources
use tagged disjoint unions; \(K\)-valued origins use matrices over \(K\). Doccer's original work is
not inventing relations, but assigning the right semantics to copy-origin, causal support,
insertions, deletions, aggregation, span lifting, stable identities, and compact composition.

## 4. Resulting kernel boundary

The audited literature supports the following layering:

~~~text
Master / boundary chain
    |
Located geometry algebra
    |
Recognition programs and extensional span relations
    |
Canonical facts + occurrence evidence
    |
Positive fixed-point inference + support hypergraph
    |
Nonmonotone policy selection
    |
Segmentation / cover / hierarchy optimization
    |
Materialized output master
    |
Origin relations back through prior masters
~~~

A tokenizer factory and a chunker factory are different instruments over this same stack. Adapters
supply domain predicates and rules; the kernel supplies finite carriers, exact and qualitative
composition, paths, fixed points, selection policies, and coordinate/origin laws.

## 5. Lean: the genuinely useful small lemmas

ThermoMapper's promotion sequence is appropriate:

~~~text
proto-lemmas/*.md
    -> compiling statements with sorry in enthymemes/*.lean
    -> proved declarations in Lemmas/*.lean
~~~

The following are proto-statements, not yet a Doccer Lean project. Their names should remain stable
once promoted.

### Chip A: finite interval semantics

This is the best first chip because it simultaneously validates the C# classifier, the finite
Allen caveat, and <code>TextSlice</code>.

Use an interval subtype over a linear order:

~~~lean
inductive AllenAtom
  | before | meets | overlaps | finishedBy | contains | starts | equal
  | startedBy | during | finishes | overlappedBy | metBy | after
  deriving DecidableEq, Fintype

def ISpan (alpha : Type u) [LT alpha] :=
  { p : alpha × alpha // p.1 < p.2 }

def Holds [LinearOrder alpha] :
    AllenAtom -> ISpan alpha -> ISpan alpha -> Prop := ...
~~~

#### A1. Converse is semantic

~~~lean
theorem converse_involutive (r : AllenAtom) :
    converse (converse r) = r

theorem holds_converse_iff
    [LinearOrder alpha] (r : AllenAtom) (x y : ISpan alpha) :
    Holds (converse r) x y <-> Holds r y x
~~~

These are small case proofs, but they freeze the easily confused inverse pairs.

#### A2. The atoms are jointly exhaustive and pairwise disjoint

~~~lean
theorem allen_existsUnique
    [LinearOrder alpha] (x y : ISpan alpha) :
    ExistsUnique (fun r : AllenAtom => Holds r x y)
~~~

This is the load-bearing theorem behind a total classifier, thirteen-bit relation sets, Boolean
complement, and interpretation injectivity. It is endpoint-order case analysis; a first
<code>Fin n</code> version should be amenable to <code>omega</code>.

#### A3. The executable classifier agrees with the predicates

~~~lean
theorem relate_spec
    [LinearOrder alpha] (x y : ISpan alpha) :
    Holds (relate x y) x y

theorem relate_eq_iff_holds
    [LinearOrder alpha] (x y : ISpan alpha) (r : AllenAtom) :
    relate x y = r <-> Holds r x y
~~~

This directly certifies the branch order in
[AllenRelation.cs](../../../src/doccer/Algebra/AllenRelation.cs).

#### A4. Order embeddings preserve every Allen atom

~~~lean
def ISpan.map [Preorder alpha] [Preorder beta]
    (f : alpha ↪o beta) (x : ISpan alpha) : ISpan beta := ...

theorem holds_map_orderEmbedding_iff
    [LinearOrder alpha] [LinearOrder beta]
    (f : alpha ↪o beta) (r : AllenAtom) (x y : ISpan alpha) :
    Holds r (x.map f) (y.map f) <-> Holds r x y
~~~

<code>TextSlice.ToParent</code> is a translation order embedding, so Allen preservation becomes a
corollary rather than thirteen separate implementation claims.

#### A5. Finite strong composition fails locally

~~~lean
abbrev FSpan (n : Nat) := ISpan (Fin n)

theorem before_before_adjacent_gap
    {n : Nat} (h : 4 <= n) :
    exists x z : FSpan n,
      Holds .before x z /\
      not (exists y : FSpan n,
        Holds .before x y /\ Holds .before y z)
~~~

The witnesses are \([0,1)\) and \([2,3)\). This is the smallest machine-checked certificate for
the distinction between canonical Allen composition and exact finite-master composition.

#### A6. Four-boundary realization threshold

~~~lean
theorem every_atom_realized_iff (n : Nat) :
    (forall r : AllenAtom, exists x y : FSpan n, Holds r x y) <-> 4 <= n
~~~

This pins the threshold at which the thirteen symbolic atoms are all represented. It also makes
the interpretation-injectivity threshold a short corollary.

### Chip B: rebase is a homomorphism exactly when the coordinate map is injective

This is arguably the most revealing small generic lemma in the whole investigation.

For the direct image of a binary relation under \(f:X\to Y\):

~~~lean
def RelMap (f : X -> Y) (R : Set (X × X)) : Set (Y × Y) := ...
def RelComp (R S : Set (X × X)) : Set (X × X) := ...

theorem relMap_comp_subset (f : X -> Y) (R S : Set (X × X)) :
    RelMap f (RelComp R S) ⊆ RelComp (RelMap f R) (RelMap f S)

theorem relMap_comp_eq_of_injective
    (hf : Function.Injective f) (R S : Set (X × X)) :
    RelMap f (RelComp R S) = RelComp (RelMap f R) (RelMap f S)

theorem relMap_preserves_all_comp_iff (f : X -> Y) :
    (forall R S, RelMap f (RelComp R S) =
      RelComp (RelMap f R) (RelMap f S)) <->
    Function.Injective f
~~~

The forward inclusion always holds. The reverse direction fails when two distinct intermediate
boundaries collapse to the same output boundary: the mapped relations acquire a spurious join.

This proves a sharp API law:

- <code>TextSlice</code>, being injective, commutes exactly with located <code>Seq</code>;
- a collapsing map may only be lax with respect to sequence composition;
- a general range-valued <code>OffsetMap</code> must not inherit <code>TextSlice</code>'s exact
  composition law.

The same chip should record the Boolean-region laws for an injective \(f\):

\[
f[A\cap B]=f[A]\cap f[B],
\qquad
f[A\setminus B]=f[A]\setminus f[B],
\]

and the relative-complement law

\[
f[U\setminus A]=f[U]\setminus f[A].
\]

For a slice, \(f[U]\) is the parent window, not the whole parent master. Thus child complement
rebases to complement relative to the window.

### Chip C: crossing and laminarity

Define:

\[
Separated(a,b) \iff a.end\le b.start \lor b.end\le a.start.
\]

For nonempty intervals:

~~~lean
theorem crosses_symmetric : Crosses a b <-> Crosses b a
theorem not_crosses_self : not (Crosses a a)

theorem noncrossing_classification
    (ha : Nonempty a) (hb : Nonempty b) :
    not (Crosses a b) <->
      Separated a b \/ Contains a b \/ Contains b a
~~~

The last theorem is the precise finite-interval fact behind "noncrossing means disjoint or nested."
The pairwise classification can likely be strengthened to include empties. The nonempty hypotheses
become important at the forest step: an empty boundary span can be numerically contained by two
meeting intervals, so a unique parent need not follow. <code>SpanBatchBuilder</code> currently
rejects empty claims, which supplies exactly the hypothesis the laminar forest needs.

The current greedy policy has two worthwhile generic theorems:

~~~lean
theorem greedy_pairwise_nonCrossing : PairwiseNonCrossing (greedy order xs)
theorem greedy_inclusion_maximal : InclusionMaximalCompatible (greedy order xs) xs
~~~

It should also have a negative certificate:

~~~lean
theorem greedy_not_maximum_cardinality :
    exists xs order,
      (greedy order xs).card <
      maximumNonCrossingCardinality xs
~~~

Use \(H=[2,7)\), \(L=[0,3)\), and \(R=[6,9)\), with \(H\) ranked first. The greedy result contains
only \(H\); \(L\) and \(R\) form a compatible pair. This proves in the theorem layer what D2 says
in prose: the current contract is deterministic inclusion-maximal selection, not global
cardinality optimality.

### Chip D: segmentations are cut sets

For a fixed window with a fixed finite set of admissible internal boundaries:

~~~lean
def cutsOf : Segmentation n -> Finset (InternalBoundary n)
def segmentationOf : Finset (InternalBoundary n) -> Segmentation n

theorem cuts_segmentation_inverse :
    cutsOf (segmentationOf cuts) = cuts

theorem segmentation_cuts_inverse :
    segmentationOf (cutsOf s) = s

theorem refines_iff_cut_inclusion :
    Refines fine coarse <-> cutsOf coarse ⊆ cutsOf fine
~~~

The two inverse laws establish the bijection; the refinement theorem transfers the Boolean lattice
structure. Labels, overlapping covers, budgets, and coupled cut constraints are deliberately
outside the theorem's type.

This is a medium rather than tiny chip because reconstruction requires sorting finite boundaries,
but the mathematical proof is short once the representation is settled.

### Chip E: consuming located relations are nilpotent

For a strict-forward relation \(R\) on a finite linear order:

~~~lean
theorem strict_path_length_lt_card
    (hR : forall {i j}, R i j -> i < j)
    (p : RPath R start finish) :
    p.length < Fintype.card alpha

theorem strict_relation_power_empty
    (hR : forall {i j}, R i j -> i < j) :
    RelPower R (Fintype.card alpha) = empty

theorem strict_star_finite
    (hR : forall {i j}, R i j -> i < j) :
    RelStar R =
      unionPowersBelow R (Fintype.card alpha)
~~~

These are the actual propositions behind finite consuming repetition. The first is an elementary
strict-chain/cardinality argument; the latter two are corollaries. They should be stated over paths
before choosing a matrix representation.

### Chip F: the \(D_6\) executable oracle

Encode the canonical table independently from finite witness enumeration:

~~~lean
def TriadOn (n : Nat) (r s t : AllenAtom) : Prop := ...
def CompOn (n : Nat) (r s : AllenAtom) : Finset AllenAtom := ...

theorem canonicalAtomComp_eq_compOn_six :
    forall r s, canonicalAtomComp r s = CompOn 6 r s
~~~

With finite decidable definitions this should be a <code>native_decide</code>-style certificate
for all 169 cells. It must not define the shipped table from <code>CompOn 6</code>, or the test is
circular.

The one larger bridge is:

~~~lean
theorem six_endpoint_normal_form
    [LinearOrder alpha] (x y z : ISpan alpha) :
    exists x' y' z' : FSpan 6,
      sameAllenTriad x y z x' y' z'
~~~

Its proof ranks the at most six endpoints. Once this is available, canonical-table soundness over
arbitrary linear orders and the finite weak-representation law become short corollaries. This is
the only result in the proposed initial development that is more than a small endpoint or finite-set
proof.

### Later chips, after the corresponding types stabilize

- **SpanSet representation:** normalization preserves point membership; normalized regions are
  sorted, nonempty, and separated; the implementation operations realize Boolean set laws.
- **Split correctness:** rebased union of local restrictions equals the global extensional result
  under an explicit cover/locality hypothesis and named equality semantics.
- **Positive saturation:** an inflationary monotone operator on a finite fact carrier reaches a
  fixed point after at most the carrier cardinality many strict insertions.
- **Origins:** functional origins embed into relation-valued origins and the embedding preserves
  identity and composition.
- **Laminar forest:** every nonroot member of a finite nonempty laminar interval family has a unique
  least proper container; the start-ascending/end-descending stack constructs that parent.

These should wait for the corresponding Doccer result types. Proving them against speculative
types would formalize an API accident rather than a contract.

## 6. Recommended first proof slice

The first Lean effort should be deliberately smaller than the whole formalization map:

1. <code>converse_involutive</code>;
2. <code>holds_converse_iff</code>;
3. <code>allen_existsUnique</code>;
4. <code>relate_spec</code>;
5. <code>holds_map_orderEmbedding_iff</code>;
6. <code>before_before_adjacent_gap</code>;
7. <code>relMap_comp_subset</code> and <code>relMap_comp_eq_of_injective</code>;
8. <code>noncrossing_classification</code>.

This slice has unusually good leverage:

- it validates the current classifier and inverse implementation;
- it proves <code>TextSlice</code>'s strongest geometry and sequence laws;
- it prevents those laws from being copied incorrectly onto <code>OffsetMap</code>;
- it gives a machine-checked finite-master counterexample to strong composition;
- it supplies the geometric theorem on which <code>Laminarizer</code>'s forest interpretation
  depends.

Only after that should the project add segmentation/cut equivalence, nilpotence/star, the greedy
maximality theorem, and the \(D_6\) oracle.

## 7. Suggested harness shape

If Doccer receives its own Lean harness, mirror ThermoMapper's promotion model but begin with a
small number of claim-oriented files:

~~~text
lean/
  proto-lemmas/
    finite-interval-semantics.md
    located-rebase-laws.md
    laminarity-and-segmentation.md
  enthymemes/
    FiniteIntervals.lean
    LocatedRebase.lean
    Laminar.lean
  Enthymemes.lean
  Lemmas.lean
~~~

Suggested namespaces are <code>Doccer.Interval</code>, <code>Doccer.Located</code>, and
<code>Doccer.Laminar</code>. Stable identifiers such as <code>IA-1</code>, <code>LR-1</code>, and
<code>LM-1</code> can tie each theorem to the engineering contract it certifies.

Deep imported facts should follow ThermoMapper's <code>Stability.lean</code> pattern: quarantine a
properly cited axiom only when reproducing the literature theorem is out of scope, then prove the
Doccer-specific plumbing separately. For the proposed first slice, no external axiom should be
necessary.

## 8. Non-goals

The first Lean work should not:

- re-prove all 169 Allen table cells from Allen-Hayes meets axioms;
- formalize a polynomial circle-graph maximum-independent-set implementation;
- embed RGXlog or document-spanner automata wholesale;
- build recursive provenance-semiring theory before Doccer has a fact/support type;
- turn every standard <code>Set</code> or <code>Relation</code> identity into a Doccer theorem;
- create one untyped "composition" abstraction spanning all carriers.

Lean is most valuable here as a theory-level unit-test harness for the places where an apparently
obvious transfer can fail: finite versus dense composition, geometry versus claim identity,
injective slice rebasing versus collapsing edit maps, relative versus whole-master complement, and
maximal versus maximum laminar selection.
