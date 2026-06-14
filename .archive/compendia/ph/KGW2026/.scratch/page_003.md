[Page 3]

One of the key limitations of Mayer homology is its dependence on the choice of triangulation or simplicial complex, which may not be canonical for a given dataset or graph. In contrast, path complexes associated to directed graphs offer a canonical and combinatorially intrinsic construction, where the underlying structure is determined directly by the directed paths of the graph. As such, the combination of Mayer homology and path homology can remove the ambiguity of Mayer homology, providing a canonical invariant of a given directed graph, rather than of an underlying topological space.

By combining these two frameworks, we obtain Mayer path homology, which incorporates the higher-order algebraic flexibility of Mayer homology, given by the N -nilpotent differential d N = 0, together with the direction-sensitive and canonical nature of path complexes. This allows us to study higher-order interactions in directed graphs without having to deal with arbitrary triangulations.

Furthermore, this combination enhances the ability to capture interdimensional relationships in digraphs. While path homology detects higher-dimensional structures arising from directed paths, Mayer homology provides additional layers of algebraic structure through the parameter q , enabling a more refined analysis of how these features interact.

It offers a unified framework that improves both the structural sensitivity and the interpretability of topological invariants for directed data.

In this work, we investigate the structure of 2and 3-simplices in Mayer path complexes and analyze their corresponding generators. In particular, we provide an explicit description of the generators of these spaces, going beyond existing results that establish only the existence of a basis. For standard path complexes, although there are known theorems guaranteeing the construction of a basis, a complete enumeration of all possible generator types is not available in the literature. We address this gap by giving a full classification of generators in low dimensions, which allows for a direct comparison between standard path homology and Mayer path homology. This explicit characterization is essential for verifying structural properties of Mayer path complexes, as the interaction between generators plays a crucial role in understanding the effect of the N -nilpotent differential. Consequently, our results provide a more detailed combinatorial and algebraic understanding of pathbased homology theories and lay the groundwork for further study of higher-dimensional structures and their persistence.

In Section 2, we briefly review Mayer homology and path homology to establish notations and facilitate our formulation. Section 3 is devoted to the theory of Mayer path homology. This paper ends with a conclusion.

# 2 Background

# 2.1 Mayer Homology

For this section, we consider a field K containing a primitive N -th root of unity, where N ≥ 2 is an integer. [15].

Definition 1. 1. An N -chain complex consists of a graded K -linear space C = ( C n ) n ≥ 0 , equipped with a linear map d : C n → C n -1 satisfying d N = 0 . The linear map d : C n → C n -1 is called an N -differential or N -boundary operator.
