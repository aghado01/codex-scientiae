[Page 577]

Figure 11.15 A probability distribution over two variables z1 and z2 that is uniform over the shaded regions and that is zero everywhere else.

z2

Exercises 557

z1

11.11 (��) www Show that the Gibbs sampling algorithm, discussed in Section 11.3,

satisﬁes detailed balance as deﬁned by (11.40).

11.12 (�) Consider the distribution shown in Figure 11.15. Discuss whether the standard Gibbs sampling procedure for this distribution is ergodic, and therefore whether it would sample correctly from this distribution

11.13 (��) Consider the simple 3-node graph shown in Figure 11.16 in which the observed node x is given by a Gaussian distribution N(x|µ,τ−1) with mean µ and precision τ. Suppose that the marginal distributions over the mean and precision are given by N(µ|µ0,s0) and Gam(τ|a,b), where Gam(·|·,·) denotes a gamma distribution. Write down expressions for the conditional distributions p(µ|x,τ) and p(τ|x,µ) that would be required in order to apply Gibbs sampling to the posterior distribution p(µ,τ|x).

11.14 (�) Verify that the over-relaxation update (11.50), in which zi has mean µi and variance σi, and where ν has zero mean and unit variance, gives a value zi� with mean µi and variance σi2.

11.15 (�) www Using (11.56) and (11.57), show that the Hamiltonian equation (11.58) is equivalent to (11.53). Similarly, using (11.57) show that (11.59) is equivalent to (11.55).

11.16 (�) By making use of (11.56), (11.57), and (11.63), show that the conditional dis-

tribution p(r|z) is a Gaussian.

Figure 11.16 A graph involving an observed Gaussian variable x with

prior distributions over its mean µ and precision τ.

µ τ

x
