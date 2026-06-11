[Page 139]

an interval A µ B as to the shifted interval A − c µ B − c. This implies

B−c

B

B

p(µ)dµ =

p(µ)dµ =

p(µ − c)dµ (2.234)

A−c

A

A

and because this must hold for all choices of A and B, we have

###### p(µ − c) = p(µ) (2.235)

which implies that p(µ) is constant. An example of a location parameter would be the mean µ of a Gaussian distribution. As we have seen, the conjugate prior distribution for µ in this case is a Gaussian p(µ|µ0,σ02) = N(µ|µ0,σ02), and we obtain a noninformative prior by taking the limit σ02 → ∞. Indeed, from (2.141) and (2.142) we see that this gives a posterior distribution over µ in which the contributions from the prior vanish.

As a second example, consider a density of the form

1 σ

p(x|σ) =

f

x σ

(2.236)

where σ > 0. Note that this will be a normalized density provided f(x) is correctly

- Exercise 2.59 normalized. The parameter σ is known as a scale parameter, and the density exhibits scale invariance because if we scale x by a constant to give x = cx, then


1 σ

p( x| σ) =

f

x σ

(2.237)

where we have deﬁned σ = cσ. This transformation corresponds to a change of scale, for example from meters to kilometers if x is a length, and we would like to choose a prior distribution that reﬂects this scale invariance. If we consider an interval A σ B, and a scaled interval A/c σ B/c, then the prior should assign equal probability mass to these two intervals. Thus we have

B

p(σ)dσ =

A

B/c

p(σ)dσ =

A/c

B

p

A

1 c

σ

and because this must hold for choices of A and B, we have

p(σ) = p

1 c

σ

1 c

1 c

dσ (2.238)

(2.239)

and hence p(σ) ∝ 1/σ. Note that again this is an improper prior because the integral of the distribution over 0 σ ∞ is divergent. It is sometimes also convenient to think of the prior distribution for a scale parameter in terms of the density of the log of the parameter. Using the transformation rule (1.27) for densities we see that p(lnσ) = const. Thus, for this prior there is the same probability mass in the range 1 σ 10 as in the range 10 σ 100 and in 100 σ 1000.
