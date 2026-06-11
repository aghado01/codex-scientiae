[Page 711]

where I jk is the j,k element of the identity matrix. Because p ( x k = 1) = µ k , the parameters must satisfy 0 µ k 1 and k µ k = 1 . The multinomial distribution is a multivariate generalization of the binomial and gives the distribution over counts m k for a K -state discrete variable to be in state k given a total number of observations N .

$$
\ n _ { K } | \mu , N ) \ = \ \begin{pmatrix} N \\ m _ { 1 } m _ { 2 } \dots m _ { M } \end{pmatrix} \prod _ { k = 1 } ^ { M } \mu _ { k } ^ { m _ { k } } \quad ( B . 5 9 ) \\ \mathbb { E } [ m _ { k } ] \ = \ N \mu _ { k } \\ \text {var} [ m _ { k } ] \ = \ N \mu _ { k } ( 1 - \mu _ { k } ) \\ \text {ov} [ m _ { j } m _ { k } ] \ = \ - N \mu _ { j } \mu _ { k } \end{pmatrix}
$$

$$
M u l t ( m _ { 1 } , m _ { 2 } , \dots , m _ { K } | \mu , N ) \ = \ \binom { N } { m _ { 1 } m _ { 2 } \dots m _ { M } } \prod _ { k = 1 } ^ { M } \mu _ { k } ^ { m _ { k } } \ \ ( B . 5 9 )
$$

$$
\mathbb { E } [ m _ { k } ] \ = \ N \mu _ { k }
$$

$$
\ v a r [ m _ { k } ] \ = \ N \mu _ { k } ( 1 - \mu _ { k } )
$$

$$
c o v [ m _ { j } m _ { k } ] \ = \ - N \mu _ { j } \mu _ { k }
$$

where µ = ( µ 1 ,...,µ K ) T , and the quantity

$$
0 , \frac { N } { m _ { 1 } m _ { 2 } \dots m _ { K } } ) = \frac { N ! } { m _ { 1 } ! \dots m _ { K } ! }
$$

gives the number of ways of taking N identical objects and assigning m k of them to bin k for k = 1 ,...,K . The value of µ k gives the probability of the random variable taking state k , and so these parameters are subject to the constraints 0 µ k 1 and k µ k = 1 . The conjugate prior distribution for the parameters { µ k } is the Dirichlet.

# Normal

The normal distribution is simply another name for the Gaussian. In this book, we use the term Gaussian throughout, although we retain the conventional use of the symbol N to denote this distribution. For consistency, we shall refer to the normalgamma distribution as the Gaussian-gamma distribution, and similarly the normalWishart is called the Gaussian-Wishart.

![image 348](../images/imageFile348.png)

# Student’s t

This distribution was published by William Gosset in 1908, but his employer, Guiness Breweries, required him to publish under a pseudonym, so he chose ‘Student’. In the univariate form, Student’s t-distribution is obtained by placing a conjugate gamma prior over the precision of a univariate Gaussian distribution and then integrating out the precision variable. It can therefore be viewed as an inﬁnite mixture
