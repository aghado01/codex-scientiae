**The Isabelle formalization of Allen’s composition table** is the principal machine-checked treatment of the full 13×13 table in the literature. It appears as the Archive of Formal Proofs entry _Allen’s Interval Calculus_ (Fadoua Ghourabi, 2016; session `Allen_Calculus`).

### Core contribution

Ghourabi formalizes:

- An axiomatic theory of intervals whose sole primitive is the binary **meets** relation (\(p \parallel q\)), taken from Allen & Hayes (1985).
- The 13 JEPD base relations, defined from meets and equality.
- Pairwise disjointness and joint exhaustiveness of those 13 relations.
- **All 169 compositions** (every entry of the classic composition table) as first-order theorems of the form \(r_1 \circ r_2 \subseteq \theta\), where \(\theta\) is either a single base relation or a named union (\(\alpha_i\), \(\beta_i\), \(\gamma\), \(\delta\), \ldots).
- The auxiliary notion of a _nest_ (the set of all intervals that meet at a common point). Nests recover the ordering properties normally associated with points without introducing a separate point sort.

The development is written in Isabelle/HOL using Isar structured proofs and custom Eisbach methods. The bulk of the work lives in the theory `allen`, supported by theories that establish the meets axioms, the PD/JE properties, and the nest construction.

### Foundational axiomatization (Allen & Hayes)

The formalization rests on the five meets axioms presented in Allen & Hayes, “A Common-sense Theory of Time” (IJCAI 1985). The key axioms include uniqueness of meeting places, a trichotomy/ordering principle on meeting points, and an existence principle that guarantees intermediate intervals. These axioms are sufficient to define all 13 Allen relations and to derive the entire composition table. Subsequent literature has examined the metatheoretic status of this axiomatization (weak equivalence with other point-free or event-based theories, finiteness and closedness criteria, etc.).

### Proof strategy for the compositions

Ghourabi (and the companion paper with Kazuko Takahashi, arXiv:1804.01637) proceed by:

1. Expanding the definitions of \(r_1\) and \(r_2\) into conjunctions of meets literals.
2. Selecting pairs of literals that constrain the endpoints of the outer intervals.
3. Applying the meets axioms—especially the central case-splitting axiom M2—to generate the three mutually exclusive geometric configurations that can arise.
4. Reconstructing the full set of literals that characterise the expected result relation(s).

The conceptual-neighbourhood lattice of the 13 relations supplies a systematic order in which to consider cases: neighbouring relations differ by a continuous deformation (lengthening or shortening an interval). This lattice-guided case analysis, together with a reusable Isar proof template, makes the 169 proofs feasible. Many simple entries are discharged by an automated method; the more complex composite entries (\(\alpha, \beta, \gamma, \delta\)) require explicit Isar scaffolding.

### Related formal work

- No other complete Isabelle (or Coq/Lean/HOL) formalization of the full Allen composition table appears to have been published.
- Separate Isabelle developments treat _numeric_ interval arithmetic (e.g., Brucker, Cameron-Burke & Stell, AFP _Interval_Analysis_, 2024) and its use in program verification; these are orthogonal to the qualitative algebra.
- Haskell libraries and other executable implementations of Allen’s algebra exist, but they are not formal proofs of the composition table.
- Model-theoretic and algebraic studies of the algebra (relation-algebra presentations, tractable subclasses such as ORD-Horn, point-interval hybrids) provide complementary analyses but do not machine-check the 169 compositions.

### Conceptual significance for qualitative temporal reasoning

The formalization supplies independent, machine-checked evidence that the composition table is a consequence of a small set of first-order axioms on meets. This has several consequences in the literature:

- It confirms that constraint-propagation algorithms that rely on the table are sound relative to the underlying ontology.
- It supplies a reusable library of lemmas that later formal developments of temporal constraint networks, qualitative calculi, or hybrid metric/qualitative systems can import.
- The nest construction offers a pure interval-based route to points, which has been used in subsequent discussions of the ontology of time (points as derived vs. primitive).
- The lattice + M2 strategy is presented as a general method that could, in principle, be adapted when the algebra is extended (non-convex intervals, higher-dimensional regions, etc.).

In short, Ghourabi’s AFP entry is the definitive formal validation of Allen’s composition table. It sits at the intersection of qualitative temporal reasoning, relation algebra, and interactive theorem proving, and it remains the reference machine-checked account of the 169 compositions.

