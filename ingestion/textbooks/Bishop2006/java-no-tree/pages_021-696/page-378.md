[Page 378]

- 7.8 ( ) www For the regression support vector machine considered in Section 7.1.4, show that all training data points for which ξn > 0 will have an = C, and similarly all points for which ξn > 0 will have an = C.

- 7.9 ( ) Verify the results (7.82) and (7.83) for the mean and covariance of the posterior distribution over weights in the regression RVM.
- 7.10 ( ) www Derive the result (7.85) for the marginal likelihood function in the regression RVM, by performing the Gaussian integral over w in (7.84) using the technique of completing the square in the exponential.

- 7.11 ( ) Repeat the above exercise, but this time make use of the general result (2.115).
- 7.12 ( ) www Show that direct maximization of the log marginal likelihood (7.85) for the regression relevance vector machine leads to the re-estimation equations (7.87) and (7.88) where γi is deﬁned by (7.89).

- 7.13 ( ) In the evidence framework for RVM regression, we obtained the re-estimation formulae (7.87) and (7.88) by maximizing the marginal likelihood given by (7.85). Extend this approach by inclusion of hyperpriors given by gamma distributions of the form (B.26) and obtain the corresponding re-estimation formulae for α and β by maximizing the corresponding posterior probability p(t,α,β|X) with respect to α and β.
- 7.14 ( ) Derive the result (7.90) for the predictive distribution in the relevance vector machine for regression. Show that the predictive variance is given by (7.91).
- 7.15 ( ) www Using the results (7.94) and (7.95), show that the marginal likelihood

(7.85) can be written in the form (7.96), where λ(αn) is deﬁned by (7.97) and the sparsity and quality factors are deﬁned by (7.98) and (7.99), respectively.

- 7.16 ( ) By taking the second derivative of the log marginal likelihood (7.97) for the

regression RVM with respect to the hyperparameter αi, show that the stationary point given by (7.101) is a maximum of the marginal likelihood.

- 7.17 ( ) Using (7.83) and (7.86), together with the matrix identity (C.7), show that

the quantities Sn and Qn deﬁned by (7.102) and (7.103) can be written in the form (7.106) and (7.107).

- 7.18 ( ) www Show that the gradient vector and Hessian matrix of the log posterior distribution (7.109) for the classiﬁcation relevance vector machine are given by (7.110) and (7.111).

- 7.19 ( ) Verify that maximization of the approximate log marginal likelihood function (7.114) for the classiﬁcation relevance vector machine leads to the result (7.116) for re-estimation of the hyperparameters.
