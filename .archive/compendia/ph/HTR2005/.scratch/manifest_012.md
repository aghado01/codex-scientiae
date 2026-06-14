# Manifest: Page 012

## REPAIR_MATH

- RAW: ```
E [ \frac { 1 } { n } \sum _ { t = 1 } ^ { n } ( y _ { t } - \mu _ { 1 } ) ^ { 2 } ] \, = \, \sigma ^ { 2 } \, = \, \frac { 1 } { 2 ( n - 1 ) } E [ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } ] \\ \intertext { i n s t o d \, o f \, o t i m a t i n g \, \sigma ^ { 2 } \, b y \, t h o \, s a u r o d \, d o v i d i o n \, o f \, t h o \, u \, f r o m \, t h o r \, m o r }
```
  FIX: ```
\[
E \left[ \frac { 1 } { n } \sum _ { t = 1 } ^ { n } ( y _ { t } - \mu _ { 1 } ) ^ { 2 } \right] = \sigma ^ { 2 } = \frac { 1 } { 2 ( n - 1 ) } E \left[ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \right]
\]
```

- RAW: ```
& E \sum _ { t = t _ { m - 1 } + 1 } ^ { t _ { m } - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } = 2 ( t _ { m } - t _ { m - 1 } - 1 ) \sigma ^ { 2 } \quad \text {and} \quad E ( y _ { t _ { m } + 1 } - y _ { t _ { m } } ) ^ { 2 } = 2 \sigma ^ { 2 } + ( \mu _ { m + 1 } - \mu _ { m } ) ^ { 2 } \\ & S _ { \sigma } \sim i \cdot y _ { t } - ( 1 - 1 ) \cdot y _ { t } = 1 - 1 \cdot i \cdot y _ { t } - 1 \cdot i \cdot y _ { t } = 2 \cdot \gamma _ { t }
```
  FIX: ```
\[
E \sum _ { t = t _ { m - 1 } + 1 } ^ { t _ { m } - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } = 2 ( t _ { m } - t _ { m - 1 } - 1 ) \sigma ^ { 2 } \quad \text{and} \quad E ( y _ { t _ { m } + 1 } - y _ { t _ { m } } ) ^ { 2 } = 2 \sigma ^ { 2 } + ( \mu _ { m + 1 } - \mu _ { m } ) ^ { 2 }
\]
```

- RAW: ```
\text {Summing over all $k$ segments and boundaries and solving $w.r.t.$ $\sigma^{2}$ we get} \\ \sigma ^ { 2 } \ = \ \frac { 1 } { 2 ( n - 1 ) } \left \{ E \left [ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \right ] - \sum _ { m = 1 } ^ { k - 1 } ( \mu _ { m + 1 } - \mu _ { m } ) ^ { 2 } \right \} \\ \ = \ \frac { 1 } { 2 ( n - 1 ) } E \left [ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \right ] \cdot \left [ 1 - O \left ( \frac { k } { n } \frac { \rho ^ { 2 } } { \sigma ^ { 2 } } \right ) \right ] \\ \text {The last expression holds, since there are $k$ boundaries in $n$ data items, and the}
```
  FIX: ```
\[
\begin{aligned}
\sigma ^ { 2 } &= \frac { 1 } { 2 ( n - 1 ) } \left \{ E \left [ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \right ] - \sum _ { m = 1 } ^ { k - 1 } ( \mu _ { m + 1 } - \mu _ { m } ) ^ { 2 } \right \} \\
&= \frac { 1 } { 2 ( n - 1 ) } E \left [ \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \right ] \cdot \left [ 1 - O \left ( \frac { k } { n } \frac { \rho ^ { 2 } } { \sigma ^ { 2 } } \right ) \right ]
\end{aligned}
\]
```

- RAW: ```
\hat { \sigma } ^ { 2 } \approx \frac { 1 } { 2 ( n - 1 ) } \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 } \\ \intertext { o n v e r s g e m m e s } \intertext { s o w n o r y s e c t h e r d e s } \intertext { i n t h e r d e s } \intertext { s o w n o r y s e c t h e r d e s }
```
  FIX: ```
\[
\hat { \sigma } ^ { 2 } \approx \frac { 1 } { 2 ( n - 1 ) } \sum _ { t = 1 } ^ { n - 1 } ( y _ { t + 1 } - y _ { t } ) ^ { 2 }
\]
```

