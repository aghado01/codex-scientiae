# Manifest: Page 013

## REPAIR_MATH
- RAW: ```
( \hat { \nu } , \hat { \rho } ) \approx \arg \max _ { ( \nu , \rho ) } \prod _ { t = 1 } ^ { n } P ( y _ { t } | \hat { \sigma } , \nu , \rho ) \quad \text {with} \\ P ( y _ { t } | \sigma , \nu , \rho ) \, = \, \int P ( y _ { t } | \mu , \sigma ) P ( \mu | \nu , \rho ) d \mu \\ \text {variant} \, \hat { \sigma } ^ { 2 } \, \text { can be estimated similarly to the last $p$}
```
  FIX: ```
$$
( \hat { \nu } , \hat { \rho } ) \approx \arg \max _ { ( \nu , \rho ) } \prod _ { t = 1 } ^ { n } P ( y _ { t } | \hat { \sigma } , \nu , \rho ) \quad \text {with} \\ P ( y _ { t } | \sigma , \nu , \rho ) \, = \, \int P ( y _ { t } | \mu , \sigma ) P ( \mu | \nu , \rho ) d \mu \\ \text {variant} \, \hat { \sigma } ^ { 2 } \, \text { can be estimated similarly to the last $p$}
$$
```
- RAW: ```
( 3 0 )
```
  FIX: ```
$$
( 3 0 )
$$
```
- RAW: ```
\hat { \sigma } \approx \arg \max _ { \sigma } \prod _ { t = 1 } ^ { n - 1 } P ( y _ { t + 1 } - y _ { t } | \sigma ) \quad \text {with} \\ P ( y _ { t + 1 } - y _ { t } = \Delta | \sigma ) \approx \int _ { - \infty } ^ { \infty } P ( y _ { t + 1 } = a + \Delta | \mu , \sigma ) P ( y _ { t } = a | \mu , \sigma ) d a \quad ( 3 1 ) \\ \text {Note that the last expression is independent of the segment level (this was the whole}
```
  FIX: ```
$$
\hat { \sigma } \approx \arg \max _ { \sigma } \prod _ { t = 1 } ^ { n - 1 } P ( y _ { t + 1 } - y _ { t } | \sigma ) \quad \text {with} \\ P ( y _ { t + 1 } - y _ { t } = \Delta | \sigma ) \approx \int _ { - \infty } ^ { \infty } P ( y _ { t + 1 } = a + \Delta | \mu , \sigma ) P ( y _ { t } = a | \mu , \sigma ) d a \quad ( 3 1 ) \\ \text {Note that the last expression is independent of the segment level (this was the whole}
$$
```
- RAW: ```
\hat { \nu } \approx [ y ] _ { n / 2 }
```
  FIX: ```
$$
\hat { \nu } \approx [ y ] _ { n / 2 }
$$
```
- RAW: ```
P ( a \leq y _ { t } \leq b | \sigma , \hat { \nu } , \hat { \rho } ) \ \stackrel { ! } { \approx } \frac { 1 } { 2 }
```
  FIX: ```
$$
P ( a \leq y _ { t } \leq b | \sigma , \hat { \nu } , \hat { \rho } ) \ \stackrel { ! } { \approx } \frac { 1 } { 2 }
$$
```
- RAW: ```
\hat { \rho } \approx \frac { [ y ] _ { 3 n / 4 } - [ y ] _ { n / 4 } } { 2 \alpha } \quad \text {with } \alpha = 1 \text { for Cauchy and } \alpha \doteq 0 . 6 7 4 4 \text { for Gauss, }
```
  FIX: ```
$$
\hat { \rho } \approx \frac { [ y ] _ { 3 n / 4 } - [ y ] _ { n / 4 } } { 2 \alpha } \quad \text {with } \alpha = 1 \text { for Cauchy and } \alpha \doteq 0 . 6 7 4 4 \text { for Gauss, }
$$
```
- RAW: `as long as ν and ρ parameterize`
  FIX: `as long as \( \nu \) and \( \rho \) parameterize`
- RAW: `variance ˆ σ 2 can be`
  FIX: `variance \( \hat{\sigma}^2 \) can be`
- RAW: `exact iﬀ y t and y t +1 belong`
  FIX: `exact iff \( y_t \) and \( y_{t+1} \) belong`
- RAW: `family) (ˆ ν, ˆ ρ, ˆ σ ) can`
  FIX: `family) \( (\hat{\nu}, \hat{\rho}, \hat{\sigma}) \) can`
- RAW: `Let [ y ] be the data vector y , but`
  FIX: `Let \( [y] \) be the data vector \( y \), but`
- RAW: `Then, item [ y ] αn (where`
  FIX: `Then, item \( [y]_{\alpha n} \) (where`
- RAW: `the α -quantile of empirical distribution y . In`
  FIX: `the \( \alpha \)-quantile of empirical distribution \( y \). In`
- RAW: `particular [ y ] n/ 2 is the median of y . It`
  FIX: `particular \( [y]_{n/2} \) is the median of \( y \). It`
- RAW: `interval [ a,b ], where a :=[ y ] n/ 4 is the ﬁrst and b :=[ y ] 3 n/ 4 is the last quartile of y . So, using (30), ˆ ρ should`
  FIX: `interval \( [a, b] \), where \( a := [y]_{n/4} \) is the first and \( b := [y]_{3n/4} \) is the last quartile of \( y \). So, using (30), \( \hat{\rho} \) should`
- RAW: `assuming σ ≈ 0), we`
  FIX: `assuming \( \sigma \approx 0 \)), we`

## REPAIR_PROSE
- RAW: `diﬀerences`
  FIX: `differences`
