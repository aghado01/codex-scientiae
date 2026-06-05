[Page 492]

![The image consists of four different colored circles arranged in a grid pattern. Each circle is colored green, and each circle has a different size. The circles are arranged in a grid, with each circle occupying a specific space in the grid. The colors of the circles are as follows: 1. **Green Circle (a)** - The green circle is located at the top-left corner of the grid. - The green circle is a perfect circle, with no gaps or indentations. 2. **Green Circle (b)** - The green circle is located at the top-right corner of the grid. - The green circle is a perfect circle, with no gaps or indentations. 3. **Green Circle (c)** - The green circle is located at the bottom-left corner of the grid. - The green circle is a perfect circle, with no gaps or indentations. 4. **Green Circle (d)** - The green circle is](../images/imageFile236.png)

2

2

(a)

(b)

τ

τ

1

1

0

0

µ

µ

-1

0

1

-1

0

1

2

2

(c)

(d)

τ

τ

1

1

0

0

µ

µ

-1

0

1

-1

0

1

Figure 10.4 Illustration of variational inference for the mean µ and precision τ of a univariate Gaussian distribution. Contours of the true posterior distribution p ( µ, τ | D ) are shown in green. (a) Contours of the initial factorized approximation q µ ( µ ) q τ ( τ ) are shown in blue. (b) After re-estimating the factor q µ ( µ ) . (c) After re-estimating the factor q τ ( τ ) . (d) Contours of the optimal factorized approximation, to which the iterative scheme converges, are shown in red.

Appendix B

In general, we will need to use an iterative approach such as this in order to solve for the optimal factorized posterior distribution. For the very simple example we are considering here, however, we can ﬁnd an explicit solution by solving the simultaneous equations for the optimal factors q µ ( µ ) and q τ ( τ ) . Before doing this, we can simplify these expressions by considering broad, noninformative priors in which µ 0 = a 0 = b 0 = λ 0 = 0 . Although these parameter settings correspond to improper priors, we see that the posterior distribution is still well deﬁned. Using the standard result E [ τ ] = a N /b N for the mean of a gamma distribution, together with (10.29) and (10.30), we have

$$
( 1 0 . 2 9 ) \, \text {and} \, ( 1 0 . 3 0 ) , \, \text {we have} \\ \frac { 1 } { \mathbb { E } [ \tau ] } = \mathbb { E } \left [ \frac { 1 } { N } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } \right ] = \overline { x ^ { 2 } } - 2 \overline { x } \mathbb { E } [ \mu ] + \mathbb { E } [ \mu ^ { 2 } ] . \quad ( 1 0 . 3 1 ) \\ \text {Then using } ( 1 0 . 2 6 ) \, \text {and} \, ( 1 0 . 2 7 ) \, \text { we obtain the first and second order moments of}
$$

Then, using (10.26) and (10.27), we obtain the ﬁrst and second order moments of
