[Page 15]

where $\delta$ and $\tau$ are the estimates of the variance components under the current $k$-dimensional model. The empirical variance estimate can be compared to the true variance:

$$
V(y \mid x_1, x_2) = |x_1| + 2
$$

Figure 2c shows the average over all samples of the empirical variance at each covariate pair plotted against the true variance. The model-estimated values pick up the general trend of the true values, but there seems to be a tendency toward slight underestimation.

Figure 2d is a traceplot of the model marginal likelihood (5) over the sampled iterations. The distribution of this quantity, and of the associated predictions, appears to be stationary, so we find no evidence against convergence of the MCMC algorithm.

![Four-panel evaluation of algorithm performance using simulated data.](<images/BD2005/imageFile2.png>)

*Fig. 2. Evaluation of algorithm performance using simulated data.*

## 4. Progesterone Example

### 4.1 Estimation

We applied these methods to the progesterone data from the NCEPS described in Section 1 with the goal of assessing differences in PdG profiles between conception and non-conception cycles. We were particularly interested in examining differences prior to implantation, since these may indicate hormonal effects on fecundability and conception probabilities.

We apply the approach described in section 2 with three covariates and an intercept. The first covariate is an indicator of whether the cycle during which the measurement was taken resulted in conception. The final two covariates contain the reference point information. They are number of days since cycle start (onset of menses) and number of days relative to ovulation in current cycle. So if response $y_{ij}$ was observed on the third day of a non-conception cycle where ovulation occurred on day 14, then $x_{ij} = (1, 0, 3, -11)'$.

Vague priors on the variance components were achieved by setting the hyperparameters to 0.05. We collected 40,000 MCMC samples after a 20,000 iteration burn-in.
