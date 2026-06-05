[Page 558]

and which scales well with the dimensionality of the sample space. Markov chain Monte Carlo methods have their origins in physics (Metropolis and Ulam, 1949), and it was only towards the end of the 1980s that they started to have a signiﬁcant impact in the ﬁeld of statistics.

As with rejection and importance sampling, we again sample from a proposal distribution. This time, however, we maintain a record of the current state z(τ), and the proposal distribution q(z|z(τ)) depends on this current state, and so the sequence

Section 11.2.1 of samples z(1),z(2),... forms a Markov chain. Again, if we write p(z) = p(z)/Zp, we will assume that p(z) can readily be evaluated for any given value of z, although the value of Zp may be unknown. The proposal distribution itself is chosen to be sufﬁciently simple that it is straightforward to draw samples from it directly. At each cycle of the algorithm, we generate a candidate sample z from the proposal distribution and then accept the sample according to an appropriate criterion.

In the basic Metropolis algorithm (Metropolis et al., 1953), we assume that the proposal distribution is symmetric, that is q(zA|zB) = q(zB|zA) for all values of zA and zB. The candidate sample is then accepted with probability

p(z ) p(z(τ))

A(z ,z(τ)) = min 1,

. (11.33)

This can be achieved by choosing a random number u with uniform distribution over the unit interval (0,1) and then accepting the sample if A(z ,z(τ)) > u. Note that if the step from z(τ) to z causes an increase in the value of p(z), then the candidate point is certain to be kept.

If the candidate sample is accepted, then z(τ+1) = z , otherwise the candidate point z is discarded, z(τ+1) is set to z(τ) and another candidate sample is drawn from the distribution q(z|z(τ+1)). This is in contrast to rejection sampling, where rejected samples are simply discarded. In the Metropolis algorithm when a candidate point is rejected, the previous sample is included instead in the ﬁnal list of samples, leading to multiple copies of samples. Of course, in a practical implementation, only a single copy of each retained sample would be kept, along with an integer weighting factor recording how many times that state appears. As we shall see, as long as q(zA|zB) is positive for any values of zA and zB (this is a sufﬁcient but not necessary condition), the distribution of z(τ) tends to p(z) as τ → ∞. It should be emphasized, however, that the sequence z(1),z(2),... is not a set of independent samples from p(z) because successive samples are highly correlated. If we wish to obtain independent samples, then we can discard most of the sequence and just retain every Mth sample. For M sufﬁciently large, the retained samples will for all practical purposes be independent. Figure 11.9 shows a simple illustrative example of sampling from a two-dimensional Gaussian distribution using the Metropolis algorithm in which the proposal distribution is an isotropic Gaussian.

Further insight into the nature of Markov chain Monte Carlo algorithms can be gleaned by looking at the properties of a speciﬁc example, namely a simple random
