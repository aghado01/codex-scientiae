# Manifest: Page 030

## REPAIR_MATH
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M ( \varepsilon _ { 1 } ) } { M ( \lambda ) } \Big | _ { M ( \pi _ { 1 } ) } \right ] - \text {rank} \, M ( \varepsilon _ { 1 } ) - \text {rank} \, M ( \pi _ { 1 } ) .
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text {rank} \left [ \frac { M ( \varepsilon _ { 1 } ) } { M ( \lambda ) } \Big | _ { M ( \pi _ { 1 } ) } \right ] - \text {rank} \, M ( \varepsilon _ { 1 } ) - \text {rank} \, M ( \pi _ { 1 } ) .
$$
```
- RAW: ```
\varepsilon _ { 1 1 } & \coloneqq \left [ \delta _ { a , c ( a ^ { \prime } ) } P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] ( a , a ^ { \prime } ) \in & s c ( I ) \times & s c ( \uparrow I ) \ , \ \ a n d \\ \varepsilon _ { 1 } ^ { \uparrow I } & \coloneqq \left [ \tilde { P } _ { a , a _ { c } } \right ] _ { ( a , a _ { c } ) \in s c ( I ) \times s c _ { 1 } ( I ) }
```
  FIX: ```
$$
\begin{aligned}
\varepsilon _ { 1 1 } & \coloneqq \left [ \delta _ { a , c ( a ^ { \prime } ) } P _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { ( a , a ^ { \prime } ) \in s c ( I ) \times s c ( \Uparrow I ) } \ , \ \ a n d \\ \varepsilon _ { 1 } ^ { \uparrow I } & \coloneqq \left [ \tilde { P } _ { a , a _ { c } } \right ] _ { ( a , a _ { c } ) \in s c ( I ) \times s c _ { 1 } ( I ) }
\end{aligned}
$$
```
- RAW: ```
\tilde { P } _ { a , a _ { c } } \colon = \begin{cases} P _ { c , a } & ( a = \underline { a } ) , \\ - P _ { c , a } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{cases}
```
  FIX: ```
$$
\tilde { P } _ { a , a _ { c } } \colon = \begin{cases} P _ { c , a } & ( a = \underline { a } ) , \\ - P _ { c , a } & ( a = \overline { a } ) , \\ 0 & ( a \not \in \mathfrak { a } ) , \end{cases}
$$
```
- RAW: ```
\pi _ { 1 1 } & \colon = \left [ \delta _ { b , d ( b ^ { \prime } ) } P _ { d ( b ^ { \prime } ) , b ^ { \prime } } \right ] ( b ^ { \prime } , b ) \in & s k ( \downarrow I ) \times & s k ( I ) \ , \ \ a n d \\ \pi _ { 1 } ^ { \downarrow I } & \colon = \left [ \hat { P } _ { b , b _ { d } } \right ] _ { ( b _ { d } , b ) \in \text {sk} _ { 1 } ( I ) \times \text {sk} ( I ) } ,
```
  FIX: ```
$$
\begin{aligned}
\pi _ { 1 1 } & \colon = \left [ \delta _ { b , d ( b ^ { \prime } ) } P _ { d ( b ^ { \prime } ) , b ^ { \prime } } \right ] _ { ( b ^ { \prime } , b ) \in s k ( \Downarrow I ) \times s k ( I ) } \ , \ \ a n d \\ \pi _ { 1 } ^ { \downarrow I } & \colon = \left [ \hat { P } _ { b , b _ { d } } \right ] _ { ( b _ { d } , b ) \in \text {sk} _ { 1 } ( I ) \times \text {sk} ( I ) } ,
\end{aligned}
$$
```
- RAW: ```
\hat { P } _ { b , b _ { d } } \colon = \begin{cases} P _ { b , d } & ( b = \underline { b } ) , \\ - P _ { b , d } & ( b = \overline { b } ) , \\ 0 & ( b \not \in \mathfrak { b } ) , \end{cases}
```
  FIX: ```
$$
\hat { P } _ { b , b _ { d } } \colon = \begin{cases} P _ { b , d } & ( b = \underline { b } ) , \\ - P _ { b , d } & ( b = \overline { b } ) , \\ 0 & ( b \not \in \mathfrak { b } ) , \end{cases}
$$
```

## REPAIR_PROSE
- RAW: `Theorem 3.27. Let M ∈ mod A and I an interval of P with sc( I ) = { a 1 ,...,a n } and sk( I ) = { b 1 ,...,b m } . Choose any choice maps c : sc( ⇑ I ) → sc( I ) and d : sk( ⇓ I ) → sk( I ) , and any ( j,i ) ∈ [ m ] × [ n ] such that b j ≥ a i . Set λ : = λ ( b j ,a i ) as in Proposition 3.24 . Then`
  FIX: `Theorem 3.27. Let \( M \in \operatorname{mod} A \) and \( I \) an interval of \( P \) with \( \operatorname{sc}( I ) = \{ a_1, \dots, a_n \} \) and \( \operatorname{sk}( I ) = \{ b_1, \dots, b_m \} \). Choose any choice maps \( c \colon \operatorname{sc}( \Uparrow I ) \to \operatorname{sc}( I ) \) and \( d \colon \operatorname{sk}( \Downarrow I ) \to \operatorname{sk}( I ) \), and any \( ( j,i ) \in [ m ] \times [ n ] \) such that \( b_j \ge a_i \). Set \( \lambda := \lambda ( b_j, a_i ) \) as in Proposition 3.24. Then`

- RAW: `Here we collect definitions of ε 1 : = ε 1 ( c ) and π 1 : = π 1 ( d ) given in Propositions 3.18 and 3.23 : ε 1 : = ε ↑ I 1 ,ε 11 , where`
  FIX: `Here we collect definitions of \( \varepsilon_1 := \varepsilon_1( c ) \) and \( \pi_1 := \pi_1( d ) \) given in Propositions 3.18 and 3.23: \( \varepsilon_1 := \begin{bmatrix} \varepsilon_1^{\uparrow I} \\ \varepsilon_{11} \end{bmatrix} \), where`

- RAW: `for all a c ∈ sc 1 ( I ) and a ∈ sc( I ) ; and π 1 : = π 11 π ↓ I 1 , where`
  FIX: `for all \( a_c \in \operatorname{sc}_1( I ) \) and \( a \in \operatorname{sc}( I ) \); and \( \pi_1 := \begin{bmatrix} \pi_{11} \\ \pi_1^{\downarrow I} \end{bmatrix} \), where`

- RAW: `for all b ∈ sk( I ) and b d ∈ sk 1 ( I ) .`
  FIX: `for all \( b \in \operatorname{sk}( I ) \) and \( b_d \in \operatorname{sk}_1( I ) \).`

- RAW: `We specialize the general formula ( 3.37 ) to the case where P = G m,n for some m,n ≥ 2 to make the formula easier to see. Denote by the maximum element ( m,n ) (resp. minimum element (0 , 0) ) of P by ω (resp. ˆ 0 ).`
  FIX: `We specialize the general formula (3.37) to the case where \( P = G_{m,n} \) for some \( m,n \ge 2 \) to make the formula easier to see. Denote by the maximum element \( ( m,n ) \) (resp. minimum element \( ( 0, 0 ) \)) of \( P \) by \( \omega \) (resp. \( \hat{0} \)).`

- RAW: `In this subsection, by Definition 2.4 , we will write I = [sc( I ) , sk( I )] for all I ∈ I .`
  FIX: `In this subsection, by Definition 2.4, we will write \( I = [\operatorname{sc}( I ), \operatorname{sk}( I )] \) for all \( I \in \mathcal{I} \).`

- RAW: `Notation 3.28. Set sc( ↑ I ) = sc( I ) = { a 1 ,...,a k } , sc( ⇑ I ) = { a ′ 1 ,...,a ′ k ′ } and sk( ↓ I ) = sk( I ) = { b 1 ,...,b l } , sk( ⇓ I ) = { b ′ 1 ,...,b ′ l ′ } (see ( 3.12 ) for the definitions of`
  FIX: `Notation 3.28. Set \( \operatorname{sc}( \uparrow I ) = \operatorname{sc}( I ) = \{ a_1, \dots, a_k \} \), \( \operatorname{sc}( \Uparrow I ) = \{ a'_1, \dots, a'_{k'} \} \) and \( \operatorname{sk}( \downarrow I ) = \operatorname{sk}( I ) = \{ b_1, \dots, b_l \} \), \( \operatorname{sk}( \Downarrow I ) = \{ b'_1, \dots, b'_{l'} \} \) (see (3.12) for the definitions of`
