[Page 6]

Cauchy model. The standard problem with Gauss is that it does not handle outliers well. If we do not want to or cannot remove outliers by hand, we have to properly model them as a prior with heavier tails. This can be achieved by a mixture of Gaussians or by a Cauchy distribution:

$$
\text {Cauchy noise} \colon \ P ( y _ { i } | \mu _ { i } ^ { \prime } , \sigma _ { i } ^ { \prime } ) \, = \, \frac { 1 } { \pi } \frac { \sigma _ { i } ^ { \prime } } { \sigma _ { i } ^ { \prime 2 } + ( y _ { i } - \mu _ { i } ^ { \prime } ) ^ { 2 } }
$$

Note that \( \mu_i^\prime \) and \( \sigma_i^\prime \) determine the location and scale of Cauchy but are not its mean and variance (which do not exist). The prior on the levels \( \mu_q \) may as well be modeled as Cauchy:

$$
\text {Cauchy prior} \colon \ P ( \mu _ { q } | \nu , \rho ) \, = \, \frac { 1 } { \pi } \frac { \rho } { \rho ^ { 2 } + ( \mu _ { q } - \nu ) ^ { 2 } }
$$

Actually, the Gaussian noise model may well be combined with a non-Gaussian prior and vice versa if appropriate.

Number of segments. Finally, consider the number of segments \( k \), which is an integer between \( 1 \) and \( n \). Sure, if we have prior knowledge on the [minimal,maximal] number of segments \( [k_{\min}, k_{\max}] \) we could/should set \( P(k)=0 \) outside this interval. Otherwise, any non-extreme choice of \( P(k) \) has little inﬂuence on the ﬁnal results, since it gets swamped by the (implicit) strong (exponential) dependence on \( k \) of the likelihood. So we suggest a uniform prior

$$
P ( k ) \, = \, \frac { 1 } { k _ { \max } } \quad \text {for} \quad 1 \leq k \leq k _ { \max } \quad \text {and} \quad 0 \quad \text {otherwise}
$$

with \( k_{\max} = n \) as default (or \( k_{\max} < n \) discussed later).

## 5 Eﬃcient Solution

Notation. We now derive expressions for all quantities of interest, which need time \( O(k_{\max} n^2) \) and space \( O(n^2) \). Throughout this and the next section we use the following notation: \( k \) is the total number of segments, \( t \) some data index, \( q \) some segment index, \( 1 \leq i < h < j \leq n \) are data item indices of segment boundaries \( t_0 \leq t_l < t_p < t_m \leq t_k \), i.e. \( t_0 = 0 \), \( t_l = i \), \( t_p = h \), \( t_m = j \), \( t_k = n \). Further, \( y_{ij} = (y_{i+1}, \dots, y_j) \) is data with segment boundaries \( t_{lm} = (t_l, \dots, t_m) \) and segment levels \( \mu_{lm} = (\mu_{l+1}, \dots, \mu_m) \). In particular \( y_{0n} = y \), \( t_{0k} = t \), and \( \mu_{0k} = \mu \). All introduced matrices below (capital symbols with indices) will be important in our algorithm.

General recursion. For \( m = l + 1 \), \( y_{ij} \) is data from a single segment with mean \( \mu_m \) whose joint distribution (given segment boundaries and \( m = l + 1 \)) is

$$
\text {single segment} \colon \, P ( y _ { i j } , \mu _ { m } | t _ { m - 1 , m } , 1 ) \, = \, P ( \mu _ { m } ) \prod _ { t = i + 1 } ^ { j } P ( y _ { t } | \mu _ { m } )
$$
