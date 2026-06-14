[Page 31]



Birth

(a)

9/1000

7/1000

5/1000

3/1000

1/1000

![The image is a diagram titled Death with two triangles labeled as Death and Birth. The diagram is divided into two parts, each labeled with a different number of points. The points of the triangles are labeled as follows: - Death has 2 points labeled as 1 and 1/1000 - Birth has 2 points labeled as 1 and 1/1000 The diagram is divided into two parts, each labeled with a different number of points. The points of the triangles are labeled as follows: - Death has 2 points labeled as 1 and 1/1000 - Birth has 2 points labeled as 1 and 1/1000 The diagram is divided into two parts, each labeled with a different number of points. The points of the triangles are labeled as follows:](<MMO2019/imageFile8.png>)

9/1000

7/1000

5/1000


3/1000

1/1000


Birth

(b)

Figure 7: Contour maps for slices of the kernel density K σ (( ξ,ξ 2 ,ξ 3 ) , D ) with input cardinality 3. A pair of features ξ 2 and ξ 3 , indicated by white crosshairs, are ﬁxed to restrict to a 2D subspace as follows: (a) ( ξ 2 ,ξ 3 ) = ((1 , 3) , (2 , 4)) and (b) ( ξ 2 ,ξ 3 ) = ((1 , 3) , (2 . 5 , 3 . 5)). Since the symmetric version of the density is used, the order of these features is irrelevant. The center diagram is indicated by red (upper) and green (lower) points. Scale bars at the right of each plot indicate the range of probability density in each shaded region.

The terms (1 − q ( k ) ) within the Q ∗ expression (see Eq. (3.11)) are very small and appear in terms for which the corresponding upper feature is unassigned. These terms are so small because both upper features have very long persistence in this example (four times the bandwidth), and so the terms in Eqs. (5.5), (5.6), and (5.7) which do not include one or both upper Guassians p (1) and p (2) have progressively smaller contribution to the overall local kernel. Consequently, the kernel places much higher probability density near input diagrams with features nearby each upper feature in the center diagram. This behavior is seen in Fig. 5, 6, 7, and their respective analyses, and is directly correlated to the ratio of persistence to bandwidth for each feature.

Example 3 Here we consider the random persistence diagram generated from a speciﬁc random dataset in R 2 . Our goal in this example is to build and demonstrate convergence of the kernel density estimate for the pdf of the associated random persistence diagram. Speciﬁcally, we generate sample datasets which each consist of 10 points sampled uniformly from the unit circle with additive Gaussian noise, N ((0 , 0) , 1 50 2 I 2 ). This toy dataset is prototypical for signal analysis (corresponding to the circular dynamics of a noisy sine curve), wherein the high dimensional point cloud is obtained through delay-embedding of the signal. An in-depth analysis of using delay embedding alongside persistent homology is found in (Perea and Harer, 2015).

These datasets each yield a ˇ Cech persistence diagram as described in Section 2 for degree of homology k = 1. A sample dataset and its associated k = 1 persistence diagram are shown in Fig.
