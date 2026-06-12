[Page 23]

Gibbs sampling is one of the main MCMC methods. A Gibbs sampling algorithm is implemented by considering the full conditional posterior distributions for the individual parameters. The full conditional posterior distribution for θ is expressed as follows:

$$
p ( \theta | y, \sigma _ { \epsilon } ^ { 2 }, \sigma _ { b } ^ { 2 } ) & \, \infty \exp \left \{ - \frac { 1 } { 2 \sigma _ { \epsilon } ^ { 2 } } \| y - T \theta \| ^ { 2 } - \frac { 1 } { 2 \sigma _ { b } ^ { 2 } } \| b \| ^ { 2 } - \frac { 1 } { 2 \sigma _ { \beta } ^ { 2 } } \| \beta \| ^ { 2 } \right \} \\ & = \exp \left \{ - \frac { 1 } { 2 \sigma _ { \epsilon } ^ { 2 } } \left ( \| y - T \theta \| ^ { 2 } + \frac { \sigma _ { \epsilon } ^ { 2 } } { \sigma _ { b } ^ { 2 } } \| b \| ^ { 2 } \right ) - \frac { 1 } { 2 \sigma _ { \beta } ^ { 2 } } \| \beta \| ^ { 2 } \right \} .
$$

Equation (2.20) can be further expanded by collecting terms and completing the square. The result is a multivariate normal distribution, N ( µ θ, Σ θ ), where

$$
\mu _ { \theta } = \left ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } \right ) ^ { - 1 } T ^ { \prime } y, \quad \Sigma _ { \theta } = \sigma _ { \epsilon } ^ { 2 } \left ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } \right ) ^ { - 1 },
$$

where D = diag( σ 2 β,...,σ 2 β,σ 2 b,...,σ 2 b ).

The full conditional distributions for the variance components σ 2 and σ 2 b are inverse gamma distributions, i.e.,

$$
( \sigma _ { \epsilon } ^ { 2 } | y, \beta, b ) \sim I G \left ( \frac { n } { 2 } + A _ { \epsilon }, \frac { 1 } { 2 } \| y - T \theta \| ^ { 2 } + B _ { \epsilon } \right )
$$

and

$$
( \sigma _ { b } ^ { 2 } | b ) \sim I G \left ( \frac { K _ { \kappa } } { 2 } + A _ { b }, \frac { 1 } { 2 } | | b | | ^ { 2 } + B _ { b } \right ) .
$$

The Gibbs sampler is used to sample from p ( β,b,σ 2  ,σ 2 b | y ) by sampling from the full conditional distributions presented above. The sampling scheme for the Bayesian approach to P-splines iterates over the following steps:

$$
N \left \{ \left ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } \right ) ^ { - 1 } T ^ { \prime } y, \sigma _ { \epsilon } ^ { 2 } \left ( T ^ { \prime } T + \sigma _ { \epsilon } ^ { 2 } D ^ { - 1 } \right ) ^ { - 1 } \right \} .
$$
