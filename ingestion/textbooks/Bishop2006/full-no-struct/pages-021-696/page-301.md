[Page 301]

# Section 3.5.3

Section 5.1.1

$$
\gamma = \sum _ { i = 1 } ^ { W } \frac { \lambda _ { i } } { \alpha + \lambda _ { i } } . \\ \intertext { x e x t for the linear regression case }
$$

Note that this result was exact for the linear regression case. For the nonlinear neural network, however, it ignores the fact that changes in α will cause changes in the Hessian H , which in turn will change the eigenvalues. We have therefore implicitly ignored terms involving the derivatives of λ i with respect to α . Similarly, from (3.95) we see that maximizing the evidence with respect to

Similarly, from (3.95) we see that maximizing the evidence with respect to β gives the re-estimation formula

$$
\frac { 1 } { \beta } = \frac { 1 } { N - \gamma } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w _ { \text {MAP} } ) - t _ { n } \} ^ { 2 } . \\ \intertext { l e a r $ n $ e l d e $ o t h e r $ d y $ e n t a r $ e w e n $ r e $ e s t i m a t i o n $ f t h e h u p e r }
$$

As with the linear model, we need to alternate between re-estimation of the hyperparameters α and β and updating of the posterior distribution. The situation with a neural network model is more complex, however, due to the multimodality of the posterior distribution. As a consequence, the solution for w MAP found by maximizing the log posterior will depend on the initialization of w . Solutions that differ only as a consequence of the interchange and sign reversal symmetries in the hidden units are identical so far as predictions are concerned, and it is irrelevant which of the equivalent solutions is found. However, there may be inequivalent solutions as well, and these will generally yield different values for the optimized hyperparameters.

In order to compare different models, for example neural networks having different numbers of hidden units, we need to evaluate the model evidence p ( D ) . This can be approximated by taking (5.175) and substituting the values of α and β obtained from the iterative optimization of these hyperparameters. A more careful evaluation is obtained by marginalizing over α and β , again by making a Gaussian approximation (MacKay, 1992c; Bishop, 1995a). In either case, it is necessary to evaluate the determinant | A | of the Hessian matrix. This can be problematic in practice because the determinant, unlike the trace, is sensitive to the small eigenvalues that are often difﬁcult to determine accurately.

The Laplace approximation is based on a local quadratic expansion around a mode of the posterior distribution over weights. We have seen in Section 5.1.1 that any given mode in a two-layer network is a member of a set of M !2 M equivalent modes that differ by interchange and sign-change symmetries, where M is the number of hidden units. When comparing networks having different numbers of hidden units, this can be taken into account by multiplying the evidence by a factor of M !2 M .

# 5.7.3 Bayesian neural networks for classiﬁcation

So far, we have used the Laplace approximation to develop a Bayesian treatment of neural network regression models. We now discuss the modiﬁcations to
