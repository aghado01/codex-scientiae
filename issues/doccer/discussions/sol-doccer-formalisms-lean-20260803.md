# so i looked into formalizations and im trying to fill in some gaps from my initial research as well as pin down the loose ends D:\aghado01\codex-scientiae\issues\doccer\discussions\fable-doccer-formalizations-20260803.md

The new [formalizations note](D:/aghado01/codex-scientiae/issues/doccer/discussions/fable-doccer-formalizations-20260803.md) closes several genuine gaps. Its central discovery is not that one existing formalism already _is_ Doccer, but that different Doccer layers have different, fairly exact mathematical homes.

The note is strongest as a decomposition of Doccer. It overreaches whenever a correspondence for one layer becomes "the whole kernel."

## Claim-by-claim assessment

### 1. Document spanners: the extractor subkernel, not the whole kernel

Document spanners are an unusually close formal model for:

$$
\text{extractor program} : \text{string} \longrightarrow \text{relation of located spans}.
$$

They supply finite strings, position-specific half-open spans—including $[i,i)$—relational operations, regex-based recognition, and set-valued results. But the spanner is the **program**, while its returned relation is an **extensional result**. Neither is quite the existing identity-bearing `SpanBatch`.

A more accurate correspondence is:

```text
SpannerProgram<TSchema> : TextMaster → SpanRelation<TSchema>
SpanRelation<TSchema>   : set-valued canonical tuples
SpanBatch               : identity-bearing evidence occurrences
```

