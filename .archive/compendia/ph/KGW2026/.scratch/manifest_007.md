# Manifest: Page 007

## REPAIR_MATH
- RAW: ```
\partial ( e _ { i _ { 0 } i _ { 1 } , \cdots i _ { p } } ) = \sum _ { j = 0 } ^ { p } \xi ^ { j } e _ { i _ { 0 } \cdots i _ { j } \cdots i _ { p } } ,
```
  FIX: ```
$$
\partial ( e _ { i _ { 0 } i _ { 1 } , \cdots i _ { p } } ) = \sum _ { j = 0 } ^ { p } \xi ^ { j } e _ { i _ { 0 } \cdots i _ { j } \cdots i _ { p } } ,
$$
```
- RAW: ```
[ n ] _ { q } = \frac { ( 1 - q ) ^ { n } } { 1 - q } = 1 + q + \cdots + q ^ { n - 1 } ,
```
  FIX: ```
$$
[ n ] _ { q } = \frac { ( 1 - q ) ^ { n } } { 1 - q } = 1 + q + \cdots + q ^ { n - 1 } ,
$$
```
- RAW: ```
[ n ! ] _ { q } = [ 1 ] _ { q } [ 2 ] _ { q } \cdots [ n ] _ { q } = \sum _ { w \in S _ { n } } q ^ { \ell ( w ) } ,
```
  FIX: ```
$$
[ n ! ] _ { q } = [ 1 ] _ { q } [ 2 ] _ { q } \cdots [ n ] _ { q } = \sum _ { w \in S _ { n } } q ^ { \ell ( w ) } ,
$$
```
- RAW: ```
\partial ^ { r } = [ r ! ] _ { q } \sum _ { 1 \leq j _ { 1 } < \cdots < j _ { r } } \xi ^ { j _ { 1 } + \cdots + j _ { r } } \partial _ { j _ { 1 } } \cdots \partial _ { j _ { r } } ,
```
  FIX: ```
$$
\partial ^ { r } = [ r ! ] _ { q } \sum _ { 1 \leq j _ { 1 } < \cdots < j _ { r } } \xi ^ { j _ { 1 } + \cdots + j _ { r } } \partial _ { j _ { 1 } } \cdots \partial _ { j _ { r } } ,
$$
```
- RAW: ```
\partial ^ { N } = [ N ! ] _ { \xi } \sum _ { 1 \leq j _ { 1 } < \cdots < j _ { N } } \xi ^ { j _ { 1 } + \cdots + j _ { N } } \partial _ { j _ { 1 } } \cdots \partial _ { j _ { N } } .
```
  FIX: ```
$$
\partial ^ { N } = [ N ! ] _ { \xi } \sum _ { 1 \leq j _ { 1 } < \cdots < j _ { N } } \xi ^ { j _ { 1 } + \cdots + j _ { N } } \partial _ { j _ { 1 } } \cdots \partial _ { j _ { N } } .
$$
```
- RAW: ```
[ N ] _ { \xi } = 1 + \xi + \dots + \xi ^ { N - 1 } = 0 .
```
  FIX: ```
$$
[ N ] _ { \xi } = 1 + \xi + \dots + \xi ^ { N - 1 } = 0 .
$$
```
- RAW: ```
[ N ! ] _ { \xi } = [ 1 ] _ { \xi } [ 2 ] _ { \xi } \cdots [ N ] _ { \xi } = 0 .
```
  FIX: ```
$$
[ N ! ] _ { \xi } = [ 1 ] _ { \xi } [ 2 ] _ { \xi } \cdots [ N ] _ { \xi } = 0 .
$$
```
- RAW: ```
\partial ^ { N } = 0 .
```
  FIX: ```
$$
\partial ^ { N } = 0 .
$$
```
- RAW: ```
\mathcal { A } _ { n } = \mathcal { A } _ { n } ( P ) = \text {span} \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { n } } \, | \, i _ { 0 } i _ { 1 } \cdots i _ { n } \in P \} .
```
  FIX: ```
$$
\mathcal { A } _ { n } = \mathcal { A } _ { n } ( P ) = \text {span} \{ e _ { i _ { 0 } i _ { 1 } \cdots i _ { n } } \, | \, i _ { 0 } i _ { 1 } \cdots i _ { n } \in P \} .
$$
```

