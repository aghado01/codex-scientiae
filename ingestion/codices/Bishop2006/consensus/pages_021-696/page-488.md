[Page 488]

![image 233](../images/imageFile233.png)
![image 234](../images/imageFile234.png)

Figure 10.2 Comparison of the two alternative forms for the Kullback-Leibler divergence. The green contours corresponding to 1, 2, and 3 standard deviations for a correlated Gaussian distribution $p(\mathbf{z})$ over two variables $z_1$ and $z_2$, and the red contours represent the corresponding levels for an approximating distribution $q(\mathbf{z})$ over the same variables given by the product of two independent univariate Gaussian distributions whose parameters are obtained by minimization of (a) the Kullback-Leibler divergence $\text{KL}(q \| p)$, and (b) the reverse Kullback-Leibler divergence $\text{KL}(p \| q)$.

is used in an alternative approximate inference framework called expectation propagation. We therefore consider the general problem of minimizing $\text{KL}(p \| q)$ when $q(\mathbf{Z})$ is a factorized approximation of the form (10.5). The KL divergence can then be written in the form

$$
\text{KL}(p \| q) = - \int p(\mathbf{Z}) \left[ \sum_{i=1}^M \ln q_i(\mathbf{Z}_i) \right] \text{d}\mathbf{Z} + \text{const} \tag{10.16}
$$

where the constant term is simply the entropy of $p(\mathbf{Z})$ and so does not depend on $q(\mathbf{Z})$. We can now optimize with respect to each of the factors $q_j(\mathbf{Z}_j)$, which is easily done using a Lagrange multiplier to give

$$
q^\star_j(\mathbf{Z}_j) = \int p(\mathbf{Z}) \prod_{i \neq j} \text{d}\mathbf{Z}_i = p(\mathbf{Z}_j). \tag{10.17}
$$

In this case, we ﬁnd that the optimal solution for $q_j(\mathbf{Z}_j)$ is just given by the corresponding marginal distribution of $p(\mathbf{Z})$. Note that this is a closed-form solution and so does not require iteration.

To apply this result to the illustrative example of a Gaussian distribution $p(\mathbf{z})$ over a vector $\mathbf{z}$ we can use (2.98), which gives the result shown in Figure 10.2(b). We see that once again the mean of the approximation is correct, but that it places signiﬁcant probability mass in regions of variable space that have very low probability.

The difference between these two results can be understood by noting that there is a large positive contribution to the Kullback-Leibler divergence

$$
\text{KL}(q \| p) = - \int q(\mathbf{Z}) \ln \left\{ \frac{p(\mathbf{Z})}{q(\mathbf{Z})} \right\} \text{d}\mathbf{Z} \tag{10.18}
$$
