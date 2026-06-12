[Page 12]

Proof of Lemma 1. The marginal likelihood p ( y | k,ξ ) is given by

$$
p ( y | k, \xi ) = p ( y | Z ) = \int _ { ( 0, \infty ) } \int _ { \mathbb { R } ^ { \nu } } p ( y | Z, \beta, \sigma ) \pi ( \beta | Z, \sigma ) \pi ( \sigma ) d \beta d \sigma .
$$

According to the specified priors, we have

$$
p ( y | Z, \beta, \sigma ) & = \frac { 1 } { ( 2 \pi \sigma ^ { 2 } ) ^ { m / 2 } } \exp \{ - \frac { 1 } { 2 \sigma ^ { 2 } } ( y - Z \beta ) ^ { \top } ( y - Z \beta ) \}, \\ \pi ( \beta | Z, \sigma ) & = \frac { 1 } { ( 2 \pi m \sigma ^ { 2 } ) ^ { \nu / 2 } } | Z ^ { \top } Z | ^ { 1 / 2 } \exp \{ - \frac { 1 } { 2 m \sigma ^ { 2 } } \beta ^ { \top } Z ^ { \top } Z \beta \} .
$$

Then the Fubini Thm implies that,

$$
p ( y | k, \xi ) = \int _ { 0 } ^ { \infty } \frac { 1 } { ( 2 \pi \sigma ^ { 2 } ) ^ { m / 2 } ( m + 1 ) ^ { \nu / 2 } } \exp \{ - \frac { 1 } { 2 \sigma ^ { 2 } } a _ { k, \xi } \} \pi ( \sigma ) d \sigma,
$$

where a k,ξ = y ⊤ ( I m − m m +1 Z ( Z ⊤ Z ) − 1 Z ⊤ ) y.With change of variables w = σ/ √ a k,ξ, we have p ( y | k,ξ ) ∝ ( m + 1) − ν/ 2 a − m/ 2 k,ξ.It follows from π ( k,ξ ) ∝ τ ( M k ) − γ that p ( k,ξ | y ) ∝ ( m + 1) − ν/ 2 a − m/ 2 k,ξ τ ( M k ) − γ .

Proof of Lemma 3. According to (9),

$$
\alpha ( k ^ { \prime }, \xi ^ { \prime } | k, \xi ) = \min \left \{ 1, \, \frac { p ( k ^ { \prime }, \xi ^ { \prime } | y ) q ( k, \xi | k ^ { \prime }, \xi ^ { \prime } ) } { p ( k, \xi | y ) q ( k ^ { \prime }, \xi ^ { \prime } | k, \xi ) } \right \} .
$$

Notably, π ( k,ξ ) q ( k ′,ξ ′ | k,ξ ) = π ( k ′,ξ ′ ) q ( k,ξ | k ′,ξ ′ ) under the priors and proposals. Then we have α ( k ′,ξ ′ | k,ξ ) = min { 1, p ( y | k ′,ξ ′ ) /p ( y | k,ξ ) }.Thus (6) implies this lemma. For the EBIC approximation, we substitute ˆ p for the corresponding p .

We conduct EBARS in the curve spline regression ( d = 1,p = 3) and the surface spline regression ( d = 2,p = 3).The performance is compared with BARS of Dimatteo et al. [2001], smoothing splines (SS) of Green and Silverman [1994] and thin plate splines (TPS) of Wood [2003]. We calculate the predictive mean squared errors (MSE) for evaluation. Simulations show that the proposed method contributes to accurate predictions of all scenarios.

The curves and data samples involved are illustrated in the first column of Figure 5. It can be seen that data are generated from 4 different smoothness functions, denoted as Cases 1.1 − 1.4 respectively. Cases 1.1 and 1.2 are continuous, whereas Cases 1.3 and 1.4 are discontinuous with one or multiple breakpoints. The outcome noise is Gaussian with standard deviation 2, 2, 4, 1.We compare the prediction performance with BARS and SS in curve fitting. To demonstrate the effect of γ in EBIC, we implement 3 versions of EBARS with γ = 1, 0.5, 0.All methods are evaluated under sample sizes m = 200, 500 and the experiment is repeated 50 times in each setting.

The mean squared errors are summarized in Table 4. To remove the effect of outliers, we drop out points with errors in the top or bottom 2.5% to calculate censored MSE on test data. In EBARS, low γ causes the model overfitting problem. It is clear that MSE rises up gradually as γ decreases, especially in Case 1.3.The behaviour is visualized in columns 2 − 4 of Figure 5. This phenomenon is consistent with the theory. According to EBIC, the prior probability of the model space with k knots satisfies π ( M k ) ∝ τ ( M k ) 1 − γ.As k << n in practice, τ ( M k ) will grow with increasing number
