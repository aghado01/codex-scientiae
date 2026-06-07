[Page 692]

The M step involves maximization of this function with respect to $\boldsymbol{\theta}$, keeping $\boldsymbol{\theta}^{\text{old}}$, and hence $\gamma_{nk}$, ﬁxed. Maximization with respect to $\pi_k$ can be done in the usual way, with a Lagrange multiplier to enforce the summation constraint $\sum_k \pi_k = 1$, giving the familiar result

$$
\pi_k = \frac{1}{N} \sum_{n=1}^N \gamma_{nk}. \tag{14.50}
$$

To determine the $\{\mathbf{w}_k\}$, we note that the $Q(\boldsymbol{\theta}, \boldsymbol{\theta}^{\text{old}})$ function comprises a sum over terms indexed by $k$ each of which depends only on one of the vectors $\mathbf{w}_k$, so that the different vectors are decoupled in the M step of the EM algorithm. In other words, the different components interact only via the responsibilities, which are ﬁxed during the M step. Note that the M step does not have a closed-form solution and must be solved iteratively using, for instance, the iterative reweighted least squares (IRLS) algorithm. The gradient and the Hessian for the vector $\mathbf{w}_k$ are given by

$$
\nabla_k Q = \sum_{n=1}^N \gamma_{nk} (t_n - y_{nk}) \boldsymbol{\phi}_n \tag{14.51}
$$

$$
\mathbf{H}_k = -\nabla_k \nabla_k Q = \sum_{n=1}^N \gamma_{nk} y_{nk} (1 - y_{nk}) \boldsymbol{\phi}_n \boldsymbol{\phi}_n^{\text{T}} \tag{14.52}
$$

where $\nabla_k$ denotes the gradient with respect to $\mathbf{w}_k$. For ﬁxed $\gamma_{nk}$, these are independent of $\{\mathbf{w}_j\}$ for $j \ne k$ and so we can solve for each $\mathbf{w}_k$ separately using the IRLS algorithm. Thus the M-step equations for component $k$ correspond simply to ﬁtting a single logistic regression model to a weighted data set in which data point $n$ carries a weight $\gamma_{nk}$. Figure 14.10 shows an example of the mixture of logistic regression models applied to a simple classiﬁcation problem. The extension of this model to a mixture of softmax models for more than two classes is straightforward.

### 14.5.3 Mixtures of experts

In Section 14.5.1, we considered a mixture of linear regression models, and in Section 14.5.2 we discussed the analogous mixture of linear classiﬁers. Although these simple mixtures extend the ﬂexibility of linear models to include more complex (e.g., multimodal) predictive distributions, they are still very limited. We can further increase the capability of such models by allowing the mixing coefﬁcients themselves to be functions of the input variable, so that

$$
p(t|\mathbf{x}) = \sum_{k=1}^K \pi_k(\mathbf{x}) p_k(t|\mathbf{x}). \tag{14.53}
$$

This is known as a mixture of experts model (Jacobs et al., 1991) in which the mixing coefﬁcients $\pi_k(\mathbf{x})$ are known as gating functions and the individual component densities $p_k(t|\mathbf{x})$ are called experts. The notion behind the terminology is that different components can model the distribution in different regions of input space (they
