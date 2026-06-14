[Page 18]

so we can estimate

It follows readily that

$$
C _ { j i } \leq \tanh ( 4 \beta ) < 1 \ \text { for all } i , j \in I .
$$

$$
\| C \| _ { * } \colon = \sup _ { j \in I } \sum _ { i \in I } e ^ { \| j - i \| } C _ { j i } \leq 4 e \tanh ( 4 \beta ) .
$$

We can now evidently choose \( 0 < p < 1 / 2 \) such that \( 4 e \tanh(4 \beta) < 1 / 2 \) for \( p < p \leq 1 / 2 \). Then the condition of Theorem 3.9 is satisﬁed. Moreover, as \( \| \cdot \|_* \) is a matrix norm

$$
\| D \| _ { * } \leq \sum _ { n = 0 } ^ { \infty } \| C \| _ { * } ^ { n } \leq 2 .
$$

Thus we obtain

$$
| \mu _ { x , y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) - \nu _ { y } ( f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) ) | \\ \leq ( 4 m + 2 ) \| f \| _ { \infty } e ^ { - k } \max _ { w = - m , \dots , m } \sum _ { v \in \mathbb { Z } } e ^ { \| ( k , w ) - ( 0 , v ) \| } D _ { ( k , w ) ( 0 , v ) } \\ \leq ( 4 m + 2 ) \| D \| _ { * } \| f \| _ { \infty } e ^ { - k } \leq ( 8 m + 4 ) \| f \| _ { \infty } e ^ { - k } .
$$

As our estimates are valid for \( P \)-a.e. \( ( x, y ) \), the proof is complete.

Remark 3.12. It is natural to conjecture that one can choose \( p = p \) in Theorem 3.1. While we certainly believe this to be true, we were not able to prove this fact using standard methods. The diﬃculty can be seen in Lemma 3.4, as we presently explain.

Lemma 3.4 shows that that the conditional distribution of \( X_1, \dots, X_n \) given \( Y_1, \dots, Y_n \) can be viewed as an Ising model in the spin variables \( \sigma_q := x_q z_q \) with independent random interactions \( \xi_{qr} \). An Ising model is called ferromagnetic if all the interactions are positive. In the ferromagnetic case, it is standard to establish the existence of a unique phase transition point by monotonicity arguments [22, p. 100]. Unfortunately, while our model is ‘ferromagnetic on average’ as \( P [ \xi_{qr} = 1 ] > P [ \xi_{qr} = -1 ] \), there are always inﬁnitely many interactions of either sign. Thus correlation inequalities cannot be used, and in their absence it is not clear how to prove the existence of a simple phase boundary. Monotonicity arguments will play a central role in section 5.3 below to rule out conditional phase transitions in a somewhat diﬀerent context.  

While we have made no attempt to optimize the estimates for \( p \) and \( p \) that can be extracted from the proof of Theorem 3.1, the methods used here are not expected to yield realistic values of these constants. On the other hand, the strong control provided by the Dobrushin comparison theorem has proved to be a powerful tool for the quantitative analysis of ﬁltering algorithms in high dimension, cf. [40, 41].

## 4 Symmetry breaking and observability

Theorem 3.1 shows that inheritance of ergodicity under conditioning cannot be taken for granted in inﬁnite dimension even when the model is locally nondegenerate. Are such phenomena prevalent in inﬁnite dimension, or are they restricted to some carefully constructed examples? We would like to understand in what situations such phenomena can be ruled out, both from the mathematical perspective and in view of the importance of ﬁlter
