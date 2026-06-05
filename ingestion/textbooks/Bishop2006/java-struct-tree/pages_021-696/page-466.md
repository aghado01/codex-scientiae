[Page 466]

variable z associated with each instance of x. As in the case of the Gaussian mixture, z = (z1,...,zK)T is a binary K-dimensional variable having a single component equal to 1, with all other components equal to 0. We can then write the conditional distribution of x, given the latent variable, as

�K

p(x|z,µ) =

p(x|µk)zk (9.52)

k=1

while the prior distribution for the latent variables is the same as for the mixture of Gaussians model, so that

�K

πz

p(z|π) =

k . (9.53)

k

k=1

If we form the product of p(x|z,µ) and p(z|π) and then marginalize over z, then we Exercise 9.14 recover (9.47).

In order to derive the EM algorithm, we ﬁrst write down the complete-data log likelihood function, which is given by

znk �lnπk

�N

�K

lnp(X,Z|µ,π) =

n=1

k=1

[xni lnµki + (1 − xni)ln(1 − µki)]� (9.54)

�D

+

i=1

where X = {xn} and Z = {zn}. Next we take the expectation of the complete-data log likelihood with respect to the posterior distribution of the latent variables to give

γ(znk)�lnπk

�N

�K

EZ[lnp(X,Z|µ,π)] =

n=1

k=1

[xni lnµki + (1 − xni)ln(1 − µki)]� (9.55)

�D

+

i=1

where γ(znk) = E[znk] is the posterior probability, or responsibility, of component k given data point xn. In the E step, these responsibilities are evaluated using Bayes’ theorem, which takes the form

�

znk [πkp(xn|µk)]z

nk

znk

γ(znk) = E[znk] =

�

�

�z

πjp(xn|µj)

nj

znj

πkp(xn|µk) �K

=

. (9.56)

πjp(xn|µj)

j=1
