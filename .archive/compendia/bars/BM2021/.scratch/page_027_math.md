[Page 27]

Lemma   A.5.   Assume   that   ρ satisﬁes   C1   and   that   L ( μ,   β,   η 1,   ...,   η p,   σ )   = b ρ < 1.  Let   (   μ,     β,     η 1,   ...,     η p )   ∈ R   × R q × S 1 × ···× S p be   such   that   L (   μ,     β,     η 1,   ...,     η p,   σ )   a.s.−→ L ( μ,   β,   η 1,   ...,   η p,   σ ).  Assume   that   E   Z   2 < ∞ and   that   C3   and   C7   hold   with   c < 1   − b ρ.  Then,   there   exists   M such   that ⎧ p ⎫

$$
T h e r, & \text { there exists } M \text { such that } \\ & \mathbb { P } \left ( \bigcup _ { m \in N } \bigcap _ { n \geq m } \left \{ | \widehat { \mu } - \mu | + \| \widehat { \beta } - \beta \| + \sum _ { j = 1 } ^ { p } \| \widehat { \eta } _ { j } - \eta _ { j } \| \mathcal { H } _ { 1 } \leq M \right \} \right ) = 1 \,.\\ \intertext { \text { Proposition } A.6. \text { Let } ( Y _ { i }, Z _ { i } ^ { T }, X _ { i } ^ { T } ) ^ { T } \, b e \, i.i.d.\, o b s e r v a t i o n s \, s a t i s f y i n g \left ( 2 \right ) \, A s s u m e \, t a t \, C 1 \, t o \, C 5 \, h o l l
$$

Proposition   A.6.   Let   ( Y i,   Z t i,   X t i ) t be   i.i.d.   observations   satisfying   ( 2 ).  Assume   that   C1   to   C5   hold   and   that   for   any   M > 0 and   δ > 0,

Yi i i,

$$
\inf _ { t \in \mathcal { A } _ { 8 } } L ( t, \sigma ) > L ( \theta, \sigma ),
$$

where A δ ={ t = ( a, b t, g 1,..., gp ) t : a ∈ R, b ∈ R q, g j ∈ G ∩ H r j, | a -µ | +‖ b -β ‖ + ∑ p j = 1 ‖ g j -η j ‖ H 1 ≤ M, π( θ, t ) ≥ δ }.Then, if in addition E ‖ Z ‖ 2 < ∞, we have that π( ̂ θ, θ ) a.s.-→ 0 .

Note that Proposition A.6 gives a general consistency result under (A.7). In fact, Theorem 3.2 supplies sufficient conditions in order to ensure that (A.7) is satisfied.

Proof   of   Proposition A.6.Let   V a, b, g 1,..., g p, ς = ρ   ( y − a − b t z −   p j = 1 g j ( x j ))/ ς  .  As   above,   P denotes   the   probability   measure   of   ( Y,   Z t,   X t ) t and   P n its   corresponding   empirical   measure.   Then,   L n ( a,   b,   g 1,   ...,   g p,   ς )   = P n V a, b, g 1,..., g p, ς and   L ( a,   b,   g 1,   ...,   g p,   ς )   = P V a, b, g 1,..., g p, ς.Let   V be   a   neighborhood of   σ.  Assumption C5 entails   that,   except   for   a   null   set   N V,   there   exists   n 0 ∈ N,   such   that,   for

Let V be a neighborhood of σ.Assumption C5 entails that, except for a null set N V, there exists n 0 ∈ N, such that, for any n ≥ n 0, σ ∈ V .

̂ Lemma A.3 implies that

$$
A _ { n } = \sup _ { \substack { \varsigma > 0, a \in \mathbb { R }, b \in \mathbb { R } ^ { n } \\ g _ { 1 } \in S _ { 1 } \dots, g _ { P } \in S _ { P } } } | L _ { n } ( a, b, g _ { 1 }, \dots, g _ { P }, \varsigma ) - L ( a, b, g _ { 1 }, \dots, g _ { P }, \varsigma ) | \stackrel { a.s.} { \longrightarrow } 0.\\
$$

On   the   other   hand,   from   Lemma A.1 we   have

$$
L ( \mu, \beta, \eta _ { 1 }, \dots, \eta _ { p }, \sigma ) = \min _ { a \in \mathbb { R }, \mathfrak { b } \in \mathbb { R } ^ { q }, \, g _ { 1 } \in \mathcal { G }, \dots, g _ { p } \in \mathcal { G } } L ( a, \mathfrak { b }, g _ { 1 }, \dots, g _ { p }, \sigma ),
$$

so,   we   get   that

$$
0 \leq L ( \widehat { \theta }, \sigma ) - L ( \varphi, \sigma ) & = \sum _ { s = 1 } ^ { 3 } A _ { n, s } \,, \\ \intertext { w i t h \ A _ { n, 1 } = L ( \widehat { \theta }, \sigma ) - L _ { n } ( \widehat { \theta }, \sigma ) \ A _ { n, 2 } = L _ { n } ( \widehat { \theta }, \sigma ) - L ( \varphi, \sigma ) \, \text { and } \ A _ { n, 3 } = L ( \widehat { \theta }, \sigma ) - L ( \widehat { \theta }, \sigma ) \,.\, \text { Note that } | A _ { n, 1 } | \leq A _ { n }, \, \text { hence } A _ { n, 1 } = }
$$

with An, 1 = L ( ̂ θ, ̂ σ) -Ln ( ̂ θ, ̂ σ), An, 2 = Ln ( ̂ θ, ̂ σ) -L ( θ, σ) and An, 3 = L ( ̂ θ, σ) -L ( ̂ θ, ̂ σ).Note that | An, 1 | ≤ An, hence An, 1 = o a.s. ( 1 ).On the other hand, Lemma A.4 and C5 imply that An, 3 = o a.s. ( 1 ) .

It remains to see that An, 2 = o a.s. ( 1 ).As in the proof of Proposition 3.1, Corollary 6.21 in Schumaker (1981) entails that, for 1 ≤ j ≤ p, there exists a centered spline η j such that η j ∈ S j and ‖ η j -η j ‖∞ = O ( n -ν j r j ) .

Note   that   S n, 1 ≤ A n,   so   that   from   ( A.8 ) we   get   that   S n, 1 −→ 0.   On   the   other   hand,   if   we   write   S n, 2 =   s = 1 S n, 2 where   S ( 1 ) n, 2 = L ( θ n,     σ )   − L ( θ n,   σ ) and   S ( 2 ) n, 2 = L ( θ n,   σ )   − L ( θ,   σ ),   using   that   ρ is   a   bounded   continuous   function,   together   with   the   fact   that       η j − η j   ∞ → 0 for   all   j   = 1,   ...,   p and   the   dominated   convergence   theorem   we   have   that   S ( 2 ) n, 2 = o a.s. ( 1 ).  Besides,   from   Lemma A.4 and   the   strong   consistency   of     σ,   we   conclude   that   S ( 1 ) n, 2 = o a.s. ( 1 ) leading   to   S n, 2 = o a.s. ( 1 ).Using   that     θ minimizes   L n over   R   × R q × S 1 × ··· × S p,   we   obtain   that A n, 2 = L n (   θ,   σ ) − L ( θ, σ ) ≤ L n ( θ n,   σ ) − L ( θ, σ ) = S n, 1 + S n, 2.(A.10)

Hence, from ( A.9 ) and ( A.10 ) and using that A n, s = o a.s. ( 1 ) for s = 1, 3 and that S n, s = o a.s. ( 1 ) for s = 1, 2, we obtain that 0   ≤ L (   θ,   σ )   − L ( θ,   σ )   =   3 j = 1 A n, j ≤ A n, 1 + S n, 1 + S n, 2 + A n, 3 = o a.s. ( 1 ),   so   L (   θ,   σ )   a.s.−→ L ( θ,   σ ).  Note   that   Lemma A.5 implies   that   there   exists   M such   that p

$$
\text { that there exists } M \text { such that } \\ \mathbb { P } \left ( \bigcup _ { m \in N \geq m } \left \{ | \widehat { \mu } - \mu | + \| \widehat { \beta } - \beta \| + \sum _ { j = 1 } ^ { p } \| \widehat { \eta } _ { j } - \eta _ { j } \| \mathcal { H } _ { 1 } \leq M \right \} \right ) = 1 .
$$
