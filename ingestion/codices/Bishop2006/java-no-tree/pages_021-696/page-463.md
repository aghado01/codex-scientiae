[Page 463]

Using (9.10) and (9.11) together with Bayes’ theorem, we see that this posterior distribution takes the form

N

p(Z|X,µ,Σ,π) ∝

n=1

###### K

[πkN(xn|µk,Σk)]z

nk

k=1

. (9.38)

and hence factorizes over n so that under the posterior distribution the {zn} are

- Exercise 9.5 independent. This is easily veriﬁed by inspection of the directed graph in Figure 9.6


- Section 8.2 and making use of the d-separation criterion. The expected value of the indicator variable znk under this posterior distribution is then given by


znk [πkN(xn|µk,Σk)]z

nk

E[znk] = znk

πjN(xn|µj,Σj) znj

znj

πkN(xn|µk,Σk) K

= γ(znk) (9.39)

=

πjN(xn|µj,Σj)

j=1

which is just the responsibility of component k for data point xn. The expected value of the complete-data log likelihood function is therefore given by

N

EZ[lnp(X,Z|µ,Σ,π)] =

n=1

###### K

γ(znk){lnπk + lnN(xn|µk,Σk)}. (9.40)

k=1

We can now proceed as follows. First we choose some initial values for the parameters µold, Σold and πold, and use these to evaluate the responsibilities (the E step). We then keep the responsibilities ﬁxed and maximize (9.40) with respect to µk, Σk and πk (the M step). This leads to closed form solutions for µnew, Σnew and πnew

Exercise 9.8 given by (9.17), (9.19), and (9.22) as before. This is precisely the EM algorithm for Gaussian mixtures as derived earlier. We shall gain more insight into the role of the expected complete-data log likelihood function when we give a proof of convergence of the EM algorithm in Section 9.4.

###### 9.3.2 Relation to K-means

Comparison of the K-means algorithm with the EM algorithm for Gaussian mixtures shows that there is a close similarity. Whereas the K-means algorithm performs a hard assignment of data points to clusters, in which each data point is associated uniquely with one cluster, the EM algorithm makes a soft assignment based on the posterior probabilities. In fact, we can derive the K-means algorithm as a particular limit of EM for Gaussian mixtures as follows.

Consider a Gaussian mixture model in which the covariance matrices of the mixture components are given by I, where is a variance parameter that is shared
