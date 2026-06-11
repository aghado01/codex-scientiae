[Page 544]

Figure 11.1 Schematic illustration of a function f ( z ) whose expectation is to be evaluated with respect to a distribution p ( z ) .

![The image consists of a graph with two lines. The graph is titled p(z) and f(z). The x-axis is labeled as p(z) and the y-axis is labeled as f(z). The graph shows two lines, one that starts at the point (0, 0) and extends to the right, and another line that starts at the point (0, 0) and extends to the left. The line that starts at the point (0, 0) is labeled as p(z) and the line that starts at the point (0, 0) is labeled as f(z).](../images/imageFile253.png)

f

(

z

)

p

(

z

)

z

# Exercise 11.1

$$
\mathbb { E } [ f ] & = \int f ( z ) p ( z ) \, d z \\ \intertext { l a r \, e x p a l } \mathbb { E } [ f ] & = \int f ( z ) p ( z ) \, d z & ( 1 1 . 1 ) \\
$$

where the integral is replaced by summation in the case of discrete variables. This is illustrated schematically for a single continuous variable in Figure 11.1. We shall suppose that such expectations are too complex to be evaluated exactly using analytical techniques. ( l )

The general idea behind sampling methods is to obtain a set of samples z (where l = 1 ,...,L ) drawn independently from the distribution p ( z ) . This allows the expectation (11.1) to be approximated by a ﬁnite sum

$$
\widehat { f } = \frac { 1 } { L } \sum _ { l = 1 } ^ { L } f ( z ^ { ( l ) } ) . \\ z ^ { ( l ) } \text { are drawn from the distribution } p ( z ) , \text { then } \mathbb { E } [ \widehat { f } ] = \mathbb { E } [ f ]
$$

As long as the samples z ( l ) are drawn from the distribution p ( z ) , then E [ f ] = E [ f ] and so the estimator f has the correct mean. The variance of the estimator is given by var[ f ] = 1 L E ( f − E [ f ]) 2 (11.3)

$$
var [ \widehat { f } ] = \frac { 1 } { L } \mathbb { E } \left [ ( f - \mathbb { E } [ f ] ) ^ { 2 } \right ] \\ \intertext { t h e f u n c t i o n } \alpha y \, o f t h e \text { estimator therefore does not depend on the dimension-}
$$

is the variance of the function f ( z ) under the distribution p ( z ) . It is worth emphasizing that the accuracy of the estimator therefore does not depend on the dimensionality of z , and that, in principle, high accuracy may be achievable with a relatively small number of samples z ( l ) . In practice, ten or twenty independent samples may sufﬁce to estimate an expectation to sufﬁcient accuracy. ( l )

The problem, however, is that the samples { z } might not be independent, and so the effective sample size might be much smaller than the apparent sample size. Also, referring back to Figure 11.1, we note that if f ( z ) is small in regions where p ( z ) is large, and vice versa, then the expectation may be dominated by regions of small probability, implying that relatively large sample sizes will be required to achieve sufﬁcient accuracy.

For many models, the joint distribution p ( z ) is conveniently speciﬁed in terms of a graphical model. In the case of a directed graph with no observed variables, it is
