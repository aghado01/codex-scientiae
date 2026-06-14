[Page 39]

$$
$$
\sup p { ( s o c \, Q ^ { j } ( V _ { I } ) ) \subseteq \sup p { ( s o c \, Q ^ { j } ( M ) ) } } \} ,
$$
$$

therefore, if i ≥ 1 , then inductively we have

$$
$$
\text {crit} _ { i } ( M ) = \{ I \in \text {crit} _ { i - 1 } ( M ) \, | \, \sup p ( \text {top} \, P _ { i } ( V _ { I } ) ) \subseteq \sup p ( \text {top} \, P _ { i } ( M ) ) , \\ \sup p ( \text {soc} \, Q ^ { i } ( V _ { I } ) ) \subseteq \sup p ( \text {soc} \, Q ^ { i } ( M ) ) \} .
$$
$$

For i = 0 , note that crt 0 ( M ) above coincides with that defined in Notation 3.38 by Proposition 3.18 .

The following is immediate by Corollary 3.44 .

Lemma 3.46. Let M ∈ mod A , I ∈ I , and i ≥ 0 . If V I is a direct summand of M , then

$$
$$
I \in c r t _ { i } ( M ) .
$$
$$

In the case where P is a 2D-grid, Proposition 3.31 gives P i ( V I ) ,Q i ( V I ) for i = 0 , 1 . Hence we have the following by Corollary 3.44 .

Proposition 3.47. Assume that P is a 2D-grid. Let M ∈ mod A , I ∈ I , and set P 1 ( M ) = i ∈ [ n ] P y i , Q 1 ( M ) = j ∈ [ n ′ ] Q y ′ j , with each x ′ i ,y ′ j ∈ P . Then

$$
$$
\text {crit} _ { 1 } ( M ) = \{ I \in \text {crit} _ { 0 } ( M ) \ | \ s c _ { 1 } ^ { \circ } ( I ) \cup s c ( \uparrow I ) \subseteq \{ y _ { j } \ | \ j \in [ n ] \} , \\ \quad s k _ { 1 } ^ { \circ } ( I ) \cup s k ( \downarrow I ) \subseteq \{ y _ { j } ^ { \prime } \ | \ j \in [ n ^ { \prime } ] \} \} .
$$
$$

For a general finite poset P and I ∈ I , we still do not have an exact form of P 1 ( V I ) , and hence we cannot use crt 1 ( M ) . To improve this, we next give a refinement of Proposition 3.18 as follows.

Proposition 3.48. Let I ∈ I . Then V I has a minimal projective presentation of the following form:

$$
$$
P \oplus P _ { s c ( \uparrow \uparrow I ) } \rightarrow P _ { s c ( I ) } \rightarrow V _ { I } \rightarrow 0 ,
$$
$$

where P is a direct summand of P sc 1 ( I ) .

Proof We start with a projective presentation ( 3.18 ) of V I given in Proposition 3.18 :

$$
$$
P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( \uparrow I ) } \xrightarrow { \varepsilon _ { 1 } } P _ { s c ( I ) } \xrightarrow { \varepsilon _ { 0 } } V _ { I } \to 0 .
$$
$$

Set M : = V ↑ I , M ′ : = V ⇑ I , identify V I = M/M ′ , and consider the canonical short exact sequence ι π

$$
$$
0 \to M ^ { \prime } \xrightarrow { \iota } M \xrightarrow { \pi } V _ { I } \to 0 .
$$
$$

Then ( 3.18 ) was obtained by applying Lemma 3.15 using the commutative diagram ( 3.17 ) with exact rows and exact columns, which has the following form under Notation ( 3.44 ) for
