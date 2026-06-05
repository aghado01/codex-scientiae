[Page 237]

where θMAP is the value of θ at the mode of the posterior distribution, and A is the Hessian matrix of second derivatives of the negative log posterior

A = −∇∇lnp(D|θMAP)p(θMAP) = −∇∇lnp(θMAP|D). (4.138)

The ﬁrst term on the right hand side of (4.137) represents the log likelihood evaluated using the optimized parameters, while the remaining three terms comprise the ‘Occam factor’ which penalizes model complexity.

If we assume that the Gaussian prior distribution over parameters is broad, and

- Exercise 4.23 that the Hessian has full rank, then we can approximate (4.137) very roughly using


lnp(D) lnp(D|θMAP) −

1 2

M lnN (4.139)

where N is the number of data points, M is the number of parameters in θ and we have omitted additive constants. This is known as the Bayesian Information Criterion (BIC) or the Schwarz criterion (Schwarz, 1978). Note that, compared to AIC given by (1.73), this penalizes model complexity more heavily.

Complexity measures such as AIC and BIC have the virtue of being easy to evaluate, but can also give misleading results. In particular, the assumption that the Hessian matrix has full rank is often not valid since many of the parameters are not

Section 3.5.3 ‘well-determined’. We can use the result (4.137) to obtain a more accurate estimate of the model evidence starting from the Laplace approximation, as we illustrate in the context of neural networks in Section 5.7.

###### 4.5. Bayesian Logistic Regression

We now turn to a Bayesian treatment of logistic regression. Exact Bayesian inference for logistic regression is intractable. In particular, evaluation of the posterior distribution would require normalization of the product of a prior distribution and a likelihood function that itself comprises a product of logistic sigmoid functions, one for every data point. Evaluation of the predictive distribution is similarly intractable. Here we consider the application of the Laplace approximation to the problem of Bayesian logistic regression (Spiegelhalter and Lauritzen, 1990; MacKay, 1992b).

###### 4.5.1 Laplace approximation

Recall from Section 4.4 that the Laplace approximation is obtained by ﬁnding the mode of the posterior distribution and then ﬁtting a Gaussian centred at that mode. This requires evaluation of the second derivatives of the log posterior, which is equivalent to ﬁnding the Hessian matrix.

Because we seek a Gaussian representation for the posterior distribution, it is natural to begin with a Gaussian prior, which we write in the general form

p(w) = N(w|m0,S0) (4.140)
