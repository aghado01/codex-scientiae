[Page 171]

Figure 3.6 Plot of squared bias and variance, together with their sum, corresponding to the results shown in Figure 3.5. Also shown is the average test set error for a test data set size of 1000 points. The minimum value of (bias) 2 + variance occurs around ln λ = − 0 . 31 , which is close to the value that gives the minimum error on the test data.

on the test data.

![The image is a graph titled Ln A. The graph is a line graph with three lines, each representing different variables. The x-axis is labeled ln(\gamma) and the y-axis is labeled ln(\gamma). The graph is titled Ln A and has a legend at the bottom of the graph that indicates the following: - The blue line represents bias - The red line represents variance - The pink line represents test error The graph has a scale from 0.03 to 0.15 on the y-axis, labeled ln(\gamma) and ln(\gamma). The x-axis is labeled ln(\gamma) and has a scale from -3 to 1. The graph has three lines: 1. The blue line represents bias 2. The red line represents variance](../images/imageFile78.png)

0.15

2

(bias) 2

0.12

variance 2

2

(bias)

variance

test error

0.09

0.06

0.03

0

-3

−2

−1

0

1

2

ln λ

λ

ﬁt a model with 24 Gaussian basis functions by minimizing the regularized error function (3.27) to give a prediction function y ( l ) ( x ) as shown in Figure 3.5. The top row corresponds to a large value of the regularization coefﬁcient λ that gives low variance (because the red curves in the left plot look similar) but high bias (because the two curves in the right plot are very different). Conversely on the bottom row, for which λ is small, there is large variance (shown by the high variability between the red curves in the left plot) but low bias (shown by the good ﬁt between the average model ﬁt and the original sinusoidal function). Note that the result of averaging many solutions for the complex model with M = 25 is a very good ﬁt to the regression function, which suggests that averaging may be a beneﬁcial procedure. Indeed, a weighted averaging of multiple solutions lies at the heart of a Bayesian approach, although the averaging is with respect to the posterior distribution of parameters, not with respect to multiple data sets.

We can also examine the bias-variance trade-off quantitatively for this example. The average prediction is estimated from

$$
\bar { y } ( x ) = \frac { 1 } { L } \sum _ { l = 1 } ^ { L } y ^ { ( l ) } ( x ) \\ \intertext { a r e d } \int a r i g h a n d i n t e r g u n d e r y a n c e r y \, a r e t h e n g i v e n b y
$$

and the integrated squared bias and integrated variance are then given by

$$
( \text {bias} ) ^ { 2 } \ = \ \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \{ \overline { y } ( x _ { n } ) - h ( x _ { n } ) \} ^ { 2 } \\
$$

$$
\variaince \ = \ \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \frac { 1 } { L } \sum _ { l = 1 } ^ { L } \{ y ^ { ( l ) } ( x _ { n } ) - \bar { y } ( x _ { n } ) \} ^ { 2 } \\ \intertext { r e the integral o r } \intertext { e r the integral o r } \intertext { x e w e i t h e d i s t r i o n } \intertext { p h e r a m p a s }
$$

where the integral over x weighted by the distribution p ( x ) is approximated by a ﬁnite sum over data points drawn from that distribution. These quantities, along with their sum, are plotted as a function of ln λ in Figure 3.6. We see that small values of λ allow the model to become ﬁnely tuned to the noise on each individual
