[Page 620]

![image 157](../../../../../images/imageFile157.png)

600 12. CONTINUOUS LATENT VARIABLES

the eigenvectors of S. Because these solutions are all equivalent, it is convenient to choose the eigenvector solution.

12.3 (*) Verify that the eigenvectors defined by (12.30) are normalized to unit length,

assuming that the eigenvectors Vi have unit length.

12.4 (*) Imm Suppose we replace the zero-mean, unit-covariance latent space distribution (12.31) in the probabilistic PCA model by a general Gaussian distribution of the formN(zlm, ~). By redefining the parameters ofthe model, show that this leads to an identical model for the marginal distribution p(x) over the observed variables for any valid choice of m and ~.

12.5 (**) Let x be a D-dimensional random variable having a Gaussian distribution given by N(xIJL, ~), and consider the M-dimensional random variable given by y = Ax + b where A is an M x D matrix. Show that y also has a Gaussian distribution, and find expressions for its mean and covariance. Discuss the form of this Gaussian distribution for M < D, for M = D, and for M > D.

12.6 (*) Imm Draw a directed probabilistic graph for the probabilistic PCA model described in Section 12.2 in which the components of the observed variable x are shown explicitly as separate nodes. Hence verify that the probabilistic PCA model has the same independence structure as the naive Bayes model discussed in Section 8.2.2.

12.7 (**) By making use of the results (2.270) and (2.271) for the mean and covariance of a general distribution, derive the result (12.35) for the marginal distribution p(x) in the probabilistic PCA model.

12.8 (**)Imm Bymakinguseoftheresult(2.116), showthattheposteriordistribution

p(zlx) for the probabilistic PCA model is given by (12.42).

12.9 (*) Verify that maximizing the log likelihood (12.43) for the probabilistic PCA model with respect to the parameter JL gives the result JLML = x where x is the mean of the data vectors.

12.10 (**) By evaluating the second derivatives of the log likelihood function (12.43) for the probabilistic PCA model with respect to the parameter JL, show that the stationary point JLML = x represents the unique maximum.

12.11 (**)Imm Showthat in the limit (Y2 -. 0, the posteriormean for theprobabilistic PCA model becomes an orthogonal projection onto the principal subspace, as in conventional PCA.

12.12 (**) For (Y2 > 0 show that the posterior mean in the probabilistic PCA model is

shifted towards the origin relative to the orthogonal projection.

12.13 (* *) Show that the optimal reconstruction of a data point under probabilistic PCA,

according to the least squares projection cost of conventional PCA, is given by (12.94)
