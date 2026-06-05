[Page 464]

by all of the components, and I is the identity matrix, so that

1 (2π )1/2

1 2

p(x|µk,Σk) =

exp −

x − µk 2 . (9.41)

We now consider the EM algorithm for a mixture of K Gaussians of this form in which we treat as a ﬁxed constant, instead of a parameter to be re-estimated. From (9.13) the posterior probabilities, or responsibilities, for a particular data point xn, are given by

πk exp{− xn − µk 2/2 } j πj exp − xn − µj 2/2

γ(znk) =

. (9.42) If we consider the limit → 0, we see that in the denominator the term for which

xn − µj 2 is smallest will go to zero most slowly, and hence the responsibilities γ(znk) for the data point xn all go to zero except for term j, for which the responsibility γ(znj) will go to unity. Note that this holds independently of the values of the πk so long as none of the πk is zero. Thus, in this limit, we obtain a hard assignment of data points to clusters, just as in the K-means algorithm, so that γ(znk) → rnk where rnk is deﬁned by (9.2). Each data point is thereby assigned to the cluster having the closest mean.

The EM re-estimation equation for the µk, given by (9.17), then reduces to the K-means result (9.4). Note that the re-estimation formula for the mixing coefﬁcients (9.22) simply re-sets the value of πk to be equal to the fraction of data points assigned to cluster k, although these parameters no longer play an active role in the algorithm.

Finally, in the limit → 0 the expected complete-data log likelihood, given by

- Exercise 9.11 (9.40), becomes


N

###### K

1 2

EZ[lnp(X,Z|µ,Σ,π)] → −

rnk xn − µk 2 + const. (9.43)

n=1

k=1

Thus we see that in this limit, maximizing the expected complete-data log likelihood is equivalent to minimizing the distortion measure J for the K-means algorithm given by (9.1).

Note that the K-means algorithm does not estimate the covariances of the clusters but only the cluster means. A hard-assignment version of the Gaussian mixture model with general covariance matrices, known as the elliptical K-means algorithm, has been considered by Sung and Poggio (1994).

###### 9.3.3 Mixtures of Bernoulli distributions

So far in this chapter, we have focussed on distributions over continuous variables described by mixtures of Gaussians. As a further example of mixture modelling, and to illustrate the EM algorithm in a different context, we now discuss mixtures of discrete binary variables described by Bernoulli distributions. This model is also known as latent class analysis (Lazarsfeld and Henry, 1968; McLachlan and Peel, 2000). As well as being of practical importance in its own right, our discussion of Bernoulli mixtures will also lay the foundation for a consideration of hidden

Section 13.2 Markov models over discrete variables.
