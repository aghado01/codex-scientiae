[Page 705]

# Appendix B. Probability Distributions

In this appendix, we summarize the main properties of some of the most widely used probability distributions, and for each distribution we list some key statistics such as the expectation E [ x ] , the variance (or covariance), the mode, and the entropy H[ x ] . All of these distributions are members of the exponential family and are widely used as building blocks for more sophisticated probabilistic models.

# Bernoulli

This is the distribution for a single binary variable x ∈ { 0 , 1 } representing, for example, the result of ﬂipping a coin. It is governed by a single continuous parameter µ ∈ [0 , 1] that represents the probability of x = 1 .

$$
\ B e r n ( x | \mu ) \ & = \ \mu ^ { x } ( 1 - \mu ) ^ { 1 - x } & & ( B . 1 ) \\ \mathbb { F } [ x ] & \ = \ \mu & & ( B . 2 )
$$

$$
\mathbb { E } [ x ] \ = \ \mu
$$

$$
\ v a r [ x ] \ = \ \mu ( 1 - \mu ) & & ( B . 3 ) \\ & & \\ & ( \ 1 \ \text {if} \ \mu > 0 \ 5 &
$$

$$
\var { u } [ x ] & \ = \ \mu ( 1 - \mu ) \quad & ( B . 3 ) \\ \mod [ x ] & \ = \ \begin{cases} \ 1 & \text {if } \mu \geqslant 0 . 5 , \\ \ 0 & \text {otherwise} \end{cases} \\ H [ x ] & \ = \ - \mu \ln \mu - ( 1 - \mu ) \ln ( 1 - \mu ) .
$$

$$
H [ x ] \ = \ - \mu \ln \mu - ( 1 - \mu ) \ln ( 1 - \mu ) .
$$

The Bernoulli is a special case of the binomial distribution for the case of a single observation. Its conjugate prior for µ is the beta distribution.
