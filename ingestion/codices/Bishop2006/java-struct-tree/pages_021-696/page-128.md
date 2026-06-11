[Page 128]

m = 5, θ0 = π/4 m = 1, θ0 = 3π/4

π/4 3π/4

0

2π

m = 5, θ0 = π/4 m = 1, θ0 = 3π/4

Figure 2.19 The von Mises distribution plotted for two different parameter values, shown as a Cartesian plot on the left and as the corresponding polar plot on the right.

where ‘const’ denotes terms independent of θ, and we have made use of the following Exercise 2.51 trigonometrical identities

cos2 A + sin2 A = 1 (2.177) cosAcosB + sinAsinB = cos(A − B). (2.178)

If we now deﬁne m = r0/σ2, we obtain our ﬁnal expression for the distribution of p(θ) along the unit circle r = 1 in the form

1 2πI0(m)

p(θ|θ0,m) =

exp{mcos(θ − θ0)} (2.179)

which is called the von Mises distribution, or the circular normal. Here the parameter θ0 corresponds to the mean of the distribution, while m, which is known as the concentration parameter, is analogous to the inverse variance (precision) for the Gaussian. The normalization coefﬁcient in (2.179) is expressed in terms of I0(m), which is the zeroth-order Bessel function of the ﬁrst kind (Abramowitz and Stegun, 1965) and is deﬁned by

� 2π

1 2π

exp{mcosθ} dθ. (2.180) Exercise 2.52 For large m, the distribution becomes approximately Gaussian. The von Mises distribution is plotted in Figure 2.19, and the function I0(m) is plotted in Figure 2.20.

I0(m) =

0

Now consider the maximum likelihood estimators for the parameters θ0 and m for the von Mises distribution. The log likelihood function is given by

�N

lnp(D|θ0,m) = −N ln(2π) − N lnI0(m) + m

cos(θn − θ0). (2.181)
