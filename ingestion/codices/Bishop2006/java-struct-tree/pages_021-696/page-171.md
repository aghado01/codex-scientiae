[Page 171]

Figure 3.6 Plot of squared bias and variance, together with their sum, corresponding to the results shown in Figure 3.5. Also shown is the average test set error for a test data set size of 1000 points. The minimum value of (bias)2 + variance occurs around ln λ = −0.31, which is close to the value that gives the minimum error on the test data.

0.15

0.12

0.09

0.06

0.03

(bias)2 variance (bias)2 + variance test error

0

−3 −2 −1 0 1 2

ln λ

ﬁt a model with 24 Gaussian basis functions by minimizing the regularized error function (3.27) to give a prediction function y(l)(x) as shown in Figure 3.5. The top row corresponds to a large value of the regularization coefﬁcient λ that gives low variance (because the red curves in the left plot look similar) but high bias (because the two curves in the right plot are very different). Conversely on the bottom row, for which λ is small, there is large variance (shown by the high variability between the red curves in the left plot) but low bias (shown by the good ﬁt between the average model ﬁt and the original sinusoidal function). Note that the result of averaging many solutions for the complex model with M = 25 is a very good ﬁt to the regression function, which suggests that averaging may be a beneﬁcial procedure. Indeed, a weighted averaging of multiple solutions lies at the heart of a Bayesian approach, although the averaging is with respect to the posterior distribution of parameters, not with respect to multiple data sets.

We can also examine the bias-variance trade-off quantitatively for this example. The average prediction is estimated from

�L

1 L

y(x) =

y(l)(x) (3.45)

l=1

and the integrated squared bias and integrated variance are then given by

�N

1 N

{y(xn) − h(xn)}2 (3.46)

(bias)2 =

n=1

�N

�L

1 L

1 N

�

�2

y(l)(xn) − y(xn)

variance =

(3.47)

n=1

l=1

where the integral over x weighted by the distribution p(x) is approximated by a ﬁnite sum over data points drawn from that distribution. These quantities, along with their sum, are plotted as a function of lnλ in Figure 3.6. We see that small values of λ allow the model to become ﬁnely tuned to the noise on each individual
