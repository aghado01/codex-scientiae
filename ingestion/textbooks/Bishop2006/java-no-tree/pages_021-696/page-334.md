[Page 334]

1

10

| |
|---|


| |
|---|


5

0.75

0

0.5

−5

0.25

−10

0

−1 −0.5 0 0.5 1

−1

−0.5 0 0.5 1

- Figure 6.11 The left plot shows a sample from a Gaussian process prior over functions a(x), and the right plot shows the result of transforming this sample using a logistic sigmoid function.


bution over the target variable t is then given by the Bernoulli distribution

###### p(t|a) = σ(a)t(1 − σ(a))1−t. (6.73)

As usual, we denote the training set inputs by x1,...,xN with corresponding observed target variables t = (t1,...,tN)T. We also consider a single test point xN+1 with target value tN+1. Our goal is to determine the predictive distribution p(tN+1|t), where we have left the conditioning on the input variables implicit. To do this we introduce a Gaussian process prior over the vector aN+1, which has components a(x1),...,a(xN+1). This in turn deﬁnes a non-Gaussian process over tN+1, and by conditioning on the training data tN we obtain the required predictive distribution. The Gaussian process prior for aN+1 takes the form

###### p(aN+1) = N(aN+1|0,CN+1). (6.74)

Unlike the regression case, the covariance matrix no longer includes a noise term because we assume that all of the training data points are correctly labelled. However, for numerical reasons it is convenient to introduce a noise-like term governed by a parameter ν that ensures that the covariance matrix is positive deﬁnite. Thus the covariance matrix CN+1 has elements given by

###### C(xn,xm) = k(xn,xm) + νδnm (6.75)

where k(xn,xm) is any positive semideﬁnite kernel function of the kind considered in Section 6.2, and the value of ν is typically ﬁxed in advance. We shall assume that the kernel function k(x,x ) is governed by a vector θ of parameters, and we shall later discuss how θ may be learned from the training data.

For two-class problems, it is sufﬁcient to predict p(tN+1 = 1|tN) because the value of p(tN+1 = 0|tN) is then given by 1 − p(tN+1 = 1|tN). The required
