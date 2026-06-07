[Page 143]

We can exploit the result (2.246) in two different ways. Either we can ﬁx $K$ and determine the value of $V$ from the data, which gives rise to the $K$-nearest-neighbour technique discussed shortly, or we can ﬁx $V$ and determine $K$ from the data, giving rise to the kernel approach. It can be shown that both the $K$-nearest-neighbour density estimator and the kernel density estimator converge to the true probability density in the limit $N \to \infty$ provided $V$ shrinks suitably with $N$, and $K$ grows with $N$ (Duda and Hart, 1973).

We begin by discussing the kernel method in detail, and to start with we take the region $\mathcal{R}$ to be a small hypercube centred on the point $\mathbf{x}$ at which we wish to determine the probability density. In order to count the number $K$ of points falling within this region, it is convenient to deﬁne the following function

$$
k(\mathbf{u}) = \begin{cases} 
1, & |u_i| \leqslant 1/2, \quad i = 1, \ldots, D, \\
0, & \text{otherwise}
\end{cases} \tag{2.247}
$$

which represents a unit cube centred on the origin. The function $k(\mathbf{u})$ is an example of a kernel function, and in this context is also called a Parzen window. From (2.247), the quantity $k((\mathbf{x} - \mathbf{x}_n)/h)$ will be one if the data point $\mathbf{x}_n$ lies inside a cube of side $h$ centred on $\mathbf{x}$, and zero otherwise. The total number of data points lying inside this cube will therefore be

$$
K = \sum_{n=1}^{N} k \left( \frac{\mathbf{x} - \mathbf{x}_n}{h} \right) . \tag{2.248}
$$

Substituting this expression into (2.246) then gives the following result for the estimated density at $\mathbf{x}$

$$
p(\mathbf{x}) = \frac{1}{N} \sum_{n=1}^{N} \frac{1}{h^D} k \left( \frac{\mathbf{x} - \mathbf{x}_n}{h} \right) \tag{2.249}
$$

where we have used $V = h^D$ for the volume of a hypercube of side $h$ in $D$ dimensions. Using the symmetry of the function $k(\mathbf{u})$, we can now re-interpret this equation, not as a single cube centred on $\mathbf{x}$ but as the sum over $N$ cubes centred on the $N$ data points $\mathbf{x}_n$.

As it stands, the kernel density estimator (2.249) will suffer from one of the same problems that the histogram method suffered from, namely the presence of artiﬁcial discontinuities, in this case at the boundaries of the cubes. We can obtain a smoother density model if we choose a smoother kernel function, and a common choice is the Gaussian, which gives rise to the following kernel density model

$$
p(\mathbf{x}) = \frac{1}{N} \sum_{n=1}^{N} \frac{1}{(2\pi h^2)^{D/2}} \exp \left\{ - \frac{\|\mathbf{x} - \mathbf{x}_n\|^2}{2h^2} \right\} \tag{2.250}
$$

where $h$ represents the standard deviation of the Gaussian components. Thus our density model is obtained by placing a Gaussian over each data point and then adding up the contributions over the whole data set, and then dividing by $N$ so that the density is correctly normalized. In Figure 2.25, we apply the model (2.250) to the data
