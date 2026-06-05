[Page 163]

Figure 3.2 Geometrical interpretation of the least-squares solution, in an N-dimensional space whose axes are the values of t1, . . . , tN. The least-squares regression function is obtained by ﬁnding the orthogonal projection of the data vector t onto the subspace spanned by the basis functions φj(x) in which each basis function is viewed as a vector ϕj of length N with elements φj(xn).

S

ϕ1 y

ϕ2

t

and so we see that the inverse of the noise precision is given by the residual variance of the target values around the regression function.

3.1.2 Geometry of least squares

At this point, it is instructive to consider the geometrical interpretation of the least-squares solution. To do this we consider an N-dimensional space whose axes are given by the tn, so that t = (t1,...,tN)T is a vector in this space. Each basis function φj(xn), evaluated at the N data points, can also be represented as a vector in the same space, denoted by ϕj, as illustrated in Figure 3.2. Note that ϕj corresponds to the jth column of Φ, whereas φ(xn) corresponds to the nth row of Φ. If the number M of basis functions is smaller than the number N of data points, then the M vectors φj(xn) will span a linear subspace S of dimensionality M. We deﬁne y to be an N-dimensional vector whose nth element is given by y(xn,w), where n = 1,...,N. Because y is an arbitrary linear combination of the vectors ϕj, it can live anywhere in the M-dimensional subspace. The sum-of-squares error (3.12) is then equal (up to a factor of 1/2) to the squared Euclidean distance between y and t. Thus the least-squares solution for w corresponds to that choice of y that lies in subspace S and that is closest to t. Intuitively, from Figure 3.2, we anticipate that this solution corresponds to the orthogonal projection of t onto the subspace S. This is indeed the case, as can easily be veriﬁed by noting that the solution for y is given

Exercise 3.2 by ΦwML, and then conﬁrming that this takes the form of an orthogonal projection.

In practice, a direct solution of the normal equations can lead to numerical difﬁculties when ΦTΦ is close to singular. In particular, when two or more of the basis vectors ϕj are co-linear, or nearly so, the resulting parameter values can have large magnitudes. Such near degeneracies will not be uncommon when dealing with real data sets. The resulting numerical difﬁculties can be addressed using the technique of singular value decomposition, or SVD (Press et al., 1992; Bishop and Nabney, 2008). Note that the addition of a regularization term ensures that the matrix is nonsingular, even in the presence of degeneracies.

3.1.3 Sequential learning

Batch techniques, such as the maximum likelihood solution (3.15), which involve processing the entire training set in one go, can be computationally costly for large data sets. As we have discussed in Chapter 1, if the data set is sufﬁciently large, it may be worthwhile to use sequential algorithms, also known as on-line algorithms,
