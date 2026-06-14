# Manifest: Page 026

## REPAIR_MATH
- RAW: ```
P _ { s k ( \psi I ) } ^ { \prime } \oplus P _ { s k _ { 1 } ( I ) } ^ { \prime } \xrightarrow { \psi _ { 1 } } P _ { s k ( I ) } ^ { \prime } \xrightarrow { \psi _ { 0 } } D V _ { I } \rightarrow 0 .
```
  FIX: ```
$$
P _ { s k ( \psi I ) } ^ { \prime } \oplus P _ { s k _ { 1 } ( I ) } ^ { \prime } \xrightarrow { \psi _ { 1 } } P _ { s k ( I ) } ^ { \prime } \xrightarrow { \psi _ { 0 } } D V _ { I } \rightarrow 0 .
$$
```
- RAW: ```
\psi _ { 1 } ^ { \downarrow I } \coloneqq [ \text {P} _ { b , b _ { d } } ] _ { ( b , b _ { d } ) \in \text {sk} ( I ) \times \text {sk} _ { 1 } ( I ) } \, ,
```
  FIX: ```
$$
\psi _ { 1 } ^ { \downarrow I } \coloneqq [ \text {P} _ { b , b _ { d } } ] _ { ( b , b _ { d } ) \in \text {sk} ( I ) \times \text {sk} _ { 1 } ( I ) } \, ,
$$
```
- RAW: ```
P _ { \sim } b , b _ { d } \colon = \begin{cases} P ^ { \prime } _ { d , b } & ( b = \underline { b } ) , \\ - P ^ { \prime } _ { d , b } & ( b = \overline { b } ) , \\ 0 & ( b \not \in \mathfrak { b } ) , \end{cases}
```
  FIX: ```
$$
P _ { \sim } b , b _ { d } \colon = \begin{cases} P ^ { \prime } _ { d , b } & ( b = \underline { b } ) , \\ - P ^ { \prime } _ { d , b } & ( b = \overline { b } ) , \\ 0 & ( b \not \in \mathfrak { b } ) , \end{cases}
$$
```
- RAW: ```
b \in \text {sk} ( I ) . \quad \square
```
  FIX: ```
$$
b \in \text {sk} ( I ) . \quad \square
$$
```
- RAW: ```
P _ { s k ( \mathbb { V } I ) } ^ { t } \oplus P _ { s k _ { 1 } ( I ) } ^ { t } = P _ { 1 } ^ { t } \oplus P _ { 2 } ^ { t }
```
  FIX: ```
$$
P _ { s k ( \mathbb { V } I ) } ^ { t } \oplus P _ { s k _ { 1 } ( I ) } ^ { t } = P _ { 1 } ^ { t } \oplus P _ { 2 } ^ { t }
$$
```
- RAW: ```
P _ { s k ( I ) } \xrightarrow { \pi _ { 1 } = \left [ \Psi ^ { t } \right ] } P _ { 1 } \oplus P _ { 2 } \xrightarrow { ( \text {coker} \, \Psi ^ { t } ) \oplus 1 _ { P _ { 2 } } } \tau ^ { - 1 } V _ { I } \oplus P _ { 2 } \to 0 .
```
  FIX: ```
$$
P _ { s k ( I ) } \xrightarrow { \pi _ { 1 } = \left [ \Psi ^ { t } \right ] } P _ { 1 } \oplus P _ { 2 } \xrightarrow { ( \text {coker} \, \Psi ^ { t } ) \oplus 1 _ { P _ { 2 } } } \tau ^ { - 1 } V _ { I } \oplus P _ { 2 } \to 0 .
$$
```
- RAW: ```
\pi _ { 1 } = \pi _ { 1 } ( \mathbf d ) = \begin{bmatrix} \pi _ { 1 1 } \\ \substack { \mu _ { 1 1 } \\ \pi _ { 1 } ^ { \downarrow I } } \end{bmatrix} \colon = \begin{bmatrix} \psi _ { 1 1 } ^ { t } \\ ( \psi _ { 1 } ^ { \downarrow I } ) ^ { t } \end{bmatrix} \colon P _ { \text {sk} ( I ) } \to P _ { \text {sk} ( \Downarrow I ) } \oplus P _ { \text {sk} ( I ) }
```
  FIX: ```
$$
\pi _ { 1 } = \pi _ { 1 } ( \mathbf d ) = \begin{bmatrix} \pi _ { 1 1 } \\ \substack { \mu _ { 1 1 } \\ \pi _ { 1 } ^ { \downarrow I } } \end{bmatrix} \colon = \begin{bmatrix} \psi _ { 1 1 } ^ { t } \\ ( \psi _ { 1 } ^ { \downarrow I } ) ^ { t } \end{bmatrix} \colon P _ { \text {sk} ( I ) } \to P _ { \text {sk} ( \Downarrow I ) } \oplus P _ { \text {sk} ( I ) }
$$
```

