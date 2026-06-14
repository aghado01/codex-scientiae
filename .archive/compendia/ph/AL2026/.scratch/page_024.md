[Page 24]

$$
$$
& = \left [ \rho _ { 1 } ^ { V _ { U } } \cdot P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { a ^ { \prime } \in \text {sc} ( U ^ { \prime } ) } \\ & \stackrel { * } { = } \left [ \rho _ { V _ { U } } ^ { V _ { U } } \right ] _ { a ^ { \prime } , c ( a ^ { \prime } ) } ( 1 _ { c ( a ^ { \prime } ) } ) \right ] _ { a ^ { \prime } \in \text {sc} ( U ^ { \prime } ) } \\ & = \left [ \rho _ { 1 } ^ { V _ { U } } \right ] _ { a ^ { \prime } \in \text {sc} ( U ^ { \prime } ) } \\ & = \iota \circ \left [ \rho _ { 1 } ^ { V _ { U ^ { \prime } } } \right ] _ { a ^ { \prime } \in \text {sc} ( U ^ { \prime } ) } \\ & = \iota ^ { U ^ { \prime } } _ { 0 } . \\ \text {equality} & \left ( \stackrel { * } { = } \text {follows by Lemma 3.17.}
$$
$$

In the above, the equality ( ∗ = ) follows by Lemma 3.17 .


# 3.1.1 The case where V I is injective

Assume that V I is injective in mod A . Then b : = max I exists, and we have I = ↓ b . Since V I is indecomposable injective, soc V I = V { b } is a simple module at b , and ε b 0 = ρ 1 b : P b → V { b } is the projective cover of V { b } . Hence by Lemma 3.15 and Proposition 3.18 , we have the following.

Notation 3.19. Let I be an interval of P with the maximum element b . Fixing one element a ∈ sc( I ) induces another choice map c ′ : { b } → sc( I ) by c ′ ( b ) : = a .

Theorem 3.20. Let I be an interval of P . Assume that V I is injective, i.e., I = ↓ b with b = max I . Then V I and V I / soc V I have projective presentations of the following forms. ε 1 ε 0

$$
$$
P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( \uparrow I ) } \xrightarrow { \varepsilon _ { 1 } } P _ { s c ( I ) } \xrightarrow { \varepsilon _ { 0 } } V _ { I } \to 0 ,
$$
$$

$$
$$
( P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( \uparrow I ) } ) \oplus P _ { b } \xrightarrow { \varepsilon _ { 1 } ^ { \prime } } P _ { s c ( I ) } \to V _ { I } / \text {soc} V _ { I } \to 0 .
$$
$$

Here ε 1 : = ε ↑ I 1 ,ε 11 and ε ′ 1 : = ε 1 ,ε ′′ 1 , where ε 11 ,ε ↑ I 1 are given in Proposition 3.18 , and ε ′′ 1 : = ε ′′ 1 ( c ′ ) : = δ a, c ′ ( b ) P b, c ′ ( b ) ( a,b ) ∈ sc( I ) ×{ b } . Therefore, we have

$$
$$
d _ { M } ( V _ { I } ) = \text {rank} \begin{bmatrix} M ( \varepsilon _ { 1 } ) \\ M ( \varepsilon _ { 1 } ^ { \prime \prime } ) \end{bmatrix} - \text {rank} \left [ M ( \varepsilon _ { 1 } ) \right ] .
$$
$$

Proof We only need to show the statement for V I / soc V I . By Lemma 3.15 , it suffices to check ε 0 ε ′′ 1 = ιε { b } 0 , in which ι : V { b } → V I is the inclusion.

$$
$$
\varepsilon _ { 0 } \varepsilon _ { 1 } ^ { \prime \prime } & = \left [ \rho _ { 1 _ { a } } ^ { V _ { I } } \right ] _ { a \in s c ( I ) } \cdot \left [ \delta _ { a , c ^ { \prime } ( b ) } P _ { b , c ^ { \prime } ( b ) } \right ] _ { ( a , b ) \in s c ( I ) \times \{ b \} } = \sum _ { a \in s c ( I ) } \delta _ { a , c ^ { \prime } ( b ) } \rho _ { 1 _ { a } } ^ { V _ { I } } \cdot P _ { b , a } \\ & = \rho _ { 1 _ { c ^ { \prime } ( b ) } } ^ { V _ { I } } \cdot P _ { b , c ^ { \prime } ( b ) } \stackrel { * } { = } \rho _ { V _ { 1 } } ^ { V _ { I } } \\
$$
$$

where we applied Lemma 3.17 to have the equality ( ∗ =) . Finally, ( 3.23 ) follows by applying Lemma 2.10 and Theorem 3.3 . □
