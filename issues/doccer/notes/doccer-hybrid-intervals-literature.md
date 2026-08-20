Good—now I understand what you actually have and what you mean. The Andrikopoulos paper (arXiv:2002.02005) proposes replacing pure Allen/interval-order realizers with **hybrid realizers** whose dimension is always ≤ classical linear order dimension, with acyclicity as the necessary-and-sufficient condition for all extension and realizability results. Your notes are precise.

The relevant literature tree for grounding that development in `doccer` has four distinct branches. I'll be specific about what each branch contributes and what it doesn't.

## Branch 1: The foundational order-dimension papers

These are required background for Andrikopoulos. Read them in this sequence:

**1a. Fishburn (1970) — _Intransitive Indifference with Unequal Indifference Intervals_ (J. Math. Psychology)**
The semiorder axioms: irreflexivity, the Scott-Suppes representation \(x \succ y \Leftrightarrow f(x) > f(y) + 1\). This is the scalar realization that replaces a two-endpoint interval with a center-plus-unit-threshold model. Not on arXiv—find it through JSTOR or a library. This is foundational to understanding why semiorders are strictly between linear orders and interval orders.

**1b. Dushnik & Miller (1941) — _Partially Ordered Sets_ (Amer. J. Math.)**
The classical linear order dimension: minimum number of linear extensions whose intersection is the partial order. Also not arXiv. The hybrid dimension from Andrikopoulos is directly defined in analogy to this.

**1c. Trotter — _Combinatorics and Partially Ordered Sets_ (Johns Hopkins, 1992)**
The standard reference for order dimension, interval orders, and semiorders as a unified theory. Not a paper but a book; chapter 8 on interval orders and chapter 11 on dimension are the relevant parts. Heavily cited in Andrikopoulos.

## Branch 2: Interval orders and semiorders — key arXiv-available papers

**2a. Bogart, Fishburn, Isaak, Langley — _Proper and Unit Interval Graphs_ (Discrete Applied Math, 1995)**
Not on arXiv directly, but arXiv:math/9811073 (Fishburn) and related papers provide the background on unit interval orders = semiorders. The key fact for `doccer`: a semiorder has a representation where all intervals have equal length—which is exactly the structure relevant for canonical or normalized tokenization schemes where you want consistent segment widths.

**2b. Bogart & West (1999) — _A short proof that 'proper = unit'_**
arXiv:math/9811073v1. Establishes that proper interval orders (no interval properly contains another) are identical to unit interval orders. Directly relevant: doccer's `LaminarView` is the no-proper-containment structural family; the proper/unit identity is the precise theorem that says your laminar structures are realizable as unit intervals.

**2c. Fishburn (1985) — _Interval Orders and Interval Graphs_ (Wiley)**
The book-length treatment. Particularly relevant are the chapters on interval dimension and the relationships between interval, semiorder, and weak order. Your `AllenRelationSet` and `LocatedRelation` together already implement the geometric substrate; this book tells you what dimension-theoretic consequences that substrate has.

## Branch 3: Directly adjacent to Andrikopoulos — hybrid and linear-interval orders

**3a. Fishburn (1970) — _Conditions for simple majority rule with intransitive individual indifference_ (J. Economic Theory)**
Original source for linear orders intersected with interval orders. Andrikopoulos cites this as the origin of the "linear-interval" terminology. Not arXiv; accessible through JSTOR.

**3b. Mitas (1995) — _Interval Dimension is a Function of Containment Dimension_ (Order, 12(1))**
The key result: interval dimension ≤ containment dimension. If you implement a containment/laminar structure (which you have, via `LaminarHierarchy` and `HierarchyView`), you get a bound on the interval dimension of the associated partial order for free. Directly useful for complexity analysis of any K8 cross-carrier integration.

**3c. Habib, Morvan, Pouzet, Rampon (1993) — _Extensions of an Order on an Interval Dimension_ (Order)**
Establishes algorithmic results for computing interval dimension. The recognition algorithms here ground any implementation of hybrid realizer construction in `doccer` in concrete complexity bounds.

**3d. Felsner & Trotter (1993) — _Colorings of Diagrams of Interval Orders and α-sequences of Sets_ (Discrete Math)**
Relevant for the relationship between interval-order dimension and hypergraph coloring, which surfaces when you try to assign canonical layer/level labels to `ResolutionMap` entries consistently across compatible masters.

## Branch 4: The doccer-specific applications

These papers tell you what hybrid intervals would _buy_ operationally in a document structure/text analysis context.

**4a. Pighizzini & Shallit — _Unary Language Operations, State Complexity and Jacobsthal's Function_ (2002)**
arXiv:cs/0201028. Interval automata over strings. Relevant to the `Utf16UnitMask` / `BooleanVector` relationship to scan automata: if a scan over a Unicode master is characterized by a state machine whose transitions are interval-labeled over codepoint ranges, the dimension of the underlying interval order bounds the state complexity of the recognizer. Not a direct dependency but useful for the V2 acceleration design gate (D42).

**4b. Klavík et al. — _Minimal Obstructions for Partial Representations of Interval Graphs_ (2013)**
arXiv:1302.3088. Partial interval representations: given a partial assignment of intervals to some vertices of an interval graph, when can it be extended? This is directly the `OffsetMap` problem: given partial knowledge of source-to-output position mappings (from TeXdig's parser gaps), when can the partial map be extended to a complete consistent interval representation, and what are the obstructions?

**4c. Mertzios et al. — _The Recognition of Tolerance and Bounded Tolerance Graphs_ (2011)**
arXiv:1010.5760. Tolerance graphs generalize interval graphs by allowing overlap up to a tolerance parameter. Relevant to doccer's Tier-2/Tier-3 acceptance work (deferred in the README): when two claim occurrences "agree" up to a tolerance, you want to know whether the resulting structure is still tractable (recognizable in polynomial time) or whether you've crossed into NP-hard territory.

**4d. Cornelsen & Schreiber — _Partial and Constrained Level Planarity_ (2016)**
arXiv:1602.06130. Level planarity for partially constrained graph drawings, which is the combinatorial problem underlying `ResolutionMap` layer assignment when documents have cross-referencing or non-local structure. The connection to hybrid intervals: a hybrid realizer that mixes linear and interval orders is, geometrically, exactly a level-planar embedding constraint.

## How these map to the K8 contract

Looking at your discussions directory—particularly [`sol-doccer-compositional-kernel-and-formalisms-20260804.md`](https://github.com/aghado01/codex-scientiae/blob/main/issues/doccer/discussions/sol-doccer-compositional-kernel-and-formalisms-20260804.md) (238KB, the largest discussion file) and the expansion-deep-dive series—the K8 cross-carrier integration question is almost certainly going to be: what is the correct relation between `ClaimPairView` geometry and `OriginRelation` geometry when the source and output masters are different and the transformation is non-trivial?

The Andrikopoulos result answers this precisely: the intersection of a linear order (the output's `seq`-ordered reading) and an interval order (the source's geometric containment structure) is exactly a linear-interval order, and its extension and realizability require only acyclicity. That means the composition of K6 origin relations across a macro-expansion or paragraph-reflow transformation has a valid hybrid realizer if and only if the composed relation is acyclic—no stronger condition is needed to guarantee that a consistent joint coordinate assignment exists.

That is the specific technical contribution of arXiv:2002.02005 to `doccer`, read through the code rather than in the abstract.
