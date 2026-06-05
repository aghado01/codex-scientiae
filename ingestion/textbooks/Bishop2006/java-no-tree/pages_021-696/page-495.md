[Page 495]

Figure 10.5 Directed acyclic graph representing the Bayesian mixture of Gaussians model, in which the box (plate) denotes a set of N i.i.d. observations. Here µ denotes {µk} and Λ denotes {Λk}.

zn

Λ

π

xn

µ

N

- Section 2.2.1 by (B.23). As we have seen, the parameter α0 can be interpreted as the effective prior number of observations associated with each component of the mixture. If the

value of α0 is small, then the posterior distribution will be inﬂuenced primarily by the data rather than by the prior.

Similarly, we introduce an independent Gaussian-Wishart prior governing the mean and precision of each Gaussian component, given by

p(µ,Λ) = p(µ|Λ)p(Λ)

=

K

k=1

N µk|m0,(β0Λk)−1 W(Λk|W0,ν0) (10.40)

because this represents the conjugate prior distribution when both the mean and pre-

- Section 2.3.6 cision are unknown. Typically we would choose m0 = 0 by symmetry. The resulting model can be represented as a directed graph as shown in Fig-


ure 10.5. Note that there is a link from Λ to µ since the variance of the distribution over µ in (10.40) is a function of Λ.

This example provides a nice illustration of the distinction between latent variables and parameters. Variables such as zn that appear inside the plate are regarded as latent variables because the number of such variables grows with the size of the data set. By contrast, variables such as µ that are outside the plate are ﬁxed in number independently of the size of the data set, and so are regarded as parameters. From the perspective of graphical models, however, there is really no fundamental difference between them.

###### 10.2.1 Variational distribution

In order to formulate a variational treatment of this model, we next write down the joint distribution of all of the random variables, which is given by

###### p(X,Z,π,µ,Λ) = p(X|Z,µ,Λ)p(Z|π)p(π)p(µ|Λ)p(Λ) (10.41)

in which the various factors are deﬁned above. The reader should take a moment to verify that this decomposition does indeed correspond to the probabilistic graphical model shown in Figure 10.5. Note that only the variables X = {x1,...,xN} are observed.
