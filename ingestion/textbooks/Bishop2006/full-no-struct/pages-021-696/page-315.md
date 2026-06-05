[Page 315]

![The image is a graph with a title at the top that reads 1. There are three different sections of the graph, each labeled with a number from 0 to 1. The graph has a grid with a scale from 0 to 1 on the x-axis, labeled 0. The y-axis is labeled 1, and the graph has a scale from 0 to 1 on the x-axis, labeled 0. The graph has a few different lines and curves, but they are not clearly defined.](../images/imageFile131.png)

1

1

1

0.5

0.75

0.75

0

0.5

0.5

−0.5

0.25

0.25

-1

0

0

-1

0

1

−1

0

1

-1

0

1

0.04

0.04

0.04

0.02

0.02

0.02

0

0

0

−1

0

1

−1

0

1

−1

0

1

Figure 6.1 Illustration of the construction of kernel functions starting from a corresponding set of basis functions. In each column the lower plot shows the kernel function k ( x, x ) deﬁned by (6.10) plotted as a function of x for x = 0 , while the upper plot shows the corresponding basis functions given by polynomials (left column), ‘Gaussians’ (centre column), and logistic sigmoids (right column).

Appendix C

If we take the particular case of a two-dimensional input space x = ( x 1 ,x 2 ) we can expand out the terms and thereby identify the corresponding nonlinear feature mapping

$$
\begin{array} { r l r } { k ( x , z ) } & { = } & { \left ( x ^ { T } z \right ) ^ { 2 } = ( x _ { 1 } z _ { 1 } + x _ { 2 } z _ { 2 } ) ^ { 2 } } \\ & { = } & { x _ { 1 } ^ { 2 } z _ { 1 } ^ { 2 } + 2 x _ { 1 } z _ { 1 } x _ { 2 } z _ { 2 } + x _ { 2 } ^ { 2 } z _ { 2 } ^ { 2 } } \\ & { = } & { ( x _ { 1 } ^ { 2 } , \sqrt { 2 } x _ { 1 } x _ { 2 } , x _ { 2 } ^ { 2 } ) ( z _ { 1 } ^ { 2 } , \sqrt { 2 } z _ { 1 } z _ { 2 } , z _ { 2 } ^ { 2 } ) ^ { T } } \\ & { = } & { \phi ( x ) ^ { T } \phi ( z ) . } \end{array}
$$

We see that the feature mapping takes the form φ ( x ) = ( x 2 1 , √ 2 x 1 x 2 ,x 2 2 ) T and therefore comprises all possible second order terms, with a speciﬁc weighting between them.

More generally, however, we need a simple way to test whether a function constitutes a valid kernel without having to construct the function φ ( x ) explicitly. A necessary and sufﬁcient condition for a function k ( x , x ) to be a valid kernel (ShaweTaylor and Cristianini, 2004) is that the Gram matrix K , whose elements are given by k ( x n , x m ) , should be positive semideﬁnite for all possible choices of the set { x n } . Note that a positive semideﬁnite matrix is not the same thing as a matrix whose elements are nonnegative.

One powerful technique for constructing new kernels is to build them out of simpler kernels as building blocks. This can be done using the following properties:
