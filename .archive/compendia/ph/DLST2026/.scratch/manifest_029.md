# Manifest: Page 029

## REPAIR_MATH
- RAW: ```
where & & X _ { 1 } \cong \text {im} \, i _ { * } , & & X _ { 2 } \cong \text {coin} \, j _ { * } = \frac { H ( N _ { 2 } , N _ { 0 } ) } { \ker j _ { * } } , \\ & V _ { 1 } \cong \text {coker} \, j _ { * } , & & V _ { 2 } \cong \text {im} \, j _ { * } , \\ & W _ { 1 } \cong \text {coin} \, i _ { * } = \frac { H ( N _ { 1 } , N _ { 0 } ) } { \ker i _ { * } } , & & W _ { 2 } \cong \text {ker} \, i _ { * } .
```
  FIX: ```
$$
where & & X _ { 1 } \cong \text {im} \, i _ { * } , & & X _ { 2 } \cong \text {coin} \, j _ { * } = \frac { H ( N _ { 2 } , N _ { 0 } ) } { \ker j _ { * } } , \\ & V _ { 1 } \cong \text {coker} \, j _ { * } , & & V _ { 2 } \cong \text {im} \, j _ { * } , \\ & W _ { 1 } \cong \text {coin} \, i _ { * } = \frac { H ( N _ { 1 } , N _ { 0 } ) } { \ker i _ { * } } , & & W _ { 2 } \cong \text {ker} \, i _ { * } .
$$
```
- RAW: ```
W _ { 1 } \cong \coim \, i _ { * } = \frac { I ( 1 \, { N } _ { 1 } , 1 \, { N } _ { 0 } ) } { \ker i _ { * } } ,
```
  FIX: ```
$$
W _ { 1 } \cong \coim \, i _ { * } = \frac { I ( 1 \, { N } _ { 1 } , 1 \, { N } _ { 0 } ) } { \ker i _ { * } } ,
$$
```
- RAW: ```
( B _ { \bullet , 0 } , \emptyset ) = ( N _ { 2 } , N _ { 0 } ) \hookrightarrow ( N _ { 2 } , N _ { 1 } ) = ( B _ { \bullet , 0 } , B _ { \circ , 1 } ) \\ \uparrow \searrow \uparrow \uparrow \uparrow \uparrow \\ ( N _ { 1 } , N _ { 0 } ) = ( B _ { \circ , 1 } , \emptyset )
```
  FIX: ```
$$
( B _ { \bullet , 0 } , \emptyset ) = ( N _ { 2 } , N _ { 0 } ) \hookrightarrow ( N _ { 2 } , N _ { 1 } ) = ( B _ { \bullet , 0 } , B _ { \circ , 1 } ) \\ \uparrow \searrow \uparrow \uparrow \uparrow \uparrow \\ ( N _ { 1 } , N _ { 0 } ) = ( B _ { \circ , 1 } , \emptyset )
$$
```
- RAW: ```
\text {Con} ( M _ { \bullet , 0 } ) \longrightarrow \text {Con} ( M _ { * , 1 } ) \quad & \quad [ k , 0 , 0 ] \stackrel { [ 0 , 0 , 0 ] } { \longrightarrow } [ 0 , 0 , k ] \\ \stackrel { \uparrow } { \longrightarrow } \stackrel { \uparrow } { \vdots } \stackrel { \uparrow } { \colon } & \quad \cong \quad \stackrel { [ \uparrow } { \longmapsto } \stackrel { \uparrow } { \colon } \stackrel { \uparrow } { \longmapsto } \stackrel { \uparrow } { \cdot } 0 \\ \text {Con} ( M _ { \circ , 1 } ) & \quad & [ k , k , 0 ]
```
  FIX: ```
$$
\text {Con} ( M _ { \bullet , 0 } ) \longrightarrow \text {Con} ( M _ { * , 1 } ) \quad & \quad [ k , 0 , 0 ] \stackrel { [ 0 , 0 , 0 ] } { \longrightarrow } [ 0 , 0 , k ] \\ \stackrel { \uparrow } { \longrightarrow } \stackrel { \uparrow } { \vdots } \stackrel { \uparrow } { \colon } & \quad \cong \quad \stackrel { [ \uparrow } { \longmapsto } \stackrel { \uparrow } { \colon } \stackrel { \uparrow } { \longmapsto } \stackrel { \uparrow } { \cdot } 0 \\ \text {Con} ( M _ { \circ , 1 } ) & \quad & [ k , k , 0 ]
$$
```

