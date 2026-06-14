[Page 5]

Quantities of interest. Our ﬁrst quantities are the posterior of the number of segments and the MAP segment number

$$
\# \text { segments} \colon \ P ( k | y ) \ \text { and } \ \hat { k } \, = \, \arg \max _ { k } P ( k | y )
$$

Second, for each boundary t q its posterior and MAP, given the MAP estimate of k

$$
\text {boundaries} \colon \ P ( t _ { q } | y , \hat { k } ) \ \text { and } \ \hat { t } _ { q } \ = \ \arg \max _ { t _ { q } } P ( t _ { q } | y , \hat { k } )
$$

Diﬀerent estimates of t q (e.g. the mean or MAP based on the joint t posterior) will be discussed later. Finally we want the segment level means for the MAP segmentation

$$
\text{segment level:} \quad P ( \mu _ { q } | y , \hat { t } , \hat { k } ) \quad \text {and} \quad \hat { \mu } _ { q } \, = \, \int P ( \mu _ { q } | y , \hat { t } , \hat { k } ) \mu _ { q } d \mu _ { q }
$$

The estimate ( ˆ µ , ˆ t , ˆ k ) deﬁnes a (single) piecewise constant (PC) function ˆ f , which is our estimate of f . A (very) diﬀerent quantity is to Bayes-average over all piecewise constant functions and to ask for the mean at location i as an estimate for f i .

$$
\text{regression curve:} \quad P ( \mu _ { i } ^ { \prime } | y ) \quad \text {and} \quad \hat { \mu } _ { i } ^ { \prime } \, = \, \int P ( \mu _ { i } ^ { \prime } | y ) \mu _ { i } ^ { \prime } d \mu _ { i } ^ { \prime }
$$

We will see that µ ′ behaves similar to a local smoothing of y , but without blurring true jumps. Standard deviations of all estimates may also be reported.

## 4 Speciﬁc Models

We now complete the speciﬁcation of the data noise and prior.

Segment boundaries. We assume a uniform prior over all segmentations into k segments. Since there are ( n − 1 k − 1 ) ways of placing the k − 1 inner boundaries (ordered and without repetition) on (1 ,...,n − 1), we have n − 1

$$
\text{uniform boundary prior} \colon \ P ( t | k ) = \binom { n - 1 } { k - 1 } ^ { - 1 }
$$

This is the only (additional) essential assumption to be able to derive eﬃcient algorithms. We now discuss some (purely exemplary) choices for the data noise and priors on µ and k .

Gaussian model. The standard assumption on the noise is independent Gauss:

$$
\text{Gaussian noise} \colon \ P ( y _ { i } | \mu _ { i } ^ { \prime } , \sigma _ { i } ^ { \prime } ) \, = \, \frac { 1 } { \sqrt { 2 \pi } \sigma _ { i } ^ { \prime } } \, e ^ { - \frac { ( y _ { i } - \mu _ { i } ^ { \prime } ) ^ { 2 } } { 2 {\sigma _ { i } ^ { \prime }}^2 } }
$$

The corresponding standard “conjugate” prior on the means µ q for each segment q is also Gauss

$$
\text{Gaussian prior} \colon \ P ( \mu _ { q } | \nu , \rho ) \, = \, \frac { 1 } { \sqrt { 2 \pi } \rho } \, e ^ { - \frac { ( \mu _ { q } - \nu ) ^ { 2 } } { 2 \rho ^ { 2 } } }
$$
