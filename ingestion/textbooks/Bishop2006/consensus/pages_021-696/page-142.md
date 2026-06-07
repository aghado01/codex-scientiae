[Page 142]

this neighbourhood property was deﬁned by the bins, and there is a natural ‘smoothing’ parameter describing the spatial extent of the local region, in this case the bin width. Second, the value of the smoothing parameter should be neither too large nor too small in order to obtain good results. This is reminiscent of the choice of model complexity in polynomial curve ﬁtting discussed in Chapter 1 where the degree $M$ of the polynomial, or alternatively the value $\alpha$ of the regularization parameter, was optimal for some intermediate value, neither too large nor too small. Armed with these insights, we turn now to a discussion of two widely used nonparametric techniques for density estimation, kernel estimators and nearest neighbours, which have better scaling with dimensionality than the simple histogram model.

### 2.5.1 Kernel density estimators

Let us suppose that observations are being drawn from some unknown probability density $p(\mathbf{x})$ in some $D$-dimensional space, which we shall take to be Euclidean, and we wish to estimate the value of $p(\mathbf{x})$. From our earlier discussion of locality, let us consider some small region $\mathcal{R}$ containing $\mathbf{x}$. The probability mass associated with this region is given by
$$
P = \int_{\mathcal{R}} p(\mathbf{x}) \, d\mathbf{x}. \tag{2.242}
$$

Now suppose that we have collected a data set comprising $N$ observations drawn from $p(\mathbf{x})$. Because each data point has a probability $P$ of falling within $\mathcal{R}$, the total number $K$ of points that lie inside $\mathcal{R}$ will be distributed according to the binomial distribution
$$
\text{Bin}(K|N,P) = \frac{N!}{K!(N - K)!} P^K (1 - P)^{1-K}. \tag{2.243}
$$

Using (2.11), we see that the mean fraction of points falling inside the region is $\mathbb{E}[K/N] = P$, and similarly using (2.12) we see that the variance around this mean is $\text{var}[K/N] = P(1 - P)/N$. For large $N$, this distribution will be sharply peaked around the mean and so
$$
K \simeq NP. \tag{2.244}
$$

If, however, we also assume that the region $\mathcal{R}$ is sufﬁciently small that the probability density $p(\mathbf{x})$ is roughly constant over the region, then we have
$$
P \simeq p(\mathbf{x})V \tag{2.245}
$$
where $V$ is the volume of $\mathcal{R}$. Combining (2.244) and (2.245), we obtain our density estimate in the form
$$
p(\mathbf{x}) = \frac{K}{NV}. \tag{2.246}
$$

Note that the validity of (2.246) depends on two contradictory assumptions, namely that the region $\mathcal{R}$ be sufﬁciently small that the density is approximately constant over the region and yet sufﬁciently large (in relation to the value of that density) that the number $K$ of points falling inside the region is sufﬁcient for the binomial distribution to be sharply peaked.
