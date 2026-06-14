[Page 18]

2. On morphisms: given a morphism between extended zigzag modules f : M → N , for each z ∈ we implicitly have a morphism between zigzag modules f z : M ( · ,z ) → N ( · ,z ) . Again by universality of limits and colimits we obtain a morphism E ( f z ) : E ( M ( · ,z )) → E ( N ( · ,z )) for each z . It remains to show that this is indeed a natural transformation, i.e. that the square commutes for all z 1 ≤ z 2

$$
\begin{array}{ccc}
E(M(\cdot, z_1)) & \longrightarrow & E(M(\cdot, z_2)) \\
\downarrow {\scriptstyle E(f_{z_1})} & & \downarrow {\scriptstyle E(f_{z_2})} \\
E(N(\cdot, z_1)) & \longrightarrow & E(N(\cdot, z_2))
\end{array}
$$

which again is a consequence of the universality of limits and colimits.

Alternatively, one could define the functor E in analogy to the block extension functor E . For this, consider the inclusion ˜ ι : ZZ × → op × × defined as

$$
\tilde{\ell}(i, z) = \begin{cases} 
(i, i, z) & \text{if } i \text{ is a sink index,} \\ 
(i + 1, i - 1, z) & \text{if } i \text{ is a source index.} 
\end{cases}
$$

In this case, by source index we mean that i is a source index in ZZ and by sink index that i is a sink index in ZZ . Now, regard the set

$$
\tilde{U} \coloneqq \{ (x, y, z) \in \mathbb{Z}^{op} \times \mathbb{Z} \times \mathbb{Z} \mid x \leq y \} ,
$$

as well as the inclusion ˜ κ : ˜ U → op × × . Then, E can be defined as the composition of three functors

$$
\mathcal{E} \coloneqq \text{Ran}_{\tilde{\kappa}} \circ (-)|_{\tilde{U}} \circ \text{Lan}_{\tilde{\ell}} \colon \text{vec}^{\mathbb{Z} \times \mathbb{Z}} \to \text{vec}^{\mathbb{Z}^{op} \times \mathbb{Z} \times \mathbb{Z}}.
$$

To see that E ( M )( · , · ,z ) = E ( M ( · ,z )) it is again sufficient to recall the considerations in Lemma 4.4 and the fact that limits and colimits depend only on lower and upper fences, respectively. Indeed, we get the explicit formulation

$$
\mathcal{E}(M)(x, y, z) \coloneqq \begin{cases} 
\varprojlim M(\cdot, z)|_{[x, y]} & \text{for } x \leq y, \\ 
\varinjlim M(\cdot, z)|_{[y, x]} & \text{for } x > y. 
\end{cases}
$$

The structure maps are, again, maps that are given by the universal properties of limits and colimits.

The subsequent proposition is an extension of Prop. 4.3 in [3] and it will not be used anywhere else in this paper. We state it for sake of completeness.

Proposition 4.5 The functor E is fully faithful, i.e. the set of morphisms from M to N is isomorphic to the set of morphisms from E ( M ) to E ( N ) for all extended zigzag modules M and N .

Proof: The first part of the proof that ( − ) | ˜ U ◦ Lan ˜ ι is fully faithful is analogue to the proof of Prop. 4.3 in [3]. We formulate the dual arguments to show that Ran ˜ κ is fully faithful. It is known that the right Kan extension is right adjoint to the restriction functor ( − ) | ˜ U (see [33], (1.1)). By Theorem IV.3.1 in [22], a right adjoint is fully faithful if and only if the counit of the adjunction is a natural isomorphism. This is easy to see since ( − ) | ˜ U ◦ Ran ˜ κ ( M ) ∼ = M for any extended zigzag module M . In total, E is fully faithful as a composition of fully faithful functors. □
