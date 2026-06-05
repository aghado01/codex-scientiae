[Page 565]

# Figure 11.11

Illustration of Gibbs sampling by alternate updates of two variables whose distribution is a correlated Gaussian. The step size is governed by the standard deviation of the conditional distribution (green curve), and is O ( l ) , leading to slow progress in the direction of elongation of the joint distribution (red ellipse). The number of steps needed to obtain an independent sample from the distribution is O (( L/l ) 2 ) .

z

![The image depicts a simple orbital diagram for a simple atom, specifically a hydrogen atom. The diagram is a line graph, with the x-axis representing time (in seconds) and the y-axis representing the distance between the atoms. The graph is labeled with the following points: 1. **Center of the Orbit**: The center of the orbit is marked as (22, 22). 2. **Radius of the Orbit**: The radius of the orbit is marked as 10. 3. **Angular Motion of the Orbit**: The angle between the two axes is labeled as 22 degrees. The diagram shows a line that starts from the center of the orbit and moves to the right, eventually reaching the point (10, 22). This line is labeled as the orbital line. ### Analysis and Description: - **Position and Orientation of the Orbit**: The orbit starts from the center of the atom and moves](../images/imageFile264.png)

2

L

l

z

1

the conditional distributions are Gaussian, which represents a more general class of distributions than the multivariate Gaussian because, for example, the non-Gaussian distribution p ( z,y ) ∝ exp( − z 2 y 2 ) has Gaussian conditional distributions. At each step of the Gibbs sampling algorithm, the conditional distribution for a particular component z i has some mean µ i and some variance σ 2 i . In the over-relaxation framework, the value of z i is replaced with

$$
z _ { i } ^ { \prime } = \mu _ { i } + \alpha ( z _ { i } - \mu _ { i } ) + \sigma _ { i } ( 1 - \alpha _ { i } ^ { 2 } ) ^ { 1 / 2 } \nu
$$

where ν is a Gaussian random variable with zero mean and unit variance, and α is a parameter such that − 1 < α < 1 . For α = 0 , the method is equivalent to standard Gibbs sampling, and for α < 0 the step is biased to the opposite side of the mean. This step leaves the desired distribution invariant because if z i has mean µ i and variance σ 2 i , then so too does z i . The effect of over-relaxation is to encourage directed motion through state space when the variables are highly correlated. The framework of ordered over-relaxation (Neal, 1999) generalizes this approach to nonGaussian distributions.

The practical applicability of Gibbs sampling depends on the ease with which samples can be drawn from the conditional distributions p ( z k | z \ k ) . In the case of probability distributions speciﬁed using graphical models, the conditional distributions for individual nodes depend only on the variables in the corresponding Markov blankets, as illustrated in Figure 11.12. For directed graphs, a wide choice of conditional distributions for the individual nodes conditioned on their parents will lead to conditional distributions for Gibbs sampling that are log concave. The adaptive rejection sampling methods discussed in Section 11.1.3 therefore provide a framework for Monte Carlo sampling from directed graphs with broad applicability.

If the graph is constructed using distributions from the exponential family, and if the parent-child relationships preserve conjugacy, then the full conditional distributions arising in Gibbs sampling will have the same functional form as the orig- inal conditional distributions (conditioned on the parents) defining each node, and so standard sampling techniques can be employed. In general, the full conditional distributions will be of a complex form that does not permit the use of standard sampling algorithms. However, if these conditionals are log concave, then sampling can be done efficiently using adaptive rejection sampling (assuming the corresponding variable is a scalar).
