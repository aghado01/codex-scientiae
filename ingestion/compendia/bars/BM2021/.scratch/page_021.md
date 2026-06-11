[Page 21]

**Table 6.** Mean and standard deviation of the estimates of $\mu$ over replications.

| | |Model 1| | |Model 2| | |Model 3| | |Model 4| | |Model 5| | |Model 6| | |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| | |ls|l1|mm|ls|l1|mm|ls|l1|mm|ls|l1|mm|ls|l1|mm|ls|l1|mm|
|C0|mean|0.001|0.022|0.002|−0.001|0.018|−0.002|0.014|0.040|0.011|−0.001|0.024|−0.000|0.004|0.022|−0.001|0.008|0.013|−0.006|
| |sd|0.058|0.074|0.107|0.064|0.084|0.070|0.183|0.242|0.196|0.049|0.063|0.052|0.123|0.156|0.130|0.059|0.071|0.061|
|C1|mean|0.010|0.027|0.003|0.007|0.018|−0.004|0.007|0.046|0.017|0.009|0.024|0.005|0.025|0.018|0.003|−0.017|0.007|−0.008|
| |sd|0.188|0.082|0.069|0.211|0.091|0.076|0.641|0.262|0.207|0.166|0.072|0.064|0.398|0.166|0.139|0.198|0.086|0.070|
|C2|mean|2.322|0.082|0.012|2.258|0.071|−0.005|2.348|0.105|0.015|2.326|0.082|0.001|2.448|0.077|0.000|2.244|0.062|−0.007|
| |sd|1.586|0.128|0.185|1.928|0.130|0.003|5.161|0.323|0.006|1.326|0.116|0.000|3.263|0.197|0.155|1.530|0.105|0.007|
|C3|mean|2.988|3.014|0.010|2.995|3.027|−0.074|3.564|3.580|0.207|1.675|1.647|−0.000|2.174|2.211|0.001|2.183|2.132|−0.007|
| |sd|0.143|0.186|0.231|0.123|0.153|0.074|0.166|0.212|0.207|0.152|0.189|0.053|0.072|0.093|0.133|0.160|0.193|0.064|


**Table 7.** Estimates and their standard deviations using cubic splines to estimate $h^*$.

| |$\hat{\beta}_{ls}$|$\hat{\beta}_{mm}$|$\hat{\beta}_{ls}^{(-\mathrm{out})}$|
|---|---|---|---|
|$\hat{\beta}$|−0.5750|−0.5099|−0.4733|
|$\widehat{\mathrm{se}}(\hat{\beta})$|0.1078|0.0149|0.0720|


distorted (see Fig. S.19). Besides, under $C_2$, their standard deviations are, in most cases, larger than those obtained with the other two methods. Note that, however, their huge bias makes the estimate unreliable. It should be noticed that the high-leverage points of contamination $C_3$ also affect the quantile estimator, whose bias is in some cases larger than that of the classical procedure.

## 6. Real Data Example

In this section, we analyze the Boston housing data set, available in the package `MASS` in R. These data contain measurements from 506 different houses taken at different locations in Boston Standard Metropolitan Statistical Area in 1970, collected by the U.S. Census Service. Harrison and Rubinfeld (1978) considered their median price values and other thirteen socio-demographic variables to evaluate how marginal air pollution damages are revealed in the housing market. Following Ma and Yang (2011), we modeled the median value of owner-occupied homes in $\$1000$s, denoted MEDV, with the following four covariates of interest:

- **RM**: average number of rooms per dwelling;
- **TAX**: full-value property-tax rate per $\$10,000$;
- **PTRATIO**: pupil-teacher ratio by town school district;
- **LSTAT**: proportion of population that is of "lower status" in %.

These covariates were also considered in Wang and Yang (2009) who fit an additive model to these data. Ma and Yang (2011) considered a partially linear additive model with a linear component on the pupil-teacher ratio. For that reason, we also propose to fit the model

$$
\mathrm{MEDV} = \mu + \beta\,\mathrm{PTRATIO} + \eta_1(\mathrm{RM}) + \eta_2(\log(\mathrm{TAX})) + \eta_3(\log(\mathrm{LSTAT})) + \sigma\,\varepsilon,
$$

where the errors $\varepsilon$ are assumed to be independent, independent of the covariates, with symmetric distribution and scale 1. With the notation given in equation (2), $Z = \mathrm{PTRATIO}$ and $X = (X_1, X_2, X_3)^t = (\mathrm{RM}, \log(\mathrm{TAX}), \log(\mathrm{LSTAT}))^t$. To estimate the additive components, we use cubic B-splines. When estimating $\eta_j$, the knots are taken as the $\ell/(k+1) \times 100\%$ quantiles, $\ell = 1, \ldots, k$, of the observed values of the covariate $X_j$. Taking into account that $n = 506$, the basis dimension $k$ varies between 4 and 14. Both the classical and the robust BIC criteria introduced in (8) selected $k = 5$ to approximate the additive functions. When using the robust procedure, the loss functions and their tuning constants were selected as in the simulation study.

In view of the numerical results obtained in Section 5, we only computed the estimators obtained through the least squares and the robust MM-approach, which are labeled with the subscripts $ls$ and $mm$, respectively. The obtained estimates of $\mu$ are $\hat{\mu}_{ls} = 39.340$ and $\hat{\mu}_{mm} = 37.998$, while those of $\beta$ can be seen in the left and center columns of Table 7. The first row reports the estimates $\hat{\beta}_{ls}$ and $\hat{\beta}_{mm}$ while the second row contains their estimated asymptotic standard errors. As in Section 5 and according to Theorem 4.1, for the least squares approach, $\hat{\Sigma}$ was computed as $\hat{\Sigma} = \hat{\sigma}^2 \hat{A}^{-1}$ with $\hat{\sigma}$ the standard deviation of the residuals obtained from the classical fit and $\hat{A} = (1/n)\sum_{i=1}^{n}\{Z_i - \hat{h}^*(X_i)\}\{Z_i - \hat{h}^*(X_i)\}^t$ where $\hat{h}^*$ minimizes the function $\Upsilon$ defined in (18). When considering the MM-estimators, as in the numerical study reported in Section 5, the estimated asymptotic variances were calculated as the diagonal elements of $\hat{\Sigma} = \hat{B}^{-1}\hat{D}(\hat{B}^{-1})^t$, following the description to robustly estimate $h^*$ given in Section 4.1. To have an insight on the shape of the estimated curves, the estimators of $\eta_j$, $j = 1, 2, 3$, are displayed in Fig. 7. The robust and classical estimators are plotted in solid blue and dashed red lines, respectively. As in Section 5, the reader is
