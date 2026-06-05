[Page 465]

Consider a set of D binary variables xi, where i = 1,...,D, each of which is governed by a Bernoulli distribution with parameter µi, so that

�D

µx

i (1 − µi)(1−xi) (9.44)

p(x|µ) =

i

i=1

where x = (x1,...,xD)T and µ = (µ1,...,µD)T. We see that the individual variables xi are independent, given µ. The mean and covariance of this distribution are easily seen to be

E[x] = µ (9.45) cov[x] = diag{µi(1 − µi)}. (9.46)

Now let us consider a ﬁnite mixture of these distributions given by

�K

πkp(x|µk) (9.47)

p(x|µ,π) =

k=1

where µ = {µ1,...,µK}, π = {π1,...,πK}, and

�D

µx

p(x|µk) =

ki(1 − µki)(1−xi). (9.48)

i

i=1

Exercise 9.12 The mean and covariance of this mixture distribution are given by

�K

E[x] =

πkµk (9.49)

k=1

�K

�

� − E[x]E[x]T (9.50)

Σk + µkµTk

cov[x] =

πk

k=1

where Σk = diag {µki(1 − µki)}. Because the covariance matrix cov[x] is no longer diagonal, the mixture distribution can capture correlations between the variables, unlike a single Bernoulli distribution.

If we are given a data set X = {x1,...,xN} then the log likelihood function for this model is given by

ln� K

πkp(xn|µk)�. (9.51)

�N

�

lnp(X|µ,π) =

n=1

k=1

Again we see the appearance of the summation inside the logarithm, so that the maximum likelihood solution no longer has closed form.

We now derive the EM algorithm for maximizing the likelihood function for the mixture of Bernoulli distributions. To do this, we ﬁrst introduce an explicit latent
