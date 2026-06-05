[Page 593]

Exercise 12.8

where the D x D covariance matrix C is defined by

$$
C = W W ^ { T } + \sigma ^ { 2 } I .
$$

This result can also be derived more directly by noting that the predictive distribution will be Gaussian and then evaluating its mean and covariance using (12.33). This gives

$$
\begin{array} { r l } { \mathbb { E } [ x ] } & { = } & { \mathbb { E } [ W z + \mu + \epsilon ] = \mu } \\ { c o v [ x ] } & { = } & { \mathbb { E } \left [ ( W z + \epsilon ) ( W z + \epsilon ) ^ { T } \right ] } \\ & { = } & { \mathbb { E } \left [ W z z ^ { T } W ^ { T } \right ] + \mathbb { E } [ \epsilon \epsilon ^ { T } ] = W W ^ { T } + \sigma ^ { 2 } I } \end{array}
$$

$$
\mathbb { E } [ x ] \ = \ \mathbb { E } [ \mathbb { W } z + \mu + \epsilon ] = \mu
$$

$$
\ = \ \mathbb { E } \left [ \text {W} z z ^ { T } W ^ { T } \right ] + \mathbb { E } [ \epsilon \epsilon ^ { T } ] = \text {W} W ^ { T } + \sigma ^ { 2 } I \quad ( 1 2 . 3 8 )
$$

where we have used the fact that z and E are independent random variables and hence are uncorrelated.

Intuitively, we can think of the distribution p(x) as being defined by taking an isotropic Gaussian 'spray can' and moving it across the principal subspace spraying Gaussian ink with density determined by 02 and weighted by the prior distribution. The accumulated ink density gives rise to a 'pancake' shaped distribution representing the marginal density p(x). 2

The predictive distribution p( x) is governed by the parameters JL, W, and 0• However, there is redundancy in this parameterization corresponding to rotations of the latent space coordinates. To see this, consider a matrix W = WR where R is an orthogonal matrix. Using the orthogonality property RR T = I, we see that the quantity WW T that appears in the covariance matrix C takes the form

$$
\widetilde { W } \widetilde { W } ^ { T } = W R R ^ { T } W ^ { T } = W W ^ { T }
$$

and hence is independent of R. Thus there is a whole family of matrices W all of which give rise to the same predictive distribution. This invariance can be understood in terms of rotations within the latent space. We shall return to a discussion of the number of independent parameters in this model later. 1

When we evaluate the predictive distribution, we require C, which involves the inversion of a D x D matrix. The computation required to do this can be reduced by making use of the matrix inversion identity (C.7) to give

$$
C ^ { - 1 } = \sigma ^ { - 1 } I - \sigma ^ { - 2 } W M ^ { - 1 } W ^ { T }
$$

where the M x M matrix M is defined by

$$
M = W ^ { T } W + \sigma ^ { 2 } I .
$$

Because we invert M rather than inverting C directly, the cost of evaluating C1 is reduced from O(D 3 ) to O(M 3 ).

As well as the predictive distribution p(x), we will also require the posterior distributionp(zlx), which can again be written down directly using the result (2.116) for linear-Gaussian models to give

$$
p ( z | \mathbf x ) = \mathcal { N } \left ( z | M ^ { - 1 } W ^ { \top } ( \mathbf x - \mu ) , \sigma ^ { - 2 } M \right ) .
$$

Note that the posterior mean depends on x, whereas the posterior covariance is independent of x.
