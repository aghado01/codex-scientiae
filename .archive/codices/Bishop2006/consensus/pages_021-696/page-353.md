[Page 353]

where $\{a_n \geqslant 0\}$ and $\{\mu_n \geqslant 0\}$ are Lagrange multipliers. The corresponding set of KKT conditions are given by

$$
a_n \geqslant 0 \tag{7.23}
$$

$$
t_ny(\mathbf{x}_n) - 1 + \xi_n \geqslant 0 \tag{7.24}
$$

$$
a_n(t_ny(\mathbf{x}_n) - 1 + \xi_n) = 0 \tag{7.25}
$$

$$
\mu_n \geqslant 0 \tag{7.26}
$$

$$
\xi_n \geqslant 0 \tag{7.27}
$$

$$
\mu_n\xi_n = 0 \tag{7.28}
$$

where $n = 1,\dots,N$.

We now optimize out $\mathbf{w}$, $b$, and $\{\xi_n\}$ making use of the deﬁnition (7.1) of $y(\mathbf{x})$ to give

$$
\frac{\partial L}{\partial \mathbf{w}} = 0 \quad \Rightarrow \quad \mathbf{w} = \sum_{n=1}^N a_nt_n\boldsymbol{\phi}(\mathbf{x}_n) \tag{7.29}
$$

$$
\frac{\partial L}{\partial b} = 0 \quad \Rightarrow \quad \sum_{n=1}^N a_nt_n = 0 \tag{7.30}
$$

$$
\frac{\partial L}{\partial \xi_n} = 0 \quad \Rightarrow \quad a_n = C - \mu_n. \tag{7.31}
$$

Using these results to eliminate $\mathbf{w}$, $b$, and $\{\xi_n\}$ from the Lagrangian, we obtain the dual Lagrangian in the form

$$
\widetilde{L}(\mathbf{a}) = \sum_{n=1}^N a_n - \frac{1}{2} \sum_{n=1}^N \sum_{m=1}^N a_n a_m t_n t_m k(\mathbf{x}_n,\mathbf{x}_m) \tag{7.32}
$$

which is identical to the separable case, except that the constraints are somewhat different. To see what these constraints are, we note that $a_n \geqslant 0$ is required because these are Lagrange multipliers. Furthermore, (7.31) together with $\mu_n \geqslant 0$ implies $a_n \leqslant C$. We therefore have to minimize (7.32) with respect to the dual variables $\{a_n\}$ subject to

$$
0 \leqslant a_n \leqslant C \tag{7.33}
$$

$$
\sum_{n=1}^N a_nt_n = 0 \tag{7.34}
$$

for $n = 1,\dots,N$, where (7.33) are known as box constraints. This again represents a quadratic programming problem. If we substitute (7.29) into (7.1), we see that predictions for new data points are again made by using (7.13).

We can now interpret the resulting solution. As before, a subset of the data points may have $a_n = 0$, in which case they do not contribute to the predictive
