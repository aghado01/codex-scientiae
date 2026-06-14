[Page 27]

Applying Proposition 38 changes the probabilities on g ( Z ) to normal tail probabilities. Thus, both bounding terms in Eq. (4.23) converge to zero and thus the kernel estimate converges to the true mean absolute deviation.

## 5. Examples

Here we provide detailed examples of the kernel density and kernel density estimation of an unknown pdf. For simplicity, we restrict to a single degree of homology, say k = 1. Due to the intrinsic high dimension of the kernel, we present contour plots for slices of the kernel density. Speciﬁcally, for inputs (( b 1 ,d 1 ) ,..., ( b N ,d N )), we consider the kernel density evaluated at ( b 1 ,d 1 ) ∈ W with ( b i ,d i ) ﬁxed for i ≥ 2. For clarity, the unique symmetric pdf f sym ( ξ 1 ,...,ξ N ) = 1 N ! π ∈ Π N f ( ξ π (1) ,...,ξ π ( N ) ) is used in the contour plots (see Remark 15). For explicit computation, we choose the probability mass function N + 1 N N

$$
\nu ( N ) = \max \left \{ \frac { N _ { \ell } + 1 - | N _ { \ell } - N | } { ( N _ { \ell } + 1 ) ^ { 2 } } , 0 \right \}
$$

when evaluating the lower density in Eq. (4.5), where N = D is the lower cardinality of the center diagram. This probability mass function is chosen to satisfy the requirements of Def. 24, and speciﬁcally has the property that ν ( N ) > 0 for 0 ≤ N ≤ 2 D .

Example 2 Consider the center persistence diagram D = { (1 , 3) , (2 , 4) , (1 , 1 . 3) , (3 , 3 . 2) } ⊂ W and bandwidth σ = 1 / 2. We construct the associated kernel density K σ ( Z, D ) according to Theorem 25 and follow with some plots and analysis of the kernel density. The random persistence diagram D associated with the kernel density K σ ( Z, D ) has a variable number of features N = | D | ; consequently, the input diagram Z = { ξ 1 ,...,ξ N } must have variable length and therefore the kernel density has local deﬁnitions (see Rmk. 14) on W N for each possible input cardinality N .

Since each modiﬁed Gaussian p ( j ) (Def. 22) and the lower density p   (Def. 24) integrate to 1 over the wedge W , an expression for the probability mass function (pmf) P [ | D | = N ] can be expressed solely in terms of ν and q ( j ) :

$$
\mathbb { P } [ | D | = N ] & = \left [ q ^ { ( 1 ) } q ^ { ( 2 ) } \right ] \nu ( N - 2 ) \\ & + \left [ q ^ { ( 1 ) } \left ( 1 - q ^ { ( 2 ) } \right ) + q ^ { ( 2 ) } \left ( 1 - q ^ { ( 1 ) } \right ) \right ] \nu ( N - 1 ) \\ & + \left [ \left ( 1 - q ^ { ( 1 ) } \right ) \left ( 1 - q ^ { ( 2 ) } \right ) \right ] \nu ( N )
$$

The plot of this pmf is shown in Fig. 4. Recall that D = D u ∪ D   , so that | D | = | D u | +   D     ; since q ( j ) ≈ 1 for j = 1 , 2, | D u | = 2 with high probability and the pmf P [ | D | = N ] is nearly the pmf for   D     , ν , shifted up by 2 units. Fig. 4 suggests that understanding the kernel density requires investigation into higher cardinality inputs. In general, it is important to consider input diagrams Z with | Z | ≥ | D u | .  

First, we describe the random diagram associated to the lower features D = { (1 , 1 . 3) , (3 , 3 . 2) } of the center diagram D . The lower random diagram D is described in Def. 24 according to a probability mass function (pmf) ν for the cardinality of D and a single probability density p ( b,d ) for the subsequent features’ locations in the wedge W . The pmf ν is deﬁned according to Eq. (5.1) with N = 2; that is, ν ( { 0 , 1 , 2 , 3 , 4 } ) = { 1 / 9 , 2 / 9 , 3 / 9 , 2 / 9 , 1 / 9 } respectively, and zero otherwise.
