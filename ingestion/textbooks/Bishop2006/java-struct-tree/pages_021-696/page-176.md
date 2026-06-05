[Page 176]

posterior distribution would become a delta function centred on the true parameter values, shown by the white cross.

Other forms of prior over the parameters can be considered. For instance, we can generalize the Gaussian prior to give

�M exp�

� (3.56)

p(w|α) = �

q 2 �α

2 �1/q 1

�M

α 2

|wj|q

−

Γ(1/q)

j=1

in which q = 2 corresponds to the Gaussian distribution, and only in this case is the prior conjugate to the likelihood function (3.10). Finding the maximum of the posterior distribution over w corresponds to minimization of the regularized error function (3.29). In the case of the Gaussian prior, the mode of the posterior distribution was equal to the mean, although this will no longer hold if q �= 2.

3.3.2 Predictive distribution

In practice, we are not usually interested in the value of w itself but rather in making predictions of t for new values of x. This requires that we evaluate the predictive distribution deﬁned by

p(t|t,α,β) = � p(t|w,β)p(w|t,α,β)dw (3.57)

in which t is the vector of target values from the training set, and we have omitted the corresponding input vectors from the right-hand side of the conditioning statements to simplify the notation. The conditional distribution p(t|x,w,β) of the target variable is given by (3.8), and the posterior weight distribution is given by (3.49). We see that (3.57) involves the convolution of two Gaussian distributions, and so making use of the result (2.115) from Section 8.1.4, we see that the predictive distribution

Exercise 3.10 takes the form

p(t|x,t,α,β) = N(t|mTNφ(x),σN2 (x)) (3.58) where the variance σN2 (x) of the predictive distribution is given by

σN2 (x) =

1 β

+ φ(x)TSNφ(x). (3.59)

The ﬁrst term in (3.59) represents the noise on the data whereas the second term reﬂects the uncertainty associated with the parameters w. Because the noise process and the distribution of w are independent Gaussians, their variances are additive. Note that, as additional data points are observed, the posterior distribution becomes narrower. As a consequence it can be shown (Qazaz et al., 1997) that σN2 +1(x) �

Exercise 3.11 σN2 (x). In the limit N → ∞, the second term in (3.59) goes to zero, and the variance of the predictive distribution arises solely from the additive noise governed by the parameter β.

As an illustration of the predictive distribution for Bayesian linear regression models, let us return to the synthetic sinusoidal data set of Section 1.1. In Figure 3.8,
