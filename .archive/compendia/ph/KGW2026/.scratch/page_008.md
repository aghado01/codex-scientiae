[Page 8]

![image 3](<KGW2026/imageFile3.png>)

Figure 2: Example 3.1

$$
\partial ( e _ { 1 2 3 } ) = e _ { 2 3 } + \xi e _ { 1 3 } + \xi ^ { 2 } e _ { 1 2 } ,
$$

where \(\xi\) is the \(N\)-th root of unity and \(e_{13} \notin \mathcal{A}_1\). Hence, \((\mathcal{A}_n, \partial)\) does not always form an \(N\)-chain complex.

Definition 7. For \(N \geq 2\) and \(1 \leq q \leq N - 1\), define the space of \(\partial\)-invariant \(n\)-paths at level \((N,q)\) as

$$
\Omega _ { n } ^ { N , q } = \Omega _ { n } ^ { N , q } ( P ) = \{ v \in \mathcal { A } _ { n } \, | \, \partial ^ { q } v \in \mathcal { A } _ { n - q } \} .
$$

The intersection is called \(\partial\)-invariant \(n\)-paths and is denoted as follows:

$$
\Omega _ { n } ^ { N } = \bigcap _ { 1 \leq q \leq N - 1 } \Omega _ { n } ^ { N , q } ( P ) = \{ v \in \mathcal { A } _ { n } \, | \, \partial ^ { q } v \in \mathcal { A } _ { n - q } \} .
$$

If \(v \in \Omega_n^N\), then \(v \in \Omega_n^{N,q}\) for all \(q \in \{1, \dots, N-1\}\). Thus, for \(1 \leq q \leq N-2\), \(\partial^q v \in \mathcal{A}_{n-q}\). Consequently, \(\partial^{q-1}(\partial v) \in \mathcal{A}_{n-q}\) for all \(q \in \{1, \dots, N-1\}\), which implies

$$
\partial v \in \Omega _ { n - 1 } ^ { N , q } \ \text { for all } q \in \{ 1 , \dots , N - 2 \} .
$$

For \(q = N - 1\), we have \(\partial^{N-1}(\partial v) = 0 \in \mathcal{A}_{n-N}\). Thus, \(\partial(v) \in \Omega_{n-1}^{N,q}\) for all \(1 \leq q \leq N - 1\), and therefore \((\Omega_n^N, \partial)\) forms an \(N\)-chain path complex. The following example shows that, in general, \(\Omega_n^{N,q}\) alone does not form a chain complex.

Example 3.1. Let \(P\) be the path complex induced by the digraph with \(V = \{e_1, e_2, e_3, e_4\}\) and \(E = \{e_{1,2}, e_{1,3}, e_{2,3}, e_{2,4}, e_{3,4}\}\). The elementary path spaces will be as follows

$$
\mathcal { A } _ { 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } , e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \mathcal { A } _ { 3 } = < e _ { 1 , 2 , 3 , 4 } > .
$$

$$
\partial ( e _ { 1 , 2 , 3 , 4 } ) & = e _ { 2 , 3 , 4 } + \xi e _ { 1 , 3 , 4 } + \xi ^ { 2 } e _ { 1 , 2 , 4 } + \xi ^ { 3 } e _ { 1 , 2 , 3 } \\ \partial ^ { 2 } ( e _ { 1 , 2 , 3 , 4 } ) & = ( \xi ^ { 2 } + \xi ^ { 3 } ) e _ { 1 , 4 } + w , \quad w \in \mathcal { A } _ { 1 } .
$$

For \((\xi^2 + \xi^3) e_{1,4} \in \mathcal{A}_1\), we have \(\xi^2 + \xi^3 = 0\) which only occur when \(N = 2\). We have the \(\partial\)-invariant paths as follows

$$
\Omega _ { 2 } ^ { 2 , 1 } = \Omega _ { 2 } ^ { 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 2 , 1 } = \Omega _ { 3 } ^ { 2 } = < e _ { 1 , 2 , 3 , 4 } > ,
$$

$$
\Omega _ { 2 } ^ { 3 , 1 } = & < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 2 } ^ { 3 , 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } , e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 , 1 } = < e _ { 1 , 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 , 2 } = 0 , \\ \Omega _ { 2 } ^ { 3 } = & \Omega _ { 2 } ^ { 3 , 1 } \cap \Omega _ { 2 } ^ { 3 , 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 } = \Omega _ { 3 } ^ { 3 , 1 } \cap \Omega _ { 3 } ^ { 3 , 2 } = 0 .
$$

Observe that \(\partial(\Omega_3^{3,1}) \not\subset \Omega_2^{3,1}\) where \(\partial(\Omega_3^2) \subset \Omega_2^2\).
