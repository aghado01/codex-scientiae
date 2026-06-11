[Page 539]

- 10.13 ( ) www Starting from (10.54), derive the result (10.59) for the optimum vari-

ational posterior distribution over µk and Λk in the Bayesian mixture of Gaussians, and hence verify the expressions for the parameters of this distribution given by (10.60)–(10.63).

- 10.14 ( ) Using the distribution (10.59), verify the result (10.64).
- 10.15 ( ) Using the result (B.17), show that the expected value of the mixing coefﬁcients in the variational mixture of Gaussians is given by (10.69).
- 10.16 ( ) www Verify the results (10.71) and (10.72) for the ﬁrst two terms in the lower bound for the variational Gaussian mixture model given by (10.70).

- 10.17 ( ) Verify the results (10.73)–(10.77) for the remaining terms in the lower bound for the variational Gaussian mixture model given by (10.70).
- 10.18 ( ) In this exercise, we shall derive the variational re-estimation equations for the Gaussian mixture model by direct differentiation of the lower bound. To do this we assume that the variational distribution has the factorization deﬁned by (10.42) and (10.55) with factors given by (10.48), (10.57), and (10.59). Substitute these into (10.70) and hence obtain the lower bound as a function of the parameters of the variational distribution. Then, by maximizing the bound with respect to these parameters, derive the re-estimation equations for the factors in the variational distribution, and show that these are the same as those obtained in Section 10.2.1.
- 10.19 ( ) Derive the result (10.81) for the predictive distribution in the variational treatment of the Bayesian mixture of Gaussians model.
- 10.20 ( ) www This exercise explores the variational Bayes solution for the mixture of Gaussians model when the size N of the data set is large and shows that it reduces (as we would expect) to the maximum likelihood solution based on EM derived in Chapter 9. Note that results from Appendix B may be used to help answer this exercise.

First show that the posterior distribution q (Λk) of the precisions becomes sharply peaked around the maximum likelihood solution. Do the same for the posterior dis-

tribution of the means q (µk|Λk). Next consider the posterior distribution q (π) for the mixing coefﬁcients and show that this too becomes sharply peaked around the maximum likelihood solution. Similarly, show that the responsibilities become equal to the corresponding maximum likelihood values for large N, by making use of the following asymptotic result for the digamma function for large x

ψ(x) = lnx + O (1/x). (10.241)

Finally, by making use of (10.80), show that for large N, the predictive distribution becomes a mixture of Gaussians.

- 10.21 ( ) Show that the number of equivalent parameter settings due to interchange symmetries in a mixture model with K components is K!.
