# Manifest: Page 034

## REPAIR_PROSE
- RAW: `where M ( ε 11 ) , M ( ε ↑ I 1 ) , M ( π 11 ) and M ( π ↓ I 1 ) are given by`
  FIX: `where \( M(\varepsilon_{11}) \), \( M(\varepsilon_{1}^{\uparrow I}) \), \( M(\pi_{11}) \) and \( M(\pi_{1}^{\downarrow I}) \) are given by`
- RAW: `Remark 3.36. We set M ( ε 1 ) = M ( ε 1 ) 1 ,M ( ε 1 ) 2 and M ( π 1 ) = M ( π 1 ) 1 M ( π 1 ) 2 , where M ( ε 1 ) 1 has dim M ( a 1 ) columns and M ( π 1 ) 1 has dim M ( b 1 ) rows. Then the matrix R ( M,I ) in the first term of ( 3.42 ) has the following form:`
  FIX: `Remark 3.3.6. We set \( M(\varepsilon_1) = [M(\varepsilon_1)_1, M(\varepsilon_1)_2] \) and \( M(\pi_1) = \begin{bmatrix} M(\pi_1)_1 \\ M(\pi_1)_2 \end{bmatrix} \), where \( M(\varepsilon_1)_1 \) has \( \dim M(a_1) \) columns and \( M(\pi_1)_1 \) has \( \dim M(b_1) \) rows. Then the matrix \( R(M,I) \) in the first term of (3.42) has the following form:`
- RAW: `We denote by E r the identity matrix of rank r . By elementary column transformations within the second block column and elementary row transformations within the first block row, we can transform M ( ε 1 ) 2 to the normal form E r 1 ⊕ 0 ; and by elementary column transformations within the third block column and elementary row transformations within the third block row, we can transform M ( π 1 ) 2 to the normal form E r 2 ⊕ 0 , where the obtained matrix R ( M,I ) 1 is equivalent to R ( M,I ) , and has the form:`
  FIX: `We denote by \( E_r \) the identity matrix of rank \( r \). By elementary column transformations within the second block column and elementary row transformations within the first block row, we can transform \( M(\varepsilon_1)_2 \) to the normal form \( E_{r_1} \oplus 0 \); and by elementary column transformations within the third block column and elementary row transformations within the third block row, we can transform \( M(\pi_1)_2 \) to the normal form \( E_{r_2} \oplus 0 \), where the obtained matrix \( R(M,I)_1 \) is equivalent to \( R(M,I) \), and has the form:`

