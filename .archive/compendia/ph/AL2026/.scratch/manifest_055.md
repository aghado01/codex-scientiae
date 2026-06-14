# Manifest: Page 055

## REPAIR_PROSE
- RAW: `Theorem 5.7. Let I be an interval of P , and M ∈ mod A with a projective presentation`
  FIX: `Theorem 5.7. Let \( I \) be an interval of \( P \), and \( M \in \operatorname{mod} A \) with a projective presentation`
- RAW: `−−−→ −→ → for some morphism α : x → y in A . Keep the notations introduced in Proposition 5.5 . Then we have the following formula for d M ( V I ) :`
  FIX: `for some morphism \( \alpha : x \rightarrow y \) in \( \mathcal{A} \). Keep the notations introduced in Proposition 5.5. Then we have the following formula for \( d_M(V_I) \):`
- RAW: `Note that for the 2D-grid case, we can replace sc 1 ( I ) with sc ◦ 1 ( I ) .`
  FIX: `Note that for the 2D-grid case, we can replace \( \text{sc}_1(I) \) with \( \text{sc}_1^\circ(I) \).`
- RAW: `Proof Case 1. V I is non-projective.`
  FIX: `Proof Case 1. \( V_I \) is non-projective.`
- RAW: `Therefore by ( 5.63 ), we have`
  FIX: `Therefore by (5.63), we have`
- RAW: `# Case 2. V I is projective.`
  FIX: `# Case 2. \( V_I \) is projective.`
- RAW: `The assertion is proved in a way similar to Case 2 in Theorem 5.16 below. □`
  FIX: `The assertion is proved in a way similar to Case 2 in Theorem 5.16 below. \( \Box \)`

