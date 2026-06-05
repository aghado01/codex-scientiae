[Page 156]

where denotes the real part, prove (2.178). Finally, by using sin( A − B ) = exp { i ( A − B ) } , where denotes the imaginary part, prove the result (2.183). ( ) For large , the von Mises distribution (2.179) becomes sharply peaked

2.52 m around the mode θ 0 . By deﬁning ξ = m 1 / 2 ( θ − θ 0 ) and making the Taylor expansion of the cosine function given by

$$
\cos \alpha = 1 - \frac { \alpha ^ { 2 } } { 2 } + O ( \alpha ^ { 4 } ) \\
$$

show that as m →∞ , the von Mises distribution tends to a Gaussian.

- 2.53 ( /star ) Using the trigonometric identity (2.183), show that solution of (2.182) for θ 0 is given by (2.184).
- 2.54 ( ) By computing ﬁrst and second derivatives of the von Mises distribution (2.179), and using I 0 ( m ) > 0 for m > 0 , show that the maximum of the distribution occurs when θ = θ 0 and that the minimum occurs when θ = θ 0 + π (mod2 π ) .
- 2.55 ( ) By making use of the result (2.168), together with (2.184) and the trigonometric identity (2.178), show that the maximum likelihood solution m ML for the concentration of the von Mises distribution satisﬁes A ( m ML ) = r where r is the radius of the mean of the observations viewed as unit vectors in the two-dimensional Euclidean plane, as illustrated in Figure 2.17.
- 2.56 ( ) www Express the beta distribution (2.13), the gamma distribution (2.146), and the von Mises distribution (2.179) as members of the exponential family (2.194) and thereby identify their natural parameters.
- 2.57 ( ) Verify that the multivariate Gaussian distribution can be cast in exponential family form (2.194) and derive expressions for η , u ( x ) , h ( x ) and g ( η ) analogous to (2.220)–(2.223).
- 2.58 ( ) The result (2.226) showed that the negative gradient of ln g ( η ) for the exponential family is given by the expectation of u ( x ) . By taking the second derivatives of (2.195), show that

$$
- \nabla \ln g ( \eta ) = \mathbb { E } [ u ( x ) u ( x ) ^ { T } ] - \mathbb { E } [ u ( x ) ] \mathbb { E } [ u ( x ) ^ { T } ] = c o v [ u ( x ) ] . \quad ( 2 . 3 0 0 )
$$

- 2.59 ( ) By changing variables using y = x/σ , show that the density (2.236) will be correctly normalized, provided f ( x ) is correctly normalized.
- 2.60 ( ) www Consider a histogram-like density model in which the space x is divided into ﬁxed regions for which the density p ( x ) takes the constant value h i over the i th region, and that the volume of region i is denoted ∆ i . Suppose we have a set of N observations of x such that n i of these observations fall in region i . Using a Lagrange multiplier to enforce the normalization constraint on the density, derive an expression for the maximum likelihood estimator for the { h i } . 2.61 ( ) Show that the -nearest-neighbour density model deﬁnes an improper distribu-
- 2.61 ( /star ) Show that the K -nearest-neighbour density model defines an improper distribution whose integral over all space is divergent.
