[Page 6]


1.5


1.0



0.5


0.0


−0.5


−1.0



0.00

0.25

0.50

0.75

1.00

0.00

0.25

0.50

0.75

1.00

0.00

0.25

0.50

0.75

1.00

Figure 1: Linear splines with one, two and four knots. Black segments are true spline curves and red points are noisy observed data with m = 200 .

Table 1: Absolute errors for knot location estimation of three methods in k = 1, 2

Methods


One knot Knot 1

Two knots

Knot 1

Knot 2

EBARS MML Segmented

200

0.0219(0.0126) 0.0163(0.0099) 0.0159(0.0102)

0.0167(0.0150) 0.0138(0.0118) 0.0117(0.0113)

0.0248(0.0257) 0.0170(0.0214) 0.0186(0.0204)

MML Segmented

500

0.0100(0.0076) 0.0075(0.0060) 0.0079(0.0061)

0.0068(0.0058) 0.0070(0.0059)

0.0102(0.0076) 0.0113(0.0081)

We perform EBARS for knot inference in linear spline regression. Line segments are connected in unique knots and the spline is discontinuous at the location where two knots coincide. The data is generated from three linear spline models with one, two and four knots as shown in Figure 1, where the knot locations are respectively (0.5), (0.3, 0.7), (0.2, 0.2, 0.5, 0.7).The functions are continuous except for the spline with k = 4.The noise is Gaussian with standard deviation 0.4, 0.3, 0.4 .

Figure 2 illustrates the posterior distribution of the knot number and location by EBARS with γ = 1 in k = 1, 2, 4.The sample size is 500 in all scenarios. We simulate 5000 samples of ( k,ξ ) via RJMCMC after 5000 burning steps. Histograms show that the average knot number is close to the true value with negligible error. From the density plots, the posterior mass concentrates on the correct location of change points in all cases even though the knot number is unknown. Especially, for k = 4, the posterior density at 0.2 is double at 0.5 and 0.7, meaning that 0.2 is chosen as the knot twice.

To evaluate the performance of knot inference, we compare EBARS with Segmented of Muggeo and MML of Guangyu Yang and Zhang. In this experiment, the knot number is given since Segmented and MML cannot estimate k.The absolute error of knot location is calculated as criteria. Three methods are evaluated under sample sizes m = 200, 500 and the experiment is repeated 50 times.

Simulation results of the mean and standard deviation of absolute errors are summarized in Tables 1 and 2. When k = 1, 2, three methods obtain fairly small absolute errors. However, when k = 4, the absolute errors of EBARS are much less than other two algorithms for all knots. MML struggles to estimate the duplicate knots 0.2 and causes horrible bias. Segmented outperforms MML but it is still much less accurate than EBARS. Compared with MML and Segmented, our EBARS is robust and attain a precise estimation with jumping discontinuity and increasing number of knots. Furthermore, MML and Segmented are exclusively applied in linear splines and they require the knot number to be given, whereas EBARS is convenient to estimate the knot number and location simultaneously in splines of any degree.
