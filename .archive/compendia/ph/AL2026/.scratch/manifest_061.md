# Manifest: Page 061

## REPAIR_MATH
- RAW: ```
P ^ { \prime } ( g _ { 1 } ) ( ( 0 , 0 ) , ( 1 , 1 ) ) & = [ \, _ { 1 } ^ { 1 } - _ { 1 } ^ { - 1 } \oplus [ \, _ { 0 } ^ { 0 } - _ { 1 } ^ { - 1 } \, ] \, , \quad P ^ { \prime } ( ( 1 , 2 ) , ( 2 , 2 ) ) ( \alpha ) = [ \, _ { 1 } ^ { 1 0 } ] \oplus [ \, _ { 1 } ^ { 1 0 } ] \, , \\ P ^ { \prime } ( g _ { 2 } ) ( ( 0 , 0 ) , ( 1 , 1 ) ) & = [ \, _ { 1 } ^ { 0 0 } \, _ { 1 } ^ { 1 } \, ] \oplus [ \, _ { 0 0 } ^ { 0 0 } \, _ { 1 } \, ] \, , \quad P ^ { \prime } ( ( 1 , 2 ) , ( 2 , 1 ) ) ( \alpha ) = [ \, _ { 1 0 } ^ { 1 0 } ] \oplus [ \, _ { 0 1 } ^ { 0 0 } ] \, . \\ P ^ { \prime } ( g _ { 3 } ) ( ( 0 , 0 ) , ( 1 , 1 ) ) & = [ \, _ { 0 0 } ^ { 1 0 } ] \oplus [ \, _ { 0 0 } ^ { 0 0 } ] \, ,
```
  FIX: ```
\[
\begin{aligned}
P ^ { \prime } ( g _ { 1 } ) ( ( 0 , 0 ) , ( 1 , 1 ) ) & = [ \, _ { 1 } ^ { 1 } - _ { 1 } ^ { - 1 } \oplus [ \, _ { 0 } ^ { 0 } - _ { 1 } ^ { - 1 } \, ] \, , \quad P ^ { \prime } ( ( 1 , 2 ) , ( 2 , 2 ) ) ( \alpha ) = [ \, _ { 1 } ^ { 1 0 } ] \oplus [ \, _ { 1 } ^ { 1 0 } ] \, , \\ P ^ { \prime } ( g _ { 2 } ) ( ( 0 , 0 ) , ( 1 , 1 ) ) & = [ \, _ { 1 } ^ { 0 0 } \, _ { 1 } ^ { 1 } \, ] \oplus [ \, _ { 0 0 } ^ { 0 0 } \, _ { 1 } \, ] \, , \quad P ^ { \prime } ( ( 1 , 2 ) , ( 2 , 1 ) ) ( \alpha ) = [ \, _ { 1 0 } ^ { 1 0 } ] \oplus [ \, _ { 0 1 } ^ { 0 0 } ] \, . \\ P ^ { \prime } ( g _ { 3 } ) ( ( 0 , 0 ) , ( 1 , 1 ) ) & = [ \, _ { 0 0 } ^ { 1 0 } ] \oplus [ \, _ { 0 0 } ^ { 0 0 } ] \, ,
\end{aligned}
\]
```
- RAW: ```
M = \left [ \frac { \left [ \begin{smallmatrix} 1 - 1 \\ 1 & 0 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 0 - 1 \\ 0 & 0 \end{smallmatrix} \right ] } { \left [ \begin{smallmatrix} 1 & 0 \\ 0 & 0 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 0 & 0 \\ 0 & 1 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 0 & 0 \\ 1 & 1 \end{smallmatrix} \right ] } \right ] .
```
  FIX: ```
\[
M = \left [ \frac { \left [ \begin{smallmatrix} 1 - 1 \\ 1 & 0 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 0 - 1 \\ 0 & 0 \end{smallmatrix} \right ] } { \left [ \begin{smallmatrix} 1 & 0 \\ 0 & 0 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 0 & 0 \\ 0 & 1 \end{smallmatrix} \right ] \oplus \left [ \begin{smallmatrix} 0 & 0 \\ 1 & 1 \end{smallmatrix} \right ] } \right ] .
\]
```

## REPAIR_PROSE
- RAW: `Fig. 3 A G 3 , 3 -filtration F`
  FIX: `Fig. 3 A \( G_{3,3} \)-filtration \( F \)`
- RAW: `respectively. By Proposition 5.11 , we have`
  FIX: `respectively. By Proposition 5.11, we have`
- RAW: `By noticing Remark 5.8 , put`
  FIX: `By noticing Remark 5.8, put`
- RAW: `The ranks of M and another matrix in Theorem 5.7 are both 8 . Therefore, d M ( V I ) = 8 − 8 = 0 .`
  FIX: `The ranks of \( M \) and another matrix in Theorem 5.7 are both \( 8 \). Therefore, \( d_M(V_I) = 8 - 8 = 0 \).`
- RAW: `Indeed, recalling Proposition 3.54 and Remark 3.41 . Since sc( I ) = { (0 , 2) , (1 , 1) } is not a subset of { (0 , 0) , (1 , 1) } (the set of row indices of P ( α ) , which is exactly supp(top M ) ), we have that I / ∈ crt 0 ( M ) and thereby d M ( V I ) = 0 . This therefore provides a twofold confirmation of the validity of formula ( 5.74 ) and the correctness of the criterion stated in Proposition 3.54 .`
  FIX: `Indeed, recalling Proposition 3.54 and Remark 3.41. Since \( \operatorname{sc}(I) = \{(0, 2), (1, 1)\} \) is not a subset of \( \{(0, 0), (1, 1)\} \) (the set of row indices of \( P(\alpha) \), which is exactly \( \operatorname{supp}(\operatorname{top} M) \)), we have that \( I \notin \operatorname{crt}_0(M) \) and thereby \( d_M(V_I) = 0 \). This therefore provides a twofold confirmation of the validity of formula (5.74) and the correctness of the criterion stated in Proposition 3.54.`
- RAW: `For an M ∈ mod A , there also exists a way to compute an injective copresentation Q • of M in the filtration level. Therefore, we next give a formula of d M ( V I ) for any I ∈ I using Q • . For this purpose, we first give the dual statement of Lemma 2.10 .`
  FIX: `For an \( M \in \operatorname{mod} A \), there also exists a way to compute an injective copresentation \( Q^\bullet \) of \( M \) in the filtration level. Therefore, we next give a formula of \( d_M(V_I) \) for any \( I \in \mathcal{I} \) using \( Q^\bullet \). For this purpose, we first give the dual statement of Lemma 2.10.`


