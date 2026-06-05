[Page 77]

where we have used the fact that −lnx is a convex function, together with the normalization condition q(x)dx = 1. In fact, −lnx is a strictly convex function, so the equality will hold if, and only if, q(x) = p(x) for all x. Thus we can interpret the Kullback-Leibler divergence as a measure of the dissimilarity of the two distributions p(x) and q(x).

We see that there is an intimate relationship between data compression and density estimation (i.e., the problem of modelling an unknown probability distribution) because the most efﬁcient compression is achieved when we know the true distribution. If we use a distribution that is different from the true one, then we must necessarily have a less efﬁcient coding, and on average the additional information that must be transmitted is (at least) equal to the Kullback-Leibler divergence between the two distributions.

Suppose that data is being generated from an unknown distribution $p(x)$ that we wish to model. We can try to approximate this distribution using some parametric distribution $q(x \mid \theta)$, governed by a set of adjustable parameters $\theta$, for example a multivariate Gaussian. One way to determine $\theta$ is to minimize the Kullback-Leibler divergence between $p(x)$ and $q(x \mid \theta)$ with respect to $\theta$. We cannot do this directly because we don’t know $p(x)$. Suppose, however, that we have observed a ﬁnite set of training points $x_n$, for $n = 1, \ldots, N$, drawn from $p(x)$. Then the expectation with respect to $p(x)$ can be approximated by a ﬁnite sum over these points, using (1.35), so that

$$
\mathrm{KL}(p \parallel q) \simeq \sum_{n=1}^{N} \left\{-\ln q(x_n \mid \theta) + \ln p(x_n)\right\}. \tag{1.119}
$$

The second term on the right-hand side of (1.119) is independent of $\theta$, and the ﬁrst term is the negative log likelihood function for $\theta$ under the distribution $q(x \mid \theta)$ evaluated using the training set. Thus we see that minimizing this Kullback-Leibler divergence is equivalent to maximizing the likelihood function.

Now consider the joint distribution between two sets of variables $x$ and $y$ given by $p(x, y)$. If the sets of variables are independent, then their joint distribution will factorize into the product of their marginals $p(x, y) = p(x)p(y)$. If the variables are not independent, we can gain some idea of whether they are ‘close’ to being independent by considering the Kullback-Leibler divergence between the joint distribution and the product of the marginals, given by

$$
I[x, y] \equiv \mathrm{KL}(p(x, y) \parallel p(x)p(y)) = -\iint p(x, y)\ln \frac{p(x)p(y)}{p(x, y)}\, dx\, dy. \tag{1.120}
$$

which is called the mutual information between the variables $x$ and $y$. From the properties of the Kullback-Leibler divergence, we see that $I(x, y) \ge 0$ with equality if, and only if, $x$ and $y$ are independent. Using the sum and product rules of probability, we see that the mutual information is related to the conditional entropy through

$$
I[x, y] = H[x] - H[x \mid y] = H[y] - H[y \mid x]. \tag{1.121}
$$
