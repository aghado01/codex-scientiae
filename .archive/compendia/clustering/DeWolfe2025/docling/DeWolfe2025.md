[Page 1]

# HIERARCHICAL SINGLE LINKAGE CLUSTERING FOR COMMUNITY DETECTION WITH O VERLAPS AND OUTLIERS

# Ryan DeWolfe

Department of Mathematics Toronto Metropolitan University Toronto, Canada

# ABSTRACT

Most community detection approaches make very strong assumptions about communities in the data, such as every vertex must belong to exactly one community (the communities form a partition). For vector data, Hierarchical Density Based Spatial Clustering for Applications with Noise (HDBSCAN) has emerged as a leading clustering algorithm that allows for outlier points that do not belong to any cluster. The first step in HDBSCAN is to redefine the distance between vectors in such a way that single-linkage clustering is effective and robust to noise. Many community detection algorithms start with a similar step that attempts to increase the weight of edges between similar nodes and decrease weights of noisy edges. In this paper, we apply the hierarchical single-linkage clustering algorithm from HDBSCAN to a variety of node/edge similarity scores to see if there is an algorithm that can effectively detect clusters while allowing for outliers. In experiments on synthetic and real world data sets, we find that no single method is optimal for every type of graph, but the admirable performance indicates that hierarchical single-linkage clustering is a viable paradigm for graph clustering.

K eywords Graph Clustering, Community Detection, Edge Clustering, Overlapping Clustering, Hierarchical Clustering

# 1 Introduction

Finding groups of similar data in an unsupervised method, called clustering, is a fundamental problem in data science [1]. When working with data in the form of a graph, we often consider an edge as an indicator of similarity between two nodes, and clustering (or community detection) involves finding sets of nodes that have many edges between them. Despite the incomplete definition, clustering graphs is an important process with many applications, including link prediction, event detection, and biology [2].

Many graph clustering algorithms have been proposed [2], but unfortunately most of them can only return a partition of the data. Some papers [3, 4, 5] have argued for overlapping partitions, but very few algorithms allow for clusterings that do not necessarily cover all the nodes. In fact, the terms partition and clustering are often used interchangeably; we make the distinction that a clustering does not necessarily cover all the nodes, so that a partition is a clustering but a clustering may not be a partition.

In this paper, we apply the Hierarchical Single-Linkage Clustering (HSLC) algorithm from HDBSCAN [6] to the undirected weighted graphs produced by several previously proposed node or edge similarity scores [3, 7, 8, 9, 10, 11, 12, 13] in order to create a variety of unsupervised graph clustering algorithms. HSLC is particularly attractive since it has only a single parameter (the minimum cluster size), and it makes few assumptions about the clusters in the data [14]. When we apply HSLC to edge similarities, the edge clusters can be projected to the nodes, and the result is a clustering that can have both outliers and overlapping clusters.

[Page 2]

# 2 Node and Edge Similarity Measures

The first step in the HDBSCAN [6] algorithm constructs a new notion of dissimilarity that is robust to noise in the data. Many graph clustering/partitioning algorithms start with a similar step that attempts to down-weight edges that are believed to be inter-cluster and up-weight edges that are believed to be intra-cluster. This is usually followed by running a standard partitioning algorithm on the weighted graph, since a good weighting of the edges has been shown to help lessen the resolution limit issue of modularity [7]. In this section, we review several proposed methods for evaluating the similarity between nodes/edges, represented by a function s , where a higher edge weight means more similarity. Some methods define similarity between any pair of nodes/edges, while others only provide weights for adjacent nodes/edges, so in our experiments we restrict ourselves to using the similarity measures of adjacent nodes/edges (and in this sense we are applying a weighting to the graph/line graph).

# 2.1 Node Similarity Measures

# 2.1.1 Short Cycles (SC) [7]

The intuition for this method is that short cycles are more prevalent within clusters than between clusters. They propose weighting the edges of the graph based on the number of triangles and rectangles the edge is in, normalized by the maximum possible number of triangles and rectangles given the degrees of the ends. Furthermore, they show that iterating the weighing process improves the results (we use 3 iterations).

