[Page 21]

where \( \varepsilon _ { 0 } ^ { U } = [ \rho _ { V _ { U } } ( 1 _ { a } ) ] _ { a \in s c ( U ) } \), and we set \( 1 _ { u } \coloneqq 1 _ { k } \in k = V _ { U } ( u ) \) for all \( u \in U \), and

$$
$$
\varepsilon _ { 1 } ^ { U } \coloneqq [ \tilde { P } _ { a , a _ { c } } ] _ { ( a , \mathfrak { a } _ { c } ) \in s c ( U ) \times s c _ { 1 } ( U ) } \\
$$
$$

with the entries given by

$$
$$
\tilde { P } _ { a , a _ { c } } \coloneqq \begin{cases} P _ { c , a } & ( a = \underline { a } ) , \\ - P _ { c , a } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{cases} \quad ( 3 . 1 6 )
$$
$$

for all \( \mathfrak { a } _ { c } \in s c _ { 1 } ( U ) \) and \( a \in s c ( U ) \). Here and subsequently, we write the matrices following the lexicographic order \( \preceq _ { l e x } \) (see Notation 3.4 (3)) of indices.

We here remark that \( \varepsilon _ { 0 } ^ { U } \) is a projective cover of \( V _ { U } \).

*Proof.* We refer the reader to the proof of (Asashiba et al. 2024, Proposition 5.10), and substitute \( I _ { \xi } \) by \( U \). \( \square \)

Given an up-set \( U \) of \( P \) (\( U \) might be non-connected), we consider its decomposition into connected components and apply Proposition 3.13 on each connected component. Following this spirit, we let \( U \coloneqq U _ { 1 } \sqcup \cdots \sqcup U _ { k } \). By Lemma 3.11 and (Munkres 2000, Theorem 25.3), each component is again an open set, thus an up-set of \( P \). Then the following is easy to show.

**Proposition 3.14.** Let \( P \) be a finite poset, and \( U = U _ { 1 } \sqcup \cdots \sqcup U _ { k } \) an up-set of \( P \) with \( k \) connected components (\( k \geq 1 \)). Set \( V _ { U } \coloneqq V _ { U _ { 1 } } \oplus \cdots \oplus V _ { U _ { k } } \). Then \( V _ { U } \) has the following (not necessarily minimal) projective presentation:

$$
$$
P _ { s c _ { 1 } ( U ) } \stackrel { \varepsilon _ { 1 } ^ { U } } { \longrightarrow } P _ { s c ( U ) } \stackrel { \varepsilon _ { 0 } ^ { U } } { \longrightarrow } V _ { U } \to 0 ,
$$
$$

$$
$$
\ w h e r e \, \varepsilon _ { i } ^ { U } \colon = \varepsilon _ { i } ^ { U _ { 1 } } \oplus \cdots \oplus \varepsilon _ { i } ^ { U _ { k } } \ \ ( i = 0 , 1 ) . \quad \square
$$
$$

The following lemma will be frequently used later.

**Lemma 3.15.** Let \( M , M ^ { \prime } \in \operatorname { m o d } A \). Assume that

- (1) \( M ^ { \prime } \) is a submodule of \( M \), i.e., we have a short exact sequence

$$
$$
0 \to M ^ { \prime } \stackrel { \iota } { \to } M \stackrel { \pi } { \to } M / M ^ { \prime } \to 0 ;
$$
$$

- (2) \( M \) has a projective presentation (not necessarily a minimal one)

$$
$$
P _ { 1 } ^ { M \ \varepsilon _ { 1 } ^ { M } } \xrightarrow { \varepsilon _ { 0 } ^ { M } } P _ { 0 } ^ { M } \xrightarrow { \varepsilon _ { 0 } ^ { M } } M \to 0 ; \, a n d
$$
$$

- (3) \( M ^ { \prime } \) has an epimorphism \( \varepsilon _ { 0 } ^ { M ^ { \prime } } \colon P _ { 0 } ^ { M ^ { \prime } } \to M ^ { \prime } \) with \( P _ { 0 } ^ { M ^ { \prime } } \) projective.

Then the factor module \( M / M ^ { \prime } \) has a projective presentation (not necessarily a minimal one)
