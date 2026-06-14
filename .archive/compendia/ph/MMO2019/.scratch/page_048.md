[Page 48]

1.0

0.5

0.0

0.5

=1.0

1.0

0.0

(a)

0.5

1.0

![The image is a scatter plot with two axes labeled Birth and Death. The x-axis represents the age in years, ranging from 0 to 10 years. The y-axis represents the number of deaths, ranging from 0 to 0.5. The plot shows a trend of decreasing deaths over time, with a sharp decline in the number of deaths between 0.5 and 0.5.](<MMO2019/imageFile15.png>)

0.5

0.4

0.3

0.2

0.1

0.


0.5


0.2

0.3

0.4


Birth

(b)

Figure 14: (a) An example of the underlying datasets generated for Ex. 5. Each dataset consists of 100 points sampled uniformly (according to angle) on the two-lobed polar curve which are then perturbed by i.i.d. Gaussian noise with variance (1 / 30) 2 I 2 . (b) The persistence diagram associated to the ˇ Cech ﬁltration of the underlying dataset.

of 100 points sampled from a two-lobed polar curve, which are then perturbed by Gaussian noise with variance (1 / 30) 2 I 2 , and their associated ˇ Cech persistence diagrams for degree of homology k = 1. An example dataset and its associated persistence diagram for k = 1 are shown in Fig. 14.

We consider several KDEs as we simultaneously increase the number of persistence diagrams and narrow the bandwidth. The bandwidth was chosen to vary according to Silverman’s rule of thumb (Silverman, 1986). Since the KDEs are deﬁned on N W N for several input cardinalities N , we present ˆ f n,σ ( Z ) in multiple slices by ﬁxing a cardinality and then ﬁxing all but one input feature, as explained in Rmk. 41. For example, g ( ξ ) = ˆ f n,σ ( ξ,ξ 2 ,...,ξ N ) for ﬁxed ξ j is a function on W and represents a slice of the local KDE on W N . This progression of KDEs can be seen in Fig. 15, wherein the same slices are viewed for each choice of n and σ . Modes of each slice are used as ﬁxed features in the slices of higher cardinality inputs; consequently, the presented slices capture portions of the KDE with high probability density. Moreover, Fig. 15 demonstrates that these slices tend to capture speciﬁc topological or geometric features of the underlying dataspace.
