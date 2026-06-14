# Manifest: Page 029

## REPAIR_MATH
- RAW: ```
\text {bottom row exact:} \\ ( P _ { s c _ { 1 } ( I ) } \oplus P _ { s c _ { 1 } ( I ) } ) \oplus P _ { s k ( I ) } & \xrightarrow { \mu _ { E } } P _ { s c ( I ) } \oplus ( P _ { s k ( I ) } \oplus P _ { s k _ { 1 } ( I ) } ) \xrightarrow { \varepsilon _ { E } } E \oplus P _ { 2 } \longrightarrow 0 \\ & \left \| \begin{array} { c } \\ \\ \\ \\ ( P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( I ) } \uparrow ) \oplus P _ { s k ( I ) } \xrightarrow { \gamma _ { I } } V _ { 1 } \oplus ( P _ { s k ( I ) } \oplus P _ { s k _ { 1 } ( I ) } ) \xrightarrow { \gamma _ { I } } E \oplus P _ { 2 } \longrightarrow 0 \\ & \left [ 0 \, \eta _ { 1 } \right ] \\ \end{array} \right \| _ { \pi } , \\ \intertext { b o w s r. at $ \{ \varepsilon _ { I } , \eta ^ { \prime } \} $ } & \left [ \varepsilon _ { I } , \eta ^ { \prime } \right ] _ { s k ( I ) } \oplus P _ { s k ( I ) } \xrightarrow { \varepsilon _ { E } } E \oplus P _ { 2 } \longrightarrow 0
```
  FIX: ```
$$
\text {bottom row exact:} \\ ( P _ { s c _ { 1 } ( I ) } \oplus P _ { s c _ { 1 } ( I ) } ) \oplus P _ { s k ( I ) } & \xrightarrow { \mu _ { E } } P _ { s c ( I ) } \oplus ( P _ { s k ( I ) } \oplus P _ { s k _ { 1 } ( I ) } ) \xrightarrow { \varepsilon _ { E } } E \oplus P _ { 2 } \longrightarrow 0 \\ & \left \| \begin{array} { c } \\ \\ \\ \\ ( P _ { s c _ { 1 } ( I ) } \oplus P _ { s c ( I ) } \uparrow ) \oplus P _ { s k ( I ) } \xrightarrow { \gamma _ { I } } V _ { 1 } \oplus ( P _ { s k ( I ) } \oplus P _ { s k _ { 1 } ( I ) } ) \xrightarrow { \gamma _ { I } } E \oplus P _ { 2 } \longrightarrow 0 \\ & \left [ 0 \, \eta _ { 1 } \right ] \\ \end{array} \right \| _ { \pi } , \\ \intertext { b o w s r. at $ \{ \varepsilon _ { I } , \eta ^ { \prime } \} $ } & \left [ \varepsilon _ { I } , \eta ^ { \prime } \right ] _ { s k ( I ) } \oplus P _ { s k ( I ) } \xrightarrow { \varepsilon _ { E } } E \oplus P _ { 2 } \longrightarrow 0
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M ( \varepsilon _ { 1 } ) } { M ( \lambda ) } \Big | _ { M ( \pi _ { 1 } ) } \right ] - \text {rank} \, M ( \varepsilon _ { 1 } ) - \text {rank} \, M ( \pi _ { 1 } ) .
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M ( \varepsilon _ { 1 } ) } { M ( \lambda ) } \Big | _ { M ( \pi _ { 1 } ) } \right ] - \text {rank} \, M ( \varepsilon _ { 1 } ) - \text {rank} \, M ( \pi _ { 1 } ) .
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) & = \dim H o m _ { A } ( V _ { I } , M ) - \dim H o m _ { A } ( E , M ) \\ & + \dim H o m _ { A } ( \tau ^ { - 1 } V _ { I } , M ) \\ & = \dim H o m _ { A } ( V _ { I } , M ) - \dim H o m _ { A } ( E \oplus P _ { 2 } , M ) \\ & + \dim H o m _ { A } ( \tau ^ { - 1 } V _ { I } \oplus P _ { 2 } , M ) ,
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) & = \dim H o m _ { A } ( V _ { I } , M ) - \dim H o m _ { A } ( E , M ) \\ & + \dim H o m _ { A } ( \tau ^ { - 1 } V _ { I } , M ) \\ & = \dim H o m _ { A } ( V _ { I } , M ) - \dim H o m _ { A } ( E \oplus P _ { 2 } , M ) \\ & + \dim H o m _ { A } ( \tau ^ { - 1 } V _ { I } \oplus P _ { 2 } , M ) ,
$$
```

