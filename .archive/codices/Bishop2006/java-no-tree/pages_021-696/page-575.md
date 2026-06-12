[Page 575]

###### 11.6. Estimating the Partition Function 555

where {z(l)} are samples drawn from the distribution deﬁned by pG(z). If the distribution pG is one for which the partition function can be evaluated analytically, for example a Gaussian, then the absolute value of ZE can be obtained.

This approach will only yield accurate results if the importance sampling distribution pG is closely matched to the distribution pE, so that the ratio pE/pG does not have wide variations. In practice, suitable analytically speciﬁed importance sampling distributions cannot readily be found for the kinds of complex models considered in this book.

An alternative approach is therefore to use the samples obtained from a Markov chain to deﬁne the importance-sampling distribution. If the transition probability for the Markov chain is given by T(z,z ), and the sample set is given by z(1),...,z(L), then the sampling distribution can be written as

1 ZG

exp(−G(z)) =

L

T(z(l),z) (11.73)

l=1

which can be used directly in (11.72).

Methods for estimating the ratio of two partition functions require for their success that the two corresponding distributions be reasonably closely matched. This is especially problematic if we wish to ﬁnd the absolute value of the partition function for a complex distribution because it is only for relatively simple distributions that the partition function can be evaluated directly, and so attempting to estimate the ratio of partition functions directly is unlikely to be successful. This problem can be tackled using a technique known as chaining (Neal, 1993; Barber and Bishop, 1997), which involves introducing a succession of intermediate distributions p2,...,pM−1 that interpolate between a simple distribution p1(z) for which we can evaluate the normalization coefﬁcient Z1 and the desired complex distribution pM(z). We then have

Z2 Z1

ZM ZM−1

Z3 Z2 ···

ZM Z1

=

(11.74)

in which the intermediate ratios can be determined using Monte Carlo methods as discussed above. One way to construct such a sequence of intermediate systems is to use an energy function containing a continuous parameter 0 α 1 that interpolates between the two distributions

Eα(z) = (1 − α)E1(z) + αEM(z). (11.75)

If the intermediate ratios in (11.74) are to be found using Monte Carlo, it may be more efﬁcient to use a single Markov chain run than to restart the Markov chain for each ratio. In this case, the Markov chain is run initially for the system p1 and then after some suitable number of steps moves on to the next distribution in the sequence. Note, however, that the system must remain close to the equilibrium distribution at each stage.
