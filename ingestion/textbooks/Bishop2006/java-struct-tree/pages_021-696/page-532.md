[Page 532]

The factor approximations will therefore take the form of exponential-quadratic functions of the form

f�n(θ) = snN(θ|mn,vnI) (10.213)

where n = 1,...,N, and we set f�0(θ) equal to the prior p(θ). Note that the use of N(θ|·,·) does not imply that the right-hand side is a well-deﬁned Gaussian density

(in fact, as we shall see, the variance parameter vn can be negative) but is simply a convenient shorthand notation. The approximations f�n(θ), for n = 1,...,N, can be initialized to unity, corresponding to sn = (2πvn)D/2, vn → ∞ and mn = 0, where D is the dimensionality of x and hence of θ. The initial q(θ), deﬁned by (10.191), is therefore equal to the prior.

We then iteratively reﬁne the factors by taking one factor fn(θ) at a time and applying (10.205), (10.206), and (10.207). Note that we do not need to revise the

Exercise 10.37 term f0(θ) because an EP update will leave this term unchanged. Here we state the

results and leave the reader to ﬁll in the details.

First we remove the current estimate f�n(θ) from q(θ) by division using (10.205) Exercise 10.38 to give q\n(θ), which has mean and inverse variance given by

m\n = m + v\nvn−1(m − mn) (10.214)

(v\n)−1 = v−1 − vn−1. (10.215) Next we evaluate the normalization constant Zn using (10.206) to give

Zn = (1 − w)N(xn|m\n,(v\n + 1)I) + wN(xn|0,aI). (10.216)

Similarly, we compute the mean and variance of qnew(θ) by ﬁnding the mean and Exercise 10.39 variance of q\n(θ)fn(θ) to give

v\n v\n + 1

(xn − m\n) (10.217)

m = m\n + ρn

(v\n)2 v\n + 1

(v\n)2�xn − m\n�2 D(v\n + 1)2

+ ρn(1 − ρn)

v = v\n − ρn

(10.218)

where the quantity

w

ZnN(xn|0,aI) (10.219) has a simple interpretation as the probability of the point xn not being clutter. Then we use (10.207) to compute the reﬁned factor f�n(θ) whose parameters are given by

ρn = 1 −

vn−1 = (vnew)−1 − (v\n)−1 (10.220) mn = m\n + (vn + v\n)(v\n)−1(mnew − m\n) (10.221)

Zn (2πvn)D/2N(mn|m\n,(vn + v\n)I)

sn =

. (10.222)

This reﬁnement process is repeated until a suitable termination criterion is satisﬁed, for instance that the maximum change in parameter values resulting from a complete
