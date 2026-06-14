# Manifest: Page 060

## REPAIR_PROSE
- RAW: ```
Intuitively, for each j ∈ [ s ] , if x i ≤ z j in P , then the j th columns of P ′ ( g t )( x i ) and of g t coincide, otherwise the j th column of P ′ ( g t )( x i ) is zero. r
```
  FIX: ```
Intuitively, for each \( j \in [s] \), if \( x_i \leq z_j \) in \( P \), then the \( j \)-th columns of \( P'(g_t)(x_i) \) and of \( g_t \) coincide, otherwise the \( j \)-th column of \( P'(g_t)(x_i) \) is zero.
```
- RAW: ```
On the other hand, P ′ ( w i ) i ∈ [ r ] ( α ) = i =1 P ′ w i ( α ) is a diagonal block matrix, where for each i ∈ [ r ] , the i th block P ′ w i ( α ) has the following coefficient matrix:
```
  FIX: ```
On the other hand, \( P'_{(w_i)_{i \in [r]}}(\alpha) = \bigoplus_{i=1}^r P'_{w_i}(\alpha) \) is a diagonal block matrix, where for each \( i \in [r] \), the \( i \)-th block \( P'_{w_i}(\alpha) \) has the following coefficient matrix:
```
- RAW: ```
Proof Set Mat( g t ) : = [ b ij ] ( i,j ) ∈ [ r ] × [ s ] and Mat( α ) : = [ a ji ] ( j,i ) ∈ [ n ] × [ m ] , and let u ∈ P . Then since P ′ ( p w i ,z j )( u ) = A ( u, p w i ,z j ) , we have
```
  FIX: ```
*Proof.* Set \( \text{Mat}(g_t) := [b_{ij}]_{(i,j) \in [r] \times [s]} \) and \( \text{Mat}(\alpha) := [a_{ji}]_{(j,i) \in [n] \times [m]} \), and let \( u \in P \). Then since \( P'(p_{w_i, z_j})(u) = A(u, p_{w_i, z_j}) \), we have
```
- RAW: ```
∈ × where for any pair ( w i , z j ) with z j ≤ w i , the morphism A ( u, p w i ,z j ): A ( u, z j ) → A ( u, w i ) is nonzero if and only if A ( u, z j ) ̸ = 0 , if and only if u ≤ z j . Hence we have Mat( P ′ ( g t )( u )) = [ b ′ ij ] ( i,j ) ∈ [ r ] × [ s ] , where
```
  FIX: ```
where for any pair \( (w_i, z_j) \) with \( z_j \leq w_i \), the morphism \( A(u, p_{w_i, z_j}): A(u, z_j) \to A(u, w_i) \) is nonzero if and only if \( A(u, z_j) \neq 0 \), if and only if \( u \leq z_j \). Hence we have \( \text{Mat}(P'(g_t)(u)) = [b'_{ij}]_{(i,j) \in [r] \times [s]} \), where
```
- RAW: ```
Therefore, ( 5.76 ) follows by setting u : = x i . ′
```
  FIX: ```
Therefore, (5.76) follows by setting \( u := x_i \).
```
- RAW: ```
Similarly, since P u ( p y j ,x i ) = A ( p y j ,x i , u ) , we have
```
  FIX: ```
Similarly, since \( P'_u(p_{y_j, x_i}) = A(p_{y_j, x_i}, u) \), we have
```
- RAW: ```
∈ × where for any pair ( x i , y j ) with x i ≤ y j , the morphism A ( p y j ,x i , u ): A ( y j , u ) → A ( x i , u ) is nonzero if and only if A ( y j , u ) ̸ = 0 , if and only if y j ≤ u . Hence we have Mat( P ′ u ( α )) = t [ a ′′ ji ] ( j,i ) ∈ [ n ] × [ m ] , where
```
  FIX: ```
where for any pair \( (x_i, y_j) \) with \( x_i \leq y_j \), the morphism \( A(p_{y_j, x_i}, u): A(y_j, u) \to A(x_i, u) \) is nonzero if and only if \( A(y_j, u) \neq 0 \), if and only if \( y_j \leq u \). Hence we have \( \text{Mat}(P'_u(\alpha)) = {}^t[a''_{ji}]_{(j,i) \in [n] \times [m]} \), where
```
- RAW: ```
By setting u = w i , this shows ( 5.77 ).
```
  FIX: ```
By setting \( u = w_i \), this shows (5.77).
```
- RAW: ```
Example 5.12. We take a bifiltration example from Fugacci et al. ( 2023 ), as displayed in Fig. 3 , to demonstrate our formulas. Set M : = H 1 (-; Z / 2 Z ) ◦ F . Following the notation given in Theorem 5.1 , the presentation matrix P ( α ) is given by
```
  FIX: ```
Example 5.12. We take a bifiltration example from Fugacci et al. (2023), as displayed in Fig. 3, to demonstrate our formulas. Set \( M := H_1(-; \mathbb{Z}/2\mathbb{Z}) \circ F \). Following the notation given in Theorem 5.1, the presentation matrix \( P(\alpha) \) is given by
```
- RAW: ```
and thus x in ( 5.74 ) is given by a sequence of row indices of P ( α ) . Namely, x = (0 , 0) , (1 , 1) .
```
  FIX: ```
and thus \( x \) in (5.74) is given by a sequence of row indices of \( P(\alpha) \). Namely, \( x = ((0, 0), (1, 1)) \).
```
- RAW: ```
Now we consider an interval: I = [ { (0 , 2) , (1 , 1) } , { (1 , 2) , (2 , 1) } ] . Thus more visually, dim V I = 110 011 000 . Three block matrices g 1 , g 2 , g 3 of the multiplicity matrix for I are given by
```
  FIX: ```
Now we consider an interval: \( I = [\{(0, 2), (1, 1)\}, \{(1, 2), (2, 1)\}] \). Thus more visually, \( \dim V_I = \begin{smallmatrix} 1 & 1 & 0 \\ 0 & 1 & 1 \\ 0 & 0 & 0 \end{smallmatrix} \). Three block matrices \( g_1, g_2, g_3 \) of the multiplicity matrix for \( I \) are given by
```