## REPAIR_PROSE
- RAW: ```
Proposition 3.22. Let I be an interval of P . Then the interval module DV I has the following (not necessarily minimal) projective presentation 3 in mod A op :
```
  FIX: ```
Proposition 3.22. Let \( I \) be an interval of \( P \). Then the interval module \( DV_I \) has the following (not necessarily minimal) projective presentation 3 in \( \text{mod} \, A^{op} \):
```
- RAW: ```
Here ψ 0 : = λ V I 1 b b ∈ sk( I ) and ψ 1 : = ψ 1 ( d ) : = ψ 11 ,ψ ↓ I 1 , where ψ 11 : = ψ 11 ( d ) is given by ψ 11 : = δ b, d ( b ′ ) P ′ b ′ , d ( b ′ ) ( b,b ′ ) ∈ sk( I ) × sk( ⇓ I ) , and
```
  FIX: ```
Here \( \psi_0 \colon= [ \lambda_{V_I} 1_b ]_{b \in \text{sk}(I)} \) and \( \psi_1 \colon= \psi_1(\mathbf{d}) \colon= [ \psi_{11}, \psi_1^{\downarrow I} ] \), where \( \psi_{11} \colon= \psi_{11}(\mathbf{d}) \) is given by \( \psi_{11} \colon= [ \delta_{b, d(b')} P'_{b', d(b')} ]_{(b,b') \in \text{sk}(I) \times \text{sk}(\Downarrow I)} \), and
```
- RAW: ```
for all b d ∈ sk 1 ( I ) and b ∈ sk( I ) .
```
  FIX: ```
for all \( b_d \in \text{sk}_1(I) \) and \( b \in \text{sk}(I) \).
```
- RAW: ```
The canonical isomorphism ( 3.24 ) allows us to make the identifications: P ′ sk( ⇓ I ) ⊕ P ′ sk 1 ( I ) = P t sk( ⇓ I ) ⊕ P t sk 1 ( I ) and P ′ sk( I ) = P t sk( I ) . Note here that ψ 0 is a projective cover of DV I in ( 3.25 ) because it induces an isomorphism top P t sk( I ) ∼ = top DV I , but ψ 1 : P t sk( ⇓ I ) ⊕ P t sk 1 ( I ) → Im ψ 1 is not always a projective cover. In any case, there exists a decomposition t t t t
```
  FIX: ```
The canonical isomorphism (3.24) allows us to make the identifications: \( P'_{\text{sk}(\Downarrow I)} \oplus P'_{\text{sk}_1(I)} = P^t_{\text{sk}(\Downarrow I)} \oplus P^t_{\text{sk}_1(I)} \) and \( P'_{\text{sk}(I)} = P^t_{\text{sk}(I)} \). Note here that \( \psi_0 \) is a projective cover of \( DV_I \) in (3.25) because it induces an isomorphism \( \text{top} \, P^t_{\text{sk}(I)} \cong \text{top} \, DV_I \), but \( \psi_1 \colon P^t_{\text{sk}(\Downarrow I)} \oplus P^t_{\text{sk}_1(I)} \to \text{Im} \, \psi_1 \) is not always a projective cover. In any case, there exists a decomposition
```
- RAW: ```
⇓ 1 of the domain of ψ 1 such that the restriction Ψ: P t 1 → Im ψ 1 of ψ 1 is a projective cover. With respect to the new decomposition P t 1 ⊕ P t 2 of the domain of ψ 1 , ψ 1 has the matrix expression ψ 1 = Ψ , 0 .
```
  FIX: ```
of the domain of \( \psi_1 \) such that the restriction \( \Psi \colon P^t_1 \to \text{Im} \, \psi_1 \) of \( \psi_1 \) is a projective cover. With respect to the new decomposition \( P^t_1 \oplus P^t_2 \) of the domain of \( \psi_1 \), \( \psi_1 \) has the matrix expression \( \psi_1 = [ \Psi, 0 ] \).
```
- RAW: ```
Proposition 3.23. In the setting above, we can give a projective presentation of τ − 1 V I ⊕ P 2 as follows:
```
  FIX: ```
Proposition 3.23. In the setting above, we can give a projective presentation of \( \tau^{-1} V_I \oplus P_2 \) as follows:
```
- RAW: ```
Here by changing the decomposition of the middle term to the right hand side of the equality P 1 ⊕ P 2 = P sk( ⇓ I ) ⊕ P sk 1 ( I ) , we have
```
  FIX: ```
Here by changing the decomposition of the middle term to the right hand side of the equality \( P_1 \oplus P_2 = P_{\text{sk}(\Downarrow I)} \oplus P_{\text{sk}_1(I)} \), we have
```
- RAW: ```
3 We changed the order of direct summands as in P ′ sk( ⇓ I ) ⊕ P ′ sk 1 ( I ) because we wanted to put matrices dependent on choice maps closer to each other in the final formula.
```
  FIX: ```
3 We changed the order of direct summands as in \( P'_{\text{sk}(\Downarrow I)} \oplus P'_{\text{sk}_1(I)} \) because we wanted to put matrices dependent on choice maps closer to each other in the final formula.
```
