[Page 7]

First, we merge all adjacent nodes in \( V_{split} \) into a single node. If multiple nodes in \( V_{split} \) are mutually adjacent, we simultaneously merge them into a single node in \( G \). For brevity, we continue to denote the modified graph and the set of nodes to be split as \( G \) and \( V_{split} \), respectively.

Next, for each node \( v_i \) in \( V_{split} \), we use \( f^{\perp} \) instead of \( f \) in the Mapper algorithm in section 4.1.1 to obtain the Mapper graph \( G_i \) for \( X_i \).

node \( v_i \) and one of its neighboring nodes \( v_j \) may be assigned to multiple nodes in \( G_i \). In such cases, directly replacing \( v_i \) with all nodes from \( G_i \) may introduce redundant edges in the modified graph, as shown in Fig. 4. Therefore, we iterate through each neighboring node \( v_j \) of \( v_i \) and merge all nodes in graph \( G_i \) that share common points with \( v_j \) into a single node. Subsequently, we modify \( G \) by replacing \( v_i \) with all nodes in \( G_i \).

Finally, we add new edges to modified graph \( G \) between nodes following the Mapper edge addition rule, i.e. edges exist if the intersection of the point sets corresponding to two nodes is non-empty.

ation. Specifically, the nodes in the lowest connected subgraph of \( G \) are merged into a single node. Fig. 3(f) shows the final modified Mapper graph. Compared to the initial Mapper graph in Fig. 3(d), the modified Mapper graph contains more nodes in the orthogonal direction, thereby better reflecting the structure of the input point set \( X \).

# 4.2. Partition of intersection set based on the Mapper graph

Using the two-step Mapper algorithm, we can generate the Mapper graph \( G \) of the intersection point set \( P_{1,u,v} \). Next, we partition \( P_{1,u,v} \) based on the characteristic nodes of the Mapper graph.

We define two types of characteristic nodes in the Mapper graph: boundary nodes and singular nodes. They correspond respectively to the boundary points and singular points of the intersection point set.

\( B_1(u,v) \in [u_s, u_e] \times [v_s, v_e] \). A boundary point is an intersection point on the boundary lines:

$$
l = \left \{ ( u , v ) \in \mathbb { R } ^ { 2 } \, | \, u = u _ { s } \, o r \, u = u _ { e } \, o r \, v = v _ { s } \, o r \, v = v _ { e } \right \} \quad \text {recurs} \\
$$

Due to the overestimation property of the subdivision method, we need to perform dilation on the boundary point set. Specifically, we regard the points with a distance less than the clustering parameter \( \delta \) to the boundary lines as the approximate boundary point set:

$$
P _ { b } = \{ ( u , v ) \in P _ { 1 , u , v } \ | \ u < u _ { s } + \delta , \text { or } u > s _ { e } - \delta , \\ \text { or } v < v _ { s } + \delta , \text { or } v > v _ { e } - \delta \} \ \ ( 1 2 )
$$

Then we define a node \( v_{bou} \) as a boundary node if its corresponding point set intersects with the approximate boundary point set \( P_b \).

A singular point is a point where the curve does not have a unique tangent. For the intersection of two B-spline surfaces, such points are typically located within the cross-type regions of the intersection point set. These cross-type regions correspond to nodes with a degree greater than 2 in graph \( G \). Therefore, we define a node \( v_{sin} \) in the Mapper graph \( G \) with a degree greater than 2 as a singular node. Then, we remove all boundary nodes and singular nodes from the Mapper graph \( G \).

Finally, we partition \( P_{1,u,v} \) based on the connection relationships between nodes in \( G \). Specifically, we group all nodes in \( G \) that are connected by a walk—i.e., nodes forming a connected component of \( G \)—into one group. The point sets corresponding to these nodes form a subset of \( P_{1,u,v} \). In this way, we partition \( P_{1,u,v} \) into several subsets. Since each connected component of the modified graph \( G \) is either a path, a cycle, or an isolated node, where,

- Each path corresponds to a simple open curve segment in the intersection set;
- Each cycle corresponds to a simple closed curve segment;


- Each isolated node corresponds to an isolated intersection point.

Thus, through such grouping, we can partition \( P_{1,u,v} \) into several simple segments. Fig. 5 illustrates the process of intersection set partition based on the Mapper graph.

In Fig. 5(c), yellow and blue circles mark boundary nodes and singular nodes, respectively. After removing these two types of characteristic nodes, the Mapper graph shown in Fig. 5(d) contains four connected components. Based on this, we can partition the intersection set \( P_{1,u,v} \) into four mutually exclusive subsets and visualize each subset using distinct colors in Fig. 5(e).

# 4.3. Correspondence between different parameter domains.

Unlike algebraic methods, subdivision methods inherently preserve correspondence between intersection results across different surface parameter domains. Specifically, the subdivision method obtains intersection point sets by recursively detecting bounding box intersections in different parameter domains. In the resulting set \( P_{1,u,v} \), each point’s correspondence to points in \( P_{2,s,t} \) is determined by the intersection relationships between their respective bounding boxes. Fig. 5(f) illustrates the corresponding result for \( P_{2,s,t} \), where matching partitioned subsets between \( P_{1,u,v} \) and \( P_{2,s,t} \) are colored identically.

# 5. Experiments and discussions

All experiments in this paper were implemented on a PC with a Intel Core Ultra 7 155H 3.80GHz CPU and 32GB RAM. We use python’s Giotto-tda library [ Tauzin, Lupo, Tunstall, Pérez, Caorsi, Medina-Mardones, Dassatti,