# 2.1.2 Random Walk Weighting (RWW) [11]

This method uses short random walks to quantify the similarity between nodes, following the intuition that a random walk is more likely to stay within a community [11, 15]. This method considers random walks up to length ℓ (with experiments for ℓ = 3 , 4 in the paper) starting at a source node n , and creates a vector corresponding to the probability of ending a random walk on each vertex. This is computed by creating a transition matrix T , equivalent to a row-normalized adjacency matrix, and then computing

$$
P = \sum _ { x = 1 } ^ { \ell } T ^ { x }
$$

The weight of an edge s ( i,j ) is defined as the cosine similarity between rows i and j of P . The weighting process is run iteratively to get a final weighting of the network (we use 3 iterations and ℓ = 3 ).

# 2.1.3 Node2vec (N2V) [9]

The node2vec algorithm uses many samples of short random walks starting at each node to embed the nodes of a graph into a vector space R d , and these embeddings have been shown to work well for graph partitioning [16]. For the weight of an edge e ij , we use s ( i,j ) = 1 1+ || v ( i ) − v ( j ) || 2 , where v ( i ) and v ( j ) are the node2vec embeddings of nodes i and j respectively. We the use pecanpy implementation [17] with parameters: p = q = 1 , 40 walks per node, 80 steps per walks, and d = 16 .

# 2.1.4 Renewal Non-backtracking Random Walks (RNBRW) [12]

This paper combines the intuitions of cycles and random walks. A non-backtracking random walker starts at a random vertex and walks until it creates a cycle, which is equivalent to revisiting a vertex since the walk in non-backtracking (walks that get stuck are discarded). Each edge is weighted with the probability that it is the last edge traversed in this random walk process, and “edges with larger weights may be thought of as more important to the formation of cycles” [12]. In practice, the edge weights are computed by sampling a large number of random walks, which is set to m (the number of edges in the graph) following the default implementation.

# 2.1.5 SimRank [18]

Zhang et al. propose a combination of the common neighbor index and Simrank [10] that allows similarity to propagate beyond the immediate neighborhood of each node. Let s t ( i,j ) represent the similarity between nodes i and j in iteration t . Initialize s 0 ( i,j ) with the indicator function χ { i = j } , and define the similarity in round t as

$$
s _ { t } ( i , j ) = \frac { 1 } { | N ( i ) | \times | N ( j ) | } \sum _ { x \in N ( i ) \ y \in N ( j ) } \sum _ { x \in N ( i ) } s _ { t - 1 } ( x , y ) .
$$

[Page 3]

In experiments on LFR and real world data, the authors found optimal t values between 1 and 5 , so we take t = 3 to match the other iterative methods.

# 2.1.6 Ensemble Clustering for Graphs (ECG) [13]

ECG was developed to address stability concerns with the Louvain partitioning algorithm. Many independent runs of the first stage of Louvain are run, and the edges of the graph are weighting according to the fraction of times the endpoints end up in the same part. Due to the randomized implementation of Louvain, this method is not deterministic, although the original paper found stable results for an ensemble size of 16 (which we also use here).

# 2.2 Edge Similarity Measures

# 2.2.1 Link Communities (LC) [3]

This methods evaluates the similarity of two adjacent edges based on the neighborhood overlap of the nodes at either end of the two-path. Let N [ i ] be the closed neighborhood of node i (all of i ’s neighbors and i itself). Then, for edges e ij and e jk , the similarity is defined as

$$
s ( e _ { i j } , e _ { j k } ) = \frac { | N [ i ] \cap N [ k ] | } { | N [ i ] \cup N [ j ] | } .
$$

# 2.2.2 Line Graph Transition Probabilities (LGTP) [8]

