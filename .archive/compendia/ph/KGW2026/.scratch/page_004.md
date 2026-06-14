[Page 4]

2. For an \( N \)-chain complex \( (C_*, d) \) and \( 1 \leq q \leq N - 1 \), the space of \( q \)-th \( n \)-cycles defined as

$$
\[
\[
Z _ { n } ^ { N , q } = \{ x \in C _ { n } \ | \ d ^ { q } x = 0 \}
\]
\]
$$

and the space of the \( q \)-th \( n \)-boundaries is defined as

$$
\[
\[
B _ { n } ^ { N , q } = \{ d ^ { N - q } x \ | \ x \in C _ { n + N - q } \}
\]
\]
$$

$$
\[
\[
\cdots \quad \stackrel { d } { \rightarrow } \quad C _ { n + N - 1 } \stackrel { d ^ { N - 1 } } { \longrightarrow } \ C _ { n } \stackrel { d } { \rightarrow } \quad C _ { n } \stackrel { d } { \rightarrow } \quad C _ { n - 1 } \stackrel { d ^ { N - 1 } } { \longrightarrow } \ \cdots \quad & \\ \vdots & & \vdots & & \vdots & & \vdots \\ \cdots \quad \stackrel { d ^ { n } } { \rightarrow } \quad C _ { n + N - q } \stackrel { d ^ { N - q } } { \longrightarrow } \ C _ { n } \stackrel { d ^ { n } } { \rightarrow } \quad C _ { n } \stackrel { d ^ { q } } { \rightarrow } \quad C _ { n - q } \stackrel { d ^ { n - q } } { \longrightarrow } \ \cdots \quad \\ & \vdots & & \vdots & & \vdots & \\ \cdots \quad \stackrel { d ^ { N - 2 } } { \longrightarrow } \quad C _ { n + 2 } \stackrel { d ^ { 2 } } { \rightarrow } \quad C _ { n } \stackrel { d ^ { N - 2 } } { \longrightarrow } \ C _ { n - N + 2 } \stackrel { d ^ { 2 } } { \rightarrow } \quad \cdots \\ \cdots \quad \stackrel { d ^ { N - 1 } } { \longrightarrow } \quad C _ { n + 1 } \stackrel { d } { \rightarrow } \quad C _ { n } \stackrel { d ^ { N - 1 } } { \longrightarrow } \ C _ { n - N + 1 } \stackrel { d } { \rightarrow } \ \cdots \\ \cdots \quad \cdots
\]
\]
$$

The Mayer homology of the \( N \)-chain complex \( (C_*, d) \) is defined as

$$
\[
\[
H _ { n } ^ { N , q } ( C _ { * } , d ) \colon = Z _ { n } ^ { N , q } / B _ { n } ^ { N , q } , \ n \geq 0
\]
\]
$$

The Mayer Betti Numbers are the dimension of the Mayer homology groups at corresponding dimensions \( N, q \).

$$
\[
\[
\beta _ { n } ^ { N , q } = \dim ( H _ { n } ^ { N , q } ( C _ { * } , d ) )
\]
\]
$$

The following example will demonstrate that the Mayer homology groups depend on the chosen triangulation of the topological space. In particular, different triangulation may yield non-isomorphic Mayer homology groups. Consequently, it does not define a topological invariant of spaces, but rather a combinatorial invariant of the chosen simplicial complex.

![image 1](<KGW2026/imageFile1.png>)

(a) The minimal triangulation of torus, \( T_1 \)

![image 2](<KGW2026/imageFile2.png>)

(b) A triangulation of torus,



Figure 1: Examples of triangulations of the torus
