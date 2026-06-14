# Manifest: Page 011

## REPAIR_PROSE
- RAW: ```
Other models. Analytic expressions for A r ij are possible for all distributions in the exponential family. For others like Cauchy we need to perform integral (16) numerically. A very simple approximation is to replace the integral by a sum on a uniform grid: The stepsize/range of the grid should be some fraction/multiple of the typical scale of the integrand, and the center of the grid should be around the mean. A crude estimate of the mean and scale can be obtained from the Gaussian model (26) and (27). Or even simpler, use the estimated global mean and variance (28), and in-segment variance (29) for determining the range (e.g. [ˆ ν − 25ˆ ρ,..., ˆ ν +25ˆ ρ ]) and stepsize (e.g. ˆ σ/ 10) of one grid used for all A r ij . Note that if y ij really stem from one segment, the integrand is typically unimodal and the above estimates for stepsize and range are reasonable, hence the approximation will be good. If y ij ranges over diﬀerent segments, the discretization may be crude, but since in this case, A r ij is (very) small, crude estimates are suﬃcient. Note also that even for the heavy-tailed Cauchy distribution, the ﬁrst and second moments A 1 ij and A 2 ij exist, since the integrand is a product of at least two Cauchy distributions, one prior and one noise for each y t . Preferably, standard numerical integration routines (which are faster, more robust and more accurate) should be used.
```
  FIX: ```
Other models. Analytic expressions for \( A_{ij}^r \) are possible for all distributions in the exponential family. For others like Cauchy we need to perform integral (16) numerically. A very simple approximation is to replace the integral by a sum on a uniform grid: The stepsize/range of the grid should be some fraction/multiple of the typical scale of the integrand, and the center of the grid should be around the mean. A crude estimate of the mean and scale can be obtained from the Gaussian model (26) and (27). Or even simpler, use the estimated global mean and variance (28), and in-segment variance (29) for determining the range (e.g. \( [\hat{\nu} - 25\hat{\rho}, \dots, \hat{\nu} + 25\hat{\rho}] \)) and stepsize (e.g. \( \hat{\sigma}/10 \)) of one grid used for all \( A_{ij}^r \). Note that if \( y_{ij} \) really stem from one segment, the integrand is typically unimodal and the above estimates for stepsize and range are reasonable, hence the approximation will be good. If \( y_{ij} \) ranges over diﬀerent segments, the discretization may be crude, but since in this case, \( A_{ij}^r \) is (very) small, crude estimates are suﬃcient. Note also that even for the heavy-tailed Cauchy distribution, the ﬁrst and second moments \( A_{ij}^1 \) and \( A_{ij}^2 \) exist, since the integrand is a product of at least two Cauchy distributions, one prior and one noise for each \( y_t \). Preferably, standard numerical integration routines (which are faster, more robust and more accurate) should be used.
```

- RAW: ```
Hyper-Bayes and Hyper-ML. The developed regression model still contains three (hyper)parameters, the global variance ρ 2 and mean ν of µ , and the in-segment variance σ 2 . If they are not known, a proper Bayesian treatment would be to assume a hyper-prior over them and integrate them out. Since we do not expect a significant inﬂuence of the hyper-prior (as long as chosen reasonable) on the quantities of interest, one could more easy proceed in an empirical Bayesian way and choose the parameters such that the evidence P ( y | σ,ν,ρ ) is maximized (“hyper-ML”). (We restored the till now omitted dependency on the hyper-parameters).
```
  FIX: ```
Hyper-Bayes and Hyper-ML. The developed regression model still contains three (hyper)parameters, the global variance \( \rho^2 \) and mean \( \nu \) of \( \mu \), and the in-segment variance \( \sigma^2 \). If they are not known, a proper Bayesian treatment would be to assume a hyper-prior over them and integrate them out. Since we do not expect a significant inﬂuence of the hyper-prior (as long as chosen reasonable) on the quantities of interest, one could more easy proceed in an empirical Bayesian way and choose the parameters such that the evidence \( P(y \mid \sigma, \nu, \rho) \) is maximized (“hyper-ML”). (We restored the till now omitted dependency on the hyper-parameters).
```

- RAW: ```
Exhaustive (grid) search for the hyper-ML parameters is expensive. For data which is indeed noisy piecewise constant, P ( y | σ,ν,ρ ) is typically unimodal 4 in ( σ,ν,ρ ) and the global maximum can be found more eﬃciently by greed hill-climbing, but even this may cost a factor of 10 to 1000 in eﬃciency. Below we present a very simple and excellent heuristic for choosing ( σ,ν,ρ ).
```
  FIX: ```
Exhaustive (grid) search for the hyper-ML parameters is expensive. For data which is indeed noisy piecewise constant, \( P(y \mid \sigma, \nu, \rho) \) is typically unimodal 4 in \( (\sigma, \nu, \rho) \) and the global maximum can be found more eﬃciently by greed hill-climbing, but even this may cost a factor of 10 to 1000 in eﬃciency. Below we present a very simple and excellent heuristic for choosing \( (\sigma, \nu, \rho) \).
```

- RAW: ```
Estimate of global mean and variance ν and ρ . A reasonable choice for the level mean and variance ν and ρ are the empirical global mean and variance of the data y . n n
```
  FIX: ```
Estimate of global mean and variance \( \nu \) and \( \rho \). A reasonable choice for the level mean and variance \( \nu \) and \( \rho \) are the empirical global mean and variance of the data \( y \).
```

- RAW: ```
4 A little care is necessary with the in-segment variance σ 2 . If we set it (extremely close) to zero, all segments will consist of a single data point y i with (close to) inﬁnite evidence (see e.g. (25)). Assuming k max <n eliminates this unwished maximum. Greedy hill-climbing with proper initialization will also not be fooled.
```
  FIX: ```
4 A little care is necessary with the in-segment variance \( \sigma^2 \). If we set it (extremely close) to zero, all segments will consist of a single data point \( y_i \) with (close to) inﬁnite evidence (see e.g. (25)). Assuming \( k_{\max} < n \) eliminates this unwished maximum. Greedy hill-climbing with proper initialization will also not be fooled.
```

## REPAIR_MATH
- RAW: ```
$$
\hat { \nu } \approx \frac { 1 } { n } \sum _ { t = 1 } ^ { n } y _ { t } \text { \ and \ } \hat { \rho } ^ { 2 } \approx \frac { 1 } { n - 1 } \sum _ { t = 1 } ^ { n } ( y _ { t } - \hat { \nu } ) ^ { 2 } \\ \text {title care is necessary with the in-segment variance } \sigma ^ { 2 } . \text { If we set it (extremely close) to }
$$
```
  FIX: ```
$$
\hat{\nu} \approx \frac{1}{n} \sum_{t=1}^{n} y_{t} \quad \text{and} \quad \hat{\rho}^{2} \approx \frac{1}{n-1} \sum_{t=1}^{n} (y_{t} - \hat{\nu})^{2}
$$
```
