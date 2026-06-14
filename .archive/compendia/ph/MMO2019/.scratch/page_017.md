[Page 17]

![The image is a scatter plot with a categorical scale from 0.3 to 0.7 on the x-axis and a categorical scale from 0.3 to 0.7 on the y-axis. The x-axis is labeled Birth and the y-axis is labeled Death. There are four data points plotted on the graph, each representing a different birth rate. The data points are scattered around the x-axis, but they are not perfectly aligned. The data points are scattered in a way that suggests a pattern or trend. The x-axis is labeled Birth and the y-axis is labeled Death. The data points are scattered around the x-axis, but they are not perfectly aligned. The data points are scattered in a way that suggests a pattern or trend. There are four data points plotted on the graph, each representing a different birth rate. The data points are scattered around the x-axis, but they](<MMO2019/imageFile3.png>)

0.7

0.6

0.5

0.4


'85

0.4

0.5

0.6

0.7

Birth

0.7

0.6

813


0.4

0.5

Birth

0.6

0.7

Figure 3: Left: A persistence diagram split according to Eq. (4.1). The dashed black line, d = b + σ , separates the diagram into the red upper points of D u and the yellow lower points of D . Right: The red and black gradients represent the upper singleton densities p (1) and p (2) given by Eq. (4.2). The green gradient represents the lower density p deﬁned in Eq 4.4. While each of these densities is deﬁned on the wedge W ⊂ R 2 , the global kernel in Eq. (4.6) is deﬁned on N W N for each input-cardinality N .

Eq. (3.9) . Treating the random persistence diagrams D u and D as independent, the probability hypothesis density (PHD) associated with the kernel density centered at D with bandwidth σ of Theorem 25 is given by

$$
K _ { \sigma , P H D } ( \xi , \mathcal { D } ) = N _ { \ell } \, p ^ { \ell } ( \xi ) + \sum _ { j = 1 } ^ { N _ { u } } q ^ { ( j ) } p ^ { ( j ) } ( \xi ) ,
$$

where the feature ξ is the input and N u = | D u | and N   =   D     depend on both D and σ . Here each p ( j ) refers to the modiﬁed Gaussian pdf as shown in Eq. (4.2) for its matching singleton feature ξ j in D u , q ( j ) given by (4.3) is the probability each singleton is present, and the lower density p   is given by Eq. (4.4) .

Proof The PHD is uniquely deﬁned by its integral over a region U , which yields the expected number of points in the region. Consequently, the independent upper and lower random draws which build the kernel contribute additively to the PHD. Within the sum, each singleton density p ( j ) is weighted by the chance for D j to be present, q ( j ) and the lower density p is weighted according to the mean draw cardinality, which was chosen to be D .

Remark 29 (Computational cost) The kernel density presented in Eq. (4.6) of Proposition 25 has approxmiately N !2 N u terms, necessitating shrewd computational strategies for real world usage. In practice, one may choose to consider only terms that correspond to high probability matchings. Such an implementation may be carried out with a linear assignment algorithm, like Munkres, resulting in a computational complexity of O ( N u N 3 ) . Another approximation for the full kernel density is to consider input features as independent draws from the PHD given in (4.8) of Corollary 28. Evaluation of a diagram in Eq. (4.8) has time complexity O ( N ( N u + N )) . Finally, sampling from the kernel in Proposition 25 has cost O ( N u + N ) .
