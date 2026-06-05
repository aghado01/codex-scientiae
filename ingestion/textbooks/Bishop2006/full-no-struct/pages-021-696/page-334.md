[Page 334]

![The image is a graph that depicts the behavior of a function, specifically a sine function, with a specific set of parameters. The graph is defined by two sets of points: the x-axis and the y-axis. The x-axis is labeled with the values 0 and 1, while the y-axis is labeled with the values 0.5 and 0.5. The graph shows a sinusoidal function, which is a type of function that has a general shape with a minimum at the origin (0, 0) and a maximum at the origin (1, 1). The function is defined by a sine function, which is a type of function that has a sine function. The sine function is defined by the equation: f(x) = a * sin(b * x) where a is the amplitude, b is the phase shift, and x is the variable. The amplitude of the sine function is](../images/imageFile141.png)

1

10

5

0.75

0

0.5

−5

0.25

-10

0

-1

−0.5

0

0.5

1

-1

−0.5

0

0.5

1

Figure 6.11 The left plot shows a sample from a Gaussian process prior over functions a ( x ) , and the right plot shows the result of transforming this sample using a logistic sigmoid function.

$$
p ( t | a ) = \sigma ( a ) ^ { t } ( 1 - \sigma ( a ) ) ^ { 1 - t } .
$$

As usual, we denote the training set inputs by x 1 ,..., x N with corresponding observed target variables t = ( t 1 ,...,t N ) T . We also consider a single test point x N +1 with target value t N +1 . Our goal is to determine the predictive distribution p ( t N +1 | t ) , where we have left the conditioning on the input variables implicit. To do this we introduce a Gaussian process prior over the vector a N +1 , which has components a ( x 1 ) ,...,a ( x N +1 ) . This in turn deﬁnes a non-Gaussian process over t N +1 , and by conditioning on the training data t N we obtain the required predictive distribution. The Gaussian process prior for a N +1 takes the form

$$
p ( a _ { N + 1 } ) = \mathcal { N } ( a _ { N + 1 } | 0 , C _ { N + 1 } ) .
$$

Unlike the regression case, the covariance matrix no longer includes a noise term because we assume that all of the training data points are correctly labelled. However, for numerical reasons it is convenient to introduce a noise-like term governed by a parameter ν that ensures that the covariance matrix is positive deﬁnite. Thus the covariance matrix C N +1 has elements given by

$$
C ( x _ { n } , x _ { m } ) = k ( x _ { n } , x _ { m } ) + \nu \delta _ { n m }
$$

where k ( x n , x m ) is any positive semideﬁnite kernel function of the kind considered in Section 6.2, and the value of ν is typically ﬁxed in advance. We shall assume that the kernel function k ( x , x ) is governed by a vector θ of parameters, and we shall later discuss how θ may be learned from the training data.

For two-class problems, it is sufﬁcient to predict p ( t N +1 = 1 | t N ) because the value of p ( t N +1 = 0 | t N ) is then given by 1 − p ( t N +1 = 1 | t N ) . The required
