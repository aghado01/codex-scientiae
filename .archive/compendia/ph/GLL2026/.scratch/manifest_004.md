# Manifest: Page 004

## REPAIR_PROSE
- RAW: ```
In Section 3.1 , we provide an overview of the basic process of the Mapper algorithm. In this paper, We develop a two-step Mapper algorithm to extract the topological structure of an input point set 𝑋 ⊆ ℝ 2 . This is outlined in Alg. 1 and explained in the following. First, we construct the initial Mapper graph using a filter function based on principal direction projections. Then, we subdivide the nodes in the Mapper graph along orthogonal directions to obtain the final Mapper graph. Algorithms for higher dimensions can be similarly generalized.
```
  FIX: ```
In Section 3.1 , we provide an overview of the basic process of the Mapper algorithm. In this paper, We develop a two-step Mapper algorithm to extract the topological structure of an input point set \( X \subseteq \mathbb{R}^2 \) . This is outlined in Alg. 1 and explained in the following. First, we construct the initial Mapper graph using a filter function based on principal direction projections. Then, we subdivide the nodes in the Mapper graph along orthogonal directions to obtain the final Mapper graph. Algorithms for higher dimensions can be similarly generalized.
```
- RAW: ```
below. Filter function selection . To obtain general theoretical guarantees, the filter function should be Morse-type. A large class of Morse-type functions commonly used in Mapper constructions are Lipschitz continuous, i.e., there exists a constant 𝑐 > 0 such that the function 𝑓 ∶ 𝑋 → ℝ satisfies
```
  FIX: ```
Filter function selection . To obtain general theoretical guarantees, the filter function should be Morse-type. A large class of Morse-type functions commonly used in Mapper constructions are Lipschitz continuous, i.e., there exists a constant \( c > 0 \) such that the function \( f : X \to \mathbb{R} \) satisfies
```
- RAW: ```
| | ‖ ‖ In this paper, we employ linear projections as filter functions, for which the Lipschitz constant satisfies 𝑐 = 1 . When constructing the initial Mapper graph, we apply principal component analysis (PCA) [ Jolliffe , 1990 ] to compute the principal directions of 𝑋 , and adopt the projection of the data onto the first principal direction as the filter function. Specifically, we first compute the centroid 𝑥 𝑐 of 𝑋 ,
```
  FIX: ```
In this paper, we employ linear projections as filter functions, for which the Lipschitz constant satisfies \( c = 1 \) . When constructing the initial Mapper graph, we apply principal component analysis (PCA) [ Jolliffe , 1990 ] to compute the principal directions of \( X \) , and adopt the projection of the data onto the first principal direction as the filter function. Specifically, we first compute the centroid \( x_c \) of \( X \) ,
```
- RAW: ```
Input: A point set 𝑋 ⊆ ℝ 2 , clustering parameter 𝛿 , overlap ratio 𝜃 ov Output: Mapper graph 𝐺 of 𝑋
```
  FIX: ```
Input: A point set \( X \subseteq \mathbb{R}^2 \) , clustering parameter \( \delta \) , overlap ratio \( \theta_{ov} \) Output: Mapper graph \( G \) of \( X \)
```
- RAW: ```
# Output: Mapper graph 𝐺 of 𝑋
```
  FIX: ```
# Output: Mapper graph \( G \) of \( X \)
```
- RAW: ```
- 1: Construct the initial Mapper graph 𝐺
```
  FIX: ```
- 1: Construct the initial Mapper graph \( G \)
```
- RAW: ```
- 2: Set 𝑉 𝑠𝑝𝑙𝑖𝑡 = ∅ .
```
  FIX: ```
- 2: Set \( V_{split} = \emptyset \) .
```
- RAW: ```
set 𝑋 𝑖 corresponding to the node 𝑣 𝑖 in 𝐺 do
```
  FIX: ```
set \( X_i \) corresponding to the node \( v_i \) in \( G \) do
```
- RAW: ```
- 4: Compute the number of intervals 𝑆 𝑖 corresponding to 𝑋 𝑖 5: = 2
```
  FIX: ```
- 4: Compute the number of intervals \( S_i \) corresponding to \( X_i \) 5: = 2
```
- RAW: ```
- 5: if 𝑆𝑖 > = 2 then
```
  FIX: ```
- 5: if \( S_i \geq 2 \) then
```
- RAW: ```
- Next, we compute the covariance matrix Σ = ( 𝜎 𝑖,𝑗 ) of the centralized point set 𝑋 ,
```
  FIX: ```
Next, we compute the covariance matrix \( \Sigma = ( \sigma_{i,j} ) \) of the centralized point set \( X \) ,
```
- RAW: ```
- 6: Add the node 𝑣 𝑖 to 𝑉 𝑠𝑝𝑙𝑖𝑡
```
  FIX: ```
- 6: Add the node \( v_i \) to \( V_{split} \)
```
- RAW: ```
nodes in 𝑉 𝑠𝑝𝑙𝑖𝑡 that belong to the same connected component in 𝐺 into a single node. 10: for each point set corresponding to the node in
```
  FIX: ```
nodes in \( V_{split} \) that belong to the same connected component in \( G \) into a single node. 10: for each point set corresponding to the node in
```
- RAW: ```
⟨ ⟩ The eigenvector corresponding to the largest eigenvalue of Σ is denoted by 𝑤 𝑝 and defines the principal direction . The filter function 𝑓 is then defined as the projection of a data point 𝑥 onto 𝑤 𝑝 :
```
  FIX: ```
The eigenvector corresponding to the largest eigenvalue of \( \Sigma \) is denoted by \( w_p \) and defines the principal direction . The filter function \( f \) is then defined as the projection of a data point \( x \) onto \( w_p \) :
```
- RAW: ```
10: for each point set 𝑋𝑖 corresponding to the node 𝑣 𝑖 in 𝑉 𝑠𝑝𝑙𝑖𝑡 do 11:
```
  FIX: ```
10: for each point set \( X_i \) corresponding to the node \( v_i \) in \( V_{split} \) do 11:
```
- RAW: ```
Construct the Mapper subgraph 𝐺𝑖 corresponding to 𝑋𝑖 using 𝑓 ⟂ .
```
  FIX: ```
Construct the Mapper subgraph \( G_i \) corresponding to \( X_i \) using \( f^{\perp} \) .
```
- RAW: ```
for each point set 𝑋𝑛𝑒𝑖 corresponding to neighboring node 𝑣 𝑛𝑒𝑖 of 𝑣 𝑖 in 𝐺 do
```
  FIX: ```
for each point set \( X_{nei} \) corresponding to neighboring node \( v_{nei} \) of \( v_i \) in \( G \) do
```
- RAW: ```
⟨ ⟩ Clustering method and parameter calculation . To guarantee the topological correctness of the Mapper graph, the parameters used to construct the cover are intrinsically related to the clustering parameters. Therefore, we first introduce the clustering method and parameter computation before describing the cover construction. In the clustering step, we construct a -neighborhood
```
  FIX: ```
Clustering method and parameter calculation . To guarantee the topological correctness of the Mapper graph, the parameters used to construct the cover are intrinsically related to the clustering parameters. Therefore, we first introduce the clustering method and parameter computation before describing the cover construction. In the clustering step, we construct a \( \delta \)-neighborhood
```
- RAW: ```
Merge all nodes in 𝐺𝑖 where their corresponding point sets intersect with 𝑋𝑛𝑒𝑖 into a single node.
```
  FIX: ```
Merge all nodes in \( G_i \) where their corresponding point sets intersect with \( X_{nei} \) into a single node.
```
- RAW: ```
- 15: Replace 𝑣 𝑖 with all nodes from 𝐺𝑖 .
```
  FIX: ```
- 15: Replace \( v_i \) with all nodes from \( G_i \) .
```
- RAW: ```
edges to 𝐺 according to the edge addition rule of the Mapper algorithm. 18: return
```
  FIX: ```
edges to \( G \) according to the edge addition rule of the Mapper algorithm. 18: return
```
- RAW: ```
𝛿 graph based on 𝑋 , where an edge is drawn between two distinct points if their Euclidean distance is less than 𝛿 . The connected components of the preimage of the filter function 𝑓 induced by this 𝛿 -neighborhood graph are then taken as the clustering results. The parameter should satisfy the following conditions:
```
  FIX: ```
graph based on \( X \) , where an edge is drawn between two distinct points if their Euclidean distance is less than \( \delta \) . The connected components of the preimage of the filter function \( f \) induced by this \( \delta \)-neighborhood graph are then taken as the clustering results. The parameter should satisfy the following conditions:
```
- RAW: ```
18: return 𝐺
```
  FIX: ```
18: return \( G \)
```
- RAW: ```
The parameter 𝛿 should satisfy the following conditions:
```
  FIX: ```
The parameter \( \delta \) should satisfy the following conditions:
```

