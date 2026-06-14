[Page 23]

Proof Let z ∈ P and q ∈ P y ( z ) . Then by Notation 2.7 , we have

$$
$$
( \rho _ { a } ^ { M } \cdot P _ { y , x } ) ( q ) = \rho _ { a } ^ { M } ( q \cdot p _ { y , x } ) = M ( q \cdot p _ { y , x } ) ( p ) = ( M ( q ) M ( p _ { y , x } ) ) ( p ) .
$$
$$

On the other hand,

$$
$$
\rho_{M(p_{y, x})(a)}^M(q) = M(q)(M(p_{y, x})(a)).
$$
$$

Therefore, the assertion holds.

Now we are in a position to give a projective presentation of V I for any interval I of P .

Proposition 3.18. Let I be an interval of P . Then V I has the following (not necessarily minimal) projective presentation:

$$
$$
P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( \uparrow I ) } \stackrel { \varepsilon _ { 1 } } { \longrightarrow } P _ { s c ( I ) } \stackrel { \varepsilon _ { 0 } } { \longrightarrow } V _ { I } \to 0 .
$$
$$

Here ε 0 = ρ V I 1 a a ∈ sc( I ) , where we set 1 u : = 1 k ∈ k = V I ( u ) for all u ∈ I ; ε 1 : = ε 1 ( c ) : = ε ↑ I 1 ,ε 11 , where ε 11 : = ε 11 ( c ) : = δ a, c ( a ′ ) P a ′ , c ( a ′ ) ( a,a ′ ) ∈ sc( I ) × sc( ⇑ I ) , and ε ↑ I 1 is defined as in Notation 3.16 . Note that ε 0 is a projective cover of V I .

Proof By Lemma 3.7 , we can write I = U \ U ′ in terms of two up-sets U = ↑ I and U ′ = ⇑ I , and hence V I ∼ = V U /V U ′ . By Proposition 3.13 and Lemma 3.6 , V U has the following (not necessarily minimal) projective presentation:

$$
$$
P _ { s c _ { 1 } ( U ) } \stackrel { \varepsilon _ { 1 } ^ { U } } { \longrightarrow } P _ { s c ( U ) } \stackrel { \varepsilon _ { 0 } ^ { U } } { \longrightarrow } V _ { U } \to 0 .
$$
$$

By Remark 3.2 (2), P sc( U ) = P sc( I ) , and P sc 1 ( U ) = P sc 1 ( I ) . Since the natural projection π : V U → V I is just the restriction on I , it follows by Lemma 3.15 , that ε 0 = πε U 0 = π ◦ ρ V U 1 a a ∈ sc( U ) = ρ V I 1 a a ∈ sc( I ) .

On the other hand, the up-set U ′ is the disjoint union U 1 ⊔ · · · ⊔ U k of some connected up-sets U 1 , . . . , U k with k ∈ Z ≥ 1 , and hence V U ′ ∼ = V U 1 ⊕ · · · ⊕ V U k . By Propositions 3.13 and 3.14 , there is an epimorphism starting from a projective module:

$$
$$
P _ { s c ( U ^ { \prime } ) } \stackrel { \varepsilon _ { 0 } ^ { U ^ { \prime } } } { \longrightarrow } V _ { U ^ { \prime } } ,
$$
$$

$$
$$
\text {where } \varepsilon _ { 0 } ^ { U ^ { \prime } } \coloneqq \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( U _ { 1 } ) } \oplus \cdots \oplus \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( U _ { k } ) } = \left [ \rho _ { 1 _ { a } } ^ { V _ { U ^ { \prime } } } \right ] _ { a \in s c ( U ^ { \prime } ) } . \text { If the equality } \\ \varepsilon _ { 0 } ^ { U } \varepsilon _ { 1 1 } = \varepsilon _ { 0 } ^ { U ^ { \prime } } \colon P _ { s c ( U ^ { \prime } ) } \to V _ { U } \\
$$
$$

holds, where ι : V U ′ ∼ = V U 1 ⊕· · ·⊕ V U k → V U is the inclusion, then by combining ( 3.19 ), ( 3.20 ) and Lemma 3.15 , we obtain a projective presentation of V I having the form

$$
$$
P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( U ^ { \prime } ) } \xrightarrow { \left [ \varepsilon _ { 1 } ^ { U } , \varepsilon _ { 1 1 } \right ] } P _ { s c ( I ) } \xrightarrow { \varepsilon _ { 0 } ^ { I } } V _ { I } \to 0
$$
$$

as claimed. The equality ( 3.21 ) is verified as follows:

$$
$$
\overset { U } { \varepsilon _ { 0 } } ^ { U } & _ { 1 1 } = \left [ \rho _ { 1 _ { a } } ^ { V _ { U } } \right ] _ { a \in s c ( I ) } \cdot \left [ \delta _ { a , c ( a ^ { \prime } ) } P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { ( a , a ^ { \prime } ) \in s c ( I ) \times s c ( U ^ { \prime } ) } \\ & = \left [ \sum _ { a \in s c ( I ) } \delta _ { a , c ( a ^ { \prime } ) } \rho _ { 1 _ { a } } ^ { V _ { U } } \cdot P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { a ^ { \prime } \in s c ( U ^ { \prime } ) }
$$
$$
