[Page 63]

Remark 5.15. We have a statement corresponding to Proposition 5.5 (resp. Proposition 5.6 ) in this case, which is given by formulas ( 3.18 ), ( 3.33 ) and ( 3.29 ) (resp. ( 3.39 ), ( 3.41 ) and ( 3.40 )).

By using ( 5.82 ), Proposition 5.3 and Remark 5.15 , we can prove the following:

Theorem 5.16. Let \( I \) be an interval of \( P \), and \( M \in \text{mod } A \) with an injective copresentation

$$
0 \to M \stackrel { \sigma } { \to } Q ( x ^ { \prime } ) \stackrel { Q ( \alpha ^ { \prime } ) } { \longrightarrow } Q ( y ^ { \prime } )
$$

for some morphism \( \alpha^\prime : y^\prime \to x^\prime \) in \( A \). Keep the notations introduced in Proposition 5.5. Then we have the following formula for \( d_M(V_I) \):

$$
\begin{align*}
d _ { M } ( V _ { I } ) &= \text{rank} \left [ \frac { P ( g _ { 1 } ) ( x ^ { \prime } ) } { P ( g _ { 3 } ) ( x ^ { \prime } ) } \middle| P ( g _ { 2 } ) ( x ^ { \prime } ) \middle| \begin{array} { c c } \frac { P ( s c ( I ) ) ( \alpha ^ { \prime } ) } { 0 } & 0 \\ 0 & P ( s k ( \downarrow I ) \oplus s k _ { 1 } ( I ) ) ( \alpha ^ { \prime } ) \end{array} \right ] \\ 
&\quad - \text{rank} \left [ \frac { P ( g _ { 1 } ) ( x ^ { \prime } ) } { 0 } \middle| \frac { 0 } { P ( g _ { 2 } ) ( x ^ { \prime } ) } \middle| \begin{array} { c c } P ( s c ( I ) ) ( \alpha ^ { \prime } ) & 0 \\ 0 & P ( s k ( \downarrow I ) \oplus s k _ { 1 } ( I ) ) ( \alpha ^ { \prime } ) \end{array} \right ] .
\end{align*}
$$

Note that for the 2D-grid case, we can replace \( \text{sk}_1(I) \) with \( \text{sk}_1^\circ(I) \).

*Proof.* Case 1. \( V_I \) is non-injective.

The assertion is proved in a way similar to Case 1 in Theorem 5.7 .

Case 2. \( V_I \) is injective.

Note in this case that since \( \text{sk}(I) = \{b\} \) has only one element, we have \( C_2^{\text{sk}(I)} = \emptyset \). Thus \( \text{sk}_1(I) = \emptyset = \text{sk}(\Downarrow I) \), and \( g_2 \) is an empty matrix. By (5.83), we have

$$
d _ { M } ( V _ { I } ) = \text{rank} ( V _ { I } / \text{soc } V _ { I } ) ( \alpha ^ { \prime } ) - \text{rank } V _ { I } ( \alpha ^ { \prime } ) + \sum _ { i \in [ m ] } \dim ( \text{soc } V _ { I } ) ( x _ { i } ) .
$$

To compute the first two terms, we apply Proposition 5.3 to the following projective presentations of \( V_I \) and \( V_I / \text{soc } V_I \) given in Theorem 3.20:

$$
\begin{align*}
P ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) &\xrightarrow { P ( g _ { 1 } ) } P ( s c ( I ) ) \to V _ { I } \to 0 \\ 
P ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) \oplus b ) &\xrightarrow { P ( \left [ \begin{smallmatrix} g _ { 1 } \\ g _ { 3 } \end{smallmatrix} \right ] ) } P ( s c ( I ) ) \to V _ { I } / s o c V _ { I } \to 0 .
\end{align*}
$$

Then we obtain

$$
\begin{align*}
\text{rank}(V_I / \text{soc } V_I)(\alpha^\prime) &= \dim(V_I / \text{soc } V_I)(x^\prime) - \dim P(\text{sc}(I))(x^\prime) \\
&\quad + \text{rank} \left[ P \left[ \begin{smallmatrix} g_1 \\ g_3 \end{smallmatrix} \right] (x^\prime), \, P(\text{sc}(I))(\alpha^\prime) \right] \\
\text{rank } V_I(\alpha^\prime) &= \dim V_I(x^\prime) - \dim P(\text{sc}(I))(x^\prime) \\
&\quad + \text{rank} \left[ P(g_1)(x^\prime), \, P(\text{sc}(I))(\alpha^\prime) \right] \\
\sum_{i \in [m]} \dim(\text{soc } V_I)(x_i) &= \dim(\text{soc } V_I)(x^\prime).
\end{align*}
$$

Altogether, we have

$$
d _ { M } ( V _ { I } ) = \text{rank} \left [ P \left [ g _ { 1 } ^ { \, } \right ] ( x ^ { \prime } ) , \, P ( s c ( I ) ) ( \alpha ^ { \prime } ) \right ] - \text{rank} \left [ P ( g _ { 1 } ) ( x ^ { \prime } ) , \, P ( s c ( I ) ) ( \alpha ^ { \prime } ) \right ] ,
$$
