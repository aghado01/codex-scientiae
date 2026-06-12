[Page 491]

Exercise 10.7

Exercise 10.8

Section 10.4.1

Note that the true posterior distribution does not factorize in this way. The optimum factors q µ ( µ ) and q τ ( τ ) can be obtained from the general result (10.9) as follows. For q µ ( µ ) we have

$$
\ln q _ { \mu } ^ { * } ( \mu ) \ = \ \mathbb { E } _ { \tau } \left [ \ln p ( \mathcal { D } | \mu , \tau ) + \ln p ( \mu | \tau ) \right ] + \text {const} \\ = \ - \frac { \mathbb { E } [ \tau ] } { 2 } \left \{ \lambda _ { 0 } ( \mu - \mu _ { 0 } ) ^ { 2 } + \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } \right \} + \text {const. } \left ( 1 0 . 2 \right ) \\ \\ \text {Completing the square over } \mu \text { we see that } q _ { \mu } ( \mu ) \text { is a Gaussian } \mathcal { N } \left ( \mu | \mu _ { N } , \lambda _ { N } ^ { - 1 } \right ) \text { with}
$$

n =1 Completing the square over µ we see that q µ ( µ ) is a Gaussian N µ | µ N ,λ − 1 N with mean and precision given by λ µ + N x

$$
\mu _ { N } \ = \ \frac { \lambda _ { 0 } \mu _ { 0 } + N \overline { x } } { \lambda _ { 0 } + N } & & ( 1 0 . 2 6 )
$$

$$
\lambda _ { N } \ = \ ( \lambda _ { 0 } + N ) \mathbb { E } [ \tau ] .
$$

Note that for N → ∞ this gives the maximum likelihood result in which µ N = x and the precision is inﬁnite.

Similarly, the optimal solution for the factor q τ ( τ ) is given by

$$
\text { Similarly, the optimal solution for the factor or } q _ { \tau } ( \tau ) \text { is given by} \\ \ln q _ { \tau } ^ { * } ( \tau ) \ = \ \mathbb { E } _ { \mu } \left [ \ln p ( \mathcal { D } | \mu , \tau ) + \ln p ( \mu | \tau ) \right ] + \ln p ( \tau ) + \text {const} \\ \equiv \quad ( a _ { 0 } - 1 ) \ln \tau - b _ { 0 } \tau + \frac { N } { 2 } \ln \tau \\ - \frac { \tau } { 2 } \mathbb { E } _ { \mu } \left [ \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } + \lambda _ { 0 } ( \mu - \mu _ { 0 } ) ^ { 2 } \right ] + \text {const} \quad ( 1 0 . 2 8 ) \\ \intertext { a n d h e n c $ q _ { \tau } ( \tau ) \text { is a gamma distribution Game} ( \tau | a _ { N } , b _ { N } ) \text { with parameters} }
$$

and hence q τ ( τ ) is a gamma distribution Gam( τ | a N ,b N ) with parameters

$$
a _ { N } \ = \ a _ { 0 } + \frac { N } { 2 } & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & & &
$$

$$
a _ { N } \ = \ a _ { 0 } + \frac { } { 2 } \frac { } { 2 } \\ b _ { N } \ = \ b _ { 0 } + \frac { 1 } { 2 } \mathbb { E } _ { \mu } \left [ \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } + \lambda _ { 0 } ( \mu - \mu _ { 0 } ) ^ { 2 } \right ] . \quad \\ \text { again this exists the expected behaviour when } N \to \infty .
$$

Again this exhibits the expected behaviour when N → ∞ . It should be emphasized that we did not assume these

speciﬁc functional forms for the optimal distributions q µ ( µ ) and q τ ( τ ) . They arose naturally from the structure of the likelihood function and the corresponding conjugate priors.

Thus we have expressions for the optimal distributions q µ ( µ ) and q τ ( τ ) each of which depends on moments evaluated with respect to the other distribution. One approach to ﬁnding a solution is therefore to make an initial guess for, say, the moment E [ τ ] and use this to re-compute the distribution q µ ( µ ) . Given this revised distribution we can then extract the required moments E [ µ ] and E [ µ 2 ] , and use these to recompute the distribution q τ ( τ ) , and so on. Since the space of hidden variables for this example is only two dimensional, we can illustrate the variational approximation to the posterior distribution by plotting contours of both the true posterior and the factorized approximation, as illustrated in Figure 10.4.