Evans and Lambiotte propose weighting the line graph according to the transition probabilities of an edge-based random walk. A random walker starts on an edge, and moves to an adjacent edge by first selecting one of the endpoints with equal probability and then selecting a random edge incident to that endpoint with probabilities proportional to the weight of each edge. Thus, for any adjacent edges e ij ,e jk , s ( e ij ,e jk ) = 1 deg ( j ) .

# 2.2.3 Node Similarity Measures on the Line Graph (LGmethod )

These methods have not been explicitly proposed previously, but inspired by [8], any of the node similarity scores can be run on the line graph to obtain an edge similarity score. We use the line graph weighted by transition probabilities (see the previous method) to down-weight the contribution of large degree nodes, since they produce a large cliques in the line graph. Furthermore, the line graph is often much larger than the original graph so there is concern about the scalability of these methods. We found RWW and Simrank are too slow, and reduced the number of walks per node to 10 and the steps per walk to 20 for node2vec.

# 2.2.4 Edge ECG (EECG)

Finally, we propose same idea as ECG [13], except instead of weighting adjacent nodes, adjacent edges are weighted as the proportion that all three nodes are in the same part after the first stage of Louvain.

# 3 Hierarchical Single-Linkage Clustering

In this section, we describe the HSLC clustering algorithm as it is applied to the similarity graphs described in the previous section. HDBSCAN [6] has strong theoretical foundations for vector data, but unfortunately they do not transfer to similarity graphs so we refer the interested reader to [14] for the motivation behind the algorithm. We note that the algorithm was originally written for dissimilarity scores (distances) in [6, 14], so we invert many of the definitions to continue with a similarity perspective. Finally, since we have defined similarity between both nodes and edges, we define the clustering method on a generic similarity graph S , with vertices K and weighted edges L .

First, a single-linkage dendrogram is built from the similarity graph S . The clusters at level λ are the connected components of the subgraph with all vertices and edges { k 1 k 2 ∈ L : s ( k 1 ,k 2 ) ≥ λ } .

However, this dendrogram is generally too complex to visualize (consider that when λ → ∞ every object has its own cluster). To condense the dendrogram so that it only tracks significant clusters, a parameter m s is introduced to control the minimum cluster size. This does impose a type of resolution limit [7] to the algorithm, but the effect of this parameter is intuitive. When traversing the dendrogram top-down, if a cluster is split, then one of the following three cases will occur:

1. The cluster splits into several clusters, each with less than m s vertices. We say the cluster has disappeared.

[Page 4]

- 2. The cluster splits into several clusters, at least two of which have at least m s vertices. We say all sub-clusters with at least m s vertices are significant and different from the original.
- 3. The cluster splits into one cluster with at least than m s vertices and one or more clusters with less than m s vertices. We say the original cluster shrinks, and the largest sub-cluster retains the name of the original cluster. The other clusters become noise.

The condensed dendrogram will have far fewer clusters, and naturally defines a level at which every cluster will disappear (for m s > 1 ).

Finally, even though the condensed dendrogram is practical for investigation, many applications still require a single set of clusters. HDBSCAN [6] defines a persistence score for each cluster, and then provides an algorithm to find the set of non-overlapping clusters to maximize total persistence. For a cluster C i ⊆ K , define the death of the cluster as λ min ( C i ) = min { λ : C i exists } . Also, define the contribution of each object k j ∈ C i as λ max ( k j ,C i ) = max { λ : k j ∈ C i } . Then, the persistence of cluster C i is given by the equation

$$
\sigma ( C _ { i } ) = \sum _ { k _ { j } \in C _ { i } } \left ( \lambda _ { \max } ( k _ { j } , C _ { i } ) - \lambda _ { \min } ( C _ { i } ) \right ) .
$$

The optimal flat clustering is described as the set of clusters C that maximizes C i ∈C σ ( C i ) subject to C i ∩ C j = ∅ ∀ C i ,C j ∈ C .

If S is a similarity graph of the nodes, HSLC returns a set of non-overlapping clusters while allowing for outliers. However, if S is a similarity graph of the edges, we project the non-overlapping edge clusters found by HSLC to the nodes by including a node in a cluster if it has at least on edge in the cluster. The clustering of nodes induced by the clustering of edges can have both outliers and overlapping clusters.

