[Page 12]

This overestimates the variance ρ 2 of the segment levels, since the expression also includes the in-segment variance σ 2 , which one may want to subtract from this expression.

Estimate of in-segment variance σ 2 . At ﬁrst there seems little hope of estimating the in-segment variance σ 2 from y without knowing the segmentation, but actually we can use a simple trick. If y would belong to a single segment, i.e. the y t were i.i.d. with variance σ 2 , then the following expressions for σ 2 would hold:

$$
\[
E \left[ \frac { 1 } { n } \sum _ { t = 1 } ^ { n } ( y _ { t } - \mu _ { 1 } ) ^ { 2 } \right] = \sigma ^ { 2 } = \frac { 1 } { 2 ( n - 1 ) } E \left[ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \right]
\]
$$

i.e. instead of estimating σ 2 by the squared deviation of the y t from their mean, we can also estimate σ 2 from the average squared diﬀerence of successive y t . This remains true even for multiple segments if we exclude the segment boundaries in the sum. On the other hand, if the number of segment boundaries is small, the error from including the boundaries will be small, i.e. the second expression remains approximately valid. More precisely, we have within a segment and at the boundaries

$$
\[
E \sum _ { t = t _ { m - 1 } + 1 } ^ { t _ { m } - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } = 2 ( t _ { m } - t _ { m - 1 } - 1 ) \sigma ^ { 2 } \quad \text{and} \quad E ( y _ { t _ { m } + 1 } - y _ { t _ { m } } ) ^ { 2 } = 2 \sigma ^ { 2 } + ( \mu _ { m + 1 } - \mu _ { m } ) ^ { 2 }
\]
$$

Summing over all k segments and boundaries and solving w.r.t. σ 2 we get

$$
\[
\begin{aligned}
\sigma ^ { 2 } &= \frac { 1 } { 2 ( n - 1 ) } \left \{ E \left [ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \right ] - \sum _ { m = 1 } ^ { k - 1 } ( \mu _ { m + 1 } - \mu _ { m } ) ^ { 2 } \right \} \\
&= \frac { 1 } { 2 ( n - 1 ) } E \left [ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \right ] \cdot \left [ 1 - O \left ( \frac { k } { n } \frac { \rho ^ { 2 } } { \sigma ^ { 2 } } \right ) \right ]
\end{aligned}
\]
$$

The last expression holds, since there are k boundaries in n data items, and the ratio between the variance of µ to the in-segment variance is ρ 2 /σ 2 . Hence we may estimate σ 2 by the upper bound

$$
\[
\hat { \sigma } ^ { 2 } \approx \frac { 1 } { 2 ( n - 1 ) } \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 }
\]
$$

If there are not too many segments ( k ≪ n ) and the regression problem is hard (high noise ρ < ∼ σ ), this is a very good estimate. In case of low noise ( ρ ≫ σ ), regression is very easy, and a crude estimate of σ 2 is suﬃcient. If there are many segments, ˆ σ 2 tends to overestimate σ 2 , resulting in a (marginal) bias towards estimating fewer segments (which is then often welcome).

If the estimate is really not suﬃcient, one may use (29) as an initial estimate for determining an initial segmentation ˆ t , which then can be used to compute an improved estimate of ˆ σ 2 , and possibly iterate.
