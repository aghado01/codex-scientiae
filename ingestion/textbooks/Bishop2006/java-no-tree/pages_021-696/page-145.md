[Page 145]

Figure 2.26 Illustration of K-nearest-neighbour density estimation using the same data set as in Figures 2.25 and 2.24. We see that the parameter K governs the degree of smoothing, so that a small value of K leads to a very noisy density model (top panel), whereas a large value (bottom panel) smoothes out the bimodal nature of the true distribution (shown by the green curve) from which the data set was generated.

5

|K = 1<br><br>|
|---|


0

0 0.5 1

5

|K = 5<br><br>|
|---|


0

0 0.5 1

5

###### K = 30

0

0 0.5 1

density p(x), and we allow the radius of the sphere to grow until it contains precisely K data points. The estimate of the density p(x) is then given by (2.246) with V set to the volume of the resulting sphere. This technique is known as K nearest neighbours and is illustrated in Figure 2.26, for various choices of the parameter K, using the same data set as used in Figure 2.24 and Figure 2.25. We see that the value of K now governs the degree of smoothing and that again there is an optimum choice for K that is neither too large nor too small. Note that the model produced by K nearest

Exercise 2.61 neighbours is not a true density model because the integral over all space diverges.

We close this chapter by showing how the K-nearest-neighbour technique for density estimation can be extended to the problem of classiﬁcation. To do this, we apply the K-nearest-neighbour density estimation technique to each class separately and then make use of Bayes’ theorem. Let us suppose that we have a data set comprising Nk points in class Ck with N points in total, so that k Nk = N. If we wish to classify a new point x, we draw a sphere centred on x containing precisely K points irrespective of their class. Suppose this sphere has volume V and contains Kk points from class Ck. Then (2.246) provides an estimate of the density associated with each class

Kk NkV

p(x|Ck) =

. (2.253) Similarly, the unconditional density is given by

K NV

p(x) =

(2.254) while the class priors are given by

Nk N

p(Ck) =

. (2.255)

We can now combine (2.253), (2.254), and (2.255) using Bayes’ theorem to obtain the posterior probability of class membership

p(x|Ck)p(Ck) p(x)

=

p(Ck|x) =

Kk K

. (2.256)
