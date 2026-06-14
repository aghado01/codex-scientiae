[Page 25]

Proposition 38 Consider D distributed according to the kernel density K σ ( · , D ) with center diagram D and bandwidth σ . Fix δ ≥ 1 . Then,

$$
\mathbb { P } [ W _ { \infty } ( D , \mathcal { D } ) < \delta \sigma ] \geq \left ( \int _ { B ( 0 , \delta ) } \frac { 1 } { 2 \pi } e ^ { - ( x ^ { 2 } + y ^ { 2 } ) / 2 } \, d x \, d y \right ) ^ { M }
$$

where M is the maximal cardinality of D (a multiple of | D | ). Here B ( x,r ) refers to a ball with respect to the inﬁnity metric (as is used in bottleneck distance).

Next, we relax assumption ( A 2) by considering the entire multi-wedge W 0: − 1 and tighten the decay control from assumption ( A 3). Formally,

( A 2) ∗ The local density f N : W N 0: − 1 → R is bounded for each N ∈ { 1 ,...,M } .

$$
( A 3 ) ^ { * } \text { There exists } C > 0 \text { so that } f ( \xi _ { 1 } , \dots , \xi _ { N } ) \leq C \left \| ( \xi _ { 1 } , \dots , \xi _ { N } ) \right \| ^ { - 2 N - 2 } \text { for } N \in \{ 1 , \dots , M \} \, .
$$

These assumptions (and ( A 1)) are required for the subsequent lemma, which ensures that the mean absolute bottleneck deviation (MAD) is ﬁnite.

Lemma 39 Consider a random persistence diagram D distributed according to a global pdf f satisfying assumptions ( A 1) , ( A 2) ∗ , and ( A 3) ∗ . Then D has ﬁnite MAD for any choice of origin diagram D .

Similar to assumption ( A 3) (given prior to Theorem 31), ( A 3) ∗ holds for a random persistence diagram associated with underlying data sampled from a compact set perturbed by Gaussian noise. One may also replace Lemma 39 and its assumptions by directly assuming that the maximal persistence moment is bounded; with this, the results of Lemma 39 follow immediately from Eq. (A.3) in the supplementary. This direct assumption is weaker (implied by ( A 1), ( A 2) ∗ , and ( A 3) ∗ ), but may be diﬃcult to show directly in practice.

Theorem 40 Consider a distribution of persistence diagrams with bounded global pdf, f , satisfying assumptions ( A 1) , ( A 2) ∗ , and ( A 3) ∗ . Let ˆ f ( Z ) = 1 n n i =1 K σ ( Z, D i ) be a kernel density estimate with centers D i sampled i.i.d. according to global pdf f and bandwidth σ = O ( n − α ) chosen with 0 < α < α 2 M . Then, the mean absolute bottleneck deviation estimate converges; in other words,

$$
\int _ { \mathcal { W } _ { 0 \cdot d - 1 } } W _ { \infty } ( \mathcal { D } _ { 0 } , Z ) \hat { f } ( Z ) \delta Z \rightarrow \int _ { \mathcal { W } _ { 0 \cdot d - 1 } } W _ { \infty } ( \mathcal { D } _ { 0 } , Z ) f ( Z ) \delta Z
$$

as n → ∞ for any origin diagram D 0 .

Proof The MAD of f with origin D 0 is ﬁnite by Lemma 39. To show convergence of the estimate, we begin by adding and subtracting the integral of the sample estimator for the MAD. Then, we split the sum into n + 1 terms via the triangle inequality to obtain

$$
\text {split the sum into n + 1 terms via the triangle inequality to obtain} \\ \left | \int _ { W _ { 0 d - 1 } } W _ { \infty } ( \mathcal { D } _ { 0 } , Z ) f ( Z ) \delta Z - \int _ { W _ { 0 d - 1 } } W _ { \infty } ( \mathcal { D } _ { 0 } , Z ) \hat { f } ( Z ) \delta Z \right | \\ \leq \left | \int _ { W _ { 0 d - 1 } } W _ { \infty } ( \mathcal { D } _ { 0 } , Z ) f ( Z ) \delta Z - \frac { 1 } { n } \int _ { W _ { 0 d - 1 } } \int _ { W _ { 0 d - 1 } } W _ { \infty } ( \mathcal { D } _ { 0 } , \mathcal { D } _ { i } ) K _ { \sigma } ( Z , \mathcal { D } _ { i } ) \delta Z \right | \\ + \frac { 1 } { n } \sum _ { i = 1 } ^ { n } \left | \int _ { W _ { 0 d - 1 } } W _ { \infty } ( \mathcal { D } _ { 0 } , Z ) K _ { \sigma } ( Z , \mathcal { D } _ { i } ) \delta Z - \int _ { W _ { 0 d - 1 } } W _ { \infty } ( \mathcal { D } _ { 0 } , \mathcal { D } _ { i } ) K _ { \sigma } ( Z , \mathcal { D } _ { i } ) \delta Z \right | .
$$
