# Manifest: Page 002

## REPAIR_MATH
- RAW: ```
\mathcal { X } \colon \ \mathbb { X } _ { 1 } \leftrightarrow \mathbb { X } _ { 2 } \leftrightarrow \cdots \leftrightarrow \mathbb { X } _ { n - 1 } \leftrightarrow \mathbb { X } _ { n }
```
  FIX: ```
$$
\mathcal { X } \colon \ \mathbb { X } _ { 1 } \leftrightarrow \mathbb { X } _ { 2 } \leftrightarrow \cdots \leftrightarrow \mathbb { X } _ { n - 1 } \leftrightarrow \mathbb { X } _ { n }
$$
```
- RAW: ```
H _ { p } ( \mathcal { X } ) \colon \ H _ { p } ( \mathbb { X } _ { 1 } ) \leftrightarrow H _ { p } ( \mathbb { X } _ { 2 } ) \leftrightarrow \dots \leftrightarrow H _ { p } ( \mathbb { X } _ { n - 1 } ) \leftrightarrow H _ { p } ( \mathbb { X } _ { n } )
```
  FIX: ```
$$
H _ { p } ( \mathcal { X } ) \colon \ H _ { p } ( \mathbb { X } _ { 1 } ) \leftrightarrow H _ { p } ( \mathbb { X } _ { 2 } ) \leftrightarrow \dots \leftrightarrow H _ { p } ( \mathbb { X } _ { n - 1 } ) \leftrightarrow H _ { p } ( \mathbb { X } _ { n } )
$$
```
- RAW: ```
\mathcal { I } _ { [ b , d ] } \colon \ I _ { 1 } \leftrightarrow I _ { 2 } \leftrightarrow \cdots \leftrightarrow I _ { n }
```
  FIX: ```
$$
\mathcal { I } _ { [ b , d ] } \colon \ I _ { 1 } \leftrightarrow I _ { 2 } \leftrightarrow \cdots \leftrightarrow I _ { n }
$$
```
- RAW: ```
\text {Pers} _ { p } ( \mathcal { X } ) = \{ [ b _ { j } , d _ { j } ] \, | \, j \in J \} \quad \Leftrightarrow \quad \text {H} _ { p } ( \mathcal { X } ) \cong \bigoplus _ { j \in J } \mathcal { I } _ { [ b _ { j } , d _ { j } ] } \quad \text {al} _ { \substack { \text {the} \\ \text {the} } }
```
  FIX: ```
$$
\text {Pers} _ { p } ( \mathcal { X } ) = \{ [ b _ { j } , d _ { j } ] \, | \, j \in J \} \quad \Leftrightarrow \quad \text {H} _ { p } ( \mathcal { X } ) \cong \bigoplus _ { j \in J } \mathcal { I } _ { [ b _ { j } , d _ { j } ] } \quad \text {al} _ { \substack { \text {the} \\ \text {the} } }
$$
```

## DELETE
- RAW: ```
For

:

∈ { X

, . . . , X

,

}



-








[

]

[

]

,


,








[

]

[

]

,


,





For

:

∈ { V

,

, . . . , X

}










[

]

[

]

,


,








[

]

[

]


,

,

Exceptional case:










+

[

]

[

]


,



,


Otherwise:






[

]

[

]

,

,
```
  FIX: ```
```

## REPAIR_PROSE
- RAW: `where each X i is a topological space and each ↔ represents a continuous function oriented forwards X i → X i +1 or backwards X i ← X i +1 . If we apply a homology functor H p with coeﬃcients in a ﬁeld k to such a diagram, we get a zigzag diagram of vector spaces, also called a zigzag module :`
  FIX: `where each \( \mathbb{X}_i \) is a topological space and each \( \leftrightarrow \) represents a continuous function oriented forwards \( \mathbb{X}_i \to \mathbb{X}_{i+1} \) or backwards \( \mathbb{X}_i \leftarrow \mathbb{X}_{i+1} \). If we apply a homology functor \( H_p \) with coefficients in a field \( k \) to such a diagram, we get a zigzag diagram of vector spaces, also called a zigzag module:`

- RAW: `The structure of a zigzag module can be analyzed using linear algebra, in particular the theory of quiver representations. The resulting linear algebra description of H p ( X ) can then be regarded as a homological invariant of the original diagram X . We call this zigzag persistence [3]. n − 1`
  FIX: `The structure of a zigzag module can be analyzed using linear algebra, in particular the theory of quiver representations. The resulting linear algebra description of \( H_p(\mathcal{X}) \) can then be regarded as a homological invariant of the original diagram \( \mathcal{X} \). We call this zigzag persistence [3].`

- RAW: `We now describe the structure theorem. There are 2 choices of orientation for the maps in a zigzag module with n terms. The modules of each type form an abelian category: morphisms, kernels, images, cokernels, and direct sums are deﬁned in a natural way. A theorem of Gabriel [12] implies that every ﬁnite-dimensional zigzag module can be decomposed as a direct sum of interval modules . These are modules of the following form:`
  FIX: `We now describe the structure theorem. There are \( 2^{n-1} \) choices of orientation for the maps in a zigzag module with \( n \) terms. The modules of each type form an abelian category: morphisms, kernels, images, cokernels, and direct sums are defined in a natural way. A theorem of Gabriel [12] implies that every finite-dimensional zigzag module can be decomposed as a direct sum of interval modules. These are modules of the following form:`

