[Page 17]

and the regression ﬁt is ˆ y = T ˆ θ.However, the least-squares method will usually overﬁt the data, resulting in a rough estimate. To facilitate a smoother estimate, consider the minimization

$$
\min _ { \theta } \left \{ \| y - T \theta \| ^ { 2 } + \lambda b ^ { \prime } b \right \} .
$$

In (2.5), the roughness penalty term, λ b b, leads to shrinking b towards zero, thus resulting in a smoother ﬁt compared to the one based on (2.4). The smoothing parameter λ controls the amount of smoothing. The larger λ, the smoother the resulting ﬁt.

Mixed model methodology is used widely in applications such as longitudinal studies. In linear regression, one assumes that f ( x ) depends linearly on x, i.e., f ( x ) = β 0 + β 1 x.The unknown parameters β 0 and β 1 are commonly estimated via the method of least squares. In Section 2.3 we will see that penalized splines can be formulated as linear mixed models. In this section we give some background on LMMs.

Observations are collected into groups or clusters in the mixed model setting. If we take for example longitudinal data, observations are collected repeatedly over time for individual subjects. These groups of data for individual subjects are independent, but usually correlated within-subjects. Two sources of variation are thus present, within groups and between groups. Accounting for within-subject correlation is one challenge in longitudinal data analysis which can be tackled by mixed models.

Consider the following study on pig weights over a period of nine weeks (Ruppert et al., 2003). Figure 2.1 shows the measurements pertaining to 48 pigs. Lines are drawn, connecting the measurements that belong to the same pig. Denote the weight of the i th pig in the j th week by weight ij and let week j = j be the week in which the measurements for a pig are recorded. If we consider the data as cross-sectional (i.e., there is only a single time measurement for a given pig rather than repeated time measurements), then we can
