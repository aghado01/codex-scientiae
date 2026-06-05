[Page 547]

Figure 11.2 Geometrical interpretation of the transformation method for generating nonuniformly distributed random numbers. h(y) is the indeﬁnite integral of the desired distribution p(y). If a uniformly distributed random variable z is transformed using y = h−1(z), then y will be distributed according to p(y). p(y)

- 0 y

- 1


h(y)

Another example of a distribution to which the transformation method can be applied is given by the Cauchy distribution

p(y) =

1 1 + y2

1 π

. (11.8)

In this case, the inverse of the indeﬁnite integral can be expressed in terms of the

- Exercise 11.3 ‘tan’ function. The generalization to multiple variables is straightforward and involves the Ja-


cobian of the change of variables, so that

p(y1,...,yM) = p(z1,...,zM)

∂(z1,...,zM) ∂(y1,...,yM)

. (11.9)

As a ﬁnal example of the transformation method we consider the Box-Muller method for generating samples from a Gaussian distribution. First, suppose we generate pairs of uniformly distributed random numbers z1,z2 ∈ (−1,1), which we can do by transforming a variable distributed uniformly over (0,1) using z → 2z − 1. Next we discard each pair unless it satisﬁes z12 + z22 1. This leads to a uniform distribution of points inside the unit circle with p(z1,z2) = 1/π, as illustrated in Figure 11.3. Then, for each pair z1,z2 we evaluate the quantities

Figure 11.3 The Box-Muller method for generating Gaussian distributed random numbers starts by generating samples from a uniform distribution inside the unit circle.

1

| |
|---|


z2

−1−1

z1 1
