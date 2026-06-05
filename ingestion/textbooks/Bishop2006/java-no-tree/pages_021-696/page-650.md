[Page 650]

Figure 13.16 A fragment of the HMM lattice showing two possible paths. The Viterbi algorithm efﬁciently determines the most probable path from amongst the exponentially many possibilities. For any given path, the corresponding probability is given by the product of the elements of the transition matrix Ajk, corresponding to the probabilities p(zn+1|zn) for each segment of the path, along with the emission densities p(xn|k) associated with each node on the path.

- k = 1
- k = 2
- k = 3


n − 2 n − 1 n n + 1

n→fn+1(zn) between these two equations, and make use of (13.46), we obtain a recursion for the f → z messages of the form

If we eliminate µz

###### ω(zn+1) = lnp(xn+1|zn+1) + max

###### {lnp(x+1|zn) + ω(zn)} (13.68)

zn

where we have introduced the notation ω(zn) ≡ µf

###### n→zn(zn).

From (8.95) and (8.96), these messages are initialized using

###### ω(z1) = lnp(z1) + lnp(x1|z1). (13.69)

where we have used (13.45). Note that to keep the notation uncluttered, we omit the dependence on the model parameters θ that are held ﬁxed when ﬁnding the most probable sequence.

The Viterbi algorithm can also be derived directly from the deﬁnition (13.6) of the joint distribution by taking the logarithm and then exchanging maximizations

- Exercise 13.16 and summations. It is easily seen that the quantities ω(zn) have the probabilistic interpretation


ω(zn) = max

p(x1,...,xn,z1,...,zn). (13.70)

z1,...,zn−1

Once we have completed the ﬁnal maximization over zN, we will obtain the value of the joint distribution p(X,Z) corresponding to the most probable path. We also wish to ﬁnd the sequence of latent variable values that corresponds to this path. To do this, we simply make use of the back-tracking procedure discussed in Section 8.4.5. Speciﬁcally, we note that the maximization over zn must be performed for each of the K possible values of zn+1. Suppose we keep a record of the values of zn that correspond to the maxima for each value of the K values of zn+1. Let us denote this function by ψ(kn) where k ∈ {1,...,K}. Once we have passed messages to the end of the chain and found the most probable state of zN, we can then use this function to backtrack along the chain by applying it recursively

###### knmax = ψ(knmax+1). (13.71)
