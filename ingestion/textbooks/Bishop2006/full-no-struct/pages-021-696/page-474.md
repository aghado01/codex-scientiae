[Page 474]

complete EM cycle will change the model parameters in such a way as to cause the log likelihood to increase (unless it is already at a maximum, in which case the parameters remain unchanged).

We can also use the EM algorithm to maximize the posterior distribution p ( θ | X ) for models in which we have introduced a prior p ( θ ) over the parameters. To see this, we note that as a function of θ , we have p ( θ | X ) = p ( θ , X ) /p ( X ) and so

$$
\ln p ( \theta | X ) = \ln p ( \theta , X ) - \ln p ( X ) .
$$

Making use of the decomposition (9.70), we have

$$
\ln p ( \theta | X ) \ & = \ \mathcal { L } ( q , \theta ) + \text {KL} ( q | p ) + \ln p ( \theta ) - \ln p ( X ) \\ & \geq \ \mathcal { L } ( q , \theta ) + \ln p ( \theta ) - \ln p ( X ) . \\
$$

where ln p ( X ) is a constant. We can again optimize the right-hand side alternately with respect to q and θ . The optimization with respect to q gives rise to the same Estep equations as for the standard EM algorithm, because q only appears in L ( q, θ ) . The M-step equations are modiﬁed through the introduction of the prior term ln p ( θ ) , which typically requires only a small modiﬁcation to the standard maximum likelihood M-step equations.

The EM algorithm breaks down the potentially difﬁcult problem of maximizing the likelihood function into two stages, the E step and the M step, each of which will often prove simpler to implement. Nevertheless, for complex models it may be the case that either the E step or the M step, or indeed both, remain intractable. This leads to two possible extensions of the EM algorithm, as follows.

The generalized EM , or GEM , algorithm addresses the problem of an intractable M step. Instead of aiming to maximize L ( q, θ ) with respect to θ , it seeks instead to change the parameters in such a way as to increase its value. Again, because L ( q, θ ) is a lower bound on the log likelihood function, each complete EM cycle of the GEM algorithm is guaranteed to increase the value of the log likelihood (unless the parameters already correspond to a local maximum). One way to exploit the GEM approach would be to use one of the nonlinear optimization strategies, such as the conjugate gradients algorithm, during the M step. Another form of GEM algorithm, known as the expectation conditional maximization , or ECM, algorithm, involves making several constrained optimizations within each M step (Meng and Rubin, 1993). For instance, the parameters might be partitioned into groups, and the M step is broken down into multiple steps each of which involves optimizing one of the subset with the remainder held ﬁxed.
