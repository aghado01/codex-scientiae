[Page 16]

## Appendix 2

### Importance Sampling

We wish to determine the weight for our problem. If $g(\beta, k, \xi)$ is the functional of interest, we need to compute $E\{g(\beta, \xi, k) \mid y\} = A/B$, say, where

$$
A = \frac{\hat{p}(y)}{p(y)}\int\!\cdots\!\int g(\beta, \xi, k)\,\frac{p(y \mid \beta, k, \xi)}{\hat{p}(y \mid \beta, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk,
$$

$$
B = \frac{\hat{p}(y)}{p(y)}\int\!\cdots\!\int \frac{p(y \mid \beta, k, \xi)}{\hat{p}(y \mid \beta, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk.
$$

Therefore

$$
E\{g(\beta, \xi, k) \mid y\}
= \frac{\displaystyle\int\!\cdots\!\int g(\beta, \xi, k)\,\dfrac{p(y \mid \beta, k, \xi)}{\hat{p}(y \mid \beta, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk}{\displaystyle\int\!\cdots\!\int \dfrac{p(y \mid \beta, k, \xi)}{\hat{p}(y \mid \beta, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk}
\approx \frac{\sum_l g(\beta^{(l)}, \xi^{(l)}, k^{(l)})\,w(\beta^{(l)}, \xi^{(l)}, k^{(l)})}{\sum_l w(\beta^{(l)}, \xi^{(l)}, k^{(l)})},
$$

where

$$
w(\beta^{(l)}, \xi^{(l)}, k^{(l)}) = \frac{p(y \mid \beta^{(l)}, \xi^{(l)}, k^{(l)})}{\hat{p}(y \mid \beta^{(l)}, \xi^{(l)}, k^{(l)})},
$$

$(\xi^{(l)}, k^{(l)})$ is the pair accepted by the reversible-jump sampler, i.e. is sampled from $p(k, \xi \mid y)$, and $\beta^{(l)}$ is sampled from $\hat{q}(\beta \mid y, \xi^{(l)}, k^{(l)})$.

## Appendix 3

### Posterior Approximations

First, we elaborate on the essential property of the BIC-based approximation we are using. Let $\hat{p}(y \mid k, \xi)$ be the approximation to $p(y \mid k, \xi)$ and assume that $k \leqslant K$ for some fixed $K$. Then, from Laplace's method, $\hat{p}(y \mid k, \xi) = p(y \mid k, \xi)\{1 + O_p(n^{-1/2})\}$ uniformly in $(k, \xi)$. Here, $O_p$ refers to the sampling distribution of the data. Let us use $\Pr$ to denote probabilities under this sampling distribution and let $\Xi$ denote the space of $(k, \xi)$ values. It follows by integration that, for any arbitrarily small positive $\eta$, there exists a bound $M$ such that, for all measurable subsets $A \subseteq \Xi$ and for all
