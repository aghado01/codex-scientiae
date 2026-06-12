[Page 552]

![Figure 11.8](../images/imageFile260.png)

Figure 11.8 Importance sampling addresses the problem of evaluating the expectation of a function $f(\mathbf{z})$ with respect to a distribution $p(\mathbf{z})$ from which it is difﬁcult to draw samples directly. Instead, samples $\{\mathbf{z}^{(l)}\}$ are drawn from a simpler distribution $q(\mathbf{z})$, and the corresponding terms in the summation are weighted by the ratios $p(\mathbf{z}^{(l)})/q(\mathbf{z}^{(l)})$.

Furthermore, the exponential decrease of acceptance rate with dimensionality is a generic feature of rejection sampling. Although rejection can be a useful technique in one or two dimensions it is unsuited to problems of high dimensionality. It can, however, play a role as a subroutine in more sophisticated algorithms for sampling in high dimensional spaces.

### 11.1.4 Importance sampling

One of the principal reasons for wishing to sample from complicated probability distributions is to be able to evaluate expectations of the form (11.1). The technique of importance sampling provides a framework for approximating expectations directly but does not itself provide a mechanism for drawing samples from distribution $p(\mathbf{z})$.

The ﬁnite sum approximation to the expectation, given by (11.2), depends on being able to draw samples from the distribution $p(\mathbf{z})$. Suppose, however, that it is impractical to sample directly from $p(\mathbf{z})$ but that we can evaluate $p(\mathbf{z})$ easily for any given value of $\mathbf{z}$. One simplistic strategy for evaluating expectations would be to discretize $\mathbf{z}$-space into a uniform grid and to evaluate the integrand as a sum of the form

$$
\mathbb{E}[f] \simeq \sum_{l=1}^L p(\mathbf{z}^{(l)}) f(\mathbf{z}^{(l)}). \tag{11.18}
$$

An obvious problem with this approach is that the number of terms in the summation grows exponentially with the dimensionality of $\mathbf{z}$. Furthermore, as we have already noted, the kinds of probability distributions of interest will often have much of their mass conﬁned to relatively small regions of $\mathbf{z}$ space and so uniform sampling will be very inefﬁcient because in high-dimensional problems, only a very small proportion of the samples will make a signiﬁcant contribution to the sum. We would really like to choose the sample points to fall in regions where $p(\mathbf{z})$ is large, or ideally where the product $p(\mathbf{z})f(\mathbf{z})$ is large.

As in the case of rejection sampling, importance sampling is based on the use of a proposal distribution $q(\mathbf{z})$ from which it is easy to draw samples, as illustrated in Figure 11.8. We can then express the expectation in the form of a ﬁnite sum over
