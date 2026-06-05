[Page 551]

Figure 11.7 Illustrative example of rejection sampling involving sampling from a Gaussian distribution p(z) shown by the green curve, by using rejection sampling from a proposal distribution q(z) that is also Gaussian and whose scaled version kq(z) is shown by the red curve.

0.5

p(z)

0.25

0

−5 0 5

z

of linear functions, and hence the envelope distribution itself comprises a piecewise exponential distribution of the form

q(z) = kiλi exp{−λi(z − zi−1)} zi−1 < z � zi. (11.17)

Once a sample has been drawn, the usual rejection criterion can be applied. If the sample is accepted, then it will be a draw from the desired distribution. If, however, the sample is rejected, then it is incorporated into the set of grid points, a new tangent line is computed, and the envelope function is thereby reﬁned. As the number of grid points increases, so the envelope function becomes a better approximation of the desired distribution p(z) and the probability of rejection decreases.

A variant of the algorithm exists that avoids the evaluation of derivatives (Gilks, 1992). The adaptive rejection sampling framework can also be extended to distributions that are not log concave, simply by following each rejection sampling step with a Metropolis-Hastings step (to be discussed in Section 11.2.2), giving rise to adaptive rejection Metropolis sampling (Gilks et al., 1995).

Clearly for rejection sampling to be of practical value, we require that the comparison function be close to the required distribution so that the rate of rejection is kept to a minimum. Now let us examine what happens when we try to use rejection sampling in spaces of high dimensionality. Consider, for the sake of illustration, a somewhat artiﬁcial problem in which we wish to sample from a zero-mean multivariate Gaussian distribution with covariance σp2I, where I is the unit matrix, by rejection sampling from a proposal distribution that is itself a zero-mean Gaussian distribution having covariance σq2I. Obviously, we must have σq2 � σp2 in order that there exists a k such that kq(z) � p(z). In D-dimensions the optimum value of k is given by k = (σq/σp)D, as illustrated for D = 1 in Figure 11.7. The acceptance rate will be the ratio of volumes under p(z) and kq(z), which, because both distributions are normalized, is just 1/k. Thus the acceptance rate diminishes exponentially with dimensionality. Even if σq exceeds σp by just one percent, for D = 1,000 the acceptance ratio will be approximately 1/20,000. In this illustrative example the comparison function is close to the required distribution. For more practical examples, where the desired distribution may be multimodal and sharply peaked, it will be extremely difﬁcult to ﬁnd a good proposal distribution and comparison function.
