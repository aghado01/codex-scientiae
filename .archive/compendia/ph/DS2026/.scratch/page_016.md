[Page 16]

## A Formal Definitions and Proofs for Stability of ZZ-GRIL

There is a notion of proximity on the space of zigzag modules in terms of the interleaving distance . In Botnan & Lesnick (2018), the authors define interleaving distance between two zigzag modules by including them into R op × R -indexed modules.

The interleaving distance on R n -indexed persistence modules is known and well-defined. We briefly recall the definition here. We refer the readers to Botnan & Lesnick (2018) for additional details. n n

Definition A.1 ( u -shift functor) . The u -shift functor ( − ) u : vec R → vec R , for u ∈ R n , is defined as follows:

- 1. For M ∈ vec R n , M u is defined as M u ( x ) = M ( x + u ) for all x ∈ R n and M u ( x 1 ≤ x 2 ) = M ( x 1 + u ≤ x 2 + u ) for all x 1 ≤ x 2 ∈ R n ,
- 2. Let M,N ∈ vec R n . Let F : M → N be a morphism. Then, the corresponding morphism F u : M u → N u is defnied as F u ( x ) = F ( x + u ): M u ( x ) → N u ( x ) for all x ∈ R n .


Definition A.2 ( ϵ -interleaving) . Let M,N ∈ vec R n . Let ϵ ∈ [0 , ∞ ) be given. We will denote ( − ) ϵ to be the shift functor corresponding to the vector ϵ = ϵ (1 , 1 ,..., 1) . We say M and N are ϵ -interleaved if there are natural transformations F : M → N ϵ and G : N → M ϵ such that

$$
1 . \ G _ { \epsilon } \circ F = \varphi _ { M } ^ { 2 \epsilon } ,
$$

$$
2 . \ F _ { \epsilon } \circ G = \varphi _ { N } ^ { 2 \epsilon } ,
$$

where φ u M : M → M u is the natural transformation whose restriction to each M ( x ) is the linear map M ( x ≤ x + u ) for all x ∈ R n . n

Definition A.3 (Interleaving distance) . Let M,N ∈ vec R . The interleaving distance d I ( M,N ) between M and N is defined as

$$
d _ { \mathcal { I } } ( M , N ) \coloneqq \inf \{ \epsilon \geq 0 \colon M \text { and } N \text { are } \epsilon \text {-interleaved} \}
$$

and d I ( M,N ) = ∞ if there exists no interleaving.

We need the following two definitions to define interleaving distance between two zigzag modules.

Definition A.4 (Left Kan Extension) . Let P and Q be two posets. Let F : P → Q be a functor. Let P [ F ≤ q ] denote the set P [ F ≤ q ] : = { p ∈ P : F ( p ) ≤ q } . Given a persistence module M : P → vec , the left Kan extension of M along F is a functor Lan F ( M ): Q → vec given by

$$
L a n _ { F } ( M ) ( q ) \coloneqq \text {colm} M | _ { P [ F \leq q ] } ,
$$

along with internal morphisms given by the universality of colimits.

Definition A.5 (Block Extension Functor Botnan & Lesnick (2018)) . Let U ⊂ R op × R denote the poset U : = { ( a,b ): a ≤ b } . Let i : ZZ → R op × R denote the inclusion. Let ( − ) | U : vec R op × R → vec U denote the restriction. Then, the block extension functor E : vec ZZ → vec U is defined as

$$
E \coloneqq ( - ) | _ { U } \circ L a n _ { i } ( \circ ) .
$$

Definition A.6 (Interleaving distance on zigzag modules) . Let M,N be two zigzag modules. Then

$$
d _ { \mathcal { I } } ( M , N ) \coloneqq d _ { \mathcal { I } } ( E ( M ) , E ( N ) ) .
$$

We extend this definition of interleaving distance to quasi zigzag persistence modules. Let UU ⊂ R op × R × R be the analog of U , i.e, UU : = { ( a,b,c ): a ≤ b } . Let ˜ i : ZZ × Z → R op × R × R denote the inclusion. Then, define ˜ E : = ( − ) | UU ◦ Lan ˜ i ( ◦ ) , analogous to the block extension functor.

Definition A.7. Let M,N be two quasi zigzag persistence modules. Then, the interleaving distance between M and N is given by

$$
d _ { \mathcal { I } } ( M , N ) \coloneqq d _ { \mathcal { I } } ( \tilde { E } ( M ) , \tilde { E } ( N ) ) .
$$

I I Lemma A.8. ˜ E sends interval modules on ZZ × Z to block interval modules.

This is analogous to Lemma 4.1 in Botnan & Lesnick (2018).

Lemma A.9. Let M be a quasi zigzag persistence module. If M ∼ = k ∈ K I k , then ˜ E ( M ) ∼ = k ∈ K ˜ E ( I k ) , where K is an indexing set.
