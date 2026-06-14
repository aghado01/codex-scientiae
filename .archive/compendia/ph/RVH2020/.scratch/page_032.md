[Page 32]

$$
| ( g _ { n } * \xi _ { n } ) ( x ) - f ( x ) | \leq 1 / n \quad \text {for all } x \in C .
$$

Then we evidently have

$$
| \mathbf E [ g _ { n } ( n Y _ { 1 / n } ^ { 0 } , \dots , n Y _ { 1 / n } ^ { m } ) | X ] - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | \\ \leq 1 / n + | f ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } d s ) - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | .
$$

$$
+ \left | f ( n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { 0 } \, d s , \dots , n \int _ { 0 } ^ { 1 / n } X _ { s } ^ { m } \, d s ) - f ( X _ { 0 } ^ { 0 } , \dots , X _ { 0 } ^ { m } ) | .
$$

As f is bounded and continuous, and as the paths of X are right-continuous, this expression converges to zero as n → ∞ a.s. and in L 1 .

Note that, by the deﬁnition of our model, Y ≤ 0 , { Y < 0 s } s ∈ [0 ,δ ] is conditionally independent of { Y 0 s ,...,Y m s } s ∈ [0 ,δ ] given X , so that for every bounded continuous function h

$$
E [ h ( Y _ { 1 / n } ^ { 0 } , \dots , Y _ { 1 / n } ^ { m } ) | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X ] = E [ h ( Y _ { 1 / n } ^ { 0 } , \dots , Y _ { 1 / n } ^ { m } ) | X ] .
$$

In particular, in view of Lemma 4.16, it now suﬃces to show that

$$
\mathbf E [ h ( Y _ { s } ^ { 0 } , \dots , Y _ { s } ^ { m } ) | \cap _ { t } \sigma \{ Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } , X _ { \leq - t } \} ] = \mathbf E [ h ( Y _ { s } ^ { 0 } , \dots , Y _ { s } ^ { m } ) | Y _ { \leq 0 } , \{ Y _ { s } ^ { < 0 } \} _ { s \in [ 0 , \delta ] } ]
$$

for every bounded continuous function h and s ∈ [0 ,δ ]. But this follows readily from Proposition 4.14 using Pinsker’s inequality and martingale convergence.

## 5 Conditional random ﬁelds

Thus far we have considered inﬁnite-dimensional counterparts of classical stability problems in nonlinear ﬁltering. However, new questions arise in inﬁnite dimension beyond stability that are of interest in their own right. In particular, it is of signiﬁcant interest (cf. [40]) to understand the spatial mixing and decay of correlations properties of conditional distributions in inﬁnite dimension, which could be viewed as spatial counterparts to the ﬁlter stability property. Such questions already arise in the absence of dynamics, and thus we proceed in this section to introduce such problems in the most basic setting of conditional random ﬁelds (that is, in models with only spatial degrees of freedom). Our motivations for such questions are threefold:

- 1. Random ﬁelds provide the simplest possible setting to investigate the spatial mixing properties of conditional distributions.
- 2. Conditional random ﬁelds are of practical interest in their own right, for example, in Bayesian image analysis applications [54, 21].
- 3. Even in the more classical setting of the previous sections, the random ﬁeld viewpoint proves to be fundamental to the understanding of ﬁlter stability in inﬁnite dimension: indeed, the proofs in both sections 3 and 4 above and in [40, 41] exploit the idea that ( X v k ,Y v k ) k ∈ Z ,v ∈ Z d can be viewed as a space-time random ﬁeld.


The remainder of this section is organized as follows. In section 5.1, we recall some basic notions from the theory of Markov random fields. In section 5.2, we develop basic properties of conditional random fields and introduce some of the relevant questions. Finally, in section 5.3, we develop a general result that ensures the inheritance of ergodicity under conditioning in random fields that possess certain monotonicity properties. The latter provides a mechanism for the resolution of the random field counterpart of Conjecture 4.1 that is quite distinct from the observability theory of section 4.