**How Ghourabi’s Isabelle formalization of the composition table can inform Doccer’s next step**

Doccer currently has the 13 base relations, `Relate`, `Inverse`, and a reference pairwise `Join`. The algebraic composition operator
\[
r_1 \circ r_2 \;=\; \{ r \mid \exists z.\; x\,r_1\,z \land z\,r_2\,y \}
\]
(the classic 13×13 table that returns a disjunction of possible relations) is the natural frontier. The AFP entry _Allen’s Interval Calculus_ (Ghourabi 2016) and its companion paper (Ghourabi & Takahashi, arXiv:1804.01637) give a machine-checked, axiomatically grounded treatment of exactly that operator. Several concrete design lessons transfer.

### 1. Soundness relative to a minimal axiomatization

The formalization derives every table entry from the five meets axioms of Allen & Hayes (1985). Because Doccer’s half-open integer spans already satisfy those axioms (meets is simply `End == Start`, the ordering is the natural order on integers, uniqueness and existence of intermediate points hold), any implementation of composition that matches the verified table is guaranteed to be consistent with the geometry you already compute. You do not have to re-prove the table; you can treat the Isabelle results as an external oracle that certifies the discrete case.

### 2. Explicit intermediate representations that map cleanly onto code

Ghourabi works with named composite relations that appear repeatedly in the table:

- \(\alpha_1 = \{ov,s,d\}\)
- \(\alpha_3 = \{b,m,ov\}\)
- \(\beta_1 = \{b,m,ov,s,d\}\)
- \(\gamma\) (almost everything except the pure before/after extremes)
- \(\delta\) (the full set)

These are exactly the sets that arise when you propagate constraints over claims. Encoding them as bit-masks or small closed sets inside Doccer (instead of always expanding to 13-element collections) gives a compact, cache-friendly representation for path-consistency or simple constraint networks. The formalization already proves the closure properties of these sets under composition and converse, so you can hard-code the small algebra they generate without fear of missing cases.

### 3. Lattice-guided case analysis as an implementation strategy

The proofs rely on the conceptual-neighbourhood lattice of the 13 relations: neighbouring relations differ by a continuous deformation of an endpoint. When you implement composition you can therefore:

- generate the table once from a small number of “generator” cases (the lattice edges) rather than writing 169 independent pieces of logic, or
- use the same lattice to drive a decision-tree or jump-table implementation that mirrors the Isabelle case splits on axiom M2.

Either route keeps the code small and makes future extensions (e.g., adding a new base relation) mechanically checkable against the lattice.

### 4. Nests as a bridge to point-level reasoning

The formalization shows that the set of all intervals that meet at a common point (a “nest”) recovers the ordering properties of points without introducing a separate point datatype. In Doccer this suggests a clean way to expose point queries or “starts-at / ends-at” constraints while staying inside the existing interval substrate: a nest is simply the set of claims that share an endpoint under the meets relation. You already have the primitives (`Relate` returns Meets/MetBy); the formalization tells you that collecting those claims into an ordered nest is mathematically well-behaved.

### 5. Separation of algebraic soundness from algorithmic acceleration

Ghourabi proves only the pure algebraic table; complexity and path-consistency algorithms are left to the literature (ORD-Horn, etc.). This matches Doccer’s existing design posture: the reference `Join` carries an explicit “no performance contract”. Composition can be introduced the same way—first a pure, total function that returns a (possibly multi-relation) result, later replaced by indexed or bit-vector implementations under F4—while the Isabelle theorems continue to guarantee that every accelerated version remains correct.

### Practical next steps suggested by the formalization

- Import (or regenerate from the meets axioms) the 13×13 table as a static lookup; the Isabelle development already enumerates every entry.
- Expose a pure operator
  `AllenRelation[] Compose(AllenRelation r1, AllenRelation r2)`
  (or a bit-mask version) whose contract is exactly the verified table.
- Use the named composites \(\alpha,\beta,\gamma\) as the intermediate language for any future constraint-propagation layer over claims.
- Treat nests as a derived view over a `SpanBatch` filtered by Meets/MetBy; the formalization guarantees that the induced order is a strict total order on the shared points.

In short, the formalization supplies a machine-checked foundation, a compact intermediate vocabulary, a systematic case-analysis discipline, and a clean ontological bridge to points—all of which map directly onto the design choices Doccer faces at the composition frontier. The algebraic core can be made total and verified first; algorithmic acceleration remains a later, orthogonal concern, exactly as the reference Join was handled.
