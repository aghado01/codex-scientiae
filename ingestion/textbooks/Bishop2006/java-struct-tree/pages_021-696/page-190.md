[Page 190]

Figure 3.15 Contours of the likelihood function (red) and the prior (green) in which the axes in parameter space have been rotated to align with the eigenvectors ui of the Hessian. For α = 0, the mode of the posterior is given by the maximum likelihood solution wML, whereas for nonzero α the mode is at wMAP = mN. In the direction w1 the eigenvalue λ1, deﬁned by (3.87), is small compared with α and so the quantity λ1/(λ1 + α) is close to zero, and the corresponding MAP value of w1 is also close to zero. By contrast, in the direction w2 the eigenvalue λ2 is large compared with α and so the quantity λ2/(λ2+α) is close to unity, and the MAP value of w2 is close to its maximum likelihood value.

w2

wMAP

u2

wML

u1

w1

3.5.3 Effective number of parameters

The result (3.92) has an elegant interpretation (MacKay, 1992a), which provides insight into the Bayesian solution for α. To see this, consider the contours of the likelihood function and the prior as illustrated in Figure 3.15. Here we have implicitly transformed to a rotated set of axes in parameter space aligned with the eigenvectors ui deﬁned in (3.87). Contours of the likelihood function are then axis-aligned ellipses. The eigenvalues λi measure the curvature of the likelihood function, and so in Figure 3.15 the eigenvalue λ1 is small compared with λ2 (because a smaller curvature corresponds to a greater elongation of the contours of the likelihood function). Because βΦTΦ is a positive deﬁnite matrix, it will have positive eigenvalues, and so the ratio λi/(λi + α) will lie between 0 and 1. Consequently, the quantity γ deﬁned by (3.91) will lie in the range 0 � γ � M. For directions in which λi � α, the corresponding parameter wi will be close to its maximum likelihood value, and the ratio λi/(λi + α) will be close to 1. Such parameters are called well determined because their values are tightly constrained by the data. Conversely, for directions in which λi � α, the corresponding parameters wi will be close to zero, as will the ratios λi/(λi+α). These are directions in which the likelihood function is relatively insensitive to the parameter value and so the parameter has been set to a small value by the prior. The quantity γ deﬁned by (3.91) therefore measures the effective total number of well determined parameters.

We can obtain some insight into the result (3.95) for re-estimating β by comparing it with the corresponding maximum likelihood result given by (3.21). Both of these formulae express the variance (the inverse precision) as an average of the squared differences between the targets and the model predictions. However, they differ in that the number of data points N in the denominator of the maximum likelihood result is replaced by N − γ in the Bayesian result. We recall from (1.56) that the maximum likelihood estimate of the variance for a Gaussian distribution over a
