[Page 362]

$$
\begin{aligned} \widetilde{L}(\mathbf{a}, \widehat{\mathbf{a}}) &= -\frac{1}{2} \sum_{n=1}^N \sum_{m=1}^N (a_n - \widehat{a}_n)(a_m - \widehat{a}_m)k(\mathbf{x}_n, \mathbf{x}_m) \\ &- \epsilon \sum_{n=1}^N (a_n + \widehat{a}_n) + \sum_{n=1}^N (a_n - \widehat{a}_n)t_n \end{aligned} \tag{7.61}
$$

with respect to $\{a_n\}$ and $\{\widehat{a}_n\}$, where we have introduced the kernel $k(\mathbf{x}, \mathbf{x}') = \phi(\mathbf{x})^T\phi(\mathbf{x}')$. Again, this is a constrained maximization, and to ﬁnd the constraints we note that $a_n \geqslant 0$ and $\widehat{a}_n \geqslant 0$ are both required because these are Lagrange multipliers. Also $\mu_n \geqslant 0$ and $\widehat{\mu}_n \geqslant 0$ together with (7.59) and (7.60), require $a_n \leqslant C$ and $\widehat{a}_n \leqslant C$, and so again we have the box constraints

$$
0 \leqslant a_n \leqslant C \tag{7.62}
$$

$$
0 \leqslant \widehat{a}_n \leqslant C \tag{7.63}
$$

together with the condition (7.58).

Substituting (7.57) into (7.1), we see that predictions for new inputs can be made using

$$
y(\mathbf{x}) = \sum_{n=1}^N (a_n - \widehat{a}_n)k(\mathbf{x}, \mathbf{x}_n) + b \tag{7.64}
$$

which is again expressed in terms of the kernel function.

The corresponding Karush-Kuhn-Tucker (KKT) conditions, which state that at the solution the product of the dual variables and the constraints must vanish, are given by

$$
a_n(\epsilon + \xi_n + y_n - t_n) = 0 \tag{7.65}
$$

$$
\widehat{a}_n(\epsilon + \widehat{\xi}_n - y_n + t_n) = 0 \tag{7.66}
$$

$$
(C - a_n)\xi_n = 0 \tag{7.67}
$$

$$
(C - \widehat{a}_n)\widehat{\xi}_n = 0. \tag{7.68}
$$

From these we can obtain several useful results. First of all, we note that a coefﬁcient $a_n$ can only be nonzero if $\epsilon + \xi_n + y_n - t_n = 0$, which implies that the data point either lies on the upper boundary of the $\epsilon$-tube ($\xi_n = 0$) or lies above the upper boundary ($\xi_n > 0$). Similarly, a nonzero value for $\widehat{a}_n$ implies $\epsilon + \widehat{\xi}_n - y_n + t_n = 0$, and such points must lie either on or below the lower boundary of the $\epsilon$-tube.

Furthermore, the two constraints $\epsilon + \xi_n + y_n - t_n = 0$ and $\epsilon + \widehat{\xi}_n - y_n + t_n = 0$ are incompatible, as is easily seen by adding them together and noting that $\xi_n$ and $\widehat{\xi}_n$ are nonnegative while $\epsilon$ is strictly positive, and so for every data point $\mathbf{x}_n$, either $a_n$ or $\widehat{a}_n$ (or both) must be zero.

The support vectors are those data points that contribute to predictions given by (7.64), in other words those for which either $a_n \neq 0$ or $\widehat{a}_n \neq 0$. These are points that lie on the boundary of the $\epsilon$-tube or outside the tube. All points within the tube have
