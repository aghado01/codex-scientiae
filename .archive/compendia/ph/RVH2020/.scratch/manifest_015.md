# Manifest: Page 015

## REPAIR_MATH
- RAW: ```
\Sigma ^ { x } ( \{ z \colon J ^ { \prime } \in \mathfrak { C } _ { z , x } \} ) = \Sigma ^ { x } ( A ) \leq \frac { \Sigma ^ { x } ( A ) } { \Sigma ^ { x } ( B ) } .
```
  FIX: ```
$$
\Sigma ^ { x } ( \{ z \colon J ^ { \prime } \in \mathfrak { C } _ { z , x } \} ) = \Sigma ^ { x } ( A ) \leq \frac { \Sigma ^ { x } ( A ) } { \Sigma ^ { x } ( B ) } .
$$
```
- RAW: ```
\frac { \Sigma ^ { x } ( A ) } { \Sigma ^ { x } ( B ) } = \exp \left ( - \, 2 \beta \sum _ { \{ q , r \} \in \mathcal { J } ^ { \prime } } \xi ^ { q r } \right ) \frac { \sum _ { z } 1 _ { A } ( z ) \exp ( \beta \sum _ { \{ q , r \} \subseteq J ^ { \prime \prime } \colon | q - r | = 1 } \xi ^ { q r } x ^ { q } x ^ { r } z ^ { q } z ^ { r } ) } { \sum _ { z } 1 _ { B } ( z ) \exp ( \beta \sum _ { \{ q , r \} \subseteq J ^ { \prime \prime } \colon | q - r | = 1 } \xi ^ { q r } x ^ { q } x ^ { r } z ^ { q } z ^ { r } ) } .
```
  FIX: ```
$$
\frac { \Sigma ^ { x } ( A ) } { \Sigma ^ { x } ( B ) } = \exp \left ( - \, 2 \beta \sum _ { \{ q , r \} \in \mathcal { J } ^ { \prime } } \xi ^ { q r } \right ) \frac { \sum _ { z } 1 _ { A } ( z ) \exp ( \beta \sum _ { \{ q , r \} \subseteq J ^ { \prime \prime } \colon | q - r | = 1 } \xi ^ { q r } x ^ { q } x ^ { r } z ^ { q } z ^ { r } ) } { \sum _ { z } 1 _ { B } ( z ) \exp ( \beta \sum _ { \{ q , r \} \subseteq J ^ { \prime \prime } \colon | q - r | = 1 } \xi ^ { q r } x ^ { q } x ^ { r } z ^ { q } z ^ { r } ) } .
$$
```
- RAW: ```
\text {Lemma 3.7 allows us to estimate} \\ P \left [ \Sigma ^ { x } ( \{ z \colon z ^ { 0 } = - x ^ { 0 } \} ) \right ] & \geq \sum _ { J ^ { \prime } \ni 0 \text { simply connected} } e ^ { - \beta | \mathfrak { E } ^ { J ^ { \prime } } | } \\ & \leq P \left [ \sum _ { J ^ { \prime } \ni 0 \text { simp. conn.} } \exp \left ( - \, 2 \beta \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \right ) \geq \sum _ { J ^ { \prime } \ni 0 \text { simp. conn.} } e ^ { - \beta | \mathfrak { E } ^ { J ^ { \prime } } | } \right ] \\ & \leq P \left [ \exists J ^ { \prime } \ni 0 \text { simply connected with} \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \leq \frac { | \mathfrak { E } ^ { J ^ { \prime } } | } { 2 } \right ] \\ & \leq \sum _ { J ^ { \prime } \ni 0 \text { simply connected} } P \left [ \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \leq \frac { | \mathfrak { E } ^ { J ^ { \prime } } | } { 2 } \right ] . \\ \text {Using a standard combinatorial result} \, [ 22, Lemma 6.13]
```
  FIX: ```
$$
\begin{aligned}
P \left [ \Sigma ^ { x } ( \{ z \colon z ^ { 0 } = - x ^ { 0 } \} ) \right ] & \geq \sum _ { J ^ { \prime } \ni 0 \text { simply connected} } e ^ { - \beta | \mathfrak { E } ^ { J ^ { \prime } } | } \\ & \leq P \left [ \sum _ { J ^ { \prime } \ni 0 \text { simp. conn.} } \exp \left ( - \, 2 \beta \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \right ) \geq \sum _ { J ^ { \prime } \ni 0 \text { simp. conn.} } e ^ { - \beta | \mathfrak { E } ^ { J ^ { \prime } } | } \right ] \\ & \leq P \left [ \exists J ^ { \prime } \ni 0 \text { simply connected with} \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \leq \frac { | \mathfrak { E } ^ { J ^ { \prime } } | } { 2 } \right ] \\ & \leq \sum _ { J ^ { \prime } \ni 0 \text { simply connected} } P \left [ \sum _ { \{ q , r \} \in \mathcal { E } ^ { J ^ { \prime } } } \xi ^ { q r } \leq \frac { | \mathfrak { E } ^ { J ^ { \prime } } | } { 2 } \right ] .
\end{aligned}
$$
```
- RAW: ```
| \{ J ^ { \prime } \subseteq J \text { simply connected } \colon 0 \in J ^ { \prime } , \ | \mathfrak { E } J ^ { \prime } | = l \} | \leq l 3 ^ { l - 1 } ,
```
  FIX: ```
$$
| \{ J ^ { \prime } \subseteq J \text { simply connected } \colon 0 \in J ^ { \prime } , \ | \mathfrak { E } J ^ { \prime } | = l \} | \leq l 3 ^ { l - 1 } ,
$$
```
- RAW: ```
P \left [ \sum _ { \{ q , r \} \in \mathcal { E } J ^ { \prime } } \xi ^ { q r } \leq \frac { | \mathfrak { E } J ^ { \prime } | } { 2 } \right ] = P \left [ \text {Bin} ( | \mathfrak { E } J ^ { \prime } | , 1 - p ) \leq \frac { 3 } { 4 } \, | \mathfrak { E } J ^ { \prime } | \right ] \leq 2 ^ { | \mathfrak { E } J ^ { \prime } | } p ^ { | \mathfrak { E } J ^ { \prime } | / 4 } ,
```
  FIX: ```
$$
P \left [ \sum _ { \{ q , r \} \in \mathcal { E } J ^ { \prime } } \xi ^ { q r } \leq \frac { | \mathfrak { E } J ^ { \prime } | } { 2 } \right ] = P \left [ \text {Bin} ( | \mathfrak { E } J ^ { \prime } | , 1 - p ) \leq \frac { 3 } { 4 } \, | \mathfrak { E } J ^ { \prime } | \right ] \leq 2 ^ { | \mathfrak { E } J ^ { \prime } | } p ^ { | \mathfrak { E } J ^ { \prime } | / 4 } ,
$$
```
- RAW: ```
\mathbf P \left [ \Sigma ^ { x } ( \{ z \colon z ^ { 0 } = - x ^ { 0 } \} ) \right ] \geq c _ { 1 } \right ] \leq c _ { 2 } , \ \ c _ { 1 } = \sum _ { l = 3 } ^ { \infty } l ^ { l - 1 } \left ( \frac { p } { 1 - p } \right ) ^ { l / 2 } , \ \ c _ { 2 } = \sum _ { l = 3 } ^ { \infty } l ^ { l - 1 } 2 ^ { l } p ^ { l / 4 } .
```
  FIX: ```
$$
\mathbf P \left [ \Sigma ^ { x } ( \{ z \colon z ^ { 0 } = - x ^ { 0 } \} ) \right ] \geq c _ { 1 } \right ] \leq c _ { 2 } , \ \ c _ { 1 } = \sum _ { l = 3 } ^ { \infty } l ^ { l - 1 } \left ( \frac { p } { 1 - p } \right ) ^ { l / 2 } , \ \ c _ { 2 } = \sum _ { l = 3 } ^ { \infty } l ^ { l - 1 } 2 ^ { l } p ^ { l / 4 } .
$$
```

## REPAIR_PROSE
- RAW: `z q  → − z q for all q ∈ J`
  FIX: `\( z^q \to -z^q \) for all \( q \in J \)`
- RAW: `p > 0 suﬃciently small such that c 1 ≤ 1 / 4 and c 2 ≤ 1 / 2 whenever p ≤ p`
  FIX: `\( p > 0 \) sufficiently small such that \( c_1 \leq 1/4 \) and \( c_2 \leq 1/2 \) whenever \( p \leq p \)`
- RAW: `proving that the ﬁlter is stable`
  FIX: `proving that the filter is stable`
- RAW: `it suﬃces to prove stability of ﬁnite-dimensional marginals of the ﬁlter.`
  FIX: `it suffices to prove stability of finite-dimensional marginals of the filter.`
