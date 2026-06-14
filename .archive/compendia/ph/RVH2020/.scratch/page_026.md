[Page 26]

we obtain

$$
\lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } ^ { < v } , X _ { - k - 1 } , \dots ) = \lim _ { k \to \infty } H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) .
$$

But by the hidden Markov model structure, { Y − k ,Y − k − 1 ,... ; X − k − 1 ,X − k − 2 ,... } and { Y 0 ,Y − 1 ,...,Y − k +1 } are conditionally independent given X − k . Thus

$$
H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots ; X _ { - k } , X _ { - k - 1 } , \dots ) = H ( Y _ { 0 } ^ { v } | Y _ { 0 } ^ { < v } , Y _ { - 1 } , \dots , Y _ { - k + 1 } , X _ { - k } ) ,
$$

and the proof is complete.

Proposition 4.7 concerns the stability of prediction of the next observation. As in the proof of Proposition 4.4, we will transform such properties into stability properties of the ﬁlter by using the informative nature of the observations.

Proof of Theorem 4.5. By translation-invariance and Lemma 3.8, it suﬃces to show that

$$
\mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) \in B | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) \in B | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
$$

in L 1 as k → ∞ for every set B , m ≥ 1 and v ∈ Z .

Suppose ﬁrst that v ≤ 1. By the chain rule for entropy and Proposition 4.7, we have

$$
H ( Y _ { k } ^ { v } , \dots , Y _ { k } ^ { m } | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ) - H ( Y _ { k } ^ { v } , \dots , Y _ { k } ^ { m } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ) & = \\ & \sum _ { \ell = v } ^ { m } \{ H ( Y _ { k } ^ { \ell } | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < \ell } ) - H ( Y _ { k } ^ { \ell } | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < \ell } ) \} \stackrel { k \to \infty } { \longrightarrow } 0 .
$$

Following verbatim the second part of the proof of Proposition 4.4 yields

$$
\mathbf P ( ( X _ { k } ^ { v } , \dots , X _ { k } ^ { m } ) \in C | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - \mathbf P ( ( X _ { k } ^ { v } , \dots , X _ { k } ^ { m } ) \in C | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
$$

in L 1 as k → ∞ for every set C , and thus the result follows.

Now suppose that v > 1. We can assume without loss of generality that v ≤ m (otherwise the conclusion follows from the result for m = v ). We may also assume that 0 < p < 1 (otherwise the conclusion is trivial). By the Bayes formula,

$$
P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] & = \\ & \frac { P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \prod _ { i = 1 } ^ { v } g ( x ^ { i } , Y _ { k } ^ { i } ) } { \sum _ { z \in \{ - 1 , 1 \} ^ { m } } P [ ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = z | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \prod _ { i = 1 } ^ { v } g ( z ^ { i } , Y _ { k } ^ { i } ) }
$$

where g ( u,y ) = P [ Y i k = y | X i k = u ], and P [( X 1 k ,...,X m k ) = x | X 0 ,Y 1 ,...,Y k − 1 ,Y <v k ] satisﬁes the analogous expression. As 0 < inf g ≤ sup g < ∞ , it follows readily that

$$
\mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] - \mathbf P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < 1 } ] \to 0
$$

for all x implies

$$
P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] - P ( ( X _ { k } ^ { 1 } , \dots , X _ { k } ^ { m } ) = x | Y _ { 1 } , \dots , Y _ { k - 1 } , Y _ { k } ^ { < v } ] \to 0
$$

for all x , and thus the proof is complete.
