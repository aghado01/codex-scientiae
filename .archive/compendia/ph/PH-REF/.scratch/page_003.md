[Page 3]

death


![In this image there is a graph.](<PH-REF/imageFile1.png>)




















birth





Figure 1. The persistence barcode and the persistence diagram of a function f : [0 , 1] → R .

( a 3 ) Similarly, when r reaches a 3 , a new connected component appears and persistent homology creates a new interval starting at a 3 .

( a 4 ) When r reaches a 4 , the two connected components created at a 1 and a 3 merges together to give a single larger component. At this step, persistent homology follows the rule that this is the most recently appeared component in the ﬁltration that dies: the interval started at a 3 is thus ended at a 4 and a ﬁrst persistence interval encoding the lifespan of the component born at a 3 is created.

( a 5 ) When r reaches a 5 , as in the previous case, the component born at a 2 dies and the persistent interval ( a 2 ,a 5 ) is created.

( a 6 ) The interval created at a 1 remains until the end of the ﬁltration giving rise to the persistent interval ( a 1 ,a 6 ) if the ﬁltration is stopped at a 6 , or ( a 1 , + ∞ ) if r goes to + ∞ (notice that in this later case, the ﬁltration remains constant for r > a 6 ).

The obtained set of intervals encoding the span life of the diﬀerent homological features encountered along the ﬁltration is called the persistence barcode of f . Each interval ( a,a ) can be represented by the point of coordinates ( a,a ) in R 2 plane. The resulting set of points is called the persistence diagram of f . Notice that a function may have several copies of the same interval in its persistence barcode. As a consequence, the persistence diagram of f is indeed a multi-set where each point has an integer valued multiplicity. Last, for technical reasons that will become clear in the next section, one adds to the persistence all the points of the diagonal ∆ = { ( b,d ) : b = d } with an inﬁnite multiplicity.

Example 2.2 (Surface in Space) . Let now f : M → R be the function of Figure 2 where M is a 2-dimensional surface homeomorphic to a torus, and let ( F r = f − 1 (( −∞ ,r ])) r ∈ R be the sublevel set ﬁltration of f . The 0dimensional persistent homology is computed as in the previous example, giving rise to the red bars in the barcode. Now, the sublevel sets also carry 1-dimensional homological features.

( a 1 ) When r goes through the height a 1 , the sublevel sets F r that were homeomorphic to two discs become homeomorphic to the disjoint union of a disc and an annulus, creating a ﬁrst cycle homologous to σ 1 on Figure
