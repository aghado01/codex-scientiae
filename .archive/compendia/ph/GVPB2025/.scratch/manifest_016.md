# Manifest: Page 016

## REPAIR_MATH
- RAW: ```
\chi \colon \mathbb { X } _ { 1 } \longleftrightarrow \mathbb { X } _ { 2 } \longleftrightarrow \cdots \longleftrightarrow \mathbb { X } _ { n } ,
```
  FIX: ```
$$
\chi \colon \mathbb { X } _ { 1 } \longleftrightarrow \mathbb { X } _ { 2 } \longleftrightarrow \cdots \longleftrightarrow \mathbb { X } _ { n } ,
$$
```
- RAW: ```
H _ { p } ( \chi ) \colon H _ { p } ( \mathbb { X } _ { 1 } ) \longleftrightarrow H _ { p } ( \mathbb { X } _ { 2 } ) \longleftrightarrow \cdots \longleftrightarrow H _ { p } ( \mathbb { X } _ { n } ) .
```
  FIX: ```
$$
H _ { p } ( \chi ) \colon H _ { p } ( \mathbb { X } _ { 1 } ) \longleftrightarrow H _ { p } ( \mathbb { X } _ { 2 } ) \longleftrightarrow \cdots \longleftrightarrow H _ { p } ( \mathbb { X } _ { n } ) .
$$
```
- RAW: ```
\mathcal { I } _ { [ b , d ] } \colon I _ { 1 } \longleftrightarrow I _ { 2 } \longleftrightarrow \cdots \longleftrightarrow I _ { n } ,
```
  FIX: ```
$$
\mathcal { I } _ { [ b , d ] } \colon I _ { 1 } \longleftrightarrow I _ { 2 } \longleftrightarrow \cdots \longleftrightarrow I _ { n } ,
$$
```
- RAW: ```
P e r _ { p } ( \chi ) = \{ [ b _ { j } , d _ { j } ] \colon j \in J \} \Longleftrightarrow H _ { p } ( \chi ) \cong \bigoplus _ { j \in J } \mathcal { I } _ { [ b _ { j } , d _ { j } ] }
```
  FIX: ```
$$
P e r _ { p } ( \chi ) = \{ [ b _ { j } , d _ { j } ] \colon j \in J \} \Longleftrightarrow H _ { p } ( \chi ) \cong \bigoplus _ { j \in J } \mathcal { I } _ { [ b _ { j } , d _ { j } ] }
$$
```
- RAW: ```
\hat { b } & = \begin{cases} b + 1 & \text {if $b$ is an intersection layer} \\ b & \text {otherwise} \end{cases} , \\ \hat { d } & = \begin{cases} d + 1 & \text {if $d$ is an intersection layer} \\ d & \text {otherwise} \end{cases}
```
  FIX: ```
$$
\hat { b } & = \begin{cases} b + 1 & \text {if $b$ is an intersection layer} \\ b & \text {otherwise} \end{cases} , \\ \hat { d } & = \begin{cases} d + 1 & \text {if $d$ is an intersection layer} \\ d & \text {otherwise} \end{cases}
$$
```
- RAW: ```
where each X i is a topological space and each arrow ←→ represents a continuous function pointing forwards X i −→ X i +1 or backwards X i ←− X i +1 .
```
  FIX: ```
where each \( X_i \) is a topological space and each arrow \( \longleftrightarrow \) represents a continuous function pointing forwards \( X_i \longrightarrow X_{i+1} \) or backwards \( X_i \longleftarrow X_{i+1} \).
```
- RAW: ```
If we apply a homology functor H p with coefficients in a field k to such a filtration, we get a zigzag filtration of k -vector spaces, called zigzag module :
```
  FIX: ```
If we apply a homology functor \( H_p \) with coefficients in a field \( k \) to such a filtration, we get a zigzag filtration of \( k \)-vector spaces, called zigzag module :
```
- RAW: ```
It is proven in [31] that the algebraic classification of zigzag modules resembles Gabriel’s classification of the persistence module described in [77]. In particular, every finite-dimensional zigzag module, i.e. for which all the k -vector spaces in the sequence that are finite-dimensional, can be decomposed as a direct sum of interval modules, where a (finitely indexed) interval module is a module of the form:
```
  FIX: ```
It is proven in [31] that the algebraic classification of zigzag modules resembles Gabriel’s classification of the persistence module described in [77]. In particular, every finite-dimensional zigzag module, i.e. for which all the \( k \)-vector spaces in the sequence that are finite-dimensional, can be decomposed as a direct sum of interval modules, where a (finitely indexed) interval module is a module of the form:
```
- RAW: ```
where I i = k for b ≤ i ≤ d , and I i = 0 otherwise, and every arrow of the form k ←− k or k −→ k is the identity map. Moreover, the list of summands is unique up to reordering.
```
  FIX: ```
where \( I_i = k \) for \( b \leq i \leq d \), and \( I_i = 0 \) otherwise, and every arrow of the form \( k \longleftarrow k \) or \( k \longrightarrow k \) is the identity map. Moreover, the list of summands is unique up to reordering.
```
- RAW: ```
The zigzag persistence diagram of a filtration χ in dimension p is the multiset of intervals [ b,d ] corresponding to the list of interval summands I [ b,d ] of H p ( χ ) . In other words,
```
  FIX: ```
The zigzag persistence diagram of a filtration \( \chi \) in dimension \( p \) is the multiset of intervals \( [b, d] \) corresponding to the list of interval summands \( \mathcal{I}_{[b, d]} \) of \( H_p(\chi) \). In other words,
```
- RAW: ```
In our approach, the use of intersection layers is essential for computing zigzag persistence, as it allows the construction of injective maps between the k NN complexes of model layers (see equation 2) 14 . Since our primary goal is to analyze the topological changes between model layers, we eliminate the construction of intersection layers while preserving the topological features by shifting each persistence interval such that the birth and death times occur strictly within the layers.
```
  FIX: ```
In our approach, the use of intersection layers is essential for computing zigzag persistence, as it allows the construction of injective maps between the \( k \)-NN complexes of model layers (see equation 2)$^{14}$. Since our primary goal is to analyze the topological changes between model layers, we eliminate the construction of intersection layers while preserving the topological features by shifting each persistence interval such that the birth and death times occur strictly within the layers.
```
- RAW: ```
For an interval [ b,d ] in the zigzag persistence diagram of dimension p of filtration 2, the mapping that enables a bijective transformation to a new interval [ ˆ b, ˆ d ] 15 only across model layers is defined as follows:
```
  FIX: ```
For an interval \( [b, d] \) in the zigzag persistence diagram of dimension \( p \) of filtration 2, the mapping that enables a bijective transformation to a new interval \( [\hat{b}, \hat{d}] \)$^{15}$ only across model layers is defined as follows:
```
- RAW: ```
The relationship between the persistence image and the effective persistence image for p -dimensional holes, denoted respectively by PI p and PI p , where b,d are the model layers indexed by even numbers, is described by the following
```
  FIX: ```
The relationship between the persistence image and the effective persistence image for \( p \)-dimensional holes, denoted respectively by \( PI_p \) and \( \widehat{PI}_p \), where \( b, d \) are the model layers indexed by even numbers, is described by the following
```

