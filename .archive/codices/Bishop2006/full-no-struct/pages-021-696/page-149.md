[Page 149]

2.7 ( ) Consider a binomial random variable x given by (2.9), with prior distribution for µ given by the beta distribution (2.13), and suppose we have observed m occurrences of x = 1 and l occurrences of x = 0 . Show that the posterior mean value of x lies between the prior mean and the maximum likelihood estimate for µ . To do this, show that the posterior mean can be written as λ times the prior mean plus (1 − λ ) times the maximum likelihood estimate, where 0 λ 1 . This illustrates the concept of the posterior distribution being a compromise between the prior distribution and the maximum likelihood solution.

2.8 ( ) Consider two variables x and y with joint distribution p ( x,y ) . Prove the following two results

$$
\mathbb { E } [ x ] \ & = \ \mathbb { E } _ { y } \left [ \mathbb { E } _ { x } [ x | y ] \right ] \\ \text {var} [ x ] \ & = \ \mathbb { F } _ { x } \left [ \text {var} \ \left [ x | u \right ] \right ] + \text {var} \ \left [ \mathbb { F } \ \left [ x | u \right ] \right ] \\
$$

$$
\ v a r [ x ] \ = \ \mathbb { E } _ { y } \left [ v a r _ { x } [ x | y ] \right ] + v a r _ { y } \left [ \mathbb { E } _ { x } [ x | y ] \right ] .
$$

Here E x [ x | y ] denotes the expectation of x under the conditional distribution p ( x | y ) , with a similar notation for the conditional variance.

2.9 ( ) www . In this exercise, we prove the normalization of the Dirichlet distribution (2.38) using induction. We have already shown in Exercise 2.5 that the beta distribution, which is a special case of the Dirichlet for M = 2 , is normalized. We now assume that the Dirichlet distribution is normalized for M − 1 variables and prove that it is normalized for M variables. To do this, consider the Dirichlet distribution over M variables, and take account of the constraint M k =1 µ k = 1 by eliminating µ M , so that the Dirichlet is written α 1

$$
p _ { M } ( \mu _ { 1 } , \dots , \mu _ { M - 1 } ) = C _ { M } \prod _ { k = 1 } ^ { M - 1 } \mu _ { k } ^ { \alpha _ { k } - 1 } \left ( 1 - \sum _ { j = 1 } ^ { M - 1 } \mu _ { j } \right ) ^ { \alpha _ { M } - 1 } \\ \intertext { a n d our goal is to find an expression for C _ { \gamma } . To do this, integrate over \mu _ { \gamma } , taking }
$$

and our goal is to ﬁnd an expression for C M . To do this, integrate over µ M − 1 , taking care over the limits of integration, and then make a change of variable so that this integral has limits 0 and 1 . By assuming the correct result for C M − 1 and making use of (2.265), derive the expression for C M .

2.10 ( ) Using the property Γ( x + 1) = x Γ( x ) of the gamma function, derive the following results for the mean, variance, and covariance of the Dirichlet distribution given by (2.38)

$$
\mathbb { E } [ \mu _ { j } ] \ = \ \frac { \alpha _ { j } } { \alpha _ { 0 } } \quad & & ( 2 . 2 7 3 )
$$

$$
\var { v } [ \mu _ { j } ] \ = \ \frac { \alpha _ { j } ( \alpha _ { 0 } - \alpha _ { j } ) } { \alpha _ { 0 } ^ { 2 } ( \alpha _ { 0 } + 1 ) }
$$

$$
\cot [ \mu _ { j } \mu _ { l } ] \ = \ - \frac { \alpha _ { j } \alpha _ { l } } { \alpha _ { 0 } ^ { 2 } ( \alpha _ { 0 } + 1 ) } , \quad j \neq l
$$

/negationslash
