[Page 325]

x 1 ,..., x N . We are therefore interested in the joint distribution of the function values y ( x 1 ) ,...,y ( x N ) , which we denote by the vector y with elements y n = y ( x n ) for n = 1 ,...,N . From (6.49), this vector is given by

$$
\gamma = \Phi w
$$

where Φ is the design matrix with elements Φ nk = φ k ( x n ) . We can ﬁnd the probability distribution of y as follows. First of all we note that y is a linear combination of Gaussian distributed variables given by the elements of w and hence is itself Gaussian. We therefore need only to ﬁnd its mean and covariance, which are given from (6.50) by

$$
\mathbb { E } [ \mathbf y ] \ = \ \Phi \mathbb { E } [ w ] = 0
$$

$$
\mathbb { E } [ y ] \ = \ \Phi \mathbb { E } [ w ] = 0 \\ \intertext { c o v [ y ] } \ \intertext { w h e r e } \ \intertext { K is the G r a m i t r i x } \ \intertext { w h e r e } \ \intertext { K is the G r a m i t r i x }
$$

where K is the Gram matrix with elements

$$
K _ { n m } = k ( x _ { n } , x _ { m } ) = \frac { 1 } { \alpha } \phi ( x _ { n } ) ^ { T } \phi ( x _ { m } )
$$

and k ( x , x ) is the kernel function.

This model provides us with a particular example of a Gaussian process. In general, a Gaussian process is deﬁned as a probability distribution over functions y ( x ) such that the set of values of y ( x ) evaluated at an arbitrary set of points x 1 ,..., x N jointly have a Gaussian distribution. In cases where the input vector x is two dimensional, this may also be known as a Gaussian random ﬁeld . More generally, a stochastic process y ( x ) is speciﬁed by giving the joint probability distribution for any ﬁnite set of values y ( x 1 ) ,...,y ( x N ) in a consistent manner. A key point about Gaussian stochastic processes is that the joint distribution

over N variables y 1 ,...,y N is speciﬁed completely by the second-order statistics, namely the mean and the covariance. In most applications, we will not have any prior knowledge about the mean of y ( x ) and so by symmetry we take it to be zero. This is equivalent to choosing the mean of the prior over weight values p ( w | α ) to be zero in the basis function viewpoint. The speciﬁcation of the Gaussian process is then completed by giving the covariance of y ( x ) evaluated at any two values of x , which is given by the kernel function

$$
\mathbb { E } \left [ y ( x _ { n } ) y ( x _ { m } ) \right ] = k ( x _ { n } , x _ { m } ) .
$$

For the speciﬁc case of a Gaussian process deﬁned by the linear regression model (6.49) with a weight prior (6.50), the kernel function is given by (6.54).

We can also deﬁne the kernel function directly, rather than indirectly through a choice of basis function. Figure 6.4 shows samples of functions drawn from Gaussian processes for two different choices of kernel function. The ﬁrst of these is a ‘Gaussian’ kernel of the form (6.23), and the second is the exponential kernel given by

$$
k ( x , x ^ { \prime } ) = \exp \left ( - \theta \left | x - x ^ { \prime } \right | \right ) \\ \text {ds to the QRnset in} \, U l h e n b e c k \, r o c e s \, \text {originally introduced by} \, U l h \bar { \cdot }
$$

which corresponds to the Ornstein-Uhlenbeck process originally introduced by Uhlenbeck and Ornstein (1930) to describe Brownian motion.
