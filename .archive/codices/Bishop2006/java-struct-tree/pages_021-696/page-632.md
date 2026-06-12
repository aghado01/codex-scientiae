[Page 632]

Figure 13.7 If we unfold the state transition diagram of Figure 13.6 over time, we obtain a lattice, or trellis, representation of the latent states. Each column of this diagram corresponds to one of the latent variables zn.

k = 1

k = 2

A11 A11 A11

k = 3

A33 A33 A33

n − 2 n − 1 n n + 1

We can represent the emission probabilities in the form

�K

p(xn|zn,φ) =

p(xn|φk)znk

. (13.9)

k=1

We shall focuss attention on homogeneous models for which all of the conditional distributions governing the latent variables share the same parameters A, and similarly all of the emission distributions share the same parameters φ (the extension to more general cases is straightforward). Note that a mixture model for an i.i.d. data set corresponds to the special case in which the parameters Ajk are the same for all values of j, so that the conditional distribution p(zn|zn−1) is independent of zn−1. This corresponds to deleting the horizontal links in the graphical model shown in Figure 13.5.

The joint probability distribution over both latent and observed variables is then given by

p(X,Z|θ) = p(z1|π)� N

p(zn|zn−1,A)� N

�

�

p(xm|zm,φ) (13.10)

n=2

m=1

where X = {x1,...,xN}, Z = {z1,...,zN}, and θ = {π,A,φ} denotes the set of parameters governing the model. Most of our discussion of the hidden Markov model will be independent of the particular choice of the emission probabilities. Indeed, the model is tractable for a wide range of emission distributions including discrete tables, Gaussians, and mixtures of Gaussians. It is also possible to exploit

Exercise 13.4 discriminative models such as neural networks. These can be used to model the emission density p(x|z) directly, or to provide a representation for p(z|x) that can be converted into the required emission density p(x|z) using Bayes’ theorem (Bishop et al., 2004).

We can gain a better understanding of the hidden Markov model by considering it from a generative point of view. Recall that to generate samples from a mixture of
