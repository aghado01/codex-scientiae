[Page 49]

Figure 1.16 Schematic illustration of a Gaussian conditional distribution for t given x given by (1.60), in which the mean is given by the polynomial function y ( x, w ) , and the precision is given by the parameter β , which is related to the variance by β − 1 = σ 2 .

![The image depicts a graph with two lines, labeled as y(x, w) and y(x, w). The x-axis is labeled as t and the y-axis is labeled as w. The graph is a curve that starts at the point (0, 0) and extends upwards to the right. The line on the graph starts at the point (0, 0) and extends to the right, then it starts at the point (0, 0) and extends to the right again. The line then starts at the point (0, 0) and extends to the right again, then it starts at the point (0, 0) and extends to the right again. The line then starts at the point (0, 0) and extends to the right again, then it starts at the point (0, 0) and extends to the right again. The line then starts at the point (0, 0) and](../images/imageFile21.png)

t

y

(

x,

)

w

,

)

y

(

x

2

σ

0

w

|

p

(

t

x

,

, β

)

0

w

x

x

0

We now use the training data { x , t } to determine the values of the unknown parameters w and β by maximum likelihood. If the data are assumed to be drawn independently from the distribution (1.60), then the likelihood function is given by

$$
p ( t | x , w , \beta ) = \prod _ { n = 1 } ^ { N } \mathcal { N } \left ( t _ { n } | y ( x _ { n } , w ) , \beta ^ { - 1 } \right ) . \\ \intertext { d i n the case of the simple Gaussian distribution earlier, it is convenient to }
$$

As we did in the case of the simple Gaussian distribution earlier, it is convenient to maximize the logarithm of the likelihood function. Substituting for the form of the Gaussian distribution, given by (1.46), we obtain the log likelihood function in the form

$$
\ln p ( t | x , w , \beta ) = - \frac { \beta } { 2 } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w ) - t _ { n } \} ^ { 2 } + \frac { N } { 2 } \ln \beta - \frac { N } { 2 } \ln ( 2 \pi ) . \quad ( 1 . 6 2 ) \\ \intertext { \text {Consider first the determination of the maximum likelihood solution for the polyno-} }
$$

Consider ﬁrst the determination of the maximum likelihood solution for the polynomial coefﬁcients, which will be denoted by w ML . These are determined by maximizing (1.62) with respect to w . For this purpose, we can omit the last two terms on the right-hand side of (1.62) because they do not depend on w . Also, we note that scaling the log likelihood by a positive constant coefﬁcient does not alter the location of the maximum with respect to w , and so we can replace the coefﬁcient β/ 2 with 1 / 2 . Finally, instead of maximizing the log likelihood, we can equivalently minimize the negative log likelihood. We therefore see that maximizing likelihood is equivalent, so far as determining w is concerned, to minimizing the sum-of-squares error function deﬁned by (1.2). Thus the sum-of-squares error function has arisen as a consequence of maximizing likelihood under the assumption of a Gaussian noise distribution.

We can also use maximum likelihood to determine the precision parameter β of the Gaussian conditional distribution. Maximizing (1.62) with respect to β gives

$$
\frac { 1 } { \beta _ { M L } } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , \mathbf w _ { M L } ) - t _ { n } \} ^ { 2 } .
$$
