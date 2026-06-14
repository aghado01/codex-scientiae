# Manifest: Page 009

## REPLACE_TABLES
None

## REPAIR_PROSE
- RAW: ```
Definition 8. Let P be a path complex associated with the N -chain complex (Ω N n ,∂ ) . For any 1 ≤ q ≤ N − 1 , define the following spaces:
```
  FIX: ```
Definition 8. Let \( P \) be a path complex associated with the \( N \)-chain complex \( ( \Omega _ n ^ N , \partial ) \). For any \( 1 \leq q \leq N - 1 \), define the following spaces:
```
- RAW: ```
- The space of q -th n -cycles:
```
  FIX: ```
- The space of \( q \)-th \( n \)-cycles:
```
- RAW: ```
- The space of q -th n -boundaries:
```
  FIX: ```
- The space of \( q \)-th \( n \)-boundaries:
```
- RAW: ```
The rank of H N,q n ( P ) is called the Mayer path Betti number.

For q ≥ n , then ∂ q ( v ) = 0 or in A 0 for every v ∈ Ω N n . Consequently, Z N,q n = Ω N n
```
  FIX: ```
The rank of \( H _ n ^ { N , q } ( P ) \) is called the Mayer path Betti number.

For \( q \geq n \), then \( \partial ^ q ( v ) = 0 \) or in \( A _ 0 \) for every \( v \in \Omega _ n ^ N \). Consequently, \( Z _ n ^ { N , q } = \Omega _ n ^ N \).
```
- RAW: ```
Example 3.2. Let P be the path complex described in Example 3.1 and in Figure 2

For N = 2 ,
```
  FIX: ```
Example 3.2. Let \( P \) be the path complex described in Example 3.1 and in Figure 2.

For \( N = 2 \),
```
- RAW: ```
For N = 3 and q = 1 ,
```
  FIX: ```
For \( N = 3 \) and \( q = 1 \),
```
- RAW: ```
For N = 3 and q = 2 ,
```
  FIX: ```
For \( N = 3 \) and \( q = 2 \),
```

