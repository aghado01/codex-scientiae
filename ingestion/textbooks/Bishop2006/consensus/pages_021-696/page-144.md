[Page 144]

Figure 2.25 Illustration of the kernel density model (2.250) applied to the same data set used to demonstrate the histogram approach in Figure 2.24. We see that h acts as a smoothing parameter and that if it is set too small (top panel), the result is a very noisy density model, whereas if it is set too large (bottom panel), then the bimodal nature of the underlying distribution from which the data is generated (shown by the green curve) is washed out. The best density model is obtained for some intermediate value of h (middle panel).

5

|h = 0.005<br><br>|
|---|


0

0 0.5 1

5

|h = 0.07<br><br>|
|---|


0

0 0.5 1

5

|h = 0.2<br><br>|
|---|


0

0 0.5 1

set used earlier to demonstrate the histogram technique. We see that, as expected, the parameter h plays the role of a smoothing parameter, and there is a trade-off between sensitivity to noise at small h and over-smoothing at large h. Again, the optimization of h is a problem in model complexity, analogous to the choice of bin width in histogram density estimation, or the degree of the polynomial used in curve ﬁtting.

We can choose any other kernel function k(u) in (2.249) subject to the conditions

k(u) 0, (2.251) k(u)du = 1 (2.252)

which ensure that the resulting probability distribution is nonnegative everywhere and integrates to one. The class of density model given by (2.249) is called a kernel density estimator, or Parzen estimator. It has a great merit that there is no computation involved in the ‘training’ phase because this simply requires storage of the training set. However, this is also one of its great weaknesses because the computational cost of evaluating the density grows linearly with the size of the data set.

###### 2.5.2 Nearest-neighbour methods

One of the difﬁculties with the kernel approach to density estimation is that the parameter h governing the kernel width is ﬁxed for all kernels. In regions of high data density, a large value of h may lead to over-smoothing and a washing out of structure that might otherwise be extracted from the data. However, reducing h may lead to noisy estimates elsewhere in data space where the density is smaller. Thus the optimal choice for h may be dependent on location within the data space. This issue is addressed by nearest-neighbour methods for density estimation.

We therefore return to our general result (2.246) for local density estimation, and instead of ﬁxing V and determining the value of K from the data, we consider a ﬁxed value of K and use the data to ﬁnd an appropriate value for V . To do this, we consider a small sphere centred on the point x at which we wish to estimate the
