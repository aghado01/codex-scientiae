# Manifest: Page 056

## REPAIR_MATH
- RAW: ```
P ^ { \prime } ( g _ { 1 } ) ( x ) \colon P ^ { \prime } ( s c ( I ) ) ( x ) & \to P ^ { \prime } ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) ( x ) , \\ P ^ { \prime } ( g _ { 2 } ) ( x ) \colon P ^ { \prime } ( s k ( \downarrow I ) \oplus s k _ { 1 } ( I ) ) ( x ) & \to P ^ { \prime } ( s k ( I ) ) ( x ) , \\ P ^ { \prime } ( g _ { 3 } ) ( x ) \colon P ^ { \prime } ( s c ( I ) ) ( x ) & \to P ^ { \prime } ( s k ( I ) ) ( x ) , \\ P ^ { \prime } ( s c _ { 1 } ( I ) ) ( \alpha ) \colon P ^ { \prime } ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) ( y ) & \to P ^ { \prime } ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) ( x ) , \\ P ^ { \prime } ( s k ( I ) ) ( \alpha ) \colon P ^ { \prime } ( s k ( I ) ) ^ { y } & \to P ^ { \prime } ( s k ( I ) ) ( x ) .
```
  FIX: ```
\[
\begin{aligned}
P ^ { \prime } ( g _ { 1 } ) ( x ) \colon P ^ { \prime } ( s c ( I ) ) ( x ) & \to P ^ { \prime } ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) ( x ) , \\ P ^ { \prime } ( g _ { 2 } ) ( x ) \colon P ^ { \prime } ( s k ( \downarrow I ) \oplus s k _ { 1 } ( I ) ) ( x ) & \to P ^ { \prime } ( s k ( I ) ) ( x ) , \\ P ^ { \prime } ( g _ { 3 } ) ( x ) \colon P ^ { \prime } ( s c ( I ) ) ( x ) & \to P ^ { \prime } ( s k ( I ) ) ( x ) , \\ P ^ { \prime } ( s c _ { 1 } ( I ) ) ( \alpha ) \colon P ^ { \prime } ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) ( y ) & \to P ^ { \prime } ( s c _ { 1 } ( I ) \oplus s c ( \uparrow I ) ) ( x ) , \\ P ^ { \prime } ( s k ( I ) ) ( \alpha ) \colon P ^ { \prime } ( s k ( I ) ) ^ { y } & \to P ^ { \prime } ( s k ( I ) ) ( x ) .
\end{aligned}
\]
```
- RAW: ```
P ^ { \prime } ( u ) ( v ) = P ^ { \prime } ( u ) ( v _ { 1 } ) \oplus \cdots \oplus P ^ { \prime } ( u ) ( v _ { n } ) = P ^ { \prime } _ { u _ { 1 } } ( v _ { 1 } ) \oplus \cdots \oplus P ^ { \prime } _ { u _ { m } } ( v _ { 1 } ) \oplus P ^ { \prime } _ { u _ { 1 } } ( v _ { 2 } ) \oplus \cdots \oplus \\ P ^ { \prime } _ { u _ { m } } ( v _ { 2 } ) \oplus \cdots \oplus P ^ { \prime } _ { u _ { 1 } } ( v _ { n } ) \oplus \cdots \oplus P ^ { \prime } _ { u _ { m } } ( v _ { n } ) .
```
  FIX: ```
\[
\begin{aligned}
P ^ { \prime } ( u ) ( v ) = P ^ { \prime } ( u ) ( v _ { 1 } ) \oplus \cdots \oplus P ^ { \prime } ( u ) ( v _ { n } ) = P ^ { \prime } _ { u _ { 1 } } ( v _ { 1 } ) \oplus \cdots \oplus P ^ { \prime } _ { u _ { m } } ( v _ { 1 } ) \oplus P ^ { \prime } _ { u _ { 1 } } ( v _ { 2 } ) \oplus \cdots \oplus \\ P ^ { \prime } _ { u _ { m } } ( v _ { 2 } ) \oplus \cdots \oplus P ^ { \prime } _ { u _ { 1 } } ( v _ { n } ) \oplus \cdots \oplus P ^ { \prime } _ { u _ { m } } ( v _ { n } ) .
\end{aligned}
\]
```
- RAW: ```
g = \left [ \begin{matrix} p _ { a _ { 1 2 } , a _ { 1 } } - p _ { a _ { 1 2 } , a _ { 2 } } & 0 & 0 \\ p _ { a ^ { \prime } _ { 1 } , a _ { 1 } } & 0 & 0 \\ \frac { p _ { a ^ { \prime } _ { 1 } , a _ { 1 } } } { p _ { b _ { 1 } , a _ { 1 } } } & 0 & p _ { b _ { 1 } , b ^ { \prime } _ { 1 } } & p _ { b _ { 1 } , b _ { 1 2 } } \\ 0 & 0 & 0 & - p _ { b _ { 2 } , b _ { 1 2 } } \end{matrix} \right ] = \left [ \begin{matrix} p _ { 2 ^ { \prime } , 2 } - p _ { 2 ^ { \prime } , 1 ^ { \prime } } & 0 & 0 \\ p _ { 4 ^ { \prime } , 2 } & 0 & 0 \\ p _ { 4 , 2 } & 0 & p _ { 4 , 1 } & p _ { 4 , 3 } \\ 0 & 0 & 0 & - p _ { 3 ^ { \prime } , 3 } \end{matrix} \right ] .
```
  FIX: ```
\[
g = \left [ \begin{matrix} p _ { a _ { 1 2 } , a _ { 1 } } - p _ { a _ { 1 2 } , a _ { 2 } } & 0 & 0 \\ p _ { a ^ { \prime } _ { 1 } , a _ { 1 } } & 0 & 0 \\ \frac { p _ { a ^ { \prime } _ { 1 } , a _ { 1 } } } { p _ { b _ { 1 } , a _ { 1 } } } & 0 & p _ { b _ { 1 } , b ^ { \prime } _ { 1 } } & p _ { b _ { 1 } , b _ { 1 2 } } \\ 0 & 0 & 0 & - p _ { b _ { 2 } , b _ { 1 2 } } \end{matrix} \right ] = \left [ \begin{matrix} p _ { 2 ^ { \prime } , 2 } - p _ { 2 ^ { \prime } , 1 ^ { \prime } } & 0 & 0 \\ p _ { 4 ^ { \prime } , 2 } & 0 & 0 \\ p _ { 4 , 2 } & 0 & p _ { 4 , 1 } & p _ { 4 , 3 } \\ 0 & 0 & 0 & - p _ { 3 ^ { \prime } , 3 } \end{matrix} \right ] .
\]
```
- RAW: ```
g _ { 1 } & = \left [ \begin{matrix} p _ { 2 ^ { \prime } , 2 } - p _ { 2 ^ { \prime } , 1 ^ { \prime } } \\ p _ { 4 ^ { \prime } , 2 } & 0 \end{matrix} \right ] \colon ( 2 , 1 ^ { \prime } ) \to ( 2 ^ { \prime } , 4 ^ { \prime } ) , \\ g _ { 2 } & = \left [ \begin{matrix} p _ { 4 , 1 } & p _ { 4 , 3 } \\ 0 & - p _ { 3 ^ { \prime } , 3 } \end{matrix} \right ] \colon ( 1 , 3 ) \to ( 4 , 3 ^ { \prime } ) , \\ g _ { 3 } & = \left [ \begin{matrix} p _ { 4 , 2 } & 0 \\ 0 & 0 \end{matrix} \right ] \colon ( 2 , 1 ^ { \prime } ) \to ( 4 , 3 ^ { \prime } ) .
```
  FIX: ```
\[
\begin{aligned}
g _ { 1 } & = \left [ \begin{matrix} p _ { 2 ^ { \prime } , 2 } - p _ { 2 ^ { \prime } , 1 ^ { \prime } } \\ p _ { 4 ^ { \prime } , 2 } & 0 \end{matrix} \right ] \colon ( 2 , 1 ^ { \prime } ) \to ( 2 ^ { \prime } , 4 ^ { \prime } ) , \\ g _ { 2 } & = \left [ \begin{matrix} p _ { 4 , 1 } & p _ { 4 , 3 } \\ 0 & - p _ { 3 ^ { \prime } , 3 } \end{matrix} \right ] \colon ( 1 , 3 ) \to ( 4 , 3 ^ { \prime } ) , \\ g _ { 3 } & = \left [ \begin{matrix} p _ { 4 , 2 } & 0 \\ 0 & 0 \end{matrix} \right ] \colon ( 2 , 1 ^ { \prime } ) \to ( 4 , 3 ^ { \prime } ) .
\end{aligned}
\]
```
- RAW: ```
0 \ 0 \, .
```
  FIX: ```
\[
0 \ 0 \, .
\]
```
- RAW: ```
\begin{bmatrix} p _ { 2 ^ { \prime } , 1 ^ { \prime } } & - p _ { 2 ^ { \prime } , 2 } & 0 \\ p _ { 4 ^ { \prime } , 1 ^ { \prime } } & 0 & 0 \\ 0 & 0 & p _ { 4 ^ { \prime } , 3 ^ { \prime } } \end{bmatrix} \colon ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) \to ( 2 ^ { \prime } , 4 ^ { \prime } , 4 ^ { \prime } ) .
```
  FIX: ```
\[
\begin{bmatrix} p _ { 2 ^ { \prime } , 1 ^ { \prime } } & - p _ { 2 ^ { \prime } , 2 } & 0 \\ p _ { 4 ^ { \prime } , 1 ^ { \prime } } & 0 & 0 \\ 0 & 0 & p _ { 4 ^ { \prime } , 3 ^ { \prime } } \end{bmatrix} \colon ( 1 ^ { \prime } , 2 , 3 ^ { \prime } ) \to ( 2 ^ { \prime } , 4 ^ { \prime } , 4 ^ { \prime } ) .
\]
```

