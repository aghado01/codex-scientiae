[Page 492]

2

τ

(a)

1

2

τ

(b)

1

0

µ

−1 0 1

2

(c)

τ

0

µ

−1 0 1

2

(d)

τ

1

1

0

µ

−1 0 1

0

µ

−1 0 1

Figure 10.4 Illustration of variational inference for the mean µ and precision τ of a univariate Gaussian distribution. Contours of the true posterior distribution p(µ, τ|D) are shown in green. (a) Contours of the initial factorized approximation qµ(µ)qτ(τ) are shown in blue. (b) After re-estimating the factor qµ(µ). (c) After re-estimating the factor qτ(τ). (d) Contours of the optimal factorized approximation, to which the iterative scheme converges, are shown in red.

In general, we will need to use an iterative approach such as this in order to solve for the optimal factorized posterior distribution. For the very simple example we are considering here, however, we can ﬁnd an explicit solution by solving the simultaneous equations for the optimal factors qµ(µ) and qτ(τ). Before doing this, we can simplify these expressions by considering broad, noninformative priors in which µ0 = a0 = b0 = λ0 = 0. Although these parameter settings correspond to improper priors, we see that the posterior distribution is still well deﬁned. Using the

Appendix B standard result E[τ] = aN/bN for the mean of a gamma distribution, together with

(10.29) and (10.30), we have

= E� 1 N

(xn − µ)2� = x2 − 2xE[µ] + E[µ2]. (10.31)

�N

1 E[τ]

n=1

Then, using (10.26) and (10.27), we obtain the ﬁrst and second order moments of
