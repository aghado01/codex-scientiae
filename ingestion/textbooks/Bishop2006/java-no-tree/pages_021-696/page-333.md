[Page 333]

Figure 6.10 Illustration of automatic relevance determination in a Gaussian process for a synthetic problem having three inputs x1, x2, and x3, for which the curves show the corresponding values of the hyperparameters η1 (red), η2 (green), and η3 (blue) as a function of the number of iterations when optimizing the marginal likelihood. Details are given in the text. Note the logarithmic scale on the vertical axis.

102

| |
|---|


100

10−2

10−4

0 20 40 60 80 100

Gaussian noise. Values of x2 are given by copying the corresponding values of x1 and adding noise, and values of x3 are sampled from an independent Gaussian distribution. Thus x1 is a good predictor of t, x2 is a more noisy predictor of t, and x3 has only chance correlations with t. The marginal likelihood for a Gaussian process with ARD parameters η1,η2,η3 is optimized using the scaled conjugate gradients algorithm. We see from Figure 6.10 that η1 converges to a relatively large value, η2 converges to a much smaller value, and η3 becomes very small indicating that x3 is irrelevant for predicting t.

The ARD framework is easily incorporated into the exponential-quadratic kernel (6.63) to give the following form of kernel function, which has been found useful for applications of Gaussian processes to a range of regression problems

1 2

k(xn,xm) = θ0 exp −

D

ηi(xni − xmi)2 + θ2 + θ3

i=1

D

xnixmi (6.72)

i=1

where D is the dimensionality of the input space.

###### 6.4.5 Gaussian processes for classiﬁcation

In a probabilistic approach to classiﬁcation, our goal is to model the posterior probabilities of the target variable for a new input vector, given a set of training data. These probabilities must lie in the interval (0,1), whereas a Gaussian process model makes predictions that lie on the entire real axis. However, we can easily adapt Gaussian processes to classiﬁcation problems by transforming the output of the Gaussian process using an appropriate nonlinear activation function.

Consider ﬁrst the two-class problem with a target variable t ∈ {0,1}. If we deﬁne a Gaussian process over a function a(x) and then transform the function using a logistic sigmoid y = σ(a), given by (4.59), then we will obtain a non-Gaussian stochastic process over functions y(x) where y ∈ (0,1). This is illustrated for the case of a one-dimensional input space in Figure 6.11 in which the probability distri-
