[Page 109]

(2.70) that depend on x a , we obtain

$$
t ) \, \text { that depend on } x _ { a } , \, \text { we obtain} \\ & \frac { 1 } { 2 } \left [ \Lambda _ { b b } \mu _ { b } - \Lambda _ { b a } ( x _ { a } - \mu _ { a } ) \right ] ^ { T } \Lambda _ { b b } ^ { - 1 } \left [ \Lambda _ { b b } \mu _ { b } - \Lambda _ { b a } ( x _ { a } - \mu _ { a } ) \right ] \\ & - \frac { 1 } { 2 } x _ { a } ^ { T } \Lambda _ { a a } x _ { a } + x _ { a } ^ { T } ( \Lambda _ { a a } \mu _ { a } + \Lambda _ { a b } \mu _ { b } ) + \text {const} \\ & = \ - \frac { 1 } { 2 } x _ { a } ^ { T } ( \Lambda _ { a a } - \Lambda _ { a b } \Lambda _ { b b } ^ { - 1 } \Lambda _ { b a } ) x _ { a } \\ & \quad + x _ { a } ^ { T } ( \Lambda _ { a a } - \Lambda _ { a b } \Lambda _ { b b } ^ { - 1 } \Lambda _ { b a } ) ^ { - 1 } \mu _ { a } + \text {const} \\ \text {here} \, \text {const} \, \text { denotes quantities independent of } x _ { a } . \ \text { Again, by comparison with}
$$

where ‘const’ denotes quantities independent of x a . Again, by comparison with (2.71), we see that the covariance of the marginal distribution of p ( x a ) is given by

$$
\Sigma _ { a } = ( \Lambda _ { a a } - \Lambda _ { a b } \Lambda _ { b b } ^ { - 1 } \Lambda _ { b a } ) ^ { - 1 } . \\ \\
$$

Similarly, the mean is given by

$$
\Sigma _ { a } ( \Lambda _ { a a } - \Lambda _ { a b } \Lambda _ { b b } ^ { - 1 } \Lambda _ { b a } ) \mu _ { a } = \mu _ { a } \\ \\ \Omega _ { a } ( \Omega _ { a } \Omega _ { a } - \Omega _ { a b } \Lambda _ { b b } ^ { - 1 } \Lambda _ { b a } ) \mu _ { a } = \mu _ { a }
$$

where we have used (2.88). The covariance in (2.88) is expressed in terms of the partitioned precision matrix given by (2.69). We can rewrite this in terms of the corresponding partitioning of the covariance matrix given by (2.67), as we did for the conditional distribution. These partitioned matrices are related by

$$
\left ( \begin{matrix} \Lambda _ { a a } & \Lambda _ { a b } \\ \Lambda _ { b a } & \Lambda _ { b b } \end{matrix} \right ) ^ { - 1 } = \left ( \begin{matrix} \Sigma _ { a a } & \Sigma _ { a b } \\ \Sigma _ { b a } & \Sigma _ { b b } \end{matrix} \right ) \\ f ( 2 . 7 6 ) \, \text { we then have}
$$

Making use of (2.76), we then have

$$
( \Lambda _ { a a } - \Lambda _ { a b } \Lambda _ { b b } ^ { - 1 } \Lambda _ { b a } ) ^ { - 1 } & = \Sigma _ { a a } . \\ \intertext { t h e intuitively s a t i s f y i n g r e s u l t h a t h e m a r g i n a l d i t u b i o n p ( x _ { a } ) } \covariance g i v e n b y
$$

Thus we obtain the intuitively satisfying result that the marginal distribution p ( x a ) has mean and covariance given by

$$
\mathbb { E } [ \mathbf x _ { a } ] \ = \ \mu _ { a }
$$

$$
c o v [ x _ { a } ] \ = \ \Sigma _ { a a } .
$$

We see that for a marginal distribution, the mean and covariance are most simply expressed in terms of the partitioned covariance matrix, in contrast to the conditional distribution for which the partitioned precision matrix gives rise to simpler expressions.

Our results for the marginal and conditional distributions of a partitioned Gaussian are summarized below.

# Partitioned Gaussians

Given a joint Gaussian distribution N ( x | µ , Σ ) with Λ ≡ Σ − 1 and

$$
\text {mass distribution} \, \mathcal { N } \left ( x | \mu , 2 \right ) \text { with } \mathbf X = 2 \quad \text {and} \\ x = \begin{pmatrix} x _ { a } \\ x _ { b } \end{pmatrix} , \quad \mu = \begin{pmatrix} \mu _ { a } \\ \mu _ { b } \end{pmatrix}
$$
