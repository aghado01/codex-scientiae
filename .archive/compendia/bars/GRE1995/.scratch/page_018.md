[Page 18]

giving equal probability to all partitions of the same degree, and placing probability on the set of g with degree d. Calculation with this is straightforward. It is necessary to count the number of partitions of degree d of a set of n items: this count c(n, d) is the solution of the recurrence relation prior

$$
c ( n , d ) = d c ( n - 1 , d ) + c ( n - 1 , d - 1 ) .
$$

Such counts become very large with n, and some care is needed to avoid overflow. An alternative model for the partitions that could have been used is Hartigan's productpartition model (Barry & Hartigan; 1992); for given d(g), this favours a more unequal distribution of the items into groups.

The joint distribution of all variables is now determined as

$$
p(g, \alpha, q, \theta | y)
= p(g) \times \prod_{j=1}^{d(g)} 1 \times p(q)
\times \prod_{j=1}^{d(g)} \prod_{i \in S_j(g)}
\frac{\theta_i^{q\alpha_j - 1}(1-\theta_i)^{q(1-\alpha_j)-1}}{B\{q\alpha_j,\, q(1-\alpha_j)\}}
\times \prod_{i=1}^{n} \binom{w_i}{y_i} \theta_i^{y_i}(1-\theta_i)^{w_i - y_i}
$$

where B(.,.) is the beta function. In the general notation of $ 2, the model indicator k is g, while the   parameter vector 0(k) is 9 01, 0n), of dimension ng = n + d(g) + 1. d(g)

### 6.2. Reversible Jump MCMC for Partition Problems

Much of the following discussion would apply, with few changes; to other partition problems. First we deal with updating the elements of 0(k) . (i =1,2, n) are independent beta distributions

$$
\theta_i \mid \cdot \;\sim\; \mathrm{Beta}\!\left(q\alpha_j + y_i,\; q(1-\alpha_j) + w_i - y_i\right)
\quad (i \in S_j(g))
$$

where, here and below, we use to denote all other variables among

$$
\{ g , \alpha _ { 1 } , \dots , \alpha _ { d ( g ) } , q , \theta _ { 1 } , \dots , \theta _ { n } \} .
$$

Therefore each 0; can be updated with a Gibbs kernel:. For 9 we find

$$
p ( q | \dots ) \circ c \, p ( q ) \times \prod _ { j = 1 } ^ { d ( g ) } \left \{ \prod _ { i \in S _ { j } ( g ) } \theta _ { i } ^ { q \alpha _ { j } - 1 } ( 1 - \theta _ { i } ) ^ { q ( 1 - \alpha _ { j } ) - 1 } \right \} ,
$$

which is not a standard distribution but is easily evaluated;, and so we use it in a Hastings with proposal that, on the scale, is uniformly distributed about the current value. The group mean parameters are also conditionally independent: step, log

$$
p(\alpha_j \mid \cdot) \propto p(\alpha_j)
\prod_{i \in S_j(g)}
\frac{\theta_i^{q\alpha_j - 1}(1-\theta_i)^{q(1-\alpha_j)-1}}{B\{q\alpha_j,\, q(1-\alpha_j)\}}
$$

Application of Stirling's formula shows that this full conditional has a normal approximation; for large q:

$$
\dots \sim N \left \{ \mu , \frac { \mu ( 1 - \mu ) } { q \# S _ { j } ( g ) } \right \} ,
$$