## REPAIR_MATH
- RAW: ```
| f ( x ) - f ( x ^ { \prime } ) | \leq c \| x - x ^ { \prime } \| .
```
  FIX: ```
$$
| f ( x ) - f ( x ^ { \prime } ) | \leq c \| x - x ^ { \prime } \| .
$$
```
- RAW: ```
x _ { c } = \frac { 1 } { m } \sum _ { i = 1 } ^ { m } x _ { i } .
```
  FIX: ```
$$
x _ { c } = \frac { 1 } { m } \sum _ { i = 1 } ^ { m } x _ { i } .
$$
```
- RAW: ```
\sigma _ { i , j } = \langle x _ { i } - x _ { c } , \ x _ { j } - x _ { c } \rangle , \text { where } x _ { i } , \ x _ { j } \in X . \quad ( 3 )
```
  FIX: ```
$$
\sigma _ { i , j } = \langle x _ { i } - x _ { c } , \ x _ { j } - x _ { c } \rangle , \text { where } x _ { i } , \ x _ { j } \in X . \quad ( 3 )
$$
```
- RAW: ```
f ( x ) = \langle x - x _ { c } , \, w _ { p } \rangle .
```
  FIX: ```
$$
f ( x ) = \langle x - x _ { c } , \, w _ { p } \rangle .
$$
```
- RAW: ```
4 d _ { H } ( \mathcal { M } , X ) \leq \delta ,
```
  FIX: ```
$$
4 d _ { H } ( \mathcal { M } , X ) \leq \delta ,
$$
```
- RAW: ```
\delta \leq \frac { 1 } { 4 } \min \{ r c h , \rho \} ,
```
  FIX: ```
$$
\delta \leq \frac { 1 } { 4 } \min \{ r c h , \rho \} ,
$$
```

