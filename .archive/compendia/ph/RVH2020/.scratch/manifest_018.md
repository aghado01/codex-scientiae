# Manifest: Page 018

## REPAIR_MATH
- RAW: ```
C _ { j i } \leq \tanh ( 4 \beta ) < 1 \ \text { for all } i , j \in I .
```
  FIX: ```
$$
C _ { j i } \leq \tanh ( 4 \beta ) < 1 \ \text { for all } i , j \in I .
$$
```
- RAW: ```
\| C \| _ { * } \colon = \sup _ { j \in I } \sum _ { i \in I } e ^ { \| j - i \| } C _ { j i } \leq 4 e \tanh ( 4 \beta ) .
```
  FIX: ```
$$
\| C \| _ { * } \colon = \sup _ { j \in I } \sum _ { i \in I } e ^ { \| j - i \| } C _ { j i } \leq 4 e \tanh ( 4 \beta ) .
$$
```
- RAW: ```
\| D \| _ { * } \leq \sum _ { n = 0 } ^ { \infty } \| C \| _ { * } ^ { n } \leq 2 .
```
  FIX: ```
$$
\| D \| _ { * } \leq \sum _ { n = 0 } ^ { \infty } \| C \| _ { * } ^ { n } \leq 2 .
$$
```
- RAW: ```
| \mu _ { x , y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) - \nu _ { y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) | \\ \leq ( 4 m + 2 ) \| f \| _ { \infty } e ^ { - k } \max _ { w = - m , \dots , m } \sum _ { v \in \mathbb { Z } } e ^ { \| ( k , w ) - ( 0 , v ) \| } D _ { ( k , w ) ( 0 , v ) } \\ \leq ( 4 m + 2 ) \| D \| _ { * } \| f \| _ { \infty } e ^ { - k } \leq ( 8 m + 4 ) \| f \| _ { \infty } e ^ { - k } .
```
  FIX: ```
$$
| \mu _ { x , y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) - \nu _ { y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) | \\ \leq ( 4 m + 2 ) \| f \| _ { \infty } e ^ { - k } \max _ { w = - m , \dots , m } \sum _ { v \in \mathbb { Z } } e ^ { \| ( k , w ) - ( 0 , v ) \| } D _ { ( k , w ) ( 0 , v ) } \\ \leq ( 4 m + 2 ) \| D \| _ { * } \| f \| _ { \infty } e ^ { - k } \leq ( 8 m + 4 ) \| f \| _ { \infty } e ^ { - k } .
$$
```

## REPAIR_PROSE
- RAW: ```
We can now evidently choose 0 < p < 1 / 2 such that 4 e tanh(4 β ) < 1 / 2 for p < p ≤ 1 / 2. Then the condition of Theorem 3.9 is satisﬁed. Moreover, as · ∗ is a matrix norm
```
  FIX: ```
We can now evidently choose \( 0 < p < 1 / 2 \) such that \( 4 e \tanh(4 \beta) < 1 / 2 \) for \( p < p \leq 1 / 2 \). Then the condition of Theorem 3.9 is satisﬁed. Moreover, as \( \| \cdot \|_* \) is a matrix norm
```
- RAW: ```
As our estimates are valid for P -a.e. ( x,y ), the proof is complete.
```
  FIX: ```
As our estimates are valid for \( P \)-a.e. \( ( x, y ) \), the proof is complete.
```
- RAW: ```
Remark 3.12. It is natural to conjecture that one can choose p = p in Theorem 3.1. While we certainly believe this to be true, we were not able to prove this fact using standard methods. The diﬃculty can be seen in Lemma 3.4, as we presently explain.
```
  FIX: ```
Remark 3.12. It is natural to conjecture that one can choose \( p = p \) in Theorem 3.1. While we certainly believe this to be true, we were not able to prove this fact using standard methods. The diﬃculty can be seen in Lemma 3.4, as we presently explain.
```
- RAW: ```
Lemma 3.4 shows that that the conditional distribution of X 1 ,...,X n given Y 1 ,...,Y n can be viewed as an Ising model in the spin variables σ q := x q z q with independent random interactions ξ qr . An Ising model is called ferromagnetic if all the interactions are positive. In the ferromagnetic case, it is standard to establish the existence of a unique phase transition point by monotonicity arguments [22, p. 100]. Unfortunately, while our model is ‘ferromagnetic on average’ as P [ ξ qr = 1] > P [ ξ qr = − 1], there are always inﬁnitely many interactions of either sign.
```
  FIX: ```
Lemma 3.4 shows that that the conditional distribution of \( X_1, \dots, X_n \) given \( Y_1, \dots, Y_n \) can be viewed as an Ising model in the spin variables \( \sigma_q := x_q z_q \) with independent random interactions \( \xi_{qr} \). An Ising model is called ferromagnetic if all the interactions are positive. In the ferromagnetic case, it is standard to establish the existence of a unique phase transition point by monotonicity arguments [22, p. 100]. Unfortunately, while our model is ‘ferromagnetic on average’ as \( P [ \xi_{qr} = 1 ] > P [ \xi_{qr} = -1 ] \), there are always inﬁnitely many interactions of either sign.
```
- RAW: ```
While we have made no attempt to optimize the estimates for p and p that can be extracted from the proof of Theorem 3.1, the methods used here are not expected to yield realistic values of these constants.
```
  FIX: ```
While we have made no attempt to optimize the estimates for \( p \) and \( p \) that can be extracted from the proof of Theorem 3.1, the methods used here are not expected to yield realistic values of these constants.
```
