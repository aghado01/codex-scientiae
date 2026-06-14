# Manifest: Page 063

## REPAIR_MATH
- RAW: ```
0 \to M \stackrel { \sigma } { \to } Q ( x ^ { \prime } ) \stackrel { Q ( \alpha ^ { \prime } ) } { \longrightarrow } Q ( y ^ { \prime } )
```
  FIX: ```
$$
0 \to M \stackrel { \sigma } { \to } Q ( x ^ { \prime } ) \stackrel { Q ( \alpha ^ { \prime } ) } { \longrightarrow } Q ( y ^ { \prime } )
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { P ( g _ { 1 } ) ( x ^ { \prime } ) } { P ( g _ { 3 } ) ( x ^ { \prime } ) } | P ( g _ { 2 } ) ( x ^ { \prime } ) | \begin{array} { c c } \frac { P ( s c ( I ) ) ( \alpha ^ { \prime } ) } { 0 } & 0 \\ 0 & P ( s k ( \downarrow I ) \oplus s k _ { 1 } ( I ) ) ( \alpha ^ { \prime } ) \end{array} \right ] \\ - \text {rank} \left [ \frac { P ( g _ { 1 } ) ( x ^ { \prime } ) } { 0 } | \frac { 0 } { P ( g _ { 2 } ) ( x ^ { \prime } ) } | \begin{array} { c c } P ( s c ( I ) ) ( \alpha ^ { \prime } ) & 0 \\ 0 & P ( s k ( \downarrow I ) \oplus s k _ { 1 } ( I ) ) ( \alpha ^ { \prime } ) \end{array} \right ] .
```
  FIX: ```
$$
\begin{align*}
d _ { M } ( V _ { I } ) &= \text{rank} \left [ \frac { P ( g _ { 1 } ) ( x ^ { \prime } ) } { P ( g _ { 3 } ) ( x ^ { \prime } ) } \middle| P ( g _ { 2 } ) ( x ^ { \prime } ) \middle| \begin{array} { c c } \frac { P ( s c ( I ) ) ( \alpha ^ { \prime } ) } { 0 } & 0 \\ 0 & P ( s k ( \downarrow I ) \oplus s k _ { 1 } ( I ) ) ( \alpha ^ { \prime } ) \end{array} \right ] \\ 
&\quad - \text{rank} \left [ \frac { P ( g _ { 1 } ) ( x ^ { \prime } ) } { 0 } \middle| \frac { 0 } { P ( g _ { 2 } ) ( x ^ { \prime } ) } \middle| \begin{array} { c c } P ( s c ( I ) ) ( \alpha ^ { \prime } ) & 0 \\ 0 & P ( s k ( \downarrow I ) \oplus s k _ { 1 } ( I ) ) ( \alpha ^ { \prime } ) \end{array} \right ] .
\end{align*}
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} ( V _ { I } / \text { soc } V _ { I } ) ( \alpha ^ { \prime } ) - \text { rank } V _ { I } ( \alpha ^ { \prime } ) + \sum _ { i \in [ m ] } \dim ( \text {soc } V _ { I } ) ( x _ { i } ) .
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text{rank} ( V _ { I } / \text{soc } V _ { I } ) ( \alpha ^ { \prime } ) - \text{rank } V _ { I } ( \alpha ^ { \prime } ) + \sum _ { i \in [ m ] } \dim ( \text{soc } V _ { I } ) ( x _ { i } ) .
$$
```
- RAW: ```
P ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) \xrightarrow { P ( g _ { 1 } ) } P ( s c ( I ) ) \to V _ { I } \to 0 \\ P ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) \oplus b ) \xrightarrow { P ( \left [ \begin{smallmatrix} g _ { 1 } \\ g _ { 3 } \end{smallmatrix} \right ] ) } P ( s c ( I ) ) \to V _ { I } / s o c V _ { I } \to 0 .
```
  FIX: ```
$$
\begin{align*}
P ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) &\xrightarrow { P ( g _ { 1 } ) } P ( s c ( I ) ) \to V _ { I } \to 0 \\ 
P ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) \oplus b ) &\xrightarrow { P ( \left [ \begin{smallmatrix} g _ { 1 } \\ g _ { 3 } \end{smallmatrix} \right ] ) } P ( s c ( I ) ) \to V _ { I } / s o c V _ { I } \to 0 .
\end{align*}
$$
```
- RAW: ```
\text { we obtain } & \quad \text {rank} ( V _ { I } / \text {soc} V _ { I } ) ( \alpha ^ { \prime } ) = \dim ( V _ { I } / \text {soc} V _ { I } ) ( x ^ { \prime } ) - \dim P ( \text {sc} ( I ) ) ( x ^ { \prime } ) \\ & + \text {rank} \left [ P \left [ \begin{smallmatrix} g _ { 1 } \\ g _ { 3 } \end{smallmatrix} \right ] ( x ^ { \prime } ) , \, P ( \text {sc} ( I ) ) ( \alpha ^ { \prime } ) \right ] \\ & \quad \text {rank} V _ { I } ( \alpha ^ { \prime } ) = \dim V _ { I } ( x ^ { \prime } ) - \dim P ( \text {sc} ( I ) ) ( x ^ { \prime } ) \\ & + \text {rank} \left [ P ( g _ { 1 } ) ( x ^ { \prime } ) , \, P ( \text {sc} ( I ) ) ( \alpha ^ { \prime } ) \right ] \\ \sum _ { i \in [ m ] } \dim ( \text {soc} V _ { I } ) ( x _ { i } ) = \dim ( \text {soc} V _ { I } ) ( x ^ { \prime } ) . \\ \text {gather, we have}
```
  FIX: ```
$$
\begin{align*}
\text{rank}(V_I / \text{soc } V_I)(\alpha^\prime) &= \dim(V_I / \text{soc } V_I)(x^\prime) - \dim P(\text{sc}(I))(x^\prime) \\
&\quad + \text{rank} \left[ P \left[ \begin{smallmatrix} g_1 \\ g_3 \end{smallmatrix} \right] (x^\prime), \, P(\text{sc}(I))(\alpha^\prime) \right] \\
\text{rank } V_I(\alpha^\prime) &= \dim V_I(x^\prime) - \dim P(\text{sc}(I))(x^\prime) \\
&\quad + \text{rank} \left[ P(g_1)(x^\prime), \, P(\text{sc}(I))(\alpha^\prime) \right] \\
\sum_{i \in [m]} \dim(\text{soc } V_I)(x_i) &= \dim(\text{soc } V_I)(x^\prime).
\end{align*}
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \left [ P \left [ g _ { 1 } ^ { \, } \right ] _ { ( x ^ { \prime } ) } , \, P ( s c ( I ) ) ( \alpha ^ { \prime } ) \right ] - \text {rank} \left [ P ( g _ { 1 } ) ( x ^ { \prime } ) , \, P ( s c ( I ) ) ( \alpha ^ { \prime } ) \right ] ,
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text{rank} \left [ P \left [ g _ { 1 } ^ { \, } \right ] ( x ^ { \prime } ) , \, P ( s c ( I ) ) ( \alpha ^ { \prime } ) \right ] - \text{rank} \left [ P ( g _ { 1 } ) ( x ^ { \prime } ) , \, P ( s c ( I ) ) ( \alpha ^ { \prime } ) \right ] ,
$$
```

