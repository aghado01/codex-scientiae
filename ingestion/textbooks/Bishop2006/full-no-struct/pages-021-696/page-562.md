[Page 562]

Figure 11.10

![image 262](../images/imageFile262.png)

σ

max

ρ

σ

min

proportion of accepted transitions will be high, but progress through the state space takes the form of a slow random walk leading to long correlation times. However, if the variance parameter is large, then the rejection rate will be high because, in the kind of complex problems we are considering, many of the proposed steps will be to states for which the probability p ( z ) is low. Consider a multivariate distribution p ( z ) having strong correlations between the components of z , as illustrated in Figure 11.10. The scale ρ of the proposal distribution should be as large as possible without incurring high rejection rates. This suggests that ρ should be of the same order as the smallest length scale σ min . The system then explores the distribution along the more extended direction by means of a random walk, and so the number of steps to arrive at a state that is more or less independent of the original state is of order ( σ max /σ min ) 2 . In fact in two dimensions, the increase in rejection rate as ρ increases is offset by the larger steps sizes of those transitions that are accepted, and more generally for a multivariate Gaussian the number of steps required to obtain independent samples scales like ( σ max /σ 2 ) 2 where σ 2 is the second-smallest standard deviation (Neal, 1993). These details aside, it remains the case that if the length scales over which the distributions vary are very different in different directions, then the Metropolis Hastings algorithm can have very slow convergence.

# 11.3. Gibbs Sampling

Gibbs sampling (Geman and Geman, 1984) is a simple and widely applicable Markov chain Monte Carlo algorithm and can be seen as a special case of the MetropolisHastings algorithm.

Consider the distribution p ( z ) = p ( z 1 ,...,z M ) from which we wish to sample, and suppose that we have chosen some initial state for the Markov chain. Each step of the Gibbs sampling procedure involves replacing the value of one of the variables by a value drawn from the distribution of that variable conditioned on the values of the remaining variables. Thus we replace z i by a value drawn from the distribution p ( z i | z \ i ) , where z i denotes the i th component of z , and z \ i denotes z 1 ,...,z M but with z i omitted. This procedure is repeated either by cycling through the variables
