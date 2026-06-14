# Manifest: Page 006

## REPAIR_PROSE
- RAW: ```
Note that µ ′ i and σ ′ i determine the location and scale of Cauchy but are not its mean and variance (which do not exist). The prior on the levels µ q may as well be modeled as Cauchy: 1 ρ
```
  FIX: ```
Note that \( \mu_i^\prime \) and \( \sigma_i^\prime \) determine the location and scale of Cauchy but are not its mean and variance (which do not exist). The prior on the levels \( \mu_q \) may as well be modeled as Cauchy:
```
- RAW: ```
Number of segments. Finally, consider the number of segments k , which is an integer between 1 and n . Sure, if we have prior knowledge on the [minimal,maximal] number of segments [ k min ,k max ] we could/should set P ( k )=0 outside this interval. Otherwise, any non-extreme choice of P ( k ) has little inﬂuence on the ﬁnal results, since it gets swamped by the (implicit) strong (exponential) dependence on k of the likelihood. So we suggest a uniform prior
```
  FIX: ```
Number of segments. Finally, consider the number of segments \( k \), which is an integer between \( 1 \) and \( n \). Sure, if we have prior knowledge on the [minimal,maximal] number of segments \( [k_{\min}, k_{\max}] \) we could/should set \( P(k)=0 \) outside this interval. Otherwise, any non-extreme choice of \( P(k) \) has little inﬂuence on the ﬁnal results, since it gets swamped by the (implicit) strong (exponential) dependence on \( k \) of the likelihood. So we suggest a uniform prior
```
- RAW: ```
with k max = n as default (or k max <n discussed later).
```
  FIX: ```
with \( k_{\max} = n \) as default (or \( k_{\max} < n \) discussed later).
```
- RAW: ```
Notation. We now derive expressions for all quantities of interest, which need time O ( k max n 2 ) and space O ( n 2 ). Throughout this and the next section we use the following notation: k is the total number of segments, t some data index, q some segment index, 1 ≤ i<h<j ≤ n are data item indices of segment boundaries t 0 ≤ t l <t p <t m ≤ t k , i.e. t 0 =0, t l = i , t p = h , t m = j , t k = n . Further, y ij =( y i +1 ,...,y j ) is data with segment boundaries t lm =( t l ,...,t m ) and segment levels µ lm =( µ l +1 ,...,µ m ). In particular y 0 n = y , t 0 k = t , and µ 0 k = µ . All introduced matrices below (capital symbols with indices) will be important in our algorithm.
```
  FIX: ```
Notation. We now derive expressions for all quantities of interest, which need time \( O(k_{\max} n^2) \) and space \( O(n^2) \). Throughout this and the next section we use the following notation: \( k \) is the total number of segments, \( t \) some data index, \( q \) some segment index, \( 1 \leq i < h < j \leq n \) are data item indices of segment boundaries \( t_0 \leq t_l < t_p < t_m \leq t_k \), i.e. \( t_0 = 0 \), \( t_l = i \), \( t_p = h \), \( t_m = j \), \( t_k = n \). Further, \( y_{ij} = (y_{i+1}, \dots, y_j) \) is data with segment boundaries \( t_{lm} = (t_l, \dots, t_m) \) and segment levels \( \mu_{lm} = (\mu_{l+1}, \dots, \mu_m) \). In particular \( y_{0n} = y \), \( t_{0k} = t \), and \( \mu_{0k} = \mu \). All introduced matrices below (capital symbols with indices) will be important in our algorithm.
```
- RAW: ```
General recursion. For m = l +1, y ij is data from a single segment with mean µ m whose joint distribution (given segment boundaries and m = l +1) is
```
  FIX: ```
General recursion. For \( m = l + 1 \), \( y_{ij} \) is data from a single segment with mean \( \mu_m \) whose joint distribution (given segment boundaries and \( m = l + 1 \)) is
```

## REPAIR_MATH
- RAW: ```
\text {Cauchy noise} \colon \ P ( y _ { i } | \mu _ { i } ^ { \prime } , \sigma _ { i } ^ { \prime } ) \, = \, \frac { 1 } { \pi } \frac { \sigma _ { i } ^ { \prime } } { \sigma _ { i } ^ { \prime 2 } + ( y _ { i } - \mu _ { i } ^ { \prime } ) ^ { 2 } } \\
```
  FIX: ```
$$
\text {Cauchy noise} \colon \ P ( y _ { i } | \mu _ { i } ^ { \prime } , \sigma _ { i } ^ { \prime } ) \, = \, \frac { 1 } { \pi } \frac { \sigma _ { i } ^ { \prime } } { \sigma _ { i } ^ { \prime 2 } + ( y _ { i } - \mu _ { i } ^ { \prime } ) ^ { 2 } }
$$
```
- RAW: ```
\text {cly} \colon & & \text {Cauchy prior} \colon \ P ( \mu _ { q } | \nu , \rho ) \, = \, \frac { 1 } { \pi } \frac { \rho } { \rho ^ { 2 } + ( \mu _ { q } - \nu ) ^ { 2 } } \\ \text {ly} \, \text {the Gaussian noise model may well be combined with a non-Gaussian prior}
```
  FIX: ```
$$
\text {Cauchy prior} \colon \ P ( \mu _ { q } | \nu , \rho ) \, = \, \frac { 1 } { \pi } \frac { \rho } { \rho ^ { 2 } + ( \mu _ { q } - \nu ) ^ { 2 } }
$$
```
- RAW: ```
P ( k ) \, = \, \frac { 1 } { k _ { \max } } \quad \text {for} \quad 1 \leq k \leq k _ { \max } \quad \text {and} \quad 0 \quad \text {otherwise}
```
  FIX: ```
$$
P ( k ) \, = \, \frac { 1 } { k _ { \max } } \quad \text {for} \quad 1 \leq k \leq k _ { \max } \quad \text {and} \quad 0 \quad \text {otherwise}
$$
```
- RAW: ```
\text {single segment} \colon \, P ( y _ { i j } , \mu _ { m } | t _ { m - 1 , m } , 1 ) \, = \, P ( \mu _ { m } ) \prod _ { t = i + 1 } ^ { j } P ( y _ { t } | \mu _ { m } )
```
  FIX: ```
$$
\text {single segment} \colon \, P ( y _ { i j } , \mu _ { m } | t _ { m - 1 , m } , 1 ) \, = \, P ( \mu _ { m } ) \prod _ { t = i + 1 } ^ { j } P ( y _ { t } | \mu _ { m } )
$$
```
