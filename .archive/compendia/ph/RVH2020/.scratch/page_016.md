[Page 16]

$$
\mathbf E | \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf E [ f ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | Y _ { 1 } , \dots , Y _ { k } ] | \stackrel { k \to \infty } { \longrightarrow } 0
$$

for every function f and every m ≥ 1 . Then the ﬁlter is stable.

Proof. Fix any measurable subset A of {− 1 , 1 } Z and deﬁne

$$
F _ { m } = f _ { m } ( X _ { 0 } ^ { - m } , \dots , X _ { 0 } ^ { m } ) \colon = \mathbf P [ X _ { 0 } \in A | X _ { 0 } ^ { - m } , \dots , X _ { 0 } ^ { m } ] .
$$

We can estimate

$$
\mathbf E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] | & \leq 2 \mathbf E | f _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) - 1 _ { A } ( X _ { k } ) | \\ & + \mathbf E | \mathbf E _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - \mathbf E [ f _ { m } ( X _ { k } ^ { - m } , \dots , X _ { k } ^ { m } ) | Y _ { 1 } , \dots , Y _ { k } ] | .
$$

By stationarity the ﬁrst term does not depend on k , and the assumption gives

$$
\lim _ { k \to \infty } \sup _ { k } E | P [ X _ { k } \in A | X _ { 0 } , Y _ { 1 } , \dots , Y _ { k } ] - P [ X _ { k } \in A | Y _ { 1 } , \dots , Y _ { k } ] | \leq 2 \, \text {E} | F _ { m } - 1 _ { A } ( X _ { 0 } ) | .
$$

Letting m → ∞ and using the martingale convergence theorem concludes the proof.

We will in fact prove a much stronger pathwise bound than is required by the above lemma. The basic tool we will use for this purpose is the Dobrushin comparison theorem [22, Theorem 8.20], which we state here in a convenient form.

Theorem 3.9 (Dobrushin comparison theorem) . Let µ and ν be probability measures on {− 1 , 1 } I for some countable set I , and choose measurable functions m i ,n i such that

$$
m _ { i } ( X ) = \mu ( X ^ { i } = 1 | \{ X ^ { j } \colon j \neq i \} ) , \quad n _ { i } ( X ) = \nu ( X ^ { i } = 1 | \{ X ^ { j } \colon j \neq i \} ) .
$$

glyph[negationslash]

glyph[negationslash]

Deﬁne

$$
b _ { i } \coloneqq \sup _ { x } | m _ { i } ( x ) - n _ { i } ( x ) | , \quad C _ { j i } \coloneqq \sup _ { x , z ; x ^ { v } = z ^ { v } \text { for } v \neq i } | m _ { j } ( x ) - m _ { j } ( z ) | ,
$$

glyph[negationslash]

and assume that

$$
\sup _ { j \in I } \sum _ { i \in I } C _ { j i } < 1 .
$$

Then D := ∞ n =0 C n exists (in the sense of matrix algebra), and

$$
| \mu ( f ) - \nu ( f ) | \leq \sum _ { j \in J } \sum _ { i \in I } D _ { j i } b _ { i }
$$

whenever J is a ﬁnite set, f ( x ) depends only on { x j : j ∈ J } , and 0 ≤ f ≤ 1 .

We will apply this result pathwise to compare the ﬁlters with and without conditioning on the initial condition. To this end, we must compute the quantities that arise in the Dobrushin comparison theorem for suitably chosen regular conditional probabilities.
