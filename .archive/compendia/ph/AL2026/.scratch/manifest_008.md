# Manifest: Page 008

## REPAIR_MATH
- RAW: ```
\ s c _ { 1 } ^ { \circ } ( I ) = \{ a _ { i , i + 1 } \colon = a _ { i } \vee a _ { i + 1 } \ | \ i \in [ k - 1 ] \} , \ s k _ { 1 } ^ { \circ } ( I ) = \{ b _ { i , i + 1 } \colon = b _ { i } \wedge b _ { i + 1 } \ | \ i \in [ l - 1 ] \} .
```
  FIX: ```
$$
\ s c _ { 1 } ^ { \circ } ( I ) = \{ a _ { i , i + 1 } \colon = a _ { i } \vee a _ { i + 1 } \ | \ i \in [ k - 1 ] \} , \ s k _ { 1 } ^ { \circ } ( I ) = \{ b _ { i , i + 1 } \colon = b _ { i } \wedge b _ { i + 1 } \ | \ i \in [ l - 1 ] \} .
$$
```
- RAW: ```
d _ { M } ( V _ { I } ) = \text {rank} \quad \stackrel { \text {sc} _ { I } ( I ) } { \text {sk} ( I ) } \stackrel { \text {sk} ( I ) } { \text {g} } \stackrel { \text {sk} ( I ) } { \text {s} _ { 1 } } ( I ) \\ d _ { M } ( V _ { I } ) = \text {rank} \quad \stackrel { \text {sc} _ { I } ^ { \circ } ( I ) } { \text {sk} ( I ) } \left [ \begin{smallmatrix} M _ { 1 } & 0 & 0 \\ M _ { 2 } & 0 & 0 \\ M _ { 3 } & M _ { 4 } & M _ { 5 } \end{smallmatrix} \right ] - \text {rank} \left [ \begin{smallmatrix} M _ { 1 } & 0 & 0 \\ M _ { 2 } & 0 & 0 \\ M _ { 3 } & M _ { 4 } & M _ { 5 } \end{smallmatrix} \right ] \\
```
  FIX: ```
$$
d _ { M } ( V _ { I } ) = \text {rank} \quad \stackrel { \text {sc} _ { I } ( I ) } { \text {sk} ( I ) } \stackrel { \text {sk} ( I ) } { \text {g} } \stackrel { \text {sk} ( I ) } { \text {s} _ { 1 } } ( I ) \\ d _ { M } ( V _ { I } ) = \text {rank} \quad \stackrel { \text {sc} _ { I } ^ { \circ } ( I ) } { \text {sk} ( I ) } \left [ \begin{smallmatrix} M _ { 1 } & 0 & 0 \\ M _ { 2 } & 0 & 0 \\ M _ { 3 } & M _ { 4 } & M _ { 5 } \end{smallmatrix} \right ] - \text {rank} \left [ \begin{smallmatrix} M _ { 1 } & 0 & 0 \\ M _ { 2 } & 0 & 0 \\ M _ { 3 } & M _ { 4 } & M _ { 5 } \end{smallmatrix} \right ] \\
$$
```
- RAW: ```
M _ { 1 } \coloneqq \begin{bmatrix} M _ { a _ { 1 } , a _ { 1 } } & - M _ { a _ { 1 } , a _ { 2 } } & & & \\ & M _ { a _ { 2 } , a _ { 2 } } & - M _ { a _ { 2 , 3 } , a _ { 3 } } & & \\ & & \ddots & & \ddots \\ & & & M _ { a _ { k - 1 , k } , a _ { k - 1 } } & - M _ { a _ { k - 1 , k } , a _ { k } } \end{bmatrix}
```
  FIX: ```
$$
M _ { 1 } \coloneqq \begin{bmatrix} M _ { a _ { 1 } , a _ { 1 } } & - M _ { a _ { 1 } , a _ { 2 } } & & & \\ & M _ { a _ { 2 } , a _ { 2 } } & - M _ { a _ { 2 , 3 } , a _ { 3 } } & & \\ & & \ddots & & \ddots \\ & & & M _ { a _ { k - 1 , k } , a _ { k - 1 } } & - M _ { a _ { k - 1 , k } , a _ { k } } \end{bmatrix}
$$
```
- RAW: ```
M _ { 5 } \coloneqq \begin{bmatrix} M _ { b _ { 1 } , b _ { 1 2 } } & & & \\ - M _ { b _ { 2 } , b _ { 1 2 } } & M _ { b _ { 2 } , b _ { 2 3 } } & & \\ & & - M _ { b _ { 3 } , b _ { 2 3 } } & \ddots & \\ & & & \ddots & M _ { b _ { l - 1 } , b _ { l - 1 , l } } \\ & & & & - M _ { b _ { l } , b _ { l - 1 , l } } \end{bmatrix} .
```
  FIX: ```
$$
M _ { 5 } \coloneqq \begin{bmatrix} M _ { b _ { 1 } , b _ { 1 2 } } & & & \\ - M _ { b _ { 2 } , b _ { 1 2 } } & M _ { b _ { 2 } , b _ { 2 3 } } & & \\ & & - M _ { b _ { 3 } , b _ { 2 3 } } & \ddots & \\ & & & \ddots & M _ { b _ { l - 1 } , b _ { l - 1 , l } } \\ & & & & - M _ { b _ { l } , b _ { l - 1 , l } } \end{bmatrix} .
$$
```
- RAW: ```
M _ { 2 } \coloneqq \left [ \delta _ { a , \, c ( a ^ { \prime } ) } M _ { a ^ { \prime } , \, c ( a ^ { \prime } ) } \right ] _ { ( a ^ { \prime } , a ) \in s c ( \uparrow I ) \times s c ( I ) } , \, M _ { 4 } \coloneqq \left [ \delta _ { b , \, d ( b ^ { \prime } ) } M _ { d ( b ^ { \prime } ) , \, b ^ { \prime } } \right ] _ { ( b , b ^ { \prime } ) \in s k ( I ) \times s k ( \downarrow I ) } ,
```
  FIX: ```
$$
M _ { 2 } \coloneqq \left [ \delta _ { a , \, c ( a ^ { \prime } ) } M _ { a ^ { \prime } , \, c ( a ^ { \prime } ) } \right ] _ { ( a ^ { \prime } , a ) \in s c ( \uparrow I ) \times s c ( I ) } , \, M _ { 4 } \coloneqq \left [ \delta _ { b , \, d ( b ^ { \prime } ) } M _ { d ( b ^ { \prime } ) , \, b ^ { \prime } } \right ] _ { ( b , b ^ { \prime } ) \in s k ( I ) \times s k ( \downarrow I ) } ,
$$
```

