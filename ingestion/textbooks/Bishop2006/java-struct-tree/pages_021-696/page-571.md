[Page 571]

Section 11.3 we see that this also leaves the desired distribution invariant. Noting that z and r are independent in the distribution p(z,r), we see that the conditional

Exercise 11.16 distribution p(r|z) is a Gaussian from which it is straightforward to sample.

In a practical application of this approach, we have to address the problem of performing a numerical integration of the Hamiltonian equations. This will necessarily introduce numerical errors and so we should devise a scheme that minimizes the impact of such errors. In fact, it turns out that integration schemes can be devised for which Liouville’s theorem still holds exactly. This property will be important in the hybrid Monte Carlo algorithm, which is discussed in Section 11.5.2. One scheme for achieving this is called the leapfrog discretization and involves alternately updating discrete-time approximations �z and �r to the position and momentum variables using

∂E ∂zi

� 2

�ri(τ + �/2) = �ri(τ) −

(�z(τ)) (11.64) �zi(τ + �) = �zi(τ) + ��ri(τ + �/2) (11.65) �ri(τ + �) = �ri(τ + �/2) −

� 2

∂E ∂zi

(�z(τ + �)). (11.66)

We see that this takes the form of a half-step update of the momentum variables with step size �/2, followed by a full-step update of the position variables with step size �, followed by a second half-step update of the momentum variables. If several leapfrog steps are applied in succession, it can be seen that half-step updates to the momentum variables can be combined into full-step updates with step size �. The successive updates to position and momentum variables then leapfrog over each other. In order to advance the dynamics by a time interval τ, we need to take τ/� steps. The error involved in the discretized approximation to the continuous time dynamics will go to zero, assuming a smooth function E(z), in the limit � → 0. However, for a nonzero � as used in practice, some residual error will remain. We shall see in Section 11.5.2 how the effects of such errors can be eliminated in the hybrid Monte Carlo algorithm.

In summary then, the Hamiltonian dynamical approach involves alternating between a series of leapfrog updates and a resampling of the momentum variables from their marginal distribution.

Note that the Hamiltonian dynamics method, unlike the basic Metropolis algorithm, is able to make use of information about the gradient of the log probability distribution as well as about the distribution itself. An analogous situation is familiar from the domain of function optimization. In most cases where gradient information is available, it is highly advantageous to make use of it. Informally, this follows from the fact that in a space of dimension D, the additional computational cost of evaluating a gradient compared with evaluating the function itself will typically be a ﬁxed factor independent of D, whereas the D-dimensional gradient vector conveys D pieces of information compared with the one piece of information given by the function itself.
