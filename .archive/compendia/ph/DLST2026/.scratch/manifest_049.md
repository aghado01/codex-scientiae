# Manifest: Page 049

## REPAIR_MATH
- RAW: ```
A _ { \ell ( t + 1 ) } = [ S _ { i ( t + 1 ) } | S _ { j ( t + 1 ) } ] \text { and } B _ { \ell ( t + 1 ) } = B _ { i ( t + 1 ) } .
```
  FIX: ```
\[
A _ { \ell ( t + 1 ) } = [ S _ { i ( t + 1 ) } | S _ { j ( t + 1 ) } ] \text { and } B _ { \ell ( t + 1 ) } = B _ { i ( t + 1 ) } .
\]
```

## REPAIR_PROSE
- RAW: ```
Case 2: Point a it has a single immediate point a ℓ ( t +1) at time t + 1 where the matrices have already been computed while proceeding from another point a jt that has also a ℓ ( t +1) as immediate point. In this case, these matrices need to be updated further. Observe that, proceeding from a it , the algorithm extends a set of bars (interval modules) for ZZ it to the point a ℓ ( t +1) which do not overlap with the set of bars that have already been extended by the algorithm while processing ZZ jt at a jt according to Theorem 7.8 . However, the new bars that are created while proceeding from a it may not be disjoint from the new bars that have already been computed while proceeding from a jt , a case that needs to be reconciled via the updated matrices.
```
  FIX: ```
Case 2: Point \( a_{i_t} \) has a single immediate point \( a_{\ell(t+1)} \) at time \( t + 1 \) where the matrices have already been computed while proceeding from another point \( a_{j_t} \) that has also \( a_{\ell(t+1)} \) as immediate point. In this case, these matrices need to be updated further. Observe that, proceeding from \( a_{i_t} \), the algorithm extends a set of bars (interval modules) for \( \text{ZZ}_{i_t} \) to the point \( a_{\ell(t+1)} \) which do not overlap with the set of bars that have already been extended by the algorithm while processing \( \text{ZZ}_{j_t} \) at \( a_{j_t} \) according to Theorem 7.8. However, the new bars that are created while proceeding from \( a_{i_t} \) may not be disjoint from the new bars that have already been computed while proceeding from \( a_{j_t} \), a case that needs to be reconciled via the updated matrices.
```

- RAW: ```
First, we observe that when we compute the extension from a it , the bars that are continued from a jt appear as new bars being born at a ℓ ( t +1) . Let β be a bar that continues from a it to a ℓ ( t +1) . The representative d -cycle computed for β at point a ℓ ( t +1) appears as a newly born d -cycle when seen from point a jt . Similarly, the representative cycle computed for a bar continued from point a jt appears as a newly born d -cycle when seen from point a it . Suppose that Z i ( t +1) = [ A i ( t +1) | B i ( t +1) ] and Z j ( t +1) = [ A j ( t +1) | B j ( t +1) ] are the updated matrices of Z it and Z jt respectively at a l ( t +1) . Let A i ( t +1) = [ R i ( t +1) | S i ( t +1) ] and A j ( t +1) = [ R j ( t +1) | S j ( t +1) ] where R i ( t +1) ⊆ A i ( t +1) and R j ( t +1) ⊆ A j ( t +1) are the submatrices representing newly born d -cycles when proceeding from a it and a jt respectively. By Theorem 7.8 (b)(coarsening case), no new bar is born at a ℓ ( t +1) for the module M induced by TD . It follows that the space represented by the columns of R i ( t +1) is equal to the space represented by the columns of S j ( t +1) and the space represented by the columns of R j ( t +1) is equal to the space represented by the columns of S i ( t +1) . This observation allows us to construct a new matrix Z ℓ ( t +1) = [ A ℓ ( t +1) | B ℓ ( t +1) ] at point a ℓ ( t +1) where
```
  FIX: ```
First, we observe that when we compute the extension from \( a_{i_t} \), the bars that are continued from \( a_{j_t} \) appear as new bars being born at \( a_{\ell(t+1)} \). Let \( \beta \) be a bar that continues from \( a_{i_t} \) to \( a_{\ell(t+1)} \). The representative \( d \)-cycle computed for \( \beta \) at point \( a_{\ell(t+1)} \) appears as a newly born \( d \)-cycle when seen from point \( a_{j_t} \). Similarly, the representative cycle computed for a bar continued from point \( a_{j_t} \) appears as a newly born \( d \)-cycle when seen from point \( a_{i_t} \). Suppose that \( Z_{i(t+1)} = [ A_{i(t+1)} \mid B_{i(t+1)} ] \) and \( Z_{j(t+1)} = [ A_{j(t+1)} \mid B_{j(t+1)} ] \) are the updated matrices of \( Z_{i_t} \) and \( Z_{j_t} \) respectively at \( a_{\ell(t+1)} \). Let \( A_{i(t+1)} = [ R_{i(t+1)} \mid S_{i(t+1)} ] \) and \( A_{j(t+1)} = [ R_{j(t+1)} \mid S_{j(t+1)} ] \) where \( R_{i(t+1)} \subseteq A_{i(t+1)} \) and \( R_{j(t+1)} \subseteq A_{j(t+1)} \) are the submatrices representing newly born \( d \)-cycles when proceeding from \( a_{i_t} \) and \( a_{j_t} \) respectively. By Theorem 7.8 (b) (coarsening case), no new bar is born at \( a_{\ell(t+1)} \) for the module \( M \) induced by \( \text{TD} \). It follows that the space represented by the columns of \( R_{i(t+1)} \) is equal to the space represented by the columns of \( S_{j(t+1)} \) and the space represented by the columns of \( R_{j(t+1)} \) is equal to the space represented by the columns of \( S_{i(t+1)} \). This observation allows us to construct a new matrix \( Z_{\ell(t+1)} = [ A_{\ell(t+1)} \mid B_{\ell(t+1)} ] \) at point \( a_{\ell(t+1)} \) where
```