Base spanners do not account for arbitrary payloads, claim occurrence identity, multiple masters, Allen networks, output materialization, origin maps, suppression evidence, or exact proof graphs. [Fagin et al.’s formalism](https://s3.us.cloud-object-storage.appdomain.cloud/res-files/500-jacm15.pdf) therefore covers Doccer’s recognition/query layer very directly, but not “the whole kernel.”

Several nearby claims need tightening:

- Regular spanners are closed under difference; **core spanners with substring-equality selection are not**. That constrains what a compiler can express in the same language fragment. It does not threaten exact finite `ClaimSet.Except` or `Subtract`.
- Constant-delay enumeration is available for particular sequential automata representations and in data complexity, not for arbitrary recursive, provenance-bearing Doccer plans. [Amarilli et al.](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ICDT.2019.22)
- RGXlog is a very close model for a positive, span-only rule fragment, but not for host-language guards, payload construction, fresh claim identities, negation, or materialization. The attribution in the note should be corrected to **Peterfreund, ten Cate, Fagin, and Kimelfeld**. [RGXlog paper](https://drops.dagstuhl.de/storage/00lipics/lipics-vol127-icdt2019/LIPIcs.ICDT.2019.13/LIPIcs.ICDT.2019.13.pdf)
- “Run locally, rebase, union, and recover the global result” is specifically **self-splittability** when the same extractor is used globally and locally. General split-correctness permits a distinct local extractor. Identity, provenance, and output-string equality require additional merge semantics. [Split-correctness paper](https://documentserver.uhasselt.be/bitstream/1942/29007/2/CameraReady.pdf)

This is exceptionally relevant to the chunker factory, but the contract must name the splitter, local extractor, coordinate rebase, duplicate reconciliation, residual boundary policy, and the precise notion of result equality.

### 2. Finite discrete Allen semantics: correct, but terminology-sensitive

Let

$$
P_M = \{0,\ldots,n\}, \qquad I_M = \{[i,j) \mid i,j \in P_M,\ i < j\}.
$$

The interpretation $\varphi_M$ of Allen atoms as relations over $I_M$ satisfies

$$
\varphi_M(R ;_A S) \supseteq \varphi_M(R) \circ \varphi_M(S),
$$

where $;_A$ is canonical Allen-table composition and $\circ$ is exact relational composition over the particular master.

That is a **weak representation in Ligozat and Renz’s 2004 terminology**. Later algebraic literature sometimes calls mere upper-bound preservation a _feeble representation_, reserving stronger terminology for the least representable upper bound. So “five words of standard terminology” is too confident. [Ligozat and Renz](https://users.cecs.anu.edu.au/~jrenz/papers/ligozat-renz-pricai04.pdf), [later terminology discussion](https://arxiv.org/pdf/1606.09140)

The cleanest finite counterexample is:

```text
A = [0,1)
C = [2,3)
```

Although $A$ is Before $C$, there is no nonempty $B$ with $A$ Before $B$ and $B$ Before $C$. Yet the symbolic table has:

$$
\texttt{Before} ;_A \texttt{Before} = \texttt{Before}.
$$

Three compositions should therefore remain explicit in Doccer:

```text
ConcreteCompose(M, R, S)   exact witnesses on this master
AllenCompose(R, S)         canonical qualitative upper bound
AbstractCompose(M, R, S)   least atom-union covering concrete results
```

Also, the representation is over **geometric intervals**, not raw claims. Distinct coextensive claims satisfy geometric `Equal`, so that relation is not the identity relation on claim IDs. Allen algebra should operate on geometry or a geometry quotient; evidence identities remain in another layer.

Six boundaries are still a very useful finite oracle: three intervals use at most six distinct endpoint ranks, so $D_6$ can regenerate every atomic composition-table membership. It does not make composition exact for every pair on $D_6$. Ghourabi and Takahashi likewise prove table-cell inclusions under interval-extension axioms, not extensional composition on an arbitrary finite master. [Ghourabi and Takahashi](https://arxiv.org/pdf/1804.01637)

### 3. Located languages and incidence algebra: one of the strongest identifications

For located pieces, include empty extents:

$$
L_M = \{(i,j) \mid i \le j\}.
$$

Represent $A \subseteq L_M$ as an upper-triangular Boolean matrix. Then:

$$
(A \cdot B)_{ij} = \bigvee_k A_{ik} \land B_{kj}
$$

is exactly endpoint-sharing sequence composition. Union is Boolean addition, the diagonal is identity, and star is reflexive-transitive closure. This really is the Boolean incidence algebra of a finite chain and a finite Kleene algebra.

Two qualifications matter:

- A strictly consuming relation $i < j$ is nilpotent, so its star has a finite power expansion. But Boolean reachability is finite even with diagonal edges; the consumption rule becomes essential when enumerating derivation paths or provenance, because epsilon cycles can generate infinitely many proofs.
- Valiant’s parsing charts have the same upper-triangular carrier shape, but chart entries contain nonterminals and use a grammar-induced product that need not be associative. It is a powerful implementation analogy, not automatically the same Kleene algebra.

This suggests a genuinely reusable `LocatedRelation<K>` kernel, with Boolean reachability as one interpretation and provenance/path structures as richer interpretations.

### 4. Nested words: exact precedent for explicit pairing

Nested words justify representing matching as a separate typed edge relation over linear positions. Their matching relation is forward, partial one-to-one, and noncrossing. [Alur and Madhusudan](https://www.cis.upenn.edu/~alur/Jacm09.pdf)

The note should soften “matching is not recoverable from flat geometry.” Bare geometry does not determine matching, but correctly tagged call/return words can induce it by stack discipline. The real design conclusion survives:

```text
MatchEdge ≠ containing span ≠ ParentEdge
```

An adapter may provide match edges, a generic visibly-pushdown operation may derive them, and ambiguous recovery may preserve competing candidates.

### 5. Provenance: preserve the proof structure first

Semiring provenance strongly supports “one semantic fact, several alternative or joint supports.” But a $K$-relation gives **one annotation per complete tuple value**. An $\mathbb{N}$-relation aggregates duplicate tuples into a multiplicity; it does not preserve independently addressable duplicate occurrences.

Consequently, the current identity-bearing [SpanBatch](D:/aghado01/codex-scientiae/src/doccer/Core/SpanBatch.cs:205) is not simply “a bag $K$-relation.” A better separation is:

```text
ClaimOccurrenceTable   stable occurrence/claim IDs
CanonicalFactTable     one row per semantic fact key
SupportHypergraph      rule application + ordered premise IDs
SemiringView           evaluated/quotiented provenance
SpanSet                geometry-only coverage projection
```

Provenance polynomials also quotient proof structure: premise order and rule identity can disappear, and derivations using the same multiset of inputs combine. Recursive Datalog may have infinitely many proof trees even though its fact fixed point is finite, requiring cyclic provenance or formal power series rather than a finite polynomial. [Green, Karvounarakis, and Tannen](https://www.cs.ucdavis.edu/~green/papers/pods07.pdf)

So keep three notions separate:

- **why/witness provenance:** which inputs support this;
- **how/derivation provenance:** which rule applications produced it;
- **where/origin provenance:** which source positions contributed material.

The omitted bridge here is [Annotated Document Spanners](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ICDT.2020.8), which directly joins spanners and semiring annotations.

### 6. Partitions, circle graphs, and “optimal Laminarizer”

The partition-as-cut-set theorem is exact only for total, flat, disjoint convex partitions over one fixed admissible boundary basis. Such a partition corresponds to a subset of internal cuts, yielding a Boolean lattice under refinement.

It does not automatically extend to labelled segments, covers, overlaps, hierarchy, budget constraints, or only partially admissible cut sets. Those should remain separate types such as `Segmentation`, `CoverView`, and `HierarchyView`.

The proper-overlap graph of intervals is indeed a circle graph: alternating interval endpoints correspond to intersecting chords. Maximum-cardinality and additive-weight independent-set algorithms therefore provide polynomial methods for selecting a maximum-weight noncrossing subset. [Gavril](https://onlinelibrary.wiley.com/doi/10.1002/net.3230030305), [weighted variant](https://globals.ieice.org/en_transactions/fundamentals/10.1587/e74-a_4_681/_p)

But this does not yet yield “the optimal Laminarizer.” It yields an optimum only after Doccer declares an additive objective. Coverage, lexicographic priority, required roots, equal-geometry groups, hierarchy costs, and stable tie-breaking may define different problems.

The existing [LaminarView.cs](D:/aghado01/codex-scientiae/src/doccer/Algebra/LaminarView.cs:50) is therefore best understood exactly as the decisions describe it: a deterministic greedy policy, not an approximation to an unstated optimum. The circle-graph solver should be another `ResolutionPolicy`, not its presumed replacement.

### 7. $\Delta$, `TextSlice`, and `OffsetMap`

Finite nonempty boundary chains with total monotone functions form the simplex category $\Delta$. Every such function factors through its image as:

$$
[m] \twoheadrightarrow \operatorname{im}(f) \hookrightarrow [n].
$$

[Stacks Project definition](https://stacks.math.columbia.edu/tag/0164)

`TextSlice.ToParent` is exactly the injective part: an isomorphism onto the parent window followed by inclusion into the parent boundary chain.

The general proposed `OffsetMap` is not a $\Delta$-morphism. `Exact`, `Range`, and `Unmapped` make it partial and relation-valued; duplication, multi-source expansion, or reordering can exceed monotone relations altogether. The accurate statement is:

> Every total single-valued monotone specialization of `OffsetMap` factors as collapse followed by embedding. General Doccer lineage requires correspondences or relations.

### 8. The origin problem is less mathematically unnamed than the note suggests

A stage origin can already be modeled as a relation:

$$
O_k \subseteq \operatorname{Atoms}(M_{k+1}) \times \operatorname{Atoms}(M_k),
$$

with successive origins composed by relational composition. Multiple source masters can be combined by tagged disjoint union; weighted origins become matrices over a semiring.

So the general mathematical home is the category $\mathbf{Rel}$, or $\mathbf{Mat}(K)$ for annotated relations. The original Doccer work lies in defining the semantics:

- copied content versus merely causal support;
- inserted and deleted residue;
- atom-to-span lifting;
- aggregation and duplication;
- stable identities across masters;
- normalization and compact storage;
- keeping coordinate origins distinct from proof provenance.

A major missing reference is the 2025 [Framework for Extraction and Transformation of Documents](https://drops.dagstuhl.de/storage/00lipics/lipics-vol328-icdt2025/LIPIcs.ICDT.2025.18/LIPIcs.ICDT.2025.18.pdf). It combines multispanners—whose variables may denote sets of disjoint spans—with regular string-to-string transformations and establishes compositional results. That narrows the apparent gap around macro expansion and materialization considerably, although it still does not provide Doccer’s desired multi-master origin semantics.

## The resulting kernel boundary

The literature now supports a fairly crisp layered kernel:

```text
Master / boundary chain
    ↓
Located geometry algebra
    ↓
Recognition programs and extensional span relations
    ↓
Canonical facts + occurrence evidence
    ↓
Positive fixed-point inference + proof hypergraph
    ↓
Nonmonotone policy selection
    ↓
Segmentation / cover / hierarchy optimization
    ↓
Materialized output master
    ↓
Origin relations back through prior masters
```

That makes “tokenizer factory” and “chunker factory” much less metaphorical:

- a tokenizer plan combines recognition, positive inference, pairing, selection, and possibly materialization;
- a chunker plan combines candidate boundary extraction, admissibility constraints, an objective, segmentation or cover construction, and split/stitch contracts;
- domain adapters supply KaTeX, Markdown, PDF, or other lexical predicates and payload rules;
- the kernel supplies the finite carriers, compositions, fixed points, policies, proofs, and coordinate/origin machinery.

I would revise the note by marking every literature connection as one of **exact formalization**, **formalization of a restricted fragment**, **algorithmic precedent**, or **Doccer synthesis**. With that epistemic distinction, the research is not merely filling citations: it is producing a defensible specification boundary for the mature kernel.

# Ok, well we can write that up, but are there any small lemmas that might be lurking here to be worked out in Lean? I have done a little of this in the ThermoMapper project when i come across something that i recognize needs treatment D:\aghado01\ThermoMapper\lean\enthymemes

Yes. Several small lemmas are unusually well placed for Lean because they expose boundaries that prose can easily blur.

I wrote the full audit and theorem inventory here: [Doccer formalization audit and Lean obligations](D:/aghado01/codex-scientiae/issues/doccer/discussions/sol-doccer-formalization-audit-and-lean-obligations-20260803.md). The Lean section begins [here](D:/aghado01/codex-scientiae/issues/doccer/discussions/sol-doccer-formalization-audit-and-lean-obligations-20260803.md:308).

The standout “lurking lemma” is:

$$
f_*(R \circ S) \subseteq f_*R \circ f_*S,
$$

with equality for every $R,S$ exactly when $f$ is injective.

That cleanly proves:

- `TextSlice`, being an injective translation, commutes exactly with located `Seq`.
- A collapsing `OffsetMap` can create spurious shared-boundary joins and must receive only the weaker inclusion law.

The best first Lean chip would then contain:

1. Allen converse is involutive and agrees with argument reversal.
2. The thirteen endpoint predicates are JEPD.
3. The executable `Relate` classifier satisfies those predicates.
4. Order embeddings preserve every Allen atom—certifying `TextSlice`.
5. The explicit $[0,1)$, $[2,3)$ counterexample showing finite `Before ; Before` is not extensional.
6. Noncrossing intervals are disjoint-or-nested.
7. The current greedy Laminarizer is inclusion-maximal, with a separate three-span counterexample proving it need not be maximum.
8. Relation mapping preserves composition exactly under injectivity.

Next-tier candidates are the cut-set/segmentation bijection, finite nilpotence of strictly consuming located relations, and the independently encoded $D_6$ table oracle. The six-endpoint normal-form theorem is the only moderately substantial proof; everything else is endpoint arithmetic, finite sets, or relational plumbing.

I did not create a Doccer Lean project yet. The write-up proposes mirroring ThermoMapper’s proto-lemma → enthymeme → proved-lemma promotion structure and identifies the first three files as `FiniteIntervals`, `LocatedRebase`, and `Laminar`.

One unrelated harness-hygiene note from the inspection: ThermoMapper’s umbrella currently omits `Stability`, some imports rely on Windows-only path casing, and its meta-CI assumes a `Lemmas/` directory that does not yet exist. I left those untouched.
