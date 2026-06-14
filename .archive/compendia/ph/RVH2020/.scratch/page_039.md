[Page 39]

Remark 5.13. It would be interesting to obtain a counterpart to Theorem 5.12 for the filter stability problem. Unfortunately, this does not appear to be possible, at least in the setting of section 2.2. The proof of Theorem 5.12 relies on the fact that the conditional distributions of the random field given the observations are monotone, which is essentially equivalent to the validity of Definition 5.11. However, in the filtering model of section 2.2, the associated space-time random field must generally fail to be monotone in the sense of Definition 5.11, cf. [32] for a discussion in the continuous time setting. While the spacetime distributions of interacting particle systems with monotone transition probabilities do satisfy some weaker monotonicity properties, cf. [30, section 3.1] or [32], such weaker properties do not suffice for the proof of Theorem 5.12.

We now turn to the proof of Theorem 5.12. We begin by establishing the inheritance of monotonicity by the conditional specification \( \gamma ^ { y } \).

Lemma 5.14. Suppose that \( \gamma \) is monotone. Then the following hold:

$$
1 . \ \gamma ^ { y } \ i s \ m o n o t o n e \ \text {for every} \ y \in \{ - 1 , 1 \} ^ { \mathbb { Z } ^ { d } } .
$$

2. \( y \mapsto \gamma _ { V } ^ { y } f \) is increasing for every \( V \subset \subset \mathbb { Z } ^ { d } \) and bounded increasing \( f \).

Proof. It will be convenient to write

$$
g _ { v } ( x _ { v } , y _ { v } ) = \mathbf P [ Y _ { v } = y _ { v } | X _ { v } = x _ { v } ] = \sqrt { p _ { v } ( 1 - p _ { v } ) } \, e ^ { \beta _ { v } y _ { v } x _ { v } }
$$

with \( \beta _ { v } = \log ( 1 - p _ { v } ) / p _ { v } \ge 0 \) in Proposition 5.7.

Define for every \( y \in F ^ { \mathbb { Z } ^ { d } } \) and \( W , V \subset \subset \mathbb { Z } ^ { d } \) the transition kernel on \( E ^ { \mathbb { Z } ^ { d } } \)

$$
\gamma _ { V , W } ^ { y } ( x , A ) = \frac { \int 1 _ { A } ( z ) \prod _ { w \in W \cap V } e ^ { \beta _ { w } y _ { w } z _ { w } } \, \gamma _ { V } ( x , d z ) } { \int \prod _ { w \in W \cap V } e ^ { \beta _ { w } y _ { w } z _ { w } } \, \gamma _ { V } ( x , d z ) } .
$$

Evidently \( \gamma _ { V } ^ { y } = \gamma _ { V , V } ^ { y } \) and \( \gamma _ { V } = \gamma _ { V , \emptyset } ^ { y } \), and for simplicity we will write \( \gamma _ { \emptyset , W } ^ { y } f = f \). We now prove that \( ( \gamma _ { V , W } ^ { y } f ) ( x ) \) is increasing in \( x , y \) for every bounded increasing function \( f \) by induction on \( | V | + | W | \). The claim is obviously true for \( | V | + | W | = 1 \) by the monotonicity of \( \gamma \). In the remainder of the proof, we suppose that the claim is true for all \( V , W \) such that \( | V | + | W | = m \), and we proceed with the induction step.

Fix \( V , W \) such that \( | V | + | W | = m + 1 \). The claim is trivially true if \( W \cap V = \emptyset \) by the monotonicity of \( \gamma \). Otherwise, fix \( v \in W \cap V \) and a bounded increasing function \( f \). Then

$$
\gamma _ { V , W } ^ { y } f = \gamma _ { V , W } ^ { y } \gamma _ { V \ \{ v \} , W } ^ { y } f
$$

holds by the same argument as in the proof of Proposition 5.7. Moreover, by the induction hypothesis, \( ( \gamma _ { V \setminus \{ v \} , W } ^ { y } f ) ( x ) \) is increasing in \( x , y \), and by construction \( ( \gamma _ { V \setminus \{ v \} , W } ^ { y } f ) ( x ) \) depends only on \( x _ { v } \) and \( x _ { V ^ { c } } , y \). To show that \( ( \gamma _ { V , W } ^ { y } f ) ( x ) \) is increasing in \( x , y \), it thus suffices to show that \( \gamma _ { V , W } ^ { y } ( x , A ) \) is increasing in \( x , y \) for \( 1 _ { A } ( x ) = 1 _ { \{ x _ { v } = 1 \} } \). But note that

$$
\frac { \gamma _ { V , W } ^ { y } ( x , A ) } { 1 - \gamma _ { V , W } ^ { y } ( x , A ) } = e ^ { 2 \beta _ { v } y _ { v } } \, \frac { \gamma _ { V , W \{ v \} } ^ { y } ( x , A ) } { 1 - \gamma _ { V , W \{ v \} } ^ { y } ( x , A ) } .
$$

As \( \gamma _ { V , W \setminus \{ v \} } ^ { y } ( x , A ) \) is increasing in \( x , y \) by the induction hypothesis, \( \gamma _ { V , W } ^ { y } ( x , A ) \) is also increasing in \( x , y \). Thus the induction step is established, and the proof is complete.
