[Page 705]

###### Appendix B. Probability Distributions

In this appendix, we summarize the main properties of some of the most widely used probability distributions, and for each distribution we list some key statistics such as the expectation E[x], the variance (or covariance), the mode, and the entropy H[x]. All of these distributions are members of the exponential family and are widely used

- as building blocks for more sophisticated probabilistic models.


###### Bernoulli

This is the distribution for a single binary variable x ∈ {0,1} representing, for example, the result of ﬂipping a coin. It is governed by a single continuous parameter µ ∈ [0,1] that represents the probability of x = 1.

Bern(x|µ) = µx(1 − µ)1−x (B.1) E[x] = µ (B.2)

var[x] = µ(1 − µ) (B.3) mode[x] =

1 if µ 0.5, 0 otherwise

(B.4) H[x] = −µlnµ − (1 − µ)ln(1 − µ). (B.5)

The Bernoulli is a special case of the binomial distribution for the case of a single observation. Its conjugate prior for µ is the beta distribution.

###### 685
