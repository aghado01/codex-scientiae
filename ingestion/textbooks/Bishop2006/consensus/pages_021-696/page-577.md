[Page 577]

![Figure 11.15](../images/imageFile270.png)

Figure 11.15 A probability distribution over two variables $z_1$ and $z_2$ that is uniform over the shaded regions and that is zero everywhere else.

11.11 ($\star\star$) www Show that the Gibbs sampling algorithm, discussed in Section 11.3, satisﬁes detailed balance as deﬁned by (11.40).

11.12 ($\star$) Consider the distribution shown in Figure 11.15. Discuss whether the standard Gibbs sampling procedure for this distribution is ergodic, and therefore whether it would sample correctly from this distribution.

11.13 ($\star$) Consider the simple 3-node graph shown in Figure 11.16 in which the observed node $x$ is given by a Gaussian distribution $\mathcal{N}(x|\mu, \tau^{-1})$ with mean $\mu$ and precision $\tau$. Suppose that the marginal distributions over the mean and precision are given by $\mathcal{N}(\mu|\mu_0, s_0)$ and $\text{Gam}(\tau|a, b)$, where $\text{Gam}(\cdot|\cdot, \cdot)$ denotes a gamma distribution. Write down expressions for the conditional distributions $p(\mu|x, \tau)$ and $p(\tau|x, \mu)$ that would be required in order to apply Gibbs sampling to the posterior distribution $p(\mu, \tau|x)$.

11.14 ($\star$) Verify that the over-relaxation update (11.50), in which $z_i$ has mean $\mu_i$ and variance $\sigma_i^2$, and where $\nu$ has zero mean and unit variance, gives a value $z_i'$ with mean $\mu_i$ and variance $\sigma_i^2$.

11.15 ($\star$) www Using (11.56) and (11.57), show that the Hamiltonian equation (11.58) is equivalent to (11.53). Similarly, using (11.57) show that (11.59) is equivalent to (11.55).

11.16 ($\star$) By making use of (11.56), (11.57), and (11.63), show that the conditional distribution $p(\mathbf{r}|\mathbf{z})$ is a Gaussian.

![Figure 11.16](../images/imageFile271.png)

Figure 11.16 A graph involving an observed Gaussian variable $x$ with prior distributions over its mean $\mu$ and precision $\tau$.
