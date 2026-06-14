# Manifest: Page 010

## REPAIR_MATH
- RAW: ```
( \bar { \xi } _ { k } ^ { v } ) _ { k , v \in \mathbb { Z } } , \, ( \hat { \xi } _ { k } ^ { v } ) _ { k , v \in \mathbb { Z } } \text { are } i . i . d . \text { with } P [ \bar { \xi } _ { k } ^ { v } = - 1 ] = p
```
  FIX: ```
$$
( \bar { \xi } _ { k } ^ { v } ) _ { k , v \in \mathbb { Z } } , \, ( \hat { \xi } _ { k } ^ { v } ) _ { k , v \in \mathbb { Z } } \text { are } i . i . d . \text { with } P [ \bar { \xi } _ { k } ^ { v } = - 1 ] = p
$$
```
- RAW: ```
E [ X _ { k } ^ { 0 } | Y _ { 1 } , \dots , Y _ { k } ] = 0 \quad \text {for all $k\geq 1$.}
```
  FIX: ```
$$
E [ X _ { k } ^ { 0 } | Y _ { 1 } , \dots , Y _ { k } ] = 0 \quad \text {for all $k\geq 1$.}
$$
```
- RAW: ```
\inf _ { k \geq 1 } \mathbf E | \mathbf E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] | > 0 .
```
  FIX: ```
$$
\inf _ { k \geq 1 } \mathbf E | \mathbf E [ X _ { k } ^ { 0 } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] | > 0 .
$$
```

## REPLACE_TABLES
<!-- FILL_ME_IN: No tables on this page -->

## REPAIR_PROSE
- RAW: ```
and ( ¯ ξ v k ) k,v ∈ Z , ( ˆ ξ v k ) k,v ∈ Z are independent of ( X v k ) k,v ∈ Z . This evidently corresponds to a model of the form
```
  FIX: ```
and \( ( \bar{\xi}_k^v )_{k,v \in \mathbb{Z}} \), \( ( \hat{\xi}_k^v )_{k,v \in \mathbb{Z}} \) are independent of \( ( X_k^v )_{k,v \in \mathbb{Z}} \). This evidently corresponds to a model of the form
```
- RAW: ```
When p = 0, the observations reveal for each site whether its current state diﬀers from its state at the previous time and from the states of its two neighbors at the present time. When p > 0, each observation is subject to additional noise that inverts the outcome with probability p . By symmetry, it will suﬃce to consider the case p ≤ 1 / 2, which we will do from now on.
```
  FIX: ```
When \( p = 0 \), the observations reveal for each site whether its current state diﬀers from its state at the previous time and from the states of its two neighbors at the present time. When \( p > 0 \), each observation is subject to additional noise that inverts the outcome with probability \( p \). By symmetry, it will suﬃce to consider the case \( p \le 1 / 2 \), which we will do from now on.
```
- RAW: ```
The model that we have constructed is evidently a direct extension of Example 2.1 to inﬁnite dimension. As in Example 2.1, the process ( X k ,Y k ) k ∈ Z is ergodic in the strongest sense, so that even the uniform stability assumption of Theorem 2.2 is satisﬁed. When p = 0, it is easily seen by the same reasoning as in Example 2.1 that the ﬁlter is not stable. However, in Example 2.1 the addition of observation noise with error probability p > 0 would yield nondegenerate observations, and thus ﬁlter stability by Theorem 2.2. In the present setting, on the other hand, nondegeneracy fails for any p . Nonetheless, the observations are locally nondegenerate when p > 0, and one might conjecture that this suﬃces to ensure inheritance of ergodicity. This is not the case.
```
  FIX: ```
The model that we have constructed is evidently a direct extension of Example 2.1 to inﬁnite dimension. As in Example 2.1, the process \( ( X_k, Y_k )_{k \in \mathbb{Z}} \) is ergodic in the strongest sense, so that even the uniform stability assumption of Theorem 2.2 is satisﬁed. When \( p = 0 \), it is easily seen by the same reasoning as in Example 2.1 that the ﬁlter is not stable. However, in Example 2.1 the addition of observation noise with error probability \( p > 0 \) would yield nondegenerate observations, and thus ﬁlter stability by Theorem 2.2. In the present setting, on the other hand, nondegeneracy fails for any \( p \). Nonetheless, the observations are locally nondegenerate when \( p > 0 \), and one might conjecture that this suﬃces to ensure inheritance of ergodicity. This is not the case.
```
- RAW: ```
Theorem 3.1. For the model of this section, there exist constants 0 < p ≤ p < 1 / 2 such that the ﬁlter is stable for p < p ≤ 1 / 2 and is not stable for 0 ≤ p < p .
```
  FIX: ```
Theorem 3.1. For the model of this section, there exist constants \( 0 < \underline{p} \le \bar{p} < 1 / 2 \) such that the ﬁlter is stable for \( \bar{p} < p \le 1 / 2 \) and is not stable for \( 0 \le p < \underline{p} \).
```
- RAW: ```
Remark 3.2. We naturally believe that one can choose p = p in Theorem 3.1, but we did not succeed in proving that. The proof yields some explicit bounds on p and p .
```
  FIX: ```
Remark 3.2. We naturally believe that one can choose \( \underline{p} = \bar{p} \) in Theorem 3.1, but we did not succeed in proving that. The proof yields some explicit bounds on \( \underline{p} \) and \( \bar{p} \).
```
- RAW: ```
Theorem 3.1 shows that local nondegeneracy does not suﬃce to ensure inheritance of ergodicity in inﬁnite dimension: ergodicity of the ﬁlter undergoes a phase transition at a strictly positive signal to noise ratio of the observations. Remarkably, the underlying model does not seem to exhibit any qualitative change in behavior: ( X v k ,Y v k ) k,v ∈ Z is a one-dependent random ﬁeld for every value of the error probability p . Thus it is evidently possible in inﬁnite dimension that complex ergodic behavior emerges in an otherwise trivial model when we consider its conditional distributions.
```
  FIX: ```
Theorem 3.1 shows that local nondegeneracy does not suﬃce to ensure inheritance of ergodicity in inﬁnite dimension: ergodicity of the ﬁlter undergoes a phase transition at a strictly positive signal to noise ratio of the observations. Remarkably, the underlying model does not seem to exhibit any qualitative change in behavior: \( ( X_k^v, Y_k^v )_{k,v \in \mathbb{Z}} \) is a one-dependent random ﬁeld for every value of the error probability \( p \). Thus it is evidently possible in inﬁnite dimension that complex ergodic behavior emerges in an otherwise trivial model when we consider its conditional distributions.
```
- RAW: ```
We begin by noting that as ( X v k ,Y v k ) k,v ∈ Z and ( − X v k ,Y v k ) k,v ∈ Z have the same law, it follows that E [ X 0 k | Y 1 ,...,Y k ] = E [ − X 0 k | Y 1 ,...,Y k ], and we therefore have
```
  FIX: ```
We begin by noting that as \( ( X_k^v, Y_k^v )_{k,v \in \mathbb{Z}} \) and \( ( -X_k^v, Y_k^v )_{k,v \in \mathbb{Z}} \) have the same law, it follows that \( E [ X_k^0 | Y_1, \dots, Y_k ] = E [ -X_k^0 | Y_1, \dots, Y_k ] \), and we therefore have
```
