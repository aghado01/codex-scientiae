[Page 55]

Theorem 5.7. Let I be an interval of P , and M ∈ mod A with a projective presentation

$$
\[
\[
P ( y ) \stackrel { P ( \alpha ) } { \longrightarrow } P ( x ) \stackrel { \varepsilon } { \rightarrow } M \rightarrow 0
\]
\]
$$

−−−→ −→ → for some morphism α : x → y in A . Keep the notations introduced in Proposition 5.5 . Then we have the following formula for d M ( V I ) :

$$
\[
\begin{aligned}
d _ { M } ( V _ { I } ) = & \, \operatorname{rank} \left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( x ) } { P ^ { \prime } ( g _ { 3 } ) ( x ) } \Big | _ { P ^ { \prime } ( g _ { 2 } ) ( x ) } \frac { 0 } { P ^ { \prime } ( s _ { 1 } ( P ) \bigoplus s ( \uparrow I ) ) ( \alpha ) } \, \begin{matrix} P ^ { \prime } ( s _ { 1 } ( I ) \oplus s ( \uparrow I ) ) ( \alpha ) & 0 \\ 0 & P ^ { \prime } ( s ( I ) ) ( \alpha ) \end{matrix} \right ] \\ & - \operatorname{rank} \left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( x ) } { 0 } \Big | _ { P ^ { \prime } ( g _ { 2 } ) ( x ) } \frac { 0 } { 0 } \Big | _ { P ^ { \prime } ( s k ( I ) ) ( \alpha ) } \, \begin{matrix} P ^ { \prime } ( s _ { 1 } ( I ) \oplus s ( \uparrow I ) ) ( \alpha ) & 0 \\ 0 & P ^ { \prime } ( s k ( I ) ) ( \alpha ) \end{matrix} \right ] .
\end{aligned}
\]
$$

Note that for the 2D-grid case, we can replace sc 1 ( I ) with sc ◦ 1 ( I ) .

Proof Case 1. V I is non-projective.

By Theorem 5.1 and Propositions 5.4 and 5.5 , we have

$$
\[
\begin{aligned}
\operatorname{rank} E _ { I } ( \alpha ) + \operatorname{rank} Q ( \alpha ) = & \dim E _ { I } ( x ) - \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( x ) \\ & + \operatorname{rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( \alpha ) ] , \\ \operatorname{rank} V _ { I } ( \alpha ) = & \dim V _ { I } ( x ) - \dim P ^ { \prime } ( \text{sk} ( I ) ) ( x ) + \operatorname{rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text{sk} ( I ) ) ( \alpha ) ] , \\ \operatorname{rank} Q ( \alpha ) = & \dim ( V _ { I } ) ( x ) - \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( x ) \\ & + \operatorname{rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( \alpha ) ] .
\end{aligned}
\]
$$

Therefore by ( 5.63 ), we have

$$
\[
\begin{aligned}
d _ { M } ( V _ { I } ) = & \dim E _ { I } ( x ) - \dim V _ { I } ( x ) - \dim \tau V _ { I } ( x ) + \dim P ^ { \prime } ( \text{sk} ( I ) ) ( x ) \\ & + \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( x ) - \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( x ) \\ & + \operatorname{rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( \alpha ) ] \\ & - \operatorname{rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text{sk} ( I ) ) ( \alpha ) ] - \operatorname{rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( \alpha ) ] \\ = & \dim P ^ { \prime } ( \text{sk} ( I ) ) ( x ) + \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( x ) - \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( x ) \\ & + \operatorname{rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( \alpha ) ] \\ & - \operatorname{rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text{sk} ( I ) ) ( \alpha ) ] - \operatorname{rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( \alpha ) ] \\ = & \operatorname{rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( \alpha ) ] \\ & - \operatorname{rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text{sk} ( I ) ) ( \alpha ) ] - \operatorname{rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( \alpha ) ] \\ = & \text{RHS of } ( 5.74 ) .
\end{aligned}
\]
$$

# Case 2. V I is projective.

The assertion is proved in a way similar to Case 2 in Theorem 5.16 below. □