## REPAIR_PROSE
- RAW: `Hence For example, We compute`
  FIX: `Hence, we compute`

## REPAIR_MATH
- RAW: `In this section, we introduce Mayer Path Homology. For any n ∈ Z ≥ 0 , let Λ p = Λ p ( V ) be the K -linear space spanned by all elementary p -paths with coefficients in the field K . Throughout this paper, we take K = C . Elementary p -paths are denoted by e i 0 ··· i p .`
  FIX: `In this section, we introduce Mayer Path Homology. For any \( n \in \mathbb{Z}_{\geq 0} \), let \( \Lambda_{p} = \Lambda_{p}(V) \) be the \( K \)-linear space spanned by all elementary \( p \)-paths with coefficients in the field \( K \). Throughout this paper, we take \( K = \mathbb{C} \). Elementary \( p \)-paths are denoted by \( e_{i_{0}\cdots i_{p}} \).`
- RAW: `Definition 6. Define the boundary operator ∂ : Λ p → Λ p − 1 by`
  FIX: `Definition 6. Define the boundary operator \( \partial : \Lambda_{p} \to \Lambda_{p-1} \) by`
- RAW: `where ξ is an N -th root of unity and e i 0 ··· ˆ i j ··· i p denotes the path obtained by omitting the j -th index.`
  FIX: `where \( \xi \) is an \( N \)-th root of unity and \( e_{i_{0}\cdots \hat{i}_{j}\cdots i_{p}} \) denotes the path obtained by omitting the \( j \)-th index.`
- RAW: `In [11], the q -analogues of the basic numbers and basic factorials for any q ∈ C are defined by`
  FIX: `In [11], the \( q \)-analogues of the basic numbers and basic factorials for any \( q \in \mathbb{C} \) are defined by`
- RAW: `where ℓ ( w ) denotes the length of the permutation w ∈ S n . By [11, Lemma 0.3], for each r ≥ 1 one has r j + + j`
  FIX: `where \( \ell(w) \) denotes the length of the permutation \( w \in S_{n} \). By [11, Lemma 0.3], for each \( r \geq 1 \) one has`
- RAW: `where ∂ i is the operator obtained by deleting the i -th index and ∂ = n i q i ∂ i .`
  FIX: `where \( \partial_{i} \) is the operator obtained by deleting the \( i \)-th index and \( \partial = \sum_{i} q^{i} \partial_{i} \).`
- RAW: `Lemma 3.1. (Λ ∗ ,∂ ) forms an N -chain complex, where Λ ∗ = { Λ p } p ∈ N .`
  FIX: `Lemma 3.1. \( (\Lambda_{\ast}, \partial) \) forms an \( N \)-chain complex, where \( \Lambda_{\ast} = \{ \Lambda_{p} \}_{p \in \mathbb{N}} \).`
- RAW: `Proof. Taking r = N and q = ξ in the above formula gives where ξ is the N th root of unity`
  FIX: `Proof. Taking \( r = N \) and \( q = \xi \) in the above formula gives where \( \xi \) is the \( N \)-th root of unity`
- RAW: `Since ξ is a primitive N -th root of unity, we have`
  FIX: `Since \( \xi \) is a primitive \( N \)-th root of unity, we have`
- RAW: `We again distinguish between the regular and non-regular subspaces of Λ p . The boundary operator ∂ will be taken as the regular boundary map, as explained in the section on Path Homology.`
  FIX: `We again distinguish between the regular and non-regular subspaces of \( \Lambda_{p} \). The boundary operator \( \partial \) will be taken as the regular boundary map, as explained in the section on Path Homology.`
- RAW: `For a given path complex P , define the C -linear space A n as the span of all elementary n -paths from P :`
  FIX: `For a given path complex \( P \), define the \( \mathbb{C} \)-linear space \( \mathcal{A}_{n} \) as the span of all elementary \( n \)-paths from \( P \):`
