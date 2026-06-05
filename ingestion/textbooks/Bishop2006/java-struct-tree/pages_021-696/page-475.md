[Page 475]

then, by continuity, any local maximum of L(q,θ) will also be a local maximum of lnp(X|θ).

Consider the case of N independent data points x1,...,xN with corresponding latent variables z1,...,zN. The joint distribution p(X,Z|θ) factorizes over the data points, and this structure can be exploited in an incremental form of EM in which at each EM cycle only one data point is processed at a time. In the E step, instead of recomputing the responsibilities for all of the data points, we just re-evaluate the responsibilities for one data point. It might appear that the subsequent M step would require computation involving the responsibilities for all of the data points. However, if the mixture components are members of the exponential family, then the responsibilities enter only through simple sufﬁcient statistics, and these can be updated efﬁciently. Consider, for instance, the case of a Gaussian mixture, and suppose we perform an update for data point m in which the corresponding old and new values of the responsibilities are denoted γold(zmk) and γnew(zmk). In the M step, the required sufﬁcient statistics can be updated incrementally. For instance, for the

Exercise 9.26 means the sufﬁcient statistics are deﬁned by (9.17) and (9.18) from which we obtain

µnewk = µoldk + �

�

γnew(zmk) − γold(zmk) Nknew

�

�

xm − µoldk

(9.78)

together with

Nknew = Nkold + γnew(zmk) − γold(zmk). (9.79) The corresponding results for the covariances and the mixing coefﬁcients are analogous.

Thus both the E step and the M step take ﬁxed time that is independent of the total number of data points. Because the parameters are revised after each data point, rather than waiting until after the whole data set is processed, this incremental version can converge faster than the batch version. Each E or M step in this incremental algorithm is increasing the value of L(q,θ) and, as we have shown above, if the algorithm converges to a local (or global) maximum of L(q,θ), this will correspond to a local (or global) maximum of the log likelihood function lnp(X|θ).

Exercises

9.1 (�) www Consider the K-means algorithm discussed in Section 9.1. Show that as a consequence of there being a ﬁnite number of possible assignments for the set of discrete indicator variables rnk, and that for each such assignment there is a unique optimum for the {µk}, the K-means algorithm must converge after a ﬁnite number of iterations.

9.2 (�) Apply the Robbins-Monro sequential estimation procedure described in Section 2.3.5 to the problem of ﬁnding the roots of the regression function given by the derivatives of J in (9.1) with respect to µk. Show that this leads to a stochastic K-means algorithm in which, for each data point xn, the nearest prototype µk is updated using (9.5).
