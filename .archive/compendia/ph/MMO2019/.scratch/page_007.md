[Page 7]

Speciﬁcally, for data in R , we consider each feature as an element of

$$
\mathcal { W } _ { 0 \colon \mathbf d - 1 } = W \times \{ 0 , \dots , \mathbf d - 1 \} \, ,
$$

where W = ( b,d ) ∈ R 2 : d > b ≥ 0 is the inﬁnite wedge. As a topological space, the -fold multiwedge W 0: − 1 is treated as -disconnected copies of W , where W has the Euclidean metric and topology.

It is desirable to deﬁne a metric between persistence diagrams with which to measure topological similarity. In TDA, Hausdorﬀ distance is typically used to compare underlying datasets, while the bottleneck distance (Def. 5) is used to compare their associated persistence diagrams (Fasy et al., 2014; Munch, 2017). A distance that accounts for cardinality diﬀerences between persistence diagrams was introduced in (Marchese and Maroulas, 2018) and its stability with respect to perturbations in the underlying point cloud was proved in (Maroulas et al., 2018).

Deﬁnition 5 The bottleneck distance between two persistence diagrams D 1 and D 2 is given by

$$
W _ { \infty } ( D _ { 1 } , D _ { 2 } ) = \min _ { \gamma } \max _ { x \in D _ { 1 } } \| x - \gamma ( x ) \| _ { \infty } \, .
$$

where γ ranges over all possible bijections between D 1 and D 2 which match in degree of homology. The diagonal { b = d } is included in both persistence diagrams with inﬁnite multiplicity so that any feature may be matched to the diagonal.

Remark 6 Due to the unstable presence of features near the diagonal, typical metrics on persistence diagrams such as the bottleneck distance treat the diagonal as part of every persistence diagram (Mileyko et al., 2011) in order to achieve stability with respect to Hausdorﬀ perturbations of the underlying dataset (Cohen-Steiner et al., 2007). Morally, one considers the diagonal as representing vacuous features which are born and die simultaneously. For convenient computation, the deﬁnition of bottleneck distance can be applied to each degree of homology separately.

## 3. Random Persistence Diagrams

In this section we establish background to make the notion of probability density for a random persistence diagram explicit and well-deﬁned. A persistence diagram changes its feature cardinality under small perturbation of the underlying dataset, and these features have no intrinsic order. Consequently, we cannot treat persistence diagrams as elements of a vector space. Instead, we consider a random persistence diagram D as a random multiset of features D = { ξ i } ⊂ W 0: − 1 in the multiwedge deﬁned in Eq. (2.1). For underlying datasets sampled from R with bounded cardinality, the aﬃliated ˇ Cech persistence diagrams also have bounded feature cardinality and degree of homology. Thus, we assume that the cardinality of a random persistence diagram is bounded above by some value | D | ≤ M ∈ N , and so consider the space C ≤ M ( W 0: − 1 ) = { D multiset in W 0: − 1 : | D | ≤ M } . We view C ≤ M ( W 0: − 1 ) through a list of functions h N which each map the appropriate dimension of Euclidean space into its corresponding cardinality component, C N ( W 0: − 1 ). This viewpoint facilitates the deﬁnition of probability densities.

Deﬁnition 7 For each N ∈ { 0 ,...,M } , consider the space of N topological features, denoted C N ( W 0: − 1 ) = { D multiset in W 0: − 1 : | D | = N } , and the associated map h N : W N 0: − 1 → C N ( W 0: − 1 ) deﬁned by

$$
h _ { N } ( \xi _ { 1 } , \dots , \xi _ { N } ) = \{ \xi _ { 1 } , \dots , \xi _ { N } \} \, .
$$