## REPAIR_PROSE
- RAW: ```
Remark 5.8. Notice the domains and the codomains of the block matrices of the big matrix in Theorem 5.7 , which are as follows:
```
  FIX: ```
Remark 5.8. Notice the domains and the codomains of the block matrices of the big matrix in Theorem 5.7, which are as follows:
```
- RAW: ```
In particular, P ′ ( g 1 )( x ) and P ′ (sc 1 ( I ) ⊕ sc( ⇑ I ))( α ) have the common codomain P ′ (sc 1 ( I ) ⊕ sc( ⇑ I ))( x ) so that they are in the same row in the big matrices. When we write their concrete matrices, we have to have the same order of the direct summands of P ′ (sc 1 ( I ) ⊕ sc( ⇑ I ))( x ) . In that case, if u = ( u 1 ,...,u m ) ,v = ( v 1 ,...,v n ) with m,n ≥ 1 in k [ P ] , then we use the following order
```
  FIX: ```
In particular, \( P^{\prime}(g_1)(x) \) and \( P^{\prime}(sc_1(I) \oplus sc(\uparrow I))(\alpha) \) have the common codomain \( P^{\prime}(sc_1(I) \oplus sc(\uparrow I))(x) \) so that they are in the same row in the big matrices. When we write their concrete matrices, we have to have the same order of the direct summands of \( P^{\prime}(sc_1(I) \oplus sc(\uparrow I))(x) \). In that case, if \( u = (u_1, \dots, u_m), v = (v_1, \dots, v_n) \) with \( m,n \ge 1 \) in \( k[P] \), then we use the following order
```
- RAW: ```
The same remark is made for the second row of the big matrices (about the order of the summands of P ′ (sk( I ))( x ) ).
```
  FIX: ```
The same remark is made for the second row of the big matrices (about the order of the summands of \( P^{\prime}(sk(I))(x) \)).
```
- RAW: ```
Example 5.9. We compute the same multiplicity as in Example 5.2 by using Theorem 5.7 . Let P = G 4 , 2 and I ∈ I be as in Example 3.37 . Then dim V I : = [ 1 1 1 0 0 1 1 1 ] , and a 1 = 2 , a 2 = 1 ′ , a 12 = 2 ′ , b 1 = 4 , b 2 = 3 ′ , b 12 = 3 , a ′ 1 = 4 ′ , b ′ 1 = 1 . Therefore,
```
  FIX: ```
Example 5.9. We compute the same multiplicity as in Example 5.2 by using Theorem 5.7. Let \( P = G_{4,2} \) and \( I \in \mathcal{I} \) be as in Example 3.37. Then \( \dim V_I := [1 \ 1 \ 1 \ 0 \ 0 \ 1 \ 1 \ 1] \), and \( a_1 = 2, a_2 = 1^{\prime}, a_{12} = 2^{\prime}, b_1 = 4, b_2 = 3^{\prime}, b_{12} = 3, a^{\prime}_1 = 4^{\prime}, b^{\prime}_1 = 1 \). Therefore,
```
- RAW: ```
Moreover, a projective presentation of M is given by P ( y ) P ( α ) −−−→ P ( x ) → M → 0 , where the morphism α : x → y in A is given by
```
  FIX: ```
Moreover, a projective presentation of \( M \) is given by \( P(y) \xrightarrow{P(\alpha)} P(x) \to M \to 0 \), where the morphism \( \alpha : x \to y \) in \( \mathcal{A} \) is given by
```
