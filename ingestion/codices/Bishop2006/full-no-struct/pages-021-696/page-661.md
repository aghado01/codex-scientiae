[Page 661]

# Figure 13.22

An illustration of a linear dynamical system being used to track a moving object. The blue points indicate the true positions of the object in a two-dimensional space at successive time steps, the green points denote noisy measurements of the positions, and the red crosses indicate the means of the inferred posterior distributions of the positions obtained by running the Kalman ﬁltering equations. The covariances of the inferred positions are indicated by the red ellipses, which correspond to contours having one standard deviation.

![In this image, we can see a diagram with some text and some colorful shapes.](../images/imageFile322.png)

Exercise 13.29

Exercise 13.31

̂ β ( z n ) , which, for continuous latent variables, can be written in the form

$$
\beta ( z _ { n } ) , \text { which, for continuous latent variables, can be written in the form } \\ c _ { n + 1 } \widehat { \beta } ( z _ { n } ) = \int \widehat { \beta } ( z _ { n + 1 } ) p ( x _ { n + 1 } | z _ { n + 1 } ) p ( z _ { n + 1 } | z _ { n } ) \, d z _ { n + 1 } . \\ \\ \text {We now multiply both sides of (13.99) by } \widehat { \alpha } ( z _ { n } ) \text { and substitute for } p ( x _ { n + 1 } | z _ { n + 1 } ) \\ \text {and } p ( z _ { n + 1 } | z _ { n } ) \, \text {using } ( 1 3 . 7 5 ) \text { and } ( 1 3 . 7 6 ) . \text { Then we make use of } ( 1 3 . 8 9 ) , \, ( 1 3 . 9 0 )
$$

We now multiply both sides of (13.99) by α ( z n ) and substitute for p ( x n +1 | z n +1 ) and p ( z n +1 | z n ) using (13.75) and (13.76). Then we make use of (13.89), (13.90) and (13.91), together with (13.98), and after some manipulation we obtain

$$
\text {, together with (13.98), and after some manipulation we obtain} \\ \widehat { \mu } _ { n } \ = \ \mu _ { n } + J _ { n } \left ( \widehat { \mu } _ { n + 1 } - A \mu _ { N } \right ) & & ( 1 3 . 1 0 0 ) \\ \widehat { V } _ { n } \ = \ V _ { n } + J _ { n } \left ( \widehat { V } _ { n + 1 } - P _ { n } \right ) J _ { n } ^ { T } & & ( 1 3 . 1 0 1 ) \\ \intertext { a v e d i n f e d } J _ { n } = V _ { n } A ^ { T } \left ( P _ { n } \right ) ^ { - 1 } & & ( 1 3 . 1 0 2 )
$$

where we have deﬁned

$$
J _ { n } = V _ { n } A ^ { \top } ( P _ { n } ) ^ { - 1 }
$$

and we have made use of AV n = P n J T n . Note that these recursions require that the forward pass be completed ﬁrst so that the quantities µ n and V n will be available for the backward pass.

For the EM algorithm, we also require the pairwise posterior marginals, which can be obtained from (13.65) in the form

$$
\text { can be obtained from (15.63) in the form } \\ \xi ( z _ { n - 1 } , z _ { n } ) = ( c _ { n } ) ^ { - 1 } \widehat { \alpha } ( z _ { n - 1 } ) p ( x _ { n } | z _ { n } ) p ( z _ { n } | z _ { - 1 } ) \widehat { \beta } ( z _ { n } ) \\ = \sqrt { \frac { \mathcal { N } ( z _ { n - 1 } | \mu _ { n - 1 } , V _ { n - 1 } ) \mathcal { N } ( z _ { n } | A z _ { n - 1 } , \Gamma ) \mathcal { N } ( x _ { n } | C z _ { n } , \Sigma ) \mathcal { N } ( z _ { n } | \widehat { \mu } _ { n } , \widehat { V } _ { n } ) } { c _ { n } \widehat { \alpha } ( z _ { n } ) } } . \\ \\ \text {Substituting for } \widehat { \alpha } ( z _ { n } ) \text { using } ( 1 3 . 8 4 ) \text { and rearranging, we see that } \xi ( z _ { n - 1 } , z _ { n } ) \text { is a } \\ \text {Gaussian with mean given with components } \gamma ( z _ { n - 1 } ) \text { and } \gamma ( z _ { n } ) , \text { and a covariance }
$$

Substituting for α ( z n ) using (13.84) and rearranging, we see that ξ ( z n − 1 , z n ) is a Gaussian with mean given with components γ ( z n − 1 ) and γ ( z n ) , and a covariance between z n and z n − 1 given by

$$
c o v [ z _ { n } , z _ { n - 1 } ] = J _ { n - 1 } \widehat { V } _ { n } .
$$
