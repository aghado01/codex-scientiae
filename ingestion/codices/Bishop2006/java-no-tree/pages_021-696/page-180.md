[Page 180]

- Figure 3.11 Examples of equivalent kernels k(x, x ) for x = 0 plotted as a function of x , corresponding (left) to the polynomial basis functions and (right) to the sigmoidal basis functions shown in Figure 3.1. Note that these are localized functions of x even though the corresponding basis functions are


nonlocal.

| |
|---|
| |


| |
|---|
| |


0.04

0.04

0.02

0.02

0

0

−1 0 1

−1 0 1

Further insight into the role of the equivalent kernel can be obtained by considering the covariance between y(x) and y(x ), which is given by

cov[y(x),y(x )] = cov[φ(x)Tw,wTφ(x )]

= φ(x)TSNφ(x ) = β−1k(x,x ) (3.63)

where we have made use of (3.49) and (3.62). From the form of the equivalent kernel, we see that the predictive mean at nearby points will be highly correlated, whereas for more distant pairs of points the correlation will be smaller.

The predictive distribution shown in Figure 3.8 allows us to visualize the pointwise uncertainty in the predictions, governed by (3.59). However, by drawing samples from the posterior distribution over w, and plotting the corresponding model functions y(x,w) as in Figure 3.9, we are visualizing the joint uncertainty in the posterior distribution between the y values at two (or more) x values, as governed by the equivalent kernel.

The formulation of linear regression in terms of a kernel function suggests an alternative approach to regression as follows. Instead of introducing a set of basis functions, which implicitly determines an equivalent kernel, we can instead deﬁne a localized kernel directly and use this to make predictions for new input vectors x, given the observed training set. This leads to a practical framework for regression (and classiﬁcation) called Gaussian processes, which will be discussed in detail in Section 6.4.

We have seen that the effective kernel deﬁnes the weights by which the training set target values are combined in order to make a prediction at a new value of x, and it can be shown that these weights sum to one, in other words

###### N

k(x,xn) = 1 (3.64)

n=1

- Exercise 3.14 for all values of x. This intuitively pleasing result can easily be proven informally by noting that the summation is equivalent to considering the predictive mean y(x)


for a set of target data in which tn = 1 for all n. Provided the basis functions are linearly independent, that there are more data points than basis functions, and that one of the basis functions is constant (corresponding to the bias parameter), then it is clear that we can ﬁt the training data exactly and hence that the predictive mean will
