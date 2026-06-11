[Page 464]

by all of the components, and I is the identity matrix, so that

$$
\text {all of the components, and 1 is the identity matrix, so that} \\ p ( x | \mu _ { k } , \Sigma _ { k } ) = \frac { 1 } { ( 2 \pi \epsilon ) ^ { 1 / 2 } } \exp \left \{ - \frac { 1 } { 2 \epsilon } \| x - \mu _ { k } \| ^ { 2 } \right \} . \\ \text {now consider the EM algorithm for a mixture of K Gaussians of this form in}
$$

We now consider the EM algorithm for a mixture of K Gaussians of this form in which we treat as a ﬁxed constant, instead of a parameter to be re-estimated. From (9.13) the posterior probabilities, or responsibilities, for a particular data point x n , are given by 2

$$
\text {by} & & \gamma ( z _ { n k } ) = \frac { \pi _ { k } \exp \{ - \| x _ { n } - \mu _ { k } \| ^ { 2 } / 2 \epsilon \} } { \sum _ { j } \pi _ { j } \exp \{ - \| x _ { n } - \mu _ { j } \| ^ { 2 } / 2 \epsilon \} } . \\ \text {consider the limit } \epsilon \to 0 , \text { we see that in the denominator the term for which } & & \| x _ { j } \| ^ { 2 } \leqslant 0
$$

If we consider the limit → 0 , we see that in the denominator the term for which x n − µ j 2 is smallest will go to zero most slowly, and hence the responsibilities γ ( z nk ) for the data point x n all go to zero except for term j , for which the responsibility γ ( z nj ) will go to unity. Note that this holds independently of the values of the π k so long as none of the π k is zero. Thus, in this limit, we obtain a hard assignment of data points to clusters, just as in the K -means algorithm, so that γ ( z nk ) → r nk where r nk is deﬁned by (9.2). Each data point is thereby assigned to the cluster having the closest mean.

The EM re-estimation equation for the µ k , given by (9.17), then reduces to the K -means result (9.4). Note that the re-estimation formula for the mixing coefﬁcients (9.22) simply re-sets the value of π k to be equal to the fraction of data points assigned to cluster k , although these parameters no longer play an active role in the algorithm.

Finally, in the limit → 0 the expected complete-data log likelihood, given by (9.40), becomes

$$
\mathbb { E } _ { Z } [ \ln p ( X , Z | \mu , \Sigma , \pi ) ] & \to - \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } r _ { n k } \| x _ { n } - \mu _ { k } \| ^ { 2 } + \text {const} . \\ \intertext { Thus we see that in this limit, maximizing the expected complete-data log likelihood }
$$

Thus we see that in this limit, maximizing the expected complete-data log likelihood is equivalent to minimizing the distortion measure J for the K -means algorithm given by (9.1).

Note that the K -means algorithm does not estimate the covariances of the clusters but only the cluster means. A hard-assignment version of the Gaussian mixture model with general covariance matrices, known as the elliptical K -means algorithm, has been considered by Sung and Poggio (1994).

# 9.3.3 Mixtures of Bernoulli distributions

So far in this chapter, we have focussed on distributions over continuous variables described by mixtures of Gaussians. As a further example of mixture modelling, and to illustrate the EM algorithm in a different context, we now discuss mixtures of discrete binary variables described by Bernoulli distributions. This model is also known as latent class analysis (Lazarsfeld and Henry, 1968; McLachlan and Peel, 2000). As well as being of practical importance in its own right, our discussion of Bernoulli mixtures will also lay the foundation for a consideration of hidden Markov models over discrete variables.
