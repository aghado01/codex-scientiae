[Page 2]

Our method applies to independent data (X 1, Y 1 ),..., (X n, Y n ) that satisfy the following model:

$$
Y _ { i } | X _ { 1 }, \dots, X _ { n } \sim p \{ y | f ( X _ { i } ), \sigma \} \ \ ( i = 1, \dots, n ),
$$

where f is a real-valued function on [a, b], and s is an optional and potentially vectorvalued nuisance parameter. We think of the X i ’s here as observed explanatory variables. The goal is to estimate the unknown function f from these data under the assumption that f lies in some ﬁxed, and usually inﬁnite-dimensional, class of functions.

We focus on the special case when p(y | h, s ) is an exponential family distribution with dispersion parameter s.In particular, when p(.) is a N( h, s 2 ) distribution, we obtain the nonparametric regression model

$$
Y _ { i } = f ( x _ { i } ) + \varepsilon _ { i } \quad ( i = 1, \dots, n ), \quad ( 2 )
$$

where the e i are independent draws from N(0, s 2 ) and s > 0 is unknown.

Our method implicitly assumes that f is well approximated between a and b by a cubic spline with some number of knots. In practice, we will assume that f is such a spline. This class of cubic splines is quite large and approximates any locally smooth function arbitrarily well.

We will denote knot conﬁgurations by pairs (k, j ), where the number of knots k is a nonnegative integer and the knot locations are given by the kvector j = ( j 1,..., j k ), for a < x (1) < j 1 ∏...∏ j k < x (n) < b. Let b j (x), for j = 1,..., k + 2, denote the j th function in a cubic Bspline basis with natural boundary constraints, i.e. linear outside [a, b], and let B k, j be the matrix whose i, j component is b j (x i ). The subscript k, j expresses the dependence of the matrix B k, j on the number and locations of knots. Under our assumptions, we can write f as a linear combination

$$
f ( x ) & = \sum _ { j = 1 } ^ { k + 2 } \beta _ { j } b _ { j } ( x ) & ( 3 ) \\ \varrho & \quad \text {WS} \ \ 1 &
$$

for some vector b = ( b 1,..., b k + 2 ). We have the linear relation B k, j b = f(X) ¬ ( f(X 1 ),..., f(X n )) at the observed design points.

To complete the Bayesian formulation of the model, we must specify a prior on the unknown quantities b, s, k and j.In this paper, we use uniform or Poisson priors on k and a uniform prior on j induced by the uniform prior over the standard ksimplex by rescaling j to [a, b]. Given k and j, we use a particular conjugate Normal prior on b that Kass & Wasserman (1995) called the unit-information prior and, independently, the improper prior p s ( s ) = 1/ s.With these choices, the posterior under the Normal model (2) can be computed analytically. For example, b and s can be integrated out of the posterior in order to obtain a Markov chain for sampling from the marginal posterior on (k, j ):

$$
p ( y | k, \xi ) = \int p ( y | \beta, k, \xi, \sigma ) \pi ( \beta, \sigma | k, \xi ) \, d \beta \, d \sigma.\\ \intertext { a l $ e r $ l o d e $ ( 1 ) $, $ w e r l y $ o n $ a p r o x i m a t i o n $ $ f o r $ r a t i o n $ of m a r g i n a l i h o o d s }
$$

In the general model (1), we rely on an approximation for ratios of marginal likelihoods (4) in terms of the Bayesian information criterion, .Kass & Wasserman (1995) and
