[Page 9]

function x(t) the log-likelihood is

$$
\ell = \sum_{i=1}^{n} \log\{x(y_i)\} - \int_0^L x(t)\,dt \tag{9}
$$

### 4.2. A Model for Step Functions

We develop a assuming that the rate function x(.) on [0,L] is a function: In this section; we formulate a prior distribution for x step

$s_1 < s_2 < \cdots < s_k < L$, and that the step function takes the value $h_j$ on the $j$-th interval. The prior model is specified by supposing that $k$ is drawn from the Poisson distribution

$$
p ( k ) = e ^ { - \lambda } \frac { \lambda ^ { k } } { k ! } ,
$$

but conditioned on $k < k_{\max}$. Given $k$, the step positions $s_1, s_2, \ldots, s_k$ are distributed as the even-numbered order statistics from $2k+1$ points uniformly distributed on $[0,L]$, and the heights $h_0, h_1, \ldots, h_k$ are independently drawn from a $\Gamma(\alpha, \beta)$ distribution.

This model for step functions is intended to be close to 'uninformative . It is not appropriate to select an improper gamma distribution $\Gamma(0,0)$ for the heights, because that causes insurmountable difficulties with normalisation across differing numbers of steps; all of the probability in the posterior would be assigned to the simplest model. It would perhaps have been more natural to take the step positions independently uniformly distrib prior small:. Since there may be no data in the interval (sj, Sj+1), such short intervals are barely penalised by the likelihood and s0 survive in the posterior, giving a more complicated picture of the true step function than is really justified by the data. The modification used here has the effect of probabilistically spacing out the positions. step
