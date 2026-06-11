[Page 240]

We now apply the approximation $\sigma(a) \simeq \Phi(\lambda a)$ to the probit functions appearing on both sides of this equation, leading to the following approximation for the convolution of a logistic sigmoid with a Gaussian

$$
\int \sigma(a)\mathcal{N}(a|\mu,\sigma^2) \, da \simeq \sigma(\kappa(\sigma^2)\mu) \tag{4.153}
$$

where we have defined

$$
\kappa(\sigma^2) = (1 + \pi\sigma^2/8)^{-1/2}. \tag{4.154}
$$

Applying this result to (4.151) we obtain the approximate predictive distribution in the form

$$
p(\mathcal{C}_1|\boldsymbol{\phi},\mathbf{t}) = \sigma(\kappa(\sigma_a^2)\mu_a) \tag{4.155}
$$

where $\mu_a$ and $\sigma_a^2$ are defined by (4.149) and (4.150), respectively, and $\kappa(\sigma_a^2)$ is defined by (4.154).

Note that the decision boundary corresponding to $p(\mathcal{C}_1|\boldsymbol{\phi},\mathbf{t}) = 0.5$ is given by $\mu_a = 0$, which is the same as the decision boundary obtained by using the MAP value for $\mathbf{w}$. Thus if the decision criterion is based on minimizing misclassification rate, with equal prior probabilities, then the marginalization over $\mathbf{w}$ has no effect. However, for more complex decision criteria it will play an important role. Marginalization of the logistic sigmoid model under a Gaussian approximation to the posterior distribution will be illustrated in the context of variational inference in Figure 10.13.

###### Exercises

4.1 ($\star$) Given a set of data points $\{\mathbf{x}_n\}$, we can define the convex hull to be the set of all points $\mathbf{x}$ given by

$$
\mathbf{x} = \sum_{n} \alpha_n \mathbf{x}_n \tag{4.156}
$$

where $\alpha_n \ge 0$ and $\sum_n \alpha_n = 1$. Consider a second set of points $\{\mathbf{y}_n\}$ together with their corresponding convex hull. By definition, the two sets of points will be linearly separable if there exists a vector $\mathbf{w}$ and a scalar $w_0$ such that $\mathbf{w}^{\mathrm{T}}\mathbf{x}_n + w_0 > 0$ for all $\mathbf{x}_n$, and $\mathbf{w}^{\mathrm{T}}\mathbf{y}_n + w_0 < 0$ for all $\mathbf{y}_n$. Show that if their convex hulls intersect, the two sets of points cannot be linearly separable, and conversely that if they are linearly separable, their convex hulls do not intersect.

4.2 ($\star$) www Consider the minimization of a sum-of-squares error function (4.15), and suppose that all of the target vectors in the training set satisfy a linear constraint

$$
\mathbf{a}^{\mathrm{T}}\mathbf{t}_n + b = 0 \tag{4.157}
$$

where $\mathbf{t}_n$ corresponds to the $n^{\mathrm{th}}$ row of the matrix $\mathbf{T}$ in (4.15). Show that as a consequence of this constraint, the elements of the model prediction $\mathbf{y}(\mathbf{x})$ given by the least-squares solution (4.17) also satisfy this constraint, so that

$$
\mathbf{a}^{\mathrm{T}}\mathbf{y}(\mathbf{x}) + b = 0. \tag{4.158}
$$
