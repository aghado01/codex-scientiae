[Page 235]

0.8

0.6

0.4

40

30

20

0.2

10

0

−2 −1 0 1 2 3 4

0

−2 −1 0 1 2 3 4

Figure 4.14 Illustration of the Laplace approximation applied to the distribution p(z) ∝ exp(−z2/2)σ(20z + 4) where σ(z) is the logistic sigmoid function deﬁned by σ(z) = (1 + e−z)−1. The left plot shows the normalized distribution p(z) in yellow, together with the Laplace approximation centred on the mode z0 of p(z) in red. The right plot shows the negative logarithms of the corresponding curves.

We can extend the Laplace method to approximate a distribution p(z) = f(z)/Z

deﬁned over an M-dimensional space z. At a stationary point z0 the gradient ∇f(z) will vanish. Expanding around this stationary point we have

1 2

(z − z0)TA(z − z0) (4.131) where the M × M Hessian matrix A is deﬁned by

lnf(z) � lnf(z0) −

A = − ∇∇lnf(z)|z=z0 (4.132) and ∇ is the gradient operator. Taking the exponential of both sides we obtain

f(z) � f(z0)exp�−

(z − z0)TA(z − z0)�. (4.133)

1 2

The distribution q(z) is proportional to f(z) and the appropriate normalization coefﬁcient can be found by inspection, using the standard result (2.43) for a normalized multivariate Gaussian, giving

exp�−

(z − z0)TA(z − z0)� = N(z|z0,A−1) (4.134)

1 2

q(z) = |A|1/2 (2π)M/2

where |A| denotes the determinant of A. This Gaussian distribution will be well deﬁned provided its precision matrix, given by A, is positive deﬁnite, which implies that the stationary point z0 must be a local maximum, not a minimum or a saddle point.

In order to apply the Laplace approximation we ﬁrst need to ﬁnd the mode z0, and then evaluate the Hessian matrix at that mode. In practice a mode will typically be found by running some form of numerical optimization algorithm (Bishop
