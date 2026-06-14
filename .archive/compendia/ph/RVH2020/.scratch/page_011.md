[Page 11]

Lemma 3.3. Suppose that \( 0 < p \le 1 / 2 \). Then

$$
E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] \xrightarrow { m \to \infty } E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] \ \ a . s .
$$

Proof. Let \( \beta := \log (1 - p) / p > 0 \). We begin by noting that

$$
P [ \hat { Y } _ { \ell } ^ { v } = y | X _ { 0 } , \dots , X _ { k } ] = \sqrt { p ( 1 - p ) } \, e ^ { \beta y X _ { \ell } ^ { v } X _ { \ell } ^ { v + 1 } }
$$

for \( 1 \le \ell \le k \) and \( y \in \{-1, 1\} \). Define the probability measure \( Q \) such that

$$
P ( A ) = E _ { Q } \left [ 1 _ { A } \prod _ { \ell = 1 } ^ { k } 4 p ( 1 - p ) \, e ^ { \beta \hat { Y } _ { \ell } ^ { m } X _ { \ell } ^ { m } X _ { \ell } ^ { m + 1 } } \, e ^ { \beta \hat { Y } _ { \ell } ^ { - m - 1 } X _ { \ell } ^ { - m - 1 } X _ { \ell } ^ { - m } } \right ] .
$$

Then under \( Q \), the observations \( \hat{Y}_\ell^m \) and \( \hat{Y}_\ell^{-m-1} \), \( 1 \le \ell \le k \) are symmetric Bernoulli and independent from all the remaining variables in the model, while the remainder of the model is the same as defined above. In particular, this implies that

$$
\{ X _ { 0 } ^ { v } , X _ { \ell } ^ { v } , Y _ { \ell } ^ { v } \colon 1 \leq \ell \leq k , | v | > m \} \perp \{ X _ { 0 } ^ { v } , X _ { \ell } ^ { v } , Y _ { \ell } ^ { v } \colon 1 \leq \ell \leq k , | v | \leq m \} \ \text { under } Q .
$$

We therefore obtain using the Bayes formula

$$
P [ A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] & = \\ \frac { E _ { Q } [ 1 _ { A } \frac { d P } { d Q } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] } { E _ { Q } [ \frac { d P } { d Q } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] } \\ & \geq e ^ { - 4 \beta k } \, Q [ A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] \\ & = e ^ { - 4 \beta k } \, Q [ A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ]
$$

for any \( A \in \sigma \{ X_0, Y_1, \dots, Y_k, X_1^v, \dots, X_k^v : |v| \le m \} \). Define \( Z^0 := ( X_1^0, \dots, X_k^0 ) \) and \( Z^{-m} := ( X_1^m, \dots, X_k^m, X_1^{-m}, \dots, X_k^{-m} ) \) for \( m \ge 1 \). Due to the conditional independence structure of the infinite-dimensional filtering model,

$$
E [ f ( Z ^ { - m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , Z ^ { - m - 1 } , Z ^ { - m - 2 } , \dots ] = E [ f ( Z ^ { - m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , Z ^ { - m - 1 } ]
$$

for every \( m \ge 0 \). Thus \( (Z^m)_{m \le 0} \) is a Markov chain under any regular version of the conditional distribution \( P [ \, \cdot \mid X_0, Y_1, \dots, Y_k ] \) (almost surely with respect to the realization of \( X_0, Y_1, \dots, Y_k \)). Moreover, the above estimate shows that the (random) transition kernels of this Markov chain satisfy the Doeblin condition [35, Theorem 16.2.4], so

$$
| E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] - E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] | \leq 2 ( 1 - e ^ { - 4 \beta k } ) ^ { m + 1 }
$$

for all \( m \ge 0 \). This completes the proof.

Lemma 3.3 reduces our problem to a finite-dimensional one. Indeed, it is clear that the filter is not stable for \( p = 0 \) (for precisely the same reason as in Example 2.1), so we will assume without loss of generality in the sequel that \( 0 < p \le 1 / 2 \). Applying Lemma 3.3, it follows that in order to prove that the filter is not stable, it suffices to show that

$$
\inf _ { k , m \geq 1 } E | E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } , \{ X _ { 1 } ^ { v } , \dots , X _ { k } ^ { v } \colon | v | > m \} ] | > 0 .
$$
