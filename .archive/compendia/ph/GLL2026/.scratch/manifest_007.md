# Manifest: Page 007

## REPAIR_MATH
- RAW: ```
l = \left \{ ( u , v ) \in \mathbb { R } ^ { 2 } \, | \, u = u _ { s } \, o r \, u = u _ { e } \, o r \, v = v _ { s } \, o r \, v = v _ { e } \right \} \quad \text {recurs} \\
```
  FIX: ```
$$
l = \left \{ ( u , v ) \in \mathbb { R } ^ { 2 } \, | \, u = u _ { s } \, o r \, u = u _ { e } \, o r \, v = v _ { s } \, o r \, v = v _ { e } \right \} \quad \text {recurs} \\
$$
```
- RAW: ```
P _ { b } = \{ ( u , v ) \in P _ { 1 , u , v } \ | \ u < u _ { s } + \delta , \text { or } u > s _ { e } - \delta , \\ \text { or } v < v _ { s } + \delta , \text { or } v > v _ { e } - \delta \} \ \ ( 1 2 )
```
  FIX: ```
$$
P _ { b } = \{ ( u , v ) \in P _ { 1 , u , v } \ | \ u < u _ { s } + \delta , \text { or } u > s _ { e } - \delta , \\ \text { or } v < v _ { s } + \delta , \text { or } v > v _ { e } - \delta \} \ \ ( 1 2 )
$$
```

## REPLACE_TABLES
None

## REPAIR_PROSE
- RAW: ```
First, we merge all adjacent nodes in 𝑉 𝑠𝑝𝑙𝑖𝑡 into a single node. If multiple nodes in 𝑉 𝑠𝑝𝑙𝑖𝑡 are mutually adjacent, we simultaneously merge them into a single node in 𝐺 . For brevity, we continue to denote the modified graph and the set of nodes to be split as 𝐺 and 𝑉 𝑠𝑝𝑙𝑖𝑡 , respectively. Next, for each node in , we use instead of in

Next, for each node 𝑣 𝑖 in 𝑉 𝑠𝑝𝑙𝑖𝑡 , we use 𝑓 ⟂ instead of 𝑓 in the Mapper algorithm in section 4.1.1 to obtain the Mapper graph 𝐺𝑖 for 𝑋𝑖 .
```
  FIX: ```
First, we merge all adjacent nodes in \( V_{split} \) into a single node. If multiple nodes in \( V_{split} \) are mutually adjacent, we simultaneously merge them into a single node in \( G \). For brevity, we continue to denote the modified graph and the set of nodes to be split as \( G \) and \( V_{split} \), respectively.

Next, for each node \( v_i \) in \( V_{split} \), we use \( f^{\perp} \) instead of \( f \) in the Mapper algorithm in section 4.1.1 to obtain the Mapper graph \( G_i \) for \( X_i \).
```

- RAW: ```
node 𝑣 𝑖 and one of its neighboring nodes 𝑣 𝑗 may be assigned to multiple nodes in 𝐺 𝑖 . In such cases, directly replacing 𝑣 𝑖 with all nodes from 𝐺 𝑖 may introduce redundant edges in the modified graph,as shown in Fig. 4 . Therefore, we iterate through each neighboring node 𝑣 𝑗 of 𝑣 𝑖 and merge all nodes in graph 𝐺 𝑖 that share common points with 𝑣 𝑗 into a single node. Subsequently, we modify 𝐺 by replacing 𝑣 𝑖 with all nodes in 𝐺 𝑖 . Finally, we add new edges to modified graph between

Finally, we add new edges to modified graph 𝐺 between nodes following the Mapper edge addition rule , i. e. edges exist if the intersection of the point sets corresponding to two nodes is non-empty.
```
  FIX: ```
node \( v_i \) and one of its neighboring nodes \( v_j \) may be assigned to multiple nodes in \( G_i \). In such cases, directly replacing \( v_i \) with all nodes from \( G_i \) may introduce redundant edges in the modified graph, as shown in Fig. 4. Therefore, we iterate through each neighboring node \( v_j \) of \( v_i \) and merge all nodes in graph \( G_i \) that share common points with \( v_j \) into a single node. Subsequently, we modify \( G \) by replacing \( v_i \) with all nodes in \( G_i \).

Finally, we add new edges to modified graph \( G \) between nodes following the Mapper edge addition rule, i.e. edges exist if the intersection of the point sets corresponding to two nodes is non-empty.
```

