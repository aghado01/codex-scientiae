[Page 372]

Figure 7.11 Plots of the log marginal likelihood $\lambda(\alpha_i)$ versus $\ln \alpha_i$ showing on the left, the single maximum at a ﬁnite $\alpha_i$ for $q_i^2 = 4$ and $s_i = 1$ (so that $q_i^2 > s_i$) and on the right, the maximum at $\alpha_i = \infty$ for $q_i^2 = 1$ and $s_i = 2$ (so that $q_i^2 < s_i$).

![The image consists of two graphs, each with a blue line and a blue dashed line. The graph on the left side is titled (-5, -5), and the graph on the right side is titled (-5, -5). Both graphs have a blue dashed line that is not drawn. The graph on the left side has a positive slope, while the graph on the right side has a negative slope. The slope of the graph on the left side is positive, while the slope of the graph on the right side is negative. The graph on the left side has a horizontal axis labeled (-5, -5), while the graph on the right side has a vertical axis labeled (-5, -5). The horizontal axis is labeled (-5, -5), while the vertical axis is labeled (-5, -5). The graph on the left side has a positive slope, while the graph on the right side has a negative slope.](../images/imageFile157.png)

is more likely to be pruned from the model. The ‘sparsity’ measures the extent to which basis function $\boldsymbol{\phi}_i$ overlaps with the other basis vectors in the model, and the ‘quality’ represents a measure of the alignment of the basis vector $\boldsymbol{\phi}_n$ with the error between the training set values $\mathbf{t} = (t_1, \ldots, t_N)^T$ and the vector $\mathbf{y}_{-i}$ of predictions that would result from the model with the vector $\boldsymbol{\phi}_i$ excluded (Tipping and Faul, 2003).

The stationary points of the marginal likelihood with respect to $\alpha_i$ occur when the derivative

$$
\frac{d\lambda(\alpha_i)}{d\alpha_i} = \frac{\alpha_i^{-1}s_i^2 - (q_i^2 - s_i)}{2(\alpha_i + s_i)^2} \tag{7.100}
$$

is equal to zero. There are two possible forms for the solution. Recalling that $\alpha_i \geqslant 0$, we see that if $q_i^2 < s_i$, then $\alpha_i \rightarrow \infty$ provides a solution. Conversely, if $q_i^2 > s_i$, we can solve for $\alpha_i$ to obtain

$$
\alpha_i = \frac{s_i^2}{q_i^2 - s_i}. \tag{7.101}
$$

These two solutions are illustrated in Figure 7.11. We see that the relative size of the quality and sparsity terms determines whether a particular basis vector will be pruned from the model or not. A more complete analysis (Faul and Tipping, 2002), based on the second derivatives of the marginal likelihood, conﬁrms these solutions are indeed the unique maxima of $\lambda(\alpha_i)$.

Note that this approach has yielded a closed-form solution for $\alpha_i$, for given values of the other hyperparameters. As well as providing insight into the origin of sparsity in the RVM, this analysis also leads to a practical algorithm for optimizing the hyperparameters that has signiﬁcant speed advantages. This uses a ﬁxed set of candidate basis vectors, and then cycles through them in turn to decide whether each vector should be included in the model or not. The resulting sequential sparse Bayesian learning algorithm is described below.

###### Sequential Sparse Bayesian Learning Algorithm

1. If solving a regression problem, initialize $\beta$.
2. Initialize using one basis function $\boldsymbol{\phi}_1$, with hyperparameter $\alpha_1$ set using (7.101), with the remaining hyperparameters $\alpha_j$ for $j \neq i$ initialized to inﬁnity, so that only $\boldsymbol{\phi}_1$ is included in the model.