## REPAIR_PROSE
- RAW: ```
We note that sc ◦ 1 ( I ) ⊆ sc 1 ( I ) and sk ◦ 1 ( I ) ⊆ sk 1 ( I ) . Then we have the following.
```
  FIX: ```
We note that \( sc _ { 1 } ^ { \circ } ( I ) \subseteq sc _ { 1 } ( I ) \) and \( sk _ { 1 } ^ { \circ } ( I ) \subseteq sk _ { 1 } ( I ) \). Then we have the following.
```
- RAW: ```
Main result B (Theorem 3.35 ). Let M ∈ mod k [ P ] , and I an interval of P . Then
```
  FIX: ```
Main result B (Theorem 3.35). Let \( M \in \text{mod} \, k [ P ] \), and \( I \) an interval of \( P \). Then
```
- RAW: ```
holds. Here M 1 and M 5 are given by
```
  FIX: ```
holds. Here \( M _ { 1 } \) and \( M _ { 5 } \) are given by
```
- RAW: ```
M 2 , M 4 are given by
```
  FIX: ```
\( M _ { 2 } , M _ { 4 } \) are given by
```
- RAW: ```
respectively. M 3 is given by a choice of pair ( b j ,a i ) ∈ sk( I ) × sc( I ) with b j ≥ a i . Namely, the ( b j ,a i ) -entry is the only non-zero entry of M 3 and it equals to M b j ,a i . Index sets of matrices in formula ( 1.3 ) are allowed to be empty. In this case, we remove rows (columns) of matrices corresponding to empty index sets.
```
  FIX: ```
respectively. \( M _ { 3 } \) is given by a choice of pair \( ( b _ { j } , a _ { i } ) \in sk( I ) \times sc( I ) \) with \( b _ { j } \geq a _ { i } \). Namely, the \( ( b _ { j } , a _ { i } ) \)-entry is the only non-zero entry of \( M _ { 3 } \) and it equals to \( M _ { b _ { j } , a _ { i } } \). Index sets of matrices in formula (1.3) are allowed to be empty. In this case, we remove rows (columns) of matrices corresponding to empty index sets.
```
- RAW: ```
(3) As we saw above, one can compute interval multiplicities from the persistent homology (persistence module) thus obtained. However, computing persistent homology directly from an arbitrary filtration of topological spaces is generally inefficient. To address this, we introduce the essential-cover technique, which computes the invariants by focusing on the essential structure of poset P and building a new
```
  FIX: ```
(3) As we saw above, one can compute interval multiplicities from the persistent homology (persistence module) thus obtained. However, computing persistent homology directly from an arbitrary filtration of topological spaces is generally inefficient. To address this, we introduce the essential-cover technique, which computes the invariants by focusing on the essential structure of poset \( P \) and building a new
```



- RAW: ```
[Page 8]
```
  FIX: ```
```
- RAW: ```
(2) Because the 2D-grid poset setting is well motivated and has more interest for TDA researchers, especially in the multi-parameter persistent homology, we also give the explicit formula in this poset setting (Theorem 3.35 ). In this case, we set
```
  FIX: ```
(2) Because the 2D-grid poset setting is well motivated and has more interest for TDA researchers, especially in the multi-parameter persistent homology, we also give the explicit formula in this poset setting (Theorem 3.35). In this case, we set
```
- RAW: ```
We provide Example 3.37 of computing the interval multiplicity in the 2D-grid case by utilizing the formula ( 1.3 ).
```
  FIX: ```
We provide Example 3.37 of computing the interval multiplicity in the 2D-grid case by utilizing the formula (1.3).
```

