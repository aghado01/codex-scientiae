[Page 286]

in which the parameter ξ is drawn from a distribution p(ξ), then the error function deﬁned over this expanded data set can be written as

- 1

- 2 {y(s(x,ξ)) − t}2p(t|x)p(x)p(ξ)dxdtdξ. (5.130)


E =

We now assume that the distribution p(ξ) has zero mean with small variance, so that we are only considering small transformations of the original input vectors. We can then expand the transformation function as a Taylor series in powers of ξ to give

ξ2 2

∂ ∂ξ

s(x,ξ)

+

s(x,ξ) = s(x,0) + ξ

ξ=0

1 2

= x + ξτ +

ξ2τ + O(ξ3)

∂2 ∂ξ2

s(x,ξ)

+ O(ξ3)

ξ=0

where τ denotes the second derivative of s(x,ξ) with respect to ξ evaluated at ξ = 0. This allows us to expand the model function to give

ξ2 2

(τ )T ∇y(x) + τT∇∇y(x)τ + O(ξ3). Substituting into the mean error function (5.130) and expanding, we then have

y(s(x,ξ)) = y(x) + ξτT∇y(x) +

E =

1 2 {y(x) − t}2p(t|x)p(x)dxdt

+ E[ξ] {y(x) − t}τT∇y(x)p(t|x)p(x)dxdt

1 2

(τ )T ∇y(x) + τT∇∇y(x)τ

+ E[ξ2] {y(x) − t}

+ τT∇y(x) 2 p(t|x)p(x)dxdt + O(ξ3).

Because the distribution of transformations has zero mean we have E[ξ] = 0. Also, we shall denote E[ξ2] by λ. Omitting terms of O(ξ3), the average error function then becomes

###### E = E + λΩ (5.131)

where E is the original sum-of-squares error, and the regularization term Ω takes the form

- 1

- 2


Ω = {y(x) − E[t|x]}

(τ )T ∇y(x) + τT∇∇y(x)τ

+ τT∇y(x) 2 p(x)dx (5.132)

in which we have performed the integration over t.
