[Page 326]

Figure 6.4 Samples from Gaussian processes for a ‘Gaussian’ kernel (left) and an exponential kernel (right).

3

1.5

0

−1.5

−3

−1 −0.5 0 0.5 1

3

1.5

0

−1.5

−3

−1 −0.5 0 0.5 1

6.4.2 Gaussian processes for regression

In order to apply Gaussian process models to the problem of regression, we need to take account of the noise on the observed target values, which are given by

tn = yn + �n (6.57)

where yn = y(xn), and �n is a random noise variable whose value is chosen independently for each observation n. Here we shall consider noise processes that have a Gaussian distribution, so that

p(tn|yn) = N(tn|yn,β−1) (6.58)

where β is a hyperparameter representing the precision of the noise. Because the noise is independent for each data point, the joint distribution of the target values t = (t1,...,tN)T conditioned on the values of y = (y1,...,yN)T is given by an isotropic Gaussian of the form

p(t|y) = N(t|y,β−1IN) (6.59)

where IN denotes the N ×N unit matrix. From the deﬁnition of a Gaussian process, the marginal distribution p(y) is given by a Gaussian whose mean is zero and whose covariance is deﬁned by a Gram matrix K so that

p(y) = N(y|0,K). (6.60)

The kernel function that determines K is typically chosen to express the property that, for points xn and xm that are similar, the corresponding values y(xn) and y(xm) will be more strongly correlated than for dissimilar points. Here the notion of similarity will depend on the application.

In order to ﬁnd the marginal distribution p(t), conditioned on the input values

x1,...,xN, we need to integrate over y. This can be done by making use of the results from Section 2.3.3 for the linear-Gaussian model. Using (2.115), we see that the marginal distribution of t is given by

p(t) = � p(t|y)p(y)dy = N(t|0,C) (6.61)
