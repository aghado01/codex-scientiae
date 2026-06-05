[Page 114]

Exercise 2.34

Exercise 2.35

which is the mean of the observed set of data points. The maximization of (2.118) with respect to Σ is rather more involved. The simplest approach is to ignore the symmetry constraint and show that the resulting solution is symmetric as required. Alternative derivations of this result, which impose the symmetry and positive deﬁniteness constraints explicitly, can be found in Magnus and Neudecker (1999). The result is as expected and takes the form

$$
\Sigma _ { M L } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu _ { M L } ) ( x _ { n } - \mu _ { M L } ) ^ { T } \\ \text {volves } u \quad \text {because this is the result of a joint maximization with respect}
$$

which involves µ ML because this is the result of a joint maximization with respect to µ and Σ . Note that the solution (2.121) for µ ML does not depend on Σ ML , and so we can ﬁrst evaluate µ ML and then use this to evaluate Σ ML .

If we evaluate the expectations of the maximum likelihood solutions under the true distribution, we obtain the following results

$$
\mathbb { E } [ \mu _ { _ { M L } } ] \ = \ \mu
$$

$$
\mathbb { E } [ \Sigma _ { M L } ] \ = \ \frac { N - 1 } { N } \Sigma .
$$

We see that the expectation of the maximum likelihood estimate for the mean is equal to the true mean. However, the maximum likelihood estimate for the covariance has an expectation that is less than the true value, and hence it is biased. We can correct this bias by deﬁning a different estimator Σ given by

$$
\text {expectation that is less than the true value, and hence it is biased. We can correct
ias by defining a different estimator \widetilde { \Sigma } given by

 \widetilde { \Sigma } = \frac { 1 } { N - 1 } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu _ { M L } ) ( x _ { n } - \mu _ { M L } ) ^ { 1 } . \quad ( 2 . 1 2 5 ) \\ \text {ly from (2.122) and (2.124), the expectation of $\widetilde{ \Sigma}$ is equal to $\Sigma$.}
$$

Clearly from (2.122) and (2.124), the expectation of Σ is equal to Σ . 2.3.5 Sequential estimation Our discussion of the maximum likelihood solution for the parameters of a Gaus-

sian distribution provides a convenient opportunity to give a more general discussion of the topic of sequential estimation for maximum likelihood. Sequential methods allow data points to be processed one at a time and then discarded and are important for on-line applications, and also where large data sets are involved so that batch processing of all data points at once is infeasible.

Consider the result (2.121) for the maximum likelihood estimator of the mean µ ML , which we will denote by µ ( N ) ML when it is based on N observations. If we A schematic illustration of two correlated random variables z and θ , together with the regression function f ( θ ) given by the conditional expectation E [ z | θ ] . The RobbinsMonro algorithm provides a general sequential procedure for finding the root θ /star of such functions.