# 4 Results

In the most general setting, both the prediction and the labels can have overlap and outliers. We follow [4] and use precision, recall, and F1 score, although we report weighted averages since the distribution of community sizes is often far from uniform. For a single cluster C ⊆ N and a single label L ⊆ N , define the precision as p ( C,L ) = | C ∩ L | / | C | , the recall as r ( C,L ) = | C ∩ L | / | L | , and the F1 score as F1( C,L ) = 2 p ( C,L ) × r ( C,L ) / ( p ( C,L ) + r ( C,L )) . However, there is not a matching of predicted clusters to labels, so the predicted cluster is compared to each label and the best is chosen. Finally, a weighted average is used to combine the scores of each predicted cluster, with each cluster contributing proportional to its size. Let C be a set of predicted clusters, and L a set of labels. The weighted average scores are defined as

$$
\bar { p } ( \mathcal { C } , \mathcal { L } ) & = \frac { 1 } { \sum _ { C \in \mathcal { C } } | C | } \sum _ { C \in \mathcal { C } } \left ( | C | \times \max _ { L \in \mathcal { L } } \{ p ( C , L ) \} \right ) , \\ \bar { r } ( \mathcal { C } , \mathcal { L } ) & = \frac { 1 } { \sum _ { C \in \mathcal { C } } | C | } \sum _ { C \in \mathcal { C } } \left ( | C | \times \max _ { L \in \mathcal { L } } \{ r ( C , L ) \} \right ) , \\ \bar { F } 1 ( \mathcal { C } , \mathcal { L } ) & = \frac { 1 } { \sum _ { C \in \mathcal { C } } | C | } \sum _ { C \in \mathcal { C } } \left ( | C | \times \max _ { L \in \mathcal { L } } \{ F 1 ( C , L ) \} \right ) . \\ \text {most important measure if our goal is a conservative algorithm that makes few}
$$

$$
C \in \mathcal { C }
$$

The precision is the most important measure if our goal is a conservative algorithm that makes few mistakes. We also report the coverage of a clusters (the percentage of objects with at least one cluster) since it is an intuitive value that is not obvious from the three measures above.

For testing the clustering algorithms, we use synthetic graphs and real world data with known ground truth communities. The synthetic graphs are generated from extensions of the Artificial Benchmark for Community Detection (ABCD) [19], which is similar to the very popular LFR model, although the noise parameter ξ ∈ [0 , 1] allows for a smooth transition from disjoint communities when ξ = 0 to no community structure when ξ = 1 . For non-overlapping node clustering, we use an extension that includes outlier nodes, ABCD+o [20], with various proportions of outlier nodes. For overlapping clusters, we use ABCD+o 2 [21] graphs that have both outliers and overlapping ground truth clusters.

Finally, we consider four real data sets from various domains with known ground truth communities. First, we use the Football graph [22], which has non-overlapping node clusters and known anomalous teams that we label as outliers [23]. Next, we use a union K-nearest-neighbors graph from the MNIST digits dataset [24], with 10 ground truth labels corresponding to each digit. We set K = 15 , and there is an edge e ij if either i in j ’s 15 nearest neighbors or j is in i ’s

[Page 5]

![In this image there is a graph. On the graph there are few lines. There is a scale on the right side. There is a text on the left side.](images/imageFile1.png)

10% Outliers

1.0

1.0

SC

RWW

0.8

0.8

N2V

RNBRW

Precision

0.6

0.6

Simrank

F1

ECG

0.4

0.4

0.2

0.2

0.0

0.0

0.2

0.3

0.4

0.5

0.6

0.7

0.8

0.2

0.3

0.4

0.5

0.6

0.7

0.8

Noise (

)

Noise (

)

50% Outliers

1.0

1.0

0.8

0.8

Precision

0.6

0.6

F1

0.4

0.4

0.2

0.2

0.0

0.0

0.2

0.3

0.4

0.5

0.6

