[Page 638]

Gaussian emission densities we have p(x|φk) = N(x|µk,Σk), and maximization of the function Q(θ,θold) then gives

µk =

Σk =

N

γ(znk)xn

n=1

(13.20)

N

γ(znk)

n=1

N

γ(znk)(xn − µk)(xn − µk)T

n=1

. (13.21)

N

γ(znk)

n=1

For the case of discrete multinomial observed variables, the conditional distribution of the observations takes the form

D

p(x|z) =

i=1

###### K

µx

izk

ik (13.22)

k=1

Exercise 13.8 and the corresponding M-step equations are given by

N

γ(znk)xni

n=1

µik =

. (13.23)

N

γ(znk)

n=1

An analogous result holds for Bernoulli observed variables.

The EM algorithm requires initial values for the parameters of the emission distribution. One way to set these is ﬁrst to treat the data initially as i.i.d. and ﬁt the emission density by maximum likelihood, and then use the resulting values to initialize the parameters for EM.

###### 13.2.2 The forward-backward algorithm

Next we seek an efﬁcient procedure for evaluating the quantities γ(znk) and ξ(zn−1,j,znk), corresponding to the E step of the EM algorithm. The graph for the hidden Markov model, shown in Figure 13.5, is a tree, and so we know that the posterior distribution of the latent variables can be obtained efﬁciently using a two-

Section 8.4 stage message passing algorithm. In the particular context of the hidden Markov model, this is known as the forward-backward algorithm (Rabiner, 1989), or the Baum-Welch algorithm (Baum, 1972). There are in fact several variants of the basic algorithm, all of which lead to the exact marginals, according to the precise form of
