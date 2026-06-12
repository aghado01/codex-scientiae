[Page 653]

Figure 13.18 Example of an input-output hidden Markov model. In this case, both the emission probabilities and the transition probabilities depend on the values of a sequence of observations u1, . . . , uN.

un−1 un un+1

zn−1 zn zn+1

xn−1 xn xn+1

the two preceding observed variables as well as on the hidden state. Although this graph looks messy, we can again appeal to d-separation to see that in fact it still has a simple probabilistic structure. In particular, if we imagine conditioning on zn we see that, as with the standard HMM, the values of zn−1 and zn+1 are independent, corresponding to the conditional independence property (13.5). This is easily veriﬁed by noting that every path from node zn−1 to node zn+1 passes through at least one observed node that is head-to-tail with respect to that path. As a consequence, we can again use a forward-backward recursion in the E step of the EM algorithm to determine the posterior distributions of the latent variables in a computational time that is linear in the length of the chain. Similarly, the M step involves only a minor modiﬁcation of the standard M-step equations. In the case of Gaussian emission densities this involves estimating the parameters using the standard linear regression equations, discussed in Chapter 3.

We have seen that the autoregressive HMM appears as a natural extension of the standard HMM when viewed as a graphical model. In fact the probabilistic graphical modelling viewpoint motivates a plethora of different graphical structures based on the HMM. Another example is the input-output hidden Markov model (Bengio and Frasconi, 1995), in which we have a sequence of observed variables u1,...,uN, in addition to the output variables x1,...,xN, whose values inﬂuence either the distribution of latent variables or output variables, or both. An example is shown in Figure 13.18. This extends the HMM framework to the domain of supervised learning for sequential data. It is again easy to show, through the use of the d-separation criterion, that the Markov property (13.5) for the chain of latent variables still holds. To verify this, simply note that there is only one path from node zn−1 to node zn+1 and this is head-to-tail with respect to the observed node zn. This conditional independence property again allows the formulation of a computationally efﬁcient learning algorithm. In particular, we can determine the parameters θ of the model by maximizing the likelihood function L(θ) = p(X|U,θ) where U is a matrix whose rows are given by uTn. As a consequence of the conditional independence property (13.5) this likelihood function can be maximized efﬁciently using an EM algorithm

Exercise 13.18 in which the E step involves forward and backward recursions.

Another variant of the HMM worthy of mention is the factorial hidden Markov model (Ghahramani and Jordan, 1997), in which there are multiple independent
