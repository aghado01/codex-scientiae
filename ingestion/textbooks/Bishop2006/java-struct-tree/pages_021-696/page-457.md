[Page 457]

2

0

2

0

2

L = 1

0

−2

−2 0 (a) 2

2

L = 2

−2

−2 0 (b) 2

2

L = 5

−2

−2 0 2

(c)

2

L = 20

0

0

0

−2

−2 0 2

(d)

−2

−2 0 2

(e)

−2

−2 0 2

(f)

Figure 9.8 Illustration of the EM algorithm using the Old Faithful set as used for the illustration of the K-means algorithm in Figure 9.1. See the text for details.

and the M step, for reasons that will become apparent shortly. In the expectation step, or E step, we use the current values for the parameters to evaluate the posterior probabilities, or responsibilities, given by (9.13). We then use these probabilities in the maximization step, or M step, to re-estimate the means, covariances, and mixing coefﬁcients using the results (9.17), (9.19), and (9.22). Note that in so doing we ﬁrst evaluate the new means using (9.17) and then use these new values to ﬁnd the covariances using (9.19), in keeping with the corresponding result for a single Gaussian distribution. We shall show that each update to the parameters resulting from an E step followed by an M step is guaranteed to increase the log likelihood

Section 9.4 function. In practice, the algorithm is deemed to have converged when the change in the log likelihood function, or alternatively in the parameters, falls below some threshold. We illustrate the EM algorithm for a mixture of two Gaussians applied to the rescaled Old Faithful data set in Figure 9.8. Here a mixture of two Gaussians is used, with centres initialized using the same values as for the K-means algorithm in Figure 9.1, and with precision matrices initialized to be proportional to the unit matrix. Plot (a) shows the data points in green, together with the initial conﬁguration of the mixture model in which the one standard-deviation contours for the two
