[Page 574]

good approximation to the true continuous-time dynamics, it is necessary for the leapfrog integration scale to be smaller than the shortest length-scale over which the potential is varying signiﬁcantly. This is governed by the smallest value of $\sigma_i$, which we denote by $\sigma_{\text{min}}$. Recall that the goal of the leapfrog integration in hybrid Monte Carlo is to move a substantial distance through phase space to a new state that is relatively independent of the initial state and still achieve a high probability of acceptance. In order to achieve this, the leapfrog integration must be continued for a number of iterations of order $\sigma_{\text{max}}/\sigma_{\text{min}}$.

By contrast, consider the behaviour of a simple Metropolis algorithm with an isotropic Gaussian proposal distribution of variance $s^2$, considered earlier. In order to avoid high rejection rates, the value of $s$ must be of order $\sigma_{\text{min}}$. The exploration of state space then proceeds by a random walk and takes of order $(\sigma_{\text{max}}/\sigma_{\text{min}})^2$ steps to arrive at a roughly independent state.

### 11.6. Estimating the Partition Function

As we have seen, most of the sampling algorithms considered in this chapter require only the functional form of the probability distribution up to a multiplicative constant. Thus if we write

$$
p_E(\mathbf{z}) = \frac{1}{Z_E} \exp(-E(\mathbf{z})) \tag{11.71}
$$

then the value of the normalization constant $Z_E$, also known as the partition function, is not needed in order to draw samples from $p(\mathbf{z})$. However, knowledge of the value of $Z_E$ can be useful for Bayesian model comparison since it represents the model evidence (i.e., the probability of the observed data given the model), and so it is of interest to consider how its value might be obtained. We assume that direct evaluation by summing, or integrating, the function $\exp(-E(\mathbf{z}))$ over the state space of $\mathbf{z}$ is intractable.

For model comparison, it is actually the ratio of the partition functions for two models that is required. Multiplication of this ratio by the ratio of prior probabilities gives the ratio of posterior probabilities, which can then be used for model selection or model averaging.

One way to estimate a ratio of partition functions is to use importance sampling from a distribution with energy function $G(\mathbf{z})$

$$
\begin{aligned}
\frac{Z_E}{Z_G} &= \frac{\sum_{\mathbf{z}} \exp(-E(\mathbf{z}))}{\sum_{\mathbf{z}} \exp(-G(\mathbf{z}))} \\
&= \frac{\sum_{\mathbf{z}} \exp(-E(\mathbf{z}) + G(\mathbf{z}))\exp(-G(\mathbf{z}))}{\sum_{\mathbf{z}} \exp(-G(\mathbf{z}))} \\
&= \mathbb{E}_{G(\mathbf{z})}[\exp(-E + G)] \\
&\simeq \frac{1}{L} \sum_{l=1}^L \exp(-E(\mathbf{z}^{(l)}) + G(\mathbf{z}^{(l)})) \tag{11.72}
\end{aligned}
$$
