[Page 51]

Case 1. By ( Asashiba et al. 2022 , Theorem 17 (2.6)) (the dual of Theorem 3.3 ) and Lemma 2.10 , we have

d M ( V I ) = dim Hom A ( M, τV I ) − dim Hom A ( M, E I ) + dim Hom A ( M, V I )

$$
d _ { M } ( V _ { 1 } ) & = \dim H o m _ { A } ( M , \tau _ { V _ { 1 } } ) - \dim H o m _ { A } ( M , E _ { 1 } ) + \dim H o m _ { A } ( M , V _ { 1 } ) \\ & = \left ( \sum _ { i \in [ m ] } \dim ( \tau V _ { 1 } ) ( x _ { i } ) - \rank ( \tau V _ { 1 } ) ( \alpha ) \right ) - \left ( \sum _ { i \in [ m ] } \dim E _ { 1 } ( x _ { i } ) - \rank E _ { 1 } ( \alpha ) \right ) \\ & + \left ( \sum _ { i \in [ m ] } \dim V _ { 1 } ( x _ { i } ) - \rank V _ { 1 } ( \alpha ) \right ) \\ & = \rank F _ { i } ( 0 ) - \rank V _ { i } ( \alpha ) - \rank ( \tau V _ { 1 } ) ( \alpha )
$$

= rank E I ( α ) − rank V I ( α ) − rank ( τV I )( α )

because i ∈ [ m ] (dim( τV I )( x i ) − dim E I ( x i )+dim V I ( x i )) = 0 by the exactness of the almost split sequence.

Case 2. In this case, we have V I = V ↑ a ∼ = P a , rad P a = V ⇑ a , and V I /V ⇑ a ∼ = V { a } . By ( Asashiba et al. 2022 , Theorem 17 (2.5)), we have

d M ( V I ) = dim Hom A ( M, P a ) − dim Hom A ( M, rad P a )

$$
d _ { M } ( V _ { I } ) & = \dim H o m _ { A } ( M , P _ { a } ) - \dim H o m _ { A } ( M , r a d \, P _ { a } ) \\ & = \left ( \sum _ { i \in [ m ] } \dim V _ { \uparrow a } ( x _ { i } ) - \text { rank } V _ { \uparrow a } ( \alpha ) \right ) - \left ( \sum _ { i \in [ m ] } \dim V _ { \uparrow a } ( x _ { i } ) - \text { rank } V _ { \uparrow a } ( \alpha ) \right ) \\ & = \sum _ { i \in [ m ] } \dim V _ { \{ a \} } ( x _ { i } ) + \text { rank } V _ { \uparrow a } ( \alpha ) - \text { rank } V _ { \uparrow a } ( \alpha ) \\ & = \sum _ { i \in [ m ] } \delta _ { a , x _ { i } } + \text { rank } V _ { \uparrow a } ( \alpha ) - \text { rank } V _ { \uparrow a } ( \alpha ) \\ & = \text { rank } V _ { \uparrow a } ( \alpha ) - \text { rank } V _ { \uparrow a } ( \alpha ) + n _ { M , I } .
$$

= rank V ⇑ a ( α ) − rank V ↑ a ( α ) + n M,I .

Hence the assertion follows from the following:

$$
V _ { \uparrow a } ( a _ { j i } p _ { j , x _ { i } } ) = \begin{cases} a _ { j i } & \text {if } a \leq x _ { i } , y _ { j } , \\ 0 & \text {otherwise} , \end{cases} \quad \text {and} \quad V _ { \uparrow a } ( a _ { j i } p _ { j , x _ { i } } ) = \begin{cases} a _ { j i } & \text {if } a < x _ { i } , y _ { j } , \\ 0 & \text {otherwise} . \end{cases} \quad \Box
$$

For convenience, P ( α ) in ( 5.61 ) is called a presentation matrix of M . We now exhibit an example of the application of Theorem 5.1 .

Example 5.2. Let P = G 4 , 2 and I ∈ I be as in Example 3.37 . Then each term of the almost split sequence 0 → τV I → E I → V I → 0 ending in V I is given as follows:

$$
\begin{array} { c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c c
$$

and E I = E 1 ⊕ E 2 , where

$$
E _ { 1 } \colon \begin{array} { c c c c c c c c } & & & [ \frac { 1 } { 0 } ] & & & & k \stackrel { [ 1 ] } { \longrightarrow } k \stackrel { [ 1 , 1 ] } { \longrightarrow } k \stackrel { 1 } { \longrightarrow } \, | k \longrightarrow k \longrightarrow 0 & & & k \stackrel { 1 } { \longrightarrow } k \stackrel { 1 } { \longrightarrow } k \stackrel { 1 } { \longrightarrow } | k & & & \\ & & & & & & & & & & & \\ E _ { 1 } \colon \begin{array} { c c c c c c c } & & & & [ 0 ] \uparrow & & & 1 \uparrow & & & 1 \uparrow & & \uparrow \, , & E _ { 2 } \colon \begin{array} { c c c c c c } & & & & & & & & & & & \\ & & & & & & & & & & & \\ & & & & & & & & & & & & \\ & & 0 \longrightarrow k \stackrel { 1 } { \longrightarrow } k \stackrel { 1 } { \longrightarrow } | k \stackrel { 1 } { \longrightarrow } k & & & & & & & & & 0 \longrightarrow k \stackrel { 1 } { \longrightarrow } k \stackrel { 1 } { \longrightarrow } | k & & & & \end{array} \end{array} .
$$
