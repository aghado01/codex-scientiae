# Close read: the ICDT 2025 extract-transform framework vs doccer's origin sort

Source: arXiv **2405.12350v1**, Riveros, Schmid, Schweikardt, *A framework for extraction and
transformation of documents* (ICDT 2025). Read from the LaTeX source in
`ingestion/inventory/2405.12350v1/`. Companion to the
[formalization audit](sol-doccer-formalization-audit-and-lean-obligations-20260803.md), which
flagged this paper as narrowing the extraction↔transformation gap while leaving cross-master
origin semantics open. This read confirms that verdict and makes it precise.

## The model, in doccer terms

- **Two phases.** An ET program is a pair $(E, T)$: $E$ a *multispanner* (variables map to **sets
  of pairwise-disjoint spans**, not single spans), $T$ a string-to-string function applied per
  extracted tuple. Linear ET = regex multispanner + linear-growth polyregular function,
  operationally a copyless-register DSST.
- **The intermediate object is the annotated string.** Each tuple $t$ is serialized *into* the
  document as inline parentheses — a canonical multiref-word $\langle t, doc\rangle$ with a
  normalization discipline (fixed per-gap variable order, superfluous empty-bracket pairs
  deduplicated) to make the encoding unique.
- **Output = bag of strings.** $\ [\![E \cdot T]\!](doc) = \{\!\{\, T(\langle t, doc\rangle) \mid t
  \in E(doc) \,\}\!\}$. Duplicates are kept deliberately (distinct extractions → distinct outputs),
  but only as multiplicity.
- **Main results.** Linear ET ≡ NSST under bag semantics (effective, both directions); enumeration
  with linear preprocessing and output-linear delay (garbage-free normalization + an ECS-with-
  assignments structure, following the Muñoz–Riveros ECS line); closure under composition, via a
  bag-semantics NSST composition theorem.
- **Their own boundary.** Full (non-linear) polyregular ET programs are explicitly future work.

## Finding 1: the origin gap is real, and now precisely bounded

There is **no origin object anywhere in the semantics**. Outputs are bare strings; once $T$ runs,
the tuple that produced an output survives only as multiplicity. No output-position→input-position
mapping exists in the model — Bojańczyk-style origin semantics is not imported. Composition is
defined by quantifying the intermediate document away:

$$
[\![(E_1 \cdot T_1) \circ (E_2 \cdot T_2)]\!](doc) \;=\; \bigcup_{doc' \in [\![E_1 \cdot T_1]\!](doc)} [\![E_2 \cdot T_2]\!](doc') .
$$

That is the exact inverse of doccer's requirement: the composition corollary's whole point is that
intermediate documents *disappear* (compose the machines, evaluate once), while doccer's chain of
masters exists because intermediates are consumer-facing deliverables with origins composed
*through* them.

The nuance worth keeping: the **operational model is origin-compatible even though the semantics
quotients it away**. In a copyless DSST run, every output letter has a unique birth event (input
position + transition), and copyless assignments move content without duplication — a functional
origin map is implicit in every run, and bag semantics even individuates runs (a duplicate output
= a distinct run = a distinct derivation). The paper discards exactly what doccer's origin sort
would keep. So the origin tranche's job against this literature is **reification, not invention**:
surface what the run already knows, then generalize to relation-valued, multi-source origins.
Status per the audit vocabulary: **Doccer synthesis**, confirmed by close read.

## Finding 2: third independent witness for the occurrence-identity gap

The canonical encoding $\langle t, doc\rangle$ is injective on *tuples* — geometry only. Its
per-gap normal form $(\dashv_x)^c(\vdash_x\dashv_x)^e(\vdash_x)^o$ with $c,e,o \in \{0,1\}$ can
represent at most one empty span per (position, variable), and the paper explicitly deduplicates
brackets that "would describe the same empty span several times." Two claims with equal geometry
are unrepresentable by construction. With the K-relation aggregation point and the output-bag
multiplicity quotient, this is now the **third independent witness** that occurrence identity is
not carried by the surrounding formalisms. The `ClaimOccurrenceTable` sort is defensibly
doccer-original.

## Finding 3: where doccer's flagship use case sits relative to their fragments