0.7

0.8

0.2

0.3

0.4

0.5

0.6

0.7

0.8

Noise (

)

Noise (

)

Figure 1: Results of the node clustering benchmark on ABCD+o graphs with m s = 15 . We report the precision (left) and F1 score (right) on ABCD+o graphs with 10 , 000 nodes with 10% outliers (top) or 50% outliers (bottom). In each figure, we vary the noise parameter ξ from 0 . 2 to 0 . 8 , and report the average metric across 25 random graphs.

15 nearest neighbors. K-nearest-neighbors graphs are commonly used for non-linear dimension reduction techniques, such as UMAP [25], which are able to separate the clusters in the low dimensional output. Finally, we use the DBLP (academic collaboration) and Amazon (co-purchasing) networks from the SNAP repository [26], which have both outliers and overlapping cluster labels.

# 4.1 Node Clustering

First, we run an experiment on synthetic ABCD+o [20] graphs with 10 , 000 nodes, one of 10% or 50% outliers, and a varying level of noise. In Figure 1, we report the ¯ p and ¯ F1 versus ξ curves of each node similarity method combined with HSLC. No single weighting method performs best across metrics, proportion of outliers, or noise level. ECG consistently achieves the best or competitive ¯ F1 score up to ξ ≈ 0 . 6 , at which point the graph is very noisy and no method is performing well. With low noise values ( ξ ≤ 0 . 4 ), the short cycle method (SC) achieves the best precision, although ECG and Simrank are competitive, and perform better in the medium noise regime ξ ∈ (0 . 4 , 0 . 6] .

Next, we apply each of the node clustering methods to the real world data-sets, setting m s = 5 for Football, m s = 500 for MNIST, and m s = 10 for DBLP and Amazon. Results are shown in Table 1. Similar to the experiment on synthetic graphs, no method clearly outperforms the others. Node2vec (N2V), Simrank, Random walk weighting (RWW), and ECG perform fairly well for each graph.

[Page 6]

| Method   | # Clusters | Max Cluster | Size Coverage | Precision | F1     |
| -------- | ---------- | ----------- | ------------- | --------- | ------ |
| Football |            |             |               |           |        |
| SC       | 3          | 93          | 0 .           | 98 0 . 29 | 0 . 38 |
| N2V      | 11         | 15          | 0 .           | 97 0 . 91 | 0 . 92 |
| ECG      | 10         | 16          | 1 .           | 00 0 . 87 | 0 . 91 |
| RNBRW    | 8          | 25          | 0 .           | 78 0 . 59 | 0 . 61 |
| SIMRANK  | 11         | 16          | 1 .           | 00 0 . 88 | 0 . 90 |
| RWW      | 11         | 19          | 1 .           | 00 0 . 88 | 0 . 90 |
| MNIST    |            |             |               |           |        |
| SC       | 11         | 7482        | 0 .           | 37 0 . 86 | 0 . 59 |
| N2V      | 9          | 13865       | 0 .           | 67 0 . 80 | 0 . 70 |
| ECG      | 10         | 7963        | 0 .           | 99 0 . 97 | 0 . 97 |
| RNBRW    | 2          | 48498       | 0 .           | 71 0 . 13 | 0 . 21 |
| SIMRANK  | 3          | 8171        | 0 .           | 14 0 . 77 | 0 . 69 |
| RWW      | 15         | 7509        | 0 .           | 44 0 . 83 | 0 . 51 |
| DBLP     |            |             |               |           |        |
| SC       | 5540       | 1469        | 0 .           | 37 0 . 53 | 0 . 32 |
| N2V      | 9698       | 323         | 0 .           | 58 0 . 49 | 0 . 28 |
| ECG      | 4894       | 16142       | 0 .           | 93 0 . 28 | 0 . 22 |
| RNBRW    | 225        | 300580      | 0 .           | 96 0 . 03 | 0 . 05 |
| SIMRANK  | 10385      | 115         | 0 .           | 62 0 . 46 | 0 . 30 |
| RWW      | 7501       | 144         | 0 .           | 44 0 . 51 | 0 . 31 |
| Amazon   |            |             |               |           |        |
| SC       | 8296       | 556         | 0 .           | 63 0 . 87 | 0 . 52 |
| N2V      | 9971       | 390         | 0 .           | 65 0 . 87 | 0 . 51 |
| ECG      | 2452       | 9471        | 0 .           | 96 0 . 76 | 0 . 50 |
| RNBRW    | 597        | 307076      | 0 .           | 95 0 . 18 | 0 . 28 |
| SIMRANK  | 10507      | 147         | 0 .           | 61 0 . 85 | 0 . 53 |
| RWW      | 8678       | 379         | 0 .           | 51 0 . 87 | 0 . 49 |

