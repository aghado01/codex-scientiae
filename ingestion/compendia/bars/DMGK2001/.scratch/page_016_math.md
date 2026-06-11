[Page 16]

Importance sampling

We wish to determine the weight for our problem. If g( b, k, j ) is the functional of interest, we need to compute

$$
\text { need to compute } & & \int \dots \int g ( \beta, \xi, k ) \frac { q ( \beta | y, k, \xi ) } { \hat { q } ( \beta | y, \xi, k ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & E \{ g ( \beta, \xi, k ) | y \} = \frac { } { \int \dots \int \frac { q ( \beta | y, k, \xi ) } { \hat { q } ( \beta | y, \xi, k ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k } = \frac { A } { B }, \\ \intertext { s a y, $ where }
$$

say, where

Therefore

$$
s y, \text { where } & & 4 = \int \dots \int g ( \beta, k, \xi ) q ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & = \int \dots \int g ( \beta, k, \xi ) \, \frac { q ( \beta | y, k, \xi ) } { \hat { q } ( \beta | y, k, \xi ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & = \int \dots \int g ( \beta, k, \xi ) \, \frac { p ( y | \beta, k, \xi ) \pi _ { \beta } ( \beta | k, \xi ) } { \hat { p } ( y | \beta, \xi, k ) \pi _ { \beta } ( \beta | \xi, k ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k \\ & = \frac { \hat { p } ( y ) } { p ( y ) } \int \dots \int g ( \beta, \xi, k ) \, \frac { p ( y | \beta, k, \xi ) } { \hat { p } ( y | \beta, \xi, k ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k, \\ B = \frac { \hat { p } ( y ) } { p ( y ) } \int \dots \int \frac { p ( y | \beta, k, \xi ) } { \hat { p } ( y | \beta, \xi, k ) } \, \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k.\\ \text { Therefore}
$$

$$
\frac { y } { y } \int \dots \int \frac { p ( y | \beta, } { \hat { p } ( y | \beta, }
$$

$$
\text {Therefor} \\ E \{ g ( \beta, \xi, k ) | y \} = \frac { \int \dots \int g ( \beta, \xi, k ) \frac { p ( y | \beta, k, \xi ) } { \hat { p } ( y | \beta, \xi, k ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k } { \int \dots \int \frac { \underline { p ( y | \beta, k, \xi ) } } { \hat { p } ( y | \beta, \xi, k ) } \hat { q } ( \beta | y, k, \xi ) p ( k, \xi | y ) \, d \beta \, d \xi \, d k } \\ \simeq \frac { \sum _ { l } g ( \beta ^ { ( \ell ) }, \xi ^ { ( \ell ) }, k ^ { ( \ell ) } ) w ( \beta ^ { ( \ell ) }, \xi ^ { ( \ell ) }, k ^ { ( \ell ) } ) } { \sum _ { l } w ( \beta ^ { ( \ell ) }, \xi ^ { ( \ell ) }, k ^ { ( \ell ) } ) }, \\ \text {where}
$$

where

$$
w ( \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) = \frac { p ( y | \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) } { \hat { p } ( y | \beta ^ { ( l ) }, \xi ^ { ( l ) }, k ^ { ( l ) } ) },
$$

( j (l), k (l) ) is the pair accepted by the reversible-jump sampler, i.e. is sampled from p(k, j | y), and h (l) is sampled from q @ ( b | y, j (l), k (l) ).

First, we elaborate on the essential property of the  -based approximation we are using. Let p @ (y | k, j ) be the approximation to p(y | k, j ) and assume that k ∏ K for some ﬁxed K. Then, from Laplace’s method, p @ (y | k, j ) = p(y | k, j ){1 + O p (n − 1/2 )} uniformly in (k, j ). Here, O p refers to the sampling distribution of the data. Let us use Pr to denote probabilities under this sampling distribution and let V denote the space of (k, j ) values. It follows by integration that, for any arbitrarily small positive g, there exists a bound M such that, for all measurable subsets A k V and for all
