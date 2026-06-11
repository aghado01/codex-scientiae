[Page 92]

![The image presents a graph with two main axes: the x-axis and the y-axis. The x-axis is labeled as a = 0.1 and the y-axis is labeled as b = 0.1. The graph is a line graph with a linear scale of range 0.0 to 0.5 on the y-axis, and a linear scale of range 0.05 to 0.5 on the x-axis. The line on the graph is a straight line with a minimum value of 0.05 and a maximum value of 0.05. The line is relatively steep, indicating a high degree of curvature.](../images/imageFile41.png)

3

3

a

= 1

a

=0

.

1

b

= 1

b

=0

.

1

2

2

1

1

0

0

0

0.5

1

0

0.5

1

µ

µ

3

3

a

= 2

a

= 8

b

= 3

b

= 4

2

2

1

1

0

0

0

0.5

1

0

0.5

1

µ

µ

Figure 2.2 Plots of the beta distribution Beta( µ | a, b ) given by (2.13) as a function of µ for various values of the hyperparameters a and b .

where l = N − m , and therefore corresponds to the number of ‘tails’ in the coin example. We see that (2.17) has the same functional dependence on µ as the prior distribution, reﬂecting the conjugacy properties of the prior with respect to the likelihood function. Indeed, it is simply another beta distribution, and its normalization coefﬁcient can therefore be obtained by comparison with (2.13) to give

$$
p ( \mu | m , l , a , b ) = \frac { \Gamma ( m + a + l + b ) } { \Gamma ( m + a ) \Gamma ( l + b ) } \mu ^ { m + a - 1 } ( 1 - \mu ) ^ { l + b - 1 } .
$$

We see that the effect of observing a data set of m observations of x = 1 and l observations of x = 0 has been to increase the value of a by m , and the value of b by l , in going from the prior distribution to the posterior distribution. This allows us to provide a simple interpretation of the hyperparameters a and b in the prior as an effective number of observations of x = 1 and x = 0 , respectively. Note that a and b need not be integers. Furthermore, the posterior distribution can act as the prior if we subsequently observe additional data. To see this, we can imagine taking observations one at a time and after each observation updating the current posterior