## REPAIR_MATH
- RAW: ```
P ( y ) \stackrel { P ( \alpha ) } { \longrightarrow } P ( x ) \stackrel { \varepsilon } { \rightarrow } M \rightarrow 0
```
  FIX: ```
\[
P ( y ) \stackrel { P ( \alpha ) } { \longrightarrow } P ( x ) \stackrel { \varepsilon } { \rightarrow } M \rightarrow 0
\]
```
- RAW: ```
d _ { M } ( V _ { I } ) = & \, \text {rank} \left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( x ) } { P ^ { \prime } ( g _ { 3 } ) ( x ) } \Big | _ { P ^ { \prime } ( g _ { 2 } ) ( x ) } \frac { 0 } { P ^ { \prime } ( s _ { 1 } ( P ) \bigoplus s ( \uparrow I ) ) ( \alpha ) } \, \begin{matrix} P ^ { \prime } ( s _ { 1 } ( I ) \oplus s ( \uparrow I ) ) ( \alpha ) & 0 \\ 0 & P ^ { \prime } ( s ( I ) ) ( \alpha ) \end{matrix} \right ] \\ & - \text {rank} \left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( x ) } { 0 } \Big | _ { P ^ { \prime } ( g _ { 2 } ) ( x ) } \frac { 0 } { 0 } \Big | _ { P ^ { \prime } ( s k ( I ) ) ( \alpha ) } \, \begin{matrix} P ^ { \prime } ( s _ { 1 } ( I ) \oplus s ( \uparrow I ) ) ( \alpha ) & 0 \\ 0 & P ^ { \prime } ( s k ( I ) ) ( \alpha ) \end{matrix} \right ] . \\ \text {Note that for the } 2 D { - \text {grid case, we can replace } s _ { 1 } ( I ) \text { with } s c _ { 1 } ^ { \circ } ( I ) . }
```
  FIX: ```
\[
\begin{aligned}
d _ { M } ( V _ { I } ) = & \, \operatorname{rank} \left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( x ) } { P ^ { \prime } ( g _ { 3 } ) ( x ) } \Big | _ { P ^ { \prime } ( g _ { 2 } ) ( x ) } \frac { 0 } { P ^ { \prime } ( s _ { 1 } ( P ) \bigoplus s ( \uparrow I ) ) ( \alpha ) } \, \begin{matrix} P ^ { \prime } ( s _ { 1 } ( I ) \oplus s ( \uparrow I ) ) ( \alpha ) & 0 \\ 0 & P ^ { \prime } ( s ( I ) ) ( \alpha ) \end{matrix} \right ] \\ & - \operatorname{rank} \left [ \frac { P ^ { \prime } ( g _ { 1 } ) ( x ) } { 0 } \Big | _ { P ^ { \prime } ( g _ { 2 } ) ( x ) } \frac { 0 } { 0 } \Big | _ { P ^ { \prime } ( s k ( I ) ) ( \alpha ) } \, \begin{matrix} P ^ { \prime } ( s _ { 1 } ( I ) \oplus s ( \uparrow I ) ) ( \alpha ) & 0 \\ 0 & P ^ { \prime } ( s k ( I ) ) ( \alpha ) \end{matrix} \right ] .
\end{aligned}
\]
```
- RAW: ```
By Theorems 5 . 1 \, \text { and } \, \text {Propositions} \, 5 . 4 \, \text { and } \, 5 . 5 , \, \text { we have} \\ \, \text { rank } E _ { I } ( \alpha ) + \text { rank } Q ( \alpha ) = \dim E _ { I } ( x ) - \dim P ^ { \prime } ( \text { sc } _ { 1 } ( I ) \oplus \text { sc } ( \uparrow I ) \oplus \text { sk } ( I ) ) ( x ) \\ + \text { rank } P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text { sc } _ { 1 } ( I ) \oplus \text { sc } ( \uparrow I ) \oplus \text { sk } ( I ) ) ( \alpha ) ] , \\ \, \text { rank } V _ { I } ( \alpha ) = \dim V _ { I } ( x ) - \dim P ^ { \prime } ( \text { sk } ( I ) ) ( x ) + \text { rank } [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text { sk } ( I ) ) ( \alpha ) ] , \\ + \text { rank } Q ( \alpha ) = \dim ( \text {v} _ { I } ) ( x ) - \dim P ^ { \prime } ( \text { sc } _ { 1 } ( I ) \oplus \text { sc } ( \uparrow I ) ) ( x ) \\ + \text { rank } [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text { sc } _ { 1 } ( I ) \oplus \text { sc } ( \uparrow I ) ) ( \alpha ) ] . \\ \text {Therefore by } ( 5 . 6 ) , \, \text { we have}
```
  FIX: ```
\[
\begin{aligned}
\operatorname{rank} E _ { I } ( \alpha ) + \operatorname{rank} Q ( \alpha ) = & \dim E _ { I } ( x ) - \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( x ) \\ & + \operatorname{rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( \alpha ) ] , \\ \operatorname{rank} V _ { I } ( \alpha ) = & \dim V _ { I } ( x ) - \dim P ^ { \prime } ( \text{sk} ( I ) ) ( x ) + \operatorname{rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text{sk} ( I ) ) ( \alpha ) ] , \\ \operatorname{rank} Q ( \alpha ) = & \dim ( V _ { I } ) ( x ) - \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( x ) \\ & + \operatorname{rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( \alpha ) ] .
\end{aligned}
\]
```
- RAW: ```
\text {There for by (5.63), we have} \\ d _ { M } ( V _ { I } ) = \dim E _ { I } ( x ) - \dim V _ { I } ( x ) - \dim \tau V _ { I } ( x ) + \dim P ^ { \prime } ( \text {sk} ( I ) ) ( x ) \\ + \dim P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) ) ( x ) - \dim P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) \oplus \text {sk} ( I ) ) ( x ) \\ + \text {rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) \oplus \text {sk} ( I ) ) ( \alpha ) ] \\ - \text {rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text {sk} ( I ) ) ( \alpha ) ] - \text {rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) ) ( \alpha ) ] \\ = \dim P ^ { \prime } ( \text {sk} ( I ) ) ( x ) + \dim P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) ) ( x ) - \dim P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) \oplus \text {sk} ( I ) ) ( x ) \\ + \text {rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) \oplus \text {sk} ( I ) ) ( \alpha ) ] \\ - \text {rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text {sk} ( I ) ) ( \alpha ) ] - \text {rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) ) ( \alpha ) ] \\ = \text {rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) \oplus \text {sk} ( I ) ) ( \alpha ) ] \\ - \text {rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text {sk} ( I ) ) ( \alpha ) ] - \text {rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text {sc} _ { 1 } ( I ) \oplus \text {sc} ( \uparrow I ) ) ( \alpha ) ] \\ = R H S \, of \, ( 5 . 7 4 ) . \\ \text {Case 2.} \, V _ { I } \text { is projective.} \\ \text {The assertion is proved in a way similar to Case 2. in Theorem 5.16 below.} \quad \Box \\
```
  FIX: ```
\[
\begin{aligned}
d _ { M } ( V _ { I } ) = & \dim E _ { I } ( x ) - \dim V _ { I } ( x ) - \dim \tau V _ { I } ( x ) + \dim P ^ { \prime } ( \text{sk} ( I ) ) ( x ) \\ & + \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( x ) - \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( x ) \\ & + \operatorname{rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( \alpha ) ] \\ & - \operatorname{rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text{sk} ( I ) ) ( \alpha ) ] - \operatorname{rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( \alpha ) ] \\ = & \dim P ^ { \prime } ( \text{sk} ( I ) ) ( x ) + \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( x ) - \dim P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( x ) \\ & + \operatorname{rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( \alpha ) ] \\ & - \operatorname{rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text{sk} ( I ) ) ( \alpha ) ] - \operatorname{rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( \alpha ) ] \\ = & \operatorname{rank} [ P ^ { \prime } ( g ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) \oplus \text{sk} ( I ) ) ( \alpha ) ] \\ & - \operatorname{rank} [ P ^ { \prime } ( g _ { 2 } ) ( x ) , P ^ { \prime } ( \text{sk} ( I ) ) ( \alpha ) ] - \operatorname{rank} [ P ^ { \prime } ( g _ { 1 } ) ( x ) , P ^ { \prime } ( \text{sc} _ { 1 } ( I ) \oplus \text{sc} ( \uparrow I ) ) ( \alpha ) ] \\ = & \text{RHS of } ( 5.74 ) .
\end{aligned}
\]
```
