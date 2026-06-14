[Page 12]

## 6. Proofs

Our proofs will use the ideas from [18] and [20].

## 6.1. Upper Bound. We ﬁrst prove the earlier lemma.

Proof of Lemma 3.1. Let ( U , ( x i )) be any normal coordinate chart centered at x i , then the components of the metric at x i are g ij = δ ij , so   | g ij ( x i ) | = 1, see [22]. Consequently, vol ( B ( λ − 1 )) =     g (exp ( x )) dx =   g (exp ( t ))  

$$
\sqrt { | g _ { i j } ( x _ { i } ) | } & = 1 , \, \text {see } [ 2 2 ] . \text { Consequently} , \\ \text {vol} \left ( \overline { B } _ { x _ { i } } ( \lambda ^ { - 1 } ) \right ) & = \int _ { B ( \lambda ^ { - 1 } ) } \sqrt { | g _ { i j } ( \exp _ { x _ { i } } ( x ) ) | } d x = \sqrt { | g _ { i j } ( \exp _ { x _ { i } } ( t ) ) | } \int _ { B ( \lambda ^ { - 1 } ) } d x \\ & \sim \text {vol } ( \mathbb { B } ( \lambda ^ { - 1 } ) ) = \text {vol } ( \mathbb { B } ( 1 ) ) \lambda ^ { - d } = \text {vol } ( \mathbb { S } ^ { d - 1 } ) \lambda ^ { d } / d \, . \\ \text {The first line uses the integration transformation, where exp _ { x } } \colon B ( \lambda ^ { - 1 } ) \to \text { } \exp _ { x }
$$

The ﬁrst line uses the integration transformation, where exp x i : B ( λ − 1 ) → B x i ( λ − 1 ) is the exponential map from the tangent space T M x i → M . The second line uses the integral mean value theorem and r is the radius from the origin to point x in the Euclidean ball B ( λ − 1 ). The third line is asymptotic as λ → ∞ and uses the fact that | g ij (exp x i ( t )) | → 1 when λ → ∞ . In the fourth line vol ( B (1)) is the volume of d -dimensional Euclidean unit ball. The last line uses the fact vol ( B (1)) = vol ( B d − 1 ) /d .

Let λ ′ = λ ′ ( m ) > 0 be the smallest number such that B x i (( λ ′ ) − 1 ) are disjoint. Then λ − 1 = c ( m ) × ( λ ′ ) − 1 , where c ( m ) > 1 and c ( m ) → 1 as m → ∞ . Consequently m

$$
\ v o l \left ( \mathbb { M } \right ) & \geq \sum _ { i = 1 } ^ { m } \text {vol} \left ( \overline { B } _ { x _ { i } } ( ( \lambda ^ { \prime } ) ^ { - 1 } ) \right ) \sim m \text {vol} \left ( \mathbb { S } ^ { d - 1 } \right ) ( \lambda ^ { \prime } ) ^ { - d } / d . \\ \intertext { T L } \text {vol} \left ( \mathbb { M } \right ) & \geq \sum _ { i = 1 } ^ { m } \text {vol} \left ( \overline { B } _ { x _ { i } } ( ( \lambda ^ { \prime } ) ^ { - 1 } ) \right ) \sim m \text {vol} \left ( \mathbb { S } ^ { d - 1 } \right ) ( \lambda ^ { \prime } ) ^ { - d } / d . \\ \intertext { T L } \text {vol} \left ( \mathbb { M } \right ) & \cdot \text {vol} \left ( \overline { \mathcal { M } } \right ) \cdot \text {vol} \left ( \mathbb { M } \right ) .
$$

Thus limsup m →∞ mλ ( m ) − d = limsup m →∞ c ( m ) d m ( λ ′ ) − d ≤ d vol ( M ) vol ( S d − 1 ) .  

We now calculate the asymptotic variance of ˆ a j for j = 1 , . . ., m . Let

$$
M = \left [ \frac { n v o l ( \overline { B } _ { x _ { i _ { j } } } ( \kappa ^ { - 1 } ) ) } { v o l ( \mathbb { M } ) } \right ] .
$$
