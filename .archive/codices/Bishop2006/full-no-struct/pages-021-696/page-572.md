[Page 572]

# 11.5.2 Hybrid Monte Carlo

As we discussed in the previous section, for a nonzero step size , the discretization of the leapfrog algorithm will introduce errors into the integration of the Hamiltonian dynamical equations. Hybrid Monte Carlo (Duane et al. , 1987; Neal, 1996) combines Hamiltonian dynamics with the Metropolis algorithm and thereby removes any bias associated with the discretization.

Speciﬁcally, the algorithm uses a Markov chain consisting of alternate stochastic updates of the momentum variable r and Hamiltonian dynamical updates using the leapfrog algorithm. After each application of the leapfrog algorithm, the resulting candidate state is accepted or rejected according to the Metropolis criterion based on the value of the Hamiltonian H . Thus if ( z , r ) is the initial state and ( z , r ) is the state after the leapfrog integration, then this candidate state is accepted with probability

$$
\min \left ( 1 , \exp \{ H ( z , r ) - H ( z ^ { * } , r ^ { * } ) \} \right ) . \\
$$

If the leapfrog integration were to simulate the Hamiltonian dynamics perfectly, then every such candidate step would automatically be accepted because the value of H would be unchanged. Due to numerical errors, the value of H may sometimes decrease, and we would like the Metropolis criterion to remove any bias due to this effect and ensure that the resulting samples are indeed drawn from the required distribution. In order for this to be the case, we need to ensure that the update equations corresponding to the leapfrog integration satisfy detailed balance (11.40). This is easily achieved by modifying the leapfrog scheme as follows.

Before the start of each leapfrog integration sequence, we choose at random, with equal probability, whether to integrate forwards in time (using step size ) or backwards in time (using step size − ). We ﬁrst note that the leapfrog integration scheme (11.64), (11.65), and (11.66) is time-reversible, so that integration for L steps using step size − will exactly undo the effect of integration for L steps using step size . Next we show that the leapfrog integration preserves phase-space volume exactly. This follows from the fact that each step in the leapfrog scheme updates either a z i variable or an r i variable by an amount that is a function only of the other variable. As shown in Figure 11.14, this has the effect of shearing a region of phase space while not altering its volume.

Finally, we use these results to show that detailed balance holds. Consider a small region R of phase space that, under a sequence of L leapfrog iterations of step size , maps to a region R . Using conservation of volume under the leapfrog iteration, we see that if R has volume δV then so too will R . If we choose an initial point from the distribution (11.63) and then update it using L leapfrog interactions, the probability of the transition going from R to R is given by

$$
\frac { 1 } { Z _ { H } } \exp ( - H ( \mathcal { R } ) ) \delta V \frac { 1 } { 2 } \min \left \{ 1 , \exp ( - H ( \mathcal { R } ) + H ( \mathcal { R } ^ { \prime } ) ) \right \} .
$$

where the factor of 1 / 2 arises from the probability of choosing to integrate with a positive step size rather than a negative one. Similarly, the probability of starting in
