[Page 8]

The mean and variance can vary ﬂexibly with the covariates and relative to each other. The elements of β can be positive or negative, large or small, and the elements of δ can also be large or small. A given basis could contribute substantially to the mean and negligibly to the variance (i.e. β l and δ l are both large), or vice versa, so that the mean and variance of the response at a given set of covariates are not constrained to vary together.

At each iteration, we obtain a piecewise linear model for which the parameters can be sampled directly from their full conditionals as derived from the priors and the likelihood following standard algebraic routes. Omitting details, we obtain the following full conditional posterior distributions:

$$
D \sim N _ { k } \left ( [ \lambda I _ { k } + m \Delta ] ^ { - 1 } \Delta \sum _ { i = 1 } ^ { m } b _ { i }, \tau ^ { - 1 } [ \lambda I _ { k } + m \Delta ] ^ { - 1 } \right )
$$

$$
f o l d i t i o n a l p o s t i o n d i t i o n s & & & \\ & \beta | b, \delta, \lambda, \tau, D \sim N _ { k } \left ( [ \lambda _ { k } + m \Delta ] ^ { - 1 } \Delta \sum _ { i = 1 } ^ { m } b _ { i }, \tau ^ { - 1 } [ \lambda _ { k } + m \Delta ] ^ { - 1 } \right ) \\ & b _ { i } | \beta, \delta, \lambda, \tau \sim N _ { k _ { i } } \left ( [ \theta ^ { \prime } _ { i } \theta _ { i } + \Delta ] ^ { - 1 } \theta ^ { \prime } _ { i } y _ { i } + \Delta \beta ], \tau ^ { - 1 } [ \theta ^ { \prime } _ { i } \theta _ { i } + \Delta ] ^ { - 1 } \right ) & & i = 1, \dots, m \\ & \tau | \beta, b, \delta, \lambda \sim G a m m a \left ( a _ { \tau } + \frac { ( m + 1 ) k + n } { 2 }, \tau \right ) & & \\ & b _ { \tau } + \frac { m } { 2 } \sum _ { i = 1 } ^ { m } [ ( b _ { i } - \beta _ { i } ) ^ { \prime } \Delta ( b _ { i } - \beta _ { i } ) + ( y _ { i } - \theta _ { i } b _ { i } ) ^ { \prime } ( y _ { i } - \theta _ { i } b _ { i } ) ] + \lambda ^ { \prime } \beta \right ) \\ & \lambda | \beta, b, \delta, \tau \sim G a m m a \left ( a _ { \lambda } + \frac { k } { 2 }, b _ { \lambda } + \frac { \beta ^ { \prime } \beta } { 2 } \right ) \\ & \delta | \beta, b, \delta _ { - 1 }, \lambda, \tau \sim G a m m a \left ( a _ { \delta } + \frac { m } { 2 }, b _ { \delta } + \frac { \tau } { 2 } \sum _ { i = 1 } ^ { m } ( b _ { u } - \beta _ { u } ) ^ { 2 } \right ) & & l = 0, \dots, ( k - 1 ) \\ & \text {where a} \ G a m m a ( a, b ) \text { random variable is parameterized to have expected value a/b and } \\ & \text {variance a/b} ^ { 2 } .
$$

where a Gamma ( a,b ) random variable is parameterized to have expected value a/b and variance a/b 2 .

The following is a description of the RJMCMC algorithm we employed:

Step 0: Initialize the model to the intercept-only basis function, where k = 1.
