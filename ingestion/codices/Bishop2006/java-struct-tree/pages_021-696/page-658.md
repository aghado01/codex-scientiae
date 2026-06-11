[Page 658]

13.3.1 Inference in LDS

We now turn to the problem of ﬁnding the marginal distributions for the latent variables conditional on the observation sequence. For given parameter settings, we also wish to make predictions of the next latent state zn and of the next observation xn conditioned on the observed data x1,...,xn−1 for use in real-time applications. These inference problems can be solved efﬁciently using the sum-product algorithm, which in the context of the linear dynamical system gives rise to the Kalman ﬁlter and Kalman smoother equations.

It is worth emphasizing that because the linear dynamical system is a linearGaussian model, the joint distribution over all latent and observed variables is simply a Gaussian, and so in principle we could solve inference problems by using the standard results derived in previous chapters for the marginals and conditionals of a multivariate Gaussian. The role of the sum-product algorithm is to provide a more efﬁcient way to perform such computations.

Linear dynamical systems have the identical factorization, given by (13.6), to hidden Markov models, and are again described by the factor graphs in Figures 13.14 and 13.15. Inference algorithms therefore take precisely the same form except that summations over latent variables are replaced by integrations. We begin by considering the forward equations in which we treat zN as the root node, and propagate messages from the leaf node h(z1) to the root. From (13.77), the initial message will be Gaussian, and because each of the factors is Gaussian, all subsequent messages will also be Gaussian. By convention, we shall propagate messages that are normalized marginal distributions corresponding to p(zn|x1,...,xn), which we denote by

α�(zn) = N(zn|µn,Vn). (13.84)

This is precisely analogous to the propagation of scaled variables α�(zn) given by (13.59) in the discrete case of the hidden Markov model, and so the recursion equation now takes the form

cnα�(zn) = p(xn|zn)�

α�(zn−1)p(zn|zn−1)dzn−1. (13.85)

Substituting for the conditionals p(zn|zn−1) and p(xn|zn), using (13.75) and (13.76), respectively, and making use of (13.84), we see that (13.85) becomes

cnN(zn|µn,Vn) = N(xn|Czn,Σ)

� N(zn|Azn−1,Γ)N(zn−1|µn−1,Vn−1)dzn−1. (13.86)

Here we are supposing that µn−1 and Vn−1 are known, and by evaluating the integral in (13.86), we wish to determine values for µn and Vn. The integral is easily evaluated by making use of the result (2.115), from which it follows that

� N(zn|Azn−1,Γ)N(zn−1|µn−1,Vn−1)dzn−1

= N(zn|Aµn−1,Pn−1) (13.87)