## REPAIR_MATH
- RAW: ```
Z _ { n } ^ { N , q } = \{ x \in \Omega _ { n } ^ { N } \, | \, \partial ^ { q } ( x ) = 0 \} .
```
  FIX: ```
$$
Z _ { n } ^ { N , q } = \{ x \in \Omega _ { n } ^ { N } \mid \partial ^ { q } ( x ) = 0 \} .
$$
```
- RAW: ```
B _ { n } ^ { N , q } = \{ \partial ^ { N - q } ( x ) \, | \, x \in \Omega _ { n + N - q } \} .
```
  FIX: ```
$$
B _ { n } ^ { N , q } = \{ \partial ^ { N - q } ( x ) \mid x \in \Omega _ { n + N - q } \} .
$$
```
- RAW: ```
H _ { n } ^ { N , q } ( P ) \coloneqq Z _ { n } ^ { N , q } / B _ { n } ^ { N , q } = \ker ( \partial _ { n } ^ { q } ) / \text {im} ( \partial _ { n + N - q } ^ { N - q } ) .
```
  FIX: ```
$$
H _ { n } ^ { N , q } ( P ) \coloneqq Z _ { n } ^ { N , q } / B _ { n } ^ { N , q } = \ker ( \partial _ { n } ^ { q } ) / \operatorname{im} ( \partial _ { n + N - q } ^ { N - q } ) .
$$
```
- RAW: ```
\begin{array} { c } \text {Example 3.2.} \quad \text {Let P be the path complex described in Extrema 3.1 and im Figure 2} \\ & \text {For N = 2} , & & 0 \to \Omega _ { 3 } ^ { 2 } \to \Omega _ { 2 } ^ { 2 } \to \Omega _ { 1 } ^ { 2 } \to \Omega _ { 0 } ^ { 2 } \to 0 \\ & & 0 \to \Omega _ { 3 } ^ { 2 } \to \Omega _ { 2 } ^ { 2 } \to \Omega _ { 1 } ^ { 2 } \to \Omega _ { 0 } ^ { 2 } \to 0 \\ Z _ { 0 } ^ { 2 } = \Omega _ { 0 } ^ { 2 } , \ Z _ { 1 } ^ { 2 } = < - e _ { 1 , 2 } + e _ { 1 , 3 } - e _ { 2 , 3 } , - e _ { 2 , 3 } + e _ { 2 , 4 } - e _ { 3 , 4 } > , \ Z _ { 2 } ^ { 2 } = < e _ { 1 , 2 , 3 } + e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } + e _ { 2 , 3 , 4 } > , \ Z _ { 3 } ^ { 2 } = 0 , \\ & B _ { 0 } ^ { 2 } = < e _ { 2 } - e _ { 1 } , e _ { 3 } - e _ { 1 , 4 } - e _ { 2 } > , \ B _ { 1 } ^ { 2 } = < e _ { 1 , 2 } - e _ { 1 , 3 } + e _ { 2 , 3 } , e _ { 3 } - e _ { 2 , 4 } + e _ { 2 , 3 } > , \\ & B _ { 2 } ^ { 2 } = < e _ { 1 , 2 , 3 } - e _ { 1 , 2 , 4 } + e _ { 1 , 3 , 4 } + e _ { 2 , 3 , 4 } > , \\ & H _ { 0 } ^ { 2 } = \Omega _ { 0 } ^ { 2 } / B _ { 0 } ^ { 2 } = \mathbb { C } , \ H _ { 1 } ^ { 2 } = Z _ { 1 } ^ { 2 } / B _ { 1 } ^ { 2 } = 0 , \ H _ { 2 } ^ { 2 } = Z _ { 2 } ^ { 2 } / B _ { 2 } ^ { 2 } = 0 , \ H _ { 3 } ^ { 2 } = Z _ { 3 } ^ { 2 } / B _ { 3 } ^ { 2 } = 0 , \\ & H _ { n } ^ { 2 , 1 } ( P ) = \left \{ \mathbb { C } \ \ n = 0 \\ 0 \ \ n \geq 1 . \\ \text {For N = 3 and q = 1} , \end{array}
```
  FIX: ```
$$
\begin{aligned}
& 0 \to \Omega _ { 3 } ^ { 2 } \to \Omega _ { 2 } ^ { 2 } \to \Omega _ { 1 } ^ { 2 } \to \Omega _ { 0 } ^ { 2 } \to 0 \\
& Z _ { 0 } ^ { 2 } = \Omega _ { 0 } ^ { 2 } , \quad Z _ { 1 } ^ { 2 } = \langle - e _ { 1 , 2 } + e _ { 1 , 3 } - e _ { 2 , 3 } , - e _ { 2 , 3 } + e _ { 2 , 4 } - e _ { 3 , 4 } \rangle , \quad Z _ { 2 } ^ { 2 } = \langle e _ { 1 , 2 , 3 } + e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } + e _ { 2 , 3 , 4 } \rangle , \quad Z _ { 3 } ^ { 2 } = 0 , \\
& B _ { 0 } ^ { 2 } = \langle e _ { 2 } - e _ { 1 } , e _ { 3 } - e _ { 1 , 4 } - e _ { 2 } \rangle , \quad B _ { 1 } ^ { 2 } = \langle e _ { 1 , 2 } - e _ { 1 , 3 } + e _ { 2 , 3 } , e _ { 3 } - e _ { 2 , 4 } + e _ { 2 , 3 } \rangle , \\
& B _ { 2 } ^ { 2 } = \langle e _ { 1 , 2 , 3 } - e _ { 1 , 2 , 4 } + e _ { 1 , 3 , 4 } + e _ { 2 , 3 , 4 } \rangle , \\
& H _ { 0 } ^ { 2 } = \Omega _ { 0 } ^ { 2 } / B _ { 0 } ^ { 2 } = \mathbb { C } , \quad H _ { 1 } ^ { 2 } = Z _ { 1 } ^ { 2 } / B _ { 1 } ^ { 2 } = 0 , \quad H _ { 2 } ^ { 2 } = Z _ { 2 } ^ { 2 } / B _ { 2 } ^ { 2 } = 0 , \quad H _ { 3 } ^ { 2 } = Z _ { 3 } ^ { 2 } / B _ { 3 } ^ { 2 } = 0 , \\
& H _ { n } ^ { 2 , 1 } ( P ) = \begin{cases} \mathbb { C } & n = 0 \\ 0 & n \geq 1 . \end{cases}
\end{aligned}
$$
```
- RAW: ```
F o r \ N = 3 \ a n d \ q = 1 , \\ 0 \to \Omega _ { 2 } ^ { 3 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > \to \Omega _ { 1 } ^ { 3 } \to \Omega _ { 0 } ^ { 3 } \to 0 , \\ Z _ { 0 } ^ { 3 , 1 } = \Omega _ { 0 } ^ { 3 } \ Z _ { 1 } ^ { 3 , 1 } = < - \xi e _ { 1 , 2 } + \xi e _ { 1 , 3 } + e _ { 2 , 4 } - e _ { 3 , 4 } > , \ \ Z _ { 2 } ^ { 3 , 1 } = 0 , \\ B _ { 0 } ^ { 3 , 1 } = < - \xi e _ { 1 } - e _ { 2 } + \xi ^ { 2 } e _ { 3 } , - e _ { 2 } + e _ { 3 } , - e _ { 2 } - \xi e _ { 3 } - \xi e _ { 4 } > , \ \ B _ { k } ^ { 3 , 1 } = 0 \ \forall k \geq 1 \\ H _ { 0 } ^ { 3 , 1 } = Z _ { 0 } ^ { 3 , 1 } / B _ { 0 } ^ { 3 , 1 } = \mathbb { C } , \ \ H _ { 1 } ^ { 3 , 1 } = Z _ { 1 } ^ { 3 , 1 } = \mathbb { C } , \ \ H _ { 2 } ^ { 2 } = Z _ { 2 } ^ { 3 , 1 } = 0 , \\ H _ { n } ^ { 3 , 1 } ( P ) = \begin{cases} \mathbb { C } & n = 0 , 1 \\ 0 & n \geq 2 . \end{cases} \\ \text {For } N = 3 \ a n d \ q = 2 ,
```
  FIX: ```
$$
\begin{aligned}
& 0 \to \Omega _ { 2 } ^ { 3 } = \langle e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } \rangle \to \Omega _ { 1 } ^ { 3 } \to \Omega _ { 0 } ^ { 3 } \to 0 , \\
& Z _ { 0 } ^ { 3 , 1 } = \Omega _ { 0 } ^ { 3 } , \quad Z _ { 1 } ^ { 3 , 1 } = \langle - \xi e _ { 1 , 2 } + \xi e _ { 1 , 3 } + e _ { 2 , 4 } - e _ { 3 , 4 } \rangle , \quad Z _ { 2 } ^ { 3 , 1 } = 0 , \\
& B _ { 0 } ^ { 3 , 1 } = \langle - \xi e _ { 1 } - e _ { 2 } + \xi ^ { 2 } e _ { 3 } , - e _ { 2 } + e _ { 3 } , - e _ { 2 } - \xi e _ { 3 } - \xi e _ { 4 } \rangle , \quad B _ { k } ^ { 3 , 1 } = 0 \quad \forall k \geq 1 , \\
& H _ { 0 } ^ { 3 , 1 } = Z _ { 0 } ^ { 3 , 1 } / B _ { 0 } ^ { 3 , 1 } = \mathbb { C } , \quad H _ { 1 } ^ { 3 , 1 } = Z _ { 1 } ^ { 3 , 1 } = \mathbb { C } , \quad H _ { 2 } ^ { 3 , 1 } = Z _ { 2 } ^ { 3 , 1 } = 0 , \\
& H _ { n } ^ { 3 , 1 } ( P ) = \begin{cases} \mathbb { C } & n = 0 , 1 \\ 0 & n \geq 2 . \end{cases}
\end{aligned}
$$
```
- RAW: ```
P ( 0 ) = & \sin \alpha q - 2 , \\ Z _ { 0 } ^ { 3 , 2 } = & \Omega _ { 0 } ^ { 3 } , \ \ Z _ { 1 } ^ { 3 , 2 } = \Omega _ { 1 } ^ { 3 } , \ \ Z _ { 2 } ^ { 3 , 2 } = 0 , \\ B _ { 0 } ^ { 3 , 2 } = & < e _ { 2 } + \xi e _ { 1 } , e _ { 3 } + \xi e _ { 1 } , e _ { 3 } + \xi e _ { 2 } , e _ { 4 } + \xi e _ { 2 } > , \\ B _ { 1 } ^ { 3 , 2 } = & < \xi ^ { 2 } e _ { 1 , 2 } + \xi e _ { 1 , 3 } + e _ { 2 , 3 } , - e _ { 3 , 4 } + e _ { 2 , 4 } - \xi ^ { 2 } e _ { 1 , 3 } + \xi ^ { 2 } e _ { 1 , 2 } , e _ { 3 , 4 } + \xi e _ { 2 , 4 } + \xi ^ { 2 } e _ { 2 , 3 } > , \\ H _ { 0 } ^ { 3 , 2 } = & Z _ { 0 } ^ { 3 , 2 } / B _ { 0 } ^ { 3 , 2 } = 0 , \ \ H _ { 1 } ^ { 3 , 2 } = Z _ { 1 } ^ { 3 , 2 } / B _ { 1 } ^ { 3 , 2 } = \mathbb { C } , \ \ H _ { 2 } ^ { 2 } = Z _ { 2 } ^ { 3 , 2 } = 0 , \\ H _ { n } ^ { 3 , 2 } ( P ) = & \begin{cases} \mathbb { C } & n = 1 \\ 0 & o t h e r w i s e . \end{cases}
```
  FIX: ```
$$
\begin{aligned}
& Z _ { 0 } ^ { 3 , 2 } = \Omega _ { 0 } ^ { 3 } , \quad Z _ { 1 } ^ { 3 , 2 } = \Omega _ { 1 } ^ { 3 } , \quad Z _ { 2 } ^ { 3 , 2 } = 0 , \\
& B _ { 0 } ^ { 3 , 2 } = \langle e _ { 2 } + \xi e _ { 1 } , e _ { 3 } + \xi e _ { 1 } , e _ { 3 } + \xi e _ { 2 } , e _ { 4 } + \xi e _ { 2 } \rangle , \\
& B _ { 1 } ^ { 3 , 2 } = \langle \xi ^ { 2 } e _ { 1 , 2 } + \xi e _ { 1 , 3 } + e _ { 2 , 3 } , - e _ { 3 , 4 } + e _ { 2 , 4 } - \xi ^ { 2 } e _ { 1 , 3 } + \xi ^ { 2 } e _ { 1 , 2 } , e _ { 3 , 4 } + \xi e _ { 2 , 4 } + \xi ^ { 2 } e _ { 2 , 3 } \rangle , \\
& H _ { 0 } ^ { 3 , 2 } = Z _ { 0 } ^ { 3 , 2 } / B _ { 0 } ^ { 3 , 2 } = 0 , \quad H _ { 1 } ^ { 3 , 2 } = Z _ { 1 } ^ { 3 , 2 } / B _ { 1 } ^ { 3 , 2 } = \mathbb { C } , \quad H _ { 2 } ^ { 3 , 2 } = Z _ { 2 } ^ { 3 , 2 } = 0 , \\
& H _ { n } ^ { 3 , 2 } ( P ) = \begin{cases} \mathbb { C } & n = 1 \\ 0 & \text{otherwise} . \end{cases}
\end{aligned}
$$
```
