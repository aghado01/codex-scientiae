[Page 4]

Understanding P -persistence modules thus boils down to understanding indecomposables (indexed by P ). For P = , it turns out that indecomposables are precisely interval modules, leading to Theorem 6.36. However, for general P , the situation is much more complicated. Without going into details: It is not possible to parameterize indecomposables in terms of some nice family of subsets of P . The decomposition of Theorem 9.9 therefore does not lead to a workable notion of barcode in general. In fact, it is not possible to deﬁne any reasonable notion of a barcode for P -persistence modules, in the following sense.

Deﬁnition 9.10. Let ( P, ) be a poset and let be a P -persistence module. We say a multiset B of subsets of P is a reasonable barcode for if

$$
\ r a n k ( u _ { p , p ^ { \prime } } ) = | \{ B \in \mathcal { B } \colon p , p ^ { \prime } \in B \} | \quad ( \forall p \preceq p ^ { \prime } ) . \\
$$

That is, the rank of the map u p,p 0 : U p ! U p 0 can be computed by counting the number of ‘bars’ that contain both p and p 0 .

Exercise 9.11. Show that the usual barcode for a p.f.d. persistence module indexed by is reasonable in the above sense.

Exercise 9.12. For p 2 P , show that dim U p is greater than or equal to the number of bars that contain p in a reasonable barcode for .

Example 9.13. Let P = { 0,1,2 } ⇥ { 0,1,2 } and consider the following persistence module indexed by P :

$$
\mathbb { F } & \longrightarrow \mathbb { F } \longrightarrow 0 & f & \colon a & \mapsto ( a , 0 ) \\ \text {id} & \widehat { g } & \widehat { \uparrow } & g & \colon ( a , b ) & \mapsto a \\ \mathbb { U } & = \mathbb { F } \longrightarrow \mathbb { F } ^ { 2 } & \mathbb { F } & \, \mathbb { F } \, , & \text {where} & h & \colon ( a , b ) & \mapsto a + b \\ & \widehat { \uparrow } & \widehat { j } & \widehat { \uparrow } & \text {id} & j & \colon a & \mapsto ( 0 , a ) \\ & 0 & \longrightarrow \mathbb { F } \longrightarrow \mathbb { F } \\ \text {We claim} \mathbb { U } & \, \text {can not have a reasonable hargcode} \, \text {to see this, sumpose}
$$

We claim cannot have a reasonable barcode. To see this, suppose B is a reasonable barcode for . Note that

$$
\ r a n k ( h \circ f ) & = \text {rank} ( g \circ f ) = \text {rank} ( h \circ j ) = 1 . \\
$$

By the reasonability assumption, there thus must be subsets I,J,K 2 B with

$$
( 0 , 1 ) , ( 2 , 1 ) \in I , \quad ( 0 , 1 ) , ( 1 , 2 ) \in J , \quad ( 1 , 0 ) , ( 2 , 1 ) \in K .
$$

Since dim U 0,1 = dim U 2,1 = 1 , we know by Exercise 9.12 that ( 0,1 ) and ( 2,1 ) occur in at most one element of B . But that means that I = J , and I = K , and so in fact I = J = K ◆ { ( 0,1 ) , ( 2,1 ) , ( 1,2 ) } . Thus, using reasonability again, we ﬁnd that

$$
\text {rank} ( g \circ j ) & \geqslant 1 , \\
$$

contradicting the fact that g j = 0 .
