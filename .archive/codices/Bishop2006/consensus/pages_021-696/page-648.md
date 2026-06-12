[Page 648]

From the product rule, we then have

$$
p(\mathbf{x}_1, \dots, \mathbf{x}_n) = \prod_{m=1}^n c_m \tag{13.57}
$$

and so

$$
\alpha(\mathbf{z}_n) = p(\mathbf{z}_n|\mathbf{x}_1, \dots, \mathbf{x}_n)p(\mathbf{x}_1, \dots, \mathbf{x}_n) = \left( \prod_{m=1}^n c_m \right) \widehat{\alpha}(\mathbf{z}_n). \tag{13.58}
$$

We can then turn the recursion equation (13.36) for $\alpha$ into one for $\widehat{\alpha}$ given by

$$
c_n \widehat{\alpha}(\mathbf{z}_n) = p(\mathbf{x}_n|\mathbf{z}_n) \sum_{\mathbf{z}_{n-1}} \widehat{\alpha}(\mathbf{z}_{n-1})p(\mathbf{z}_n|\mathbf{z}_{n-1}). \tag{13.59}
$$

Note that at each stage of the forward message passing phase, used to evaluate $\widehat{\alpha}(\mathbf{z}_n)$, we have to evaluate and store $c_n$, which is easily done because it is the coefﬁcient that normalizes the right-hand side of (13.59) to give $\widehat{\alpha}(\mathbf{z}_n)$.

We can similarly deﬁne re-scaled variables $\widehat{\beta}(\mathbf{z}_n)$ using

$$
\beta(\mathbf{z}_n) = \left( \prod_{m=n+1}^N c_m \right) \widehat{\beta}(\mathbf{z}_n) \tag{13.60}
$$

which will again remain within machine precision because, from (13.35), the quantities $\widehat{\beta}(\mathbf{z}_n)$ are simply the ratio of two conditional probabilities

$$
\widehat{\beta}(\mathbf{z}_n) = \frac{p(\mathbf{x}_{n+1}, \dots, \mathbf{x}_N|\mathbf{z}_n)}{p(\mathbf{x}_{n+1}, \dots, \mathbf{x}_N|\mathbf{x}_1, \dots, \mathbf{x}_n)}. \tag{13.61}
$$

The recursion result (13.38) for $\beta$ then gives the following recursion for the re-scaled variables

$$
c_{n+1} \widehat{\beta}(\mathbf{z}_n) = \sum_{\mathbf{z}_{n+1}} \widehat{\beta}(\mathbf{z}_{n+1})p(\mathbf{x}_{n+1}|\mathbf{z}_{n+1})p(\mathbf{z}_{n+1}|\mathbf{z}_n). \tag{13.62}
$$

In applying this recursion relation, we make use of the scaling factors $c_n$ that were previously computed in the $\alpha$ phase.

From (13.57), we see that the likelihood function can be found using

$$
p(\mathbf{X}) = \prod_{n=1}^N c_n. \tag{13.63}
$$

Similarly, using (13.33) and (13.43), together with (13.63), we see that the required marginals are given by

$$
\gamma(\mathbf{z}_n) = \widehat{\alpha}(\mathbf{z}_n)\widehat{\beta}(\mathbf{z}_n) \tag{13.64}
$$
$$
\xi(\mathbf{z}_{n-1}, \mathbf{z}_n) = c_n \widehat{\alpha}(\mathbf{z}_{n-1})p(\mathbf{x}_n|\mathbf{z}_n)p(\mathbf{z}_n|\mathbf{z}_{n-1})\widehat{\beta}(\mathbf{z}_n). \tag{13.65}
$$
