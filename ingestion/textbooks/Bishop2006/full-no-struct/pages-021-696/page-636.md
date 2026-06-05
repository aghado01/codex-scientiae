[Page 636]

# Section 9.2

exponentially with the length of the chain. In fact, the summation in (13.11) corresponds to summing over exponentially many paths through the lattice diagram in Figure 13.7.

We have already encountered a similar difﬁculty when we considered the inference problem for the simple chain of variables in Figure 8.32. There we were able to make use of the conditional independence properties of the graph to re-order the summations in order to obtain an algorithm whose cost scales linearly, instead of exponentially, with the length of the chain. We shall apply a similar technique to the hidden Markov model.

A further difﬁculty with the expression (13.11) for the likelihood function is that, because it corresponds to a generalization of a mixture distribution, it represents a summation over the emission models for different settings of the latent variables. Direct maximization of the likelihood function will therefore lead to complex expressions with no closed-form solutions, as was the case for simple mixture models (recall that a mixture model for i.i.d. data is a special case of the HMM).

We therefore turn to the expectation maximization algorithm to ﬁnd an efﬁcient framework for maximizing the likelihood function in hidden Markov models. The EM algorithm starts with some initial selection for the model parameters, which we denote by θ old . In the E step, we take these parameter values and ﬁnd the posterior distribution of the latent variables p ( Z | X , θ old ) . We then use this posterior distribution to evaluate the expectation of the logarithm of the complete-data likelihood function, as a function of the parameters θ , to give the function Q ( θ , θ old ) deﬁned by

$$
Q ( \theta , \theta ^ { \text {old} } ) & = \sum _ { z } p ( Z | X , \theta ^ { \text {old} } ) \ln p ( X , Z | \theta ) . \\ \intertext { p o n t , i t is convenient t o introduce some notation.  We shall use \gamma ( z _ { n } ) to }
$$

At this point, it is convenient to introduce some notation. We shall use γ ( z n ) to denote the marginal posterior distribution of a latent variable z n , and ξ ( z n − 1 , z n ) to denote the joint posterior distribution of two successive latent variables, so that

$$
\gamma ( z _ { n } ) \ = \ p ( z _ { n } | X , \theta ^ { \text {old} } ) & & ( 1 3 . 1 3 ) \\ \xi ( \tau _ { n } , \tau _ { 1 } ) \ = \ p ( \tau _ { n } , \tau _ { 1 } \, | X \, \theta ^ { \text {old} } ) & & ( 1 3 . 1 4 )
$$

$$
\xi ( z _ { n - 1 } , z _ { n } ) \ = \ p ( z _ { n - 1 } , z _ { n } | X , \theta ^ { \text {old} } ) .
$$

For each value of n , we can store γ ( z n ) using a set of K nonnegative numbers that sum to unity, and similarly we can store ξ ( z n − 1 , z n ) using a K × K matrix of nonnegative numbers that again sum to unity. We shall also use γ ( z nk ) to denote the conditional probability of z nk = 1 , with a similar use of notation for ξ ( z n − 1 ,j ,z nk ) and for other probabilistic variables introduced later. Because the expectation of a binary random variable is just the probability that it takes the value 1 , we have

$$
\gamma ( z _ { n k } ) \ & = \ \mathbb { E } [ z _ { n k } ] = \sum _ { z } \gamma ( z ) z _ { n k } \\ \xi ( z _ { n - 1 } i , z _ { n k } ) \ & = \ \mathbb { E } [ z _ { n - 1 } i z _ { n k } ] = \sum _ { z } \gamma ( z ) z _ { n - 1 } i z _ { n k } .
$$

$$
\xi ( z _ { n - 1 , j } , z _ { n k } ) \ = \ \mathbb { E } [ z _ { n - 1 , j } z _ { n k } ] = \sum _ { z } \gamma ( z ) z _ { n - 1 , j } z _ { n k } . \\ \\ \text {If two substituto the joint distribution } n ( X , Z | \theta ) \text { given by } ( 1 3 . 1 0 ) \text { into } ( 1 3 . 1 2 )
$$

If we substitute the joint distribution p ( X , Z | θ ) given by (13.10) into (13.12),
