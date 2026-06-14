[Page 15]

Then we evidently have by Lemma 3.4

$$
\Sigma ^ { x } ( \{ z \colon J ^ { \prime } \in \mathfrak { C } _ { z , x } \} ) = \Sigma ^ { x } ( A ) \leq \frac { \Sigma ^ { x } ( A ) } { \Sigma ^ { x } ( B ) } .
$$

An elementary computation shows that

$$
\frac { \Sigma ^ { x } ( A ) } { \Sigma ^ { x } ( B ) } = \exp \left ( - \, 2 \beta \sum _ { \{ q , r \} \in \mathcal { J } ^ { \prime } } \xi ^ { q r } \right ) \frac { \sum _ { z } 1 _ { A } ( z ) \exp ( \beta \sum _ { \{ q , r \} \subseteq J ^ { \prime \prime } \colon | q - r | = 1 } \xi ^ { q r } x ^ { q } x ^ { r } z ^ { q } z ^ { r } ) } { \sum _ { z } 1 _ { B } ( z ) \exp ( \beta \sum _ { \{ q , r \} \subseteq J ^ { \prime \prime } \colon | q - r | = 1 } \xi ^ { q r } x ^ { q } x ^ { r } z ^ { q } z ^ { r } ) } .
$$

But the ratio in this expression is unity, as the exponential term inside the sums is invariant under the transformation z q  → − z q for all q ∈ J . The proof is complete.

Lemma 3.7 allows us to estimate

$$
\begin{aligned}
P \left [ \Sigma ^ { x } ( \{ z \colon z ^ { 0 } = - x ^ { 0 } \} ) \right ] & \geq \sum _ { J ^ { \prime } \ni 0 \text { simply connected} } e ^ { - \beta | \mathfrak { E } ^ { J ^ { \prime } } | } \\ & \leq P \left [ \sum _ { J ^ { \prime } \ni 0 \text { simp. conn.} } \exp \left ( - \, 2 \beta \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \right ) \geq \sum _ { J ^ { \prime } \ni 0 \text { simp. conn.} } e ^ { - \beta | \mathfrak { E } ^ { J ^ { \prime } } | } \right ] \\ & \leq P \left [ \exists J ^ { \prime } \ni 0 \text { simply connected with} \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \leq \frac { | \mathfrak { E } ^ { J ^ { \prime } } | } { 2 } \right ] \\ & \leq \sum _ { J ^ { \prime } \ni 0 \text { simply connected} } P \left [ \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \leq \frac { | \mathfrak { E } ^ { J ^ { \prime } } | } { 2 } \right ] .
\end{aligned}
$$

Using a standard combinatorial result [22, Lemma 6.13]

$$
| \{ J ^ { \prime } \subseteq J \text { simply connected } \colon 0 \in J ^ { \prime } , \ | \mathfrak { E } J ^ { \prime } | = l \} | \leq l 3 ^ { l - 1 } ,
$$

as well as the simple bound

$$
P \left [ \sum _ { \{ q , r \} \in \mathcal { E } J ^ { \prime } } \xi ^ { q r } \leq \frac { | \mathfrak { E } J ^ { \prime } | } { 2 } \right ] = P \left [ \text {Bin} ( | \mathfrak { E } J ^ { \prime } | , 1 - p ) \leq \frac { 3 } { 4 } \, | \mathfrak { E } J ^ { \prime } | \right ] \leq 2 ^ { | \mathfrak { E } J ^ { \prime } | } p ^ { | \mathfrak { E } J ^ { \prime } | / 4 } ,
$$

we can conclude that

$$
\mathbf P \left [ \Sigma ^ { x } ( \{ z \colon z ^ { 0 } = - x ^ { 0 } \} ) \right ] \geq c _ { 1 } \right ] \leq c _ { 2 } , \ \ c _ { 1 } = \sum _ { l = 3 } ^ { \infty } l ^ { l - 1 } \left ( \frac { p } { 1 - p } \right ) ^ { l / 2 } , \ \ c _ { 2 } = \sum _ { l = 3 } ^ { \infty } l ^ { l - 1 } 2 ^ { l } p ^ { l / 4 } .
$$

But we can now evidently choose p > 0 suﬃciently small such that c 1 ≤ 1 / 4 and c 2 ≤ 1 / 2 whenever p ≤ p , which readily yields the desired estimate.

## 3.3 Proof of Theorem 3.1: high noise

We now turn to proving that the ﬁlter is stable when the noise is strong. We begin by noting that it suﬃces to prove stability of ﬁnite-dimensional marginals of the ﬁlter.
