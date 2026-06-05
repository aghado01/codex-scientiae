[Page 564]

To show that this procedure samples from the required distribution, we ﬁrst of all note that the distribution p(z) is an invariant of each of the Gibbs sampling steps individually and hence of the whole Markov chain. This follows from the fact that when we sample from p(zi|{z\i), the marginal distribution p(z\i) is clearly invariant because the value of z\i is unchanged. Also, each step by deﬁnition samples from the correct conditional distribution p(zi|z\i). Because these conditional and marginal distributions together specify the joint distribution, we see that the joint distribution is itself invariant.

The second requirement to be satisﬁed in order that the Gibbs sampling procedure samples from the correct distribution is that it be ergodic. A sufﬁcient condition for ergodicity is that none of the conditional distributions be anywhere zero. If this is the case, then any point in z space can be reached from any other point in a ﬁnite number of steps involving one update of each of the component variables. If this requirement is not satisﬁed, so that some of the conditional distributions have zeros, then ergodicity, if it applies, must be proven explicitly.

The distribution of initial states must also be speciﬁed in order to complete the algorithm, although samples drawn after many iterations will effectively become independent of this distribution. Of course, successive samples from the Markov chain will be highly correlated, and so to obtain samples that are nearly independent it will be necessary to subsample the sequence.

We can obtain the Gibbs sampling procedure as a particular instance of the Metropolis-Hastings algorithm as follows. Consider a Metropolis-Hastings sampling step involving the variable zk in which the remaining variables z\k remain ﬁxed, and for which the transition probability from z to z� is given by qk(z�|z) = p(zk�|z\k). We note that z�\k = z\k because these components are unchanged by the sampling step. Also, p(z) = p(zk|z\k)p(z\k). Thus the factor that determines the acceptance probability in the Metropolis-Hastings (11.44) is given by

p(zk�|z�\k)p(z�\k)p(zk|z�\k) p(zk|z\k)p(z\k)p(zk�|z\k)

p(z�)qk(z|z�) p(z)qk(z�|z)

A(z�,z) =

=

= 1 (11.49)

where we have used z�\k = z\k. Thus the Metropolis-Hastings steps are always accepted.

As with the Metropolis algorithm, we can gain some insight into the behaviour of Gibbs sampling by investigating its application to a Gaussian distribution. Consider a correlated Gaussian in two variables, as illustrated in Figure 11.11, having conditional distributions of width l and marginal distributions of width L. The typical step size is governed by the conditional distributions and will be of order l. Because the state evolves according to a random walk, the number of steps needed to obtain independent samples from the distribution will be of order (L/l)2. Of course if the Gaussian distribution were uncorrelated, then the Gibbs sampling procedure would be optimally efﬁcient. For this simple problem, we could rotate the coordinate system in order to decorrelate the variables. However, in practical applications it will generally be infeasible to ﬁnd such transformations.

One approach to reducing random walk behaviour in Gibbs sampling is called over-relaxation (Adler, 1981). In its original form, this applies to problems for which
