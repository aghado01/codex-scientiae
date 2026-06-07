[Page 350]

In Appendix E, we show that a constrained optimization of this form satisﬁes the Karush-Kuhn-Tucker (KKT) conditions, which in this case require that the following three properties hold

$$
a_n \geqslant 0 \tag{7.14}
$$

$$
t_n y(\mathbf{x}_n) - 1 \geqslant 0 \tag{7.15}
$$

$$
a_n \{t_n y(\mathbf{x}_n) - 1\} = 0. \tag{7.16}
$$

Thus for every data point, either $a_n = 0$ or $t_n y(\mathbf{x}_n) = 1$. Any data point for which $a_n = 0$ will not appear in the sum in (7.13) and hence plays no role in making predictions for new data points. The remaining data points are called support vectors, and because they satisfy $t_n y(\mathbf{x}_n) = 1$, they correspond to points that lie on the maximum margin hyperplanes in feature space, as illustrated in Figure 7.1. This property is central to the practical applicability of support vector machines. Once the model is trained, a signiﬁcant proportion of the data points can be discarded and only the support vectors retained.

Having solved the quadratic programming problem and found a value for $\mathbf{a}$, we can then determine the value of the threshold parameter $b$ by noting that any support vector $\mathbf{x}_n$ satisﬁes $t_n y(\mathbf{x}_n) = 1$. Using (7.13) this gives

$$
t_n \left( \sum_{m \in \mathcal{S}} a_m t_m k(\mathbf{x}_n, \mathbf{x}_m) + b \right) = 1 \tag{7.17}
$$

where $\mathcal{S}$ denotes the set of indices of the support vectors. Although we can solve this equation for $b$ using an arbitrarily chosen support vector $\mathbf{x}_n$, a numerically more stable solution is obtained by ﬁrst multiplying through by $t_n$, making use of $t_n^2 = 1$, and then averaging these equations over all support vectors and solving for $b$ to give

$$
b = \frac{1}{N_{\mathcal{S}}} \sum_{n \in \mathcal{S}} \left( t_n - \sum_{m \in \mathcal{S}} a_m t_m k(\mathbf{x}_n, \mathbf{x}_m) \right) \tag{7.18}
$$

where $N_{\mathcal{S}}$ is the total number of support vectors.

For later comparison with alternative models, we can express the maximummargin classiﬁer in terms of the minimization of an error function, with a simple quadratic regularizer, in the form

$$
\sum_{n=1}^N E_{\infty}(y(\mathbf{x}_n)t_n - 1) + \lambda \|\mathbf{w}\|^2 \tag{7.19}
$$

where $E_{\infty}(z)$ is a function that is zero if $z \geqslant 0$ and $\infty$ otherwise and ensures that the constraints (7.5) are satisﬁed. Note that as long as the regularization parameter satisﬁes $\lambda > 0$, its precise value plays no role.

Figure 7.2 shows an example of the classiﬁcation resulting from training a support vector machine on a simple synthetic data set using a Gaussian kernel of the
