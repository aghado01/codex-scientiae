# Manifest: Page 005

## REPAIR_PROSE
- RAW: `Our ﬁrst quantities`
  FIX: `Our first quantities`
- RAW: `speciﬁcation of the data`
  FIX: `specification of the data`
- RAW: `## 4 Speciﬁc Models`
  FIX: `## 4 Specific Models`

## REPAIR_MATH
- RAW: `for each boundary t q its posterior and MAP, given the MAP estimate of k`
  FIX: `for each boundary \( t_q \) its posterior and MAP, given the MAP estimate of \( k \)`
- RAW: `Diﬀerent estimates of t q (e.g. the mean or MAP based on the joint t posterior) will be discussed later.`
  FIX: `Different estimates of \( t_q \) (e.g. the mean or MAP based on the joint \( t \) posterior) will be discussed later.`
- RAW: `The estimate ( ˆ µ , ˆ t , ˆ k ) deﬁnes a (single) piecewise constant (PC) function ˆ f , which is our estimate of f .`
  FIX: `The estimate \( (\hat{\mu}, \hat{t}, \hat{k}) \) defines a (single) piecewise constant (PC) function \( \hat{f} \), which is our estimate of \( f \).`
- RAW: `A (very) diﬀerent quantity is to Bayes-average over all piecewise constant functions and to ask for the mean at location i as an estimate for f i .`
  FIX: `A (very) different quantity is to Bayes-average over all piecewise constant functions and to ask for the mean at location \( i \) as an estimate for \( f_i \).`
- RAW: `We will see that µ ′ behaves similar to a local smoothing of y , but without blurring true jumps.`
  FIX: `We will see that \( \mu' \) behaves similar to a local smoothing of \( y \), but without blurring true jumps.`
- RAW: `segmentations into k segments.`
  FIX: `segmentations into \( k \) segments.`
- RAW: `Since there are ( n − 1 k − 1 ) ways of placing the k − 1 inner boundaries (ordered and without repetition) on (1 ,...,n − 1), we have n − 1`
  FIX: `Since there are \( \binom{n-1}{k-1} \) ways of placing the \( k-1 \) inner boundaries (ordered and without repetition) on \( (1, \dots, n-1) \),`
- RAW: `to derive eﬃcient algorithms. We now discuss some (purely exemplary) choices for the data noise and priors on µ and k .`
  FIX: `to derive efficient algorithms. We now discuss some (purely exemplary) choices for the data noise and priors on \( \mu \) and \( k \).`
- RAW: `on the means µ q for each segment q is also Gauss`
  FIX: `on the means \( \mu_q \) for each segment \( q \) is also Gauss`
- RAW: ```
\# \text { segments} \colon \ P ( k | y ) \ \text { and } \ \hat { k } \, = \, \arg \max _ { k } P ( k | y )
```
  FIX: ```
$$
\# \text { segments} \colon \ P ( k | y ) \ \text { and } \ \hat { k } \, = \, \arg \max _ { k } P ( k | y )
$$
```
- RAW: ```
\text {boundaries} \colon \ P ( t _ { q } | y , \hat { k } ) \ \text { and } \ \hat { t } _ { q } \ = \ \arg \max _ { t _ { q } } P ( t _ { q } | y , \hat { k } )
```
  FIX: ```
$$
\text {boundaries} \colon \ P ( t _ { q } | y , \hat { k } ) \ \text { and } \ \hat { t } _ { q } \ = \ \arg \max _ { t _ { q } } P ( t _ { q } | y , \hat { k } )
$$
```
- RAW: ```
\text { discussed later.} \ F \text { finally we want the segment level means for the MAP segmentation} \\ \text { segment level: } \ P ( \mu _ { q } | y , \hat { t } , \hat { k } ) \quad \text {and} \quad \hat { \mu } _ { q } \, = \, \int P ( \mu _ { q } | y , \hat { t } , \hat { k } ) \mu _ { q } d \mu _ { q } \\ \text { The optimum} \ ( \hat { u } \ \hat { t } \ \hat { k } ) \ \text { defines } o \left ( \text {single} \right ) \text { picoservice, constant} \ ( \text {PC} ) \ \text { function} \ \hat { f } \ \text { which is}
```
  FIX: ```
$$
\text{segment level:} \quad P ( \mu _ { q } | y , \hat { t } , \hat { k } ) \quad \text {and} \quad \hat { \mu } _ { q } \, = \, \int P ( \mu _ { q } | y , \hat { t } , \hat { k } ) \mu _ { q } d \mu _ { q }
$$
```
- RAW: ```
\text {instant functions and to ask for the mean at location } i \text { as an estimate for } f _ { i } . \\ \text {regression curve: } \quad P ( \mu _ { i } ^ { \prime } | y ) \quad \text {and} \quad \hat { \mu } _ { i } ^ { \prime } \, = \, \int P ( \mu _ { i } ^ { \prime } | y ) \mu _ { i } ^ { \prime } d \mu _ { i } ^ { \prime } \\ \text {will see that } \mu _ { i } ^ { \prime } \text { behaves similar to a local smoothing of } u \text {, but without blurring}
```
  FIX: ```
$$
\text{regression curve:} \quad P ( \mu _ { i } ^ { \prime } | y ) \quad \text {and} \quad \hat { \mu } _ { i } ^ { \prime } \, = \, \int P ( \mu _ { i } ^ { \prime } | y ) \mu _ { i } ^ { \prime } d \mu _ { i } ^ { \prime }
$$
```
- RAW: ```
\text {uniform boundary prior} \colon \ P ( t | k ) = ( \begin{matrix} n ^ { - 1 } \\ k ^ { - 1 } \end{matrix} ) ^ { - 1 } \\
```
  FIX: ```
$$
\text{uniform boundary prior} \colon \ P ( t | k ) = \binom { n - 1 } { k - 1 } ^ { - 1 }
$$
```
- RAW: ```
Gaussian noise \colon \ P ( y _ { i } | \mu _ { i } ^ { \prime } , \sigma _ { i } ^ { \prime } ) \, = \, \frac { 1 } { \sqrt { 2 \pi } \sigma _ { i } ^ { \prime } } \, e ^ { - \frac { ( y _ { i } - \mu _ { i } ^ { \prime } ) ^ { 2 } } { 2 \sigma _ { i } ^ { \prime } 2 } }
```
  FIX: ```
$$
\text{Gaussian noise} \colon \ P ( y _ { i } | \mu _ { i } ^ { \prime } , \sigma _ { i } ^ { \prime } ) \, = \, \frac { 1 } { \sqrt { 2 \pi } \sigma _ { i } ^ { \prime } } \, e ^ { - \frac { ( y _ { i } - \mu _ { i } ^ { \prime } ) ^ { 2 } } { 2 {\sigma _ { i } ^ { \prime }}^2 } }
$$
```
- RAW: ```
G a s i s { a n g u s i o r } \colon \ P ( \mu _ { q } | \nu , \rho ) \, = \, \frac { 1 } { \sqrt { 2 \pi } \rho } \, e ^ { - \frac { ( \mu _ { q } - \nu ) ^ { 2 } } { 2 \rho ^ { 2 } } }
```
  FIX: ```
$$
\text{Gaussian prior} \colon \ P ( \mu _ { q } | \nu , \rho ) \, = \, \frac { 1 } { \sqrt { 2 \pi } \rho } \, e ^ { - \frac { ( \mu _ { q } - \nu ) ^ { 2 } } { 2 \rho ^ { 2 } } }
$$
```
