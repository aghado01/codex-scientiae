[Page 9]

Definition 8. Let \( P \) be a path complex associated with the \( N \)-chain complex \( ( \Omega _ n ^ N , \partial ) \). For any \( 1 \leq q \leq N - 1 \), define the following spaces:

- The space of \( q \)-th \( n \)-cycles:

$$
Z _ { n } ^ { N , q } = \{ x \in \Omega _ { n } ^ { N } \mid \partial ^ { q } ( x ) = 0 \} .
$$

- The space of \( q \)-th \( n \)-boundaries:


$$
B _ { n } ^ { N , q } = \{ \partial ^ { N - q } ( x ) \mid x \in \Omega _ { n + N - q } \} .
$$

Then, the Mayer Path Homology is defined as

$$
H _ { n } ^ { N , q } ( P ) \coloneqq Z _ { n } ^ { N , q } / B _ { n } ^ { N , q } = \ker ( \partial _ { n } ^ { q } ) / \operatorname{im} ( \partial _ { n + N - q } ^ { N - q } ) .
$$

The rank of \( H _ n ^ { N , q } ( P ) \) is called the Mayer path Betti number.

For \( q \geq n \), then \( \partial ^ q ( v ) = 0 \) or in \( A _ 0 \) for every \( v \in \Omega _ n ^ N \). Consequently, \( Z _ n ^ { N , q } = \Omega _ n ^ N \).

Example 3.2. Let \( P \) be the path complex described in Example 3.1 and in Figure 2.

For \( N = 2 \),

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

For \( N = 3 \) and \( q = 1 \),

$$
\begin{aligned}
& 0 \to \Omega _ { 2 } ^ { 3 } = \langle e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } \rangle \to \Omega _ { 1 } ^ { 3 } \to \Omega _ { 0 } ^ { 3 } \to 0 , \\
& Z _ { 0 } ^ { 3 , 1 } = \Omega _ { 0 } ^ { 3 } , \quad Z _ { 1 } ^ { 3 , 1 } = \langle - \xi e _ { 1 , 2 } + \xi e _ { 1 , 3 } + e _ { 2 , 4 } - e _ { 3 , 4 } \rangle , \quad Z _ { 2 } ^ { 3 , 1 } = 0 , \\
& B _ { 0 } ^ { 3 , 1 } = \langle - \xi e _ { 1 } - e _ { 2 } + \xi ^ { 2 } e _ { 3 } , - e _ { 2 } + e _ { 3 } , - e _ { 2 } - \xi e _ { 3 } - \xi e _ { 4 } \rangle , \quad B _ { k } ^ { 3 , 1 } = 0 \quad \forall k \geq 1 , \\
& H _ { 0 } ^ { 3 , 1 } = Z _ { 0 } ^ { 3 , 1 } / B _ { 0 } ^ { 3 , 1 } = \mathbb { C } , \quad H _ { 1 } ^ { 3 , 1 } = Z _ { 1 } ^ { 3 , 1 } = \mathbb { C } , \quad H _ { 2 } ^ { 3 , 1 } = Z _ { 2 } ^ { 3 , 1 } = 0 , \\
& H _ { n } ^ { 3 , 1 } ( P ) = \begin{cases} \mathbb { C } & n = 0 , 1 \\ 0 & n \geq 2 . \end{cases}
\end{aligned}
$$

For \( N = 3 \) and \( q = 2 \),

$$
\begin{aligned}
& Z _ { 0 } ^ { 3 , 2 } = \Omega _ { 0 } ^ { 3 } , \quad Z _ { 1 } ^ { 3 , 2 } = \Omega _ { 1 } ^ { 3 } , \quad Z _ { 2 } ^ { 3 , 2 } = 0 , \\
& B _ { 0 } ^ { 3 , 2 } = \langle e _ { 2 } + \xi e _ { 1 } , e _ { 3 } + \xi e _ { 1 } , e _ { 3 } + \xi e _ { 2 } , e _ { 4 } + \xi e _ { 2 } \rangle , \\
& B _ { 1 } ^ { 3 , 2 } = \langle \xi ^ { 2 } e _ { 1 , 2 } + \xi e _ { 1 , 3 } + e _ { 2 , 3 } , - e _ { 3 , 4 } + e _ { 2 , 4 } - \xi ^ { 2 } e _ { 1 , 3 } + \xi ^ { 2 } e _ { 1 , 2 } , e _ { 3 , 4 } + \xi e _ { 2 , 4 } + \xi ^ { 2 } e _ { 2 , 3 } \rangle , \\
& H _ { 0 } ^ { 3 , 2 } = Z _ { 0 } ^ { 3 , 2 } / B _ { 0 } ^ { 3 , 2 } = 0 , \quad H _ { 1 } ^ { 3 , 2 } = Z _ { 1 } ^ { 3 , 2 } / B _ { 1 } ^ { 3 , 2 } = \mathbb { C } , \quad H _ { 2 } ^ { 3 , 2 } = Z _ { 2 } ^ { 3 , 2 } = 0 , \\
& H _ { n } ^ { 3 , 2 } ( P ) = \begin{cases} \mathbb { C } & n = 1 \\ 0 & \text{otherwise} . \end{cases}
\end{aligned}
$$
