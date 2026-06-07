[Page 542]

where $Z_j$ is the normalization constant deﬁned by (10.197). By applying this result recursively, and initializing with $p_0(\mathcal{D}) = 1$, derive the result

$$
p(\mathcal{D}) \simeq \prod_j Z_j. \tag{10.243}
$$

10.37 ($\star$) www Consider the expectation propagation algorithm from Section 10.7, and suppose that one of the factors $f_0(\boldsymbol{\theta})$ in the deﬁnition (10.188) has the same exponential family functional form as the approximating distribution $q(\boldsymbol{\theta})$. Show that if the factor $\widetilde{f}_0(\boldsymbol{\theta})$ is initialized to be $f_0(\boldsymbol{\theta})$, then an EP update to reﬁne $\widetilde{f}_0(\boldsymbol{\theta})$ leaves $\widetilde{f}_0(\boldsymbol{\theta})$ unchanged. This situation typically arises when one of the factors is the prior $p(\boldsymbol{\theta})$, and so we see that the prior factor can be incorporated once exactly and does not need to be reﬁned.

10.38 ($\star$) In this exercise and the next, we shall verify the results (10.214)–(10.224) for the expectation propagation algorithm applied to the clutter problem. Begin by using the division formula (10.205) to derive the expressions (10.214) and (10.215) by completing the square inside the exponential to identify the mean and variance.

Also, show that the normalization constant $Z_n$, deﬁned by (10.206), is given for the clutter problem by (10.216). This can be done by making use of the general result (2.115).

10.39 ($\star$) Show that the mean and variance of $q^{\text{new}}(\boldsymbol{\theta})$ for EP applied to the clutter problem are given by (10.217) and (10.218). To do this, ﬁrst prove the following results for the expectations of $\boldsymbol{\theta}$ and $\boldsymbol{\theta}\boldsymbol{\theta}^{\text{T}}$ under $q^{\text{new}}(\boldsymbol{\theta})$

$$
\mathbb{E}[\boldsymbol{\theta}] = \mathbf{m}^{\setminus n} + v^{\setminus n}\nabla_{\mathbf{m}^{\setminus n}} \ln Z_n \tag{10.244}
$$

$$
\mathbb{E}[\boldsymbol{\theta}^{\text{T}}\boldsymbol{\theta}] = 2(v^{\setminus n})^2 \nabla_{v^{\setminus n}} \ln Z_n + 2\mathbb{E}[\boldsymbol{\theta}]^{\text{T}}\mathbf{m}^{\setminus n} - \Vert \mathbf{m}^{\setminus n} \Vert^2 \tag{10.245}
$$

and then make use of the result (10.216) for $Z_n$. Next, prove the results (10.220)–(10.222) by using (10.207) and completing the square in the exponential. Finally, use (10.208) to derive the result (10.223).
