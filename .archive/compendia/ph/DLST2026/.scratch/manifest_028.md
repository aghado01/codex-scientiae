# Manifest: Page 028

## REPAIR_MATH
- RAW: ```
\dots \xrightarrow { i _ { * } ^ { d } } H _ { d } ( N _ { 2 } , N _ { 0 } ) \xrightarrow { j _ { * } ^ { d } } H _ { d } ( N _ { 2 } , N _ { 1 } ) \xrightarrow { \partial _ { * } ^ { d } } H _ { d - 1 } ( N _ { 1 } , N _ { 0 } ) \xrightarrow { i _ { * } ^ { d - 1 } } . .
```
  FIX: ```
$$
\dots \xrightarrow { i _ { * } ^ { d } } H _ { d } ( N _ { 2 } , N _ { 0 } ) \xrightarrow { j _ { * } ^ { d } } H _ { d } ( N _ { 2 } , N _ { 1 } ) \xrightarrow { \partial _ { * } ^ { d } } H _ { d - 1 } ( N _ { 1 } , N _ { 0 } ) \xrightarrow { i _ { * } ^ { d - 1 } } . .
$$
```
- RAW: ```
\text {coker} \, j _ { * } ^ { d } \cong \frac { H _ { d } ( N _ { 2 } , N _ { 1 } ) } { \text {im} \, j _ { * } ^ { d } } \cong \frac { H _ { d } ( N _ { 2 } , N _ { 1 } ) } { \ker \partial _ { * } ^ { d } } \cong \text {im} \, \partial _ { * } ^ { d } \cong \ker \, i _ { * } ^ { d - 1 } ,
```
  FIX: ```
$$
\text {coker} \, j _ { * } ^ { d } \cong \frac { H _ { d } ( N _ { 2 } , N _ { 1 } ) } { \text {im} \, j _ { * } ^ { d } } \cong \frac { H _ { d } ( N _ { 2 } , N _ { 1 } ) } { \ker \partial _ { * } ^ { d } } \cong \text {im} \, \partial _ { * } ^ { d } \cong \ker \, i _ { * } ^ { d - 1 } ,
$$
```
- RAW: ```
H ( N _ { 2 } , N _ { 0 } ) \ \cong \ \ X _ { 1 } \oplus X _ { 2 } \ \xrightarrow { 0 \oplus f } V _ { 1 } \oplus V _ { 2 } \quad \cong \quad H ( N _ { 2 } , N _ { 1 } ) \\ \searrow \bigcap _ { g \oplus 0 } \ \searrow \ \bigcup _ { \substack { h _ { * } \\ W _ { 1 } \oplus W _ { 2 } } } h _ { * } \\ \cong \quad H ( N _ { 1 } , N _ { 0 } )
```
  FIX: ```
$$
H ( N _ { 2 } , N _ { 0 } ) \ \cong \ \ X _ { 1 } \oplus X _ { 2 } \ \xrightarrow { 0 \oplus f } V _ { 1 } \oplus V _ { 2 } \quad \cong \quad H ( N _ { 2 } , N _ { 1 } ) \\ \searrow \bigcap _ { g \oplus 0 } \ \searrow \ \bigcup _ { \substack { h _ { * } \\ W _ { 1 } \oplus W _ { 2 } } } h _ { * } \\ \cong \quad H ( N _ { 1 } , N _ { 0 } )
$$
```

## REPAIR_PROSE
- RAW: ```
(N 2

,N 0

)

(N 2

,N 1

)







(N 1

,N 0

)



(5.2)
```
  FIX: ```
(5.2)
```
- RAW: ```
It is easy to notice that an index triple forms a long exact sequence, as shown below, from which we can relate the Conley indices of sets involved in the ARdecomposition, that is M , M a and M r .
```
  FIX: ```
It is easy to notice that an index triple forms a long exact sequence, as shown below, from which we can relate the Conley indices of sets involved in the ARdecomposition, that is \( M \), \( M_a \) and \( M_r \).
```
- RAW: ```
Theorem 5.12 (The AR-split) . Consider an index triple N 0 ⊂ N 1 ⊂ N 2 and the inclusion induced maps i d ∗ ,j d ∗ and ∂ d ∗ as in the long exact sequence ( 5.3 ). Then, we have the following properties:

- (a) k d ∗ : = j d ∗ ◦ i d ∗ = 0 for all d ∈ N , d H ( N ,N )
- (b) H d ( N 2 ,N 0 ) ∼ = im i ∗ ⊕ d 2 0 ker j d ∗ for all d ∈ N , d d d 1
- (c) h ∗ : coker j ∗ → ker i − ∗ , defined as the restriction of ∂ d ∗ to coker j d ∗ , is an isomorphism for all d ∈ N .
```
  FIX: ```
Theorem 5.12 (The AR-split). Consider an index triple \( N_0 \subset N_1 \subset N_2 \) and the inclusion induced maps \( i_*^d \), \( j_*^d \) and \( \partial_*^d \) as in the long exact sequence (5.3). Then, we have the following properties:

- (a) \( k_*^d := j_*^d \circ i_*^d = 0 \) for all \( d \in \mathbb{N} \)
- (b) \( H_d(N_2, N_0) \cong \text{im } i_*^d \oplus \frac{H_d(N_2, N_0)}{\ker j_*^d} \) for all \( d \in \mathbb{N} \)
- (c) \( h_* : \text{coker } j_*^d \to \ker i_*^{d-1} \), defined as the restriction of \( \partial_*^d \) to \( \text{coker } j_*^d \), is an isomorphism for all \( d \in \mathbb{N} \).
```
- RAW: ```
Proof. Property (a) is straightforward since N 1 becomes the relative part under the map k .

To see (b) , note that we work with vector spaces; therefore, the long exact sequence splits. In particular, we have H d ( N 2 ,N 0 ) ∼ = im i d ∗ ⊕ ker j d ∗ im i d ∗ ⊕ H d ( N 2 ,N 0 ) ker j d ∗ , but we can omit the middle term, because exactness provides that ker j d ∗ = im i d ∗ .

To prove (c) , we use the following sequence of isomorphisms:
```
  FIX: ```
Proof. Property (a) is straightforward since \( N_1 \) becomes the relative part under the map \( k \).

To see (b), note that we work with vector spaces; therefore, the long exact sequence splits. In particular, we have \( H_d(N_2, N_0) \cong \ker j_*^d \oplus \frac{H_d(N_2, N_0)}{\ker j_*^d} \cong \text{im } i_*^d \oplus \frac{H_d(N_2, N_0)}{\ker j_*^d} \), but we can omit the middle term, because exactness provides that \( \ker j_*^d = \text{im } i_*^d \).

To prove (c), we use the following sequence of isomorphisms:
```
- RAW: ```
where the first equality follows by definition of coker, the second and the fourth equality are given by the exactness of the sequence, and the third by the first isomorphism theorem. □

We will revisit Theorem 5.12 in Section 7 after introducing the persistence language, but for now, let us observe what it implies for Conley indices when we encounter an AR-split. In particular, based on the right diagram in ( 5.2 ) we construct the diagram:
```
  FIX: ```
where the first equality follows by definition of coker, the second and the fourth equality are given by the exactness of the sequence, and the third by the first isomorphism theorem. □

We will revisit Theorem 5.12 in Section 7 after introducing the persistence language, but for now, let us observe what it implies for Conley indices when we encounter an AR-split. In particular, based on the right diagram in (5.2) we construct the diagram:
```
