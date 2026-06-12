[Page 24]

A brief application (Ruppert et al., 2003) is presented in this section. The LIDAR data consist of n = 221 observations. The covariate, range, is the distance that light travels before coming back to its source, and the dependent variable is log ratio, which is the logarithm of the ratio of light received from two laser sources. Again, assume

$$
y _ { i } = f ( x _ { i } ) + \epsilon _ { i } .
$$

The above sampling scheme was applied to the LIDAR data with 10,000 iterations, the ﬁrst 2000 of which were used as a burn-in period. Estimates using basis functions of degree p = 1 and 2 are displayed. The number of knots for this application is K κ = 40. Pointwise 95% credible intervals are also shown for each estimate (see Figure 2.2). The credible intervals are calculated by computing the 2.5th percentile and 97.5th percentile of the MCMC iterations of T ˆ θ at each covariate value. From the plot, both estimates provide a good ﬁt for the data.

0.0

−0.2

−0.4

log(ratio)

Linear Fit Quadratic

Quadratic Fit

Intervals (p = 1) 95% Credible Intervals (p = 2)

95% Credible Intervals (p = 2)

−0.6

−0.8

400

450

500

550

600

650

700

range

Figure 2.2: P-spline estimates of degrees p = 1 (solid line) and p = 2 (dashed line) to the LIDAR data along with pointwise 95% credible intervals.