[Page 7]

= 1.5, 10% Outliers

= 1.5, 10% Outliers

![In this image there is a graph.](images/imageFile2.png)

1.0

1.0

LC

LGTP

0.8

0.8

LG-SC

LG-N2V

Precision

0.6

0.6

LG-RNBRW

F1

LG-ECG

0.4

0.4

EECG

0.2

0.2

0.0

0.0

0.1

0.2

0.3

0.4

0.5 )

0.6

0.7

0.1

0.2

0.3

0.4

0.5 )

0.6

0.7

Noise (

)

Noise (

)

= 0.4, 10% Outliers

= 0.4, 10% Outliers

1.0

1.0

0.8

0.8

Precision

0.6

0.6

F1

0.4

0.4

0.2

0.2

0.0

0.0

1.0

1.2

1.4

1.6

1.8

2.0

1.0

1.2

1.4

1.6

1.8

2.0

Overlap (

)

Overlap (

)

Figure 2: Results of the edge clustering benchmark on ABCD+o 2 [21] graphs with 10 , 000 nodes. We report the precision (left column) and F1 score (right column) when varying either the noise parameter ξ (top row) or the amount of overlap η (bottom row). The results shown are the average of each metric on 25 random graphs produced with the given parameters.

# 4.2 Edge Clustering / Overlapping Clustering

The performance of each edge clustering method on the synthetic ABCD+o 2 graphs are shown in Figure 2, again with 10 , 000 nodes and averaged over 25 graphs. Only link community (LC), node2vec (LG-N2V) and edge-ecg (EECG) appear to be viable option for detecting overlapping clusters, with link communities and node2vec generally out performing edge-ecg.

Finally, we apply each of the node clustering methods to the real world data-sets. The results are shown in Table 2. Link communities (LC) is the only method with competitive performance on all four graphs. The other method of note is Edge-ECG (EECG), which achieves almost perfect F1 on MNIST, and performs reasonably well every other graph.

# 5 Conclusion

We proposed applying the hierarchical single-linkage clustering method from HDBSCAN [6] to several existing node and edge similarity measures to create graph clustering methods that allow for outliers and overlapping clusters. The results on synthetic and real data suggest that several methods can perform well, and that the best performing method depends on the nature of the graph, the amount of noise, and the amount of overlap. We believe the respectable performance indicates that hierarchical single-linkage clustering is a viable avenue for community detection with overlaps and outliers, and hope to develop improved node/edge similarity measures in future work.

[Page 8]

