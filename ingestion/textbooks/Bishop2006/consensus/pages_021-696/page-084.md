[Page 84]

1. 24. `(www)` Consider a classiﬁcation problem in which the loss incurred when an input vector from class $\mathcal{C}_k$ is classiﬁed as belonging to class $\mathcal{C}_j$ is given by the loss matrix $L_{kj}$, and for which the loss incurred in selecting the reject option is $\lambda$. Find the decision criterion that will give the minimum expected loss. Verify that this reduces to the reject criterion discussed in Section 1.5.3 when the loss matrix is given by $L_{kj} = 1 - I_{kj}$. What is the relationship between $\lambda$ and the rejection threshold $\theta$?

1. 25. `(www)` Consider the generalization of the squared loss function (1.87) for a single target variable $t$ to the case of multiple target variables described by the vector $\mathbf{t}$ given by

$$
\mathbb{E}[L(\mathbf{t}, \mathbf{y}(\mathbf{x}))] = \iint \|\mathbf{y}(\mathbf{x}) - \mathbf{t}\|^2 p(\mathbf{x}, \mathbf{t})\, d\mathbf{x}\, d\mathbf{t}. \tag{1.151}
$$

Using the calculus of variations, show that the function $\mathbf{y}(\mathbf{x})$ for which this expected loss is minimized is given by $\mathbf{y}(\mathbf{x}) = \mathbb{E}_{\mathbf{t}}[\mathbf{t} \mid \mathbf{x}]$. Show that this result reduces to (1.89) for the case of a single target variable $t$.

1. 26. By expansion of the square in (1.151), derive a result analogous to (1.90) and hence show that the function $\mathbf{y}(\mathbf{x})$ that minimizes the expected squared loss for the case of a vector $\mathbf{t}$ of target variables is again given by the conditional expectation of $\mathbf{t}$.

1. 27. `(www)` Consider the expected loss for regression problems under the $L_q$ loss function given by (1.91). Write down the condition that $y(x)$ must satisfy in order to minimize $\mathbb{E}[L_q]$. Show that, for $q = 1$, this solution represents the conditional median, i.e., the function $y(x)$ such that the probability mass for $t < y(x)$ is the same as for $t \ge y(x)$. Also show that the minimum expected $L_q$ loss for $q \to 0$ is given by the conditional mode, i.e., by the function $y(x)$ equal to the value of $t$ that maximizes $p(t \mid x)$ for each $x$.

1. 28. In Section 1.6, we introduced the idea of entropy $h(x)$ as the information gained on observing the value of a random variable $x$ having distribution $p(x)$. We saw that, for independent variables $x$ and $y$ for which $p(x, y) = p(x)p(y)$, the entropy functions are additive, so that $h(x, y) = h(x) + h(y)$. In this exercise, we derive the relation between $h$ and $p$ in the form of a function $h(p)$. First show that $h(p^2) = 2h(p)$, and hence by induction that $h(p^n) = nh(p)$ where $n$ is a positive integer. Hence show that $h(p^{n/m}) = (n/m)h(p)$ where $m$ is also a positive integer. This implies that $h(p^x) = xh(p)$ where $x$ is a positive rational number, and hence by continuity when it is a positive real number. Finally, show that this implies $h(p)$ must take the form $h(p) \propto \ln p$.

1. 29. `(www)` Consider an $M$-state discrete random variable $x$, and use Jensen’s inequality in the form (1.115) to show that the entropy of its distribution $p(x)$ satisﬁes $H[x] \le \ln M$.

1. 30. Evaluate the Kullback-Leibler divergence (1.113) between two Gaussians $p(x) = \mathcal{N}(x \mid \mu, \sigma^2)$ and $q(x) = \mathcal{N}(x \mid m, s^2)$.
