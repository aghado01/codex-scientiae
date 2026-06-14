[Page 9]

Define N 0 as the blue ring and N 2 as the brown disc in the left panel of Figure 5 . Let N 1 be the union of N 0 and the light brown disc in the right panel. In particular, we have N 0 ⊂ N 1 ⊂ N 2 .

As discussed earlier, R in λ = 0 continues to the invariant disc at λ = 1that is, the union of E , O and the trajectories connecting them—because both sets are isolated by a common isolating block N 2 . With N 1 and N 0 , we can decompose the Conley index of R as follows. First, observe that B E : = cl( N 1 \ N 0 ), B O : = cl( N 2 \ N 1 ), and B R : = cl( N 2 \ N 0 ) are isolating blocks for E , O , and R , respectively. However, we can compute the Conley index directly using N 0 , N 1 and N 2 . By the excision property, we have H ( N 2 ,N 0 ) ∼ = H ( B R ,B − R ); similarly, H ( N 1 ,N 0 ) ∼ = H ( B E ,B − E ) and H ( N 2 ,N 1 ) ∼ = H ( B O ,B − O ) for B E and B O . In fact, these pairs form so-called index pairs —we will discuss their combinatorial analogues in Section 4.3 . They induce the following diagram that we call the attractor-repeller split diagram (or AR-split diagram ):

$$
\[
\begin{aligned}
H ( N _ { 2 } , N _ { 0 } ) & \longrightarrow H ( N _ { 2 } , N _ { 1 } ) & [ 0 , 0 , k ] & \stackrel { [ 0 , 0 , I d ] } { \longrightarrow } [ 0 , k , k ] \\ 
& \stackrel { \longmapsto } { \sim } \stackrel { \uparrow } { \stackrel { \longmapsto } { I } } & \cong & \stackrel { \longmapsto } { \stackrel { \uparrow } { \longrightarrow } } & \stackrel { \uparrow } { \stackrel { \longmapsto } { I } } \\ 
& \stackrel { H ( N _ { 1 } , N _ { 0 } ) } { \longrightarrow } & [ k , 0 , 0 ]
\end{aligned}
\tag{2.1}
\]
$$

where the homomorphisms are induced by inclusions. These maps relate Conley index generators of isolated invariant sets before and after bifurcation. The diagram on the right shows concrete vector spaces and maps for the example. In particular, we see that the degree-2 generator of R is mapped into the Conley index of O .

The basic split theorem introduced in Section 5.2 (Theorem 5.12 ) provides additional insight. For instance, property (b) of that theorem states that whenever an isolated invariant set splits, no Conley index generator is lost—in other words, through a decomposition, every generator of a bifurcating set is “passed on” to one of the newly created sets. Property (c) states that new generators are always born (or die) in pairs of codimension 1. Both properties are illustrated in diagram ( 2.1 ): first, because the degree-2 generator is mapped from R to O ; second, two new generators, of degree-0 and 1, are born together during the split.

Figure 6 shows a combinatorial version of that bifurcation. In particular, it is the top view of the octahedron in Figure 4 , where point e corresponds to the vertex at the north pole. The combinatorial counterparts of N 0 , N 1 and N 2 are

$$
\[
\begin{aligned}
N_0 &\coloneqq \{ a, b, c, d, ab, bc, cd, ad \}, \\
N_1 &\coloneqq N_0 \cup \{ e \}, \\
N_2 &\coloneqq N_1 \cup \{ ae, be, ce, de, abe, bce, cde, ade \}.
\end{aligned}
\]
$$

One can verify that the combinatorial AR-split diagram is identical, in terms of homology groups, to diagram ( 2.1 ). Moreover, E = N 1 \ N 0 , R = N 2 \ N 0 , and O = N 2 \ N 1 are combinatorial isolating blocks (see Definition 4.2 ) for the corresponding combinatorial isolated invariant sets.
