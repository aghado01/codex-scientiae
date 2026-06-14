[Page 10]

![The image shows a geometric figure with four squares. Each square has four vertices, and each vertex has a line connecting it to the other vertices. The four squares are arranged in a square grid. Here is a detailed description of the image: 1. **Squares**: - Each square has four vertices. - The vertices of each square are labeled as follows: - A (top-left) - B (top-right) - C (top-center) - D (bottom-left) - E (bottom-center) - F (bottom-right) 2. **Squares and Lines**: - Each square has four lines connecting its vertices. - The lines are labeled as follows: - Line A: Line segment from A to A - Line B: Line segment from B to B - Line C: Line segment from C to C - Line D: Line segment from D to D -](<DLST2026/imageFile5.png>)


Figure 6. Combinatorial analogue of a Hopf bifurcation. The left panel represents the top view of the octahedron in Figure 4 , similarly, the middle and right panel show projections of multivector fields V 0 and V 1 .

2.3. Homological signature of a bifurcation. Another motivation for the development of the Conley-Morse persistence barcodes is the classification of bifurcations. Consider two 1-dimensional flows, φ λ and ψ λ parameterized by λ , as illustrated in the upper panels of Figure 7 . Each vertical line through the plot represents a 1-dimensional flow on the real line. Red and green segments denote repelling and attracting equilibria, respectively. Note that, pointwise—for a fixed λ —both dynamical systems are qualitatively the same:

- for λ < − 1 and λ > 1 they have a single attracting equilibrium;
- for λ ∈ ( − 1 , 1)—two attracting and one repelling equilibrium in between;
- for λ ∈ {− 1 , 1 } —an attracting equilibrium and one degenerate equilibrium.


However, the corresponding Conley-Morse persistence barcodes presented in Figure 7 (bottom) capture the difference in the nature of the two bifurcations. Thus, the Conley-Morse persistence barcode can be regarded as an algebraic signature of a bifurcation.

Figure 8 presents minimalist combinatorial models for both bifurcations. Again, we encourage the reader to revisit the examples in Figures 6 and 8 after going through Section 4 .

# 3. Preliminaries

- 3.1. Sets. A Z -interval I is an intersection of an interval in R with Z . We say that a Z -interval I is right-bounded if I admits a maximal element, otherwise I is rightinfinite . Similarly, if I has a minimal element, then it is left-bounded ; otherwise, it is left-infinite . We denote bounded Z -intervals by [ n,m ] Z : = { n,n + 1 ,...,m } . Let A and B be families of subsets of X . Then we say that A is inscribed in B if for every A ∈ A there exists B ∈ B such that A ⊂ B . We denote this relation by writing A ⊑ B .
- 3.2. Digraphs. A pair G = ( V,E ) is called a directed graph (or digraph ), where V is the set of vertices and relation E ⊂ V × V is the collection of edges. A
