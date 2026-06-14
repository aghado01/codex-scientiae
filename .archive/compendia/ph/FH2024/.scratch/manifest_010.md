# Manifest: Page 010

## REPAIR_MATH
- RAW: ```
e \colon \varprojlim M | _ { L } \to \varprojlim M , \ \ ( v _ { p } ) _ { p \in L } \mapsto ( w _ { q } ) _ { q \in P } ,
```
  FIX: ```
$$
e \colon \varprojlim M | _ { L } \to \varprojlim M , \ \ ( v _ { p } ) _ { p \in L } \mapsto ( w _ { q } ) _ { q \in P } ,
$$
```
- RAW: ```
h \colon \varprojlim M | _ { U } \to \varprojlim M , \ \ [ v _ { p } ] \mapsto [ v _ { p } ] \ \ \forall p \in U , \ v _ { p } \in M _ { p } .
```
  FIX: ```
$$
h \colon \varprojlim M | _ { U } \to \varprojlim M , \ \ [ v _ { p } ] \mapsto [ v _ { p } ] \ \ \forall p \in U , \ v _ { p } \in M _ { p } .
$$
```
- RAW: ```
\lim _ { \leftarrow } M | _ { L } \stackrel { \xi } { \longrightarrow } & \lim _ { \longrightarrow } M | _ { U } \\ \downarrow & e \quad \downarrow h \\ \lim _ { \leftarrow } M \stackrel { \psi _ { M } } { \longrightarrow } & \lim _ { \longrightarrow } M .
```
  FIX: ```
$$
\lim _ { \leftarrow } M | _ { L } \stackrel { \xi } { \longrightarrow } & \lim _ { \longrightarrow } M | _ { U } \\ \downarrow & e \quad \downarrow h \\ \lim _ { \leftarrow } M \stackrel { \psi _ { M } } { \longrightarrow } & \lim _ { \longrightarrow } M .
$$
```
- RAW: ```
\min ( I ) = \{ p \in I \colon \text { there is no } q \in I \text { s.t. } q < p \} ,
```
  FIX: ```
$$
\min ( I ) = \{ p \in I \colon \text { there is no } q \in I \text { s.t. } q < p \} ,
$$
```
- RAW: ```
\max ( I ) = \{ p \in I \colon \text { there is no } q \in I \text { s.t. } p < q \} .
```
  FIX: ```
$$
\max ( I ) = \{ p \in I \colon \text { there is no } q \in I \text { s.t. } p < q \} .
$$
```
- RAW: ```
\Gamma _ { \min } \colon p _ { 0 } , ( p _ { 0 } \vee p _ { 1 } ) , p _ { 1 } , ( p _ { 1 } \vee p _ { 2 } ) , \dots , ( p _ { k - 1 } \vee p _ { k } ) , p _ { k } ,
```
  FIX: ```
$$
\Gamma _ { \min } \colon p _ { 0 } , ( p _ { 0 } \vee p _ { 1 } ) , p _ { 1 } , ( p _ { 1 } \vee p _ { 2 } ) , \dots , ( p _ { k - 1 } \vee p _ { k } ) , p _ { k } ,
$$
```
- RAW: ```
\Gamma _ { \max } \colon q _ { 0 } , ( q _ { 0 } \wedge q _ { 1 } ) , q _ { 1 } , ( q _ { 1 } \wedge q _ { 2 } ) , \dots , ( q _ { l - 1 } \wedge q _ { l } ) , q _ { l } .
```
  FIX: ```
$$
\Gamma _ { \max } \colon q _ { 0 } , ( q _ { 0 } \wedge q _ { 1 } ) , q _ { 1 } , ( q _ { 1 } \wedge q _ { 2 } ) , \dots , ( q _ { l - 1 } \wedge q _ { l } ) , q _ { l } .
$$
```
- RAW: `where for all q ∈ P , w q is defined as M ( p ≤ q )( v p ) for any p ∈ L ∩ { r ∈ P : r ≤ q } and by the map`
  FIX: `where for all \( q \in P \), \( w_q \) is defined as \( M(p \leq q)(v_p) \) for any \( p \in L \cap \{ r \in P \colon r \leq q \} \) and by the map`
