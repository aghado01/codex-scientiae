[Page 148]

Use this result to prove by induction the following result

$$
( 1 + x ) ^ { N } = \sum _ { m = 0 } ^ { N } \binom { N } { m } x ^ { m } & & ( 2 . 2 6 3 ) \\ \intertext { t h i n o m i a l l t h e o r m e r } \intertext { w i t h e r s } \intertext { c h i n o w h i c h i s e r }
$$

which is known as the binomial theorem , and which is valid for all real values of x . Finally, show that the binomial distribution is normalized, so that

$$
\sum _ { m = 0 } ^ { N } \binom { N } { m } \mu ^ { m } ( 1 - \mu ) ^ { N - m } = 1 \quad ( 2 . 2 6 ) \\ \intertext { s u n o b y s f r i t p u l l i n g w i l l } \intertext { o n o n e b y s f r i t p u l l i n g w i l l } \intertext { s u n o n e b y s f r i t p u l l i n g w i l l }
$$

which can be done by ﬁrst pulling out a factor (1 − µ ) N out of the summation and then making use of the binomial theorem.

2.4 ( ) Show that the mean of the binomial distribution is given by (2.11). To do this, differentiate both sides of the normalization condition (2.264) with respect to µ and then rearrange to obtain an expression for the mean of n . Similarly, by differentiating (2.264) twice with respect to µ and making use of the result (2.11) for the mean of the binomial distribution prove the result (2.12) for the variance of the binomial.

2.5 ( ) www In this exercise, we prove that the beta distribution, given by (2.13), is correctly normalized, so that (2.14) holds. This is equivalent to showing that

$$
\int _ { 0 } ^ { 1 } \mu ^ { a - 1 } ( 1 - \mu ) ^ { b - 1 } \, d \mu & = \frac { \Gamma ( a ) \Gamma ( b ) } { \Gamma ( a + b ) } . \\ \intertext { f i n t i o n } \left ( 1 . 1 1 \right ) \text { of the } \text { gamma function } w _ { \ } h e v o \right )
$$

From the deﬁnition (1.141) of the gamma function, we have

$$
T \text { from the definition } ( . . ) & \text { for the $\gamma$-calidron, where } \\ \Gamma ( a ) \Gamma ( b ) = \int _ { 0 } ^ { \infty } \exp ( - x ) x ^ { a - 1 } \, d x \int _ { 0 } ^ { \infty } \exp ( - y ) y ^ { b - 1 } \, d y . & ( 2 . 2 6 6 ) \\ \intertext { U o s t h i n s e x p r o s i c y o n t e r g a n d s }
$$

Use this expression to prove (2.265) as follows. First bring the integral over y inside the integrand of the integral over x , next make the change of variable t = y + x where x is ﬁxed, then interchange the order of the x and t integrations, and ﬁnally make the change of variable x = tµ where t is ﬁxed.

2.6 ( ) Make use of the result (2.265) to show that the mean, variance, and mode of the beta distribution (2.13) are given respectively by

$$
\mathbb { E } [ \mu ] \ = \ \frac { a } { a + b } & & ( 2 . 2 6 7 )
$$

$$
\var { v } [ \mu ] \ = \ \frac { a b } { ( a + b ) ^ { 2 } ( a + b + 1 ) } \quad ( 2 . 2 6 8 )
$$

$$
\mod [ \mu ] \ = \ \frac { a - 1 } { a + b - 2 } .
$$