## REPAIR_PROSE
- RAW: ```
The maps f : X 2 → V 2 , g : W 1 → X 1 , and h : V 1 → W 2 are induced by j ∗ , i ∗ , and ∂ ∗ , respectively. Note that f and g are of degree 0, while h of degree − 1. All maps are isomorphisms, f and g by the first isomorphisms theorem, and h ∗ is given by Theorem 5.12(c) .
```
  FIX: ```
The maps \( f : X_{2} \to V_{2} \), \( g : W_{1} \to X_{1} \), and \( h : V_{1} \to W_{2} \) are induced by \( j_{*} \), \( i_{*} \), and \( \partial_{*} \), respectively. Note that \( f \) and \( g \) are of degree \( 0 \), while \( h \) of degree \( -1 \). All maps are isomorphisms, \( f \) and \( g \) by the first isomorphisms theorem, and \( h_{*} \) is given by Theorem 5.12(c).
```
- RAW: ```
Corollary 5.13. Let N 0 ⊂ N 1 ⊂ N 2 be an index triple for isolated invariant set M and its AR-decomposition { M a ,M r } . Then, Theorem 5.12 implies that:
```
  FIX: ```
Corollary 5.13. Let \( N_{0} \subset N_{1} \subset N_{2} \) be an index triple for isolated invariant set \( M \) and its AR-decomposition \( \{ M_{a}, M_{r} \} \). Then, Theorem 5.12 implies that:
```
- RAW: ```
- (a) Con( M a ) and Con( M r ) do not “share” generators, that is, any generator in Con( M a ) is mapped into 0 in Con( M r ) through the connecting maps, because k ∗ ∼ = (0 ⊕ f ) ◦ ( g ⊕ 0) = 0,
```
  FIX: ```
- (a) \( \text{Con}(M_{a}) \) and \( \text{Con}(M_{r}) \) do not “share” generators, that is, any generator in \( \text{Con}(M_{a}) \) is mapped into \( 0 \) in \( \text{Con}(M_{r}) \) through the connecting maps, because \( k_{*} \cong (0 \oplus f) \circ (g \oplus 0) = 0 \),
```
- RAW: ```
- (b) each generator of Con( M ) is present either in the attractor M a or in the repeller M r ; none of them vanishes during the split, that is, X 1 continues as W 1 and X 2 continues as V 2 ,
```
  FIX: ```
- (b) each generator of \( \text{Con}(M) \) is present either in the attractor \( M_{a} \) or in the repeller \( M_{r} \); none of them vanishes during the split, that is, \( X_{1} \) continues as \( W_{1} \) and \( X_{2} \) continues as \( V_{2} \),
```
- RAW: ```
- (c) the generators of Con d ( M r ) and Con d − 1 ( M a ) that are not “inherited” from Con( M ), that is W 1 and V 2 , are coupled via isomorphism h d ∗ . That is, whenever new generators are born during the AR-split, they appear in pairs. Specifically, for every basis element of degree d − 1 in Con( M a ) which is not present in Con( M ), that is, an element of W 2 , there exists a matching dual basis element of degree d in Con( M r ) which is likewise not present in M (that is, an element of V 1 ).
```
  FIX: ```
- (c) the generators of \( \text{Con}_{d}(M_{r}) \) and \( \text{Con}_{d-1}(M_{a}) \) that are not “inherited” from \( \text{Con}(M) \), that is \( W_{1} \) and \( V_{2} \), are coupled via isomorphism \( h_{d}^{*} \). That is, whenever new generators are born during the AR-split, they appear in pairs. Specifically, for every basis element of degree \( d-1 \) in \( \text{Con}(M_{a}) \) which is not present in \( \text{Con}(M) \), that is, an element of \( W_{2} \), there exists a matching dual basis element of degree \( d \) in \( \text{Con}(M_{r}) \) which is likewise not present in \( M \) (that is, an element of \( V_{1} \)).
```
- RAW: ```
Example 5.14. Consider the splitting of B • , 0 into B ◦ , 1 and B ⋆, 1 in the step B 0 ⊒ B 1 from Example 5.3 . In this case, the involved isolating blocks equal the corresponding Morse sets M • , 0 , M ◦ , 1 and M ⋆, 1 . Sets B ◦ , 1 and B ⋆, 1 form a block decomposition of B • , 0 in V 1 . One can easily check that sets N 0 : = ∅ , N 1 : = B ◦ , 1 and N 2 : = B • , 0 satisfy the index triple assumptions. Thus, we get the following diagram:
```
  FIX: ```
Example 5.14. Consider the splitting of \( B_{\bullet, 0} \) into \( B_{\circ, 1} \) and \( B_{\star, 1} \) in the step \( B_{0} \sqsupseteq B_{1} \) from Example 5.3. In this case, the involved isolating blocks equal the corresponding Morse sets \( M_{\bullet, 0} \), \( M_{\circ, 1} \), and \( M_{\star, 1} \). Sets \( B_{\circ, 1} \) and \( B_{\star, 1} \) form a block decomposition of \( B_{\bullet, 0} \) in \( V_{1} \). One can easily check that sets \( N_{0} := \emptyset \), \( N_{1} := B_{\circ, 1} \) and \( N_{2} := B_{\bullet, 0} \) satisfy the index triple assumptions. Thus, we get the following diagram:
```
- RAW: ```
The AR-split theorem states that degree 0 generator of Con( M • , 0 ) has been “passed” to Con( M ◦ , 0 ). Moreover, degree 1 and 2 generators of Con( M ◦ , 1 ) and
```
  FIX: ```
The AR-split theorem states that degree \( 0 \) generator of \( \text{Con}(M_{\bullet, 0}) \) has been “passed” to \( \text{Con}(M_{\circ, 0}) \). Moreover, degree \( 1 \) and \( 2 \) generators of \( \text{Con}(M_{\circ, 1}) \) and
```
