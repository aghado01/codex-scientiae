[Page 522]

6

4

2

0

−2

−4

0.99

0.75

0.25

0.01

6

4

2

0

−2

−4

−6

−4 −2 0 2 4

−6

−4 −2 0 2 4

Figure 10.13 Illustration of the Bayesian approach to logistic regression for a simple linearly separable data set. The plot on the left shows the predictive distribution obtained using variational inference. We see that the decision boundary lies roughly mid way between the clusters of data points, and that the contours of the predictive distribution splay out away from the data reﬂecting the greater uncertainty in the classiﬁcation of such regions. The plot on the right shows the decision boundaries corresponding to ﬁve samples of the parameter vector w drawn from the posterior distribution p(w|t).

1 2

1 2

1 2

ln |SN| |S0|

mTNS−1

mT0 S−1

L(ξ) =

N mN +

0 m0

−

�lnσ(ξn) −

ξn − λ(ξn)ξn2�. (10.164)

�N

1 2

+

n=1

This variational framework can also be applied to situations in which the data is arriving sequentially (Jaakkola and Jordan, 2000). In this case we maintain a Gaussian posterior distribution over w, which is initialized using the prior p(w). As each data point arrives, the posterior is updated by making use of the bound (10.151) and then normalized to give an updated posterior distribution.

The predictive distribution is obtained by marginalizing over the posterior distribution, and takes the same form as for the Laplace approximation discussed in Section 4.5.2. Figure 10.13 shows the variational predictive distributions for a synthetic data set. This example provides interesting insights into the concept of ‘large margin’, which was discussed in Section 7.1 and which has qualitatively similar behaviour to the Bayesian solution.

10.6.3 Inference of hyperparameters

So far, we have treated the hyperparameter α in the prior distribution as a known constant. We now extend the Bayesian logistic regression model to allow the value of this parameter to be inferred from the data set. This can be achieved by combining the global and local variational approximations into a single framework, so as to maintain a lower bound on the marginal likelihood at each stage. Such a combined approach was adopted by Bishop and Svensen (2003) in the context of a Bayesian´ treatment of the hierarchical mixture of experts model.
