[Page 12]

This integral is complicated, and we approximate it using the Laplace method. This involves ﬁtting a scaled normal density to the integrand. Speciﬁcally, if we wish to evaluate ￿ h ( θ ) dθ, we assume that h ( θ ) ≈ h ( ˆ θ ) exp ( − ( θ − ¯ θ ) 2 2 σ 2 ), where ¯ θ is the mode of h ( θ ) and ˆ σ 2 is the estimate of the variance of the normal density. A good estimate of the mode, ˆ θ, can be obtained with a numerical search algorithm. The variance can be estimated by noting that h ( ˆ θ ) h ( ˆ θ + ￿ ) ≈ exp ( ￿ 2 2 σ 2 ). We evaluate h at ( ˆ θ + ￿ ) and ( ˆ θ − ￿ ) and average the two resulting estimates of σ 2 to get ˆ σ 2.The integral is then approximated by (2 π ) 1 2 (ˆ σ ) 1 2 h ( ˆ θ ). For additional information on the Laplace method and other methods for Bayes factor approximation, see DiCiccio et al. (1997).

Since the integral we want to approximate is deﬁned over ￿ + and the normal distribution is deﬁned over the entire real line, we will transform δ k ∗.Simulations show that this has the added beneﬁt of making the integrand more symmetric. Let ω = log ( δ k ∗ ) and note that the prior on ω k ∗ is:

$$
\pi ( \omega _ { k ^ { * } } ) = \frac { e x p ( a _ { \delta } \omega - b _ { \delta } [ e x p ( \omega ) ] ) b _ { \delta } ^ { a _ { \delta } } } { \Gamma ( a _ { \delta } ) }
$$

The integral in (7) can be written:

$$
p ( y | M ^ { * }, \delta, \lambda ) = \int p ( y, \omega | M ^ { * }, \delta, \lambda ) d \omega = \int _ { - \infty } ^ { \infty } p ( y | M ^ { * }, \delta, \omega, \lambda ) \pi ( \omega ) d \omega
$$

$$
& = \frac { C ( \lambda, k ^ { * } ) } { \Gamma ( a _ { \delta } ) } \prod _ { l = 1 } ^ { k } \delta _ { l } \int e x p ( \omega + a _ { \delta } \omega - b _ { \delta } [ e x p ( \omega ) ] | R ^ { * } | ^ { - \frac { 1 } { 2 } } ( b _ { \tau } + \frac { \alpha ^ { * } } { 2 } ) ^ { - ( \frac { n } { 2 } + a _ { \tau } ) } \prod _ { i = 1 } ^ { m } | U _ { i } ^ { * } | ^ { \frac { 1 } { 2 } } d \omega \\ & \quad \text {Similarly } \alpha _ { \delta } \text { is non-universal, proposal involves integers out the other moment of } \delta \text {, cor}
$$

Similarly, a basis removal proposal involves integrating out the element of δ corresponding to the basis proposed for removal. A proposal to alter a basis involves integrating out the element of δ corresponding to that basis in both the numerator and the denominator.
