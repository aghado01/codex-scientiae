[Page 293]

Figure 5.19 On the left is the data set for a simple ‘forward problem’ in which the red curve shows the result of ﬁtting a two-layer neural network by minimizing the sum-of-squares error function. The corresponding inverse problem, shown on the right, is obtained by exchanging the roles of x and t. Here the same network trained again by minimizing the sum-of-squares error function gives a very poor ﬁt to the data due to the multimodality of the data set.

1

0

0 1

1

0

0 1

by computing the function xn + 0.3sin(2πxn) and then adding uniform noise over the interval (−0.1,0.1). The inverse problem is then obtained by keeping the same data points but exchanging the roles of x and t. Figure 5.19 shows the data sets for the forward and inverse problems, along with the results of ﬁtting two-layer neural networks having 6 hidden units and a single linear output unit by minimizing a sumof-squares error function. Least squares corresponds to maximum likelihood under a Gaussian assumption. We see that this leads to a very poor model for the highly non-Gaussian inverse problem.

We therefore seek a general framework for modelling conditional probability distributions. This can be achieved by using a mixture model for p(t|x) in which both the mixing coefﬁcients as well as the component densities are ﬂexible functions of the input vector x, giving rise to the mixture density network. For any given value of x, the mixture model provides a general formalism for modelling an arbitrary conditional density function p(t|x). Provided we consider a sufﬁciently ﬂexible network, we then have a framework for approximating arbitrary conditional distributions.

Here we shall develop the model explicitly for Gaussian components, so that

�K

πk(x)N �

�

t|µk(x),σk2(x)

p(t|x) =

. (5.148)

k=1

This is an example of a heteroscedastic model since the noise variance on the data is a function of the input vector x. Instead of Gaussians, we can use other distributions for the components, such as Bernoulli distributions if the target variables are binary rather than continuous. We have also specialized to the case of isotropic covariances for the components, although the mixture density network can readily be extended to allow for general covariance matrices by representing the covariances using a Cholesky factorization (Williams, 1996). Even with isotropic components, the conditional distribution p(t|x) does not assume factorization with respect to the components of t (in contrast to the standard sum-of-squares regression model) as a consequence of the mixture distribution.

We now take the various parameters of the mixture model, namely the mixing coefﬁcients πk(x), the means µk(x), and the variances σk2(x), to be governed by
