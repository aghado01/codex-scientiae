[Page 21]

Lemma 36 Consider a random persistence diagram D distributed according to f satisfying assumptions ( A 1) ( A 3) . Take Q of Eq. (3.10) and Q ∗ of Eq. (3.11) to be the upper singleton probabilities for the kernel density K σ ( Z,D ) shown in Eq. (4.6) . Then, there exists C > 0 so that E f [ Q ( γ )] ≤ E f [ Q ∗ ( γ )] ≤ Cσ for any γ ∈ I ( j,N ) with j < N .

Proof Since every q ( k ) ∈ (0 , 1), we have that Q ( γ ) ≤ Q ∗ ( γ ); and furthermore, since γ ∈ I ( j,N ) are not onto when j < N , each product Q ∗ is bounded by one of the terms of the (1 − q ( k ) i ) type. By construction, these terms depend monotonically upon a feature’s persistence, and the maximum (over all indices j < N and functions γ ) is tied to the least persistent feature of D u i . 2

For a feature ( b,d ) of persistence p = d − b , we deﬁne q ( p ) :=   ∞ − p/ ( √ 2 σ ) 1 √ 2 π e − x / 2 dx in concordance with Eq. (4.3); or in terms of the error function Φ, q ( p ) = 1 2   1 + Φ   p 2 σ    . Deﬁne the minimal persistence as p min ( Z ) = sup { p : | ∆ p 0 ∩ Z | = ∅} which satisﬁes p min ( Z ) ≥ p if and only if | ∆ p 0 ∩ Z | = ∅ . In turn, we may bound Q ∗ ( γ ) ≤ (1 − q ( p min ( D )) independently of γ . By Lemma 34, there is C > 0 such that P f [ | ∆ σ 0 ∩ D |   = ∅ ] ≤ E f [ | ∆ σ 0 ∩ D | ] ≤ Cσ , which controls the distribution of the minimal persistence.

glyph[negationslash]

In particular, q ( p ) = 1 2 σ √ π e − p 2 / 4 σ 2 by the fundamental theorem of calculus. The control of Lemma 34 and the fact that p min ( Z ) ≥ 0 also allows us to use integration via the probability of sublevel sets. Take g ( p ) = 1 − q ( p ) so that lim p →∞ g ( p ) = 0. Speciﬁcally, since Q ∗ ( γ ) ≤ (1 − q ( p min ( D )), and using the fundamental theorem of calculus then Fubini’s theorem, we have:

$$
& \mathbb { E } ^ { f } [ Q ^ { * } ( \gamma ) ] \leq \int _ { W _ { 0 } d - 1 } g ( p _ { \min } ( Z ) ) f ( Z ) \delta Z = \int _ { W _ { 0 } d - 1 } \left ( \int _ { \infty } ^ { p _ { \min } ( Z ) } g ^ { \prime } ( p ) d p \right ) f ( Z ) \delta Z \\ & = \int _ { \infty } ^ { 0 } \left ( \int _ { \{ Z ; p _ { \min } ( Z ) < p \} } f ( Z ) \delta Z \right ) g ^ { \prime } ( p ) d p = \int _ { 0 } ^ { \infty } \left ( \mathbb { P } ^ { f } [ p _ { \min } < p ] \right ) q ^ { \prime } ( p ) d p .
$$

We now further bound the expectation in Eq. (4.11). Replacing terms with their deﬁnitions and using the bound control from Lemma 34 we obtain:

$$
\mathbb { E } ^ { f } \left [ Q ^ { * } ( \gamma ) \right ] & \leq \int _ { 0 } ^ { \infty } \mathbb { P } ^ { f } ( \Delta _ { 0 } ^ { p } \cap D \neq \emptyset ) \frac { 1 } { 2 \sigma \sqrt { \pi } } e ^ { - p ^ { 2 } / 4 \sigma ^ { 2 } } d p \\ & \leq \frac { C } { 2 \sigma \sqrt { \pi } } \int _ { 0 } ^ { \infty } p e ^ { - ( p / 2 \sigma ) ^ { 2 } } d p = \frac { C } { 2 \sigma \sqrt { \pi } } \left [ - 2 \sigma ^ { 2 } e ^ { - p ^ { 2 } / 4 \sigma ^ { 2 } } \right ] _ { p = 0 } ^ { \infty } = \frac { C } { \sqrt { \pi } } \sigma .
$$

glyph[negationslash]

Proof of Theorem 31. For convenience, we denote the upper cardinalities by N i = | D u i | and total cardinalities by M i = | D i | for the sample persistence diagrams. Denote the set of strictly increasing functions from { 1 ,...,j } into { 1 ,...,N i } by I ( j,N i ). Here we use ‘id’ to denote the identity map, where I ( N i ,N i ) = { id } . The proof is organized by splitting the kernel densities into several pieces and then controlling each piece separately.