## REPAIR_MATH
- RAW: ```
\left \lceil \delta _ { ( y _ { 1 } \leq w _ { i } ) } \cdot a ^ { ( 1 ) } \right \rceil \cdot \dots \left | \delta _ { ( y _ { n } \leq w _ { i } ) } \cdot a ^ { ( n ) } \right \rceil .
```
  FIX: ```
$$
\begin{bmatrix}
\delta_{(y_1 \le w_i)} a^{(1)} \\
\vdots \\
\delta_{(y_n \le w_i)} a^{(n)}
\end{bmatrix} .
$$
```
- RAW: ```
P ^ { \prime } ( g _ { t } ) ( u ) = [ b _ { i j } A ( u , p _ { w _ { i } , z _ { j } } ) ] _ { ( i , j ) \in [ r ] \times [ s ] } ,
```
  FIX: ```
$$
P'(g_t)(u) = [b_{ij} A(u, p_{w_i, z_j})]_{(i,j) \in [r] \times [s]},
$$
```
- RAW: ```
b _ { i j } ^ { \prime } = \delta _ { ( A ( u , p _ { w _ { i } , z _ { j } } ) \neq 0 ) } b _ { i j } = \delta _ { ( u \leq z _ { j } ) } b _ { i j } .
```
  FIX: ```
$$
b'_{ij} = \delta_{(A(u, p_{w_i, z_j}) \neq 0)} b_{ij} = \delta_{(u \le z_j)} b_{ij}.
$$
```
- RAW: ```
P _ { u } ^ { \prime } ( \alpha ) = ^ { t } [ a _ { j i } A ( p _ { y _ { j } , x _ { i } } , u ) ] _ { ( j , i ) \in [ n ] \times [ m ] } ,
```
  FIX: ```
$$
P'_u(\alpha) = {}^t[a_{ji} A(p_{y_j, x_i}, u)]_{(j,i) \in [n] \times [m]},
$$
```
- RAW: ```
a _ { j i } ^ { \prime \prime } = \delta _ { ( A ( p _ { y _ { j } . x _ { i } } , u ) \neq 0 ) } a _ { j i } = \delta _ { ( y _ { j } \leq u ) } a _ { j i } .
```
  FIX: ```
$$
a''_{ji} = \delta_{(A(p_{y_j, x_i}, u) \neq 0)} a_{ji} = \delta_{(y_j \le u)} a_{ji}.
$$
```
- RAW: ```
\begin{bmatrix} 0 , 0 \\ 1 , 1 \end{bmatrix} \begin{bmatrix} 1 , 2 ) & 2 , 1 \\ 1 & 0 \\ 1 & 1 \end{bmatrix} ,
```
  FIX: ```
$$
\begin{matrix}
& \begin{matrix} (1, 2) & (2, 1) \end{matrix} \\
\begin{matrix} (0, 0) \\ (1, 1) \end{matrix} & \begin{bmatrix} 1 & 0 \\ 1 & 1 \end{bmatrix}
\end{matrix},
$$
```
- RAW: ```
\begin{smallmatrix} ( 0 , 2 ) & ( 1 , 1 ) & ( 0 , 1 ) & ( 2 , 0 ) & ( 1 , 1 ) & ( 0 , 2 ) & ( 1 , 1 ) \\ ( 1 , 2 ) & 1 & - 1 \\ ( 2 , 2 ) & 1 & 0 & 1 & ( 2 , 1 ) & \left [ \begin{array} { c c c c } 0 & 0 & 1 \\ 1 & 1 & - 1 \end{array} \right ] , & ( 1 , 2 ) & \left [ \begin{array} { c c c c } 0 & 1 & 0 \\ 1 & 0 & 1 \\ 0 & - 1 \end{array} \right ] , & ( 2 , 1 ) & \left [ \begin{array} { c c c c } 1 & 0 \\ 1 & 0 \\ 0 & 0 \end{array} \right ] , & ( 5 . 7 9 )
```
  FIX: ```
$$
\begin{matrix}
& (0, 2) & (1, 1) \\
(1, 2) & 1 & -1 \\
(2, 2) & 1 & 0 
\end{matrix}, \quad
\begin{matrix}
& (0, 1) & (2, 0) & (1, 1) \\
(2, 1) & 0 & 0 & 1 \\
& 1 & 1 & -1
\end{matrix}, \quad
\begin{matrix}
& (0, 2) & (1, 1) \\
(1, 2) & 0 & 1 & 0 \\
& 1 & 0 & 1 \\
& 0 & -1 & \dots
\end{matrix}, \quad
\begin{matrix}
(2, 1) & 1 & 0 \\
& 1 & 0 \\
& 0 & 0 
\end{matrix}
\tag{5.79}
$$
```

