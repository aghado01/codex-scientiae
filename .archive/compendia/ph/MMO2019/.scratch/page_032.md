[Page 32]

![The image is a graph with two axes labeled as x and y. The x-axis is labeled as x and the y-axis is labeled as y. Both axes are labeled as death and birth. There are two points on the graph, labeled as a and b.](<MMO2019/imageFile9.png>)

20.5

0.0

0.5

1.0

1.0

(a)

0.8


080

0.2

0.4

0.6

Birth

(b)

0.8

1.0

Figure 8: An example underlying dataset and its associated persistence diagram. The persistence diagrams are used as the centers for the kernel density estimate. For this example, persistence diagrams with more than one feature are relatively rare.

|KDE|(1)|(2)|(3)|(4)|
|---|---|---|---|---|
|n|100|300|1000|5000|
|σ|0.03|0.025|0.020|0.015|


Table 1: Choices of sample size n (number of persistence diagrams) and bandwidth σ for each kernel density estimate ˆ f n,σ ( Z ) shown in Fig. 9.

8. Since these datasets are sampled from the unit circle perturbed by relatively small noise, one expects the associated 1-homology to have a single persistent feature with d ≈ 1 with possible brief features caused by noise.

We consider several KDEs as we simultaneously increase the number of persistence diagrams ( n ) and narrow the bandwidth ( σ ) as shown in Table 1). The bandwidth was chosen to scale according to Silverman’s rule of thumb (Silverman, 1986) (see Rmk. 32).

Since the KDEs ˆ f n,σ ( Z ) are deﬁned on N W N for several input cardinalities N , we present them in multiple slices by ﬁxing a cardinality and then ﬁxing all but one input feature as described in Rmk 41. For example, g ( ξ ) = ˆ f n,σ ( ξ,ξ 2 ,...,ξ N ) for ﬁxed ξ j ( j = 2 ,...,N ) is a function on W and represents a slice of the local KDE on W N . The progression of KDE slices can be seen in Fig. 9, wherein the same slices (i.e., the same features are ﬁxed) are viewed for each choice of ( n,σ ). These plots demonstrate in practice the convergence of the kernel density estimator shown in Theorem 1. Because the sample points for the underlying dataset lie so close to the unit circle, one expects the topological feature to die near scale d = 1, as is reﬂected in the KDEs shown in Fig. 9 (left); however, the distribution of points along the circle allows its birth scale to vary quite a lot. Additional features with brief persistence are concentrated very close to the diagonal due to small noise. These features tend to be either spurious holes near the edge (smaller b and d ) or a short split of the main topological loop in two (larger b and d ); this behavior is reﬂected in the two peaks for slices of the KDEs shown in Fig. 9 (right). Indeed, the persistence diagram shown in Fig. 8 is typical for this example. Overall, by scanning from top to bottom, Fig. 9 demonstrates the convergence of the KDEs as n increases and σ decreases. The location and mass of each mode is as expected from underlying data sampled from the unit circle. Moreover, very small spread in
