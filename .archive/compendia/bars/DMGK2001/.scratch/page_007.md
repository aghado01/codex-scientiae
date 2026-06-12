[Page 7]

Denote by $g(\beta, k, \xi)$ some feature of the curve, such as the location of its maximum, that we wish to estimate. Let $q(\beta \mid y, \xi, k) \propto p(y \mid \beta, k, \xi)\,\pi_\beta(\beta \mid k, \xi)$. The posterior expectation of $g(\beta, k, \xi)$ given $y$ may be computed from

$$
E\{g(\beta, \xi, k) \mid y\}
= \frac{\displaystyle\int\!\cdots\!\int g(\beta, \xi, k)\,\dfrac{q(\beta \mid y, k, \xi)}{\hat{q}(\beta \mid y, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk}{\displaystyle\int\!\cdots\!\int \dfrac{q(\beta \mid y, k, \xi)}{\hat{q}(\beta \mid y, \xi, k)}\,\hat{q}(\beta \mid y, k, \xi)\,p(k, \xi \mid y)\,d\beta\,d\xi\,dk}
\approx \frac{\sum_l g(\beta^{(l)}, \xi^{(l)}, k^{(l)})\,w(\beta^{(l)}, \xi^{(l)}, k^{(l)})}{\sum_l w(\beta^{(l)}, \xi^{(l)}, k^{(l)})}
$$

where

$$
w(\beta^{(l)}, \xi^{(l)}, k^{(l)}) = \frac{q(\beta^{(l)} \mid y, \xi^{(l)}, k^{(l)})}{\hat{q}(\beta^{(l)} \mid y, \xi^{(l)}, k^{(l)})},
$$

$(\xi^{(l)}, k^{(l)})$ is the pair accepted by the reversible-jump sampler, i.e. sampled from $p(k, \xi \mid y)$, and $\beta^{(l)}$ is sampled from a suitable approximation $\hat{q}$ to the conditional posterior of $\beta$ given $(k, \xi)$. In fact, we may approximate the likelihood function on $\beta$ given $(k, \xi)$ rather than the full conditional posterior, which is typically easier under model (1), yielding weights of the form

$$
w(\beta^{(l)}, \xi^{(l)}, k^{(l)}) = \frac{p(y \mid \beta^{(l)}, \xi^{(l)}, k^{(l)})}{\hat{p}(y \mid \beta^{(l)}, \xi^{(l)}, k^{(l)})}.
$$

A standard choice for $\hat{p}$ would be a multivariate $t$ density (Evans & Swartz, 1995). Verification that the importance weights are correct when $q/\hat{q}$ is replaced by $p/\hat{p}$ is straightforward; see Appendix 2. From this method of computing posterior expectations we may also obtain posterior variances and posterior interval probabilities.

## 4. Simulation Study

Our implementation has two key features: first, we use a fully Bayesian approach, together with a BIC approximation to the marginal density (4) and, secondly, we use the locality heuristic of Zhou & Shen (2001) to place new knots. Both of these choices may be contrasted with the implementation of Denison et al. (1998). In our simulation study we compute mean squared error for our Bayesian adaptive regression splines and compare with spatially adaptive regression splines, using the software of Zhou & Shen (2001), and with the Denison et al. method, using software available at http://www.ma.ic.ac.uk/~dgtd. We also investigate the relative importance of the two implementation changes by comparing with what we call the modified Denison et al. method, which includes the BIC approximation but not the change in candidate knot locations; we computed the modified Denison et al. method by inserting the required factor $1/\sqrt{n}$ into their code and recompiling. The Bayesian adaptive regression spline estimates of $E\{f(x) \mid y\} = E[E\{f(x) \mid y, k, \xi\}]$ are found from our Markov chain Monte Carlo with runs of length 10,000 following burn-ins of 1000.

In this section we consider three functions: a slowly-varying smooth function, a function with a sharp peak, that is spatially inhomogeneously smooth, and a function with a discontinuity. Noise is added to each in generating the data. The functions together with samples of data are shown in Fig. 1.
