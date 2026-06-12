[Page 532]

The factor approximations will therefore take the form of exponential-quadratic functions of the form

$$
\widetilde{f}_n(\boldsymbol{\theta}) = s_n \mathcal{N}(\boldsymbol{\theta}|\mathbf{m}_n, v_n\mathbf{I}) \tag{10.213}
$$

where $n = 1, \ldots, N$, and we set $\widetilde{f}_0(\boldsymbol{\theta})$ equal to the prior $p(\boldsymbol{\theta})$. Note that the use of $\mathcal{N}(\boldsymbol{\theta}|\cdot, \cdot)$ does not imply that the right-hand side is a well-deﬁned Gaussian density (in fact, as we shall see, the variance parameter $v_n$ can be negative) but is simply a convenient shorthand notation. The approximations $\widetilde{f}_n(\boldsymbol{\theta})$, for $n = 1, \ldots, N$, can be initialized to unity, corresponding to $s_n = (2\pi v_n)^{D/2}$, $v_n \to \infty$ and $\mathbf{m}_n = \mathbf{0}$, where $D$ is the dimensionality of $\mathbf{x}$ and hence of $\boldsymbol{\theta}$. The initial $q(\boldsymbol{\theta})$, deﬁned by (10.191), is therefore equal to the prior.

We then iteratively reﬁne the factors by taking one factor $f_n(\boldsymbol{\theta})$ at a time and applying (10.205), (10.206), and (10.207). Note that we do not need to revise the term $f_0(\boldsymbol{\theta})$ because an EP update will leave this term unchanged. Here we state the results and leave the reader to ﬁll in the details.

First we remove the current estimate $\widetilde{f}_n(\boldsymbol{\theta})$ from $q(\boldsymbol{\theta})$ by division using (10.205) to give $q^{\setminus n}(\boldsymbol{\theta})$, which has mean and inverse variance given by

$$
\mathbf{m}^{\setminus n} = \mathbf{m} + v^{\setminus n}v_n^{-1}(\mathbf{m} - \mathbf{m}_n) \tag{10.214}
$$

$$
(v^{\setminus n})^{-1} = v^{-1} - v_n^{-1}. \tag{10.215}
$$

Next we evaluate the normalization constant $Z_n$ using (10.206) to give

$$
Z_n = (1 - w)\mathcal{N}(\mathbf{x}_n|\mathbf{m}^{\setminus n}, (v^{\setminus n} + 1)\mathbf{I}) + w\mathcal{N}(\mathbf{x}_n|\mathbf{0}, a\mathbf{I}). \tag{10.216}
$$

Similarly, we compute the mean and variance of $q^{\text{new}}(\boldsymbol{\theta})$ by ﬁnding the mean and variance of $q^{\setminus n}(\boldsymbol{\theta})f_n(\boldsymbol{\theta})$ to give

$$
\mathbf{m} = \mathbf{m}^{\setminus n} + \rho_n \frac{v^{\setminus n}}{v^{\setminus n} + 1}(\mathbf{x}_n - \mathbf{m}^{\setminus n}) \tag{10.217}
$$

$$
v = v^{\setminus n} - \rho_n \frac{(v^{\setminus n})^2}{v^{\setminus n} + 1} + \rho_n(1 - \rho_n) \frac{(v^{\setminus n})^2 \Vert \mathbf{x}_n - \mathbf{m}^{\setminus n} \Vert^2}{D(v^{\setminus n} + 1)^2} \tag{10.218}
$$

where the quantity

$$
\rho_n = 1 - \frac{w}{Z_n} \mathcal{N}(\mathbf{x}_n|\mathbf{0}, a\mathbf{I}) \tag{10.219}
$$

has a simple interpretation as the probability of the point $\mathbf{x}_n$ not being clutter. Then we use (10.207) to compute the reﬁned factor $\widetilde{f}_n(\boldsymbol{\theta})$ whose parameters are given by

$$
v_n^{-1} = (v^{\text{new}})^{-1} - (v^{\setminus n})^{-1} \tag{10.220}
$$

$$
\mathbf{m}_n = \mathbf{m}^{\setminus n} + (v_n + v^{\setminus n})(v^{\setminus n})^{-1}(\mathbf{m}^{\text{new}} - \mathbf{m}^{\setminus n}) \tag{10.221}
$$

$$
s_n = \frac{Z_n}{(2\pi v_n)^{D/2} \mathcal{N}(\mathbf{m}_n|\mathbf{m}^{\setminus n}, (v_n + v^{\setminus n})\mathbf{I})}. \tag{10.222}
$$

This reﬁnement process is repeated until a suitable termination criterion is satisﬁed, for instance that the maximum change in parameter values resulting from a complete
