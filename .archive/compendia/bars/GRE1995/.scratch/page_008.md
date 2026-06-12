[Page 8]

set

$$
\xi ( A \times B ) = \xi ( B \times A ) = \lambda \{ ( \theta ^ { ( 1 ) } , u ^ { ( 1 ) } ) \colon \theta ^ { ( 1 ) } \in A , \, \theta ^ { ( 2 ) } ( \theta ^ { ( 1 ) } , u ^ { ( 1 ) } ) \in B \} ,
$$

$$
\xi ( A \times B ) = \xi \{ ( A \cap \mathcal { C } _ { 1 } ) \times ( B \cap \mathcal { C } _ { 2 } ) \} + \xi \{ ( A \cap \mathcal { C } _ { 2 } ) \times ( B \cap \mathcal { C } _ { 1 } ) \} .
$$

$$
f ( x , x ^ { \prime } ) = p ( 1 , \theta ^ { ( 1 ) } | y ) j ( 1 , \theta ^ { ( 1 ) } ) q _ { 1 } ( u ^ { ( 1 ) } ) ,
$$

$$
f(x', x) = p\!\left(2, \theta^{(2)}\big|y\right) j\!\left(2, \theta^{(2)}\right) q_2\!\left(u^{(2)}\right)
$$

4 of the equilibrium joint proposal distribution n(dx)q(x, dx')

According to (5), the appropriate acceptance probability for the proposed transition from x = (1,0(1)) to x' = (2,0(2)) is

$$
\min \left \{ 1 , \frac { p ( 2 , \theta ^ { ( 2 ) } | y ) j ( 2 , \theta ^ { ( 2 ) } ) q _ { 2 } ( u ^ { ( 2 ) } ) } { p ( 1 , \theta ^ { ( 1 ) } | y ) j ( 1 , \theta ^ { ( 1 ) } ) q _ { 1 } ( u ^ { ( 1 ) } ) } \left [ \frac { \partial ( \theta ^ { ( 2 ) } , u ^ { ( 2 ) } ) } { \partial ( \theta ^ { ( 1 ) } , u ^ { ( 1 ) } ) } \right ] \right \} ,
$$

used above.

then; there is no need to generate the corresponding and the expression for the acceptance probability simplifies. For example; with m2 = 0, it becomes u(i)

$$
\min\left\{1,\, \frac{p\!\left(2,\theta^{(2)}\big|y\right) j\!\left(2,\theta^{(2)}\right)}{p\!\left(1,\theta^{(1)}\big|y\right) j\!\left(1,\theta^{(1)}\right) q_1\!\left(u^{(1)}\right)} \left|\frac{\partial\,\theta^{(2)}}{\partial\,\theta^{(1)}}\right|\right\}
$$

Finally, this example is somewhat simplified compared with many real applications; and appropriate modifications may need to be made: For example; may be generated dependently on 0(1, in which case q1(u(1)) is replaced by the conditional density. If other discrete variables are generated in making the proposals; the probability functions of their realised  values are multiplied into the move probabilities j(x). With this latter change, (8) is used repeatedly in the applications later in this paper. u(1)

## 4. Application to One-Dimensional Multiple Change-Point Problems

### 4.1. Coal Mining Disasters

As our first application of the general construction of $ 3, we present a new Bayesian model for multiple change-point analysis; and develop a reversible jump Markov chain Monte Carlo sampler to compute the posterior distribution

A data set that has been frequently used in illustrating new methods for change-point analysis is the process of dates of serious coal-mining disasters between 1851 and 1962, given by Raftery & Akman (1986) In contrast to some other previous analyses of these data, we will work in continuous time with the points recorded in rather than Figure 1 displays the dates of the 192 disasters in these 112 years 40 907 days as a jittered dot plot, together with the cumulative counting process; shown as a dotted line. n} e [0, L] from a Poisson process with rate given by the point days years.
