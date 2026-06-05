[Page 321]

- 0.8
- 1


1

| |
|---|


| |
|---|


0.8

0.6

0.6

0.4

0.4

0.2

0.2

0

0

−1 −0.5 0 0.5 1

−1

−0.5 0 0.5 1

- Figure 6.2 Plot of a set of Gaussian basis functions on the left, together with the corresponding normalized basis functions on the right.


One of the simplest ways of choosing basis function centres is to use a randomly chosen subset of the data points. A more systematic approach is called orthogonal least squares (Chen et al., 1991). This is a sequential selection process in which at each step the next data point to be chosen as a basis function centre corresponds to the one that gives the greatest reduction in the sum-of-squares error. Values for the expansion coefﬁcients are determined as part of the algorithm. Clustering algorithms

Section 9.1 such as K-means have also been used, which give a set of basis function centres that

no longer coincide with training data points.

###### 6.3.1 Nadaraya-Watson model

In Section 3.3.3, we saw that the prediction of a linear regression model for a new input x takes the form of a linear combination of the training set target values with coefﬁcients given by the ‘equivalent kernel’ (3.62) where the equivalent kernel satisﬁes the summation constraint (3.64).

We can motivate the kernel regression model (3.61) from a different perspective, starting with kernel density estimation. Suppose we have a training set {xn,tn} and

- Section 2.5.1 we use a Parzen density estimator to model the joint distribution p(x,t), so that


1 N

p(x,t) =

N

f(x − xn,t − tn) (6.42)

n=1

where f(x,t) is the component density function, and there is one such component centred on each data point. We now ﬁnd an expression for the regression function y(x), corresponding to the conditional average of the target variable conditioned on