- RAW: `where I i = k for b ≤ i ≤ d , and I i = 0 otherwise; and every k → k or k ← k is the identity map. Moreover, the list of summands is unique up to reordering. We refer to [3] for a thorough account of this theorem from our present perspective, including general techniques for computing the summands of a zigzag module and some guidance towards the appropriate intuitions for this theory.`
  FIX: `where \( I_i = k \) for \( b \leq i \leq d \), and \( I_i = 0 \) otherwise; and every \( k \to k \) or \( k \leftarrow k \) is the identity map. Moreover, the list of summands is unique up to reordering. We refer to [3] for a thorough account of this theorem from our present perspective, including general techniques for computing the summands of a zigzag module and some guidance towards the appropriate intuitions for this theory.`

- RAW: `The zigzag persistent homology of X in dimension p is deﬁned to be the (multi-)set of intervals [ b, d ] corresponding to the list of interval summands I [ b,d ] of H p ( X ). In other words`
  FIX: `The zigzag persistent homology of \( \mathcal{X} \) in dimension \( p \) is defined to be the (multi-)set of intervals \( [b, d] \) corresponding to the list of interval summands \( \mathcal{I}_{[b,d]} \) of \( H_p(\mathcal{X}) \). In other words`

- RAW: `The total persistence Pers( X ) of the zigzag diagram X is the collection of multisets Pers p ( X ), taken over all p .`
  FIX: `The total persistence \( \text{Pers}(\mathcal{X}) \) of the zigzag diagram \( \mathcal{X} \) is the collection of multisets \( \text{Pers}_p(\mathcal{X}) \), taken over all \( p \).`

- RAW: `Each interval [ b, d ] is thought of as a persistent feature of X which is manifested from X b to X d inclusive. It is convenient notation to write [ X b , X d ] instead of [ b, d ] when describing the intervals in Pers p ( X ). This is particularly helpful when we work with diagrams of spaces which are not naturally indexed by { 1 , 2 , . . . , n } . We will occasionally introduce other shorthand when studying zigzag diagrams which encode changes occuring at critical transition values a i ∈ R . The standard theory of persistence [11, 16] is the spe-`
  FIX: `Each interval \( [b, d] \) is thought of as a persistent feature of \( \mathcal{X} \) which is manifested from \( \mathbb{X}_b \) to \( \mathbb{X}_d \) inclusive. It is convenient notation to write \( [\mathbb{X}_b, \mathbb{X}_d] \) instead of \( [b, d] \) when describing the intervals in \( \text{Pers}_p(\mathcal{X}) \). This is particularly helpful when we work with diagrams of spaces which are not naturally indexed by \( \{1, 2, \dots, n\} \). We will occasionally introduce other shorthand when studying zigzag diagrams which encode changes occuring at critical transition values \( a_i \in \mathbb{R} \). The standard theory of persistence [11, 16] is the spe-`

- RAW: `cial case where all the maps point forwards. In this case the linear algebra is particularly transparent, because persistence modules can be thought of as graded modules over the polynomial ring k [ t ]. An important warning: it is usual in standard persistence to denote the decomposition summands by open intervals [ X b , X d +1 ) rather than closed intervals [ X b , X d ]. This may cause some confusion to the unwary reader.`
  FIX: `cial case where all the maps point forwards. In this case the linear algebra is particularly transparent, because persistence modules can be thought of as graded modules over the polynomial ring \( k[t] \). An important warning: it is usual in standard persistence to denote the decomposition summands by open intervals \( [\mathbb{X}_b, \mathbb{X}_{d+1}) \) rather than closed intervals \( [\mathbb{X}_b, \mathbb{X}_d] \). This may cause some confusion to the unwary reader.`

- RAW: `Consider the diagram in Figure 1. This contains two obvious zigzag diagrams of length n : the union diagram X ∪ which passes through U ∪ V , and the intersection diagram X ∩ which passes through U ∩ V .`
  FIX: `Consider the diagram in Figure 1. This contains two obvious zigzag diagrams of length \( n \): the union diagram \( \mathcal{X}_\cup \) which passes through \( U \cup V \), and the intersection diagram \( \mathcal{X}_\cap \) which passes through \( U \cap V \).`

- RAW: `Mayer–Vietoris Diamond Principle . There exists a bijection Pers( X ∩ ) ↔ Pers( X ∪ ) which transforms intervals according to the following rules:`
  FIX: `Mayer–Vietoris Diamond Principle. There exists a bijection \( \text{Pers}(\mathcal{X}_\cap) \leftrightarrow \text{Pers}(\mathcal{X}_\cup) \) which transforms intervals according to the following rules:`

- RAW: `The superscript + in the exceptional case indicates a dimension shift: [ U ∩ V , U ∩ V ] in Pers p ( X ∩ ) is paired with [ U ∪ V , U ∪ V ] in Pers p +1 ( X ∪ ). Otherwise, the bijection respects homological dimension.`
  FIX: `The superscript \( + \) in the exceptional case indicates a dimension shift: \( [U \cap V, U \cap V] \) in \( \text{Pers}_p(\mathcal{X}_\cap) \) is paired with \( [U \cup V, U \cup V] \) in \( \text{Pers}_{p+1}(\mathcal{X}_\cup) \). Otherwise, the bijection respects homological dimension.`

- RAW: `A proof of the Diamond Principle can be found in [3]. For intuition the reader may wish to consider the simplest situation, where the conﬁguration consists of the diamond alone. For instance, the exceptional bijection corresponds to the fact that the cokernel of H p +1 ( U ) ⊕ H p +1 ( V ) → H p +1 ( U ∪`
  FIX: `A proof of the Diamond Principle can be found in [3]. For intuition the reader may wish to consider the simplest situation, where the configuration consists of the diamond alone. For instance, the exceptional bijection corresponds to the fact that the cokernel of \( H_{p+1}(U) \oplus H_{p+1}(V) \to H_{p+1}(U \cup \)`
