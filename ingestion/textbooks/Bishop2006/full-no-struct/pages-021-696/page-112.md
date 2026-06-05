[Page 112]

Similarly, we can ﬁnd the mean of the Gaussian distribution over z by identifying the linear terms in (2.102), which are given by

$$
x ^ { T } \Lambda \mu - x ^ { T } A ^ { T } L b + y ^ { T } L b & = \begin{pmatrix} x \\ y \end{pmatrix} ^ { T } \begin{pmatrix} \Lambda \mu - A ^ { T } L b \\ L b \end{pmatrix} . \quad ( 2 . 1 0 6 ) \\ U \sin g o r e r i l y r e c u l t ( 2 7 1 ) o b t i a n d b y c o n p l e t i n g t h e s u r a r e v o r t h e w a r d r a t i c
$$

Using our earlier result (2.71) obtained by completing the square over the quadratic form of a multivariate Gaussian, we ﬁnd that the mean of z is given by

$$
\frac { \mathbb { E } [ z ] = R ^ { - 1 } \begin{pmatrix} \Lambda \mu - A ^ { T } L b \\ L b \end{pmatrix} . } { ( 2 . 1 0 7 ) } \quad ( 2 . 1 0 7 ) \\
$$

Making use of (2.105), we then obtain Exercise 2.30

$$
0 , \, w \text { then } 0 \text { at } \phi
$$

Next we ﬁnd an expression for the marginal distribution p ( y ) in which we have marginalized over x . Recall that the marginal distribution over a subset of the components of a Gaussian random vector takes a particularly simple form when expressed in terms of the partitioned covariance matrix. Speciﬁcally, its mean and covariance are given by (2.92) and (2.93), respectively. Making use of (2.105) and (2.108) we see that the mean and covariance of the marginal distribution p ( y ) are given by

Section 2.3

Section 2.3

$$
\mathbb { E } [ y ] \ = \ A \mu + b
$$

$$
c o v [ y ] \ = \ L ^ { - 1 } + A \Lambda ^ { - 1 } A ^ { T } .
$$

A special case of this result is when A = I , in which case it reduces to the convolution of two Gaussians, for which we see that the mean of the convolution is the sum of the mean of the two Gaussians, and the covariance of the convolution is the sum of their covariances.

Finally, we seek an expression for the conditional p ( x | y ) . Recall that the results for the conditional distribution are most easily expressed in terms of the partitioned precision matrix, using (2.73) and (2.75). Applying these results to (2.105) and (2.108) we see that the conditional distribution p ( x | y ) has mean and covariance given by

$$
\begin{array} { r l r } { \text {given by} } & { \in } & { \mathbb { E } [ x | y ] } & { = } & { ( \Lambda + A ^ { T } L A ) ^ { - 1 } \{ A ^ { T } L ( y - b ) + \Lambda \mu \} } & { ( 2 . 1 1 ) } \\ & { \text {cov} [ x | y ] } & { = } & { ( \Lambda + A ^ { T } L A ) ^ { - 1 } . } & { ( 2 . 1 2 ) } \\ { \text {The evolution of this condition} ] { \text {can be seen as an example of Roves' theorem} } } \end{array}
$$

The evaluation of this conditional can be seen as an example of Bayes’ theorem. We can interpret the distribution p ( x ) as a prior distribution over x . If the variable y is observed, then the conditional distribution p ( x | y ) represents the corresponding posterior distribution over x . Having found the marginal and conditional distributions, we effectively expressed the joint distribution p ( z ) = p ( x ) p ( y | x ) in the form p ( x | y ) p ( y ) . These results are summarized below.
