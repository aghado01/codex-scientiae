[Page 363]

$a_n = \widehat{a}_n = 0$. We again have a sparse solution, and the only terms that have to be evaluated in the predictive model (7.64) are those that involve the support vectors.

The parameter $b$ can be found by considering a data point for which $0 < a_n < C$, which from (7.67) must have $\xi_n = 0$, and from (7.65) must therefore satisfy $\epsilon + y_n - t_n = 0$. Using (7.1) and solving for $b$, we obtain

$$
\begin{aligned} b &= t_n - \epsilon - \mathbf{w}^T\phi(\mathbf{x}_n) \\ &= t_n - \epsilon - \sum_{m=1}^N (a_m - \widehat{a}_m)k(\mathbf{x}_n, \mathbf{x}_m) \end{aligned} \tag{7.69}
$$

where we have used (7.57). We can obtain an analogous result by considering a point for which $0 < \widehat{a}_n < C$. In practice, it is better to average over all such estimates of $b$.

As with the classiﬁcation case, there is an alternative formulation of the SVM for regression in which the parameter governing complexity has a more intuitive interpretation (Sch¨olkopf et al., 2000). In particular, instead of ﬁxing the width of the insensitive region, we ﬁx instead a parameter $\nu$ that bounds the fraction of points lying outside the tube. This involves maximizing

$$
\begin{aligned} \widetilde{L}(\mathbf{a}, \widehat{\mathbf{a}}) &= -\frac{1}{2} \sum_{n=1}^N \sum_{m=1}^N (a_n - \widehat{a}_n)(a_m - \widehat{a}_m)k(\mathbf{x}_n, \mathbf{x}_m) \\ &+ \sum_{n=1}^N (a_n - \widehat{a}_n)t_n \end{aligned} \tag{7.70}
$$

subject to the constraints

$$
0 \leqslant a_n \leqslant C/N \tag{7.71}
$$

$$
0 \leqslant \widehat{a}_n \leqslant C/N \tag{7.72}
$$

$$
\sum_{n=1}^N (a_n - \widehat{a}_n) = 0 \tag{7.73}
$$

$$
\sum_{n=1}^N (a_n + \widehat{a}_n) \leqslant \nu C. \tag{7.74}
$$

It can be shown that there are at most $\nu N$ data points falling outside the insensitive tube, while at least $\nu N$ data points are support vectors and so lie either on the tube or outside it.

The use of a support vector machine to solve a regression problem is illustrated using the sinusoidal data set in Figure 7.8. Here the parameters $\nu$ and $C$ have been chosen by hand. In practice, their values would typically be determined by crossvalidation.
