# Manifest: Page 008

## REPAIR_MATH
- RAW: ```
\partial ( e _ { 1 2 3 } ) = e _ { 2 3 } + \xi e _ { 1 3 } + \xi ^ { 2 } e _ { 1 2 } ,
```
  FIX: ```
$$
\partial ( e _ { 1 2 3 } ) = e _ { 2 3 } + \xi e _ { 1 3 } + \xi ^ { 2 } e _ { 1 2 } ,
$$
```
- RAW: ```
\Omega _ { n } ^ { N , q } = \Omega _ { n } ^ { N , q } ( P ) = \{ v \in \mathcal { A } _ { n } \, | \, \partial ^ { q } v \in \mathcal { A } _ { n - q } \} .
```
  FIX: ```
$$
\Omega _ { n } ^ { N , q } = \Omega _ { n } ^ { N , q } ( P ) = \{ v \in \mathcal { A } _ { n } \, | \, \partial ^ { q } v \in \mathcal { A } _ { n - q } \} .
$$
```
- RAW: ```
\Omega _ { n } ^ { N } = \bigcap _ { 1 \leq q \leq N - 1 } \Omega _ { n } ^ { N , q } ( P ) = \{ v \in \mathcal { A } _ { n } \, | \, \partial ^ { q } v \in \mathcal { A } _ { n - q } \} .
```
  FIX: ```
$$
\Omega _ { n } ^ { N } = \bigcap _ { 1 \leq q \leq N - 1 } \Omega _ { n } ^ { N , q } ( P ) = \{ v \in \mathcal { A } _ { n } \, | \, \partial ^ { q } v \in \mathcal { A } _ { n - q } \} .
$$
```
- RAW: ```
\partial v \in \Omega _ { n - 1 } ^ { N , q } \ \text { for all } q \in \{ 1 , \dots , N - 2 \} .
```
  FIX: ```
$$
\partial v \in \Omega _ { n - 1 } ^ { N , q } \ \text { for all } q \in \{ 1 , \dots , N - 2 \} .
$$
```
- RAW: ```
\mathcal { A } _ { 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } , e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \mathcal { A } _ { 3 } = < e _ { 1 , 2 , 3 , 4 } > .
```
  FIX: ```
$$
\mathcal { A } _ { 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } , e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \mathcal { A } _ { 3 } = < e _ { 1 , 2 , 3 , 4 } > .
$$
```
- RAW: ```
\partial ( e _ { 1 , 2 , 3 , 4 } ) & = e _ { 2 , 3 , 4 } + \xi e _ { 1 , 3 , 4 } + \xi ^ { 2 } e _ { 1 , 2 , 4 } + \xi ^ { 3 } e _ { 1 , 2 , 3 } \\ \partial ^ { 2 } ( e _ { 1 , 2 , 3 , 4 } ) & = ( \xi ^ { 2 } + \xi ^ { 3 } ) e _ { 1 , 4 } + w , \quad w \in \mathcal { A } _ { 1 } .
```
  FIX: ```
$$
\partial ( e _ { 1 , 2 , 3 , 4 } ) & = e _ { 2 , 3 , 4 } + \xi e _ { 1 , 3 , 4 } + \xi ^ { 2 } e _ { 1 , 2 , 4 } + \xi ^ { 3 } e _ { 1 , 2 , 3 } \\ \partial ^ { 2 } ( e _ { 1 , 2 , 3 , 4 } ) & = ( \xi ^ { 2 } + \xi ^ { 3 } ) e _ { 1 , 4 } + w , \quad w \in \mathcal { A } _ { 1 } .
$$
```
- RAW: ```
\Omega _ { 2 } ^ { 2 , 1 } = \Omega _ { 2 } ^ { 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 2 , 1 } = \Omega _ { 3 } ^ { 2 } = < e _ { 1 , 2 , 3 , 4 } > ,
```
  FIX: ```
$$
\Omega _ { 2 } ^ { 2 , 1 } = \Omega _ { 2 } ^ { 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 2 , 1 } = \Omega _ { 3 } ^ { 2 } = < e _ { 1 , 2 , 3 , 4 } > ,
$$
```
- RAW: ```
\Omega _ { 2 } ^ { 3 , 1 } = & < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 2 } ^ { 3 , 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } , e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 , 1 } = < e _ { 1 , 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 , 2 } = 0 , \\ \Omega _ { 2 } ^ { 3 } = & \Omega _ { 2 } ^ { 3 , 1 } \cap \Omega _ { 2 } ^ { 3 , 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 } = \Omega _ { 3 } ^ { 3 , 1 } \cap \Omega _ { 3 } ^ { 3 , 2 } = 0 .
```
  FIX: ```
$$
\Omega _ { 2 } ^ { 3 , 1 } = & < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 2 } ^ { 3 , 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } , e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 , 1 } = < e _ { 1 , 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 , 2 } = 0 , \\ \Omega _ { 2 } ^ { 3 } = & \Omega _ { 2 } ^ { 3 , 1 } \cap \Omega _ { 2 } ^ { 3 , 2 } = < e _ { 1 , 2 , 3 } , e _ { 1 , 2 , 4 } - e _ { 1 , 3 , 4 } , e _ { 2 , 3 , 4 } > , \quad \Omega _ { 3 } ^ { 3 } = \Omega _ { 3 } ^ { 3 , 1 } \cap \Omega _ { 3 } ^ { 3 , 2 } = 0 .
$$
```

