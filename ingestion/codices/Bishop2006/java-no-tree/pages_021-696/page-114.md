[Page 114]

which is the mean of the observed set of data points. The maximization of (2.118) with respect to Σ is rather more involved. The simplest approach is to ignore the

- Exercise 2.34 symmetry constraint and show that the resulting solution is symmetric as required. Alternative derivations of this result, which impose the symmetry and positive deﬁniteness constraints explicitly, can be found in Magnus and Neudecker (1999). The result is as expected and takes the form

ΣML =

1 N

N

n=1

(xn − µML)(xn − µML)T (2.122)

which involves µML because this is the result of a joint maximization with respect to µ and Σ. Note that the solution (2.121) for µML does not depend on ΣML, and so we can ﬁrst evaluate µML and then use this to evaluate ΣML.

If we evaluate the expectations of the maximum likelihood solutions under the

- Exercise 2.35 true distribution, we obtain the following results


E[µML] = µ (2.123) E[ΣML] =

N − 1 N

Σ. (2.124)

We see that the expectation of the maximum likelihood estimate for the mean is equal to the true mean. However, the maximum likelihood estimate for the covariance has an expectation that is less than the true value, and hence it is biased. We can correct this bias by deﬁning a different estimator Σ given by

N

1 N − 1

Σ =

(xn − µML)(xn − µML)T. (2.125)

n=1

Clearly from (2.122) and (2.124), the expectation of Σ is equal to Σ.

###### 2.3.5 Sequential estimation

Our discussion of the maximum likelihood solution for the parameters of a Gaussian distribution provides a convenient opportunity to give a more general discussion of the topic of sequential estimation for maximum likelihood. Sequential methods allow data points to be processed one at a time and then discarded and are important for on-line applications, and also where large data sets are involved so that batch processing of all data points at once is infeasible.

Consider the result (2.121) for the maximum likelihood estimator of the mean µML, which we will denote by µ(MLN) when it is based on N observations. If we
