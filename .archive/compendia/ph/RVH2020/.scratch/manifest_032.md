# Manifest: Page 032

## REPAIR_MATH
- RAW: ```
| ( g _ { n } * \xi _ { n } ) ( x ) - f ( x ) | \leq 1 / n \quad \text {for all } x \in C .
```
  FIX: ```
$$
| ( g _ { n } * \xi _ { n } ) ( x ) - f ( x ) | \leq 1 / n \quad \text {for all } x \in C .
$$
```
- RAW: ```
| \mathbf E [ g _ { n } ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | \\ \leq 1 / n + | f ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } d s ) - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | .
```
  FIX: ```
$$
| \mathbf E [ g _ { n } ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | \\ \leq 1 / n + | f ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } d s ) - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | .
$$
```
- RAW: ```
+ \left | f ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } \, d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } \, d s ) - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | .
```
  FIX: ```
$$
+ \left | f ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } \, d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } \, d s ) - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | .
$$
```
- RAW: ```
E [ h ( Y _ { 1 / n } ^ { 0 } , \dots , Y _ { 1 / n } ^ { m } ) | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X ] = E [ h ( Y _ { 1 / n } ^ { 0 } , \dots , Y _ { 1 / n } ^ { m } ) | X ] .
```
  FIX: ```
$$
E [ h ( Y _ { 1 / n } ^ { 0 } , \dots , Y _ { 1 / n } ^ { m } ) | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X ] = E [ h ( Y _ { 1 / n } ^ { 0 } , \dots , Y _ { 1 / n } ^ { m } ) | X ] .
$$
```
- RAW: ```
\mathbf E [ h ( Y _ { s } ^ { 0 } , \dots , Y _ { s } ^ { m } ) | \cap _ { t } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} ] = \mathbf E [ h ( Y _ { s } ^ { 0 } , \dots , Y _ { s } ^ { m } ) | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } ]
```
  FIX: ```
$$
\mathbf E [ h ( Y _ { s } ^ { 0 } , \dots , Y _ { s } ^ { m } ) | \cap _ { t } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} ] = \mathbf E [ h ( Y _ { s } ^ { 0 } , \dots , Y _ { s } ^ { m } ) | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } ]
$$
```
- RAW: `As f is bounded and continuous, and as the paths of X are right-continuous, this expression converges to zero as n → ∞ a.s. and in L 1 .`
  FIX: `As \( f \) is bounded and continuous, and as the paths of \( X \) are right-continuous, this expression converges to zero as \( n \to \infty \) a.s. and in \( L^1 \).`
- RAW: `Note that, by the deﬁnition of our model, Y ≤ 0 , { Y < 0 s } s ∈ [0 ,δ ] is conditionally independent of { Y 0 s ,...,Y m s } s ∈ [0 ,δ ] given X , so that for every bounded continuous function h`
  FIX: `Note that, by the deﬁnition of our model, \( Y_{\leq 0}, \{ Y_{s}^{< 0} \}_{s \in [0, \delta]} \) is conditionally independent of \( \{ Y_{s}^{0}, \dots, Y_{s}^{m} \}_{s \in [0, \delta]} \) given \( X \), so that for every bounded continuous function \( h \)`
- RAW: `for every bounded continuous function h and s ∈ [0 ,δ ]. But this follows readily from Proposition 4.14 using Pinsker’s inequality and martingale convergence.`
  FIX: `for every bounded continuous function \( h \) and \( s \in [0, \delta] \). But this follows readily from Proposition 4.14 using Pinsker’s inequality and martingale convergence.`
- RAW: `- 3. Even in the more classical setting of the previous sections, the random ﬁeld viewpoint proves to be fundamental to the understanding of ﬁlter stability in inﬁnite dimension: indeed, the proofs in both sections 3 and 4 above and in [40, 41] exploit the idea that ( X v k ,Y v k ) k ∈ Z ,v ∈ Z d can be viewed as a space-time random ﬁeld.`
  FIX: `- 3. Even in the more classical setting of the previous sections, the random ﬁeld viewpoint proves to be fundamental to the understanding of ﬁlter stability in inﬁnite dimension: indeed, the proofs in both sections 3 and 4 above and in [40, 41] exploit the idea that \( (X_{v}^{k}, Y_{v}^{k})_{k \in \mathbb{Z}, v \in \mathbb{Z}^d} \) can be viewed as a space-time random ﬁeld.`

## REPAIR_PROSE
- RAW: `deﬁnition`
  FIX: `definition`
- RAW: `suﬃces`
  FIX: `suffices`
- RAW: `inﬁnite`
  FIX: `infinite`
- RAW: `ﬁltering`
  FIX: `filtering`
- RAW: `ﬁlter`
  FIX: `filter`
- RAW: `ﬁelds`
  FIX: `fields`
- RAW: `ﬁeld`
  FIX: `field`
