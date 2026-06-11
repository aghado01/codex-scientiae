[Page 133]

where X = { x 1 ,..., x N } . We immediately see that the situation is now much more complex than with a single Gaussian, due to the presence of the summation over k inside the logarithm. As a result, the maximum likelihood solution for the parameters no longer has a closed-form analytical solution. One approach to maximizing the likelihood function is to use iterative numerical optimization techniques (Fletcher, 1987; Nocedal and Wright, 1999; Bishop and Nabney, 2008). Alternatively we can employ a powerful framework called expectation maximization , which will be discussed at length in Chapter 9.

# 2.4. The Exponential Family

The probability distributions that we have studied so far in this chapter (with the exception of the Gaussian mixture) are speciﬁc examples of a broad class of distributions called the exponential family (Duda and Hart, 1973; Bernardo and Smith, 1994). Members of the exponential family have many important properties in common, and it is illuminating to discuss these properties in some generality.

The exponential family of distributions over x , given parameters η , is deﬁned to be the set of distributions of the form

$$
\intertext { s u r b o u t i o n s o r t i n c h r a l l } p ( x | \eta ) = h ( x ) g ( \eta ) \exp \left \{ \eta ^ { T } u ( x ) \right \} \\ \intertext { b e s c a r l o r v e r t o , a n d y m a b e d i s c r e d e r o u n t i o n s . $ H e r e $ \eta a r e } \text {tural parameters of the distribution } \text {d} u ( x ) \text { is some function of } x
$$

where x may be scalar or vector, and may be discrete or continuous. Here η are called the natural parameters of the distribution, and u ( x ) is some function of x . The function g ( η ) can be interpreted as the coefﬁcient that ensures that the distribution is normalized and therefore satisﬁes

$$
\text {aligned and therefore satisfies} \\ g ( \eta ) \int h ( x ) \exp \left \{ \eta ^ { T } u ( x ) \right \} \, d x = 1 \\ \text {integration is replaced by summation if x is a discrete variable.}
$$

where the integration is replaced by summation if x is a discrete variable.

We begin by taking some examples of the distributions introduced earlier in the chapter and showing that they are indeed members of the exponential family. Consider ﬁrst the Bernoulli distribution

$$
p ( x | \mu ) = \text {Bern} ( x | \mu ) = \mu ^ { x } ( 1 - \mu ) ^ { 1 - x } .
$$

Expressing the right-hand side as the exponential of the logarithm, we have

$$
p ( x | \mu ) \ & = \ \exp \{ x \ln \mu + ( 1 - x ) \ln ( 1 - \mu ) \} \\ & = \ ( 1 - \mu ) \exp \left \{ \ln \left ( \frac { \mu } { 1 - \mu } \right ) x \right \} . \\ \intertext { s i r $ o n $ with $ ( 2 . 1 9 4 ) $ allows us to identify }
$$

Comparison with (2.194) allows us to identify

$$
\eta = \ln \left ( \frac { \mu } { 1 - \mu } \right )
$$
