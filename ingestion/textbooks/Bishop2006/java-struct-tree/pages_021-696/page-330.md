[Page 330]

Figure 6.7 Illustration of the mechanism of Gaussian process regression for the case of one training point and one test point, in which the red ellipses show contours of the joint distribution p(t1, t2). Here t1 is the training data point, and conditioning on the value of t1, corresponding to the vertical blue line, we obtain p(t2|t1) shown as a function of t2 by the green curve. t1

t2

1

m(x2)

0

−1

−1 0 1

framework. However, an advantage of a Gaussian processes viewpoint is that we can consider covariance functions that can only be expressed in terms of an inﬁnite number of basis functions.

For large training data sets, however, the direct application of Gaussian process methods can become infeasible, and so a range of approximation schemes have been developed that have better scaling with training set size than the exact approach (Gibbs, 1997; Tresp, 2001; Smola and Bartlett, 2001; Williams and Seeger, 2001; Csato and Opper, 2002; Seeger´ et al., 2003). Practical issues in the application of Gaussian processes are discussed in Bishop and Nabney (2008).

We have introduced Gaussian process regression for the case of a single target variable. The extension of this formalism to multiple target variables, known Exercise 6.23 as co-kriging (Cressie, 1993), is straightforward. Various other extensions of Gaus-

Figure 6.8 Illustration of Gaussian process regression applied to the sinusoidal data set in Figure A.6 in which the three right-most data points have been omitted. The green curve shows the sinusoidal function from which the data points, shown in blue, are obtained by sampling and addition of Gaussian noise. The red line shows the mean of the Gaussian process predictive distribution, and the shaded region corresponds to plus and minus two standard deviations. Notice how the uncertainty increases in the region to the right of the data points.

1

0.5

0

−0.5

−1

0 0.2 0.4 0.6 0.8 1
