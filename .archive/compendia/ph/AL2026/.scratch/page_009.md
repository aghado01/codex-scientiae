[Page 9]

Roughly speaking, the essential cover \(\zeta \colon Z \to P\) is an order-preserving map, and we say that \(\zeta\) essentially covers an interval \(I\) (resp. relative to compression systems ) if morphisms in \(P\) that appear in formula (1.2) have preimages in \(Z\), subject to some mild technical conditions. We refer the reader to Definition 4.12 for the detailed definition. Then we have the next main result.

Main result C (Theorem 4.16). Let \(M \in \operatorname{mod} k[P]\), and \(I\) an interval of \(P\). If \(\zeta \colon Z \to P\) essentially covers \(I\), then we have

$$
\[
d_{M}(V_{I}) = \bar{d}_{R(M)}(R(V_{I})),
\]
$$

where \(R\) denotes the restriction functor induced by \(\zeta\), and \(\bar{d}_N(L)\) denotes the maximal number of copies of \(L\) that can be taken as a direct summand of \(N\) such that no further copies of \(L\) remain in the complement as direct summands.

We remark that in (1.4), If \(L\) is indecomposable, then \(\bar{d}_N(L)\) is just the usual multiplicity of \(L\) in \(N\). Note that it may happen that \(R(V_I)\) is decomposable. This is why \(\bar{d}\) is used here instead of \(d\) (see Remark 6.11).

For every interval of \(P\), equation (1.4) provides us with a method to transfer the computation of the interval multiplicity to the computation of corresponding multiplicity over another “essential” poset \(Z\). When \(P\) is a special type of poset, the “essential” poset \(Z\) can be taken as either a single zigzag poset or a directed tree formed by connecting several zigzag posets. This makes it possible to utilize algorithms designed for computing zigzag persistence (for example, Dey and Hou ( 2022 ); Milosavljević et al. ( 2011 ); Carlsson et al. ( 2009 )) to compute interval multiplicities. The idea of utilizing the computation of zigzag persistence for computing invariants has also been considered in the literature. For example, Dey and Xin ( 2024 ) recently achieve computing the generalized rank invariant by the unfolding process.

Our last main result gives a formula for computing interval multiplicities of a persistence module by utilizing its (minimal) projective presentation or injective copresentation, without knowing the structure (linear maps) of persistence module over arbitrary finite posets. Notably, the computation of the minimal (co)presentations of 2-parameter persistent homology has been actively studied in the literature, and many fast algorithms are currently available for this purpose. Lesnick and Wright ( 2022 ) first develop a way of computing the minimal projective presentation of 2parameter persistent homology. Later, Kerber and Rolle ( 2021 ); Fugacci et al. ( 2023 ) improve the pioneering work of Lesnick and Wright by some techniques such as multichunk Fugacci and Kerber ( 2019 ). Regarding the minimal injective copresentation, Bauer et al. ( 2023 ) propose a cohomological algorithm for computing minimal free resolutions of 2-parameter persistent cohomology.

Let us denote by \(P\) the extension of the Yoneda embedding \(Y^\bullet \colon k[P^{\operatorname{op}}] \to \operatorname{prj} k[P]\), \(x \mapsto P_x := k[P](x, -)\), where \(P_x\) denotes the projective indecomposable \(k[P]\)-module at \(x\). Similarly, by \(P'\) we denote the extension of the Yoneda embedding \(Y^\bullet \colon k[P] \to \operatorname{prj}(k[P^{\operatorname{op}}])\), \(x \mapsto P'_x := k[P](-, x)\). See Corollary 4.4 for details.
