# Manifest: Page 031

## REPAIR_MATH
- RAW: ```
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq \delta } , X _ { \leq - t } \} = \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} \mod { P } .
```
  FIX: ```
$$
\bigcap _ { \delta > 0 } \sigma \{ Y _ { \leq \delta } , X _ { \leq - t } \} = \sigma \{ Y _ { \leq 0 } , X _ { \leq - t } \} \mod { P } .
$$
```
- RAW: ```
E [ Z | Y _ { \leq \delta } , X _ { \leq - t } ] \stackrel { \delta \downarrow 0 } { \longrightarrow } E [ Z | Y _ { \leq 0 } , X _ { \leq - t } ] \quad \text {in } L ^ { 2 }
```
  FIX: ```
$$
E [ Z | Y _ { \leq \delta } , X _ { \leq - t } ] \stackrel { \delta \downarrow 0 } { \longrightarrow } E [ Z | Y _ { \leq 0 } , X _ { \leq - t } ] \quad \text {in } L ^ { 2 }
$$
```
- RAW: ```
E [ E [ Z _ { s } | Y _ { \leq \delta } , X _ { \leq - t } ] ^ { 2 } ] = E [ E [ Z _ { s - \delta } | Y _ { \leq 0 } , X _ { \leq - t - \delta } ] ^ { 2 } ] .
```
  FIX: ```
$$
E [ E [ Z _ { s } | Y _ { \leq \delta } , X _ { \leq - t } ] ^ { 2 } ] = E [ E [ Z _ { s - \delta } | Y _ { \leq 0 } , X _ { \leq - t - \delta } ] ^ { 2 } ] .
$$
```
- RAW: ```
E [ E [ Z _ { s } | Y _ { \leq s } , X _ { \leq - t } ] ^ { 2 } ] \stackrel { \delta \downarrow 0 } { \longrightarrow } E [ E [ Z _ { s } | Y _ { \leq 0 } , X _ { < - t } ] ^ { 2 } ] = E [ E [ Z _ { s } | Y _ { \leq 0 } , X _ { \leq - t } ] ^ { 2 } ] ,
```
  FIX: ```
$$
E [ E [ Z _ { s } | Y _ { \leq s } , X _ { \leq - t } ] ^ { 2 } ] \stackrel { \delta \downarrow 0 } { \longrightarrow } E [ E [ Z _ { s } | Y _ { \leq 0 } , X _ { < - t } ] ^ { 2 } ] = E [ E [ Z _ { s } | Y _ { \leq 0 } , X _ { \leq - t } ] ^ { 2 } ] ,
$$
```
- RAW: ```
P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \cap _ { t } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} ] = \\ P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } ]
```
  FIX: ```
$$
P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | \cap _ { t } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} ] = \\ P [ ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) \in A | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } ]
$$
```
- RAW: ```
| \mathbf E [ g _ { n } ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | \stackrel { n \to \infty } { \longrightarrow } 0 \ \ i n \ L ^ { 1 } .
```
  FIX: ```
$$
| \mathbf E [ g _ { n } ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | \stackrel { n \to \infty } { \longrightarrow } 0 \ \ i n \ L ^ { 1 } .
$$
```
- RAW: ```
E [ g ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] = ( g * \xi _ { n } ) ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } \, d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } \, d s ) ,
```
  FIX: ```
$$
E [ g ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] = ( g * \xi _ { n } ) ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } \, d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } \, d s ) ,
$$
```
- RAW: `for every bounded random variable Z . By a standard approximation argument, it suﬃces to consider Z of the form Z s = f ( X s + t 1 ,Y s + t 1 ,...,X s + t n ,Y s + t n ) for n ∈ N , t 1 ,...,t n ∈ R , and f bounded and local. Now note that by stationarity,`
  FIX: `for every bounded random variable \( Z \). By a standard approximation argument, it suﬃces to consider \( Z \) of the form \( Z _ { s } = f ( X _ { s + t _ { 1 } } , Y _ { s + t _ { 1 } } , \dots , X _ { s + t _ { n } } , Y _ { s + t _ { n } } ) \) for \( n \in \mathbb{N} \), \( t _ { 1 } , \dots , t _ { n } \in \mathbb{R} \), and \( f \) bounded and local. Now note that by stationarity,`
