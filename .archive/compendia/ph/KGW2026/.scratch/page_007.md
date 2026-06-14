[Page 7]

# 3 Mayer Path Homology

In this section, we introduce Mayer Path Homology. For any n ∈ Z ≥ 0 , let Λ p = Λ p ( V ) be the K -linear space spanned by all elementary p -paths with coefficients in the field K . Throughout this paper, we take K = C . Elementary p -paths are denoted by e i 0 ··· i p .

Definition 6. Define the boundary operator ∂ : Λ p → Λ p − 1 by

$$
\partial ( e _ { i _ { 0 } i _ { 1 } , \cdots i _ { p } } ) = \sum _ { j = 0 } ^ { p } \xi ^ { j } e _ { i _ { 0 } \cdots i _ { j } \cdots i _ { p } } ,
$$

where ξ is an N -th root of unity and e i 0 ··· ˆ i j ··· i p denotes the path obtained by omitting the j -th index.

In [11], the q -analogues of the basic numbers and basic factorials for any q ∈ C are defined by

$$
[ n ] _ { q } = \frac { ( 1 - q ) ^ { n } } { 1 - q } = 1 + q + \cdots + q ^ { n - 1 } ,
$$

and

$$
[ n ! ] _ { q } = [ 1 ] _ { q } [ 2 ] _ { q } \cdots [ n ] _ { q } = \sum _ { w \in S _ { n } } q ^ { \ell ( w ) } ,
$$

where ℓ ( w ) denotes the length of the permutation w ∈ S n . By [11, Lemma 0.3], for each r ≥ 1 one has r j + + j

$$
\partial ^ { r } = [ r ! ] _ { q } \sum _ { 1 \leq j _ { 1 } < \cdots < j _ { r } } \xi ^ { j _ { 1 } + \cdots + j _ { r } } \partial _ { j _ { 1 } } \cdots \partial _ { j _ { r } } ,
$$

where ∂ i is the operator obtained by deleting the i -th index and ∂ = n i q i ∂ i .

Lemma 3.1. (Λ ∗ ,∂ ) forms an N -chain complex, where Λ ∗ = { Λ p } p ∈ N .

Proof. Taking r = N and q = ξ in the above formula gives where ξ is the N th root of unity

$$
\partial ^ { N } = [ N ! ] _ { \xi } \sum _ { 1 \leq j _ { 1 } < \cdots < j _ { N } } \xi ^ { j _ { 1 } + \cdots + j _ { N } } \partial _ { j _ { 1 } } \cdots \partial _ { j _ { N } } .
$$

Since ξ is a primitive N -th root of unity, we have

$$
[ N ] _ { \xi } = 1 + \xi + \dots + \xi ^ { N - 1 } = 0 .
$$

Therefore,

Hence For example, We compute

$$
[ N ! ] _ { \xi } = [ 1 ] _ { \xi } [ 2 ] _ { \xi } \cdots [ N ] _ { \xi } = 0 .
$$

$$
\partial ^ { N } = 0 .
$$

We again distinguish between the regular and non-regular subspaces of Λ p . The boundary operator ∂ will be taken as the regular boundary map, as explained in the section on Path Homology.

For a given path complex P , define the C -linear space A n as the span of all elementary n -paths from P :

$$
\mathcal { A } _ { n } = \mathcal { A } _ { n } ( P ) = \text {span} \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { n } } \, | \, i _ { 0 } i _ { 1 } \cdots i _ { n } \in P \} .
$$
