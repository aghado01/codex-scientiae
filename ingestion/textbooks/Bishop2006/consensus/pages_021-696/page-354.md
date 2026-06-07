[Page 354]

model (7.13). The remaining data points constitute the support vectors. These have $a_n > 0$ and hence from (7.25) must satisfy

$$
t_ny(\mathbf{x}_n) = 1 - \xi_n. \tag{7.35}
$$

If $a_n < C$, then (7.31) implies that $\mu_n > 0$, which from (7.28) requires $\xi_n = 0$ and hence such points lie on the margin. Points with $a_n = C$ can lie inside the margin and can either be correctly classiﬁed if $\xi_n \leqslant 1$ or misclassiﬁed if $\xi_n > 1$.

To determine the parameter $b$ in (7.1), we note that those support vectors for which $0 < a_n < C$ have $\xi_n = 0$ so that $t_ny(\mathbf{x}_n) = 1$ and hence will satisfy

$$
t_n \left( \sum_{m \in \mathcal{S}} a_mt_mk(\mathbf{x}_n,\mathbf{x}_m) + b \right) = 1. \tag{7.36}
$$

Again, a numerically stable solution is obtained by averaging to give

$$
b = \frac{1}{N_{\mathcal{M}}} \sum_{n \in \mathcal{M}} \left( t_n - \sum_{m \in \mathcal{S}} a_mt_mk(\mathbf{x}_n,\mathbf{x}_m) \right) \tag{7.37}
$$

where $\mathcal{M}$ denotes the set of indices of data points having $0 < a_n < C$.

An alternative, equivalent formulation of the support vector machine, known as the $\nu$-SVM, has been proposed by Sch¨olkopf et al. (2000). This involves maximizing

$$
\widetilde{L}(\mathbf{a}) = \sum_{n=1}^N a_n - \frac{1}{2} \sum_{n=1}^N \sum_{m=1}^N a_n a_m t_n t_m k(\mathbf{x}_n,\mathbf{x}_m) \tag{7.38}
$$

subject to the constraints

$$
0 \leqslant a_n \leqslant 1/N \tag{7.39}
$$

$$
\sum_{n=1}^N a_nt_n = 0 \tag{7.40}
$$

$$
\sum_{n=1}^N a_n \geqslant \nu. \tag{7.41}
$$

This approach has the advantage that the parameter $\nu$, which replaces $C$, can be interpreted as both an upper bound on the fraction of margin errors (points for which $\xi_n > 0$ and hence which lie on the wrong side of the margin boundary and which may or may not be misclassiﬁed) and a lower bound on the fraction of support vectors. An example of the $\nu$-SVM applied to a synthetic data set is shown in Figure 7.4. Here Gaussian kernels of the form $\exp(-\gamma\|\mathbf{x} - \mathbf{x}'\|^2)$ have been used, with $\gamma = 0.45$.

Although predictions for new inputs are made using only the support vectors, the training phase (i.e., the determination of the parameters $\mathbf{a}$ and $b$) makes use of the whole data set, and so it is important to have efﬁcient algorithms for solving
