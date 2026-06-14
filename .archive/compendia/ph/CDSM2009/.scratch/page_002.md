[Page 2]

Our chief contributions are:

• levelset zigzag persistent homology, which solves the problem of finding a local, symmetric interval description for a real-valued function,

- • a Pyramid Theorem , which is a powerful extension of the Mayer–Vietoris theorem to levelset zigzag persistent homology,
- • an efficient concrete algorithm to compute zigzag persistent homology.


Together with a connection between a certain kind of (levelset) zigzag and extended persistence [7], these results allow us to:

- • derive an alternative intuition and interpretation of extended persistence,
- • resolve the open question about symmetry of extended persistence on non-manifold domains,
- • use the algorithm for zigzag persistent homology to compute extended persistence; such computation uses less space and can be distributed across multiple processors.


# 2. ZIGZAG PERSISTENCE

A zigzag diagram of topological spaces is a sequence

$$
$$
\mathcal { X } \colon \ \mathbb { X } _ { 1 } \leftrightarrow \mathbb { X } _ { 2 } \leftrightarrow \cdots \leftrightarrow \mathbb { X } _ { n - 1 } \leftrightarrow \mathbb { X } _ { n }
$$
$$

where each X i is a topological space and each ↔ represents a continuous function oriented forwards X i → X i +1 or backwards X i ← X i +1 . If we apply a homology functor H p with coefficients in a field k to such a diagram, we get a zigzag diagram of vector spaces, also called a zigzag module :

$$
$$
H _ { p } ( \mathcal { X } ) \colon \ H _ { p } ( \mathbb { X } _ { 1 } ) \leftrightarrow H _ { p } ( \mathbb { X } _ { 2 } ) \leftrightarrow \dots \leftrightarrow H _ { p } ( \mathbb { X } _ { n - 1 } ) \leftrightarrow H _ { p } ( \mathbb { X } _ { n } )
$$
$$

The structure of a zigzag module can be analyzed using linear algebra, in particular the theory of quiver representations. The resulting linear algebra description of H p ( X ) can then be regarded as a homological invariant of the original diagram X . We call this zigzag persistence [3]. n − 1

We now describe the structure theorem. There are 2 choices of orientation for the maps in a zigzag module with n terms. The modules of each type form an abelian category: morphisms, kernels, images, cokernels, and direct sums are defined in a natural way. A theorem of Gabriel [12] implies that every finite-dimensional zigzag module can be decomposed as a direct sum of interval modules . These are modules of the following form:

$$
$$
\mathcal { I } _ { [ b , d ] } \colon \ I _ { 1 } \leftrightarrow I _ { 2 } \leftrightarrow \cdots \leftrightarrow I _ { n }
$$
$$

where I i = k for b ≤ i ≤ d , and I i = 0 otherwise; and every k → k or k ← k is the identity map. Moreover, the list of summands is unique up to reordering. We refer to [3] for a thorough account of this theorem from our present perspective, including general techniques for computing the summands of a zigzag module and some guidance towards the appropriate intuitions for this theory.

The zigzag persistent homology of X in dimension p is defined to be the (multi-)set of intervals [ b, d ] corresponding to the list of interval summands I [ b,d ] of H p ( X ). In other words

$$
$$
\text {Pers} _ { p } ( \mathcal { X } ) = \{ [ b _ { j } , d _ { j } ] \, | \, j \in J \} \quad \Leftrightarrow \quad \text {H} _ { p } ( \mathcal { X } ) \cong \bigoplus _ { j \in J } \mathcal { I } _ { [ b _ { j } , d _ { j } ] } \quad \text {al} _ { \substack { \text {the} \\ \text {the} } }
$$
$$

The total persistence Pers( X ) of the zigzag diagram X is the collection of multisets Pers p ( X ), taken over all p .

Each interval [ b, d ] is thought of as a persistent feature of X which is manifested from X b to X d inclusive. It is convenient notation to write [ X b , X d ] instead of [ b, d ] when describing the intervals in Pers p ( X ). This is particularly helpful when we work with diagrams of spaces which are not naturally indexed by { 1 , 2 , . . . , n } . We will occasionally introduce other shorthand when studying zigzag diagrams which encode changes occuring at critical transition values a i ∈ R . The standard theory of persistence [11, 16] is the spe-

cial case where all the maps point forwards. In this case the linear algebra is particularly transparent, because persistence modules can be thought of as graded modules over the polynomial ring k [ t ]. An important warning: it is usual in standard persistence to denote the decomposition summands by open intervals [ X b , X d +1 ) rather than closed intervals [ X b , X d ]. This may cause some confusion to the unwary reader.

Mayer–Vietoris diamonds. Our most important mathematical tool is the Diamond Principle, which relates the persistence intervals of two zigzag diagrams which differ by a single local change.

Consider the diagram in Figure 1. This contains two obvious zigzag diagrams of length n : the union diagram X ∪ which passes through U ∪ V , and the intersection diagram X ∩ which passes through U ∩ V .

Mayer–Vietoris Diamond Principle . There exists a bijection Pers( X ∩ ) ↔ Pers( X ∪ ) which transforms intervals according to the following rules:





![In this image, we can see a diagram.](<CDSM2009/imageFile1.png>)

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

The superscript + in the exceptional case indicates a dimension shift: [ U ∩ V , U ∩ V ] in Pers p ( X ∩ ) is paired with [ U ∪ V , U ∪ V ] in Pers p +1 ( X ∪ ). Otherwise, the bijection respects homological dimension.

A proof of the Diamond Principle can be found in [3]. For intuition the reader may wish to consider the simplest situation, where the configuration consists of the diamond alone. For instance, the exceptional bijection corresponds to the fact that the cokernel of H p +1 ( U ) ⊕ H p +1 ( V ) → H p +1 ( U ∪