The same-variable **disjointness constraint is representation-forced**: without it, valid
multiref-words form a Dyck-like language an NFA cannot recognize — the nested-word threshold
appearing again, this time as the boundary that keeps multispanners regular. Overlapping same-kind
candidates therefore cannot coexist in one tuple; ambiguity lives across tuples of the relation.
A multispan-tuple is one disjoint selection — one packing — and $E(doc)$ enumerates admissible
packings, which is the extensional shadow of doccer's candidate-graph-plus-policy design.

For macro expansion specifically, the framework covers a ladder, and doccer's showcase climbs off
the top of it:

1. **Bounded, program-known duplication** (argument used twice): stays linear — parallel registers
   accumulate the same content copylessly. Covered by their strongest results.
2. **Site-count-dependent copying** (one definition body copied to $k$ call sites): polynomial
   growth — full polyregular, i.e., exactly their deferred future work. And matching call sites to
   definitions by *name* is string-equality selection, which regex multispanners do not have
   (the core-spanner equality thread from the audit reconnects here) — only a finite, fixed macro
   vocabulary fits the fixed-program model at all.
3. **Document-supplied rules and recursion to fixpoint** (TeX-style `\newcommand` read from the
   same master, unbounded nesting): outside the framework entirely — ET programs are fixed
   $(E,T)$; doccer's adapters are document-parameterized, and expansion depth is data-dependent.

So the convergence is real but fragment-bounded: the paper's strong results cover rung 1; rung 2
is their open problem; rung 3 is orchestration + termination policy, which is doccer's territory
by design.

## Finding 4: what transfers

- **ECS-with-assignments** is a packed-evaluation precedent for Tranche D's packed derivations:
  compact representation of exponentially many alternatives with output-linear-delay retrieval,
  register content kept synchronous via assignments in internal nodes. Worth reading alongside
  Muñoz–Riveros ECS when the derivation store gets built.
- **Garbage-free** is a nameable validator concept for rewrite plans: every register's content
  reaches the output ("no dead lineage"). They can decide it in $O(|\Delta|\cdot|Reg|)$; doccer's
  analog is a residual check — every plan piece is either woven into the materialized master or
  reported as explicit residue.
- **Multiref-language closure** under union, concatenation, *and star* (classical spanners: union
  only) is the located-Kleene structure surfacing in spanner-land — an independent confirmation of
  the §6.1 incidence-algebra view.
- **The composition-multiplicity bug history** is a cautionary tale with names attached: the
  Alur–Deshmukh 2011 set-semantics construction contained an error found by Engelfriet, repaired
  in 2022, and simplified here for bag semantics (garbage-freeness + single-guess subruns) —
  multiplicity-correct composition of evidence-forgetting stages is genuinely subtle. Doccer's
  identity-preserving alternative composes origins in **Rel**, where composition is boring by
  design — and boring is provable. That is an argument *for* the Lean origin-composition chip,
  not against it. (The fair converse: their hard part is doing it in one streaming pass with
  complexity bounds; doccer materializes intermediates and pays storage instead.)
- **NSST equivalence** gives a complexity anchor: a rewrite plan that fits fixed linear ET admits
  output-linear-delay streaming evaluation. Doccer doesn't need the streaming regime — masters
  materialize — but the anchor tells us what the compiled-bounded-rewrite option would cost.

## Status markings (audit vocabulary)

| Piece | Status for doccer |
| --- | --- |
| Multispanners (disjoint span-set tuples) | Exact formalization of a *restricted* candidate-family carrier; ambiguity across tuples, not within |
| ET semantics (bag of output strings) | Restricted-fragment formalization of extract→materialize; no lineage |
| NSST equivalence, ECSA enumeration | Algorithmic precedent (packed evaluation, compiled plans) |
| Bag-semantics composition theorem | Algorithmic precedent + warning catalogue for multiplicity under composition |
| Cross-master origins | Absent — confirmed **Doccer synthesis**, with the reification path stated above |

## Lean inventory deltas

Nothing here creates a defensive obligation against an existing formalism — the close read
*confirms* the later origin chips as stated in the audit: functional origins embed into
relation-valued origins; the embedding preserves identity and composition. Two optional additions:

- A small lemma connecting carriers: a multispan is exactly a pairwise-`Separated` family
  (Chip C's vocabulary), and the unnested ref-word discipline $(\vdash\dashv)^k$ is equivalent to
  pairwise separation — the regularity boundary sits precisely at separated-vs-nested.
- When the origin sort lands, the copyless-run functional origin is the canonical *inhabitant* to
  state the embedding lemma against: linear ET programs live in the functional sublattice of
  doccer's relation-valued origins.
