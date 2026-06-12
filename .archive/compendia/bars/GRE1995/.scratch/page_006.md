[Page 6]

Then

$$
\int _ { A } \pi ( d x ) \int _ { B } q _ { m } ( x , d x ^ { \prime } ) \alpha _ { m } ( x , x ^ { \prime } ) & = \int _ { A } \int _ { B } \xi _ { m } ( d x , d x ^ { \prime } ) \\ & = \int _ { B } \int _ { A } \xi _ { m } ( d x ^ { \prime } , d x ) \\ & = \int _ { B } \pi ( d x ^ { \prime } ) \int _ { A } q _ { m } ( x )
$$

as that

$$
\alpha_m(x, x') f_m(x, x') = \alpha_m(x', x) f_m(x', x) \tag{4}
$$

As shown by Peskun (1973) with a proof only for the finite state space case, it is optimal, in the sense of reducing autocorrelation in the realised chain, to make the acceptance probability as large as possible subject to retaining detailed balance. Thus we take

$$
\alpha_m(x, x') = \min\left\{1,\, \frac{f_m(x', x)}{f_m(x, x')}\right\} \tag{5}
$$

which satisfies (4). The possibility that the denominator of the ratio above is zero is not of concern, since for such x;, dx' there is zero probability of proposing such a move, by definition of f; the ratio can therefore safely be set to an arbitrary value. Less formally; but more transparently, we could write this expression using a ratio of measures

$$
\alpha_m(x, x') = \min\left\{1,\, \frac{\pi(dx') q_m(x', dx)}{\pi(dx)\, q_m(x, dx')}\right\}
$$

For straightforward cases, the dimension-matching requirement can be imposed fairly simply; by following a standard 'template' . We give further details in $ 3-3, but in the meantime add a few remarks.

- Remark 1. The definition of the sampling method is entirely constructive. No integration; by simulation or otherwise; is needed to set up the transition mechanism.
- Remark 2 The method allows great flexibility to the algorithm designer to the structure of the problem at hand. Intuition can be used to choose moves that plausibly induce a heavy burden of algebraic and analytic work to establish validity. exploit good
- Remark 3. Although as usual with Hastings methods, the distribution T need not be normalised, relative   normalising constants between different   subspaces are needed. Specifically, while it is not necessary that the distributions Ik) are properly normalised, there must be only one unknown multiplicative constant among all such priors; unless only posteriors conditional on k are needed. Detailed balance  between different   subspaces   could not be   achieved   otherwise, apparently missed   by Grenander & Miller (1994). prior point
