[Page 7]

Denote by g( b, k, j ) some feature of the curve, such as the location of its maximum, that we wish to estimate. Let q( b | y, j, k) 3 p(y | b, k, j ) p b ( b | k, j ). The posterior expectation of g( b, k, j ) given y may be computed from

$$
of g ( \beta, k, \xi ) \text { given } y \text { may be computed from} \\ & \quad \int \dots \int g ( \beta, \xi, k ) \frac { q ( \beta | y, k, \xi ) } { \hat { q } ( \beta | y, \xi, k ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & \quad E \{ g ( \beta, \xi, k ) | y \} = \frac { } { \int \dots \int } \sum _ { \hat { q } ( \beta | y, \xi, k ) } ^ { \underline { q } ( \beta | y, k, \xi ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & \quad \simeq \frac { \sum _ { l } g ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) } { \sum _ { l } w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) }, \\ \text {where}
$$

where

$$
w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) = \frac { q ( \beta ^ { ( l ) } | y, \xi ^ { ( l ) }, k ^ { ( l ) } ) } { \hat { q } ( \beta ^ { ( l ) } | y, \xi ^ { ( l ) }, k ^ { ( l ) } ) },
$$

( j (l), k (l) ) is the pair accepted by the reversible-jump sampler, i.e. sampled from p(k, j | y), and b (l) is sampled from a suitable approximation q @ to the conditional posterior of b given (k, j ). In fact, we may approximate the likelihood function on b given (k, j ) rather than the full conditional posterior, which is typically easier under model (1), yielding weights of the form

$$
w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) = \frac { p ( y | \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) } { \hat { p } ( y | \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) } .
$$

A standard choice for p @ would be a multivariate t density (Evans & Swartz, 1995). Veriﬁcation that the importance weights are correct when q/q @ is replaced by p/p @ is straightforward; see Appendix 2. From this method of computing posterior expectations we may also obtain posterior variances and posterior interval probabilities.

Our implementation has two key features: ﬁrst, we use a fully Bayesian approach, together with a  approximation to the marginal density (4) and, secondly, we use the locality heuristic of Zhou & Shen (2001) to place new knots. Both of these choices may be contrasted with the implementation of Denison et al. (1998). In our simulation study we compute mean squared error for our Bayesian adaptive regression splines and compare with spatially adaptive regression splines, using the software of Zhou & Shen (2001), and with the Denison et al. method, using software available at http: // www.ma.ic.ac.uk / ~ dgtd. We also investigate the relative importance of the two implementation changes by comparing with what we call the modiﬁed Denison et al. method, which includes the  approximation but not the change in candidate knot locations; we computed the modiﬁed Denison et al. method by inserting the required factor 1/ √ n into their code and recompiling. The Bayesian adaptive regression spline estimates of E{f(x) | y} = E[E{f(x) | y, k, j }] are found from our Markov chain Monte Carlo with runs of length 10 000 following burn-ins of 1000.

In this section we consider three functions: a slowly-varying smooth function, a function with a sharp peak, that is spatially inhomogeneously smooth, and a function with a discontinuity. Noise is added to each in generating the data. The functions together with samples of data are shown in Fig. 1.
