[Page 220]

2.5

2

1.5

1

0.5

0

−0.5

−1

−1.5

−2

−2.5

−2

−1

0

1

2

![The image consists of a graph with three circles. The graph is titled 3-D and has a gradient that transitions from blue to purple. The gradient is defined by a scale of 0.5 units on the x-axis and 1 unit on the y-axis. The gradient is colored in a gradient of colors that include blue, green, red, and purple. The gradient is not uniform, but it appears to be a gradient from blue to purple. The graph is labeled 3-D and has a title. The title is written in a sans-serif font, which is white. The graph is also labeled 2.5 and has a title. The title is written in a sans-serif font, which is blue. The graph is divided into three sections, each with a different color. The first section is blue, the second section is green, and the third section is red. The colors of the](../images/imageFile23.png)

2.5

2

1.5

0.5

-0.5

Figure 4.11 The left-hand plot shows the class-conditional densities for three classes each having a Gaussian distribution, coloured red, green, and blue, in which the red and green classes have the same covariance matrix. The right-hand plot shows the corresponding posterior probabilities, in which the RGB colour vector represents the posterior probabilities for the respective three classes. The decision boundaries are also shown. Notice that the boundary between the red and green classes, which have the same covariance matrix, is linear, whereas those between the other pairs of classes are quadratic.

# 4.2.2 Maximum likelihood solution

Once we have speciﬁed a parametric functional form for the class-conditional densities p ( x |C k ) , we can then determine the values of the parameters, together with the prior class probabilities p ( C k ) , using maximum likelihood. This requires a data set comprising observations of x along with their corresponding class labels.

Consider ﬁrst the case of two classes, each having a Gaussian class-conditional density with a shared covariance matrix, and suppose we have a data set { x n ,t n } where n = 1 ,...,N . Here t n = 1 denotes class C 1 and t n = 0 denotes class C 2 . We denote the prior class probability p ( C 1 ) = π , so that p ( C 2 ) = 1 − π . For a data point x n from class C 1 , we have t n = 1 and hence

$$
p ( x _ { n } , \mathcal { C } _ { 1 } ) = p ( \mathcal { C } _ { 1 } ) p ( x _ { n } | \mathcal { C } _ { 1 } ) = \pi \mathcal { N } ( x _ { n } | \mu _ { 1 } , \Sigma ) . \\
$$

Similarly for class C 2 , we have t n = 0 and hence

$$
p ( \mathbf x _ { n } , \mathcal { C } _ { 2 } ) = p ( \mathcal { C } _ { 2 } ) p ( \mathbf x _ { n } | \mathcal { C } _ { 2 } ) = ( 1 - \pi ) \mathcal { N } ( \mathbf x _ { n } | \mu _ { 2 } , \Sigma ) . \\
$$

Thus the likelihood function is given by

$$
p ( t | \pi , \mu _ { 1 } , \mu _ { 2 } , \Sigma ) = & \prod _ { n = 1 } ^ { N } [ \pi \mathcal { N } ( x _ { n } | \mu _ { 1 } , \Sigma ) ] ^ { t _ { n } } \left [ ( 1 - \pi ) \mathcal { N } ( x _ { n } | \mu _ { 2 } , \Sigma ) \right ] ^ { 1 - t _ { n } } \\ \text {where } t _ { n } = ( t _ { 1 } , \dots , t _ { N } ) ^ { T } \text { \ as usual } \text {it is convenient to maximize the log of the}
$$

where t = ( t 1 ,...,t N ) T . As usual, it is convenient to maximize the log of the likelihood function. Consider ﬁrst the maximization with respect to π . The terms in
