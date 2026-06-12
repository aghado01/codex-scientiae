[Page 15]

**Table 3.** Bias, standard deviation, asymptotic standard error and coverage probability for the estimates of the components of $\beta$, under Model 3. The classical and MM-procedures are labeled $ls$ and $mm$, respectively.

| | |C0| |C1| |C2| |C3| |
|---|---|---|---|---|---|---|---|---|---|
| | |ls|mm|ls|mm|ls|mm|ls|mm|
|β1|bias|−0.018|−0.016|−0.010|−0.020|0.009|−0.021|−2.975|−0.010|
| |sd|0.201|0.214|0.635|0.215|5.618|0.213|0.317|0.204|
| |as.se|0.199|0.196|0.934|0.215|5.332|0.918|0.289|0.894|
| |cov.prob|0.952|0.910|0.934|0.922|0.940|0.918|0.000|0.894|
|β2|bias|0.002|0.003|0.004|−0.002|−0.218|0.003|−3.024|0.002|
| |sd|0.210|0.215|0.709|0.236|5.959|0.227|0.309|0.225|
| |as.se|0.199|0.194|0.634|0.211|5.328|0.211|0.282|0.204|
| |cov.prob|0.930|0.892|0.916|0.912|0.914|0.918|0.000|0.906|


![Confidence interval plots for β1 under Model 3, showing classical and MM procedures across contamination settings C0–C3](<images/BM2021/imageFile5.png>)

*Fig. 2. Confidence intervals for $\beta_1$, under Model 3, obtained when using the classical least squares and MM-procedures.*

intervals; however, as illustrated in Table 3, the MM-method leads to a lower probability coverage than the least squares one, in particular when estimating $\beta_2$. The MM-method developed in this paper provides reliable confidence intervals over the considered contamination settings, since their shape is almost the same as under $C_0$ and the coverage probability is stable. In contrast, even when the coverage of the least squares procedure, under $C_1$ and $C_2$, is close to that obtained for clean samples, this stability is obtained at the expense of enlarging the confidence intervals, especially under $C_2$. The impact of high-leverage points on the bias of the classical estimators already discussed is more evident when looking at the confidence intervals, since none of them contain the true value of the parameter.

To evaluate the behavior of the additive component estimators, for $j = 1, 2$, as in Boente et al. (2020b), we measured the performance of the estimator $\hat{\eta}_j$ of $\eta_j$ through the integrated squared error ($\mathrm{ise}$) and the squared integrated bias. We approximate these measures over an equally spaced grid of points $\{t_s\}_{s=1}^{M}$, $0 \leq t_1 < \cdots < t_M \leq 1$ with $M = 1000$; that is, if $\hat{\eta}_{j,\ell}$ is the estimate of the function $\eta_j$ obtained with the $\ell$-th sample ($1 \leq \ell \leq N = 500$), we computed

$$
\widehat{\mathrm{ise}}_{j,\ell} = \frac{1}{M}\sum_{s=1}^{M}\bigl(\hat{\eta}_{j,\ell}(t_s) - \eta_j(t_s)\bigr)^2, \qquad \mathrm{Bias}_j^2 = \frac{1}{M}\sum_{s=1}^{M}\left(\frac{1}{N}\sum_{\ell=1}^{N}\hat{\eta}_{j,\ell}(t_s) - \eta_j(t_s)\right)^2.
$$

Note that $\mathrm{Bias}_j^2$ approximates $\int_0^1\bigl\{(1/N)\sum_{\ell=1}^{N}\hat{\eta}_{j,\ell}(t) - \eta_j(t)\bigr\}^2\,dt$. Taking into account that a few large values of the $\mathrm{ise}$ may have a huge impact on its mean over replications, and to prevent this distorted effect, instead of the mean integrated square error we considered two measures less affected by extreme values: the median of the $\mathrm{ise}$, denoted $\mathrm{medise}$, and the mean of the $\mathrm{ise}$ obtained after trimming the 5% largest values, labeled $5\%\text{-mise}$. The obtained results for the $\mathrm{ise}$ are given in Table 4, while those regarding the squared integrated bias are summarized in Table 5 where we report $100 \times \mathrm{Bias}_j^2$.
