[Page 459]

3. M step. Re-estimate the parameters using the current responsibilities

�N

1 Nk

µnewk =

γ(znk)xn (9.24)

n=1

�N

1 Nk

γ(znk)(xn − µnewk )(xn − µnewk )T (9.25)

Σnewk =

n=1

Nk N

πknew =

(9.26) where

�N

Nk =

γ(znk). (9.27)

n=1

4. Evaluate the log likelihood

ln� K

πkN(xn|µk,Σk)� (9.28)

�N

�

lnp(X|µ,Σ,π) =

n=1

k=1

and check for convergence of either the parameters or the log likelihood. If the convergence criterion is not satisﬁed return to step 2.

9.3. An Alternative View of EM

In this section, we present a complementary view of the EM algorithm that recognizes the key role played by latent variables. We discuss this approach ﬁrst of all in an abstract setting, and then for illustration we consider once again the case of Gaussian mixtures.

The goal of the EM algorithm is to ﬁnd maximum likelihood solutions for models having latent variables. We denote the set of all observed data by X, in which the nth row represents xTn, and similarly we denote the set of all latent variables by Z, with a corresponding row zTn. The set of all model parameters is denoted by θ, and so the log likelihood function is given by

lnp(X|θ) = ln�

p(X,Z|θ)�. (9.29)

�

Z

Note that our discussion will apply equally well to continuous latent variables simply by replacing the sum over Z with an integral.

A key observation is that the summation over the latent variables appears inside the logarithm. Even if the joint distribution p(X,Z|θ) belongs to the exponential