## REPAIR_PROSE
- RAW: ```
Each interval [ b,d ] is called persistence interval and is thought of as a persistent homological feature of χ that appears at time b (referred to as the ”birth”) and disappears at time d (referred to as the ”death 13 ”).
```
  FIX: ```
Each interval \( [b, d] \) is called persistence interval and is thought of as a persistent homological feature of \( \chi \) that appears at time \( b \) (referred to as the ”birth”) and disappears at time \( d \) (referred to as the ”death”$^{13}$).
```
- RAW: ```
13 In our setting we say a p -dimensional holes “dies”, we mean that the corresponding homology class no longer persists in subsequent layers. In the zigzag filtration, this happens when the hole is no longer represented by an independent equivalence class in the homology group. 14
```
  FIX: ```
$^{13}$ In our setting we say a \( p \)-dimensional holes “dies”, we mean that the corresponding homology class no longer persists in subsequent layers. In the zigzag filtration, this happens when the hole is no longer represented by an independent equivalence class in the homology group.
```
- RAW: ```
An alternative method for constructing these maps and obtaining the zigzag persistence diagram is to use a filtration where, instead of intersections, the union of the complexes from two consecutive layers is considered. However, the Diamond Lemma, as discussed in [32], guarantees that both the intersectionand union-based filtrations encode the same homological information. 15
```
  FIX: ```
$^{14}$ An alternative method for constructing these maps and obtaining the zigzag persistence diagram is to use a filtration where, instead of intersections, the union of the complexes from two consecutive layers is considered. However, the Diamond Lemma, as discussed in [32], guarantees that both the intersection and union-based filtrations encode the same homological information.
```
- RAW: ```
By construction, all resulting intervals contain even numbers, as the model layers are indexed with these numbers.
```
  FIX: ```
$^{15}$ By construction, all resulting intervals contain even numbers, as the model layers are indexed with these numbers.
```