- RAW: ```
ation. Specifically, the nodes in the lowest connected subgraph of 𝐺 are merged into a single node. Fig. 3(f) shows the final modified Mapper graph. Compared to the initial Mapper graph in Fig. 3(d) , the modified Mapper graph contains more nodes in the orthogonal direction, thereby better reflecting the structure of the input point set 𝑋 .
```
  FIX: ```
ation. Specifically, the nodes in the lowest connected subgraph of \( G \) are merged into a single node. Fig. 3(f) shows the final modified Mapper graph. Compared to the initial Mapper graph in Fig. 3(d), the modified Mapper graph contains more nodes in the orthogonal direction, thereby better reflecting the structure of the input point set \( X \).
```

- RAW: ```
Using the two-step Mapper algorithm, we can generate the Mapper graph 𝐺 of the intersection point set 𝑃 1 ,𝑢,𝑣 . Next, we partition 𝑃 1 ,𝑢,𝑣 based on the characteristic nodes of the Mapper graph. We define two types of characteristic nodes in the Map-

We define two types of characteristic nodes in the Mapper graph: boundary nodes and singular nodes . They correspond respectively to the boundary points and singular points of the intersection point set.
```
  FIX: ```
Using the two-step Mapper algorithm, we can generate the Mapper graph \( G \) of the intersection point set \( P_{1,u,v} \). Next, we partition \( P_{1,u,v} \) based on the characteristic nodes of the Mapper graph.

We define two types of characteristic nodes in the Mapper graph: boundary nodes and singular nodes. They correspond respectively to the boundary points and singular points of the intersection point set.
```

- RAW: ```
𝐵 1 𝑢,𝑣 [ 𝑢 𝑠 ,𝑢 𝑒 ] × [ 𝑣 𝑠 ,𝑣 𝑒 ] . A boundary point is an intersection point on the boundary lines:
```
  FIX: ```
\( B_1(u,v) \in [u_s, u_e] \times [v_s, v_e] \). A boundary point is an intersection point on the boundary lines:
```

- RAW: ```
{ } Duetotheoverestimationpropertyofthesubdivisionmethod, we need to perform dilation on the boundary point set. Specifically, we regard the points with a distance less than the clustering parameter 𝛿 to the boundary lines as the approximate boundary point set:
```
  FIX: ```
Due to the overestimation property of the subdivision method, we need to perform dilation on the boundary point set. Specifically, we regard the points with a distance less than the clustering parameter \( \delta \) to the boundary lines as the approximate boundary point set:
```

- RAW: ```
Then we define a node 𝑣 𝑏𝑜𝑢 as a boundary node if its corresponding point set intersects with the approximate boundary point set 𝑃 𝑏 .
```
  FIX: ```
Then we define a node \( v_{bou} \) as a boundary node if its corresponding point set intersects with the approximate boundary point set \( P_b \).
```

