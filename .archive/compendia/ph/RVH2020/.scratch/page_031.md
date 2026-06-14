[Page 31]

Proof. Let us prove the ﬁrst statement (the second statement follows readily in the same manner). It evidently suﬃces to prove the stronger identity

$$
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq \delta } , X _ { \leq - t } \} = \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} \mod { P } .
$$

To this end, it suﬃces to show that

$$
E [ Z | Y _ { \leq \delta } , X _ { \leq - t } ] \stackrel { \delta \downarrow 0 } { \longrightarrow } E [ Z | Y _ { \leq 0 } , X _ { \leq - t } ] \quad \text {in } L ^ { 2 }
$$

for every bounded random variable Z . By a standard approximation argument, it suﬃces to consider Z of the form Z s = f ( X s + t 1 ,Y s + t 1 ,...,X s + t n ,Y s + t n ) for n ∈ N , t 1 ,...,t n ∈ R , and f bounded and local. Now note that by stationarity,

$$
E [ E [ Z _ { s } | Y _ { \leq \delta } , X _ { \leq - t } ] ^ { 2 } ] = E [ E [ Z _ { s - \delta } | Y _ { \leq 0 } , X _ { \leq - t - \delta } ] ^ { 2 } ] .
$$

As X is Feller, it is quasi-left continuous [42, p. 101], and therefore X t − δ → X t a.s. as δ ↓ 0. In particular, as f is local and Y is continuous by construction, we have Z s − δ → Z s a.s. as δ ↓ 0. On the other hand, as f is bounded, we obtain

$$
E [ E [ Z _ { s } | Y _ { \leq s } , X _ { \leq - t } ] ^ { 2 } ] \stackrel { \delta \downarrow 0 } { \longrightarrow } E [ E [ Z _ { s } | Y _ { \leq 0 } , X _ { < - t } ] ^ { 2 } ] = E [ E [ Z _ { s } | Y _ { \leq 0 } , X _ { \leq - t } ] ^ { 2 } ] ,
$$

using Hunt’s lemma [42, Corollary II.2.4], where the last equality follows again by quasi-left continuity. Thus E [ Z s | Y ≤ δ ,X ≤− t ] → E [ Z s | Y ≤ 0 ,X ≤− t ] in L 2 , completing the proof.

By virtue of Lemma 4.15, to complete the proof of Theorem 4.12, it suﬃces to show

$$
P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \cap _ { t } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} ] = \\ P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } ]
$$

for every set A , m ≥ 1, and δ > 0: indeed, letting δ ↓ 0 the yields the expression before the statement of Lemma 4.15. We will deduce this fact from Proposition 4.14. To this end we require a lemma that replaces the analogous argument in Proposition 4.4.

Lemma 4.16. Let f : R m +1 → R be a bounded continuous function. Then there exists a sequence of bounded continuous functions g n : R m +1 → R such that

$$
| \mathbf E [ g _ { n } ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | \stackrel { n \to \infty } { \longrightarrow } 0 \ \ i n \ L ^ { 1 } .
$$

Proof. By the deﬁnition of the observations,

$$
E [ g ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] = ( g * \xi _ { n } ) ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } \, d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } \, d s ) ,
$$

where ξ n denotes the centered Gaussian measure on R m +1 with covariance n Id and ∗ denotes convolution. Note the trivial estimate |   t 0 X v s ds | ≤ t , so the argument of the function g ∗ ξ n above takes values in the compact set C = [ − 1 , 1] m +1 .

We now recall that as C is compact, every continuous function on C is contained in the closure of { ( g ∗ ξ n ) | C : g ∈ C b ( R m +1 ) } with respect to the uniform convergence topology on C (here C b ( R n +1 ) is the family of bounded continuous functions on R n +1 ). This follows