## REPAIR_PROSE

- RAW: `This overestimates the variance ρ 2 of the segment levels, since the expression also includes the in-segment variance σ 2 , which one may want to subtract from this expression.`
  FIX: `This overestimates the variance \( \rho^{2} \) of the segment levels, since the expression also includes the in-segment variance \( \sigma^{2} \), which one may want to subtract from this expression.`

- RAW: `Estimate of in-segment variance σ 2 . At ﬁrst there seems little hope of estimating the in-segment variance σ 2 from y without knowing the segmentation, but actually we can use a simple trick. If y would belong to a single segment, i.e. the y t were i.i.d. with variance σ 2 , then the following expressions for σ 2 would hold:`
  FIX: `Estimate of in-segment variance \( \sigma^{2} \). At ﬁrst there seems little hope of estimating the in-segment variance \( \sigma^{2} \) from \( y \) without knowing the segmentation, but actually we can use a simple trick. If \( y \) would belong to a single segment, i.e. the \( y_t \) were i.i.d. with variance \( \sigma^{2} \), then the following expressions for \( \sigma^{2} \) would hold:`

- RAW: `i.e. instead of estimating σ 2 by the squared deviation of the y t from their mean, we can also estimate σ 2 from the average squared diﬀerence of successive y t . This remains true even for multiple segments if we exclude the segment boundaries in the sum. On the other hand, if the number of segment boundaries is small, the error from including the boundaries will be small, i.e. the second expression remains approximately valid. More precisely, we have within a segment and at the boundaries`
  FIX: `i.e. instead of estimating \( \sigma^{2} \) by the squared deviation of the \( y_t \) from their mean, we can also estimate \( \sigma^{2} \) from the average squared diﬀerence of successive \( y_t \). This remains true even for multiple segments if we exclude the segment boundaries in the sum. On the other hand, if the number of segment boundaries is small, the error from including the boundaries will be small, i.e. the second expression remains approximately valid. More precisely, we have within a segment and at the boundaries`

- RAW: `Summing over all k segments and boundaries and solving w.r.t. σ 2 we get`
  FIX: `Summing over all \( k \) segments and boundaries and solving w.r.t. \( \sigma^{2} \) we get`

- RAW: `The last expression holds, since there are k boundaries in n data items, and the ratio between the variance of µ to the in-segment variance is ρ 2 /σ 2 . Hence we may estimate σ 2 by the upper bound`
  FIX: `The last expression holds, since there are \( k \) boundaries in \( n \) data items, and the ratio between the variance of \( \mu \) to the in-segment variance is \( \rho^{2} / \sigma^{2} \). Hence we may estimate \( \sigma^{2} \) by the upper bound`

- RAW: `If there are not too many segments ( k ≪ n ) and the regression problem is hard (high noise ρ < ∼ σ ), this is a very good estimate. In case of low noise ( ρ ≫ σ ), regression is very easy, and a crude estimate of σ 2 is suﬃcient. If there are many segments, ˆ σ 2 tends to overestimate σ 2 , resulting in a (marginal) bias towards estimating fewer segments (which is then often welcome).`
  FIX: `If there are not too many segments \( (k \ll n) \) and the regression problem is hard (high noise \( \rho \lesssim \sigma \)), this is a very good estimate. In case of low noise (\( \rho \gg \sigma \)), regression is very easy, and a crude estimate of \( \sigma^{2} \) is suﬃcient. If there are many segments, \( \hat{\sigma}^{2} \) tends to overestimate \( \sigma^{2} \), resulting in a (marginal) bias towards estimating fewer segments (which is then often welcome).`

- RAW: `If the estimate is really not suﬃcient, one may use (29) as an initial estimate for determining an initial segmentation ˆ t , which then can be used to compute an improved estimate of ˆ σ 2 , and possibly iterate.`
  FIX: `If the estimate is really not suﬃcient, one may use (29) as an initial estimate for determining an initial segmentation \( \hat{t} \), which then can be used to compute an improved estimate of \( \hat{\sigma}^{2} \), and possibly iterate.`