- RAW: ```
A singular point is a point where the curve does not have a unique tangent. For the intersection of two B-spline surfaces, such points are typically located within the crosstype regions of the intersection point set. These cross-type regions correspond to nodes with a degree greater than 2 in graph 𝐺 . Therefore, we define a node 𝑣 𝑠𝑖𝑛 in the Mapper graph 𝐺 with a degree greater than 2 as a singular node . Then, we remove all boundary nodes and singular nodes

from the Mapper graph 𝐺 . Finally, we partition 𝑃 1 ,𝑢,𝑣 based on the connection relationships between nodes in 𝐺 . Specifically, we group all nodes in 𝐺 that are connected by a walk—i.e., nodes forming a connected component of 𝐺 into one group. The point sets corresponding to these nodes form a subset of 𝑃 1 ,𝑢,𝑣 . In this way, we partition 𝑃 1 ,𝑢,𝑣 into several subsets. Since each connected component of the modified graph 𝐺 is either a path, a cycle, or an isolated node, where,
```
  FIX: ```
A singular point is a point where the curve does not have a unique tangent. For the intersection of two B-spline surfaces, such points are typically located within the cross-type regions of the intersection point set. These cross-type regions correspond to nodes with a degree greater than 2 in graph \( G \). Therefore, we define a node \( v_{sin} \) in the Mapper graph \( G \) with a degree greater than 2 as a singular node. Then, we remove all boundary nodes and singular nodes from the Mapper graph \( G \).

Finally, we partition \( P_{1,u,v} \) based on the connection relationships between nodes in \( G \). Specifically, we group all nodes in \( G \) that are connected by a walk—i.e., nodes forming a connected component of \( G \)—into one group. The point sets corresponding to these nodes form a subset of \( P_{1,u,v} \). In this way, we partition \( P_{1,u,v} \) into several subsets. Since each connected component of the modified graph \( G \) is either a path, a cycle, or an isolated node, where,
```

- RAW: ```
Thus, through such grouping, we can partition 𝑃 1 ,𝑢,𝑣 into several simple segments. Fig. 5 illustrates the process of intersection set partition

based on the Mapper graph. In Fig. 5(c) , yellow and blue circles mark boundary nodes and singular nodes, respectively. After removing these two types of characteristic nodes, the Mapper graph shown in Fig. 5(d) contains four connected components. Based on this, we can partition the intersection set 𝑃 1 ,𝑢,𝑣 into four mutually exclusive subsets and visualize each subset using distinct colors in Fig. 5(e) .
```
  FIX: ```
Thus, through such grouping, we can partition \( P_{1,u,v} \) into several simple segments. Fig. 5 illustrates the process of intersection set partition based on the Mapper graph.

In Fig. 5(c), yellow and blue circles mark boundary nodes and singular nodes, respectively. After removing these two types of characteristic nodes, the Mapper graph shown in Fig. 5(d) contains four connected components. Based on this, we can partition the intersection set \( P_{1,u,v} \) into four mutually exclusive subsets and visualize each subset using distinct colors in Fig. 5(e).
```

- RAW: ```
Unlike algebraic methods, subdivision methods inherently preserve correspondence between intersection results across different surface parameter domains. Specifically, the subdivision method obtains intersection point sets by recursively detecting bounding box intersections in different parameter domains. In the resulting set 𝑃 1 ,𝑢,𝑣 , each point’s correspondence to points in 𝑃 2 ,𝑠,𝑡 is determined by the intersection relationships between their respective bounding boxes. Fig. 5(f) illustrates the corresponding result for ,

𝑃 2 ,𝑠,𝑡 where matching partitioned subsets between 𝑃 1 ,𝑢,𝑣 and 𝑃 2 ,𝑠,𝑡 are colored identically.
```
  FIX: ```
Unlike algebraic methods, subdivision methods inherently preserve correspondence between intersection results across different surface parameter domains. Specifically, the subdivision method obtains intersection point sets by recursively detecting bounding box intersections in different parameter domains. In the resulting set \( P_{1,u,v} \), each point’s correspondence to points in \( P_{2,s,t} \) is determined by the intersection relationships between their respective bounding boxes. Fig. 5(f) illustrates the corresponding result for \( P_{2,s,t} \), where matching partitioned subsets between \( P_{1,u,v} \) and \( P_{2,s,t} \) are colored identically.
```
