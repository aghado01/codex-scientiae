[Page 121]

From (2.150), we see that the effect of observing N data points is to increase the value of the coefﬁcient a by N/2. Thus we can interpret the parameter a0 in the prior in terms of 2a0 ‘effective’ prior observations. Similarly, from (2.151) we see that the N data points contribute NσML2 /2 to the parameter b, where σML2 is the variance, and so we can interpret the parameter b0 in the prior as arising from the 2a0 ‘effective’ prior observations having variance 2b0/(2a0) = b0/a0. Recall

Section 2.2 that we made an analogous interpretation for the Dirichlet prior. These distributions are examples of the exponential family, and we shall see that the interpretation of a conjugate prior in terms of effective ﬁctitious data points is a general one for the exponential family of distributions.

Instead of working with the precision, we can consider the variance itself. The conjugate prior in this case is called the inverse gamma distribution, although we shall not discuss this further because we will ﬁnd it more convenient to work with the precision.

Now suppose that both the mean and the precision are unknown. To ﬁnd a conjugate prior, we consider the dependence of the likelihood function on µ and λ

�

�1/2 exp�−

(xn − µ)2�

�N

λ 2π

λ 2

p(X|µ,λ) =

n=1

��N exp�λµ

x2n�. (2.152)

∝ �λ1/2 exp�−

�N

�N

λµ2 2

λ 2

xn −

n=1

n=1

We now wish to identify a prior distribution p(µ,λ) that has the same functional dependence on µ and λ as the likelihood function and that should therefore take the form

p(µ,λ) ∝ �λ1/2 exp�−

��β exp{cλµ − dλ}

λµ2 2

= exp�−

(µ − c/β)2�λβ/2 exp�−�d −

�λ� (2.153)

c2 2β

βλ 2

where c, d, and β are constants. Since we can always write p(µ,λ) = p(µ|λ)p(λ), we can ﬁnd p(µ|λ) and p(λ) by inspection. In particular, we see that p(µ|λ) is a Gaussian whose precision is a linear function of λ and that p(λ) is a gamma distribution, so that the normalized prior takes the form

p(µ,λ) = N(µ|µ0,(βλ)−1)Gam(λ|a,b) (2.154)

where we have deﬁned new constants given by µ0 = c/β, a = 1 + β/2, b = d−c2/2β. The distribution (2.154) is called the normal-gamma or Gaussian-gamma distribution and is plotted in Figure 2.14. Note that this is not simply the product of an independent Gaussian prior over µ and a gamma prior over λ, because the precision of µ is a linear function of λ. Even if we chose a prior in which µ and λ were independent, the posterior distribution would exhibit a coupling between the precision of µ and the value of λ.