## REPAIR_MATH
- RAW: ```
w h e r e \, M ( \varepsilon _ { 1 1 } ) , \, M ( \varepsilon _ { 1 } ^ { \uparrow I } ) , \, M ( \pi _ { 1 1 } ) \, a n d \, M ( \pi _ { 1 } ^ { \downarrow I } ) \, a r e \, g i v e n \, b y \\ M ( \varepsilon _ { 1 1 } ) = \left [ \delta _ { a , c ( a ^ { \prime } ) } M _ { a ^ { \prime } , c ( a ^ { \prime } ) } \right ] _ { ( a ^ { \prime } , a ) \in s c ( \uparrow I ) \times s c ( I ) } , \\ M ( \varepsilon _ { 1 2 } , a _ { 1 } \, - M _ { a _ { 1 2 } , a _ { 2 } } , \quad & \left [ \begin{matrix} M _ { a _ { 1 2 } , a _ { 1 } } & - M _ { a _ { 1 2 } , a _ { 2 } } \\ M _ { a _ { 2 3 } , a _ { 2 } } & - M _ { a _ { 2 , 3 } , a _ { 3 } } \end{matrix} \right ] , \\ M ( \varepsilon _ { 1 } ^ { \uparrow I } ) = \left [ \begin{matrix} M _ { a _ { 1 1 } , a _ { 1 } , a _ { k - 1 } } & \ddots & \ddots & \ddots \\ & M _ { a _ { k - 1 , k } , a _ { k - 1 } } & - M _ { a _ { k - 1 , k } , a _ { k } } \end{matrix} \right ] \\ M ( \pi _ { 1 1 } ) = \left [ \delta _ { b , d ( b ^ { \prime } ) } M _ { d ( b ^ { \prime } ) , b ^ { \prime } } \right ] _ { ( b , b ^ { \prime } ) \in s k ( I ) \times s k ( \uparrow I ) } , \text { and } \\ \left [ \begin{matrix} M _ { b _ { 1 } , b _ { 1 2 } } & M _ { b _ { 2 } , b _ { 2 3 } } & & \\ - M _ { b _ { 2 } , b _ { 1 2 } } & M _ { b _ { 2 } , b _ { 2 3 } } & & \\ & & - M _ { b _ { 3 } , b _ { 2 3 } } & \ddots & \\ & & & \ddots & M _ { b _ { t - 1 , b _ { 1 } - 1 , t } } \\ & & & - M _ { b _ { t } , b _ { 1 - 1 , t } } \end{matrix} \right ] \\ \text {Remark } 3 . 3 . 6 . \text { We set } M ( \varepsilon _ { 1 } ) = \left [ M ( \varepsilon _ { 1 } ) _ { 1 } , M ( \varepsilon _ { 1 } ) _ { 2 } \right ] \text { and } M ( \pi _ { 1 } ) = \left [ M ( \pi _ { 1 } ) _ { 1 } \right ] , \text { where }
```
  FIX: ```
$$
\begin{align*}
M(\varepsilon_{11}) &= \left[ \delta_{a,c(a')} M_{a',c(a')} \right]_{(a',a) \in sc(\uparrow I) \times sc(I)}, \\
M(\varepsilon_1^{\uparrow I}) &= \left[ \begin{matrix} M_{a_{12},a_1} & -M_{a_{12},a_2} \\ & M_{a_{23},a_2} & -M_{a_{23},a_3} \\ & & \ddots & \ddots \\ & & & M_{a_{k-1,k},a_{k-1}} & -M_{a_{k-1,k},a_k} \end{matrix} \right], \\
M(\pi_{11}) &= \left[ \delta_{b,d(b')} M_{d(b'),b'} \right]_{(b,b') \in sk(I) \times sk(\uparrow I)}, \text{ and } \\
M(\pi_1^{\downarrow I}) &= \left[ \begin{matrix} M_{b_1,b_{12}} \\ -M_{b_2,b_{12}} & M_{b_2,b_{23}} \\ & -M_{b_3,b_{23}} & \ddots \\ & & \ddots & M_{b_{t-1},b_{t-1,t}} \\ & & & -M_{b_t,b_{t-1,t}} \end{matrix} \right].
\end{align*}
$$
```
- RAW: ```
R ( M , I ) = \begin{bmatrix} M ( \varepsilon _ { 1 } ) _ { 1 } & M ( \varepsilon _ { 1 } ) _ { 2 } & 0 \\ M _ { b _ { 1 } , a _ { 1 } } & 0 & M ( \pi _ { 1 } ) _ { 1 } \\ 0 & 0 & M ( \pi _ { 1 } ) _ { 2 } \end{bmatrix} .
```
  FIX: ```
$$
R(M,I) = \begin{bmatrix} M(\varepsilon_1)_1 & M(\varepsilon_1)_2 & 0 \\ M_{b_1,a_1} & 0 & M(\pi_1)_1 \\ 0 & 0 & M(\pi_1)_2 \end{bmatrix}.
$$
```
- RAW: ```
R ( M , I ) _ { 1 } = \begin{bmatrix} M _ { 1 } ^ { \prime } | E _ { r _ { 1 } } & 0 & 0 & 0 \\ M _ { 1 } | & 0 & 0 & 0 \\ \frac { M _ { 1 } } { M _ { 2 } } | & 0 & 0 & M _ { 3 } ^ { \prime } \ M _ { 3 } \\ 0 & 0 & 0 & E _ { r _ { 2 } } & 0 \\ 0 & 0 & 0 & 0 & 0 \end{bmatrix} \sim \begin{bmatrix} 0 & | E _ { r _ { 1 } } & 0 & 0 & 0 \\ M _ { 1 } & 0 & 0 & 0 & 0 \\ \frac { M _ { 1 } } { M _ { 2 } } & 0 & 0 & 0 & M _ { 3 } \\ 0 & 0 & 0 & 0 & M _ { 3 } \\ 0 & 0 & 0 & 0 & 0 \end{bmatrix} .
```
  FIX: ```
$$
R(M,I)_1 = \left[ \begin{array}{c|cccc} M'_1 & E_{r_1} & 0 & 0 & 0 \\ M_1 & 0 & 0 & 0 & 0 \\ \hline M_2 & 0 & 0 & M'_3 & 0 \\ 0 & 0 & 0 & E_{r_2} & 0 \\ 0 & 0 & 0 & 0 & 0 \end{array} \right] \sim \left[ \begin{array}{c|cccc} 0 & E_{r_1} & 0 & 0 & 0 \\ M_1 & 0 & 0 & 0 & 0 \\ \hline M_2 & 0 & 0 & 0 & M'_3 \\ 0 & 0 & 0 & 0 & M_3 \\ 0 & 0 & 0 & 0 & 0 \end{array} \right].
$$
```