| Method   | # Clusters | Max Cluster | Coverage | Coverage Precision | F1     |
| -------- | ---------- | ----------- | -------- | ------------------ | ------ |
| Football |            |             |          |                    |        |
| LC       | 14         | 16          | 1 .      | 00 0 . 75          | 0 . 78 |
| LGTP     | 8          | 105         | 1 .      | 00 0 . 32          | 0 . 42 |
| LG-SC    | 4          | 98          | 1 .      | 00 0 . 25          | 0 . 35 |
| LG-N2V   | 11         | 32          | 0 .      | 98 0 . 67          | 0 . 74 |
| LG-ECG   | 11         | 35          | 1 .      | 00 0 . 46          | 0 . 61 |
| LG-RNBRW | 3          | 111         | 1 .      | 00 0 . 17          | 0 . 27 |
| EECG     | 10         | 37          | 1 .      | 00 0 . 61          | 0 . 72 |
| MNIST    |            |             |          |                    |        |
| LC       | 19         | 7450        | 0 .      | 31 0 . 94          | 0 . 54 |
| LGTP     | 5          | 57763       | 0 .      | 85 0 . 16          | 0 . 20 |
| LG-SC    | 2          | 69052       | 0 .      | 99 0 . 12          | 0 . 19 |
| LG-N2V   | 3          | 45853       | 0 .      | 94 0 . 32          | 0 . 43 |
| LG-ECG   | 8          | 22204       | 1 .      | 00 0 . 76          | 0 . 82 |
| LG-RNBRW | 3          | 38941       | 0 .      | 58 0 . 17          | 0 . 23 |
| EECG     | 10         | 7999        | 1 .      | 00 0 . 97          | 0 . 97 |
| DBLP     |            |             |          |                    |        |
| LC       | 19991      | 197         | 0 .      | 80 0 . 56          | 0 . 27 |
| LGTP     | 20123      | 178         | 0 .      | 72 0 . 56          | 0 . 29 |
| LG-SC    | 18         | 314355      | 0 .      | 99 0 . 02          | 0 . 05 |
| LG-N2V   | 3          | 317065      | 1 .      | 00 0 . 02          | 0 . 05 |
| LG-ECG   | 3          | 317053      | 1 .      | 00 0 . 02          | 0 . 05 |
| LG-RNBRW | 209        | 306017      | 0 .      | 97 0 . 04          | 0 . 05 |
| EECG     | 4975       | 21409       | 0 .      | 94 0 . 28          | 0 . 21 |
| Amazon   |            |             |          |                    |        |
| LC       | 16578      | 550         | 0 .      | 87 0 . 87          | 0 . 46 |
| LGTP     | 16120      | 21599       | 0 .      | 76 0 . 78          | 0 . 38 |
| LG-SC    | 9182       | 4882        | 0 .      | 86 0 . 80          | 0 . 45 |
| LG-N2V   | 12661      | 697         | 0 .      | 76 0 . 87          | 0 . 52 |
| LG-ECG   | 3069       | 9578        | 0 .      | 97 0 . 76          | 0 . 49 |
| LG-RNBRW | 5          | 334534      | 1 .      | 00 0 . 16          | 0 . 28 |
| EECG     | 2482       | 9021        | 0 .      | 96 0 . 76          | 0 . 49 |

[Page 9]

# References