## REPAIR_PROSE
- RAW: ```
  where ξ is the N -th root of unity and e 13 ̸∈ A 1 . Hence, ( A n ,∂ ) does not always form an N -chain complex.
  ```
  FIX: ```
  where \(\xi\) is the \(N\)-th root of unity and \(e_{13} \notin \mathcal{A}_1\). Hence, \((\mathcal{A}_n, \partial)\) does not always form an \(N\)-chain complex.
  ```
- RAW: ```
  Definition 7. For N ≥ 2 and 1 ≤ q ≤ N − 1 , define the space of ∂ -invariant n -paths at level ( N,q ) as N,q N,q q
  ```
  FIX: ```
  Definition 7. For \(N \geq 2\) and \(1 \leq q \leq N - 1\), define the space of \(\partial\)-invariant \(n\)-paths at level \((N,q)\) as
  ```
- RAW: ```
  The intersection is called ∂ -invariant n -paths and is denoted as follows:
  ```
  FIX: ```
  The intersection is called \(\partial\)-invariant \(n\)-paths and is denoted as follows:
  ```
- RAW: ```
  If v ∈ Ω N n , then v ∈ Ω N,q n for all q ∈ { 1 ,...,N − 1 } . Thus, for 1 ≤ q ≤ N − 2, ∂ q v ∈ A n − q . Consequently, ∂ q − 1 ( ∂v ) ∈ A n − q for all q ∈ { 1 ,...,N − 1 } , which implies
  ```
  FIX: ```
  If \(v \in \Omega_n^N\), then \(v \in \Omega_n^{N,q}\) for all \(q \in \{1, \dots, N-1\}\). Thus, for \(1 \leq q \leq N-2\), \(\partial^q v \in \mathcal{A}_{n-q}\). Consequently, \(\partial^{q-1}(\partial v) \in \mathcal{A}_{n-q}\) for all \(q \in \{1, \dots, N-1\}\), which implies
  ```
- RAW: ```
  For q = N − 1, we have ∂ N − 1 ( ∂v ) = 0 ∈ A n − N . Thus, ∂ ( v ) ∈ Ω N,q n − 1 for all 1 ≤ q ≤ N − 1, and therefore (Ω N n ,∂ ) forms an N -chain path complex. The following example shows that, in general, Ω N,q n alone does not form a chain complex.
  ```
  FIX: ```
  For \(q = N - 1\), we have \(\partial^{N-1}(\partial v) = 0 \in \mathcal{A}_{n-N}\). Thus, \(\partial(v) \in \Omega_{n-1}^{N,q}\) for all \(1 \leq q \leq N - 1\), and therefore \((\Omega_n^N, \partial)\) forms an \(N\)-chain path complex. The following example shows that, in general, \(\Omega_n^{N,q}\) alone does not form a chain complex.
  ```
- RAW: ```
  Example 3.1. Let P be the path complex induced by the digraph with V = { e 1 ,e 2 ,e 3 ,e 4 } and E = { e 1 , 2 ,e 1 , 3 ,e 2 , 3 ,e 2 , 4 ,e 3 , 4 } . The elementary path spaces will be as follows
  ```
  FIX: ```
  Example 3.1. Let \(P\) be the path complex induced by the digraph with \(V = \{e_1, e_2, e_3, e_4\}\) and \(E = \{e_{1,2}, e_{1,3}, e_{2,3}, e_{2,4}, e_{3,4}\}\). The elementary path spaces will be as follows
  ```
- RAW: ```
  For ( ξ 2 + ξ 3 ) e 1 , 4 ∈ A 1 , we have ξ 2 + ξ 3 = 0 which only occur when N = 2 . We have the ∂ -invariant paths as follows
  ```
  FIX: ```
  For \((\xi^2 + \xi^3) e_{1,4} \in \mathcal{A}_1\), we have \(\xi^2 + \xi^3 = 0\) which only occur when \(N = 2\). We have the \(\partial\)-invariant paths as follows
  ```
- RAW: ```
  Observe that ∂ (Ω 3 , 1 3 ) ̸⊂ Ω 3 , 1 2 where ∂ (Ω 2 3 ) ⊂ Ω 2 2 .
  ```
  FIX: ```
  Observe that \(\partial(\Omega_3^{3,1}) \not\subset \Omega_2^{3,1}\) where \(\partial(\Omega_3^2) \subset \Omega_2^2\).
  ```
