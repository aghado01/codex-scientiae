[Page 6]

## 3. Persistent Modules and Persistence Diagrams

Persistent diagrams can be formally and rigorously deﬁned in a purely algebraic way. This requires some care and we only give here the basic necessary notions, leaving aside technical subtleties and diﬃculties.

Deﬁnition 3.1 (Persistence Module) . A persistence module V over a subset T ⊂ R of the real numbers is an indexed family of vector spaces ( V r | r ∈ T ) and a doubly-indexed family of linear maps ( v r s : V r → V s | r   s ) which satisfy the composition law v s t ◦ v r s = v r t whenever r   s   t , and where v r r is the identity map on V r .

Example 3.2. Let Filt = ( F r ) r ∈ T be a ﬁltration of a simplicial complex or a topological space. Given an integer k 0 and considering the homology groups H k ( F r ) we obtain a family of vector spaces, and the inclusions i r s : F r → F s ,for r s , induce linear maps ( i r s ) ∗ : H k ( F r ) → H k ( F s ) at the homology level. Furthermore, these maps satisfy ( i r t ) ∗ = ( i s t ◦ i r s ) ∗ = ( i s t ) ∗ ◦ ( i r s ) ∗ for all r s t .

In many cases, a persistence module can be decomposed into a direct sum of intervals modules I ( b,d ) of the form

$$
\cdots \to 0 \to \cdots \to 0 \to \mathbb { Z } _ { 2 } \to \cdots \to \mathbb { Z } _ { 2 } \to 0 \to \cdots
$$

where the maps Z 2 → Z 2 are identity maps while all the other maps are 0. Denoting b (resp. d ) the inﬁmum (resp. supremum) of the interval of indices corresponding to non zero vector spaces, such a module can be interpreted as a feature that appears in the ﬁltration at index b and disappear at index d . When a persistence module V can be decomposed as a direct sum of interval modules, one can show that this decomposition is unique up to reordering the intervals (see [CdSGO16, Theorem 2.7]). As a consequence, the set of resulting intervals is independent of the decomposition of V and is called the persistence barcode of V .

Remark 3.3. As in the examples of the previous section, each interval ( b,d ) in the barcode can be represented as the point of coordinates ( b,d ) in the plane R 2 . The disjoint union of these points, together with the diagonal ∆ = { b = d } is a multi-set called the persistence diagram of V .

The following result gives suﬃcient conditions for a persistence module to be decomposable as a direct sum of interval modules.

Theorem 3.4 . Let V be a persistence module indexed by T ⊂ R . If T is a ﬁnite set or if all the vector spaces V r are ﬁnite-dimensional, then V is decomposable as a direct sum of interval modules.

$$
P r o f . \, S e e \, [ C d S G O 1 6 , \, Theorem \, 2 . 8 ] .
$$

As both conditions above are satisﬁed for the persistent homology of ﬁltrations of ﬁnite simplicial complexes, an immediate consequence of this result is that the persistence diagrams of such ﬁltrations are always welldeﬁned.

Unfortunately, Theorem 3.4 is not suﬃcient for our purposes of general data analysis. Indeed, there exist compact sets whose oﬀsets do not induce pointwise ﬁnite-dimensional persistence modules, such as X = { 0 } ∪ n 1