- RAW: `Note that the canonical section extension map e is well-defined since L ∩{ r ∈ P : r ≤ q } is a connected set.`
  FIX: `Note that the canonical section extension map \( e \) is well-defined since \( L \cap \{ r \in P \colon r \leq q \} \) is a connected set.`
- RAW: `The inverse r = e − 1 is the canonical section restriction. Furthermore, the other isomorphism h is well-defined because of Proposition 2.18. Keeping the maps that we defined in the proof of the last Proposition, we set ξ = h − 1 ◦ ψ M ◦ e , i.e. we obtain the commutative diagram`
  FIX: `The inverse \( r = e^{-1} \) is the canonical section restriction. Furthermore, the other isomorphism \( h \) is well-defined because of Proposition 2.18. Keeping the maps that we defined in the proof of the last Proposition, we set \( \xi = h^{-1} \circ \psi_M \circ e \), i.e. we obtain the commutative diagram`
- RAW: `Due to the fact that e and h are isomorphisms we have rank ξ = rank ψ M .`
  FIX: `Due to the fact that \( e \) and \( h \) are isomorphisms we have \( \operatorname{rank} \xi = \operatorname{rank} \psi_M \).`
- RAW: `For an interval I , denote by min( I ) and max( I ) the set of minimal and maximal elements, respectively, i.e.`
  FIX: `For an interval \( I \), denote by \( \min(I) \) and \( \max(I) \) the set of minimal and maximal elements, respectively, i.e.`
- RAW: `The least upper bound and the greatest lower bound of two elements p,q ∈ P are denoted by p ∨ q and p ∧ q , respectively.`
  FIX: `The least upper bound and the greatest lower bound of two elements \( p, q \in P \) are denoted by \( p \vee q \) and \( p \wedge q \), respectively.`
- RAW: `In our work, we will regard persistence modules that are indexed by a subset of 2 , which, however, do not have the usual partial order as 2 .`
  FIX: `In our work, we will regard persistence modules that are indexed by a subset of \( \mathbb{R}^2 \), which, however, do not have the usual partial order as \( \mathbb{R}^2 \).`
- RAW: `We sort the elements of min( I ) and max( I ) in ascending order by their x coordinates and the elements of max( I ) in descending order, i.e. min( I ) = { p 0 ,p 1 ,...,p k } and max( I ) = { q 0 ,q 1 ,...,q l } . Then, we define the two paths`
  FIX: `We sort the elements of \( \min(I) \) and \( \max(I) \) in ascending order by their \( x \) coordinates and the elements of \( \max(I) \) in descending order, i.e. \( \min(I) = \{ p_0, p_1, \dots, p_k \} \) and \( \max(I) = \{ q_0, q_1, \dots, q_l \} \). Then, we define the two paths`
- RAW: `Clearly, the set of elements in Γ min is a lower fence of M and the set of elements in Γ max is an upper fence of M .`
  FIX: `Clearly, the set of elements in \( \Gamma_{\min} \) is a lower fence of \( M \) and the set of elements in \( \Gamma_{\max} \) is an upper fence of \( M \).`
- RAW: `Definition 2.22 We define the path Γ ∂I of an interval I ⊂ P as the path obtained by composing Γ min , any arbitrary path Γ ′ between p k and q l (or p 0 and q 0 ) and Γ max . Further, for a persistence module M we denote by M ∂I its restriction to the path, i.e. M | Γ ∂I .`
  FIX: `**Definition 2.22** We define the path \( \Gamma_{\partial I} \) of an interval \( I \subset P \) as the path obtained by composing \( \Gamma_{\min} \), any arbitrary path \( \Gamma' \) between \( p_k \) and \( q_l \) (or \( p_0 \) and \( q_0 \)) and \( \Gamma_{\max} \). Further, for a persistence module \( M \) we denote by \( M_{\partial I} \) its restriction to the path, i.e. \( M|_{\Gamma_{\partial I}} \).`
- RAW: `The difference between our theorem and the theorem in [9] is that we proved it for more general paths Γ ∂I .`
  FIX: `The difference between our theorem and the theorem in [9] is that we proved it for more general paths \( \Gamma_{\partial I} \).`

## REPAIR_PROSE
- RAW: `[Page 10]`
  FIX: ``