- [1] C. Hennig, M. Meila, F. Murtagh, and R. Rocci. Handbook of Cluster Analysis . Chapman and Hall/CRC, New York, 2015.
- [2] Santo Fortunato. Community detection in graphs. Physics Reports , 486(3-5):75–174, 2010.
- [3] Yong-Yeol Ahn, James P. Bagrow, and Sune Lehmann. Link communities reveal multiscale complexity in networks. Nature , 466:761–764, 2010.
- [4] Alessandro Epasto, Silvio Lattanzi, and Renato Paes Leme. Ego-splitting framework: from non-overlapping to overlapping clusters. In Proceedings of the 23rd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining , KDD ’17, pages 145–154, Halifax, Canada, 2017.
- [5] T. S. Evans and R. Lambiotte. Line graphs of weighted networks for overlapping communities. The European Physical Journal B , 77:265–272, 2010.
- [6] Ricardo J. G. B. Campello, Davoud Moulavi, and Joerg Sander. Density-based clustering based on hierarchical density estimates. In Advances in Knowledge Discovery and Data Mining , volume 7819 of PAKDD 2013. Lecture Notes in Computer Science() , pages 160–172, Sydney, Australia, 2013.
- [7] Jonathan W. Berry, Bruce Hendrickson, Randall A. LaViolette, and Cynthia A. Phillips. Tolerating the community detection resolution limit with edge weighting. Physical Review E , 83(5):056119, 2011.
- [8] T. S. Evans and R. Lambiotte. Line graphs, link partitions, and overlapping communities. Phys. Rev. E , 80:016105, 2009.
- [9] Aditya Grover and Jure Leskovec. node2vec: Scalable feature learning for networks. In Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining , KDD ’16, pages 855–864, San Francisco, USA, 2016.
- [10] Glen Jeh and Jennifer Widom. Simrank: a measure of structural-context similarity. In Proceedings of the Eighth ACM SIGKDD International Conference on Knowledge Discovery and Data Mining , KDD ’02, pages 538–543, Edmonton, Canada, 2002.
- [11] Darong Lai, Hongtao Lu, and Christine Nardini. Enhanced modularity-based community detection by random walk network preprocessing. Phys. Rev. E , 81:066118, 2010.
- [12] Behnaz Moradi-Jamei, Heman Shakeri, Pietro Poggi-Corradini, and Michael J. Higgins. A new method for quantifying network cyclic structure to improve community detection. Physica A: Statistical Mechanics and its Applications , 561:125116, 2021.
- [13] Valérie Poulin and François Théberge. Ensemble clustering for graphs: comparisons and applications. Applied Network Science , 4(1):51, 2019.
- [14] Leland McInnes and John Healy. Accelerated hierarchical density based clustering. In 2017 IEEE International Conference on Data Mining Workshops (ICDMW) , pages 33–42, New Orleans, USA, 2017.
- [15] Pascal Pons and Matthieu Latapy. Computing communities in large networks using random walks. In Computer and Information Sciences ISCIS 2005 , pages 284–293, Berlin, Heidelberg, 2005. Springer Berlin Heidelberg.
- [16] Sadamori Kojaku, Filippo Radicchi, Yong-Yeol Ahn, and Santo Fortunato. Network community detection via neural embeddings. Nature Communications , 15(1):9446, 2024.
- [17] Renming Liu and Arjun Krishnan. Pecanpy: a fast, efficient and parallelized python implementation of node2vec. Bioinformatics , 37:3377–3379, 2021.
- [18] Haiyan Zhang, Chenxi Zhou, Xun Liang, Xi Zhao, and Yaping Li. A novel edge weighting method to enhance network community detection. In 2015 IEEE International Conference on Systems, Man, and Cybernetics , pages 167–172, Hong Kong, China, 2015.
- [19] Bogumił Kami´ nski, Paweł Prałat, and François Théberge. Artificial benchmark for community detection (ABCD)—fast random graph model with community structure. Network Science , 9(2):153–178, 2021.
- [20] Bogumił Kami´ nski, Paweł Prałat, and François Théberge. Artificial benchmark for community detection with outliers (ABCD+o). Applied Network Science , 8(25), 2023.
- [21] Jordan Barrett, Ryan DeWolfe, Bogumił Kami´ nski, Paweł Prałat, Aaron Smith, and François Théberge. The artificial benchmark for community detection with outliers and overlapping communities (ABCD+o 2 ). In Modelling and Mining Networks , volume 15669 of WAW 2025. Lecture Notes in Computer Science , pages 125–140, Vilnius, Lithuania, 2025.

[Page 10]

- [22] M. Girvan and M. E. J. Newman. Community structure in social and biological networks. Proceedings of the National Academy of Sciences , 99(12):7821–7826, 2002.
- [23] T S Evans. Clique graphs and overlapping communities. J. Stat. Mech. , 2010(12):P12037, 2010.
- [24] Y. Lecun, L. Bottou, Y. Bengio, and P. Haffner. Gradient-based learning applied to document recognition. Proceedings of the IEEE , 86(11):2278–2324, 1998.
- [25] Leland McInnes, John Healy, and James Melville. Umap: Uniform manifold approximation and projection for dimension reduction, 2020.
- [26] Jaewon Yang and Jure Leskovec. Defining and evaluating network communities based on ground-truth. In 2012 IEEE 12th International Conference on Data Mining , pages 745–754, Brussels, Belgium, 2012.