## REPAIR_PROSE
- RAW: ```
where π : = µ, − θ ⊕ 0 . This is extended to the following commutative diagram with the bottom row exact:
```
  FIX: ```
where \( \pi := [\mu, -\theta] \oplus 0 \). This is extended to the following commutative diagram with the bottom row exact:
```
- RAW: ```
where we set µ E : = ε 1 η ′ 0 π 1 and ε E : = π ◦ ε 0 0 0 1 l , which is an epimorphism as the composite of epimorphisms.
```
  FIX: ```
where we set \( \mu_E := \left[ \begin{smallmatrix} \varepsilon_1 & \eta' \\ 0 & \pi_1 \end{smallmatrix} \right] \) and \( \varepsilon_E := \pi \circ \left[ \begin{smallmatrix} \varepsilon_0 & 0 \\ 0 & 1 \end{smallmatrix} \right] \), which is an epimorphism as the composite of epimorphisms.
```
- RAW: ```
It remains to show that ε E is a cokernel morphism of µ E . By the commutativity of the diagram and the exactness of the bottom row, we see that ε E µ E = 0 . Let f, g : P sc( I ) ⊕ ( P sk( ⇓ I ) ⊕ P sk 1 ( I ) ) → X be a morphism with f, g · µ E = 0 . Then fε 1 = 0 . Since ε 0 is a cokernel morphism of ε 1 , there exists some f ′ : V I → X such that f = f ′ ε 0 . Then we have f, g = f ′ , g · ε 0 0 0 1 l . Now f ′ , g · 0 η 0 π 1 = f ′ , g ε 0 0 0 1 l µ E = f, g · µ E = 0 . Hence f ′ , g factors through π , that is, f ′ , g = hπ for some h : E ⊕ P 2 → X . Therefore, we have f, g = hπ ε 0 0 0 1 l = h ε E . The uniqueness of h follows from the fact that ε E is an epimorphism. As a consequence, ε E is a cokernel morphism of µ E . □
```
  FIX: ```
It remains to show that \( \varepsilon_E \) is a cokernel morphism of \( \mu_E \). By the commutativity of the diagram and the exactness of the bottom row, we see that \( \varepsilon_E \mu_E = 0 \). Let \( [f, g] : P_{sc(I)} \oplus (P_{sk(\Downarrow I)} \oplus P_{sk_1(I)}) \to X \) be a morphism with \( [f, g] \cdot \mu_E = 0 \). Then \( f\varepsilon_1 = 0 \). Since \( \varepsilon_0 \) is a cokernel morphism of \( \varepsilon_1 \), there exists some \( f' : V_I \to X \) such that \( f = f'\varepsilon_0 \). Then we have \( [f, g] = [f', g] \cdot \left[ \begin{smallmatrix} \varepsilon_0 & 0 \\ 0 & 1 \end{smallmatrix} \right] \). Now \( [f', g] \cdot \left[ \begin{smallmatrix} 0 & \eta \\ 0 & \pi_1 \end{smallmatrix} \right] = [f', g] \left[ \begin{smallmatrix} \varepsilon_0 & 0 \\ 0 & 1 \end{smallmatrix} \right] \mu_E = [f, g] \cdot \mu_E = 0 \). Hence \( [f', g] \) factors through \( \pi \), that is, \( [f', g] = h\pi \) for some \( h : E \oplus P_2 \to X \). Therefore, we have \( [f, g] = h\pi \left[ \begin{smallmatrix} \varepsilon_0 & 0 \\ 0 & 1 \end{smallmatrix} \right] = h\varepsilon_E \). The uniqueness of \( h \) follows from the fact that \( \varepsilon_E \) is an epimorphism. As a consequence, \( \varepsilon_E \) is a cokernel morphism of \( \mu_E \). \( \Box \)
```
- RAW: ```
We are now in a position to state the formula of d M ( V I ) in this case.
```
  FIX: ```
We are now in a position to state the formula of \( d_M(V_I) \) in this case.
```
- RAW: ```
Theorem 3.25. Let M ∈ mod A and I an interval of P with sc( I ) = { a 1 ,...,a n } and sk( I ) = { b 1 ,...,b m } . Choose any choice maps c : sc( ⇑ I ) → sc( I ) and d : sk( ⇓ I ) → sk( I ) , and set ε 1 : = ε 1 ( c ) , π 1 : = π 1 ( d ) as in Propositions 3.18 and 3.23 . Choose also any ( j,i ) ∈ [ m ] × [ n ] such that b j ≥ a i , and set λ : = λ ( b j ,a i ) as in Proposition 3.24 . Assume that V I is non-injective ( i.e., m ≥ 2) . Then
```
  FIX: ```
**Theorem 3.25.** Let \( M \in \text{mod}\, A \) and \( I \) an interval of \( P \) with \( sc(I) = \{ a_1, \dots, a_n \} \) and \( sk(I) = \{ b_1, \dots, b_m \} \). Choose any choice maps \( c : sc(\Uparrow I) \to sc(I) \) and \( d : sk(\Downarrow I) \to sk(I) \), and set \( \varepsilon_1 := \varepsilon_1(c) \), \( \pi_1 := \pi_1(d) \) as in Propositions 3.18 and 3.23. Choose also any \( (j, i) \in [m] \times [n] \) such that \( b_j \ge a_i \), and set \( \lambda := \lambda(b_j, a_i) \) as in Proposition 3.24. Assume that \( V_I \) is non-injective (i.e., \( m \ge 2 \)). Then
```
- RAW: ```
Proof Because V I is not injective, the value of d M ( V I ) can be computed from the three terms of the almost split sequence ( 3.9 ) by using Theorem 3.3 as follows:
```
  FIX: ```
*Proof.* Because \( V_I \) is not injective, the value of \( d_M(V_I) \) can be computed from the three terms of the almost split sequence (3.9) by using Theorem 3.3 as follows:
```
- RAW: ```
where P 2 is a direct summand of P sk( ⇓ I ) ⊕ P sk 1 ( I ) as in ( 3.28 ). Hence the assertion follows by Lemma 2.10 , and Propositions 3.18 , 3.23 and 3.24 . □
```
  FIX: ```
where \( P_2 \) is a direct summand of \( P_{sk(\Downarrow I)} \oplus P_{sk_1(I)} \) as in (3.28). Hence the assertion follows by Lemma 2.10, and Propositions 3.18, 3.23 and 3.24. \( \Box \)
```
- RAW: ```
Remark 3.26. We note here that the formula ( 3.35 ) covers all cases, regardless of whether V I is injective or not.
```
  FIX: ```
**Remark 3.26.** We note here that the formula (3.35) covers all cases, regardless of whether \( V_I \) is injective or not.
```
- RAW: ```
Summarizing Theorems 3.20 and 3.25 , we obtain the following.
```
  FIX: ```
Summarizing Theorems 3.20 and 3.25, we obtain the following.
```
