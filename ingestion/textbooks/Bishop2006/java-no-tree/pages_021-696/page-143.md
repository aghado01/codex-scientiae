[Page 143]

We can exploit the result (2.246) in two different ways. Either we can ﬁx K and determine the value of V from the data, which gives rise to the K-nearest-neighbour technique discussed shortly, or we can ﬁx V and determine K from the data, giving rise to the kernel approach. It can be shown that both the K-nearest-neighbour density estimator and the kernel density estimator converge to the true probability density in the limit N → ∞ provided V shrinks suitably with N, and K grows with N (Duda and Hart, 1973).

We begin by discussing the kernel method in detail, and to start with we take the region R to be a small hypercube centred on the point x at which we wish to determine the probability density. In order to count the number K of points falling within this region, it is convenient to deﬁne the following function

k(u) =

1, |ui| 1/2, i = 1,...,D, 0, otherwise

(2.247)

which represents a unit cube centred on the origin. The function k(u) is an example of a kernel function, and in this context is also called a Parzen window. From (2.247), the quantity k((x − xn)/h) will be one if the data point xn lies inside a cube of side h centred on x, and zero otherwise. The total number of data points lying inside this cube will therefore be

N

x − xn h

K =

. (2.248)

k

n=1

Substituting this expression into (2.246) then gives the following result for the estimated density at x

N

1 hD

1 N

x − xn h

p(x) =

(2.249)

k

n=1

where we have used V = hD for the volume of a hypercube of side h in D dimensions. Using the symmetry of the function k(u), we can now re-interpret this equation, not as a single cube centred on x but as the sum over N cubes centred on the N data points xn.

As it stands, the kernel density estimator (2.249) will suffer from one of the same problems that the histogram method suffered from, namely the presence of artiﬁcial discontinuities, in this case at the boundaries of the cubes. We can obtain a smoother density model if we choose a smoother kernel function, and a common choice is the Gaussian, which gives rise to the following kernel density model

1 N

p(x) =

N

1 (2πh2)1/2

x − xn 2

exp −

2h2

n=1

(2.250)

where h represents the standard deviation of the Gaussian components. Thus our density model is obtained by placing a Gaussian over each data point and then adding up the contributions over the whole data set, and then dividing by N so that the density is correctly normalized. In Figure 2.25, we apply the model (2.250) to the data
