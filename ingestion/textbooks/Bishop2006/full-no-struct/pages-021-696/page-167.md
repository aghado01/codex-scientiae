[Page 167]

Exercise 3.6

As before, we can maximize this function with respect to W , giving

$$
W _ { M L } = ( \Phi ^ { T } \Phi ) ^ { - 1 } \, \Phi ^ { T } T . \\ \text {result for each target variable} \, t _ { k } , \, \text {we have}
$$

If we examine this result for each target variable t k , we have

$$
w _ { k } = ( \Phi ^ { T } \Phi ) ^ { - 1 } \, \Phi ^ { T } t _ { k } = \Phi ^ { \dagger } t _ { k } \\ V \text {-dimensional column vector with components } t _ { n k } \text { for } n = 1 , \dots N . \\ \intertext { w h e r s } \intertext { w h e r s } V \text {-dimensional column vector with components } t _ { n k } \text { for } n = 1 , \dots N . \\ \intertext { w h e r s } \intertext { o n t h e r s } \intertext { r e g r e s s } \intertext { i n g r e s s } \intertext { p l e c h s } \intertext { s u p s }
$$

where t k is an N -dimensional column vector with components t nk for n = 1 ,...N . Thus the solution to the regression problem decouples between the different target variables, and we need only compute a single pseudo-inverse matrix Φ † , which is shared by all of the vectors w k . The extension to general Gaussian noise distributions having arbitrary covari-

ance matrices is straightforward. Again, this leads to a decoupling into K independent regression problems. This result is unsurprising because the parameters W deﬁne only the mean of the Gaussian noise distribution, and we know from Section 2.3.4 that the maximum likelihood solution for the mean of a multivariate Gaussian is independent of the covariance. From now on, we shall therefore consider a single target variable t for simplicity.

# 3.2. The Bias-Variance Decomposition

So far in our discussion of linear models for regression, we have assumed that the form and number of basis functions are both ﬁxed. As we have seen in Chapter 1, the use of maximum likelihood, or equivalently least squares, can lead to severe over-ﬁtting if complex models are trained using data sets of limited size. However, limiting the number of basis functions in order to avoid over-ﬁtting has the side effect of limiting the ﬂexibility of the model to capture interesting and important trends in the data. Although the introduction of regularization terms can control over-ﬁtting for models with many parameters, this raises the question of how to determine a suitable value for the regularization coefﬁcient λ . Seeking the solution that minimizes the regularized error function with respect to both the weight vector w and the regularization coefﬁcient λ is clearly not the right approach since this leads to the unregularized solution with λ = 0 .

As we have seen in earlier chapters, the phenomenon of over-ﬁtting is really an unfortunate property of maximum likelihood and does not arise when we marginalize over parameters in a Bayesian setting. In this chapter, we shall consider the Bayesian view of model complexity in some depth. Before doing so, however, it is instructive to consider a frequentist viewpoint of the model complexity issue, known as the biasvariance trade-off. Although we shall introduce this concept in the context of linear basis function models, where it is easy to illustrate the ideas using simple examples, the discussion has more general applicability.

In Section 1.5.5, when we discussed decision theory for regression problems, we considered various loss functions each of which leads to a corresponding optimal prediction once we are given the conditional distribution p ( t | x ) . A popular choice is
