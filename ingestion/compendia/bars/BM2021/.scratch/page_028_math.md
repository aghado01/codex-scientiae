[Page 28]

Hence,   from   the   assumption   that,   for   any   δ > 0,   inf t ∈ A δ L ( a,   b,   g 1,   ...,   g p,   σ )   > L ( μ,   β,   η 1,   ...,   η p,   σ ) and   the   fact   that   L (   θ,   σ )   a.s.−→ L ( θ,   σ ),   we   immediately   obtain   that   π (   θ,   θ )   a.s.−→ 0.   We   now   can   proceed   with   the   proof   of   Theorem 3.2 .

Proof   of   Theorem 3.2.It   is   enough   to   show   that   ( A.7 ) holds.   Recall   that

$$
\mathcal { A } _ { 5 } = \left \{ t = ( a, b ^ { T }, g _ { 1 }, \dots, g _ { p } ) ^ { T } \colon a \in \mathbb { R }, b \in \mathbb { R } ^ { q }, g _ { j } \in \mathcal { G } \cap \mathcal { H } _ { r j }, | a - \mu | + \| b - \beta \| + \sum _ { j = 1 } ^ { p } \| g _ { j } - \eta _ { j } \| _ { \mathcal { H } _ { 1 } } \leq M, \pi ( \theta, t ) \geq \delta \right \}, \\ \intertext { w h o r $ \theta = ( \mu, \ell ^ { T }, \eta _ { 1 } ) ^ { T } \ A c s i n l o m m a 4 5 o l t, t = ( a, b ^ { T }, g _ { 1 }, \dots, g _ { p } ) ^ { T } \subset A, b \supseteq \mathcal { H } _ { T } ( \mu, t ) \inf _ { \mu \in ( T, \sigma ) } \mu ( t, \sigma ) }
$$

where   θ = ( μ,   β t,   η 1,   ...,   η p ) t.  As   in   Lemma A.5,   let   t k = ( a k,   b t k,   g 1, k,   ...,   g p, k ) t ∈ A δ be   such   that   L ( t k,   σ )   → inf t ∈ A δ L ( t,   σ ) and   denote   ν k = | a k − μ |   +  b k − β     +   p j = 1   g j, k − η j   H 1.  Using   that   t k ∈ A δ,   we   get   that   the   sequences   { g j, k − η j } k ≥ 1 and   their   ﬁrst   derivatives   are   uniformly   bounded.   Hence,   the   compactness   of   { ( a,   b )   ∈ R   × R q : | a   − μ |   +   b   − β     ≤ M } and   the   Arzela-Ascoli   Theorem   imply   that   there   exists   a   subsequence   k   such   that   d   = a k   − μ   → d,   e   = b k   − β → e for   some   d   ∈ R and   e   ∈ R q,   while   f j,  = g j, k   − η j,   for   1   ≤ j   ≤ p,   converge   uniformly   to   some   continuous   functions   f 1,   ...,   f p,   respectively.   Denote     a = d   + μ,     b = e   + β,     g j = f j + η j,   1   ≤ j   ≤ p,   the   uniform   limit   of   a k  ,   b k   and   g j, k  ,   1   ≤ j   ≤ p,   respectively.   Denote     t = (   a,     b t,     g 1,   ...,     g p ) t and     t k   = (   a k  ,     b t k  ,     g 1, k  ,   ...,     g p, k   ) t.  Then,   we   have   that   π (   t,     t k   )   = | a k   −   a |   +   b k   −   b     +   p j = 1   g j, k   −   g j   ∞ → 0.   The   fact   that   ρ 1 is   a   bounded   continuous   function   and   the   Bounded   Convergence   Theorem   imply   that   L (   t k  ,   σ )   → L (   t,   σ ) which   leads   to   inf t ∈ A δ L ( t,   σ )   = L (   t,   σ ).  Furthermore,   π (   t,   θ )   ≥ δ since   π (   t k, ,   θ )   ≥ δ,   π (   t,     t k   )   → 0 and   π (   t,   θ )   ≥ π (   t k, ,   θ )   − π (   t,     t k   ),   hence   from   Lemma A.1 we   get   that   L (   t,   σ )   > L ( θ,   σ ) concluding   the   proof.   A.2.   Proof   of   Theorem 4.1

Throughout   this   section,   we   denote   ρ = ρ 1 and   ψ = ψ 1 = ρ   1.  As   in   the   proof   of   Proposition A.6,   P n stands   for   the   empirical   probability   measure   of   the   observations   ( Y i,   Z t i,   X t i ) t and   P for   the   underlying   probability   measure.   Furthermore,   for   any   t   = ( a,   b t,   g 1,   ...,   g p ) t ∈ R q + 1 × G × ··· × G let   us   consider   the   function   V t, ς deﬁned   as t p