- RAW: ```
For the updated matrix C ℓ ( t +1) , we simply take C ℓ ( t +1) : = C i ( t +1) because B ℓ ( t +1) = B i ( t +1) in the updated matrix Z ℓ ( t +1) .
```
  FIX: ```
For the updated matrix \( C_{\ell(t+1)} \), we simply take \( C_{\ell(t+1)} := C_{i(t+1)} \) because \( B_{\ell(t+1)} = B_{i(t+1)} \) in the updated matrix \( Z_{\ell(t+1)} \).
```

- RAW: ```
Case 3: Point a it has two immediate points a j ( t +1) and a ℓ ( t +1) at time t + 1. In this case, we proceed as in Case 1 or Case 2 as needed for each of a j ( t +1) and a ℓ ( t +1) and we obtain the updated matrices at these two points accordingly. It is worth noting that while processing the filtration ZZ it for extension to a j ( t +1) , the bars that extend from a it to a ℓ ( t +1) appear as bars ending at a it . Similarly, while extending the filtration ZZ it to a ℓ ( t +1) , the bars that extend from a it to a j ( t +1) appear as bars ending at a it . By Theorem 7.8 , the two sets of bars do not overlap. Also, due to Theorem 7.8( b ) (refinement case), no bar actually dies for the module M at a it . Hence, we simply ignore the bars that appear to be ending at a it while processing the filtration from a it to a j ( t +1) and to a ℓ ( t +1) .
```
  FIX: ```
Case 3: Point \( a_{i_t} \) has two immediate points \( a_{j(t+1)} \) and \( a_{\ell(t+1)} \) at time \( t + 1 \). In this case, we proceed as in Case 1 or Case 2 as needed for each of \( a_{j(t+1)} \) and \( a_{\ell(t+1)} \) and we obtain the updated matrices at these two points accordingly. It is worth noting that while processing the filtration \( \text{ZZ}_{i_t} \) for extension to \( a_{j(t+1)} \), the bars that extend from \( a_{i_t} \) to \( a_{\ell(t+1)} \) appear as bars ending at \( a_{i_t} \). Similarly, while extending the filtration \( \text{ZZ}_{i_t} \) to \( a_{\ell(t+1)} \), the bars that extend from \( a_{i_t} \) to \( a_{j(t+1)} \) appear as bars ending at \( a_{i_t} \). By Theorem 7.8, the two sets of bars do not overlap. Also, due to Theorem 7.8(b) (refinement case), no bar actually dies for the module \( M \) at \( a_{i_t} \). Hence, we simply ignore the bars that appear to be ending at \( a_{i_t} \) while processing the filtration from \( a_{i_t} \) to \( a_{j(t+1)} \) and to \( a_{\ell(t+1)} \).
```

- RAW: ```
8.2. Correctness. We argue that the bars computed by the zigzag algorithm described above compute the barcode (Definition 7.6 ) of the Conley-Morse persistence module M given by the transition diagram TD with the underlying poset P . For this, we argue that the interval modules I u supported on the paths u ∈ S that the algorithm computes also decompose M , that is, M ∼ = u ∈ S I u . Then,
```
  FIX: ```
8.2. Correctness. We argue that the bars computed by the zigzag algorithm described above compute the barcode (Definition 7.6) of the Conley-Morse persistence module \( M \) given by the transition diagram \( \text{TD} \) with the underlying poset \( P \). For this, we argue that the interval modules \( I_u \) supported on the paths \( u \in S \) that the algorithm computes also decompose \( M \), that is, \( M \cong \bigoplus_{u \in S} I_u \). Then,
```
