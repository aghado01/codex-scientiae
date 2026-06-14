[Page 10]

The isomorphisms in Proposition 2.21 are given by the canonical section extension map

$$
e \colon \varprojlim M | _ { L } \to \varprojlim M , \ \ ( v _ { p } ) _ { p \in L } \mapsto ( w _ { q } ) _ { q \in P } ,
$$

where for all q ∈ P , w q is defined as M ( p ≤ q )( v p ) for any p ∈ L ∩ { r ∈ P : r ≤ q } and by the map

$$
h \colon \varprojlim M | _ { U } \to \varprojlim M , \ \ [ v _ { p } ] \mapsto [ v _ { p } ] \ \ \forall p \in U , \ v _ { p } \in M _ { p } .
$$

Note that the canonical section extension map e is well-defined since L ∩{ r ∈ P : r ≤ q } is a connected set. The inverse r = e − 1 is the canonical section restriction. Furthermore, the other isomorphism h is well-defined because of Proposition 2.18. Keeping the maps that we defined in the proof of the last Proposition, we set ξ = h − 1 ◦ ψ M ◦ e , i.e. we obtain the commutative diagram

$$
\lim _ { \leftarrow } M | _ { L } \stackrel { \xi } { \longrightarrow } & \lim _ { \longrightarrow } M | _ { U } \\ \downarrow & e \quad \downarrow h \\ \lim _ { \leftarrow } M \stackrel { \psi _ { M } } { \longrightarrow } & \lim _ { \longrightarrow } M .
$$

Due to the fact that e and h are isomorphisms we have rank ξ = rank ψ M . In total, since the limit of a diagram is isomorphic to the limit of the diagram restricted to a lower fence and analogously for the colimit and a upper fence, we can compute the generalized rank of a diagram by only calculating limits and colimits of lower and upper fences and taking the canonical map between them.

For an interval I , denote by min( I ) and max( I ) the set of minimal and maximal elements, respectively, i.e.

$$
\min ( I ) = \{ p \in I \colon \text { there is no } q \in I \text { s.t. } q < p \} ,
$$

$$
\max ( I ) = \{ p \in I \colon \text { there is no } q \in I \text { s.t. } p < q \} .
$$

The least upper bound and the greatest lower bound of two elements p,q ∈ P are denoted by p ∨ q and p ∧ q , respectively.

In our work, we will regard persistence modules that are indexed by a subset of 2 , which, however, do not have the usual partial order as 2 . We will specify the partial order in the next section. We sort the elements of min( I ) and max( I ) in ascending order by their x coordinates and the elements of max( I ) in descending order, i.e. min( I ) = { p 0 ,p 1 ,...,p k } and max( I ) = { q 0 ,q 1 ,...,q l } . Then, we define the two paths

$$
\Gamma _ { \min } \colon p _ { 0 } , ( p _ { 0 } \vee p _ { 1 } ) , p _ { 1 } , ( p _ { 1 } \vee p _ { 2 } ) , \dots , ( p _ { k - 1 } \vee p _ { k } ) , p _ { k } ,
$$

$$
\Gamma _ { \max } \colon q _ { 0 } , ( q _ { 0 } \wedge q _ { 1 } ) , q _ { 1 } , ( q _ { 1 } \wedge q _ { 2 } ) , \dots , ( q _ { l - 1 } \wedge q _ { l } ) , q _ { l } .
$$

Clearly, the set of elements in Γ min is a lower fence of M and the set of elements in Γ max is an upper fence of M .

Definition 2.22 We define the path Γ ∂I of an interval I ⊂ P as the path obtained by composing Γ min , any arbitrary path Γ ′ between p k and q l (or p 0 and q 0 ) and Γ max . Further, for a persistence module M we denote by M ∂I its restriction to the path, i.e. M | Γ ∂I .

The following theorem is a slight variation of Theorem 24 in [9] and hence, the proof differs only slightly from the proof given in [9]. The difference between our theorem and the theorem in [9] is that we proved it for more general paths Γ ∂I . The entire proof can be found in Appendix B.
