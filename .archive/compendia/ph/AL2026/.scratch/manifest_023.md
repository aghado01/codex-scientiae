# Manifest: Page 023

## REPAIR_MATH
- RAW: ```
( \rho _ { a } ^ { M } \cdot P _ { y , x } ) ( q ) = \rho _ { a } ^ { M } ( q \cdot p _ { y , x } ) = M ( q \cdot p _ { y , x } ) ( p ) = ( M ( q ) M ( p _ { y , x } ) ) ( p ) .
```
  FIX: ```
$$
( \rho _ { a } ^ { M } \cdot P _ { y , x } ) ( q ) = \rho _ { a } ^ { M } ( q \cdot p _ { y , x } ) = M ( q \cdot p _ { y , x } ) ( p ) = ( M ( q ) M ( p _ { y , x } ) ) ( p ) .
$$
```
- RAW: ```
\rho _ { M ( p _ { y , x } ) ( a ) } ^ { M } ( q ) = M ( q ) ( M ( p _ { y , x } ) ( a ) ) . \\ \text {assertion holds.} & & \Box
```
  FIX: ```
$$
\rho_{M(p_{y, x})(a)}^M(q) = M(q)(M(p_{y, x})(a)).
$$
```
- RAW: ```
P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( \uparrow I ) } \stackrel { \varepsilon _ { 1 } } { \longrightarrow } P _ { s c ( I ) } \stackrel { \varepsilon _ { 0 } } { \longrightarrow } V _ { I } \to 0 .
```
  FIX: ```
$$
P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( \uparrow I ) } \stackrel { \varepsilon _ { 1 } } { \longrightarrow } P _ { s c ( I ) } \stackrel { \varepsilon _ { 0 } } { \longrightarrow } V _ { I } \to 0 .
$$
```
- RAW: ```
P _ { s c _ { 1 } ( U ) } \stackrel { \varepsilon _ { 1 } ^ { U } } { \longrightarrow } P _ { s c ( U ) } \stackrel { \varepsilon _ { 0 } ^ { U } } { \longrightarrow } V _ { U } \to 0 .
```
  FIX: ```
$$
P _ { s c _ { 1 } ( U ) } \stackrel { \varepsilon _ { 1 } ^ { U } } { \longrightarrow } P _ { s c ( U ) } \stackrel { \varepsilon _ { 0 } ^ { U } } { \longrightarrow } V _ { U } \to 0 .
$$
```
- RAW: ```
P _ { s c ( U ^ { \prime } ) } \stackrel { \varepsilon _ { 0 } ^ { U ^ { \prime } } } { \longrightarrow } V _ { U ^ { \prime } } ,
```
  FIX: ```
$$
P _ { s c ( U ^ { \prime } ) } \stackrel { \varepsilon _ { 0 } ^ { U ^ { \prime } } } { \longrightarrow } V _ { U ^ { \prime } } ,
$$
```
- RAW: ```
\text {where } \varepsilon _ { 0 } ^ { U ^ { \prime } } \coloneqq \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( U _ { 1 } ) } \oplus \cdots \oplus \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( U _ { k } ) } = \left [ \rho _ { 1 _ { a } } ^ { V _ { U ^ { \prime } } } \right ] _ { a \in s c ( U ^ { \prime } ) } . \text { If the equality } \\ \varepsilon _ { 0 } ^ { U } \varepsilon _ { 1 1 } = \varepsilon _ { 0 } ^ { U ^ { \prime } } \colon P _ { s c ( U ^ { \prime } ) } \to V _ { U } \\
```
  FIX: ```
$$
\text {where } \varepsilon _ { 0 } ^ { U ^ { \prime } } \coloneqq \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( U _ { 1 } ) } \oplus \cdots \oplus \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( U _ { k } ) } = \left [ \rho _ { 1 _ { a } } ^ { V _ { U ^ { \prime } } } \right ] _ { a \in s c ( U ^ { \prime } ) } . \text { If the equality } \\ \varepsilon _ { 0 } ^ { U } \varepsilon _ { 1 1 } = \varepsilon _ { 0 } ^ { U ^ { \prime } } \colon P _ { s c ( U ^ { \prime } ) } \to V _ { U } \\
$$
```
- RAW: ```
P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( U ^ { \prime } ) } \xrightarrow { \left [ \varepsilon _ { 1 } ^ { U } , \varepsilon _ { 1 1 } \right ] } P _ { s c ( I ) } \xrightarrow { \varepsilon _ { 0 } ^ { I } } V _ { I } \to 0
```
  FIX: ```
$$
P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( U ^ { \prime } ) } \xrightarrow { \left [ \varepsilon _ { 1 } ^ { U } , \varepsilon _ { 1 1 } \right ] } P _ { s c ( I ) } \xrightarrow { \varepsilon _ { 0 } ^ { I } } V _ { I } \to 0
$$
```
- RAW: ```
\overset { U } { \varepsilon _ { 0 } } ^ { U } & _ { 1 1 } = \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( I ) } \cdot \left [ \delta _ { a , c ( a ^ { \prime } ) } P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { ( a , a ^ { \prime } ) \in s c ( I ) \times s c ( U ^ { \prime } ) } \\ & = \left [ \sum _ { a \in s c ( I ) } \delta _ { a , c ( a ^ { \prime } ) } \rho _ { 1 _ { a } } ^ { V _ { U } } \cdot P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { a ^ { \prime } \in s c ( U ^ { \prime } ) }
```
  FIX: ```
$$
\overset { U } { \varepsilon _ { 0 } } ^ { U } & _ { 1 1 } = \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( I ) } \cdot \left [ \delta _ { a , c ( a ^ { \prime } ) } P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { ( a , a ^ { \prime } ) \in s c ( I ) \times s c ( U ^ { \prime } ) } \\ & = \left [ \sum _ { a \in s c ( I ) } \delta _ { a , c ( a ^ { \prime } ) } \rho _ { 1 _ { a } } ^ { V _ { U } } \cdot P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { a ^ { \prime } \in s c ( U ^ { \prime } ) }
$$
```



