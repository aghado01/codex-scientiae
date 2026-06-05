[Page 575]

where { z ( l ) } are samples drawn from the distribution deﬁned by p G ( z ) . If the distribution p G is one for which the partition function can be evaluated analytically, for example a Gaussian, then the absolute value of Z E can be obtained.

This approach will only yield accurate results if the importance sampling distribution p G is closely matched to the distribution p E , so that the ratio p E /p G does not have wide variations. In practice, suitable analytically speciﬁed importance sampling distributions cannot readily be found for the kinds of complex models considered in this book.

An alternative approach is therefore to use the samples obtained from a Markov chain to deﬁne the importance-sampling distribution. If the transition probability for the Markov chain is given by T ( z , z ) , and the sample set is given by z (1) ,..., z ( L ) , then the sampling distribution can be written as

$$
\frac { 1 } { Z _ { G } } \exp \left ( - G ( z ) \right ) = \sum _ { l = 1 } ^ { L } T ( z ^ { ( l ) } , z ) \\ \intertext { s u d e r t i v y i n } \left ( 1 1 7 2 \right )
$$

which can be used directly in (11.72).

Methods for estimating the ratio of two partition functions require for their success that the two corresponding distributions be reasonably closely matched. This is especially problematic if we wish to ﬁnd the absolute value of the partition function for a complex distribution because it is only for relatively simple distributions that the partition function can be evaluated directly, and so attempting to estimate the ratio of partition functions directly is unlikely to be successful. This problem can be tackled using a technique known as chaining (Neal, 1993; Barber and Bishop, 1997), which involves introducing a succession of intermediate distributions p 2 ,...,p M − 1 that interpolate between a simple distribution p 1 ( z ) for which we can evaluate the normalization coefﬁcient Z 1 and the desired complex distribution p M ( z ) . We then have Z Z Z Z

$$
\frac { Z _ { M } } { Z _ { 1 } } = \frac { Z _ { 2 } } { Z _ { 1 } } \frac { Z _ { 3 } } { Z _ { 2 } } \cdots \frac { Z _ { M } } { Z _ { M - 1 } } & & ( 1 1 . 7 4 ) \\ \ e d i t e \ r a t i o s \ c a n b e d e r m e n d \ u s i n g \ M o n t e \ C a r l o \ m e t h o d s \ a s
$$

in which the intermediate ratios can be determined using Monte Carlo methods as discussed above. One way to construct such a sequence of intermediate systems is to use an energy function containing a continuous parameter 0 α 1 that interpolates between the two distributions

$$
E _ { \alpha } ( z ) = ( 1 - \alpha ) E _ { 1 } ( z ) + \alpha E _ { M } ( z ) .
$$

If the intermediate ratios in (11.74) are to be found using Monte Carlo, it may be more efﬁcient to use a single Markov chain run than to restart the Markov chain for each ratio. In this case, the Markov chain is run initially for the system p 1 and then after some suitable number of steps moves on to the next distribution in the sequence. Note, however, that the system must remain close to the equilibrium distribution at each stage.
