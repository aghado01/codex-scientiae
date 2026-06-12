[Page 650]

![In this image, we can see a diagram with some numbers and arrows.](../images/imageFile316.png)

Figure 13.16 A fragment of the HMM lattice showing two possible paths. The Viterbi algorithm efﬁciently determines the most probable path from amongst the exponentially many possibilities. For any given path, the corresponding probability is given by the product of the elements of the transition matrix A jk , corresponding to the probabilities p ( z n +1 | z n ) for each segment of the path, along with the emission densities p ( x n | k ) associated with each node on the path.

k

= 1

k

= 2

k

= 3

-

-

n

2

n

1

n

n

- 1

Exercise 13.16

If we eliminate µ z n → f n +1 ( z n ) between these two equations, and make use of (13.46), we obtain a recursion for the f → z messages of the form

$$
\omega ( z _ { n + 1 } ) = \ln p ( x _ { n + 1 } | z _ { n + 1 } ) + \max _ { z _ { n } } \{ \ln p ( x _ { + 1 } | z _ { n } ) + \omega ( z _ { n } ) \}
$$

where we have introduced the notation ω ( z n ) ≡ µ f n → z n ( z n ) . From (8.95) and (8.96), these messages are initialized using

$$
\omega ( z _ { 1 } ) = \ln p ( z _ { 1 } ) + \ln p ( x _ { 1 } | z _ { 1 } ) .
$$

where we have used (13.45). Note that to keep the notation uncluttered, we omit the dependence on the model parameters θ that are held ﬁxed when ﬁnding the most probable sequence.

The Viterbi algorithm can also be derived directly from the deﬁnition (13.6) of the joint distribution by taking the logarithm and then exchanging maximizations and summations. It is easily seen that the quantities ω ( z n ) have the probabilistic interpretation

$$
\omega ( z _ { n } ) = \max _ { z _ { 1 } , \dots , z _ { n - 1 } } p ( x _ { 1 } , \dots , x _ { n } , z _ { 1 } , \dots , z _ { n } ) .
$$

Once we have completed the ﬁnal maximization over z N , we will obtain the value of the joint distribution p ( X , Z ) corresponding to the most probable path. We also wish to ﬁnd the sequence of latent variable values that corresponds to this path. To do this, we simply make use of the back-tracking procedure discussed in Section 8.4.5. Speciﬁcally, we note that the maximization over z n must be performed for each of the K possible values of z n +1 . Suppose we keep a record of the values of z n that correspond to the maxima for each value of the K values of z n +1 . Let us denote this function by ψ ( k n ) where k ∈ { 1 ,...,K } . Once we have passed messages to the end of the chain and found the most probable state of z N , we can then use this function to backtrack along the chain by applying it recursively

$$
k _ { n } ^ { \max } = \psi ( k _ { n + 1 } ^ { \max } ) .
$$