## REPAIR_PROSE
- RAW: `Therefore, the assertion holds.`
  FIX: `Therefore, the assertion holds. \(\Box\)`

- RAW: `Proof Let z ∈ P and q ∈ P y ( z ) . Then by Notation 2.7 , we have`
  FIX: `Proof Let \( z \in P \) and \( q \in P_y(z) \). Then by Notation 2.7, we have`

- RAW: `Now we are in a position to give a projective presentation of V I for any interval I of P .`
  FIX: `Now we are in a position to give a projective presentation of \( V_I \) for any interval \( I \) of \( P \).`

- RAW: `Proposition 3.18. Let I be an interval of P . Then V I has the following (not necessarily minimal) projective presentation:`
  FIX: `Proposition 3.18. Let \( I \) be an interval of \( P \). Then \( V_I \) has the following (not necessarily minimal) projective presentation:`

- RAW: `Here ε 0 = ρ V I 1 a a ∈ sc( I ) , where we set 1 u : = 1 k ∈ k = V I ( u ) for all u ∈ I ; ε 1 : = ε 1 ( c ) : = ε ↑ I 1 ,ε 11 , where ε 11 : = ε 11 ( c ) : = δ a, c ( a ′ ) P a ′ , c ( a ′ ) ( a,a ′ ) ∈ sc( I ) × sc( ⇑ I ) , and ε ↑ I 1 is defined as in Notation 3.16 . Note that ε 0 is a projective cover of V I .`
  FIX: `Here \( \varepsilon_0 = [\rho_{1_a}^{V_I}]_{a \in sc(I)} \), where we set \( 1_u := 1_k \in k = V_I(u) \) for all \( u \in I \); \( \varepsilon_1 := \varepsilon_1(c) := [\varepsilon_1^{\uparrow I}, \varepsilon_{11}] \), where \( \varepsilon_{11} := \varepsilon_{11}(c) := [\delta_{a, c(a')} P_{a', c(a')}]_{(a,a') \in sc(I) \times sc(\Uparrow I)} \), and \( \varepsilon_1^{\uparrow I} \) is defined as in Notation 3.16. Note that \( \varepsilon_0 \) is a projective cover of \( V_I \).`

- RAW: `Proof By Lemma 3.7 , we can write I = U \ U ′ in terms of two up-sets U = ↑ I and U ′ = ⇑ I , and hence V I ∼ = V U /V U ′ . By Proposition 3.13 and Lemma 3.6 , V U has the following (not necessarily minimal) projective presentation:`
  FIX: `Proof By Lemma 3.7, we can write \( I = U \setminus U' \) in terms of two up-sets \( U = {\uparrow}I \) and \( U' = {\Uparrow}I \), and hence \( V_I \cong V_U / V_{U'} \). By Proposition 3.13 and Lemma 3.6, \( V_U \) has the following (not necessarily minimal) projective presentation:`

- RAW: `By Remark 3.2 (2), P sc( U ) = P sc( I ) , and P sc 1 ( U ) = P sc 1 ( I ) . Since the natural projection π : V U → V I is just the restriction on I , it follows by Lemma 3.15 , that ε 0 = πε U 0 = π ◦ ρ V U 1 a a ∈ sc( U ) = ρ V I 1 a a ∈ sc( I ) .`
  FIX: `By Remark 3.2 (2), \( P_{sc(U)} = P_{sc(I)} \), and \( P_{sc_1(U)} = P_{sc_1(I)} \). Since the natural projection \( \pi \colon V_U \to V_I \) is just the restriction on \( I \), it follows by Lemma 3.15, that \( \varepsilon_0 = \pi \varepsilon_0^U = \pi \circ [\rho_{1_a}^{V_U}]_{a \in sc(U)} = [\rho_{1_a}^{V_I}]_{a \in sc(I)} \).`

- RAW: `On the other hand, the up-set U ′ is the disjoint union U 1 ⊔ · · · ⊔ U k of some connected up-sets U 1 , . . . , U k with k ∈ Z ≥ 1 , and hence V U ′ ∼ = V U 1 ⊕ · · · ⊕ V U k . By Propositions 3.13 and 3.14 , there is an epimorphism starting from a projective module:`
  FIX: `On the other hand, the up-set \( U' \) is the disjoint union \( U_1 \sqcup \cdots \sqcup U_k \) of some connected up-sets \( U_1, \dots, U_k \) with \( k \in \mathbb{Z}_{\ge 1} \), and hence \( V_{U'} \cong V_{U_1} \oplus \cdots \oplus V_{U_k} \). By Propositions 3.13 and 3.14, there is an epimorphism starting from a projective module:`

- RAW: `holds, where ι : V U ′ ∼ = V U 1 ⊕· · ·⊕ V U k → V U is the inclusion, then by combining ( 3.19 ), ( 3.20 ) and Lemma 3.15 , we obtain a projective presentation of V I having the form`
  FIX: `holds, where \( \iota \colon V_{U'} \cong V_{U_1} \oplus \cdots \oplus V_{U_k} \to V_U \) is the inclusion, then by combining (3.19), (3.20) and Lemma 3.15, we obtain a projective presentation of \( V_I \) having the form`
