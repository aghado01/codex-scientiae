[Page 115]

Figure 2.10 A schematic illustration of two correlated random variables $z$ and $\theta$, together with the regression function $f(\theta)$ given by the conditional expectation $\mathbb{E}[z|\theta]$. The Robbins-Monro algorithm provides a general sequential procedure for ﬁnding the root $\theta^\star$ of such functions.

![The image is a graph titled curve. The graph has a linear scale from 0 to 1 on the x-axis, labeled as s(n). The graph has a linear scale from 0 to 1 on the y-axis, labeled as f(n). The graph shows a curve that starts at a point labeled 0 and ends at a point labeled f(n). The curve starts at the point 0 and ends at the point f(n). The curve is a straight line with a slight curve at the end.](../images/imageFile51.png)

dissect out the contribution from the ﬁnal data point $\mathbf{x}_N$, we obtain
$$
\begin{align}
\boldsymbol{\mu}_{\text{ML}}^{(N)} &= \frac{1}{N} \sum_{n=1}^{N} \mathbf{x}_n \\
&= \frac{1}{N} \mathbf{x}_N + \frac{1}{N} \sum_{n=1}^{N-1} \mathbf{x}_n \\
&= \frac{1}{N} \mathbf{x}_N + \frac{N-1}{N} \boldsymbol{\mu}_{\text{ML}}^{(N-1)} \\
&= \boldsymbol{\mu}_{\text{ML}}^{(N-1)} + \frac{1}{N} (\mathbf{x}_N - \boldsymbol{\mu}_{\text{ML}}^{(N-1)}). \tag{2.126}
\end{align}
$$

This result has a nice interpretation, as follows. After observing $N - 1$ data points we have estimated $\boldsymbol{\mu}$ by $\boldsymbol{\mu}_{\text{ML}}^{(N-1)}$. We now observe data point $\mathbf{x}_N$, and we obtain our revised estimate $\boldsymbol{\mu}_{\text{ML}}^{(N)}$ by moving the old estimate a small amount, proportional to $1/N$, in the direction of the ‘error signal’ $(\mathbf{x}_N - \boldsymbol{\mu}_{\text{ML}}^{(N-1)})$. Note that, as $N$ increases, so the contribution from successive data points gets smaller.

The result (2.126) will clearly give the same answer as the batch result (2.121) because the two formulae are equivalent. However, we will not always be able to derive a sequential algorithm by this route, and so we seek a more general formulation of sequential learning, which leads us to the Robbins-Monro algorithm. Consider a pair of random variables $\theta$ and $z$ governed by a joint distribution $p(z,\theta)$. The conditional expectation of $z$ given $\theta$ deﬁnes a deterministic function $f(\theta)$ that is given by
$$
f(\theta) \equiv \mathbb{E}[z|\theta] = \int z p(z|\theta) \, dz \tag{2.127}
$$
and is illustrated schematically in Figure 2.10. Functions deﬁned in this way are called regression functions.

Our goal is to ﬁnd the root $\theta^\star$ at which $f(\theta^\star) = 0$. If we had a large data set of observations of $z$ and $\theta$, then we could model the regression function directly and then obtain an estimate of its root. Suppose, however, that we observe values of $z$ one at a time and we wish to ﬁnd a corresponding sequential estimation scheme for $\theta$. The following general procedure for solving such problems was given by
