[Page 4]

# 4.1. Two-step Mapper algorithm

In Section 3.1 , we provide an overview of the basic process of the Mapper algorithm. In this paper, We develop a two-step Mapper algorithm to extract the topological structure of an input point set \( X \subseteq \mathbb{R}^2 \) . This is outlined in Alg. 1 and explained in the following. First, we construct the initial Mapper graph using a filter function based on principal direction projections. Then, we subdivide the nodes in the Mapper graph along orthogonal directions to obtain the final Mapper graph. Algorithms for higher dimensions can be similarly generalized.

Filter function selection . To obtain general theoretical guarantees, the filter function should be Morse-type. A large class of Morse-type functions commonly used in Mapper constructions are Lipschitz continuous, i.e., there exists a constant \( c > 0 \) such that the function \( f : X \to \mathbb{R} \) satisfies

$$
| f ( x ) - f ( x ^ { \prime } ) | \leq c \| x - x ^ { \prime } \| .
$$

In this paper, we employ linear projections as filter functions, for which the Lipschitz constant satisfies \( c = 1 \) . When constructing the initial Mapper graph, we apply principal component analysis (PCA) [ Jolliffe , 1990 ] to compute the principal directions of \( X \) , and adopt the projection of the data onto the first principal direction as the filter function. Specifically, we first compute the centroid \( x_c \) of \( X \) ,

# Algorithm 1 Two-step Mapper algorithm

Input: A point set \( X \subseteq \mathbb{R}^2 \) , clustering parameter \( \delta \) , overlap ratio \( \theta_{ov} \) Output: Mapper graph \( G \) of \( X \)

# Output: Mapper graph \( G \) of \( X \)

- 1: Construct the initial Mapper graph \( G \)
- 2: Set \( V_{split} = \emptyset \) .


set \( X_i \) corresponding to the node \( v_i \) in \( G \) do

- 4: Compute the number of intervals \( S_i \) corresponding to \( X_i \) 5: = 2

$$
x _ { c } = \frac { 1 } { m } \sum _ { i = 1 } ^ { m } x _ { i } .
$$

- 5: if \( S_i \geq 2 \) then
Next, we compute the covariance matrix \( \Sigma = ( \sigma_{i,j} ) \) of the centralized point set \( X \) ,
- 6: Add the node \( v_i \) to \( V_{split} \)
- 7: end if
- 8: end for


$$
\sigma _ { i , j } = \langle x _ { i } - x _ { c } , \ x _ { j } - x _ { c } \rangle , \text { where } x _ { i } , \ x _ { j } \in X . \quad ( 3 )
$$

nodes in \( V_{split} \) that belong to the same connected component in \( G \) into a single node. 10: for each point set corresponding to the node in

The eigenvector corresponding to the largest eigenvalue of \( \Sigma \) is denoted by \( w_p \) and defines the principal direction . The filter function \( f \) is then defined as the projection of a data point \( x \) onto \( w_p \) :

10: for each point set \( X_i \) corresponding to the node \( v_i \) in \( V_{split} \) do 11:

Construct the Mapper subgraph \( G_i \) corresponding to \( X_i \) using \( f^{\perp} \) .

$$
f ( x ) = \langle x - x _ { c } , \, w _ { p } \rangle .
$$

for each point set \( X_{nei} \) corresponding to neighboring node \( v_{nei} \) of \( v_i \) in \( G \) do

12:

Clustering method and parameter calculation . To guarantee the topological correctness of the Mapper graph, the parameters used to construct the cover are intrinsically related to the clustering parameters. Therefore, we first introduce the clustering method and parameter computation before describing the cover construction. In the clustering step, we construct a \( \delta \)-neighborhood

Merge all nodes in \( G_i \) where their corresponding point sets intersect with \( X_{nei} \) into a single node.

- 13:
- 14: end for
- 15: Replace \( v_i \) with all nodes from \( G_i \) .
- 16: end for


edges to \( G \) according to the edge addition rule of the Mapper algorithm. 18: return

graph based on \( X \) , where an edge is drawn between two distinct points if their Euclidean distance is less than \( \delta \) . The connected components of the preimage of the filter function \( f \) induced by this \( \delta \)-neighborhood graph are then taken as the clustering results. The parameter should satisfy the following conditions:

18: return \( G \)

# 4.1.1. Generation of the Mapper graph

This section follows the work of Carrière et al. [ Carriere et al. , 2018 ], who investigated the convergence of the Mapper graph to its continuous analogue, namely the Reeb graph. They employed extended persistence and its associated metric, the bottleneck distance [ Edelsbrunner and Harer , 2010 ], to quantitatively characterize the topological similarity between the Mapper graph and the corresponding Reeb graph. Their analysis provides parameter selection criteria that guarantee the bottleneck distance between the

The parameter \( \delta \) should satisfy the following conditions:

$$
4 d _ { H } ( \mathcal { M } , X ) \leq \delta ,
$$

$$
\delta \leq \frac { 1 } { 4 } \min \{ r c h , \rho \} ,
$$
