[Page 29]

i.e., as a piecewise constant or

$$
\gamma _ { j } = \sum _ { k = 0 } ^ { K _ { \iota } } b _ { \gamma k } ( \kappa _ { j } - \iota _ { k } ) _ { + }, \quad j = 1, \dots, K _ { \kappa },
$$

i.e., as truncated lines. A normal homoscedastic prior with precision η is placed on the new random eﬀects b γk,

$$
( b _ { \gamma k } | \eta ) \stackrel { i i d } { \sim } N ( 0, \eta ^ { - 1 } I _ { K _ { \ell } + q } ),
$$

for k = 0,...,K ι when q = 1 (truncated lines) and for k = 1,...,K ι when q = 0 (piecewise constant). Equations (3.4) and (3.5) are P-splines of degree 0 and 1, respectively.

This section is devoted to describing the priors used in the BAPS model. To begin, the prior placed on the ﬁxed eﬀects β is the same as in Chapter 2. The density p ( y | b, β,τ ) is normal, i.e.,

$$
( y | \beta, b, \tau ) \sim N ( X \beta + Z b, \tau ^ { - 1 } I _ { n } ),
$$

where τ is a precision parameter. The parameter τ has the improper Jeﬀrey’s prior,

$$
p ( \tau ) \, \infty \, \frac { 1 } { \tau } .
$$

Let ξ 1 = δ/τ and ξ 2 = η/δ be a parametrization of the smoothing parameters. It follows that δ = τξ 1.For a fully Bayesian approach, ξ 1 and ξ 2 need hyper prior speciﬁcations. The priors suggested by Yue et al. (2012) follow directly from the work of Liang et al. (2008) and Yue and Speckman (2010) where a Pareto prior is placed on ξ 1,

$$
p ( \xi _ { 1 } | c ) = \frac { c } { ( c + \xi _ { 1 } ) ^ { 2 } }, \quad \xi _ { 1 } \geq 0, \quad c > 0,
$$

and an inverse gamma prior with pdf p ( ξ 2 | a,b ) ∝ ξ − ( a +1) 2 e − b/ξ 2, ξ 2 > 0, a > 0, b > 0, is placed on ξ 2.However, Yue et al. (2012) use a Pareto prior on ξ 2 as well. To ease the computation,
