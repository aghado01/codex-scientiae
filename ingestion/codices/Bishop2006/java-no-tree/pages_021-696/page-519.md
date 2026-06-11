[Page 519]

we reproduce here for convenience

σ(z) σ(ξ)exp (z − ξ)/2 − λ(ξ)(z2 − ξ2) (10.149) where

1 2

1 2ξ

σ(ξ) −

λ(ξ) =

. (10.150) We can therefore write

###### p(t|w) = eatσ(−a) eatσ(ξ)exp −(a + ξ)/2 − λ(ξ)(a2 − ξ2) . (10.151)

Note that because this bound is applied to each of the terms in the likelihood function separately, there is a variational parameter ξn corresponding to each training set observation (φn,tn). Using a = wTφ, and multiplying by the prior distribution, we obtain the following bound on the joint distribution of t and w

p(t,w) = p(t|w)p(w) h(w,ξ)p(w) (10.152) where ξ denotes the set {ξn} of variational parameters, and

N

σ(ξn)exp wTφntn − (wTφn + ξn)/2

h(w,ξ) =

n=1

− λ(ξn)([wTφn]2 − ξn2) . (10.153)

Evaluation of the exact posterior distribution would require normalization of the lefthand side of this inequality. Because this is intractable, we work instead with the right-hand side. Note that the function on the right-hand side cannot be interpreted as a probability density because it is not normalized. Once it is normalized to give a variational posterior distribution q(w), however, it no longer represents a bound.

Because the logarithm function is monotonically increasing, the inequality A B implies lnA lnB. This gives a lower bound on the log of the joint distribution of t and w of the form

N

lnσ(ξn) + wTφntn

ln{p(t|w)p(w)} lnp(w) +

n=1

− (wTφn + ξn)/2 − λ(ξn)([wTφn]2 − ξn2) . (10.154)

Substituting for the prior p(w), the right-hand side of this inequality becomes, as a function of w

1 2

(w − m0)TS−1

0 (w − m0)

−

N

wTφn(tn − 1/2) − λ(ξn)wT(φnφTn)w + const. (10.155)

+

n=1