$$
v _ { t, s } ( y, z, x ) = \rho \left ( \frac { y - a - b ^ { \top } z - \sum _ { j = 1 } ^ { p } g _ { j } ( x _ { j } ) } { s } \right ) .
$$

Then,   L n ( a,   b,   g 1,   ...,   g p,   ς )   = P n V t, ς and   L ( a,   b,   g 1,   ...,   g p,   ς )   = P V t, ς.Moreover,   denote   as   V ( μ ) t, ς and   V ( 0 ) t, ς = ( V ( 0 ) 1, t, ς,   ...,   V ( 0 ) q, t, ς ) t the   functions p

$$
M o r e v e r, \, \text {denote as } V _ { \mathfrak { t }, \mathfrak { s } } ^ { ( \mu ) } \text { and } V _ { \mathfrak { t }, \mathfrak { s } } ^ { ( \mu ) } = & ( V _ { 1, \mathfrak { t }, \mathfrak { s } } ^ { ( 0 ) }, \dots, V _ { q, \mathfrak { t }, \mathfrak { s } } ^ { ( 0 ) } ) ^ { \dagger } \, \text { the functions} \\ V _ { \mathfrak { t }, \mathfrak { s } } ^ { ( \mu ) } ( y, z, \mathfrak { x } ) = & - \frac { 1 } { \varsigma } \psi \left ( \frac { y - a - \mathfrak { b } ^ { \mathfrak { t } } z - \sum _ { j = 1 } ^ { p } g _ { j } ( x _ { j } ) } { \varsigma } \right ), \\ \ V _ { \mathfrak { t }, \varsigma } ^ { ( 0 ) } ( y, z, \mathfrak { x } ) = & - \frac { 1 } { \varsigma } \psi \left ( \frac { y - a - \mathfrak { b } ^ { \mathfrak { t } } z - \sum _ { j = 1 } ^ { p } g _ { j } ( x _ { j } ) } { \varsigma } \right ) z.\\ \ N o t e _ { \ } t a t _ { \ } V ^ { ( \mu ) } ( y, z, \mathfrak { x } ) \, _ { \, a r o r e \, _ { \, t h a r t i o n \, _ { \, d o r i v a t i v e \, _ { \, o f \, V } } } }
$$

Note   that   V ( μ ) t, ς and   V ( 0 ) t, ς are   the   partial   derivative   of   V t, ς with   respect   to   a and   b,   respectively.   Therefore,   using   that   L n (   μ,     β,     η 1,   ...,     η p,     σ )   ≤ L n ( a,   b,     η 1,   ...,     η p,     σ ) for   any   ( a,   b t ) t ∈ R q + 1 we   obtain   that P n V ( μ )   θ,   σ = 0 and P n V ( 0 )   θ,   σ = 0.(A.11)

Besides,   using   that   E ψ( a   ε )   = 0 for   any   a   > 0 and   the   independence   between   the   errors   and   covariates,   we   get   that   for   any   ς > 0

$$
P V _ { \theta, S } ^ { ( \mu ) } = 0 \text { and } \ P V _ { \theta, S } ^ { ( 0 ) } = 0 .
$$

Similarly,   if   G 0 stands   for   the   class   of   measurable   functions   over   [ 0,   1 ],   we   consider   the   operator   V ( j ) t, ς deﬁned   as

$$
5 \text { mainly, } 1 \, 9 0 \, \text {same} \, 1 \, 8 \, \text { also} \, 1 \, 7 \, \text { same} \, 5 \, \text { over} \, [ 0, 1 ], \, \text { we consider the operator } \, V _ { \zeta } \, \text { different} \, [ 0, 1 ] \,, \\ V _ { \zeta, S } ^ { ( j ) } [ y ] ( y, z, x ) = - \, \frac { 1 } { \varsigma } \psi \left ( \frac { y - a - b ^ { \intercal } z - \sum _ { \ell = 1 } ^ { p } g _ { \ell } ( x _ { \ell } ) } { \varsigma } \right ) h ( x _ { j } ) \quad \text {for any } h \in \mathcal { G } _ { 0 } \, .
$$

As   above,   V ( j ) t, ς [ h ] is   the   directional   derivative   of   V t, ς,   that   is,

$$
\text {As above, } v _ { \mathfrak { t }, s } ^ { ( j ) } [ h ] \text { is the directional derivative of } v _ { \mathfrak { t }, s }, \text { that is,} \\ V _ { \mathfrak { t }, s } ^ { ( j ) } [ h ] = \frac { \partial V _ { a, \mathfrak { b }, g _ { 1 }, \dots, g _ { j - 1 }, g _ { j } + s h, g _ { j + 1 }, \dots, g _ { p } } { \partial s } \Big | _ { s = 0 } \\
$$
