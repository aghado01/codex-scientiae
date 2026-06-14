[Page 38]

$$
$$
\operatorname{supp} ( s o c \, M ) = \{ x _ { 1 } ^ { \prime } , \dots , x _ { m ^ { \prime } } ^ { \prime } \} .
$$
$$

The following is well-known.

Lemma 3.42. Let \( X,Y \in \operatorname{mod} A \). Then

$$
$$
0 \to \Omega ( X ) \oplus \Omega ( Y ) \xrightarrow { \sigma _ { X } \oplus \sigma _ { Y } } P _ { 0 } ( X ) \oplus P _ { 0 } ( Y ) \xrightarrow { \varepsilon _ { X } \oplus \varepsilon _ { Y } } X \oplus Y \to 0
$$
$$

is an exact sequence with \( \varepsilon_X \oplus \varepsilon_Y \) a projective cover of \( X \oplus Y \).

This immediately shows the following:

Proposition 3.43. Let \( X,Y \in \operatorname{mod} A \). Then

$$
$$
P _ { 1 } ( X ) \oplus P _ { 1 } ( Y ) \xrightarrow { \partial _ { 0 } ^ { X } \oplus \partial _ { 0 } ^ { Y } } P _ { 0 } ( X ) \oplus P _ { 0 } ( Y ) \xrightarrow { \varepsilon _ { X } \oplus \varepsilon _ { Y } } X \oplus Y \to 0
$$
$$

is a minimal projective presentation of \( X \oplus Y \), and more generally,

$$
$$
P ( X ) \oplus P ( Y ) \coloneqq ( P _ { i } ( X ) \oplus P _ { i } ( Y ) , \partial _ { i } ^ { X } \oplus \partial _ { i } ^ { Y } ) _ { i \geq 0 }
$$
$$

is a minimal projective resolution of \( X \oplus Y \).

The following is immediate from Proposition 3.43 by the uniqueness of a minimal projective presentation of a module up to isomorphism of exact sequences:

Corollary 3.44. Let \( L,M \in \operatorname{mod} A \), and assume that \( L \) is a direct summand of \( M \). Then for each \( i \geq 0 \), the following statements hold:

- (1) \( P_i(L) \) is a direct summand of \( P_i(M) \). Therefore,

$$
$$
\operatorname{supp} ( \text {top} P _ { i } ( L ) ) \subseteq \operatorname{supp} ( \text {top} P _ { i } ( M ) ) .
$$
$$

- (2) Dually, \( Q_i(L) \) is a direct summand of \( Q_i(M) \). Therefore,


$$
$$
\operatorname{supp} { ( s o c \, Q ^ { i } ( L ) ) \subseteq \operatorname{supp} { ( s o c \, Q ^ { i } ( M ) ) } } .
$$
$$

Using the fact above, we generalize \( \operatorname{crt}_0(M) \) to define the following.

Definition 3.45. Let \( M \in \operatorname{mod} A \), \( I \in \mathbb{I} \), and \( i \geq 0 \). Then we define the \( i \)-th critical set of intervals of \( M \) to be

$$
$$
\operatorname{crt} _ { i } ( M ) \coloneqq \{ I \in \mathbb { I } \ | \ \forall j \text { with } 0 \leq j \leq i , \text {supp} ( \text {top} \, P _ { j } ( V _ { I } ) ) \subseteq \text {supp} ( \text {top} \, P _ { j } ( M ) ) ,
$$
$$