- RAW: `As X is Feller, it is quasi-left continuous [42, p. 101], and therefore X t − δ → X t a.s. as δ ↓ 0. In particular, as f is local and Y is continuous by construction, we have Z s − δ → Z s a.s. as δ ↓ 0. On the other hand, as f is bounded, we obtain`
  FIX: `As \( X \) is Feller, it is quasi-left continuous [42, p. 101], and therefore \( X _ { t - \delta } \to X _ { t } \) a.s. as \( \delta \downarrow 0 \). In particular, as \( f \) is local and \( Y \) is continuous by construction, we have \( Z _ { s - \delta } \to Z _ { s } \) a.s. as \( \delta \downarrow 0 \). On the other hand, as \( f \) is bounded, we obtain`
- RAW: `using Hunt’s lemma [42, Corollary II.2.4], where the last equality follows again by quasi-left continuity. Thus E [ Z s | Y ≤ δ ,X ≤− t ] → E [ Z s | Y ≤ 0 ,X ≤− t ] in L 2 , completing the proof.`
  FIX: `using Hunt’s lemma [42, Corollary II.2.4], where the last equality follows again by quasi-left continuity. Thus \( E [ Z _ { s } | Y _ { \leq \delta } , X _ { \leq - t } ] \to E [ Z _ { s } | Y _ { \leq 0 } , X _ { \leq - t } ] \) in \( L ^ { 2 } \), completing the proof.`
- RAW: `for every set A , m ≥ 1, and δ > 0: indeed, letting δ ↓ 0 the yields the expression before the statement of Lemma 4.15. We will deduce this fact from Proposition 4.14. To this end we require a lemma that replaces the analogous argument in Proposition 4.4.`
  FIX: `for every set \( A \), \( m \geq 1 \), and \( \delta > 0 \): indeed, letting \( \delta \downarrow 0 \) then yields the expression before the statement of Lemma 4.15. We will deduce this fact from Proposition 4.14. To this end we require a lemma that replaces the analogous argument in Proposition 4.4.`
- RAW: `Lemma 4.16. Let f : R m +1 → R be a bounded continuous function. Then there exists a sequence of bounded continuous functions g n : R m +1 → R such that`
  FIX: `Lemma 4.16. Let \( f : \mathbb{R} ^ { m + 1 } \to \mathbb{R} \) be a bounded continuous function. Then there exists a sequence of bounded continuous functions \( g _ { n } : \mathbb{R} ^ { m + 1 } \to \mathbb{R} \) such that`
- RAW: `where ξ n denotes the centered Gaussian measure on R m +1 with covariance n Id and ∗ denotes convolution. Note the trivial estimate |   t 0 X v s ds | ≤ t , so the argument of the function g ∗ ξ n above takes values in the compact set C = [ − 1 , 1] m +1 .`
  FIX: `where \( \xi _ { n } \) denotes the centered Gaussian measure on \( \mathbb{R} ^ { m + 1 } \) with covariance \( n \mathrm{Id} \) and \( * \) denotes convolution. Note the trivial estimate \( | \int _ { 0 } ^ { t } X _ { s } ^ { v } \, d s | \leq t \), so the argument of the function \( g * \xi _ { n } \) above takes values in the compact set \( C = [ - 1 , 1 ] ^ { m + 1 } \).`
- RAW: `We now recall that as C is compact, every continuous function on C is contained in the closure of { ( g ∗ ξ n ) | C : g ∈ C b ( R m +1 ) } with respect to the uniform convergence topology on C (here C b ( R n +1 ) is the family of bounded continuous functions on R n +1 ). This follows`
  FIX: `We now recall that as \( C \) is compact, every continuous function on \( C \) is contained in the closure of \( \{ ( g * \xi _ { n } ) | _ { C } : g \in C _ { b } ( \mathbb{R} ^ { m + 1 } ) \} \) with respect to the uniform convergence topology on \( C \) (here \( C _ { b } ( \mathbb{R} ^ { n + 1 } ) \) is the family of bounded continuous functions on \( \mathbb{R} ^ { n + 1 } \)). This follows`

## REPLACE_TABLES
- FILL_ME_IN
