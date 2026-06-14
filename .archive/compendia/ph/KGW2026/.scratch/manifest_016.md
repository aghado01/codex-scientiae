# Manifest: Page 016

## REPAIR_MATH
- RAW: ```
\mathcal { C } _ { N , 1 } = \{ v \in \mathcal { A } _ { 3 } | \, \exists \, \min i n a l { \ c l u s t e r } \, w \in \Omega _ { 3 } ^ { N , 1 } \ s u c h { \ t h a t } \, w = \alpha _ { v } v + \sum \alpha _ { v _ { i } } v _ { i } \ , v _ { i } \in \mathcal { A } _ { 3 } \}
```
  FIX: ```
$$
\mathcal { C } _ { N , 1 } = \{ v \in \mathcal { A } _ { 3 } | \, \exists \, \min i n a l { \ c l u s t e r } \, w \in \Omega _ { 3 } ^ { N , 1 } \ s u c h { \ t h a t } \, w = \alpha _ { v } v + \sum \alpha _ { v _ { i } } v _ { i } \ , v _ { i } \in \mathcal { A } _ { 3 } \}
$$
```
- RAW: ```
\phi ( \mathcal { C } _ { N , 1 } ) = \{ ( T , T , T , T ) , ( T , S , S , T ) \} \ \cup \ \mathcal { L } ,
```
  FIX: ```
$$
\phi ( \mathcal { C } _ { N , 1 } ) = \{ ( T , T , T , T ) , ( T , S , S , T ) \} \ \cup \ \mathcal { L } ,
$$
```
- RAW: ```
( S , T , N _ { w } , T ) , \, ( S , S , N _ { w } , T ) , \, ( S , W , N _ { w } , T ) , \, ( T , N _ { w } , T , S ) , \, ( T , N _ { w } , S ) , \, ( T , N _ { w } , W , S ) , \, ( S , N _ { w } , N _ { w } , S ) .
```
  FIX: ```
$$
( S , T , N _ { w } , T ) , \, ( S , S , N _ { w } , T ) , \, ( S , W , N _ { w } , T ) , \, ( T , N _ { w } , T , S ) , \, ( T , N _ { w } , S ) , \, ( T , N _ { w } , W , S ) , \, ( S , N _ { w } , N _ { w } , S ) .
$$
```
- RAW: ```
\phi ( v ) = \left ( \phi ( e _ { j , k , l } ) , \, \phi ( e _ { i , k , l } ) , \, \phi ( e _ { i , j , l } ) , \, \phi ( e _ { i , j , k } ) \right ) \in \Sigma ^ { 4 } , \quad \Sigma = \{ T , S , W , N _ { w } \} .
```
  FIX: ```
$$
\phi ( v ) = \left ( \phi ( e _ { j , k , l } ) , \, \phi ( e _ { i , k , l } ) , \, \phi ( e _ { i , j , l } ) , \, \phi ( e _ { i , j , k } ) \right ) \in \Sigma ^ { 4 } , \quad \Sigma = \{ T , S , W , N _ { w } \} .
$$
```
- RAW: ```
\phi ( v ) \in \{ S , W \} \times \{ T , S , W \} \times \{ N _ { w } \} \times \{ T \} .
```
  FIX: ```
$$
\phi ( v ) \in \{ S , W \} \times \{ T , S , W \} \times \{ N _ { w } \} \times \{ T \} .
$$
```
- RAW: ```
\phi ( v ) \in \{ T \} \times \{ N _ { w } \} \times \{ T , S , W \} \times \{ S , W \} .
```
  FIX: ```
$$
\phi ( v ) \in \{ T \} \times \{ N _ { w } \} \times \{ T , S , W \} \times \{ S , W \} .
$$
```