## REPAIR_PROSE
- RAW: ```
Theorem 5.16. Let I be an interval of P , and M ∈ mod A with an injective copresentation
```
  FIX: ```
Theorem 5.16. Let \( I \) be an interval of \( P \), and \( M \in \text{mod } A \) with an injective copresentation
```
- RAW: ```
→ −→ −−−→ for some morphism α ′ : y ′ → x ′ in A . Keep the notations introduced in Proposition 5.5 . Then we have the following formula for d M ( V I ) :
```
  FIX: ```
for some morphism \( \alpha^\prime : y^\prime \to x^\prime \) in \( A \). Keep the notations introduced in Proposition 5.5. Then we have the following formula for \( d_M(V_I) \):
```
- RAW: ```
Note that for the 2D-grid case, we can replace sk 1 ( I ) with sk ◦ 1 ( I ) .
```
  FIX: ```
Note that for the 2D-grid case, we can replace \( \text{sk}_1(I) \) with \( \text{sk}_1^\circ(I) \).
```
- RAW: ```
Proof Case 1. V I is non-injective.
```
  FIX: ```
*Proof.* Case 1. \( V_I \) is non-injective.
```
- RAW: ```
Case 2. V I

is injective.
```
  FIX: ```
Case 2. \( V_I \) is injective.
```
- RAW: ```
Note in this case that since sk( I ) = { b } has only one element, we have C 2 sk( I ) = ∅ . Thus sk 1 ( I ) = ∅ = sk( ⇓ I ) , and g 2 is an empty matrix. By ( 5.83 ), we have

By (5.83), we have
```
  FIX: ```
Note in this case that since \( \text{sk}(I) = \{b\} \) has only one element, we have \( C_2^{\text{sk}(I)} = \emptyset \). Thus \( \text{sk}_1(I) = \emptyset = \text{sk}(\Downarrow I) \), and \( g_2 \) is an empty matrix. By (5.83), we have
```
- RAW: ```
To compute the first two terms, we apply Proposition 5.3 to the following projective presentations of V I and V I / soc V I given in Theorem 3.20 :
```
  FIX: ```
To compute the first two terms, we apply Proposition 5.3 to the following projective presentations of \( V_I \) and \( V_I / \text{soc } V_I \) given in Theorem 3.20:
```
