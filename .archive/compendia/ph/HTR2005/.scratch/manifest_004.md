# Manifest: Page 004

## REPAIR_PROSE
- RAW: `The estimation of the true underlying function f = ( f 1 ,...,f n ) is called regression. We assume or model f as piecewise constant. Consider k segments with segment boundaries 0= t 0 <t 1 <...<t k − 1 <t k = n , i.e. f is constant on { t q − 1 +1 ,..,t q } for each 0 <q ≤ k . If the noise within each segment is the same, we have`
  FIX: `The estimation of the true underlying function \( f = ( f_1 , \dots , f_n ) \) is called regression. We assume or model \( f \) as piecewise constant. Consider \( k \) segments with segment boundaries \( 0 = t_0 < t_1 < \dots < t_{k-1} < t_k = n \), i.e. \( f \) is constant on \( \{ t_{q-1} + 1 , \dots , t_q \} \) for each \( 0 < q \leq k \). If the noise within each segment is the same, we have`
- RAW: `We ﬁrst consider the case in which the variances of all segments coincide, i.e. σ q = σ ∀ q . Our goal is to estimate the segment levels µ =( µ 1 ,...,µ k ), boundaries t =( t 0 ,...,t k ), and their number k . Bayesian regression proceeds in assuming a prior for these quantities of interest . We model the segment levels by a broad (e.g. Gaussian) distribution with mean ν and variance ρ 2 . For the segment boundaries we take some (e.g. uniform) distribution among all segmentations into k segments. Finally we take some prior (e.g. uniform) over the segment number k . So our prior P ( µ , t ,k ) is the product of`
  FIX: `We ﬁrst consider the case in which the variances of all segments coincide, i.e. \( \sigma_q = \sigma \ \forall q \). Our goal is to estimate the segment levels \( \mu = ( \mu_1 , \dots , \mu_k ) \), boundaries \( t = ( t_0 , \dots , t_k ) \), and their number \( k \). Bayesian regression proceeds in assuming a prior for these quantities of interest . We model the segment levels by a broad (e.g. Gaussian) distribution with mean \( \nu \) and variance \( \rho^2 \). For the segment boundaries we take some (e.g. uniform) distribution among all segmentations into \( k \) segments. Finally we take some prior (e.g. uniform) over the segment number \( k \). So our prior \( P ( \mu , t , k ) \) is the product of`
- RAW: `We regard the global variance ρ 2 and mean ν of µ and the in-segment variance σ 2 as ﬁxed hyper-parameters, and notationally suppress them in the following. We will return to their determination in Section 7.`
  FIX: `We regard the global variance \( \rho^2 \) and mean \( \nu \) of \( \mu \) and the in-segment variance \( \sigma^2 \) as ﬁxed hyper-parameters, and notationally suppress them in the following. We will return to their determination in Section 7.`
- RAW: `Evidence and posterior. Given the prior and likelihood we can compute the data evidence and posterior P ( y | µ , t ,k ) by Bayes’ rule:`
  FIX: `Evidence and posterior. Given the prior and likelihood we can compute the data evidence and posterior \( P ( y \mid \mu , t , k ) \) by Bayes’ rule:`
- RAW: `The posterior contains all information of interest, but is a complex object for practical use. So we need summaries like the maximum (MAP) or mean and variances. MAP over continuous parameters ( µ ) is problematic, since it is not reparametrization invariant. This is particularly dangerous if MAP is across diﬀerent dimensions ( k ), since then even a linear transformation ( µ ❀ α µ ) scales the posterior (density) exponentially in k (by α k ). This severely inﬂuences the maximum over k , i.e. the estimated number of segments. The mean of µ does not have this problem. On the other hand, the mean of t makes only sense for ﬁxed (e.g. MAP) k . The most natural solution is to proceed in stages similar to as the prior (3) has been formed.`
  FIX: `The posterior contains all information of interest, but is a complex object for practical use. So we need summaries like the maximum (MAP) or mean and variances. MAP over continuous parameters ( \( \mu \) ) is problematic, since it is not reparametrization invariant. This is particularly dangerous if MAP is across diﬀerent dimensions ( \( k \) ), since then even a linear transformation ( \( \mu \to \alpha \mu \) ) scales the posterior (density) exponentially in \( k \) (by \( \alpha^k \) ). This severely inﬂuences the maximum over \( k \), i.e. the estimated number of segments. The mean of \( \mu \) does not have this problem. On the other hand, the mean of \( t \) makes only sense for ﬁxed (e.g. MAP) \( k \). The most natural solution is to proceed in stages similar to as the prior (3) has been formed.`

## REPAIR_MATH
- RAW: ```
$$
\text {piecewise constant} \colon \ \mu _ { i } ^ { \prime } = \mu _ { q } \quad \text {and} \quad \sigma _ { i } ^ { \prime } = \sigma _ { q } \quad \text {for} \quad t _ { q - 1 } < i \leq t _ { q } \quad \forall q \quad ( 2 )
$$
```
  FIX: ```
\[
\text {piecewise constant} \colon \ \mu _ { i } ^ { \prime } = \mu _ { q } \quad \text {and} \quad \sigma _ { i } ^ { \prime } = \sigma _ { q } \quad \text {for} \quad t _ { q - 1 } < i \leq t _ { q } \quad \forall q \tag{2}
\]
```
- RAW: ```
$$
\ p r i o { \colon \quad P ( \mu _ { q } | \nu , \rho ) \, \forall q \quad \text {and} \quad P ( t | k ) \quad \text {and} \quad P ( k ) }
$$
```
  FIX: ```
\[
\text{prior} \colon \quad P ( \mu _ { q } \mid \nu , \rho ) \, \forall q \quad \text {and} \quad P ( t \mid k ) \quad \text {and} \quad P ( k )
\]
```
- RAW: ```
$$
( ) \, = \, \sum _ { k , t } \int P ( y | \mu , t , k ) P ( \mu , t , k ) \, d \mu \\
$$

$$
\text {evidence} \colon \ P ( y ) \, = \, \sum _ { k , t } \int P ( y | \mu , t , k ) P ( \mu , t , k ) \, d \mu
$$
```
  FIX: ```
\[
\text {evidence} \colon \ P ( y ) \, = \, \sum _ { k , t } \int P ( y \mid \mu , t , k ) P ( \mu , t , k ) \, d \mu
\]
```
- RAW: ```
$$
\text {posterior} \colon \ P ( \mu , t , k | y ) = \frac { P ( y | \mu , t , k ) P ( \mu , t , k ) } { P ( y ) }
$$
```
  FIX: ```
\[
\text {posterior} \colon \ P ( \mu , t , k \mid y ) = \frac { P ( y \mid \mu , t , k ) P ( \mu , t , k ) } { P ( y ) }
\]
```
