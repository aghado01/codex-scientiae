[Page 399]

- Figure 8.22 Illustration of the concept of d-separation. See the text for details.


f

a

e b

c

(a)

f

a

e b

c

(b)

be satisﬁed by any distribution that factorizes according to this graph. Note that this path is also blocked by node e because e is a head-to-head node and neither it nor its descendant are in the conditioning set.

For the purposes of d-separation, parameters such as α and σ2 in Figure 8.5, indicated by small ﬁlled circles, behave in the same was as observed nodes. However, there are no marginal distributions associated with such nodes. Consequently parameter nodes never themselves have parents and so all paths through these nodes will always be tail-to-tail and hence blocked. Consequently they play no role in d-separation.

Another example of conditional independence and d-separation is provided by the concept of i.i.d. (independent identically distributed) data introduced in Section 1.2.4. Consider the problem of ﬁnding the posterior distribution for the mean

- Section 2.3 of a univariate Gaussian distribution. This can be represented by the directed graph shown in Figure 8.23 in which the joint distribution is deﬁned by a prior p(µ) together with a set of conditional distributions p(xn|µ) for n = 1,...,N. In practice, we observe D = {x1,...,xN} and our goal is to infer µ. Suppose, for a moment, that we condition on µ and consider the joint distribution of the observations. Using


d-separation, we note that there is a unique path from any xi to any other xj =i and that this path is tail-to-tail with respect to the observed node µ. Every such path is

blocked and so the observations D = {x1,...,xN} are independent given µ, so that

N

p(xn|µ). (8.34)

p(D|µ) =

n=1

- Figure 8.23 (a) Directed graph corresponding to the problem of inferring the mean µ of a univariate Gaussian distribution from observations


x1, . . . , xN. (b) The same graph drawn using the plate notation.

µ

x1 xN

(a)

µ

N

xn

N

(b)
