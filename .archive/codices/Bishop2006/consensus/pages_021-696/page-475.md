[Page 475]

then, by continuity, any local maximum of $\mathcal{L}(q,\boldsymbol{\theta})$ will also be a local maximum of $\ln p(\mathbf{X}|\boldsymbol{\theta})$.

Consider the case of $N$ independent data points $\mathbf{x}_1,\dots,\mathbf{x}_N$ with corresponding latent variables $\mathbf{z}_1,\dots,\mathbf{z}_N$. The joint distribution $p(\mathbf{X},\mathbf{Z}|\boldsymbol{\theta})$ factorizes over the data points, and this structure can be exploited in an incremental form of EM in which at each EM cycle only one data point is processed at a time. In the E step, instead of recomputing the responsibilities for all of the data points, we just re-evaluate the responsibilities for one data point. It might appear that the subsequent M step would require computation involving the responsibilities for all of the data points. However, if the mixture components are members of the exponential family, then the responsibilities enter only through simple sufﬁcient statistics, and these can be updated efﬁciently. Consider, for instance, the case of a Gaussian mixture, and suppose we perform an update for data point $m$ in which the corresponding old and new values of the responsibilities are denoted $\gamma^{\text{old}}(z_{mk})$ and $\gamma^{\text{new}}(z_{mk})$. In the M step, the required sufﬁcient statistics can be updated incrementally. For instance, for the means the sufﬁcient statistics are deﬁned by (9.17) and (9.18) from which we obtain

$$
\boldsymbol{\mu}_k^{\text{new}} = \boldsymbol{\mu}_k^{\text{old}} + \left( \frac{\gamma^{\text{new}}(z_{mk}) - \gamma^{\text{old}}(z_{mk})}{N_k^{\text{new}}} \right) (\mathbf{x}_m - \boldsymbol{\mu}_k^{\text{old}}) \tag{9.78}
$$

together with

$$
N_k^{\text{new}} = N_k^{\text{old}} + \gamma^{\text{new}}(z_{mk}) - \gamma^{\text{old}}(z_{mk}). \tag{9.79}
$$

The corresponding results for the covariances and the mixing coefﬁcients are analogous.

Thus both the E step and the M step take ﬁxed time that is independent of the total number of data points. Because the parameters are revised after each data point, rather than waiting until after the whole data set is processed, this incremental version can converge faster than the batch version. Each E or M step in this incremental algorithm is increasing the value of $\mathcal{L}(q,\boldsymbol{\theta})$ and, as we have shown above, if the algorithm converges to a local (or global) maximum of $\mathcal{L}(q,\boldsymbol{\theta})$, this will correspond to a local (or global) maximum of the log likelihood function $\ln p(\mathbf{X}|\boldsymbol{\theta})$.

### Exercises

9.1 ( $\star$ ) www Consider the $K$-means algorithm discussed in Section 9.1. Show that as a consequence of there being a ﬁnite number of possible assignments for the set of discrete indicator variables $r_{nk}$, and that for each such assignment there is a unique optimum for the $\{\boldsymbol{\mu}_k\}$, the $K$-means algorithm must converge after a ﬁnite number of iterations.

9.2 ( $\star$ ) Apply the Robbins-Monro sequential estimation procedure described in Section 2.3.5 to the problem of ﬁnding the roots of the regression function given by the derivatives of $J$ in (9.1) with respect to $\boldsymbol{\mu}_k$. Show that this leads to a stochastic $K$-means algorithm in which, for each data point $\mathbf{x}_n$, the nearest prototype $\boldsymbol{\mu}_k$ is updated using (9.5).
