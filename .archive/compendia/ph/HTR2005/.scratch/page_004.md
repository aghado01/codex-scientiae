[Page 4]

The estimation of the true underlying function f = ( f 1 ,...,f n ) is called regression. We assume or model f as piecewise constant. Consider k segments with segment boundaries 0= t 0 <t 1 <...<t k − 1 <t k = n , i.e. f is constant on { t q − 1 +1 ,..,t q } for each 0 <q ≤ k . If the noise within each segment is the same, we have

\[
\text {piecewise constant} \colon \ \mu _ { i } ^ { \prime } = \mu _ { q } \quad \text {and} \quad \sigma _ { i } ^ { \prime } = \sigma _ { q } \quad \text {for} \quad t _ { q - 1 } < i \leq t _ { q } \quad \forall q \tag{2}
\]

We ﬁrst consider the case in which the variances of all segments coincide, i.e. σ q = σ ∀ q . Our goal is to estimate the segment levels µ =( µ 1 ,...,µ k ), boundaries t =( t 0 ,...,t k ), and their number k . Bayesian regression proceeds in assuming a prior for these quantities of interest . We model the segment levels by a broad (e.g. Gaussian) distribution with mean ν and variance ρ 2 . For the segment boundaries we take some (e.g. uniform) distribution among all segmentations into k segments. Finally we take some prior (e.g. uniform) over the segment number k . So our prior P ( µ , t ,k ) is the product of

\[
\text{prior} \colon \quad P ( \mu _ { q } \mid \nu , \rho ) \, \forall q \quad \text {and} \quad P ( t \mid k ) \quad \text {and} \quad P ( k )
\]

We regard the global variance ρ 2 and mean ν of µ and the in-segment variance σ 2 as ﬁxed hyper-parameters, and notationally suppress them in the following. We will return to their determination in Section 7.

Evidence and posterior. Given the prior and likelihood we can compute the data evidence and posterior P ( y | µ , t ,k ) by Bayes’ rule:

\[
\text {evidence} \colon \ P ( y ) \, = \, \sum _ { k , t } \int P ( y \mid \mu , t , k ) P ( \mu , t , k ) \, d \mu
\]

\[
\text {posterior} \colon \ P ( \mu , t , k \mid y ) = \frac { P ( y \mid \mu , t , k ) P ( \mu , t , k ) } { P ( y ) }
\]

The posterior contains all information of interest, but is a complex object for practical use. So we need summaries like the maximum (MAP) or mean and variances. MAP over continuous parameters ( µ ) is problematic, since it is not reparametrization invariant. This is particularly dangerous if MAP is across diﬀerent dimensions ( k ), since then even a linear transformation ( µ ❀ α µ ) scales the posterior (density) exponentially in k (by α k ). This severely inﬂuences the maximum over k , i.e. the estimated number of segments. The mean of µ does not have this problem. On the other hand, the mean of t makes only sense for ﬁxed (e.g. MAP) k . The most natural solution is to proceed in stages similar to as the prior (3) has been formed.

## 3 Quantities of Interest

We now deﬁne estimators for all quantities of interest in stages as suggested in Section 2.
