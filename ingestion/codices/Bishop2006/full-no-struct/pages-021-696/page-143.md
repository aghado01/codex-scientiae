[Page 143]

We can exploit the result (2.246) in two different ways. Either we can ﬁx K and determine the value of V from the data, which gives rise to the K -nearest-neighbour technique discussed shortly, or we can ﬁx V and determine K from the data, giving rise to the kernel approach. It can be shown that both the K -nearest-neighbour density estimator and the kernel density estimator converge to the true probability density in the limit N → ∞ provided V shrinks suitably with N , and K grows with N (Duda and Hart, 1973).

We begin by discussing the kernel method in detail, and to start with we take the region R to be a small hypercube centred on the point x at which we wish to determine the probability density. In order to count the number K of points falling within this region, it is convenient to deﬁne the following function

$$
k ( u ) & = \left \{ \begin{array} { l l } { 1 , } & { | u _ { i } | \leqslant 1 / 2 , } & { i = 1 , \dots , D , } \\ { 0 , } & { o t h e r w i s e } & \\ \end{array} \quad ( 2 . 2 4 7 ) \\
$$

which represents a unit cube centred on the origin. The function k ( u ) is an example of a kernel function , and in this context is also called a Parzen window . From (2.247), the quantity k (( x − x n ) /h ) will be one if the data point x n lies inside a cube of side h centred on x , and zero otherwise. The total number of data points lying inside this cube will therefore be N

$$
K = \sum _ { n = 1 } ^ { N } k \left ( \frac { x - x _ { n } } { h } \right ) . \\ \text {expression into } ( 2 . 2 4 6 ) \text { then gives the following result for the esti-}
$$

Substituting this expression into (2.246) then gives the following result for the estimated density at x

$$
p ( x ) & = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \frac { 1 } { h ^ { D } } k \left ( \frac { x - x _ { n } } { h } \right ) \\ \text {used } V \, = \, h ^ { D } \text { for the volume of a hypercube of side } h \text { in } D \text { di-}
$$

where we have used V = h D for the volume of a hypercube of side h in D dimensions. Using the symmetry of the function k ( u ) , we can now re-interpret this equation, not as a single cube centred on x but as the sum over N cubes centred on the N data points x n .

As it stands, the kernel density estimator (2.249) will suffer from one of the same problems that the histogram method suffered from, namely the presence of artiﬁcial discontinuities, in this case at the boundaries of the cubes. We can obtain a smoother density model if we choose a smoother kernel function, and a common choice is the Gaussian, which gives rise to the following kernel density model

$$
p ( x ) = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \frac { 1 } { ( 2 \pi h ^ { 2 } ) ^ { 1 / 2 } } \exp \left \{ - \frac { \| x - x _ { n } \| ^ { 2 } } { 2 h ^ { 2 } } \right \} \quad ( 2 . 2 5 ) \\ h \, \text {represents the standard deviation of the Gaussian components.} \, \text {This uses}
$$

where h represents the standard deviation of the Gaussian components. Thus our density model is obtained by placing a Gaussian over each data point and then adding up the contributions over the whole data set, and then dividing by N so that the density is correctly normalized. In Figure 2.25, we apply the model (2.250) to the data Illustration of the kernel density model (2.250) applied to the same data set used to demonstrate the histogram approach in Figure 2.24. We see that h acts as a smoothing parameter and that if it is set too small (top panel), the result is a very noisy density model, whereas if it is set too large (bottom panel), then the bimodal nature of the underlying distribution from which the data is generated (shown by the green curve) is washed out. The best density model is obtained for some intermediate value of h (middle panel).
