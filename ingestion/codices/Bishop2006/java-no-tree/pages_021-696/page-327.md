[Page 327]

where the covariance matrix C has elements

###### C(xn,xm) = k(xn,xm) + β−1δnm. (6.62)

This result reﬂects the fact that the two Gaussian sources of randomness, namely that associated with y(x) and that associated with , are independent and so their covariances simply add.

One widely used kernel function for Gaussian process regression is given by the exponential of a quadratic form, with the addition of constant and linear terms to give

θ1 2

k(xn,xm) = θ0 exp −

xn − xm 2 + θ2 + θ3xTnxm. (6.63)

Note that the term involving θ3 corresponds to a parametric model that is a linear function of the input variables. Samples from this prior are plotted for various values

of the parameters θ0,...,θ3 in Figure 6.5, and Figure 6.6 shows a set of points sampled from the joint distribution (6.60) along with the corresponding values deﬁned by (6.61).

So far, we have used the Gaussian process viewpoint to build a model of the joint distribution over sets of data points. Our goal in regression, however, is to make predictions of the target variables for new inputs, given a set of training data. Let us suppose that tN = (t1,...,tN)T, corresponding to input values x1,...,xN, comprise the observed training set, and our goal is to predict the target variable tN+1 for a new input vector xN+1. This requires that we evaluate the predictive distribution p(tN+1|tN). Note that this distribution is conditioned also on the variables x1,...,xN and xN+1. However, to keep the notation simple we will not show these conditioning variables explicitly.

To ﬁnd the conditional distribution p(tN+1|t), we begin by writing down the joint distribution p(tN+1), where tN+1 denotes the vector (t1,...,tN,tN+1)T. We then apply the results from Section 2.3.1 to obtain the required conditional distribution, as illustrated in Figure 6.7.

From (6.61), the joint distribution over t1,...,tN+1 will be given by

p(tN+1) = N(tN+1|0,CN+1) (6.64)

where CN+1 is an (N + 1) × (N + 1) covariance matrix with elements given by (6.62). Because this joint distribution is Gaussian, we can apply the results from Section 2.3.1 to ﬁnd the conditional Gaussian distribution. To do this, we partition the covariance matrix as follows

CN+1 =

CN k kT c

(6.65)

where CN is the N ×N covariance matrix with elements given by (6.62) for n,m = 1,...,N, the vector k has elements k(xn,xN+1) for n = 1,...,N, and the scalar
