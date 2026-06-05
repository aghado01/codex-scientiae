[Page 534]

![The image is a scatter plot with two axes labeled Error and Floops. The x-axis is labeled FLOPS and the y-axis is labeled Eror. There are two sets of data points plotted on the graph. The first set of data points is plotted on the x-axis, and the second set of data points is plotted on the y-axis. The data points are colored in blue, red, green, and orange. The blue color represents the error, the red color represents the error, the green color represents the error, and the orange color represents the error. The graph shows two different sets of data points. The first set of data points is plotted on the x-axis, and the second set of data points is plotted on the y-axis. The data points are colored in green, red, blue, and orange. The green color represents the error, the red color represents the error, the blue color represents](../images/imageFile250.png)

Evidence

Posterior mean

0

10 0

vb

−200

10

Error

Error

vb

laplace

−202

laplace

-5

10

10

ep

ep

−204

10

4

6

4

6

10 4

10 6

10 4

10 6

FLOPS

FLOPS

Figure 10.17 Comparison of expectation propagation, variational inference, and the Laplace approximation on the clutter problem. The left-hand plot shows the error in the predicted posterior mean versus the number of ﬂoating point operations, and the right-hand plot shows the corresponding results for the model evidence.

# Section 8.4.4

We shall focus on the case in which the approximating distribution is fully factorized, and we shall show that in this case expectation propagation reduces to loopy belief propagation (Minka, 2001a). To start with, we show this in the context of a simple example, and then we shall explore the general case.

First of all, recall from (10.17) that if we minimize the Kullback-Leibler divergence KL( p q ) with respect to a factorized distribution q , then the optimal solution for each factor is simply the corresponding marginal of p .

Now consider the factor graph shown on the left in Figure 10.18, which was introduced earlier in the context of the sum-product algorithm. The joint distribution is given by

$$
p ( x ) = f _ { a } ( x _ { 1 } , x _ { 2 } ) f _ { b } ( x _ { 2 } , x _ { 3 } ) f _ { c } ( x _ { 2 } , x _ { 4 } ) .
$$

We seek an approximation q ( x ) that has the same factorization, so that

q ( x ) ∝ f a ( x 1 ,x 2 ) f b ( x 2 ,x 3 ) f c ( x 2 ,x 4 ) . (10.226) Note that normalization constants have been omitted, and these can be re-instated at the end by local normalization, as is generally done in belief propagation. Now suppose we restrict attention to approximations in which the factors themselves factorize with respect to the individual variables so that

q ( x ) ∝ f a 1 ( x 1 ) f a 2 ( x 2 ) f b 2 ( x 2 ) f b 3 ( x 3 ) f c 2 ( x 2 ) f c 4 ( x 4 ) (10.227) which corresponds to the factor graph shown on the right in Figure 10.18. Because the individual factors are factorized, the overall distribution q ( x ) is itself fully factorized.

Now we apply the EP algorithm using the fully factorized approximation. Suppose that we have initialized all of the factors and that we choose to reﬁne factor
