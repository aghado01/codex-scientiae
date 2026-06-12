[Page 4]

Suppose k 1,...,k d << m, then Z ⊤ Z is of full rank. In terms of β,σ, we assume

$$
\beta | Z, \sigma \sim N _ { \nu } \left ( 0, m \sigma ^ { 2 } ( Z ^ { \top } Z ) ^ { - 1 } \right ), \, \pi ( \sigma ) = 1 / \sigma, \ \sigma > 0 .
$$

The prior of β is the so-called unit information prior. According to the linear regression theory, the least squares estimator of β is ˆ β = ( Z ⊤ Z ) − 1 Z ⊤ y.Then the precision matrix (inverse covariance) is given by ( Z ⊤ Z ) /σ 2.The unit precision matrix is defined as ( Z ⊤ Z ) /mσ 2, implying the prior of β in (4). The prior of σ is an improper prior as ∞ 0 1 /σdσ = ∞ .

According to the Bayesian formula, the posterior density of k,ξ,β,σ is

$$
p ( k, \xi, \beta, \sigma | y ) = p ( \beta, \sigma | k, \xi, y ) p ( k, \xi | y ),
$$

where p ( k,ξ | y ) ∝ p ( y | k,ξ ) π ( k,ξ ).Let a k,ξ = y ⊤ ( I m − m m +1 Z ( Z ⊤ Z ) − 1 Z ⊤ ) y .

Lemma 1. With the above priors of k,ξ,β,σ in (2), we have

$$
p ( y | k, \xi ) \in ( m + 1 ) ^ { - \nu / 2 } a _ { k, \xi } ^ { - m / 2 }, \, p ( k, \xi | y ) \subset ( m + 1 ) ^ { - \nu / 2 } a _ { k, \xi } ^ { - m / 2 } \tau ( \mathcal { M } _ { k } ) ^ { - \gamma } .
$$

The posterior p ( k,ξ | y ) consists of three main components. The first term ( m + 1) − ν/ 2 serves as the dimensional penalty. It balances the number of parameters and the bias of model fitting. The second term a − m/ 2 k,ξ represents the effect of the likelihood. When m is sufficiently large, a k,ξ is approximately equal to the residual sum of squares. The third term τ ( M k ) − γ corresponds to the priors of k,ξ.It takes the complexity of M k into consideration.

Subsequently, we can simulate samples of β,σ given k,ξ from the conditional posterior density in (5) via a Gibbs sampler, contributing to a fully Bayesian model.

The Gaussian prior of β is a conjugate prior in (2), yielding a closed expression of p ( y | k,ξ ).Generally, p ( y | k,ξ ) is analytically intractable except for the normal regression model. For those non-conjugate cases, we utilize the extended Bayesian information criterion (EBIC) of Chen and Chen [2008] to approximate the posterior density. In the spline knot estimation, the cardinality of all candidate knots ( i.e., n ) can be very large but the number of the true knots ( i.e., k ) is small compared to the sample size ( i.e., m ). Thus, EBIC will be extremely useful for model selection as the smallm -largen assumption holds and the Laplace approximation is valid [Foygel and Drton, 2010, Chen and Chen, 2012, Luo et al., 2015].

According to the definition, the EBIC of k,ξ is

$$
B I C _ { \gamma } ( k, \xi ) = - 2 \log L ( \hat { \beta }, \hat { \sigma } | y, k, \xi ) + ( \nu + 1 ) \log m + 2 \gamma \log \tau ( \mathcal { M } _ { k } ), \ \ 0 \leq \gamma \leq 1, \ \ ( 7 )
$$

where ˆ β, ˆ σ are the maximum likelihood estimators of β,σ given k,ξ.Especially in (2), ˆ β = ( Z ⊤ Z ) − 1 Z ⊤ y and ˆ σ 2 = y ⊤ ( I m − Z ( Z ⊤ Z ) − 1 Z ⊤ ) y/m.As γ = 0, (7) is the ordinary BIC. Since n 1,...,n d >> m, the EBIC with γ > 0 is preferable to the ordinary BIC in knot estimation. From the Laplace approximation, p ( k,ξ | y ) ≈ exp {− BIC γ ( k,ξ ) / 2 }, denoted by ˆ p ( k,ξ | y ) .

Lemma 2. In multivariate spline model (2), the EBIC approximation of the posterior density is

$$
\hat { p } ( k, \xi | y ) \, \infty \, m ^ { - ( \nu + 1 ) / 2 } ( \hat { \sigma } ^ { 2 } ) ^ { - m / 2 } \tau ( \mathcal { M } _ { k } ) ^ { - \gamma } .
$$

Suppose k ′,ξ ′ are another group of knots. Comparing (6) and (8), we can find p ( k,ξ | y ) /p ( k ′,ξ ′ | y ) ≈ ˆ p ( k,ξ | y ) / ˆ p ( k ′,ξ ′ | y ) when m is sufficiently large. Since the sampling procedure of MCMC is determined by the posterior density ratio, the EBIC contributes to a consistent estimation.

The reversible jump approach [Green, 1995] is an extension of the standard Metropolis-Hastings algorithm, allowing the trans-dimensional movement. These algorithms are widely used in the (Bayesian) model determination problems where the dimension of parameters is unknown [Bolton and Heard, 2018, Chapple et al., 2020].
