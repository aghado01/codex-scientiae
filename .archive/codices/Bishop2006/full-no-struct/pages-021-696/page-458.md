[Page 458]

Note that the EM algorithm takes many more iterations to reach (approximate) convergence compared with the K -means algorithm, and that each cycle requires signiﬁcantly more computation. It is therefore common to run the K -means algorithm in order to ﬁnd a suitable initialization for a Gaussian mixture model that is subsequently adapted using EM. The covariance matrices can conveniently be initialized to the sample covariances of the clusters found by the K -means algorithm, and the mixing coefﬁcients can be set to the fractions of data points assigned to the respective clusters. As with gradient-based approaches for maximizing the log likelihood, techniques must be employed to avoid singularities of the likelihood function in which a Gaussian component collapses onto a particular data point. It should be emphasized that there will generally be multiple local maxima of the log likelihood function, and that EM is not guaranteed to ﬁnd the largest of these maxima. Because the EM algorithm for Gaussian mixtures plays such an important role, we summarize it below.

# EM for Gaussian Mixtures

Given a Gaussian mixture model, the goal is to maximize the likelihood function with respect to the parameters (comprising the means and covariances of the components and the mixing coefﬁcients).

- 1. Initialize the means µ k , covariances Σ k and mixing coefﬁcients π k , and evaluate the initial value of the log likelihood.
- 2. E step . Evaluate the responsibilities using the current parameter values

$$
\gamma ( z _ { n k } ) = \frac { \pi _ { k } \mathcal { N } ( x _ { n } | \mu _ { k } , \Sigma _ { k } ) } { K } .
$$
