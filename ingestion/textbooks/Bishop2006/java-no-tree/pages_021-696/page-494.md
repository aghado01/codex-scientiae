[Page 494]

of (10.35), and then subsequently determining the q(m) using (10.36). After normalization the resulting values for q(m) can be used for model selection or model averaging in the usual way.

###### 10.2. Illustration: Variational Mixture of Gaussians

We now return to our discussion of the Gaussian mixture model and apply the variational inference machinery developed in the previous section. This will provide a good illustration of the application of variational methods and will also demonstrate how a Bayesian treatment elegantly resolves many of the difﬁculties associated with the maximum likelihood approach (Attias, 1999b). The reader is encouraged to work through this example in detail as it provides many insights into the practical application of variational methods. Many Bayesian models, corresponding to much more sophisticated distributions, can be solved by straightforward extensions and generalizations of this analysis.

Our starting point is the likelihood function for the Gaussian mixture model, illustrated by the graphical model in Figure 9.6. For each observation xn we have a corresponding latent variable zn comprising a 1-of-K binary vector with elements znk for k = 1,...,K. As before we denote the observed data set by X = {x1,...,xN}, and similarly we denote the latent variables by Z = {z1,...,zN}. From (9.10) we can write down the conditional distribution of Z, given the mixing coefﬁcients π, in the form

N

p(Z|π) =

n=1

###### K

πz

k . (10.37)

nk

k=1

Similarly, from (9.11), we can write down the conditional distribution of the observed data vectors, given the latent variables and the component parameters

N

p(X|Z,µ,Λ) =

n=1

###### K

N xn|µk,Λ−1

k

k=1

znk (10.38)

where µ = {µk} and Λ = {Λk}. Note that we are working in terms of precision matrices rather than covariance matrices as this somewhat simpliﬁes the mathematics.

Next we introduce priors over the parameters µ, Λ and π. The analysis is conSection 10.4.1 siderably simpliﬁed if we use conjugate prior distributions. We therefore choose a

Dirichlet distribution over the mixing coefﬁcients π

K

p(π) = Dir(π|α0) = C(α0)

k=1

0−1

πα

k (10.39)

where by symmetry we have chosen the same parameter α0 for each of the components, and C(α0) is the normalization constant for the Dirichlet distribution deﬁned
