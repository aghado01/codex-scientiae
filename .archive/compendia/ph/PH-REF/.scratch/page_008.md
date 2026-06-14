[Page 8]

“the” persistence diagram dgm(Filt) of the ﬁltration Filt. This notation has to be understood as “dgm k (Filt) for some k ”.

## 4. Metrics on the Space of Persistence Diagrams

To exploit the topological information and topological features inferred from persistent homology, one needs to be able to compare persistence diagrams, i.e. to endow the space of persistence diagrams with a metric structure. Although several metrics can be considered, the most fundamental one is known as the bottleneck distance .

Recall that a persistence diagram is the union of a discrete multi-set in the half-plane above the diagonal ∆ and, for technical reasons that will become clear below, of ∆ where the point of ∆ are counted with inﬁnite multiplicity.

Deﬁnition 4.1 (Matching) . A matching between two diagrams dgm 1 and dgm 2 is a subset m ⊂ dgm 1 × dgm 2 such that every points in dgm 1 \ ∆ and dgm 2 \ ∆ appears exactly once in m .

In other words, for any p ∈ dgm 1 \ ∆, and for any q ∈ dgm 2 \ ∆, ( { p } × dgm 2 ) ∩ m and (dgm 1 ×{ q } ) ∩ m each contains a single pair, see Figure 4.

Deﬁnition 4.2 (Bottleneck Distance) . The bottleneck distance between dgm 1 and dgm 2 is then deﬁned by

$$
d _ { b } ( d g m _ { 1 } , d g m _ { 2 } ) = \inf _ { \ m a t h i n g { \ m } \left ( p , q \right ) \in m } \max _ { \ } \left \| p - q \right \| _ { \infty } .
$$

![The image presents a graph with two sets of points. The graph is titled d and has a legend in the top right corner. The legend indicates that the points are labeled as follows: - **d(gdm,dgm2)** - **d(gdm,dgm3)** - **d(gdm,dgm4)** The graph is labeled as d and has a scale of range 0 to 100. The x-axis is labeled d and the y-axis is labeled d(gdm,dgm2). The graph shows a trend of increasing values of the function d as the x-axis increases. The points are scattered around the x-axis, with some points closer to the x-axis and others farther away. The graph also includes a scale labeled b with a value of 0 to 100. The](<PH-REF/imageFile7.png>)


=




(dgm

,dgm

)





Figure 4. A perfect matching and the bottleneck distance between a blue and a red diagram. Notice that some points of both diagrams are matched to points of the diagonal.
