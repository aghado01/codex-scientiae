[Page 20]

One way of deriving the estimators uses Henderson’s justiﬁcation (Henderson, 1950). Maximizing the joint density (2.11) with respect to β and b, is equivalent to minimizing the criterion

$$
( y - T \theta ) ^ { \prime } R ^ { - 1 } ( y - T \theta ) + b ^ { \prime } G ^ { - 1 } b,
$$

which leads to the best linear unbiased predictor (BLUP) of θ = ( β  , b )  .Moreover, we can easily express (2.12) as follows:

$$
( y - T \theta ) ^ { \prime } R ^ { - 1 } ( y - T \theta ) + \theta ^ { \prime } H \theta, \quad H = \begin{bmatrix} 0 & 0 \\ 0 & G ^ { - 1 } \end{bmatrix} .
$$

By diﬀerentiating the the above expression and equating the derivative to zero, we can solve for θ and write its BLUP as

$$
\hat { \theta } = ( T ^ { \prime } R ^ { - 1 } T + H ) ^ { - 1 } T ^ { \prime } R ^ { - 1 } y .
$$

The ﬁtted values are therefore BLUP( y ) = X ˆ β + Z ˆ b = T ˆ θ .

Note that criterion (2.12) is similar to the penalized spline criterion (2.5). Dividing (2.5) by σ 2  , leads to spline criterion as

$$
& = \frac { 1 } { \sigma _ { \epsilon } ^ { 2 } } \| y - T \theta \| ^ { 2 } + \frac { \lambda } { \sigma _ { \epsilon } ^ { 2 } } b ^ { \prime } b \\ & = \frac { 1 } { \sigma _ { \epsilon } ^ { 2 } } ( y - T \theta ) ^ { \prime } ( y - T \theta ) + \frac { \lambda } { \sigma _ { \epsilon } ^ { 2 } } b ^ { \prime } b .
$$

Comparing (2.12) to (2.15), it becomes clear that for the P-splines, R = σ 2 I n and G = σ 2 λ I n ≡ σ 2 b I K κ with λ = σ 2 /σ 2 b.It is evident that the penalized spline criterion for a spline is exactly the BLUP criterion for a mixed model. Thus, P-splines can be written as mixed models with a smoothing parameter λ.In the next section we will see how to perform the estimation in a Bayesian setting.

In this section, a Bayesian approach to penalized splines is examined. The Bayesian philosophy in statistics is based on the practice of treating parameters as random variables. By
