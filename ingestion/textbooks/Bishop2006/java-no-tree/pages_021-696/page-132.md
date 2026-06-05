[Page 132]

|0.5 0.3<br><br>0.2<br><br>(a)<br><br>|
|---|


|(b)<br><br>|
|---|


1

- 0.5
- 1


0.5

0

0

0 0.5 1

0 0.5 1

![image 51](../../../../../images/imageFile51.png)

![image 52](../../../../../images/imageFile52.png)

Figure 2.23 Illustration of a mixture of 3 Gaussians in a two-dimensional space. (a) Contours of constant density for each of the mixture components, in which the 3 components are denoted red, blue and green, and the values of the mixing coefﬁcients are shown below each component. (b) Contours of the marginal probability density p(x) of the mixture distribution. (c) A surface plot of the distribution p(x).

We therefore see that the mixing coefﬁcients satisfy the requirements to be probabilities.

From the sum and product rules, the marginal density is given by

p(x) =

K

p(k)p(x|k) (2.191)

k=1

which is equivalent to (2.188) in which we can view πk = p(k) as the prior probability of picking the kth component, and the density N(x|µk,Σk) = p(x|k) as the probability of x conditioned on k. As we shall see in later chapters, an important role is played by the posterior probabilities p(k|x), which are also known as responsibilities. From Bayes’ theorem these are given by

γk(x) ≡ p(k|x) =

p(k)p(x|k) l p(l)p(x|l)

πkN(x|µk,Σk) l πlN(x|µl,Σl)

=

. (2.192)

We shall discuss the probabilistic interpretation of the mixture distribution in greater detail in Chapter 9.

The form of the Gaussian mixture distribution is governed by the parameters π,

µ and Σ, where we have used the notation π ≡ {π1,...,πK}, µ ≡ {µ1,...,µK} and Σ ≡ {Σ1,...ΣK}. One way to set the values of these parameters is to use maximum likelihood. From (2.188) the log of the likelihood function is given by

N

lnp(X|π,µ,Σ) =

ln

n=1

K

πkN(xn|µk,Σk) (2.193)
