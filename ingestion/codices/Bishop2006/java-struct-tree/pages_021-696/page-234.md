[Page 234]

over the parameter vector w since the posterior distribution is no longer Gaussian. It is therefore necessary to introduce some form of approximation. Later in the

Chapter 10 book we shall consider a range of techniques based on analytical approximations Chapter 11 and numerical sampling.

Here we introduce a simple, but widely used, framework called the Laplace approximation, that aims to ﬁnd a Gaussian approximation to a probability density deﬁned over a set of continuous variables. Consider ﬁrst the case of a single continuous variable z, and suppose the distribution p(z) is deﬁned by

1 Z

p(z) =

f(z) (4.125)

�

f(z)dz is the normalization coefﬁcient. We shall suppose that the value of Z is unknown. In the Laplace method the goal is to ﬁnd a Gaussian approximation q(z) which is centred on a mode of the distribution p(z). The ﬁrst step is to ﬁnd a mode of p(z), in other words a point z0 such that p�(z0) = 0, or equivalently

where Z =

� � � �

df(z) dz

= 0. (4.126)

z=z0

A Gaussian distribution has the property that its logarithm is a quadratic function of the variables. We therefore consider a Taylor expansion of lnf(z) centred on the mode z0 so that

1 2

lnf(z) � lnf(z0) −

A(z − z0)2 (4.127) where

lnf(z)�

� � �

d2 dz2

A = −

. (4.128)

z=z0

Note that the ﬁrst-order term in the Taylor expansion does not appear since z0 is a local maximum of the distribution. Taking the exponential we obtain

f(z) � f(z0)exp�−

(z − z0)2�. (4.129)

A 2

We can then obtain a normalized distribution q(z) by making use of the standard result for the normalization of a Gaussian, so that

q(z) = �

�1/2 exp�−

(z − z0)2�. (4.130)

A 2

A 2π

The Laplace approximation is illustrated in Figure 4.14. Note that the Gaussian approximation will only be well deﬁned if its precision A > 0, in other words the stationary point z0 must be a local maximum, so that the second derivative of f(z) at the point z0 is negative.
