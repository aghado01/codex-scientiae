[Page 574]

good approximation to the true continuous-time dynamics, it is necessary for the leapfrog integration scale to be smaller than the shortest length-scale over which the potential is varying signiﬁcantly. This is governed by the smallest value of σ i , which we denote by σ min . Recall that the goal of the leapfrog integration in hybrid Monte Carlo is to move a substantial distance through phase space to a new state that is relatively independent of the initial state and still achieve a high probability of acceptance. In order to achieve this, the leapfrog integration must be continued for a number of iterations of order σ max /σ min .

By contrast, consider the behaviour of a simple Metropolis algorithm with an isotropic Gaussian proposal distribution of variance s 2 , considered earlier. In order to avoid high rejection rates, the value of s must be of order σ min . The exploration of state space then proceeds by a random walk and takes of order ( σ max /σ min ) 2 steps to arrive at a roughly independent state.

# 11.6. Estimating the Partition Function

As we have seen, most of the sampling algorithms considered in this chapter require only the functional form of the probability distribution up to a multiplicative constant. Thus if we write

$$
p _ { E } ( z ) = \frac { 1 } { Z _ { E } } \exp ( - E ( z ) )
$$

then the value of the normalization constant Z E , also known as the partition function, is not needed in order to draw samples from p ( z ) . However, knowledge of the value of Z E can be useful for Bayesian model comparison since it represents the model evidence (i.e., the probability of the observed data given the model), and so it is of interest to consider how its value might be obtained. We assume that direct evaluation by summing, or integrating, the function exp( − E ( z )) over the state space of z is intractable.

For model comparison, it is actually the ratio of the partition functions for two models that is required. Multiplication of this ratio by the ratio of prior probabilities gives the ratio of posterior probabilities, which can then be used for model selection or model averaging.

One way to estimate a ratio of partition functions is to use importance sampling from a distribution with energy function G ( z )

$$
\text {one way to estimate a ratio of parition functions is to use importance sampling} \\ \intertext { a d i t b u i n g t h e r g y f u n c t i o n } \frac { Z _ { E } } { Z _ { G } } \ = \ \frac { \sum _ { z } \exp ( - E ( z ) ) } { \sum _ { z } \exp ( - G ( z ) ) } \\ \ = \ \sum _ { z } \exp ( - E ( z ) + G ( z ) ) \exp ( - G ( z ) ) \\ \ = \ \int _ { G ( z ) [ \exp ( - E + G ) ] } \exp ( - E ( z ) ) \\ \simeq \ \sum _ { l } \exp ( - E ( z ^ { ( l ) } ) + G ( z ^ { ( l ) } ) )
$$
