[Page 6]

![The image depicts a graph with two main axes: the x-axis and the y-axis. The x-axis is labeled as x and the y-axis is labeled as y. The graph is a line graph, with a single point at the end of the y-axis. The line is drawn from the point (0, 0) to the point (1, 1). The line is colored in blue and red. The points on the graph are connected by lines, and the line extends from the point (0, 0) to the point (1, 1).](<GLL2026/imageFile4.png>)

Fig. 4: An illustration of additional cross-graph edges introduced by independent subdivision of adjacent Mapper nodes. Top: data elements corresponding to two adjacent nodes, where node-specific elements are shown in red and blue, and their shared elements are shown in green. Middle: the corresponding two adjacent Mapper nodes and their connecting edge. Bottom: Mapper subgraphs generated independently from the two nodes. Due to inconsistent partitioning of shared elements, the edge addition rule based on whether corresponding element sets intersect introduced additional cross-graph edges (green dashed lines).

Since the number of intervals 𝑆 and the interval length 𝑙 satisfy,

$$
S l - ( S - 1 ) \theta _ { o v } l = \sup _ { x _ { i } \in X } f ( x _ { i } ) - i n f \, f ( x _ { i } ) , \quad \ \ ( 9 ) \quad \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
$$

To ensure condition ( 8 ), we compute the number of intervals 𝑆 as

$$
S = \left \lfloor \frac { \sup _ { x _ { i } \in X } f ( x _ { i } ) - \inf _ { x _ { i } \in X } f ( x _ { i } ) - \theta _ { o v } l ^ { \prime } } { ( 1 - \theta _ { o v } ) l ^ { \prime } } \right \rfloor , \quad ( 1 0 ) \quad v _ { i } \ \ w i d g r a l { ( 1 0 ) } \quad v _ { i } \ \ w i d g r a l { ( 1 0 ) }
$$

⎢ ⎣ ⎥ ⎦ where ⌊ ⋅ ⌋ denotes the floor operator and 𝑙 ′ = (1 + 𝛼 ) 𝑙 0 . In this paper, we set 𝛼 = 0 . 001 to ensure 𝑙 ′ > 𝑙 0 . Fig. 3 illustrates an example of constructing the initial

Mapper graph 𝐺 . To better reflect the practical setting considered in this paper, we uniformly sample points from severalplanarcurvesusingafixedarc-length step size 𝑠𝑎𝑚𝑝𝑙𝑒 = 0 . 02 and add random offset noise with magnitude in the range [0 , 0 . 01] to each sampled point, yielding the point cloud 𝑋 . According to the parameter selection criterion in Eq. ( 6 ), we therefore set

$$
\delta = 4 \left ( \epsilon + \frac { s a m p l e } { 2 } \right )
$$

in this example.

Wethen compute the centroid and the principal direction of 𝑋 using PCA, and evaluate the filter function 𝑓 accordingly. In Fig. 3(b), the points in 𝑋 are colored according to their corresponding filter function values. The black dashed line indicates the line segment passing through the centroid of 𝑋 and aligned with its principal direction. In Fig. 3(c), we employ 46 intervals to uniformly cover the range of the filter function 𝑓 . Finally, Fig. 3(d) presents the resulting initial Mapper graph constructed from these settings.

# 4.1.2. Subdivision in the orthogonal direction

In Fig. 3(c) , the points sampled from the middle curve segment in the example exhibit a very narrow range of values under the filter function 𝑓 . As a result, these points are assigned to the same interval, and are consequently aggregated into a single node in the Mapper graph, as indicated by the dashed box. Such aggregation weakens the ability of the Mapper graph to capture the geometric structure of the underlying data. To handle this issue, we analyze the initial Mapper graph

𝐺 in the direction orthogonal to the principal direction vector 𝑤 𝑝 in Eq. ( 4 ). The core idea is to use the Mapper algorithm to split nodes with excessively large projection spans in the orthogonal direction into smaller nodes. Let be the unit vector orthogonal to the principal

𝑤 ⟂ direction vector 𝑤 𝑝 , i.e. ⟨ 𝑤 ⟂ , 𝑤 𝑝 ⟩ = 0 . We define a new filter function 𝑓 ⟂ as the projection of the data point 𝑥 onto 𝑤 ⟂ as follows:

$$
f _ { \perp } ( x ) = \langle x _ { i } - x _ { c } , \, w _ { \perp } \rangle
$$

⟨ ⟩ where 𝑥 𝑐 is the center of 𝑋 calculated by Eq. ( 2 ). Let denote the set of points corresponding

𝑋 𝑖 to each node 𝑣 𝑖 in 𝐺 . In Eq. ( 8 ) and ( 10 ) , we substitute 𝑓 ⟂ for 𝑓 and 𝑋 𝑖 for 𝑋 to compute the number of intervals 𝑆 𝑖 that 𝑋 𝑖 can partition in the orthogonal direction. We denote the set of nodes awaiting splitting as =

𝑉 𝑠𝑝𝑙𝑖𝑡 { 𝑣 ∈ 𝐺,𝑆 𝑖 ≥ 2} . The straightforward idea is to use 𝑓 ⟂ instead of 𝑓 in the Mapper algorithm for each node 𝑣 in 𝑉 𝑠𝑝𝑙𝑖𝑡 , obtaining the subgraph 𝐺 𝑖 and replace each such 𝑣 𝑖 with all nodes in 𝐺 𝑖 and add edges between different subgraph nodes based on the intersection relationships of corresponding clusters to achieve subdivision. However, if two adjacent nodes both require to be subdi-

vided, this method may introduce additional edges because the classification results for elements in their overlapping region might differ across their subgraphs. However, when two adjacent nodes in the Mapper graph are both subject to subdivision, this strategy may introduce additional edges. The reason is that elements lying in the overlapping region of the two nodes may be classified differently in their respective subdivided subgraphs. Fig. 4 provides an illustrative example. The two original

nodes share a common subset of 𝑋 . However,these elements is separated into different clusters during the generation of the Mapper subgraph. Consequently, additional cross-graph edges are introduced. Therefore, to achieve effective subdivision while avoid-

ing the generation of additional edges, we designed the following process for handling 𝑉 𝑠𝑝𝑙𝑖𝑡 .
