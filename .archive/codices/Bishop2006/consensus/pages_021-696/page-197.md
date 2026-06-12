[Page 197]

- 3.20 ( ) www Starting from (3.86) verify all of the steps needed to show that maximization of the log marginal likelihood function (3.86) with respect to $\alpha$ leads to the re-estimation equation (3.92).

- 3.21 ( ) An alternative way to derive the result (3.92) for the optimal value of $\alpha$ in the evidence framework is to make use of the identity
$$
\frac{d}{d\alpha} \ln |\mathbf{A}| = \text{Tr} \left( \mathbf{A}^{-1} \frac{d}{d\alpha} \mathbf{A} \right) \tag{3.117}
$$
Prove this identity by considering the eigenvalue expansion of a real, symmetric matrix $\mathbf{A}$, and making use of the standard results for the determinant and trace of $\mathbf{A}$ expressed in terms of its eigenvalues (Appendix C). Then make use of (3.117) to derive (3.92) starting from (3.86).

- 3.22 ( ) Starting from (3.86) verify all of the steps needed to show that maximization of the log marginal likelihood function (3.86) with respect to $\beta$ leads to the re-estimation equation (3.95).

- 3.23 ( ) www Show that the marginal probability of the data, in other words the model evidence, for the model described in Exercise 3.12 is given by
$$
p(\mathbf{t}) = \frac{1}{(2\pi)^{N/2}} \frac{b_0^{a_0}}{b_N^{a_N}} \frac{\Gamma(a_N)}{\Gamma(a_0)} \frac{|\mathbf{S}_N|^{1/2}}{|\mathbf{S}_0|^{1/2}} \tag{3.118}
$$
by first marginalizing with respect to $\mathbf{w}$ and then with respect to $\beta$.

- 3.24 ( ) Repeat the previous exercise but now use Bayes’ theorem in the form
$$
p(\mathbf{t}) = \frac{p(\mathbf{t}|\mathbf{w},\beta)p(\mathbf{w},\beta)}{p(\mathbf{w},\beta|\mathbf{t})} \tag{3.119}
$$
and then substitute for the prior and posterior distributions and the likelihood function in order to derive the result (3.118).
