[Page 110]

![The image is a graph with two axes labeled as x and y. The x-axis is labeled as 0 and the y-axis is labeled as 0. There are two lines on the graph, one is a straight line with a slope of 0.7 and the other is a curve with a slope of 0.7. The line on the graph is a straight line with a slope of 0.7. The curve on the graph is a curve with a slope of 0.7.](../images/imageFile50.png)

1

10

x

b

|

x

=0

.

7.

p

(

x

a

b

x

=0

.

7

b

0.5

5

p

(

x

, x

)

a

b

p

(

x

)

a

0

0

0

0.5

1

0

0.5

1

x

x

a

a

Figure 2.9 The plot on the left shows the contours of a Gaussian distribution p ( x a , x b ) over two variables, and the plot on the right shows the marginal distribution p ( x a ) (blue curve) and the conditional distribution p ( x a | x b ) for x b = 0 . 7 (red curve).

$$
\Sigma = \begin{pmatrix} \Sigma _ { a a } & \Sigma _ { a b } \\ \Sigma _ { b a } & \Sigma _ { b b } \end{pmatrix} , \quad \Lambda = \begin{pmatrix} \Lambda _ { a a } & \Lambda _ { a b } \\ \Lambda _ { b a } & \Lambda _ { b b } \end{pmatrix} .
$$

Conditional distribution:

$$
p ( x _ { a } | x _ { b } ) \ = \ \mathcal { N } ( x | \mu _ { a | b } , \Lambda _ { a a } ^ { - 1 } ) \\ \\
$$

$$
\mu _ { a | b } \ = \ \mu _ { a } - \Lambda _ { a a } ^ { - 1 } \Lambda _ { a b } ( x _ { b } - \mu _ { b } ) .
$$

Marginal distribution:

$$
p ( x _ { a } ) = \mathcal { N } ( x _ { a } | \mu _ { a } , \Sigma _ { a a } ) .
$$

We illustrate the idea of conditional and marginal distributions associated with a multivariate Gaussian using an example involving two variables in Figure 2.9.

# 2.3.3 Bayes’ theorem for Gaussian variables

In Sections 2.3.1 and 2.3.2, we considered a Gaussian p ( x ) in which we partitioned the vector x into two subvectors x = ( x a , x b ) and then found expressions for the conditional distribution p ( x a | x b ) and the marginal distribution p ( x a ) . We noted that the mean of the conditional distribution p ( x a | x b ) was a linear function of x b . Here we shall suppose that we are given a Gaussian marginal distribution p ( x ) and a Gaussian conditional distribution p ( y | x ) in which p ( y | x ) has a mean that is a linear function of x , and a covariance which is independent of x . This is an example of
