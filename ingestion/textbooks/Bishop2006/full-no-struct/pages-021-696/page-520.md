[Page 520]

# Exercise 10.32

This is a quadratic function of w , and so we can obtain the corresponding variational approximation to the posterior distribution by identifying the linear and quadratic terms in w , giving a Gaussian variational posterior of the form

$$
q ( \mathbf w ) = \mathcal { N } ( \mathbf w | \mathbf m _ { N } , \mathbf S _ { N } )
$$

where

$$
m _ { N } \, = \, S _ { N } \left ( S _ { 0 } ^ { - 1 } m _ { 0 } + \sum _ { n = 1 } ^ { N } ( t _ { n } - 1 / 2 ) \phi _ { n } \right ) \quad ( 1 0 . 1 5 ) \\
$$

$$
S _ { N } ^ { - 1 } \, = \, S _ { 0 } ^ { - 1 } + 2 \sum _ { n = 1 } ^ { N } \lambda ( \xi _ { n } ) \phi _ { n } \phi _ { n } ^ { T } . \\ \intertext { t h e l a p l a c e f r a m e w i s } \text {with the Laplace framework, we have again obtained a Gaussian approximation}
$$

As with the Laplace framework, we have again obtained a Gaussian approximation to the posterior distribution. However, the additional ﬂexibility provided by the variational parameters { ξ n } leads to improved accuracy in the approximation (Jaakkola and Jordan, 2000).

Here we have considered a batch learning context in which all of the training data is available at once. However, Bayesian methods are intrinsically well suited to sequential learning in which the data points are processed one at a time and then discarded. The formulation of this variational approach for the sequential case is straightforward.

Note that the bound given by (10.149) applies only to the two-class problem and so this approach does not directly generalize to classiﬁcation problems with K > 2 classes. An alternative bound for the multiclass case has been explored by Gibbs (1997).

# 10.6.2 Optimizing the variational parameters

We now have a normalized Gaussian approximation to the posterior distribution, which we shall use shortly to evaluate the predictive distribution for new data points. First, however, we need to determine the variational parameters { ξ n } by maximizing the lower bound on the marginal likelihood.

To do this, we substitute the inequality (10.152) back into the marginal likelihood to give

$$
h o d \, \text {to give} \\ \ln p ( \mathfrak { t } ) & = \ln \int p ( \mathfrak { t } | w ) p ( w ) \, d w \geqslant \ln \int h ( w , \xi ) p ( w ) \, d w = \mathcal { L } ( \xi ) . \quad ( 1 0 . 1 5 ) \\ \text {As with the optimization of the hyperparameter $\alpha$ in the linear regression model of}
$$

As with the optimization of the hyperparameter α in the linear regression model of Section 3.5, there are two approaches to determining the ξ n . In the ﬁrst approach, we recognize that the function L ( ξ ) is deﬁned by an integration over w and so we can view w as a latent variable and invoke the EM algorithm. In the second approach, we integrate over w analytically and then perform a direct maximization over ξ . Let us begin by considering the EM approach.

The EM algorithm starts by choosing some initial values for the parameters { ξ n } , which we denote collectively by ξ old . In the E step of the EM algorithm,
