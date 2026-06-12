[Page 329]

Figure 6.6 Illustration of the sampling of data points {tn} from a Gaussian process. The blue curve shows a sample function from the Gaussian process prior over functions, and the red points show the values of yn obtained by evaluating the function at a set of input values {xn}. The corresponding values of {tn}, shown in green, are obtained by adding independent Gaussian noise to each of the {yn}.

3

t

0

−3

−1 0 1

x

suitable kernels.

Note that the mean (6.66) of the predictive distribution can be written, as a function of xN+1, in the form

�N

m(xN+1) =

ank(xn,xN+1) (6.68)

n=1

where an is the nth component of C−1

N t. Thus, if the kernel function k(xn,xm) depends only on the distance �xn − xm�, then we obtain an expansion in radial basis functions.

The results (6.66) and (6.67) deﬁne the predictive distribution for Gaussian process regression with an arbitrary kernel function k(xn,xm). In the particular case in which the kernel function k(x,x�) is deﬁned in terms of a ﬁnite set of basis functions, we can derive the results obtained previously in Section 3.3.2 for linear regression

Exercise 6.21 starting from the Gaussian process viewpoint.

For such models, we can therefore obtain the predictive distribution either by taking a parameter space viewpoint and using the linear regression result or by taking a function space viewpoint and using the Gaussian process result.

The central computational operation in using Gaussian processes will involve the inversion of a matrix of size N × N, for which standard methods require O(N3) computations. By contrast, in the basis function model we have to invert a matrix SN of size M × M, which has O(M3) computational complexity. Note that for both viewpoints, the matrix inversion must be performed once for the given training set. For each new test point, both methods require a vector-matrix multiply, which has cost O(N2) in the Gaussian process case and O(M2) for the linear basis function model. If the number M of basis functions is smaller than the number N of data points, it will be computationally more efﬁcient to work in the basis function
