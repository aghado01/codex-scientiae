[Page 4]

![image 9](<SIFTS/imageFile9.png>)

c c c




Theorem 2. For every p and every ( p + 1) -chain c , ∂ p ( ∂ p +1 c ) = 0 .

Deﬁnition 19. A p -boundary-cycle is a p -cycle that is also the boundary of some ( p + 1) -chain.

Let B p = ∂ p +1 C p +1 , namely all the p -boundary-cycles. B p are the uninteresting rubber bands. In the example above, B 1 = { 0 ,c 1 } , none surrounding any holes. It is easy to see that B p is a group, therefore a subgroup of Z p (all rubber bands).

Are there “interesting rubber bands”? In other words, do we have anything in Z p besides B p ? It depends on the structure of the simplicial complex. In the example above, the 1 -cycles c 2 and c 3 (red) are not in B 1 since the rectangle does not contain any 2 -simplices. These are interesting because they surround the hole in the rectangle. In fact, we can drag the rubber band c 2 over the yellow triangle and turn it into c 3 . Formally, we do this by c 3 = c 2 + c 1 . Intuitively, c 2 and c 3 are equivalent in the hole they surround. More generally, such equivalence class is obtained by c + B p : we are allowed to drag a p -cycle rubber band c over any ( p + 1) -simplices without changing the holes (or the lack thereof) it surrounds.

Returning to the example, we now see all the 1-cycles for this simplicial complex: Z 1 = { 0 ,c 1 ,c 2 ,c 3 } . The uninteresting ones are B 1 = { 0 ,c 1 } , a subgroup of Z 1 . The interesting ones are c 2 + B 1 = c 3 + B 1 = { c 2 ,c 3 } : this should remind us of cosets and quotient group.

Deﬁnition 20. The p -th homology group is the quotient group H p = Z p /B p . The p -th Betti number is its rank: β p = rank( H p ) .

We have arrived at the core of homology. In our example, H 1 = { 0 ,c 1 ,c 2 ,c 3 } / { 0 ,c 1 } which is isomorphic to Z 2 . The ﬁrst Betti number is β 1 = rank( Z 2 ) = 1 , indicating one independent 1st-order hole not ﬁlled in by triangles.

In general, β p is the number of independent p -th holes. For example, a tetrahedron has β 0 = 1 since the shape is connected, β 1 = β 2 = 0 since there is no holes or voids. A hollow tetrahedron has β 0 = 1 ,β 1 = 0 ,β 2 = 1 because of the void. Further removing the four triangle faces but keeping the six edges, the skeleton has β 0 = 1 , β 1 = 3 (there are 4 triangular holes but one is the sum of the other three), β 2 = 0 (no more void). Finally removing the edges but keeping the four vertices, β 0 = 4 (4 connected components each a single vertex) and β 1 = β 2 = 0 .

## 2.3 Persistent Homology

Usually we are given data as a point cloud x 1 ,...,x n ∈ R d . Where does the simplicial complex come from in the ﬁrst place? One way to create it is to examine all subsets of points. If any subset of p + 1 points are “close enough,” we add a p simplex σ with those points as vertices to the complex:

Deﬁnition 21. A Vietoris-Rips complex of diameter   is the simplicial complex V R (   ) = { σ | diam( σ ) ≤   } .

Here diam( σ ) is the largest distance between two points in σ . Note if σ ∈ V R ( ) , all its faces are, too. The following ﬁgure shows four points (0,0), (0,1), (2,1), (2,0) and the VietorisRips complex with different . V R ( √ 5) is a ﬂat tetrahedron.

![image 10](<SIFTS/imageFile10.png>)

VR(1)

VR(2)

VR( 5)

A natural question is what best to use for any data set. Persistent homology examines all ’s to see how the system of holes change.

Deﬁnition 22. An increasing sequence of produces a ﬁltration , i.e., a sequence of increasing simplicial complexes V R ( 1 ) ⊆ V R ( 2 ) ⊆ ... , with the property that a simplex enters the sequence no earlier than all its faces.

Persistent homology tracks homology classes along the ﬁltration: at what value of does a hole appear, and how long does it persist till it is ﬁlled in? A convenient way to visualize persistent homology is the barcode plot shown below. The x -axis is . Each horizontal bar represents the birth–death of a separate homology class. Longer bars correspond to more robust topological structure in the data.

![image 11](<SIFTS/imageFile11.png>)

barcode (dimension 0)


0.5


1.5 1)


2.5

barcode (dimension 1)


0.5


1.5


2.5

The top panel shows H 0 (0-th order holes or clusters). At = 0 there are four bars for the four disconnected vertices in V R (0) . The Betti number at any given is the number of bars above it, in this case β 0 = 4 . At = 1 two edges appear in V R (1) , reducing the number of connected components to two. This is why the top two bars die and β 0 reduces to 2. At = 2 , V R (2) forms a rectangle and becomes fully connected, so one more bar dies and β 0 = 1 thereafter. The remaining bar represents the one vertex that grabs everything to eventually become the fully connected component. It never dies (represented by the arrow at the end of the bar). We note that the clusters are precisely those obtained from hierarchical clustering with single-linkage.

The bottom panel shows H 1 (1st order holes). In the example above, a homology class corresponding to the hole is born at = 2 when the rectangle becomes connected. It persists until = √ 5 and dies because the Vietoris-Rips complex becomes the solid tetrahedron. This is represented by the single short bar. The Betti number is β 1 = 1 in the interval [2 , √ 5) and 0 otherwise.

## 3 A Natural Language Processing Application

We all have the intuition that some documents tell a straight story while others twist and turn. We hope persistent homology captures such structures. We assume that a document has been divided into small units x 1 ,...,x n . We are given a distance function D ( x i ,x j ) ≥ 0 so that similar units have small