## REPAIR_PROSE
- RAW: ```
The above lemma shows that cancellation of non-admissible faces is highly constrained: a nonadmissible face can only be eliminated by pairing with another 3-path that shares the same face, and such a pairing necessarily produces a square-type configuration.
```
  FIX: ```
The above lemma shows that cancellation of non-admissible faces is highly constrained: a non-admissible face can only be eliminated by pairing with another 3-path that shares the same face, and such a pairing necessarily produces a square-type configuration.
```
- RAW: ```
In the construction of Γ, this cancellation mechanism is encoded globally by edges in the graph Γ, and generators arise from alternating paths and cycles in Γ. In our formulation, this same cancellation mechanism is encoded locally through the image-type ϕ ( v ) and the indicator maps π 2 ,π 3 .
```
  FIX: ```
In the construction of \( \Gamma \), this cancellation mechanism is encoded globally by edges in the graph \( \Gamma \), and generators arise from alternating paths and cycles in \( \Gamma \). In our formulation, this same cancellation mechanism is encoded locally through the image-type \( \phi(v) \) and the indicator maps \( \pi_2, \pi_3 \).
```
- RAW: ```
Therefore, instead of searching for alternating paths in Γ, we may identify generators by determining which collections of 3-path types can be connected through successive cancellations of non-admissible faces.
```
  FIX: ```
Therefore, instead of searching for alternating paths in \( \Gamma \), we may identify generators by determining which collections of 3-path types can be connected through successive cancellations of non-admissible faces.
```
- RAW: ```
Theorem 3.6. Let C N, 1 be the set of all 3 -paths components that occur in minimal cluster elements of Ω N, 1 3 .
```
  FIX: ```
Theorem 3.6. Let \( \mathcal{C}_{N,1} \) be the set of all 3-paths components that occur in minimal cluster elements of \( \Omega_3^{N,1} \).
```
- RAW: ```
Let ϕ : C N, 1 → { T,S,W,N w } 4 be the image-type map. Then, for N ≥ 2 ,
```
  FIX: ```
Let \( \phi : \mathcal{C}_{N,1} \to \{T,S,W,N_w\}^4 \) be the image-type map. Then, for \( N \geq 2 \),
```
- RAW: ```
In particular, | ϕ ( C N, 1 ) | = 9 .
```
  FIX: ```
In particular, \( |\phi(\mathcal{C}_{N,1})| = 9 \).
```
- RAW: ```
Proof. Let v ∈ C N, 1 . Then v = e i,j,k,l ∈ A 3 occurs as a component of a minimal w ∈ Ω N, 1 3 . By definition,
```
  FIX: ```
Proof. Let \( v \in \mathcal{C}_{N,1} \). Then \( v = e_{i,j,k,l} \in \mathcal{A}_3 \) occurs as a component of a minimal \( w \in \Omega_3^{N,1} \). By definition,
```
- RAW: ```
The type of each 2-face is determined by the existence of the shortcut edges e i,k , e j,l , and e i,l . We distinguish cases according to membership of these edges in A 1 .
```
  FIX: ```
The type of each 2-face is determined by the existence of the shortcut edges \( e_{i,k} \), \( e_{j,l} \), and \( e_{i,l} \). We distinguish cases according to membership of these edges in \( \mathcal{A}_1 \).
```
- RAW: ```
- If e i,k ,e j,l ,e i,l ∈ A 1 , then every 2-face is triangular and hence ϕ ( v ) = ( T,T,T,T ), in which case v ∈ Ω N, 1 3 for all N ≥ 2.
```
  FIX: ```
- If \( e_{i,k}, e_{j,l}, e_{i,l} \in \mathcal{A}_1 \), then every 2-face is triangular and hence \( \phi(v) = (T,T,T,T) \), in which case \( v \in \Omega_3^{N,1} \) for all \( N \geq 2 \).
```
- RAW: ```
- If e i,k ,e j,l ∈ A 1 but e i,l / ∈ A 1 , then for N = 2 the only possible configuration on four vertices produces the internal square and yields ϕ ( v ) = ( T,S,S,T ) which implies v ∈ Ω 2 , 1 3 . For N ≥ 3 this configuration cannot be realized using only the four vertices { i,j,k,l } (see example 3.1) but with additional vertices that will create squares with e i, ∗ ,k ; the remaining possibility on four vertices would force the pattern ( T,W,W,T ), does not belong to Ω N, 1 3 . Thus in this case the only pattern in C N, 1 is ( T,S,S,T ) for N ≥ 2.
```
  FIX: ```
- If \( e_{i,k}, e_{j,l} \in \mathcal{A}_1 \) but \( e_{i,l} \notin \mathcal{A}_1 \), then for \( N = 2 \) the only possible configuration on four vertices produces the internal square and yields \( \phi(v) = (T,S,S,T) \) which implies \( v \in \Omega_3^{2,1} \). For \( N \geq 3 \) this configuration cannot be realized using only the four vertices \( \{i,j,k,l\} \) (see Example 3.1) but with additional vertices that will create squares with \( e_{i,*,k} \); the remaining possibility on four vertices would force the pattern \( (T,W,W,T) \), does not belong to \( \Omega_3^{N,1} \). Thus in this case the only pattern in \( \mathcal{C}_{N,1} \) is \( (T,S,S,T) \) for \( N \geq 2 \).
```
- RAW: ```
- If e i,k ∈ A 1 and e j,l / ∈ A 1 , then the third face e i,j,l is non-admissible, so π 3 ( v ) = 1, and one obtains
```
  FIX: ```
- If \( e_{i,k} \in \mathcal{A}_1 \) and \( e_{j,l} \notin \mathcal{A}_1 \), then the third face \( e_{i,j,l} \) is non-admissible, so \( \pi_3(v) = 1 \), and one obtains
```
- RAW: ```
- If e j,l ∈ A 1 and e i,k / ∈ A 1 , then the second face e i,k,l is non-admissible, so the second coordinate of ϕ ( v ) is N w , and one obtains
```
  FIX: ```
- If \( e_{j,l} \in \mathcal{A}_1 \) and \( e_{i,k} \notin \mathcal{A}_1 \), then the second face \( e_{i,k,l} \) is non-admissible, so the second coordinate of \( \phi(v) \) is \( N_w \), and one obtains
```
