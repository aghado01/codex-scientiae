[Page 488]

- Figure 10.2 Comparison of the two alternative forms for the Kullback-Leibler divergence. The green contours corresponding to 1, 2, and 3 standard deviations for a correlated Gaussian distribution


p(z) over two variables z1 and z2, and the red contours represent the corresponding levels for an approximating distribution q(z) over the same variables given by the product of two independent univariate Gaussian distributions whose parameters are obtained by minimization of (a) the KullbackLeibler divergence KL(q p), and (b) the reverse Kullback-Leibler divergence KL(p q).

- 0.5
- 1


1

| |
|---|


| |
|---|


z2

z2

0.5

0

0

0 0.5 1

0 0.5 1

z1

z1

(b)

(a)

is used in an alternative approximate inference framework called expectation prop-

Section 10.7 agation. We therefore consider the general problem of minimizing KL(p q) when q(Z) is a factorized approximation of the form (10.5). The KL divergence can then be written in the form

KL(p q) = − p(Z)

M

lnqi(Zi) dZ + const (10.16)

i=1

where the constant term is simply the entropy of p(Z) and so does not depend on q(Z). We can now optimize with respect to each of the factors qj(Zj), which is

Exercise 10.3 easily done using a Lagrange multiplier to give

q j(Zj) = p(Z)

i =j

dZi = p(Zj). (10.17)

In this case, we ﬁnd that the optimal solution for qj(Zj) is just given by the corresponding marginal distribution of p(Z). Note that this is a closed-form solution and so does not require iteration.

To apply this result to the illustrative example of a Gaussian distribution p(z) over a vector z we can use (2.98), which gives the result shown in Figure 10.2(b). We see that once again the mean of the approximation is correct, but that it places signiﬁcant probability mass in regions of variable space that have very low probability.

The difference between these two results can be understood by noting that there is a large positive contribution to the Kullback-Leibler divergence

KL(q p) = − q(Z)ln

p(Z) q(Z)

dZ (10.18)
