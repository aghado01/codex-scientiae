[Page 500]

Figure 10.6 Variational Bayesian mixture of K = 6 Gaussians applied to the Old Faithful data set, in which the ellipses denote the one standard-deviation density contours for each of the components, and the density of red ink inside each ellipse corresponds to the mean value of the mixing coefﬁcient for each component. The number in the top left of each diagram shows the number of iterations of variational inference. Components whose expected mixing coefﬁcient are numerically indistinguishable from zero are not plotted.

![In this image we can see some green color cells.](../images/imageFile238.png)

0

15

60

120

In Figure 10.6, the prior over the mixing coefﬁcients is a Dirichlet of the form (10.39). Recall from Figure 2.5 that for α 0 < 1 the prior favours solutions in which some of the mixing coefﬁcients are zero. Figure 10.6 was obtained using α 0 = 10 − 3 , and resulted in two components having nonzero mixing coefﬁcients. If instead we choose α 0 = 1 we obtain three components with nonzero mixing coefﬁcients, and for α = 10 all six components have nonzero mixing coefﬁcients.

As we have seen there is a close similarity between the variational solution for the Bayesian mixture of Gaussians and the EM algorithm for maximum likelihood. In fact if we consider the limit N → ∞ then the Bayesian treatment converges to the maximum likelihood EM algorithm. For anything other than very small data sets, the dominant computational cost of the variational algorithm for Gaussian mixtures arises from the evaluation of the responsibilities, together with the evaluation and inversion of the weighted data covariance matrices. These computations mirror precisely those that arise in the maximum likelihood EM algorithm, and so there is little computational overhead in using this Bayesian approach as compared to the traditional maximum likelihood one. There are, however, some substantial advantages. First of all, the singularities that arise in maximum likelihood when a Gaussian component ‘collapses’ onto a speciﬁc data point are absent in the Bayesian treatment.
