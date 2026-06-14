[Page 13]

Hyper-ML estimates. Expressions (28) are the standard estimates of mean and variance of a distribution. They are particularly suitable for (close to) Gaussian distributions, but also for others, as long as ν and ρ parameterize mean and variance. If mean and variance do not exist or the distribution is quite heavy-tailed, we need other estimates. The “ideal” hyper-ML estimates may be approximated as follows. If we assume that each data point lies in its own segment, we get

$$
( \hat { \nu } , \hat { \rho } ) \approx \arg \max _ { ( \nu , \rho ) } \prod _ { t = 1 } ^ { n } P ( y _ { t } | \hat { \sigma } , \nu , \rho ) \quad \text {with} \\ P ( y _ { t } | \sigma , \nu , \rho ) \, = \, \int P ( y _ { t } | \mu , \sigma ) P ( \mu | \nu , \rho ) d \mu \\ \text {variant} \, \hat { \sigma } ^ { 2 } \, \text { can be estimated similarly to the last $p$}
$$

$$
( 3 0 )
$$

The in-segment variance ˆ σ 2 can be estimated similarly to the last paragraph considering data diﬀerences and ignoring segment boundaries:

$$
\hat { \sigma } \approx \arg \max _ { \sigma } \prod _ { t = 1 } ^ { n - 1 } P ( y _ { t + 1 } - y _ { t } | \sigma ) \quad \text {with} \\ P ( y _ { t + 1 } - y _ { t } = \Delta | \sigma ) \approx \int _ { - \infty } ^ { \infty } P ( y _ { t + 1 } = a + \Delta | \mu , \sigma ) P ( y _ { t } = a | \mu , \sigma ) d a \quad ( 3 1 ) \\ \text {Note that the last expression is independent of the segment level (this was the whole}
$$

Note that the last expression is independent of the segment level (this was the whole reason for considering data diﬀerences) and exact iﬀ y t and y t +1 belong to the same segment. In general (beyond the exponential family) (ˆ ν, ˆ ρ, ˆ σ ) can only be determined numerically.

Using median and quartile. We present some simpler estimates based on median and quartiles. Let [ y ] be the data vector y , but sorted in ascending order. Then, item [ y ] αn (where the index is assumed to be rounded up to the next integer) is the α -quantile of empirical distribution y . In particular [ y ] n/ 2 is the median of y . It is a consistent (and robust to outliers) estimator of the mean segment level

$$
\hat { \nu } \approx [ y ] _ { n / 2 }
$$

if noise and segment levels have symmetric distributions. Further, half of the data points lie in the interval [ a,b ], where a :=[ y ] n/ 4 is the ﬁrst and b :=[ y ] 3 n/ 4 is the last quartile of y . So, using (30), ˆ ρ should be estimated such that

$$
P ( a \leq y _ { t } \leq b | \sigma , \hat { \nu } , \hat { \rho } ) \ \stackrel { ! } { \approx } \frac { 1 } { 2 }
$$

Ignoring data noise (assuming σ ≈ 0), we get

$$
\hat { \rho } \approx \frac { [ y ] _ { 3 n / 4 } - [ y ] _ { n / 4 } } { 2 \alpha } \quad \text {with } \alpha = 1 \text { for Cauchy and } \alpha \doteq 0 . 6 7 4 4 \text { for Gauss, }
$$
