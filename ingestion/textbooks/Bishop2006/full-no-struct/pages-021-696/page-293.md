[Page 293]

Figure 5.19 On the left is the data set for a simple ‘forward problem’ in which the red curve shows the result of ﬁtting a two-layer neural network by minimizing the sum-of-squares error function. The corresponding inverse problem, shown on the right, is obtained by exchanging the roles of x and t . Here the same network trained again by minimizing the sum-of-squares error function gives a very poor ﬁt to the data due to the multimodality of the data set.

![The image is a scatter plot with two sets of data points. The x-axis is labeled 1 and the y-axis is labeled 0. The data points are represented by green dots. The plot shows a downward trend over the years, with the lowest points being around 0.1 and 0.2. The highest points are around 0.5. The trend is not linear, but rather a downward trend.](../images/imageFile125.png)

1

1

0

0

0

1

0

1

by computing the function x n + 0 . 3sin(2 πx n ) and then adding uniform noise over the interval ( − 0 . 1 , 0 . 1) . The inverse problem is then obtained by keeping the same data points but exchanging the roles of x and t . Figure 5.19 shows the data sets for the forward and inverse problems, along with the results of ﬁtting two-layer neural networks having 6 hidden units and a single linear output unit by minimizing a sumof-squares error function. Least squares corresponds to maximum likelihood under a Gaussian assumption. We see that this leads to a very poor model for the highly non-Gaussian inverse problem.

We therefore seek a general framework for modelling conditional probability distributions. This can be achieved by using a mixture model for p ( t | x ) in which both the mixing coefﬁcients as well as the component densities are ﬂexible functions of the input vector x , giving rise to the mixture density network . For any given value of x , the mixture model provides a general formalism for modelling an arbitrary conditional density function p ( t | x ) . Provided we consider a sufﬁciently ﬂexible network, we then have a framework for approximating arbitrary conditional distributions.

Here we shall develop the model explicitly for Gaussian components, so that

$$
p ( t | x ) = \sum _ { k = 1 } ^ { K } \pi _ { k } ( x ) \mathcal { N } \left ( t | \mu _ { k } ( x ) , \sigma _ { k } ^ { 2 } ( x ) \right ) . \\ \text {example of a heteroscedastic model since the noise variance on the data}
$$

This is an example of a heteroscedastic model since the noise variance on the data is a function of the input vector x . Instead of Gaussians, we can use other distributions for the components, such as Bernoulli distributions if the target variables are binary rather than continuous. We have also specialized to the case of isotropic covariances for the components, although the mixture density network can readily be extended to allow for general covariance matrices by representing the covariances using a Cholesky factorization (Williams, 1996). Even with isotropic components, the conditional distribution p ( t | x ) does not assume factorization with respect to the components of t (in contrast to the standard sum-of-squares regression model) as a consequence of the mixture distribution.

We now take the various parameters of the mixture model, namely the mixing coefficients π k ( x ) , the means µ k ( x ) , and the variances σ 2 k ( x ) , to be governed by the outputs of a conventional neural network that takes x as its input. The structure of this mixture density network is illustrated in Figure 5.20. The mixture density network is closely related to the mixture of experts discussed in Section 14.5.3. The principle difference is that in the mixture density network the same function is used to predict the parameters of all of the component densities as well as the mixing coefficients, and so the nonlinear hidden units are shared amongst the input-dependent functions.
