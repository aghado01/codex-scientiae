[Page 574]

good approximation to the true continuous-time dynamics, it is necessary for the leapfrog integration scale to be smaller than the shortest length-scale over which the potential is varying signiﬁcantly. This is governed by the smallest value of σi, which we denote by σmin. Recall that the goal of the leapfrog integration in hybrid Monte Carlo is to move a substantial distance through phase space to a new state that is relatively independent of the initial state and still achieve a high probability of acceptance. In order to achieve this, the leapfrog integration must be continued for a number of iterations of order σmax/σmin.

By contrast, consider the behaviour of a simple Metropolis algorithm with an isotropic Gaussian proposal distribution of variance s2, considered earlier. In order to avoid high rejection rates, the value of s must be of order σmin. The exploration of state space then proceeds by a random walk and takes of order (σmax/σmin)2 steps to arrive at a roughly independent state.

###### 11.6. Estimating the Partition Function

As we have seen, most of the sampling algorithms considered in this chapter require only the functional form of the probability distribution up to a multiplicative constant. Thus if we write

pE(z) =

1 ZE

exp(−E(z)) (11.71)

then the value of the normalization constant ZE, also known as the partition function, is not needed in order to draw samples from p(z). However, knowledge of the

value of ZE can be useful for Bayesian model comparison since it represents the model evidence (i.e., the probability of the observed data given the model), and so it is of interest to consider how its value might be obtained. We assume that direct evaluation by summing, or integrating, the function exp(−E(z)) over the state space of z is intractable.

For model comparison, it is actually the ratio of the partition functions for two models that is required. Multiplication of this ratio by the ratio of prior probabilities gives the ratio of posterior probabilities, which can then be used for model selection or model averaging.

One way to estimate a ratio of partition functions is to use importance sampling from a distribution with energy function G(z)

ZE ZG

exp(−E(z)) z exp(−G(z))

= z

exp(−E(z) + G(z))exp(−G(z))

= z

z exp(−G(z))

= EG(z)[exp(−E + G)]

exp(−E(z(l)) + G(z(l))) (11.72)

l
