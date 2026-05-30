# Exercises

## Contents

- [Exercises Preface](#exercises-preface)
- [1 Introduction Exercises](#1-introduction-exercises)
- [2 Probability Distributions Exercises](#2-probability-distributions-exercises)
- [3 Linear Models for Regression Exercises](#3-linear-models-for-regression-exercises)
- [4 Linear Models for Classification Exercises](#4-linear-models-for-classification-exercises)
- [5 Neural Networks Exercises](#5-neural-networks-exercises)
- [6 Kernel Methods Exercises](#6-kernel-methods-exercises)
- [7 Sparse Kernel Machines Exercises](#7-sparse-kernel-machines-exercises)
- [8 Graphical Models Exercises](#8-graphical-models-exercises)
- [9 Mixture Models and EM Exercises](#9-mixture-models-and-em-exercises)
- [10 Approximate Inference Exercises](#10-approximate-inference-exercises)
- [11 Sampling Methods Exercises](#11-sampling-methods-exercises)
- [12 Continuous Latent Variables Exercises](#12-continuous-latent-variables-exercises)
- [13 Sequential Data Exercises](#13-sequential-data-exercises)
- [14 Combining Models Exercises](#14-combining-models-exercises)

## Exercises Preface

The exercises that appear at the end of every chapter form an important component of the book. Each exercise has been carefully chosen to reinforce concepts explained in the text or to develop and generalize them in signiﬁcant ways, and each is graded according to difﬁculty ranging from ( ) , which denotes a simple exercise taking a few minutes to complete, through to ( ) , which denotes a signiﬁcantly more complex exercise.

It has been difﬁcult to know to what extent these solutions should be made widely available. Those engaged in self study will ﬁnd worked solutions very beneﬁcial, whereas many course tutors request that solutions be available only via the publisher so that the exercises may be used in class. In order to try to meet these conﬂicting requirements, those exercises that help amplify key points in the text, or that ﬁll in important details, have solutions that are available as a PDF ﬁle from the book web site. Such exercises are denoted by www . Solutions for the remaining exercises are available to course tutors by contacting the publisher (contact details are given on the book web site). Readers are strongly encouraged to work through the exercises unaided, and to turn to the solutions only as required.

Although this book focuses on concepts and principles, in a taught course the students should ideally have the opportunity to experiment with some of the key algorithms using appropriate data sets. A companion volume (Bishop and Nabney, 2008) will deal with practical aspects of pattern recognition and machine learning, and will be accompanied by Matlab software implementing most of the algorithms discussed in this book.

## 1 Introduction Exercises

1.1 ( ) www Consider the sum-of-squares error function given by (1.2) in which the function y ( x, w ) is given by the polynomial (1.1). Show that the coefﬁcients w = { w i } that minimize this error function are given by the solution to the following set of linear equations

$$
\sum _ { j = 0 } ^ { M } A _ { i j } w _ { j } = T _ { i }
$$

where

$$
A _ { i j } & = \sum _ { n = 1 } ^ { N } ( x _ { n } ) ^ { i + j } , & T _ { i } & = \sum _ { n = 1 } ^ { N } ( x _ { n } ) ^ { i } t _ { n } . & ( 1 . 1 2 3 ) \\ \intertext { a s f i x i or i d e n t o s the index of a component, whereas ( x ) ^ { i } denotes x raised } \intertext { a s f i x i or i d e n t o s the index of a component, whereas ( x ) ^ { i } denotes x raised }
$$

Here a sufﬁx i or j denotes the index of a component, whereas ( x ) i denotes x raised to the power of i .

1.2 ( ) Write down the set of coupled linear equations, analogous to (1.122), satisﬁed by the coefﬁcients w i which minimize the regularized sum-of-squares error function given by (1.4).

1.3 ( ) Suppose that we have three coloured boxes r (red), b (blue), and g (green). Box r contains 3 apples, 4 oranges, and 3 limes, box b contains 1 apple, 1 orange, and 0 limes, and box g contains 3 apples, 3 oranges, and 4 limes. If a box is chosen at random with probabilities p ( r ) = 0 . 2 , p ( b ) = 0 . 2 , p ( g ) = 0 . 6 , and a piece of fruit is removed from the box (with equal probability of selecting any of the items in the box), then what is the probability of selecting an apple? If we observe that the selected fruit is in fact an orange, what is the probability that it came from the green box?

1.4 ( ) www Consider a probability density p x ( x ) deﬁned over a continuous variable x , and suppose that we make a nonlinear change of variable using x = g ( y ) , so that the density transforms according to (1.27). By differentiating (1.27), show that the location y of the maximum of the density in y is not in general related to the location x of the maximum of the density over x by the simple functional relation x = g ( y ) as a consequence of the Jacobian factor. This shows that the maximum of a probability density (in contrast to a simple function) is dependent on the choice of variable. Verify that, in the case of a linear transformation, the location of the maximum transforms in the same way as the variable itself.

1.5 ( ) Using the deﬁnition (1.38) show that var[ f ( x )] satisﬁes (1.39).

1.6 ( ) Show that if two variables x and y are independent, then their covariance is zero.

1.7 ( ) www In this exercise, we prove the normalization condition (1.48) for the univariate Gaussian. To do this consider, the integral

$$
I & = \int _ { - \infty } ^ { \infty } \exp \left ( - \frac { 1 } { 2 \sigma ^ { 2 } } x ^ { 2 } \right ) \, d x & & ( 1 . 1 2 4 ) \\
$$

which we can evaluate by ﬁrst writing its square in the form

$$
I ^ { 2 } = \int _ { - \infty } ^ { \infty } \int _ { - \infty } ^ { \infty } \exp \left ( - \frac { 1 } { 2 \sigma ^ { 2 } } x ^ { 2 } - \frac { 1 } { 2 \sigma ^ { 2 } } y ^ { 2 } \right ) \, d x \, d y . \\
$$

Now make the transformation from Cartesian coordinates ( x,y ) to polar coordinates ( r,θ ) and then substitute u = r 2 . Show that, by performing the integrals over θ and u , and then taking the square root of both sides, we obtain

$$
I & = ( 2 \pi \sigma ^ { 2 } ) ^ { 1 / 2 } \, . & ( 1 . 1 2 6 ) \\ \intertext { s o w t h a t h e the Gaussian distribution }
$$

Finally, use this result to show that the Gaussian distribution N ( x | µ,σ 2 ) is normalized.

1.8 ( ) www By using a change of variables, verify that the univariate Gaussian distribution given by (1.46) satisﬁes (1.49). Next, by differentiating both sides of the normalization condition

$$
\int _ { - \infty } ^ { \infty } \mathcal { N } \left ( x | \mu , \sigma ^ { 2 } \right ) \, d x & = 1 & ( 1 . 1 2 7 ) \\ \intertext { v i r f y } \text { verify that the Gaussian satisfies } ( 1 . 5 0 ) . \text { Finally, show that } ( 1 . 5 1 )
$$

with respect to σ 2 , verify that the Gaussian satisﬁes (1.50). Finally, show that (1.51) holds.

1.9 ( ) www Show that the mode (i.e. the maximum) of the Gaussian distribution (1.46) is given by µ . Similarly, show that the mode of the multivariate Gaussian (1.52) is given by µ .

1.10 ( ) www Suppose that the two variables x and z are statistically independent. Show that the mean and variance of their sum satisﬁes

$$
\mathbb { E } [ x + z ] \ = \ \mathbb { E } [ x ] + \mathbb { E } [ z ]
$$

$$
\ v a r [ x + z ] \ = \ v a r [ x ] + v a r [ z ] .
$$

#### Exercise 1.11

By setting the derivatives of the log likelihood function (1.54) with respect to µ and σ 2 equal to zero, verify the results (1.55) and (1.56).

1.12 ( ) www Using the results (1.49) and (1.50), show that

$$
\mathbb { E } [ x _ { n } x _ { m } ] = \mu ^ { 2 } + I _ { n m } \sigma ^ { 2 }
$$

where x n and x m denote data points sampled from a Gaussian distribution with mean µ and variance σ 2 , and I nm satisﬁes I nm = 1 if n = m and I nm = 0 otherwise. Hence prove the results (1.57) and (1.58).

1.13 ( ) Suppose that the variance of a Gaussian is estimated using the result (1.56) but with the maximum likelihood estimate µ ML replaced with the true value µ of the mean. Show that this estimator has the property that its expectation is given by the true variance σ 2 .

1.14 ( ) Show that an arbitrary square matrix with elements w ij can be written in the form w ij = w S ij + w A ij where w S ij and w A ij are symmetric and anti-symmetric matrices, respectively, satisfying w S ij = w S ji and w A ij = − w A ji for all i and j . Now consider the second order term in a higher order polynomial in D dimensions, given by

$$
\sum _ { i = 1 } ^ { D } \sum _ { j = 1 } ^ { D } w _ { i j } x _ { i } x _ { j } .
$$

Show that

$$
\sum _ { i = 1 } ^ { D } \sum _ { j = 1 } ^ { D } w _ { i j } x _ { i } x _ { j } & = \sum _ { i = 1 } ^ { D } \sum _ { j = 1 } ^ { D } w _ { i j } ^ { S } x _ { i } x _ { j } \\ \text { contribution from the anti-symmetric matrix vanishes. We therefore see}
$$

so that the contribution from the anti-symmetric matrix vanishes. We therefore see that, without loss of generality, the matrix of coefﬁcients w ij can be chosen to be symmetric, and so not all of the D 2 elements of this matrix can be chosen independently. Show that the number of independent parameters in the matrix w S ij is given by D ( D + 1) / 2 .

1.15 ( ) www In this exercise and the next, we explore how the number of independent parameters in a polynomial grows with the order M of the polynomial and with the dimensionality D of the input space. We start by writing down the M th order term for a polynomial in D dimensions in the form

$$
\sum _ { i _ { 1 } = 1 } ^ { D } \sum _ { i _ { 2 } = 1 } ^ { D } \cdots \sum _ { i _ { M } = 1 } ^ { D } w _ { i _ { 1 } i _ { 2 } \cdots i _ { M } } x _ { i _ { 1 } } x _ { i _ { 2 } } \cdots x _ { i _ { M } } .
$$

The coefﬁcients w i 1 i 2 ··· i M comprise D M elements, but the number of independent parameters is signiﬁcantly fewer due to the many interchange symmetries of the factor x i 1 x i 2 ··· x i M . Begin by showing that the redundancy in the coefﬁcients can be removed by rewriting this M th order term in the form

$$
\sum _ { i _ { 1 } = 1 } ^ { D } \sum _ { i _ { 2 } = 1 } ^ { i _ { 1 } } \cdots \sum _ { i _ { M } = 1 } ^ { i _ { M - 1 } } \widetilde { w } _ { i _ { 1 } i _ { 2 } \cdots i _ { M } } x _ { i _ { 1 } } x _ { i _ { 2 } } \cdots x _ { i _ { M } } .
$$

Note that the precise relationship between the w coefﬁcients and w coefﬁcients need not be made explicit. Use this result to show that the number of independent parameters n ( D,M ) , which appear at order M , satisﬁes the following recursion relation

$$
n ( D , M ) = \sum _ { i = 1 } ^ { D } n ( i , M - 1 ) . \quad ( 1 . 1 3 5 ) \\ \intertext { y i n d u c t i o n t o s h o w t h a r e } \intertext { y i n d u c t i o n t o s h o w t h a r e }
$$

Next use proof by induction to show that the following result holds

$$
\sum _ { i = 1 } ^ { D } \frac { ( i + M - 2 ) ! } { ( i - 1 ) ! ( M - 1 ) ! } = \frac { ( D + M - 1 ) ! } { ( D - 1 ) ! M ! } \quad ( 1 . 1 3 6 ) \\ \text {be done by first proving the result for } D = 1 \text { and arbitrary } M \text { by making}
$$

which can be done by ﬁrst proving the result for D = 1 and arbitrary M by making use of the result 0! = 1 , then assuming it is correct for dimension D and verifying that it is correct for dimension D + 1 . Finally, use the two previous results, together with proof by induction, to show

$$
n ( D , M ) = \frac { ( D + M - 1 ) ! } { ( D - 1 ) ! M ! } . & & ( 1 . 1 3 7 ) \\ \intertext { o w h a t h e r s i t u r $ e f $ M = 2 $ , $ $ a n d $ any value of $ D \geq 1 $ }
$$

To do this, ﬁrst show that the result is true for M = 2 , and any value of D 1 , by comparison with the result of Exercise 1.14. Then make use of (1.135), together with (1.136), to show that, if the result holds at order M − 1 , then it will also hold at order M

1.16 ( ) In Exercise 1.15, we proved the result (1.135) for the number of independent parameters in the M th order term of a D -dimensional polynomial. We now ﬁnd an expression for the total number N ( D,M ) of independent parameters in all of the terms up to and including the M 6th order. First show that N ( D,M ) satisﬁes

$$
N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 1 - 2 0 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\ \intertext { t h e r $ b o w $ } \frac { 1 } { 2 } \intertext { t h e r $ b o w $ } \frac { N ( D , M ) = \sum _ { m = 0 } ^ { M } n ( D , m ) } { 2 } & & ( 1 . 1 3 ) \\
$$

where n ( D,m ) is the number of independent parameters in the term of order m . Now make use of the result (1.137), together with proof by induction, to show that

$$
N ( d , M ) = \frac { ( D + M ) ! } { D ! \, M ! } .
$$

This can be done by ﬁrst proving that the result holds for M = 0 and arbitrary D 1 , then assuming that it holds at order M , and hence showing that it holds at order M + 1 . Finally, make use of Stirling’s approximation in the form

$$
n ! \simeq n ^ { n } e ^ { - n } \\ \intertext { f } n ! \simeq n ^ { n } e ^ { - n } \intertext { s c r } \intertext { c r } D _ { 0 } \gg \intertext { s c r } U _ { 0 } \gg \intertext { s c r } D ( D _ { 0 } ) = \dot { U } ( D _ { 0 } ) = \dot { U } ( D ) = \dots = \intertext { r e f } \intertext { s c r } \intertext { c r } D ( D ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ { 0 } ) = \dots = \intertext { s c r } D ( U ) = \dots = \intertext { s c r } D ( D _ {
$$

for large n to show that, for D M , the quantity N ( D,M ) grows like D M , and for M D it grows like M D . Consider a cubic ( M = 3 ) polynomial in D dimensions, and evaluate numerically the total number of independent parameters for (i) D = 10 and (ii) D = 100 , which correspond to typical small-scale and medium-scale machine learning applications.

1.17 ( ) www The gamma function is deﬁned by

$$
\text {gamma function is defined by} \\ \Gamma ( x ) \equiv \int _ { 0 } ^ { \infty } u ^ { x - 1 } e ^ { - u } \, d u . \quad ( 1 . 1 4 1 ) \\ \text {by parts, prove the relation $\Gamma(x+1) = x\Gamma(x)$. Show also that}
$$

Using integration by parts, prove the relation Γ( x + 1) = x Γ( x ) . Show also that Γ(1) = 1 and hence that Γ( x + 1) = x ! when x is an integer.

1.18 ( ) www We can use the result (1.126) to derive an expression for the surface area S D , and the volume V D , of a sphere of unit radius in D dimensions. To do this, consider the following result, which is obtained by transforming from Cartesian to polar coordinates

$$
\prod _ { i = 1 } ^ { D } \int _ { - \infty } ^ { \infty } e ^ { - x _ { i } ^ { 2 } } \, d x _ { i } = S _ { D } \int _ { 0 } ^ { \infty } e ^ { - r ^ { 2 } } r ^ { D - 1 } \, d r .
$$

Using the deﬁnition (1.141) of the Gamma function, together with (1.126), evaluate both sides of this equation, and hence show that

$$
S _ { D } = \frac { 2 \pi ^ { D / 2 } } { \Gamma ( D / 2 ) } .
$$

Next, by integrating with respect to radius from 0 to 1 , show that the volume of the unit sphere in D dimensions is given by

$$
V _ { D } = \frac { S _ { D } } { D } .
$$

D Finally, use the results Γ(1) = 1 and Γ(3 / 2) = √ π/ 2 to show that (1.143) and (1.144) reduce to the usual expressions for D = 2 and D = 3 .

1.19 ( ) Consider a sphere of radius a in D -dimensions together with the concentric hypercube of side 2 a , so that the sphere touches the hypercube at the centres of each of its sides. By using the results of Exercise 1.18, show that the ratio of the volume of the sphere to the volume of the cube is given by

$$
\frac { \volume of \text {sphere} } { \volume of \text {cube} } = \frac { \pi ^ { D / 2 } } { D 2 ^ { D - 1 } \Gamma ( D / 2 ) } .
$$

Now make use of Stirling’s formula in the form

$$
\Gamma ( x + 1 ) & \simeq ( 2 \pi ) ^ { 1 / 2 } e ^ { - x } x ^ { x + 1 / 2 } & ( 1 . 1 4 6 ) \\
$$

which is valid for x 1 , to show that, as D → ∞ , the ratio (1.145) goes to zero. Show also that the ratio of the distance from the centre of the hypercube to one of the corners, divided by the perpendicular distance to one of the sides, is √ D , which therefore goes to ∞ as D → ∞ . From these results we see that, in a space of high dimensionality, most of the volume of a cube is concentrated in the large number of corners, which themselves become very long ‘spikes’!

1.20 ( ) www In this exercise, we explore the behaviour of the Gaussian distribution in high-dimensional spaces. Consider a Gaussian distribution in D dimensions given by 2

$$
p ( x ) = \frac { 1 } { ( 2 \pi \sigma ^ { 2 } ) ^ { D / 2 } } \exp \left ( - \frac { \| x \| ^ { 2 } } { 2 \sigma ^ { 2 } } \right ) . \\ \intertext { i n d t h e d s i n t y w i t h e s e c t r o d i a n t e s i n p o r a l c o d r i n d a t e s i n w h i c h e r }
$$

We wish to ﬁnd the density with respect to radius in polar coordinates in which the direction variables have been integrated out. To do this, show that the integral of the probability density over a thin shell of radius r and thickness , where 1 , is given by p ( r ) where

$$
p ( r ) & = \frac { S _ { D } r ^ { D - 1 } } { ( 2 \pi \sigma ^ { 2 } ) ^ { D / 2 } } \exp \left ( - \frac { r ^ { 2 } } { 2 \sigma ^ { 2 } } \right ) \\ \intertext { s u r f a c e a r a o f a u n i t s p h e r e i n g s u p t h e r f o w t h e f u c t i o n }
$$

where S D is the surface area of a unit sphere in D dimensions. Show that the function p ( r ) has a single stationary point located, for large D , at r √ Dσ . By considering p ( r + ) where r , show that for large D , p ( r + ) = p ( r )exp − 3 2 2 σ 2 (1.149)

$$
\epsilon \ll r , \, \text {show that for large } D , \\ p ( \widehat { r } + \epsilon ) = p ( \widehat { r } ) \exp \left ( - \frac { 3 \epsilon ^ { 2 } } { 2 \sigma ^ { 2 } } \right ) \\ \intertext { t \, r \, is \, a \, \max i m u m \, o f the r a d i a b l i g h \, o f t i l y \, d e n s i t y \, a n d \, a l s o t h a r \, d e p t ( r ) } \text {tally  away  from  its  maximum  at  } \widehat { r } \, \text { with  length  scale  } \sigma . \text {  We  have}
$$

which shows that r is a maximum of the radial probability density and also that p ( r ) decays exponentially away from its maximum at r with length scale σ . We have already seen that σ r for large D , and so we see that most of the probability mass is concentrated in a thin shell at large radius. Finally, show that the probability density p ( x ) is larger at the origin than at the radius r by a factor of exp( D/ 2) . We therefore see that most of the probability mass in a high-dimensional Gaussian distribution is located at a different radius from the region of high probability density. This property of distributions in spaces of high dimensionality will have important consequences when we consider Bayesian inference of model parameters in later chapters.

1.21 ( ) Consider two nonnegative numbers a and b , and show that, if a b , then a ( ab ) 1 / 2 . Use this result to show that, if the decision regions of a two-class classiﬁcation problem are chosen to minimize the probability of misclassiﬁcation, this probability will satisfy

$$
\text {mobility with satisfy} \\ p ( \text {mistake} ) \leqslant \int \{ p ( x , \mathcal { C } _ { 1 } ) p ( x , \mathcal { C } _ { 2 } ) \} ^ { 1 / 2 } \, d x .
$$

1.22 ( ) www Given a loss matrix with elements L kj , the expected risk is minimized if, for each x , we choose the class that minimizes (1.81). Verify that, when the loss matrix is given by L kj = 1 − I kj , where I kj are the elements of the identity matrix, this reduces to the criterion of choosing the class having the largest posterior probability. What is the interpretation of this form of loss matrix?

1.23 ( ) Derive the criterion for minimizing the expected loss when there is a general loss matrix and general prior probabilities for the classes.

1.24 ( ) www Consider a classiﬁcation problem in which the loss incurred when an input vector from class C k is classiﬁed as belonging to class C j is given by the loss matrix L kj , and for which the loss incurred in selecting the reject option is λ . Find the decision criterion that will give the minimum expected loss. Verify that this reduces to the reject criterion discussed in Section 1.5.3 when the loss matrix is given by L kj = 1 − I kj . What is the relationship between λ and the rejection threshold θ ?

1.25 ( ) www Consider the generalization of the squared loss function (1.87) for a single target variable t to the case of multiple target variables described by the vector t given by

$$
\text {en by} \\ \mathbb { E } [ L ( t , y ( x ) ) ] = \iint \| y ( x ) - t \| ^ { 2 } p ( x , t ) \, d x \, d t . \\ \intertext { t h e c l u c l u s of variations, show that the function y ( x ) \, f o r \, \text {which this expected} }
$$

Using the calculus of variations, show that the function y ( x ) for which this expected loss is minimized is given by y ( x ) = E t [ t | x ] . Show that this result reduces to (1.89) for the case of a single target variable t .

1.26 ( ) By expansion of the square in (1.151), derive a result analogous to (1.90) and hence show that the function y ( x ) that minimizes the expected squared loss for the case of a vector t of target variables is again given by the conditional expectation of t .

1.27 ( ) www Consider the expected loss for regression problems under the L q loss function given by (1.91). Write down the condition that y ( x ) must satisfy in order to minimize E [ L q ] . Show that, for q = 1 , this solution represents the conditional median, i.e., the function y ( x ) such that the probability mass for t < y ( x ) is the same as for t y ( x ) . Also show that the minimum expected L q loss for q → 0 is given by the conditional mode, i.e., by the function y ( x ) equal to the value of t that maximizes p ( t | x ) for each x .

1.28 ( ) In Section 1.6, we introduced the idea of entropy h ( x ) as the information gained on observing the value of a random variable x having distribution p ( x ) . We saw that, for independent variables x and y for which p ( x,y ) = p ( x ) p ( y ) , the entropy functions are additive, so that h ( x,y ) = h ( x ) + h ( y ) . In this exercise, we derive the relation between h and p in the form of a function h ( p ) . First show that h ( p 2 ) = 2 h ( p ) , and hence by induction that h ( p n ) = nh ( p ) where n is a positive integer. Hence show that h ( p n/m ) = ( n/m ) h ( p ) where m is also a positive integer. This implies that h ( p x ) = xh ( p ) where x is a positive rational number, and hence by continuity when it is a positive real number. Finally, show that this implies h ( p ) must take the form h ( p ) ∝ ln p .

1.29 ( ) www Consider an M -state discrete random variable x , and use Jensen’s inequality in the form (1.115) to show that the entropy of its distribution p ( x ) satisﬁes H[ x ] ln M .

1.30 ( ) Evaluate the Kullback-Leibler divergence (1.113) between two Gaussians p ( x ) = N ( x | µ,σ 2 ) and q ( x ) = N ( x | m,s 2 ) .

Table 1.3 The joint distribution p ( x, y ) for two binary variables x and y used in Exercise 1.39.

$$
\frac { x } { 1 } \begin{array} { c | c c } \frac { y } { 0 } & 0 & 1 \\ \frac { 1 } { 0 } & 1 / 3 & 1 / 3 \\ 1 & 0 & 1 / 3 \end{array}
$$

1.31 ( ) www Consider two variables x and y having joint distribution p ( x , y ) . Show that the differential entropy of this pair of variables satisﬁes

$$
H [ x , y ] \leq H [ x ] + H [ y ]
$$

with equality if, and only if, x and y are statistically independent.

1.32 ( ) Consider a vector x of continuous variables with distribution p ( x ) and corresponding entropy H[ x ] . Suppose that we make a nonsingular linear transformation of x to obtain a new variable y = Ax . Show that the corresponding entropy is given by H[ y ] = H[ x ] + ln | A | where | A | denotes the determinant of A .

1.33 ( ) Suppose that the conditional entropy H[ y | x ] between two discrete random variables x and y is zero. Show that, for all values of x such that p ( x ) > 0 , the variable y must be a function of x , in other words for each x there is only one value of y such that p ( y | x ) = 0 .

/negationslash

1.34 ( ) www Use the calculus of variations to show that the stationary point of the functional (1.108) is given by (1.108). Then use the constraints (1.105), (1.106), and (1.107) to eliminate the Lagrange multipliers and hence show that the maximum entropy solution is given by the Gaussian (1.109).

1.35 ( ) www Use the results (1.106) and (1.107) to show that the entropy of the univariate Gaussian (1.109) is given by (1.110).

1.36 ( ) A strictly convex function is deﬁned as one for which every chord lies above the function. Show that this is equivalent to the condition that the second derivative of the function be positive.

1.37 ( ) Using the deﬁnition (1.111) together with the product rule of probability, prove the result (1.112).

1.38 ( ) www Using proof by induction, show that the inequality (1.114) for convex functions implies the result (1.115).

1.39 ( ) Consider two binary variables x and y having the joint distribution given in Table 1.3.

Evaluate the following quantities

(c) H[ y | x ] y ] (d) H[ x | y ]

(a) H[ x ]

(b) H[

(e) H[ x,y ]

(f) I[ x,y ] .

Draw a diagram to show the relationship between these various quantities.

## 2 Probability Distributions Exercises

2.1 ( ) www Verify that the Bernoulli distribution (2.2) satisﬁes the following properties

$$
\sum _ { x = 0 } ^ { 1 } p ( x | \mu ) \ = \ 1 & & ( 2 . 2 5 7 ) \\ \mathbb { E } [ x ] \ = \ \mu & & ( 2 . 2 5 8 )
$$

$$
\mathbb { E } [ x ] \ = \ \mu
$$

$$
\var { v } [ x ] \ = \ \mu ( 1 - \mu ) . \\
$$

Show that the entropy H[ x ] of a Bernoulli distributed random binary variable x is given by

$$
H [ x ] = - \mu \ln \mu - ( 1 - \mu ) \ln ( 1 - \mu ) .
$$

2.2 ( ) The form of the Bernoulli distribution given by (2.2) is not symmetric between the two values of x . In some situations, it will be more convenient to use an equivalent formulation for which x ∈ {− 1 , 1 } , in which case the distribution can be written (1 x ) / 2 (1+ x ) / 2

$$
p ( x | \mu ) & = \left ( \frac { 1 - \mu } { 2 } \right ) ^ { ( 1 - x ) / 2 } \left ( \frac { 1 + \mu } { 2 } \right ) ^ { ( 1 + x ) / 2 } \\ \in [ - 1 , 1 ] \, \text {Show that the distribution } ( 2 . 2 6 1 ) \, \text {is normalized, and evaluate its}
$$

where µ ∈ [ − 1 , 1] . Show that the distribution (2.261) is normalized, and evaluate its mean, variance, and entropy.

2.3 ( ) www In this exercise, we prove that the binomial distribution (2.9) is normalized. First use the deﬁnition (2.10) of the number of combinations of m identical objects chosen from a total of N to show that

$$
\text {from a total of $N$ to show that} \\ \begin{pmatrix} N \\ m \end{pmatrix} + \begin{pmatrix} N \\ m - 1 \end{pmatrix} = \begin{pmatrix} N + 1 \\ m \end{pmatrix} .
$$

Use this result to prove by induction the following result

$$
( 1 + x ) ^ { N } = \sum _ { m = 0 } ^ { N } \binom { N } { m } x ^ { m } & & ( 2 . 2 6 3 ) \\ \intertext { t h i n o m i a l l t h e o r m e r } \intertext { w i t h e r s } \intertext { c h i n o w h i c h i s e r }
$$

which is known as the binomial theorem , and which is valid for all real values of x . Finally, show that the binomial distribution is normalized, so that

$$
\sum _ { m = 0 } ^ { N } \binom { N } { m } \mu ^ { m } ( 1 - \mu ) ^ { N - m } = 1 \quad ( 2 . 2 6 ) \\ \intertext { s u n o b y s f r i t p u l l i n g w i l l } \intertext { o n o n e b y s f r i t p u l l i n g w i l l } \intertext { s u n o n e b y s f r i t p u l l i n g w i l l }
$$

which can be done by ﬁrst pulling out a factor (1 − µ ) N out of the summation and then making use of the binomial theorem.

2.4 ( ) Show that the mean of the binomial distribution is given by (2.11). To do this, differentiate both sides of the normalization condition (2.264) with respect to µ and then rearrange to obtain an expression for the mean of n . Similarly, by differentiating (2.264) twice with respect to µ and making use of the result (2.11) for the mean of the binomial distribution prove the result (2.12) for the variance of the binomial.

2.5 ( ) www In this exercise, we prove that the beta distribution, given by (2.13), is correctly normalized, so that (2.14) holds. This is equivalent to showing that

$$
\int _ { 0 } ^ { 1 } \mu ^ { a - 1 } ( 1 - \mu ) ^ { b - 1 } \, d \mu & = \frac { \Gamma ( a ) \Gamma ( b ) } { \Gamma ( a + b ) } . \\ \intertext { f i n t i o n } \left ( 1 . 1 1 \right ) \text { of the } \text { gamma function } w _ { \ } h e v o \right )
$$

From the deﬁnition (1.141) of the gamma function, we have

$$
T \text { from the definition } ( . . ) & \text { for the $\gamma$-calidron, where } \\ \Gamma ( a ) \Gamma ( b ) = \int _ { 0 } ^ { \infty } \exp ( - x ) x ^ { a - 1 } \, d x \int _ { 0 } ^ { \infty } \exp ( - y ) y ^ { b - 1 } \, d y . & ( 2 . 2 6 6 ) \\ \intertext { U o s t h i n s e x p r o s i c y o n t e r g a n d s }
$$

Use this expression to prove (2.265) as follows. First bring the integral over y inside the integrand of the integral over x , next make the change of variable t = y + x where x is ﬁxed, then interchange the order of the x and t integrations, and ﬁnally make the change of variable x = tµ where t is ﬁxed.

2.6 ( ) Make use of the result (2.265) to show that the mean, variance, and mode of the beta distribution (2.13) are given respectively by

$$
\mathbb { E } [ \mu ] \ = \ \frac { a } { a + b } & & ( 2 . 2 6 7 )
$$

$$
\var { v } [ \mu ] \ = \ \frac { a b } { ( a + b ) ^ { 2 } ( a + b + 1 ) } \quad ( 2 . 2 6 8 )
$$

$$
\mod [ \mu ] \ = \ \frac { a - 1 } { a + b - 2 } .
$$

2.7 ( ) Consider a binomial random variable x given by (2.9), with prior distribution for µ given by the beta distribution (2.13), and suppose we have observed m occurrences of x = 1 and l occurrences of x = 0 . Show that the posterior mean value of x lies between the prior mean and the maximum likelihood estimate for µ . To do this, show that the posterior mean can be written as λ times the prior mean plus (1 − λ ) times the maximum likelihood estimate, where 0 λ 1 . This illustrates the concept of the posterior distribution being a compromise between the prior distribution and the maximum likelihood solution.

2.8 ( ) Consider two variables x and y with joint distribution p ( x,y ) . Prove the following two results

$$
\mathbb { E } [ x ] \ & = \ \mathbb { E } _ { y } \left [ \mathbb { E } _ { x } [ x | y ] \right ] \\ \text {var} [ x ] \ & = \ \mathbb { F } _ { x } \left [ \text {var} \ \left [ x | u \right ] \right ] + \text {var} \ \left [ \mathbb { F } \ \left [ x | u \right ] \right ] \\
$$

$$
\ v a r [ x ] \ = \ \mathbb { E } _ { y } \left [ v a r _ { x } [ x | y ] \right ] + v a r _ { y } \left [ \mathbb { E } _ { x } [ x | y ] \right ] .
$$

Here E x [ x | y ] denotes the expectation of x under the conditional distribution p ( x | y ) , with a similar notation for the conditional variance.

2.9 ( ) www . In this exercise, we prove the normalization of the Dirichlet distribution (2.38) using induction. We have already shown in Exercise 2.5 that the beta distribution, which is a special case of the Dirichlet for M = 2 , is normalized. We now assume that the Dirichlet distribution is normalized for M − 1 variables and prove that it is normalized for M variables. To do this, consider the Dirichlet distribution over M variables, and take account of the constraint M k =1 µ k = 1 by eliminating µ M , so that the Dirichlet is written α 1

$$
p _ { M } ( \mu _ { 1 } , \dots , \mu _ { M - 1 } ) = C _ { M } \prod _ { k = 1 } ^ { M - 1 } \mu _ { k } ^ { \alpha _ { k } - 1 } \left ( 1 - \sum _ { j = 1 } ^ { M - 1 } \mu _ { j } \right ) ^ { \alpha _ { M } - 1 } \\ \intertext { a n d our goal is to find an expression for C _ { \gamma } . To do this, integrate over \mu _ { \gamma } , taking }
$$

and our goal is to ﬁnd an expression for C M . To do this, integrate over µ M − 1 , taking care over the limits of integration, and then make a change of variable so that this integral has limits 0 and 1 . By assuming the correct result for C M − 1 and making use of (2.265), derive the expression for C M .

2.10 ( ) Using the property Γ( x + 1) = x Γ( x ) of the gamma function, derive the following results for the mean, variance, and covariance of the Dirichlet distribution given by (2.38)

$$
\mathbb { E } [ \mu _ { j } ] \ = \ \frac { \alpha _ { j } } { \alpha _ { 0 } } \quad & & ( 2 . 2 7 3 )
$$

$$
\var { v } [ \mu _ { j } ] \ = \ \frac { \alpha _ { j } ( \alpha _ { 0 } - \alpha _ { j } ) } { \alpha _ { 0 } ^ { 2 } ( \alpha _ { 0 } + 1 ) }
$$

$$
\cot [ \mu _ { j } \mu _ { l } ] \ = \ - \frac { \alpha _ { j } \alpha _ { l } } { \alpha _ { 0 } ^ { 2 } ( \alpha _ { 0 } + 1 ) } , \quad j \neq l
$$

/negationslash

2.11 ( ) www By expressing the expectation of ln µ j under the Dirichlet distribution (2.38) as a derivative with respect to α j , show that

$$
\mathbb { E } [ \ln \mu _ { j } ] = \psi ( \alpha _ { j } ) - \psi ( \alpha _ { 0 } )
$$

where α 0 is given by (2.39) and

is the digamma function.

$$
\psi ( a ) \equiv \frac { d } { d a } \ln \Gamma ( a )
$$

2.12 ( ) The uniform distribution for a continuous variable x is deﬁned by

$$
U ( x | a , b ) = \frac { 1 } { b - a } , \quad a \leqslant x \leqslant b . \\ \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s d i t b u i n g } \intertext { t h i s
$$

Verify that this distribution is normalized, and ﬁnd expressions for its mean and variance.

2.13 ( ) Evaluate the Kullback-Leibler divergence (1.113) between two Gaussians p ( x ) = N ( x | µ , Σ ) and q ( x ) = N ( x | m , L ) .

2.14 ( ) www This exercise demonstrates that the multivariate distribution with maximum entropy, for a given covariance, is a Gaussian. The entropy of a distribution p ( x ) is given by

$$
H [ x ] = - \int p ( x ) \ln p ( x ) \, d x . \\ \intertext { i m i z e } H [ x ] \, o r \, v e r \, a l l \, d i r b u t i o n s \, p ( x ) \, s u i c t \, t o \, t h e \, c r a n t i o n s \, t h a r t
$$

We wish to maximize H[ x ] over all distributions p ( x ) subject to the constraints that p ( x ) be normalized and that it have a speciﬁc mean and covariance, so that

$$
\int p ( x ) \, d x & = 1 \\ \int _ { \real } p ( x ) \, r _ { d x } & = x - 1
$$

$$
& \int p ( x ) d x = 1 \\ & \int p ( x ) x d x = \mu \\ & \int _ { \real } p ( x ) ( x ) ( x - x ) ( x - x ) ^ { T } d x = \Sigma \\
$$

$$
& \int p ( x ) x ^ { \ } d x = \mu \\ & \int p ( x ) ( x - \mu ) ( x - \mu ) ^ { \top } \, d x = \Sigma . \\ \text {variational maximization of } & ( 2 . 2 7 9 ) \, a n d \, u s i g n \, I \, a r g n e \, m u l i p i l i s
$$

By performing a variational maximization of (2.279) and using Lagrange multipliers to enforce the constraints (2.280), (2.281), and (2.282), show that the maximum likelihood distribution is given by the Gaussian (2.43).

2.15 ( ) Show that the entropy of the multivariate Gaussian N ( x | µ , Σ ) is given by

$$
H [ x ] = \frac { 1 } { 2 } \ln | \Sigma | + \frac { D } { 2 } \left ( 1 + \ln ( 2 \pi ) \right ) \quad ( 2 . 2 8 3 )
$$

2.16 ( ) www Consider two random variables x 1 and x 2 having Gaussian distributions with means µ 1 ,µ 2 and precisions τ 1 , τ 2 respectively. Derive an expression for the differential entropy of the variable x = x 1 + x 2 . To do this, ﬁrst ﬁnd the distribution of x by using the relation

$$
p ( x ) & = \int _ { - \infty } ^ { \infty } p ( x | x _ { 2 } ) p ( x _ { 2 } ) \, d x _ { 2 } & ( 2 . 2 8 4 ) \\ \intertext { t h e s u r g e i n the w i n g e n t }
$$

and completing the square in the exponent. Then observe that this represents the convolution of two Gaussian distributions, which itself will be Gaussian, and ﬁnally make use of the result (1.110) for the entropy of the univariate Gaussian.

2.17 ( ) www Consider the multivariate Gaussian distribution given by (2.43). By writing the precision matrix (inverse covariance matrix) Σ − 1 as the sum of a symmetric and an anti-symmetric matrix, show that the anti-symmetric term does not appear in the exponent of the Gaussian, and hence that the precision matrix may be taken to be symmetric without loss of generality. Because the inverse of a symmetric matrix is also symmetric (see Exercise 2.22), it follows that the covariance matrix may also be chosen to be symmetric without loss of generality.

2.18 ( ) Consider a real, symmetric matrix Σ whose eigenvalue equation is given by (2.45). By taking the complex conjugate of this equation and subtracting the original equation, and then forming the inner product with eigenvector u i , show that the eigenvalues λ i are real. Similarly, use the symmetry property of Σ to show that two eigenvectors u i and u j will be orthogonal provided λ j = λ i . Finally, show that without loss of generality, the set of eigenvectors can be chosen to be orthonormal, so that they satisfy (2.46), even if some of the eigenvalues are zero.

/negationslash

2.19 ( ) Show that a real, symmetric matrix Σ having the eigenvector equation (2.45) can be expressed as an expansion in the eigenvectors, with coefﬁcients given by the eigenvalues, of the form (2.48). Similarly, show that the inverse matrix Σ − 1 has a representation of the form (2.49).

2.20 ( ) www A positive deﬁnite matrix Σ can be deﬁned as one for which the quadratic form T

$$
a ^ { \top } \Sigma a
$$

is positive for any real value of the vector a . Show that a necessary and sufﬁcient condition for Σ to be positive deﬁnite is that all of the eigenvalues λ i of Σ , deﬁned by (2.45), are positive.

2.21 ( ) Show that a real, symmetric matrix of size D × D has D ( D +1) / 2 independent parameters.

2.22 ( ) www Show that the inverse of a symmetric matrix is itself symmetric.

2.23 ( ) By diagonalizing the coordinate system using the eigenvector expansion (2.45), show that the volume contained within the hyperellipsoid corresponding to a constant

Mahalanobis distance ∆ is given by

$$
V _ { D } | \Sigma | ^ { 1 / 2 } \Delta ^ { D }
$$

where V D is the volume of the unit sphere in D dimensions, and the Mahalanobis distance is deﬁned by (2.44).

2.24 ( ) www Prove the identity (2.76) by multiplying both sides by the matrix

$$
\begin{pmatrix} A & B \\ C & D \end{pmatrix}
$$

and making use of the deﬁnition (2.77).

2.25 ( ) In Sections 2.3.1 and 2.3.2, we considered the conditional and marginal distributions for a multivariate Gaussian. More generally, we can consider a partitioning of the components of x into three groups x a , x b , and x c , with a corresponding partitioning of the mean vector µ and of the covariance matrix Σ in the form

$$
\mu & = \begin{pmatrix} \mu _ { a } \\ \mu _ { b } \end{pmatrix} , \quad \Sigma = \begin{pmatrix} \Sigma _ { a a } & \Sigma _ { a b } & \Sigma _ { a c } \\ \Sigma _ { b a } & \Sigma _ { b b } & \Sigma _ { b c } \\ \Sigma _ { c a } & \Sigma _ { c b } & \Sigma _ { c c } \end{pmatrix} .
$$

By making use of the results of Section 2.3, ﬁnd an expression for the conditional distribution p ( x a | x b ) in which x c has been marginalized out.

2.26 ( ) A very useful result from linear algebra is the Woodbury matrix inversion formula given by

$$
( A + B C D ) ^ { - 1 } = A ^ { - 1 } - A ^ { - 1 } B ( C ^ { - 1 } + D A ^ { - 1 } B ) ^ { - 1 } D A ^ { - 1 } . \quad ( 2 . 2 8 9 )
$$

By multiplying both sides by ( A + BCD ) prove the correctness of this result.

2.27 ( ) Let x and z be two independent random vectors, so that p ( x , z ) = p ( x ) p ( z ) . Show that the mean of their sum y = x + z is given by the sum of the means of each of the variable separately. Similarly, show that the covariance matrix of y is given by the sum of the covariance matrices of x and z . Conﬁrm that this result agrees with that of Exercise 1.10.

2.28 ( ) www Consider a joint distribution over the variable

$$
z = \begin{pmatrix} x \\ y \end{pmatrix} & ( 2 . 2 9 0 ) \\
$$

whose mean and covariance are given by (2.108) and (2.105) respectively. By making use of the results (2.92) and (2.93) show that the marginal distribution p ( x ) is given (2.99). Similarly, by making use of the results (2.81) and (2.82) show that the conditional distribution p ( y | x ) is given by (2.100).

2.29 ( ) Using the partitioned matrix inversion formula (2.76), show that the inverse of the precision matrix (2.104) is given by the covariance matrix (2.105).

2.30 ( ) By starting from (2.107) and making use of the result (2.105), verify the result (2.108).

2.31 ( ) Consider two multidimensional random vectors x and z having Gaussian distributions p ( x ) = N ( x | µ x , Σ x ) and p ( z ) = N ( z | µ z , Σ z ) respectively, together with their sum y = x + z . Use the results (2.109) and (2.110) to ﬁnd an expression for the marginal distribution p ( y ) by considering the linear-Gaussian model comprising the product of the marginal distribution p ( x ) and the conditional distribution p ( y | x ) .

2.32 ( ) www This exercise and the next provide practice at manipulating the quadratic forms that arise in linear-Gaussian models, as well as giving an independent check of results derived in the main text. Consider a joint distribution p ( x , y ) deﬁned by the marginal and conditional distributions given by (2.99) and (2.100). By examining the quadratic form in the exponent of the joint distribution, and using the technique of ‘completing the square’ discussed in Section 2.3, ﬁnd expressions for the mean and covariance of the marginal distribution p ( y ) in which the variable x has been integrated out. To do this, make use of the Woodbury matrix inversion formula (2.289). Verify that these results agree with (2.109) and (2.110) obtained using the results of Chapter 2.

2.33 ( ) Consider the same joint distribution as in Exercise 2.32, but now use the technique of completing the square to ﬁnd expressions for the mean and covariance of the conditional distribution p ( x | y ) . Again, verify that these agree with the corresponding expressions (2.111) and (2.112).

2.34 ( ) www To ﬁnd the maximum likelihood solution for the covariance matrix of a multivariate Gaussian, we need to maximize the log likelihood function (2.118) with respect to Σ , noting that the covariance matrix must be symmetric and positive deﬁnite. Here we proceed by ignoring these constraints and doing a straightforward maximization. Using the results (C.21), (C.26), and (C.28) from Appendix C, show that the covariance matrix Σ that maximizes the log likelihood function (2.118) is given by the sample covariance (2.122). We note that the ﬁnal result is necessarily symmetric and positive deﬁnite (provided the sample covariance is nonsingular).

2.35 ( ) Use the result (2.59) to prove (2.62). Now, using the results (2.59), and (2.62), show that T

$$
\mathbb { E } [ x _ { n } x _ { m } ] = \mu \mu ^ { T } + I _ { n m } \Sigma
$$

where x n denotes a data point sampled from a Gaussian distribution with mean µ and covariance Σ , and I nm denotes the ( n,m ) element of the identity matrix. Hence prove the result (2.124).

2.36 ( ) www Using an analogous procedure to that used to obtain (2.126), derive an expression for the sequential estimation of the variance of a univariate Gaussian

distribution, by starting with the maximum likelihood expression

$$
\sigma _ { M L } ^ { 2 } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } ( x _ { n } - \mu ) ^ { 2 } . \\ \intertext { t i n g t h e x p r e s s } \text {using the expression for a Gaussian distribution into the R o bins} \
$$

Verify that substituting the expression for a Gaussian distribution into the RobbinsMonro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefﬁcients a N .

2.37 ( ) Using an analogous procedure to that used to obtain (2.126), derive an expression for the sequential estimation of the covariance of a multivariate Gaussian distribution, by starting with the maximum likelihood expression (2.122). Verify that substituting the expression for a Gaussian distribution into the Robbins-Monro sequential estimation formula (2.135) gives a result of the same form, and hence obtain an expression for the corresponding coefﬁcients a N .

2.38 ( ) Use the technique of completing the square for the quadratic form in the exponent to derive the results (2.141) and (2.142).

2.39 ( ) Starting from the results (2.141) and (2.142) for the posterior distribution of the mean of a Gaussian random variable, dissect out the contributions from the ﬁrst N − 1 data points and hence obtain expressions for the sequential update of µ N and σ 2 N . Now derive the same results starting from the posterior distribution p ( µ | x 1 ,...,x N − 1 ) = N ( µ | µ N − 1 ,σ 2 N − 1 ) and multiplying by the likelihood function p ( x N | µ ) = N ( x N | µ,σ 2 ) and then completing the square and normalizing to obtain the posterior distribution after N observations.

2.40 ( ) www Consider a D -dimensional Gaussian random variable x with distribution N ( x | µ , Σ ) in which the covariance Σ is known and for which we wish to infer the mean µ from a set of observations X = { x 1 ,..., x N } . Given a prior distribution p ( µ ) = N ( µ | µ 0 , Σ 0 ) , ﬁnd the corresponding posterior distribution p ( µ | X ) .

2.41 ( ) Use the deﬁnition of the gamma function (1.141) to show that the gamma distribution (2.146) is normalized.

2.42 ( ) Evaluate the mean, variance, and mode of the gamma distribution (2.146).

2.43 ( ) The following distribution

$$
p ( x | \sigma ^ { 2 } , q ) = \frac { q } { 2 ( 2 \sigma ^ { 2 } ) ^ { 1 / q } \Gamma ( 1 / q ) } \exp \left ( - \frac { | x | ^ { q } } { 2 \sigma ^ { 2 } } \right ) \quad ( 2 . 2 9 3 ) \\ \intertext { o r l i z i o n } p ( x | \sigma ^ { 2 } , q ) = \frac { q } { 2 ( 2 \sigma ^ { 2 } ) ^ { 1 / q } \Gamma ( 1 / q ) } \exp \left ( - \frac { | x | ^ { q } } { 2 \sigma ^ { 2 } } \right ) \quad ( 2 . 2 9 3 ) \\
$$

is a generalization of the univariate Gaussian distribution. Show that this distribution is normalized so that ∞

$$
\int _ { - \infty } ^ { \infty } p ( x | \sigma ^ { 2 } , q ) \, d x & = 1 \\ \intertext { o } \int _ { - \infty } ^ { \infty } p ( x | \sigma ^ { 2 } , q ) \, d x & = 2 . \ \text { Consider a regression model in}
$$

and that it reduces to the Gaussian when q = 2 . Consider a regression model in which the target variable is given by t = y ( x , w ) + and is a random noise

variable drawn from the distribution (2.293). Show that the log likelihood function over w and σ 2 , for an observed data set of input vectors X = { x 1 ,..., x N } and corresponding target variables t = ( t 1 ,...,t N ) T , is given by

$$
\ln p ( t | X , w , \sigma ^ { 2 } ) = - \frac { 1 } { 2 \sigma ^ { 2 } } \sum _ { n = 1 } ^ { N } | y ( x _ { n } , w ) - t _ { n } | ^ { q } - \frac { N } { q } \ln ( 2 \sigma ^ { 2 } ) + \text {const} \quad ( 2 . 2 5 ) \\ \intertext { w h e r e } \text {where } \L ^ { \text {const} } \det n o t e r s \text { independent of both } w \text { and } \sigma ^ { 2 } \text { } \text {Note that as a function }
$$

where ‘ const ’ denotes terms independent of both w and σ 2 . Note that, as a function of w , this is the L q error function considered in Section 1.5.5.

2.44 ( ) Consider a univariate Gaussian distribution N ( x | µ,τ − 1 ) having conjugate Gaussian-gamma prior given by (2.154), and a data set x = { x 1 ,...,x N } of i.i.d. observations. Show that the posterior distribution is also a Gaussian-gamma distribution of the same functional form as the prior, and write down expressions for the parameters of this posterior distribution.

2.45 ( ) Verify that the Wishart distribution deﬁned by (2.155) is indeed a conjugate prior for the precision matrix of a multivariate Gaussian.

2.46 ( ) www Verify that evaluating the integral in (2.158) leads to the result (2.159).

2.47 ( ) www Show that in the limit ν → ∞ , the t-distribution (2.159) becomes a Gaussian. Hint: ignore the normalization coefﬁcient, and simply look at the dependence on x .

2.48 ( ) By following analogous steps to those used to derive the univariate Student’s t-distribution (2.159), verify the result (2.162) for the multivariate form of the Student’s t-distribution, by marginalizing over the variable η in (2.161). Using the deﬁnition (2.161), show by exchanging integration variables that the multivariate t-distribution is correctly normalized.

2.49 ( ) By using the deﬁnition (2.161) of the multivariate Student’s t-distribution as a convolution of a Gaussian with a gamma distribution, verify the properties (2.164), (2.165), and (2.166) for the multivariate t-distribution deﬁned by (2.162).

2.50 ( ) Show that in the limit ν → ∞ , the multivariate Student’s t-distribution (2.162) reduces to a Gaussian with mean µ and precision Λ .

2.51 ( ) www The various trigonometric identities used in the discussion of periodic variables in this chapter can be proven easily from the relation

$$
\exp ( i A ) = \cos A + i \sin A
$$

in which i is the square root of minus one. By considering the identity

$$
\exp ( i A ) \exp ( - i A ) = 1
$$

prove the result (2.177). Similarly, using the identity

$$
\cos ( A - B ) = \Re \exp \{ i ( A - B ) \}
$$

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

![image 16](Bishop2006_images/imageFile16.png)

## 3 Linear Models for Regression Exercises

3.1 ( ) www Show that the ‘ tanh ’ function and the logistic sigmoid function (3.6) are related by

$$
\tanh ( a ) & = 2 \sigma ( 2 a ) - 1 . & ( 3 . 1 0 0 ) \\ \intertext { l e r } 1 \cdot \stackrel { \cdot } { a } \cdot \stackrel { \cdot } { \dot { a } } \cdot \intertext { s u n t h e r } 1 \cdot \stackrel { \cdot } { a } \cdot \stackrel { \cdot } { \dot { a } } 1 \cdot \stackrel { \cdot } { \cdot } \cdot \stackrel { \cdot } { \dot { a } } \cdot \intertext { s u n t h e r }
$$

Hence show that a general linear combination of logistic sigmoid functions of the form M

$$
y ( x , w ) = w _ { 0 } + \sum _ { j = 1 } ^ { M } w _ { j } \sigma \left ( \frac { x - \mu _ { j } } { s } \right ) \\ \intertext { t o a l i n e r b i n a t i o n $ f $ t a n h $ ^ { \prime } $ f o u n i o n s $ of t h e f o r m }
$$

is equivalent to a linear combination of ‘ tanh ’ functions of the form

$$
y ( x , u ) = u _ { 0 } + \sum _ { j = 1 } ^ { M } u _ { j } \tanh \left ( \frac { x - \mu _ { j } } { s } \right ) \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \
$$

and ﬁnd expressions to relate the new parameters { u 1 ,...,u M } to the original parameters { w 1 ,...,w M } .

3.2 ( ) Show that the matrix

$$
\Phi ( \Phi ^ { T } \Phi ) ^ { - 1 } \Phi ^ { T }
$$

takes any vector v and projects it onto the space spanned by the columns of Φ . Use this result to show that the least-squares solution (3.15) corresponds to an orthogonal projection of the vector t onto the manifold S as shown in Figure 3.2.

3.3 ( ) Consider a data set in which each data point t n is associated with a weighting factor r n > 0 , so that the sum-of-squares error function becomes

$$
E _ { D } ( w ) = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } r _ { n } \left \{ t _ { n } - w ^ { \top } \phi ( x _ { n } ) \right \} ^ { 2 } . \\ \intertext { s p r e s s } \text {for the solution } w ^ { * } \text { that minimizes } \text { this error function.  Give two}
$$

Find an expression for the solution w that minimizes this error function. Give two alternative interpretations of the weighted sum-of-squares error function in terms of (i) data dependent noise variance and (ii) replicated data points.

3.4 ( ) www Consider a linear model of the form

$$
y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \\ \intertext { a n o f s u r g e s } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D } w _ { i } x _ { i } \intertext { o n t h e f f } \intertext { o n t h e f f } x - y ( x , w ) = w _ { 0 } + \sum _ { i = 1 } ^ { D }
$$

together with a sum-of-squares error function of the form

$$
E _ { D } ( w ) = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w ) - t _ { n } \} ^ { 2 } .
$$

Now suppose that Gaussian noise i with zero mean and variance σ 2 is added independently to each of the input variables x i . By making use of E [ i ] = 0 and E [ i j ] = δ ij σ 2 , show that minimizing E D averaged over the noise distribution is equivalent to minimizing the sum-of-squares error for noise-free input variables with the addition of a weight-decay regularization term, in which the bias parameter w 0 is omitted from the regularizer.

3.5 ( ) www Using the technique of Lagrange multipliers, discussed in Appendix E, show that minimization of the regularized error function (3.29) is equivalent to minimizing the unregularized sum-of-squares error (3.12) subject to the constraint (3.30). Discuss the relationship between the parameters η and λ .

3.6 ( ) www Consider a linear basis function regression model for a multivariate target variable t having a Gaussian distribution of the form

where together with a training data set comprising input basis vectors φ ( x n ) and corresponding target vectors t n , with n = 1 , . . . , N . Show that the maximum likelihood solution W ML for the parameter matrix W has the property that each column is given by an expression of the form (3.15), which was the solution for an isotropic noise distribution. Note that this is independent of the covariance matrix Σ . Show that the maximum likelihood solution for Σ is given by

$$
p ( t | W , \Sigma ) = \mathcal { N } ( t | y ( x , W ) , \Sigma )
$$

$$
y ( x , W ) = W ^ { T } \phi ( x )
$$

$$
\Sigma & = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \left ( t _ { n } - W _ { M L } ^ { T } \phi ( x _ { n } ) \right ) \left ( t _ { n } - W _ { M L } ^ { T } \phi ( x _ { n } ) \right ) ^ { T } . \\ \\ ( \, ) \, D _ { 0 } \, \colon \, & \quad \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \, \cdot \,
$$

3.7 ( ) By using the technique of completing the square, verify the result (3.49) for the posterior distribution of the parameters w in the linear basis function model in which m N and S N are deﬁned by (3.50) and (3.51) respectively.

3.8 ( ) www Consider the linear basis function model in Section 3.1, and suppose that we have already observed N data points, so that the posterior distribution over w is given by (3.49). This posterior can be regarded as the prior for the next observation. By considering an additional data point ( x N +1 ,t N +1 ) , and by completing the square in the exponential, show that the resulting posterior distribution is again given by (3.49) but with S N replaced by S N +1 and m N replaced by m N +1 .

3.9 ( ) Repeat the previous exercise but instead of completing the square by hand, make use of the general result for linear-Gaussian models given by (2.116).

3.10 ( ) www By making use of the result (2.115) to evaluate the integral in (3.57), verify that the predictive distribution for the Bayesian linear regression model is given by (3.58) in which the input-dependent variance is given by (3.59).

3.11 ( ) We have seen that, as the size of a data set increases, the uncertainty associated with the posterior distribution over model parameters decreases. Make use of the matrix identity (Appendix C)

$$
\text {Identity} \, ( \text {Appendix} \, C ) ^ { - 1 } & = M ^ { - 1 } = M ^ { - 1 } - \frac { ( M ^ { - 1 } v ) \left ( v ^ { T } M ^ { - 1 } \right ) } { 1 + v ^ { T } M ^ { - 1 } v } \quad ( 3 . 1 1 0 ) \\ \intertext { w h t a t h e u n c t a i n t y } \sigma _ { N } ^ { 2 } ( x ) \, \text { associated with the linear regression function}
$$

to show that the uncertainty σ 2 N ( x ) associated with the linear regression function given by (3.59) satisﬁes 2 2

$$
\sigma _ { N + 1 } ^ { 2 } ( x ) \leqslant \sigma _ { N } ^ { 2 } ( x ) .
$$

3.12 ( ) We saw in Section 2.3.6 that the conjugate prior for a Gaussian distribution with unknown mean and unknown precision (inverse variance) is a normal-gamma distribution. This property also holds for the case of the conditional Gaussian distribution p ( t | x , w ,β ) of the linear regression model. If we consider the likelihood function (3.10), then the conjugate prior for w and β is given by

$$
p ( w , \beta ) = \mathcal { N } ( w | m _ { 0 } , \beta ^ { - 1 } S _ { 0 } ) G a m ( \beta | a _ { 0 } , b _ { 0 } ) .
$$

Show that the corresponding posterior distribution takes the same functional form, so that 1

$$
p ( w , \beta | \mathfrak { t } ) = \mathcal { N } ( w | \mathfrak { m } _ { N } , \beta ^ { - 1 } S _ { N } ) \text {Gam} ( \beta | a _ { N } , b _ { N } ) \\ \text {ind.} \, \exp o r a i o n \, \text {for the $n$-atom $m$-atom $n$} \quad \text {S} _ { N } \, \text {, } \, \text {e} d \, h
$$

and ﬁnd expressions for the posterior parameters m N , S N , a N , and b N .

3.13 ( ) Show that the predictive distribution p ( t | x , t ) for the model discussed in Exercise 3.12 is given by a Student’s t-distribution of the form

$$
p ( t | x , \mathbf t ) = S t ( t | \mu , \lambda , \nu )
$$

and obtain expressions for µ , λ and ν .

3.14 ( ) In this exercise, we explore in more detail the properties of the equivalent kernel deﬁned by (3.62), where S N is deﬁned by (3.54). Suppose that the basis functions φ j ( x ) are linearly independent and that the number N of data points is greater than the number M of basis functions. Furthermore, let one of the basis functions be constant, say φ 0 ( x ) = 1 . By taking suitable linear combinations of these basis functions, we can construct a new basis set ψ j ( x ) spanning the same space but that are orthonormal, so that

$$
\sum _ { n = 1 } ^ { N } \psi _ { j } ( x _ { n } ) \psi _ { k } ( x _ { n } ) = I _ { j k } \\ \intertext { d t o b 1 if $j = k$ and 0$ otherwise $j \text { and } $v \text { to } $k \text { also } $v/x$}
$$

where I jk is deﬁned to be 1 if j = k and 0 otherwise, and we take ψ 0 ( x ) = 1 . Show that for α = 0 , the equivalent kernel can be written as k ( x , x ) = ψ ( x ) T ψ ( x ) where ψ = ( ψ 1 ,...,ψ M ) T . Use this result to show that the kernel satisﬁes the summation constraint N

$$
\sum _ { n = 1 } ^ { N } k ( x , x _ { n } ) = 1 . \\
$$

3.15 ( ) www Consider a linear basis function model for regression in which the parameters α and β are set using the evidence framework. Show that the function E ( m N ) deﬁned by (3.82) satisﬁes the relation 2 E ( m N ) = N .

3.16 ( ) Derive the result (3.86) for the log evidence function p ( t | α,β ) of the linear regression model by making use of (2.115) to evaluate the integral (3.77) directly.

3.17 ( ) Show that the evidence function for the Bayesian linear regression model can be written in the form (3.78) in which E ( w ) is deﬁned by (3.79).

3.18 ( ) www By completing the square over w , show that the error function (3.79) in Bayesian linear regression can be written in the form (3.80).

3.19 ( ) Show that the integration over w in the Bayesian linear regression model gives the result (3.85). Hence show that the log marginal likelihood is given by (3.86).

3.20 ( ) www Starting from (3.86) verify all of the steps needed to show that maximization of the log marginal likelihood function (3.86) with respect to α leads to the re-estimation equation (3.92).

3.21 ( ) An alternative way to derive the result (3.92) for the optimal value of α in the evidence framework is to make use of the identity

$$
\frac { d } { d \alpha } \ln | A | & = \text {Tr} \left ( A ^ { - 1 } \frac { d } { d \alpha } A \right ) . \\ \intertext { i t h s w . s e i n d i r i n g w h s c r . }
$$

Prove this identity by considering the eigenvalue expansion of a real, symmetric matrix A , and making use of the standard results for the determinant and trace of A expressed in terms of its eigenvalues (Appendix C). Then make use of (3.117) to derive (3.92) starting from (3.86).

3.22 ( ) Starting from (3.86) verify all of the steps needed to show that maximization of the log marginal likelihood function (3.86) with respect to β leads to the re-estimation equation (3.95).

3.23 ( ) www Show that the marginal probability of the data, in other words the model evidence, for the model described in Exercise 3.12 is given by

$$
p ( \mathbf t ) = \frac { 1 } { ( 2 \pi ) ^ { N / 2 } } \frac { b _ { 0 } ^ { a _ { 0 } } } { b _ { N } ^ { a _ { N } } } \frac { \Gamma ( a _ { N } ) } { \Gamma ( a _ { 0 } ) } \frac { | S _ { N } | ^ { 1 / 2 } } { | S _ { 0 } | ^ { 1 / 2 } } \\ \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \cdot \quad \
$$

by ﬁrst marginalizing with respect to w and then with respect to β .

3.24 ( ) Repeat the previous exercise but now use Bayes’ theorem in the form

$$
p ( \mathbf t ) = \frac { p ( \mathbf t | \mathbf w , \beta ) p ( \mathbf w , \beta ) } { p ( \mathbf w , \beta | \mathbf t ) } \\
$$

and then substitute for the prior and posterior distributions and the likelihood function in order to derive the result (3.118).

![image 19](Bishop2006_images/imageFile19.png)

## 4 Linear Models for Classification Exercises

4.1 ( ) Given a set of data points { x n } , we can deﬁne the convex hull to be the set of all points x given by

$$
x & = \sum _ { n } \alpha _ { n } x _ { n } \\ n & = 1 . \, \text {Consider a second set of points} \, \{ y _ { n } \} \, \text { together with}
$$

n where α n 0 and n α n = 1 . Consider a second set of points { y n } together with their corresponding convex hull. By deﬁnition, the two sets of points will be linearly separable if there exists a vector w and a scalar w 0 such that w T x n + w 0 > 0 for all x n , and w T y n + w 0 < 0 for all y n . Show that if their convex hulls intersect, the two sets of points cannot be linearly separable, and conversely that if they are linearly separable, their convex hulls do not intersect.

4.2 ( ) www Consider the minimization of a sum-of-squares error function (4.15), and suppose that all of the target vectors in the training set satisfy a linear constraint

$$
a ^ { T } t _ { n } + b = 0
$$

where t n corresponds to the n th row of the matrix T in (4.15). Show that as a consequence of this constraint, the elements of the model prediction y ( x ) given by the least-squares solution (4.17) also satisfy this constraint, so that

$$
a ^ { T } y ( x ) + b = 0 .
$$

To do so, assume that one of the basis functions φ 0 ( x ) = 1 so that the corresponding parameter w 0 plays the role of a bias.

4.3 ( ) Extend the result of Exercise 4.2 to show that if multiple linear constraints are satisﬁed simultaneously by the target vectors, then the same constraints will also be satisﬁed by the least-squares prediction of a linear model.

4.4 ( ) www Show that maximization of the class separation criterion given by (4.23) with respect to w , using a Lagrange multiplier to enforce the constraint w T w = 1 , leads to the result that w ∝ ( m 2 − m 1 ) .

4.5 ( ) By making use of (4.20), (4.23), and (4.24), show that the Fisher criterion (4.25) can be written in the form (4.26).

4.6 ( ) Using the deﬁnitions of the between-class and within-class covariance matrices given by (4.27) and (4.28), respectively, together with (4.34) and (4.36) and the choice of target values described in Section 4.1.5, show that the expression (4.33) that minimizes the sum-of-squares error function can be written in the form (4.37).

4.7 ( ) www Show that the logistic sigmoid function (4.59) satisﬁes the property σ ( − a ) = 1 − σ ( a ) and that its inverse is given by σ − 1 ( y ) = ln { y/ (1 − y ) } .

4.8 ( ) Using (4.57) and (4.58), derive the result (4.65) for the posterior class probability in the two-class generative model with Gaussian densities, and verify the results (4.66) and (4.67) for the parameters w and w 0 .

4.9 ( ) www Consider a generative classiﬁcation model for K classes deﬁned by prior class probabilities p ( C k ) = π k and general class-conditional densities p ( φ |C k ) where φ is the input feature vector. Suppose we are given a training data set { φ n , t n } where n = 1 ,...,N , and t n is a binary target vector of length K that uses the 1-ofK coding scheme, so that it has components t nj = I jk if pattern n is from class C k . Assuming that the data points are drawn independently from this model, show that the maximum-likelihood solution for the prior probabilities is given by

$$
\pi _ { k } = \frac { N _ { k } } { N }
$$

where N k is the number of data points assigned to class C k .

4.10 ( ) Consider the classiﬁcation model of Exercise 4.9 and now suppose that the class-conditional densities are given by Gaussian distributions with a shared covariance matrix, so that

$$
p ( \phi | \mathcal { C } _ { k } ) = \mathcal { N } ( \phi | \mu _ { k } , \Sigma ) . \\ \intertext { p ( \phi | \mathcal { C } _ { k } ) = \mathcal { N } ( \phi | \mu _ { k } , \Sigma ) . } \intertext { r ! 1 1 } \intertext { r ! 1 1 } \intertext { r ! 2 1 }
$$

Show that the maximum likelihood solution for the mean of the Gaussian distribution for class C k is given by 1 N

$$
\mu _ { k } = \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } t _ { n k } \phi _ { n }
$$

which represents the mean of those feature vectors assigned to class C k . Similarly, show that the maximum likelihood solution for the shared covariance matrix is given by

$$
\Sigma = \sum _ { k = 1 } ^ { K } \frac { N _ { k } } { N } S _ { k } \\
$$

where

$$
S _ { k } = \frac { 1 } { N _ { k } } \sum _ { n = 1 } ^ { N } t _ { n k } ( \phi _ { n } - \mu _ { k } ) ( \phi _ { n } - \mu _ { k } ) ^ { T } . \\ \text {given by a weighted average of the covariances of the data associated with}
$$

Thus Σ is given by a weighted average of the covariances of the data associated with each class, in which the weighting coefﬁcients are given by the prior probabilities of the classes.

4.11 ( ) Consider a classiﬁcation problem with K classes for which the feature vector φ has M components each of which can take L discrete states. Let the values of the components be represented by a 1-ofL binary coding scheme. Further suppose that, conditioned on the class C k , the M components of φ are independent, so that the class-conditional density factorizes with respect to the feature vector components. Show that the quantities a k given by (4.63), which appear in the argument to the softmax function describing the posterior class probabilities, are linear functions of the components of φ . Note that this represents an example of the naive Bayes model which is discussed in Section 8.2.2.

4.12 ( ) www Verify the relation (4.88) for the derivative of the logistic sigmoid function deﬁned by (4.59).

4.13 ( ) www By making use of the result (4.88) for the derivative of the logistic sigmoid, show that the derivative of the error function (4.90) for the logistic regression model is given by (4.91).

4.14 ( ) Show that for a linearly separable data set, the maximum likelihood solution for the logistic regression model is obtained by ﬁnding a vector w whose decision boundary w T φ ( x ) = 0 separates the classes and then taking the magnitude of w to inﬁnity.

4.15 ( ) Show that the Hessian matrix H for the logistic regression model, given by (4.97), is positive deﬁnite. Here R is a diagonal matrix with elements y n (1 − y n ) , and y n is the output of the logistic regression model for input vector x n . Hence show that the error function is a concave function of w and that it has a unique minimum.

4.16 ( ) Consider a binary classiﬁcation problem in which each observation x n is known to belong to one of two classes, corresponding to t = 0 and t = 1 , and suppose that the procedure for collecting training data is imperfect, so that training points are sometimes mislabelled. For every data point x n , instead of having a value t for the class label, we have instead a value π n representing the probability that t n = 1 . Given a probabilistic model p ( t = 1 | φ ) , write down the log likelihood function appropriate to such a data set.

4.17 ( ) www Show that the derivatives of the softmax activation function (4.104), where the a k are deﬁned by (4.105), are given by (4.106).

4.18 ( ) Using the result (4.91) for the derivatives of the softmax activation function, show that the gradients of the cross-entropy error (4.108) are given by (4.109).

4.19 ( ) www Write down expressions for the gradient of the log likelihood, as well as the corresponding Hessian matrix, for the probit regression model deﬁned in Section 4.3.5. These are the quantities that would be required to train such a model using IRLS.

4.20 ( ) Show that the Hessian matrix for the multiclass logistic regression problem, deﬁned by (4.110), is positive semideﬁnite. Note that the full Hessian matrix for this problem is of size MK × MK , where M is the number of parameters and K is the number of classes. To prove the positive semideﬁnite property, consider the product u T Hu where u is an arbitrary vector of length MK , and then apply Jensen’s inequality.

4.21 ( ) Show that the probit function (4.114) and the erf function (4.115) are related by (4.116).

4.22 ( ) Using the result (4.135), derive the expression (4.137) for the log model evidence under the Laplace approximation.

4.23 ( ) www In this exercise, we derive the BIC result (4.139) starting from the Laplace approximation to the model evidence given by (4.137). Show that if the prior over parameters is Gaussian of the form p ( θ ) = N ( θ | m , V 0 ) , the log model evidence under the Laplace approximation takes the form

$$
\ln p ( \mathcal { D } ) \simeq \ln p ( \mathcal { D } | \theta _ { M A P } ) - \frac { 1 } { 2 } ( \theta _ { M A P } - m ) ^ { T } V _ { 0 } ^ { - 1 } ( \theta _ { M A P } - m ) - \frac { 1 } { 2 } \ln | H | + \text {const}
$$

where H is the matrix of second derivatives of the log likelihood ln p ( D| θ ) evaluated at θ MAP . Now assume that the prior is broad so that V − 1 0 is small and the second term on the right-hand side above can be neglected. Furthermore, consider the case of independent, identically distributed data so that H is the sum of terms one for each data point. Show that the log model evidence can then be written approximately in the form of the BIC expression (4.139).

4.24 ( ) Use the results from Section 2.3.2 to derive the result (4.151) for the marginalization of the logistic regression model with respect to a Gaussian posterior distribution over the parameters w .

4.25 ( ) Suppose we wish to approximate the logistic sigmoid σ ( a ) deﬁned by (4.59) by a scaled probit function Φ( λa ) , where Φ( a ) is deﬁned by (4.114). Show that if λ is chosen so that the derivatives of the two functions are equal at a = 0 , then λ 2 = π/ 8 .

4.26 ( ) In this exercise, we prove the relation (4.152) for the convolution of a probit function with a Gaussian distribution. To do this, show that the derivative of the lefthand side with respect to µ is equal to the derivative of the right-hand side, and then integrate both sides with respect to µ and then show that the constant of integration vanishes. Note that before differentiating the left-hand side, it is convenient ﬁrst to introduce a change of variable given by a = µ + σz so that the integral over a is replaced by an integral over z . When we differentiate the left-hand side of the relation (4.152), we will then obtain a Gaussian integral over z that can be evaluated analytically.

![image 24](Bishop2006_images/imageFile24.png)

## 5 Neural Networks Exercises

5.1 ( ) Consider a two-layer network function of the form (5.7) in which the hiddenunit nonlinear activation functions g ( · ) are given by logistic sigmoid functions of the form 1

$$
\sigma ( a ) = \{ 1 + \exp ( - a ) \} ^ { - 1 } \, . \\ \intertext { i t s e r } \sigma ( a ) = \{ 1 + \exp ( - a ) \} ^ { - 1 } \, .
$$

Show that there exists an equivalent network, which computes exactly the same function, but with hidden unit activation functions given by tanh( a ) where the tanh function is deﬁned by (5.59). Hint: ﬁrst ﬁnd the relation between σ ( a ) and tanh( a ) , and then show that the parameters of the two networks differ by linear transformations.

5.2 ( ) www Show that maximizing the likelihood function under the conditional distribution (5.16) for a multioutput neural network is equivalent to minimizing the sum-of-squares error function (5.11).

5.3 ( ) Consider a regression problem involving multiple target variables in which it is assumed that the distribution of the targets, conditioned on the input vector x , is a Gaussian of the form

$$
p ( t | x , w ) = \mathcal { N } ( t | y ( x , w ) , \Sigma ) \\ \intertext { f o r } \intertext { i s t h e w t w i t h e f a w i l l w i t h e w i t w i t h e w a l d w i t h e w s }
$$

where y ( x , w ) is the output of a neural network with input vector x and weight vector w , and Σ is the covariance of the assumed Gaussian noise on the targets. Given a set of independent observations of x and t , write down the error function that must be minimized in order to ﬁnd the maximum likelihood solution for w , if we assume that Σ is ﬁxed and known. Now assume that Σ is also to be determined from the data, and write down an expression for the maximum likelihood solution for Σ . Note that the optimizations of w and Σ are now coupled, in contrast to the case of independent target variables discussed in Section 5.2.

5.4 ( ) Consider a binary classiﬁcation problem in which the target values are t ∈ { 0 , 1 } , with a network output y ( x , w ) that represents p ( t = 1 | x ) , and suppose that there is a probability that the class label on a training data point has been incorrectly set. Assuming independent and identically distributed data, write down the error function corresponding to the negative log likelihood. Verify that the error function (5.21) is obtained when = 0 . Note that this error function makes the model robust to incorrectly labelled data, in contrast to the usual error function.

5.5 ( ) www Show that maximizing likelihood for a multiclass neural network model in which the network outputs have the interpretation y k ( x , w ) = p ( t k = 1 | x ) is equivalent to the minimization of the cross-entropy error function (5.24).

5.6 ( ) www Show the derivative of the error function (5.21) with respect to the activation a k for an output unit having a logistic sigmoid activation function satisﬁes (5.18).

5.7 ( ) Show the derivative of the error function (5.24) with respect to the activation a k for output units having a softmax activation function satisﬁes (5.18).

5.8 ( ) We saw in (4.88) that the derivative of the logistic sigmoid activation function can be expressed in terms of the function value itself. Derive the corresponding result for the ‘ tanh ’ activation function deﬁned by (5.59).

5.9 ( ) www The error function (5.21) for binary classiﬁcation problems was derived for a network having a logistic-sigmoid output activation function, so that 0 y ( x , w ) 1 , and data having target values t ∈ { 0 , 1 } . Derive the corresponding error function if we consider a network having an output − 1 y ( x , w ) 1 and target values t = 1 for class C 1 and t = − 1 for class C 2 . What would be the appropriate choice of output unit activation function?

5.10 ( ) www Consider a Hessian matrix H with eigenvector equation (5.33). By setting the vector v in (5.39) equal to each of the eigenvectors u i in turn, show that H is positive deﬁnite if, and only if, all of its eigenvalues are positive.

5.11 ( ) www Consider a quadratic error function deﬁned by (5.32), in which the Hessian matrix H has an eigenvalue equation given by (5.33). Show that the contours of constant error are ellipses whose axes are aligned with the eigenvectors u i , with lengths that are inversely proportional to the square root of the corresponding eigenvalues λ i .

5.12 ( ) www By considering the local Taylor expansion (5.32) of an error function about a stationary point w , show that the necessary and sufﬁcient condition for the stationary point to be a local minimum of the error function is that the Hessian matrix H , deﬁned by (5.30) with w = w , be positive deﬁnite.

5.13 ( ) Show that as a consequence of the symmetry of the Hessian matrix H , the number of independent elements in the quadratic error function (5.28) is given by W ( W + 3) / 2 .

5.14 ( ) By making a Taylor expansion, verify that the terms that are O ( ) cancel on the right-hand side of (5.69).

5.15 ( ) In Section 5.3.4, we derived a procedure for evaluating the Jacobian matrix of a neural network using a backpropagation procedure. Derive an alternative formalism for ﬁnding the Jacobian based on forward propagation equations.

5.16 ( ) The outer product approximation to the Hessian matrix for a neural network using a sum-of-squares error function is given by (5.84). Extend this result to the case of multiple outputs.

5.17 ( ) Consider a squared loss function of the form

$$
\text {der a squared loss function of the form} \\ E = \frac { 1 } { 2 } \iint \{ y ( x , w ) - t \} ^ { 2 } \, p ( x , t ) \, d x \, d t \\ \text {, } w \text { is a parametric function such as a neural network. The result (1,89)}
$$

where y ( x , w ) is a parametric function such as a neural network. The result (1.89) shows that the function y ( x , w ) that minimizes this error is given by the conditional expectation of t given x . Use this result to show that the second derivative of E with respect to two elements w r and w s of the vector w , is given by

$$
\text {elements} \ w _ { r } \text { and } w _ { s } \text { of the vector } w , \text { is given by} \\ \frac { \partial ^ { 2 } E } { \partial w _ { r } \partial w _ { s } } = \int \frac { \partial y } { \partial w _ { r } } \frac { \partial y } { \partial w _ { s } } p ( x ) \, d x . \\ \intertext { a n i t h e m p l e s o m p l e s } \text {finite sample from } p ( x ) , \text { we obtain } ( 5 . 8 4 ) ,
$$

Note that, for a ﬁnite sample from p ( x ) , we obtain (5.84).

5.18 ( ) Consider a two-layer network of the form shown in Figure 5.1 with the addition of extra parameters corresponding to skip-layer connections that go directly from the inputs to the outputs. By extending the discussion of Section 5.3.2, write down the equations for the derivatives of the error function with respect to these additional parameters.

5.19 ( ) www Derive the expression (5.85) for the outer product approximation to the Hessian matrix for a network having a single output with a logistic sigmoid output-unit activation function and a cross-entropy error function, corresponding to the result (5.84) for the sum-of-squares error function.

5.20 ( ) Derive an expression for the outer product approximation to the Hessian matrix for a network having K outputs with a softmax output-unit activation function and a cross-entropy error function, corresponding to the result (5.84) for the sum-ofsquares error function.

5.21 ( ) Extend the expression (5.86) for the outer product approximation of the Hessian matrix to the case of K > 1 output units. Hence, derive a recursive expression analogous to (5.87) for incrementing the number N of patterns and a similar expression for incrementing the number K of outputs. Use these results, together with the identity (5.88), to ﬁnd sequential update expressions analogous to (5.89) for ﬁnding the inverse of the Hessian by incrementally including both extra patterns and extra outputs.

5.22 ( ) Derive the results (5.93), (5.94), and (5.95) for the elements of the Hessian matrix of a two-layer feed-forward network by application of the chain rule of calculus.

5.23 ( ) Extend the results of Section 5.4.5 for the exact Hessian of a two-layer network to include skip-layer connections that go directly from inputs to outputs.

5.24 ( ) Verify that the network function deﬁned by (5.113) and (5.114) is invariant under the transformation (5.115) applied to the inputs, provided the weights and biases are simultaneously transformed using (5.116) and (5.117). Similarly, show that the network outputs can be transformed according (5.118) by applying the transformation (5.119) and (5.120) to the second-layer weights and biases.

5.25 ( ) www Consider a quadratic error function of the form

$$
E = E _ { 0 } + \frac { 1 } { 2 } ( w - w ^ { * } ) ^ { T } H ( w - w ^ { * } )
$$

where w represents the minimum, and the Hessian matrix H is positive deﬁnite and constant. Suppose the initial weight vector w (0) is chosen to be at the origin and is updated using simple gradient descent

$$
w ^ { ( \tau ) } = w ^ { ( \tau - 1 ) } - \rho \nabla E
$$

where τ denotes the step number, and ρ is the learning rate (which is assumed to be small). Show that, after τ steps, the components of the weight vector parallel to the eigenvectors of H can be written

$$
w _ { j } ^ { ( \tau ) } = \{ 1 - ( 1 - \rho \eta _ { j } ) ^ { \tau } \} w _ { j } ^ { * }
$$

where w j = w T u j , and u j and η j are the eigenvectors and eigenvalues, respectively, of H so that

$$
H u _ { j } = \eta _ { j } u _ { j } .
$$

Show that as τ → ∞ , this gives w ( τ ) → w as expected, provided | 1 − ρη j | < 1 . Now suppose that training is halted after a ﬁnite number τ of steps. Show that the

$$
w _ { j } ^ { ( \tau ) } \simeq w _ { j } ^ { * } \ \text {when} \ \eta _ { j } \gg ( \rho \tau ) ^ { - 1 } & & ( 5 . 1 9 9 ) \\ ( \tau ) _ { 1 } & \dots & ( 1 + 1 ) ^ { 2 } & & ( - 1 ) ^ { 2 } \\
$$

$$
| w _ { j } ^ { ( \tau ) } | & \ll | w _ { j } ^ { * } | \quad \text {when } \eta _ { j } \ll ( \rho \tau ) ^ { - 1 } . \\ \vdots & \quad \ \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots \quad \vdots
$$

Compare this result with the discussion in Section 3.5.3 of regularization with simple weight decay, and hence show that ( ρτ ) − 1 is analogous to the regularization parameter λ . The above results also show that the effective number of parameters in the network, as deﬁned by (3.91), grows as the training progresses.

5.26 ( ) Consider a multilayer perceptron with arbitrary feed-forward topology, which is to be trained by minimizing the tangent propagation error function (5.127) in which the regularizing function is given by (5.128). Show that the regularization term Ω can be written as a sum over patterns of terms of the form

$$
\Omega _ { n } = \frac { 1 } { 2 } \sum _ { k } ( \mathcal { G } y _ { k } ) ^ { 2 } \\ \intertext { a l $ o r $ a r $ o r $ d e f i n e $ d y $ } \left ( \begin{matrix} \Omega _ { n } = \frac { 1 } { 2 } \sum _ { k } ( \mathcal { G } y _ { k } ) ^ { 2 } & & ( 5 . 2 1 ) \\ \end{matrix} \right ) \\ \intertext { a l $ o r $ a r $ d e f i n e $ d y $ } \left ( \begin{matrix} 0 . 5 1 \\ 0 . 5 2 \end{matrix} \right )
$$

where G is a differential operator deﬁned by

$$
\mathcal { G } \equiv & \sum _ { i } \tau _ { i } \frac { \partial } { \partial x _ { i } } . \\ \text {propagation equations}
$$

By acting on the forward propagation equations

$$
\text {the forward propagation equations} \\ z _ { j } = h ( a _ { j } ) , \quad a _ { j } = \sum _ { i } w _ { j i } z _ { i } \\ \text {ator} \, \mathcal { G } , \text { show that } \Omega _ { n } \text { can be evaluated by forward propagation using}
$$

with the operator G , show that Ω n can be evaluated by forward propagation using the following equations:

$$
\begin{array} { c c } \arg \text {equalations} \colon \\ \alpha _ { j } = h ^ { \prime } ( \alpha _ { j } ) \beta _ { j } , & \beta _ { j } = \sum _ { i } w _ { j i } \alpha _ { i } . \\ \end{array} \quad ( 5 . 2 0 4 ) \\ \text {leave defined the new variables}
$$

where we have deﬁned the new variables

$$
\alpha _ { j } & \equiv \mathcal { G } z _ { j } , \quad \beta _ { j } \equiv \mathcal { G } a _ { j } . \\ \\ ( 1 - ( 1 + \alpha _ { j } ) ) & = \mathcal { G } z _ { j } , \quad \beta _ { j } \equiv \mathcal { G } a _ { j } .
$$

Now show that the derivatives of Ω n with respect to a weight w rs in the network can be written in the form

$$
\frac { \partial \Omega _ { n } } { \partial w _ { r s } } = \sum _ { k } \alpha _ { k } \left \{ \phi _ { k r } z _ { s } + \delta _ { k r } \alpha _ { s } \right \} \\ \text {defined}
$$

where we have deﬁned

$$
\delta _ { k r } \equiv \frac { \partial y _ { k } } { \partial a _ { r } } , \quad \phi _ { k r } \equiv \mathcal { G } \delta _ { k r } .
$$

Write down the backpropagation equations for δ kr , and hence derive a set of backpropagation equations for the evaluation of the φ kr .

5.27 ( ) www Consider the framework for training with transformed data in the special case in which the transformation consists simply of the addition of random noise x → x + ξ where ξ has a Gaussian distribution with zero mean and unit covariance. By following an argument analogous to that of Section 5.5.5, show that the resulting regularizer reduces to the Tikhonov form (5.135).

5.28 ( ) www Consider a neural network, such as the convolutional network discussed in Section 5.5.6, in which multiple weights are constrained to have the same value. Discuss how the standard backpropagation algorithm must be modiﬁed in order to ensure that such constraints are satisﬁed when evaluating the derivatives of an error function with respect to the adjustable parameters in the network.

5.29 ( ) www Verify the result (5.141).

5.30 ( ) Verify the result (5.142).

5.31 ( ) Verify the result (5.143).

5.32 ( ) Show that the derivatives of the mixing coefﬁcients { π k } , deﬁned by (5.146), with respect to the auxiliary parameters { η j } are given by

$$
\frac { \partial \pi _ { k } } { \partial \eta _ { j } } = \delta _ { j k } \pi _ { j } - \pi _ { j } \pi _ { k } .
$$

Hence, by making use of the constraint k π k = 1 , derive the result (5.147). 5.33 ( ) Write down a pair of equations that express the Cartesian coordinates ( x 1 ,x 2 ) for the robot arm shown in Figure 5.18 in terms of the joint angles θ 1 and θ 2 and the lengths L 1 and L 2 of the links. Assume the origin of the coordinate system is given by the attachment point of the lower arm. These equations deﬁne the ‘forward kinematics’ of the robot arm.

5.34 ( ) www Derive the result (5.155) for the derivative of the error function with respect to the network output activations controlling the mixing coefﬁcients in the mixture density network.

5.35 ( ) Derive the result (5.156) for the derivative of the error function with respect to the network output activations controlling the component means in the mixture density network.

5.36 ( ) Derive the result (5.157) for the derivative of the error function with respect to the network output activations controlling the component variances in the mixture density network.

5.37 ( ) Verify the results (5.158) and (5.160) for the conditional mean and variance of the mixture density network model.

5.38 ( ) Using the general result (2.115), derive the predictive distribution (5.172) for the Laplace approximation to the Bayesian neural network model.

5.39 ( ) www Make use of the Laplace approximation result (4.135) to show that the evidence function for the hyperparameters α and β in the Bayesian neural network model can be approximated by (5.175).

5.40 ( ) www Outline the modiﬁcations needed to the framework for Bayesian neural networks, discussed in Section 5.7.3, to handle multiclass problems using networks having softmax output-unit activation functions.

5.41 ( ) By following analogous steps to those given in Section 5.7.1 for regression networks, derive the result (5.183) for the marginal likelihood in the case of a network having a cross-entropy error function and logistic-sigmoid output-unit activation function.

Chapter 5

Section 2.5.1

![image 27](Bishop2006_images/imageFile27.png)

6

## 6 Kernel Methods Exercises

6.1 ( ) www Consider the dual formulation of the least squares linear regression problem given in Section 6.1. Show that the solution for the components a n of the vector a can be expressed as a linear combination of the elements of the vector φ ( x n ) . Denoting these coefﬁcients by the vector w , show that the dual of the dual formulation is given by the original representation in terms of the parameter vector w .

6.2 ( ) In this exercise, we develop a dual formulation of the perceptron learning algorithm. Using the perceptron learning rule (4.55), show that the learned weight vector w can be written as a linear combination of the vectors t n φ ( x n ) where t n ∈ {− 1 , +1 } . Denote the coefﬁcients of this linear combination by α n and derive a formulation of the perceptron learning algorithm, and the predictive function for the perceptron, in terms of the α n . Show that the feature vector φ ( x ) enters only in the form of the kernel function k ( x , x ) = φ ( x ) T φ ( x ) .

6.3 ( ) The nearest-neighbour classiﬁer (Section 2.5.2) assigns a new input vector x to the same class as that of the nearest input vector x n from the training set, where in the simplest case, the distance is deﬁned by the Euclidean metric x − x n 2 . By expressing this rule in terms of scalar products and then making use of kernel substitution, formulate the nearest-neighbour classiﬁer for a general nonlinear kernel.

6.4 ( ) In Appendix C, we give an example of a matrix that has positive elements but that has a negative eigenvalue and hence that is not positive deﬁnite. Find an example of the converse property, namely a 2 × 2 matrix with positive eigenvalues yet that has at least one negative element.

6.5 ( ) www Verify the results (6.13) and (6.14) for constructing valid kernels.

6.6 ( ) Verify the results (6.15) and (6.16) for constructing valid kernels.

6.7 ( ) www Verify the results (6.17) and (6.18) for constructing valid kernels.

6.8 ( ) Verify the results (6.19) and (6.20) for constructing valid kernels.

6.9 ( ) Verify the results (6.21) and (6.22) for constructing valid kernels.

6.10 ( ) Show that an excellent choice of kernel for learning a function f ( x ) is given by k ( x , x ) = f ( x ) f ( x ) by showing that a linear learning machine based on this kernel will always ﬁnd a solution proportional to f ( x ) .

6.11 ( ) By making use of the expansion (6.25), and then expanding the middle factor as a power series, show that the Gaussian kernel (6.23) can be expressed as the inner product of an inﬁnite-dimensional feature vector.

6.12 ( ) www Consider the space of all possible subsets A of a given ﬁxed set D . Show that the kernel function (6.27) corresponds to an inner product in a feature space of dimensionality 2 | D | deﬁned by the mapping φ ( A ) where A is a subset of D and the element φ U ( A ) , indexed by the subset U , is given by

$$
\phi _ { U } ( A ) = \begin{cases} & 1 , \text { if } U \subseteq A ; \\ & 0 , \text { otherwise.} \end{cases}
$$

Here U ⊆ A denotes that U is either a subset of A or is equal to A .

6.13 ( ) Show that the Fisher kernel, deﬁned by (6.33), remains invariant if we make a nonlinear transformation of the parameter vector θ → ψ ( θ ) , where the function ψ ( · ) is invertible and differentiable.

6.14 ( ) www Write down the form of the Fisher kernel, deﬁned by (6.33), for the case of a distribution p ( x | µ ) = N ( x | µ , S ) that is Gaussian with mean µ and ﬁxed covariance S .

6.15 ( ) By considering the determinant of a 2 × 2 Gram matrix, show that a positivedeﬁnite kernel function k ( x,x ) satisﬁes the Cauchy-Schwartz inequality

$$
k ( x _ { 1 } , x _ { 2 } ) ^ { 2 } \leqslant k ( x _ { 1 } , x _ { 1 } ) k ( x _ { 2 } , x _ { 2 } ) .
$$

6.16 ( ) Consider a parametric model governed by the parameter vector w together with a data set of input values x 1 ,..., x N and a nonlinear feature mapping φ ( x ) . Suppose that the dependence of the error function on w takes the form

$$
J ( \mathbf w ) = f ( \mathbf w ^ { T } \phi ( \mathbf x _ { 1 } ) , \dots , \mathbf w ^ { T } \phi ( \mathbf x _ { N } ) ) + g ( \mathbf w ^ { T } \mathbf w )
$$

where g ( · ) is a monotonically increasing function. By writing w in the form

$$
w = \sum _ { n = 1 } ^ { N } \alpha _ { n } \phi ( x _ { n } ) + w _ { \perp } \\ \intertext { f o r w t h o t \minimize } \intertext { o f w t h o t \minimize } \intertext { o f w t h o t \max } \intertext { o f w t h o t \minimize }
$$

show that the value of w that minimizes J ( w ) takes the form of a linear combination of the basis functions φ ( x n ) for n = 1 ,...,N .

6.17 ( ) www Consider the sum-of-squares error function (6.39) for data having noisy inputs, where ν ( ξ ) is the distribution of the noise. Use the calculus of variations to minimize this error function with respect to the function y ( x ) , and hence show that the optimal solution is given by an expansion of the form (6.40) in which the basis functions are given by (6.41).

6.18 ( ) Consider a Nadaraya-Watson model with one input variable x and one target variable t having Gaussian components with isotropic covariances, so that the covariance matrix is given by σ 2 I where I is the unit matrix. Write down expressions for the conditional density p ( t | x ) and for the conditional mean E [ t | x ] and variance var[ t | x ] , in terms of the kernel function k ( x,x n ) .

6.19 ( ) Another viewpoint on kernel regression comes from a consideration of regression problems in which the input variables as well as the target variables are corrupted with additive noise. Suppose each target value t n is generated as usual by taking a function y ( z n ) evaluated at a point z n , and adding Gaussian noise. The value of z n is not directly observed, however, but only a noise corrupted version x n = z n + ξ n where the random variable ξ is governed by some distribution g ( ξ ) . Consider a set of observations { x n ,t n } , where n = 1 ,...,N , together with a corresponding sum-of-squares error function deﬁned by averaging over the distribution of input noise to give

$$
E = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \int \{ y ( x _ { n } - \xi _ { n } ) - t _ { n } \} ^ { 2 } \, g ( \xi _ { n } ) \, d \xi _ { n } . \\ \intertext { \text {imizing } F with respect to the function } u ( z ) \, \text {using the calculus of variations}
$$

By minimizing E with respect to the function y ( z ) using the calculus of variations (Appendix D), show that optimal solution for y ( x ) is given by a Nadaraya-Watson kernel regression solution of the form (6.45) with a kernel of the form (6.46).

6.20 ( ) www Verify the results (6.66) and (6.67).

6.21 ( ) www Consider a Gaussian process regression model in which the kernel function is deﬁned in terms of a ﬁxed set of nonlinear basis functions. Show that the predictive distribution is identical to the result (3.58) obtained in Section 3.3.2 for the Bayesian linear regression model. To do this, note that both models have Gaussian predictive distributions, and so it is only necessary to show that the conditional mean and variance are the same. For the mean, make use of the matrix identity (C.6), and for the variance, make use of the matrix identity (C.7).

6.22 ( ) Consider a regression problem with N training set input vectors x 1 ,..., x N and L test set input vectors x N +1 ,..., x N + L , and suppose we deﬁne a Gaussian process prior over functions t ( x ) . Derive an expression for the joint predictive distribution for t ( x N +1 ) ,...,t ( x N + L ), given the values of t ( x 1 ) ,...,t ( x N ) . Show the marginal of this distribution for one of the test observations t j where N + 1 j N + L is given by the usual Gaussian process regression result (6.66) and (6.67).

6.23 ( ) www Consider a Gaussian process regression model in which the target variable t has dimensionality D . Write down the conditional distribution of t N +1 for a test input vector x N +1 , given a training set of input vectors x 1 ,..., x N +1 and corresponding target observations t 1 ,..., t N .

6.24 ( ) Show that a diagonal matrix W whose elements satisfy 0 < W ii < 1 is positive deﬁnite. Show that the sum of two positive deﬁnite matrices is itself positive deﬁnite.

6.25 ( ) www Using the Newton-Raphson formula (4.92), derive the iterative update formula (6.83) for ﬁnding the mode a N of the posterior distribution in the Gaussian process classiﬁcation model.

6.26 ( ) Using the result (2.115), derive the expressions (6.87) and (6.88) for the mean and variance of the posterior distribution p ( a N +1 | t N ) in the Gaussian process classiﬁcation model.

6.27 ( ) Derive the result (6.90) for the log likelihood function in the Laplace approximation framework for Gaussian process classiﬁcation. Similarly, derive the results (6.91), (6.92), and (6.94) for the terms in the gradient of the log likelihood.

![image 30](Bishop2006_images/imageFile30.png)

## 7 Sparse Kernel Machines Exercises

7.1 ( ) www Suppose we have a data set of input vectors { x n } with corresponding target values t n ∈ {− 1 , 1 } , and suppose that we model the density of input vectors within each class separately using a Parzen kernel density estimator (see Section 2.5.1) with a kernel k ( x , x ) . Write down the minimum misclassiﬁcation-rate decision rule assuming the two classes have equal prior probability. Show also that, if the kernel is chosen to be k ( x , x ) = x T x , then the classiﬁcation rule reduces to simply assigning a new input vector to the class having the closest mean. Finally, show that, if the kernel takes the form k ( x , x ) = φ ( x ) T φ ( x ) , that the classiﬁcation is based on the closest mean in the feature space φ ( x ) .

7.2 ( ) Show that, if the 1 on the right-hand side of the constraint (7.5) is replaced by some arbitrary constant γ > 0 , the solution for the maximum margin hyperplane is unchanged.

7.3 ( ) Show that, irrespective of the dimensionality of the data space, a data set consisting of just two data points, one from each class, is sufﬁcient to determine the location of the maximum-margin hyperplane.

7.4 ( ) www Show that the value ρ of the margin for the maximum-margin hyperplane is given by

$$
\frac { 1 } { \rho ^ { 2 } } = \sum _ { n = 1 } ^ { N } a _ { n } \\ \maximizing \left ( 7 . 1 0 \right ) \text { subject to the constraints } \left ( 7 . 1 1 \right ) \text { and}
$$

where { a n } are given by maximizing (7.10) subject to the constraints (7.11) and (7.12).

7.5 ( ) Show that the values of ρ and { a n } in the previous exercise also satisfy

$$
\frac { 1 } { \rho ^ { 2 } } = 2 \widetilde { L } ( a ) \\ \\ . 1 0 ) . \text { Similarly, show that}
$$

where L ( a ) is deﬁned by (7.10). Similarly, show that 1 ρ 2 = w 2 .

$$
\frac { 1 } { \rho ^ { 2 } } = \| w \| ^ { 2 } .
$$

7.6 ( ) Consider the logistic regression model with a target variable t ∈ {− 1 , 1 } . If we deﬁne p ( t = 1 | y ) = σ ( y ) where y ( x ) is given by (7.1), show that the negative log likelihood, with the addition of a quadratic regularization term, takes the form (7.47).

7.7 ( ) Consider the Lagrangian (7.56) for the regression support vector machine. By setting the derivatives of the Lagrangian with respect to w , b , ξ n , and ξ n to zero and then back substituting to eliminate the corresponding variables, show that the dual Lagrangian is given by (7.61).

7.8 ( ) www For the regression support vector machine considered in Section 7.1.4, show that all training data points for which ξ n > 0 will have a n = C , and similarly all points for which ξ n > 0 will have a n = C .

    7.9 (   ) Verify the results (7.82) and (7.83) for the mean and covariance of the posterior distribution over weights in the regression RVM.

7.10 ( ) www Derive the result (7.85) for the marginal likelihood function in the regression RVM, by performing the Gaussian integral over w in (7.84) using the technique of completing the square in the exponential.

7.11 ( ) Repeat the above exercise, but this time make use of the general result (2.115).

7.12 ( ) www Show that direct maximization of the log marginal likelihood (7.85) for the regression relevance vector machine leads to the re-estimation equations (7.87) and (7.88) where γ i is deﬁned by (7.89).

7.13 ( ) In the evidence framework for RVM regression, we obtained the re-estimation formulae (7.87) and (7.88) by maximizing the marginal likelihood given by (7.85). Extend this approach by inclusion of hyperpriors given by gamma distributions of the form (B.26) and obtain the corresponding re-estimation formulae for α and β by maximizing the corresponding posterior probability p ( t , α ,β | X ) with respect to α and β .

7.14 ( ) Derive the result (7.90) for the predictive distribution in the relevance vector machine for regression. Show that the predictive variance is given by (7.91).

7.15 ( ) www Using the results (7.94) and (7.95), show that the marginal likelihood (7.85) can be written in the form (7.96), where λ ( α n ) is deﬁned by (7.97) and the sparsity and quality factors are deﬁned by (7.98) and (7.99), respectively.

7.16 ( ) By taking the second derivative of the log marginal likelihood (7.97) for the regression RVM with respect to the hyperparameter α i , show that the stationary point given by (7.101) is a maximum of the marginal likelihood.

7.17 ( ) Using (7.83) and (7.86), together with the matrix identity (C.7), show that the quantities S n and Q n deﬁned by (7.102) and (7.103) can be written in the form (7.106) and (7.107).

7.18 ( ) www Show that the gradient vector and Hessian matrix of the log posterior distribution (7.109) for the classiﬁcation relevance vector machine are given by (7.110) and (7.111).

7.19 ( ) Verify that maximization of the approximate log marginal likelihood function (7.114) for the classiﬁcation relevance vector machine leads to the result (7.116) for re-estimation of the hyperparameters.

![image 33](Bishop2006_images/imageFile33.png)

8

## 8 Graphical Models Exercises

8.1 ( ) www By marginalizing out the variables in order, show that the representation (8.5) for the joint distribution of a directed graph is correctly normalized, provided each of the conditional distributions is normalized.

8.2 ( ) www Show that the property of there being no directed cycles in a directed graph follows from the statement that there exists an ordered numbering of the nodes such that for each node there are no links going to a lower-numbered node.

Table 8.2 The joint distribution over three binary variables.

| a   | b   | c   | p ( a, b, c ) |
| --- | --- | --- | ------------- |
| 0   | 0   | 0   | 0.192         |
| 0   | 0   | 1   | 0.144         |
| 0   | 1   | 0   | 0.048         |
| 0   | 1   | 1   | 0.216         |
| 1   | 0   | 0   | 0.192         |
| 1   | 0   | 1   | 0.064         |
| 1   | 1   | 0   | 0.048         |
| 1   | 1   | 1   | 0.096         |

![image 213](Bishop2006_images/imageFile213.png)

a

b

c

p

(

a, b, c

)

0

0

0

0.192

0

0

1

0.144

0

1

0

0.048

1

1

0.216

0

1

0

0

0.192

1

0

1

0.064

1

1

0

0.048

1

1

1

0.096

8.3 ( ) Consider three binary variables a,b,c ∈ { 0 , 1 } having the joint distribution given in Table 8.2. Show by direct evaluation that this distribution has the property that a and b are marginally dependent, so that p ( a,b ) = p ( a ) p ( b ) , but that they become independent when conditioned on c , so that p ( a,b | c ) = p ( a | c ) p ( b | c ) for both c = 0 and c = 1 .

/negationslash

8.4 ( ) Evaluate the distributions p ( a ) , p ( b | c ) , and p ( c | a ) corresponding to the joint distribution given in Table 8.2. Hence show by direct evaluation that p ( a,b,c ) = p ( a ) p ( c | a ) p ( b | c ) . Draw the corresponding directed graph.

8.5

( ) www Draw a directed probabilistic graphical model corresponding to the relevance vector machine described by (7.79) and (7.80).

8.6 ( ) For the model shown in Figure 8.13, we have seen that the number of parameters required to specify the conditional distribution p ( y | x 1 ,...,x M ) , where x i ∈ { 0 , 1 } , could be reduced from 2 M to M +1 by making use of the logistic sigmoid representation (8.10). An alternative representation (Pearl, 1988) is given by

$$
p ( y = 1 | x _ { 1 } , \dots , x _ { M } ) = 1 - ( 1 - \mu _ { 0 } ) \prod _ { i = 1 } ^ { M } ( 1 - \mu _ { i } ) ^ { x _ { i } } \quad ( 8 . 1 0 4 ) \\ \intertext { r o w t h e p o r m o t i m a r s } \left ( 0 , \dots , x _ { M } \right ) = \intertext { s o r w h e p o r m o t i m a r s } \intertext { a n d } \intertext { o n d } \intertext { s o r w h e p o r m o t i m a r s } \intertext { e q n o d } \intertext { i s e a n d }
$$

where the parameters µ i represent the probabilities p ( x i = 1) , and µ 0 is an additional parameters satisfying 0 µ 0 1 . The conditional distribution (8.104) is known as the noisy-OR . Show that this can be interpreted as a ‘soft’ (probabilistic) form of the logical OR function (i.e., the function that gives y = 1 whenever at least one of the x i = 1 ). Discuss the interpretation of µ 0 .

8.7 ( ) Using the recursion relations (8.15) and (8.16), show that the mean and covariance of the joint distribution for the graph shown in Figure 8.14 are given by (8.17) and (8.18), respectively.

8.8 ( ) www Show that a ⊥ b,c | d implies a ⊥ b | d .

8.9 ( ) www Using the d-separation criterion, show that the conditional distribution for a node x in a directed graph, conditioned on all of the nodes in the Markov blanket, is independent of the remaining variables in the graph.

Figure 8.54 Example of a graphical model used to explore the conditional independence properties of the head-to-head path a – c – b when a descendant of c , namely the node d , is observed.

![image 214](Bishop2006_images/imageFile214.png)

a

b

c

d

8.10 ( ) Consider the directed graph shown in Figure 8.54 in which none of the variables is observed. Show that a ⊥ b | ∅ . Suppose we now observe the variable d . Show that in general a ⊥ b | d .

8.11 ( ) Consider the example of the car fuel system shown in Figure 8.21, and suppose that instead of observing the state of the fuel gauge G directly, the gauge is seen by the driver D who reports to us the reading on the gauge. This report is either that the gauge shows full D = 1 or that it shows empty D = 0 . Our driver is a bit unreliable, as expressed through the following probabilities

$$
p ( D & = 1 | G = 1 ) \ = \ 0 . 9 \\ p ( D & = 0 | G = 0 ) \ = \ 0 . 9
$$

$$
p ( D = 0 | G = 0 ) \ = \ 0 . 9 .
$$

Suppose that the driver tells us that the fuel gauge shows empty, in other words that we observe D = 0 . Evaluate the probability that the tank is empty given only this observation. Similarly, evaluate the corresponding probability given also the observation that the battery is ﬂat, and note that this second probability is lower. Discuss the intuition behind this result, and relate the result to Figure 8.54.

8.12 ( ) www Show that there are 2 M ( M − 1) / 2 distinct undirected graphs over a set of M distinct random variables. Draw the 8 possibilities for the case of M = 3 .

8.13 ( ) Consider the use of iterated conditional modes (ICM) to minimize the energy function given by (8.42). Write down an expression for the difference in the values of the energy associated with the two states of a particular variable x j , with all other variables held ﬁxed, and show that it depends only on quantities that are local to x j in the graph.

8.14 ( ) Consider a particular case of the energy function given by (8.42) in which the coefﬁcients β = h = 0 . Show that the most probable conﬁguration of the latent variables is given by x i = y i for all i .

8.15 ( ) www Show that the joint distribution p ( x n − 1 ,x n ) for two neighbouring nodes in the graph shown in Figure 8.38 is given by an expression of the form (8.58).

8.16 ( ) Consider the inference problem of evaluating p ( x n | x N ) for the graph shown in Figure 8.38, for all nodes n ∈ { 1 ,...,N − 1 } . Show that the message passing algorithm discussed in Section 8.4.1 can be used to solve this efﬁciently, and discuss which messages are modiﬁed and in what way.

8.17 ( ) Consider a graph of the form shown in Figure 8.38 having N = 5 nodes, in which nodes x 3 and x 5 are observed. Use d-separation to show that x 2 ⊥ x 5 | x 3 . Show that if the message passing algorithm of Section 8.4.1 is applied to the evaluation of p ( x 2 | x 3 ,x 5 ) , the result will be independent of the value of x 5 .

8.18 ( ) www Show that a distribution represented by a directed tree can trivially be written as an equivalent distribution over the corresponding undirected tree. Also show that a distribution expressed as an undirected tree can, by suitable normalization of the clique potentials, be written as a directed tree. Calculate the number of distinct directed trees that can be constructed from a given undirected tree.

8.19 ( ) Apply the sum-product algorithm derived in Section 8.4.4 to the chain-ofnodes model discussed in Section 8.4.1 and show that the results (8.54), (8.55), and (8.57) are recovered as a special case.

8.20 ( ) www Consider the message passing protocol for the sum-product algorithm on a tree-structured factor graph in which messages are ﬁrst propagated from the leaves to an arbitrarily chosen root node and then from the root node out to the leaves. Use proof by induction to show that the messages can be passed in such an order that at every step, each node that must send a message has received all of the incoming messages necessary to construct its outgoing messages.

8.21 ( ) www Show that the marginal distributions p ( x s ) over the sets of variables x s associated with each of the factors f x ( x s ) in a factor graph can be found by ﬁrst running the sum-product message passing algorithm and then evaluating the required marginals using (8.72).

8.22 ( ) Consider a tree-structured factor graph, in which a given subset of the variable nodes form a connected subgraph (i.e., any variable node of the subset is connected to at least one of the other variable nodes via a single factor node). Show how the sum-product algorithm can be used to compute the marginal distribution over that subset.

8.23 ( ) www In Section 8.4.4, we showed that the marginal distribution p ( x i ) for a variable node x i in a factor graph is given by the product of the messages arriving at this node from neighbouring factor nodes in the form (8.63). Show that the marginal p ( x i ) can also be written as the product of the incoming message along any one of the links with the outgoing message along the same link.

8.24 ( ) Show that the marginal distribution for the variables x s in a factor f s ( x s ) in a tree-structured factor graph, after running the sum-product message passing algorithm, can be written as the product of the message arriving at the factor node along all its links, times the local factor f ( x s ) , in the form (8.72).

8.25 ( ) In (8.86), we veriﬁed that the sum-product algorithm run on the graph in Figure 8.51 with node x 3 designated as the root node gives the correct marginal for x 2 . Show that the correct marginals are obtained also for x 1 and x 3 . Similarly, show that the use of the result (8.72) after running the sum-product algorithm on this graph gives the correct joint distribution for x 1 ,x 2 .

8.26 ( ) Consider a tree-structured factor graph over discrete variables, and suppose we wish to evaluate the joint distribution p ( x a ,x b ) associated with two variables x a and x b that do not belong to a common factor. Deﬁne a procedure for using the sumproduct algorithm to evaluate this joint distribution in which one of the variables is successively clamped to each of its allowed values.

8.27 ( ) Consider two discrete variables x and y each having three possible states, for example x,y ∈ { 0 , 1 , 2 } . Construct a joint distribution p ( x,y ) over these variables having the property that the value x that maximizes the marginal p ( x ) , along with the value y that maximizes the marginal p ( y ) , together have probability zero under the joint distribution, so that p ( x, y ) = 0 . 8.28 ( ) www The concept of a pending message in the sum-product algorithm for

a factor graph was deﬁned in Section 8.4.7. Show that if the graph has one or more cycles, there will always be at least one pending message irrespective of how long the algorithm runs.

8.29 ( ) www Show that if the sum-product algorithm is run on a factor graph with a tree structure (no loops), then after a ﬁnite number of messages have been sent, there will be no pending messages.

Section 9.1

![image 35](Bishop2006_images/imageFile35.png)

9

## 9 Mixture Models and EM Exercises

9.1 ( ) www Consider the K -means algorithm discussed in Section 9.1. Show that as a consequence of there being a ﬁnite number of possible assignments for the set of discrete indicator variables r nk , and that for each such assignment there is a unique optimum for the { µ k } , the K -means algorithm must converge after a ﬁnite number of iterations.

9.2 ( ) Apply the Robbins-Monro sequential estimation procedure described in Section 2.3.5 to the problem of ﬁnding the roots of the regression function given by the derivatives of J in (9.1) with respect to µ k . Show that this leads to a stochastic K -means algorithm in which, for each data point x n , the nearest prototype µ k is updated using (9.5).

9.3 ( ) www Consider a Gaussian mixture model in which the marginal distribution p ( z ) for the latent variable is given by (9.10), and the conditional distribution p ( x | z ) for the observed variable is given by (9.11). Show that the marginal distribution p ( x ) , obtained by summing p ( z ) p ( x | z ) over all possible values of z , is a Gaussian mixture of the form (9.7).

9.4 ( ) Suppose we wish to use the EM algorithm to maximize the posterior distribution over parameters p ( θ | X ) for a model containing latent variables, where X is the observed data set. Show that the E step remains the same as in the maximum likelihood case, whereas in the M step the quantity to be maximized is given by Q ( θ , θ old ) + ln p ( θ ) where Q ( θ , θ old ) is deﬁned by (9.30).

9.5 ( ) Consider the directed graph for a Gaussian mixture model shown in Figure 9.6. By making use of the d-separation criterion discussed in Section 8.2, show that the posterior distribution of the latent variables factorizes with respect to the different data points so that

$$
p ( Z | X , \mu , \Sigma , \pi ) = \prod _ { n = 1 } ^ { N } p ( z _ { n } | x _ { n } , \mu , \Sigma , \pi ) . \\
$$

9.6 ( ) Consider a special case of a Gaussian mixture model in which the covariance matrices Σ k of the components are all constrained to have a common value Σ . Derive the EM equations for maximizing the likelihood function under such a model.

9.7 ( ) www Verify that maximization of the complete-data log likelihood (9.36) for a Gaussian mixture model leads to the result that the means and covariances of each component are ﬁtted independently to the corresponding group of data points, and the mixing coefﬁcients are given by the fractions of points in each group.

9.8 ( ) www Show that if we maximize (9.40) with respect to µ k while keeping the responsibilities γ ( z nk ) ﬁxed, we obtain the closed form solution given by (9.17).

9.9 ( ) Show that if we maximize (9.40) with respect to Σ k and π k while keeping the responsibilities γ ( z nk ) ﬁxed, we obtain the closed form solutions given by (9.19) and (9.22).

9.10 ( ) Consider a density model given by a mixture distribution

$$
p ( x ) = \sum _ { k = 1 } ^ { K } \pi _ { k } p ( x | k ) \\ \intertext { t i n t i o n } p ( x ) = \sum _ { k = 1 } ^ { K } \pi _ { k } p ( x | k )
$$

and suppose that we partition the vector x into two parts so that x = ( x a , x b ) . Show that the conditional density p ( x b | x a ) is itself a mixture distribution and ﬁnd expressions for the mixing coefﬁcients and for the component densities.

9.11 ( ) In Section 9.3.2, we obtained a relationship between K means and EM for Gaussian mixtures by considering a mixture model in which all components have covariance I . Show that in the limit → 0 , maximizing the expected completedata log likelihood for this model, given by (9.40), is equivalent to minimizing the distortion measure J for the K -means algorithm given by (9.1).

9.12 ( ) www Consider a mixture distribution of the form

$$
p ( x ) = \sum _ { k = 1 } ^ { K } \pi _ { k } p ( x | k ) \\ \intertext { f x c o l d e b s c r i d e t e r o c h i n t i o n o r a c h i n b o w s }
$$

where the elements of x could be discrete or continuous or a combination of these. Denote the mean and covariance of p ( x | k ) by µ k and Σ k , respectively. Show that the mean and covariance of the mixture distribution are given by (9.49) and (9.50).

9.13 ( ) Using the re-estimation equations for the EM algorithm, show that a mixture of Bernoulli distributions, with its parameters set to values corresponding to a maximum of the likelihood function, has the property that

$$
\mathbb { E } [ x ] = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } x _ { n } \equiv \bar { x } . \\ \intertext { the parameters of this model are initialized such that all compo- }
$$

Hence show that if the parameters of this model are initialized such that all components have the same mean µ k = µ for k = 1 ,...,K , then the EM algorithm will converge after one iteration, for any choice of the initial mixing coefﬁcients, and that this solution has the property µ k = x . Note that this represents a degenerate case of the mixture model in which all of the components are identical, and in practice we try to avoid such solutions by using an appropriate initialization.

9.14 ( ) Consider the joint distribution of latent and observed variables for the Bernoulli distribution obtained by forming the product of p ( x | z , µ ) given by (9.52) and p ( z | π ) given by (9.53). Show that if we marginalize this joint distribution with respect to z , then we obtain (9.47).

9.15 ( ) www Show that if we maximize the expected complete-data log likelihood function (9.55) for a mixture of Bernoulli distributions with respect to µ k , we obtain the M step equation (9.59).

9.16 ( ) Show that if we maximize the expected complete-data log likelihood function (9.55) for a mixture of Bernoulli distributions with respect to the mixing coefﬁcients π k , using a Lagrange multiplier to enforce the summation constraint, we obtain the M step equation (9.60).

9.17 ( ) www Show that as a consequence of the constraint 0 p ( x n | µ k ) 1 for the discrete variable x n , the incomplete-data log likelihood function for a mixture of Bernoulli distributions is bounded above, and hence that there are no singularities for which the likelihood goes to inﬁnity.

9.18 ( ) Consider a Bernoulli mixture model as discussed in Section 9.3.3, together with a prior distribution p ( µ k | a k ,b k ) over each of the parameter vectors µ k given by the beta distribution (2.13), and a Dirichlet prior p ( π | α ) given by (2.38). Derive the EM algorithm for maximizing the posterior probability p ( µ , π | X ) .

9.19 ( ) Consider a D -dimensional variable x each of whose components i is itself a multinomial variable of degree M so that x is a binary vector with components x ij where i = 1 ,...,D and j = 1 ,...,M , subject to the constraint that j x ij = 1 for all i . Suppose that the distribution of these variables is described by a mixture of the discrete multinomial distributions considered in Section 2.2 so that

$$
p ( x ) = \sum _ { k = 1 } ^ { K } \pi _ { k } p ( x | \mu _ { k } )
$$

where

$$
p ( x | \mu _ { k } ) = \prod _ { i = 1 } ^ { D } \prod _ { j = 1 } ^ { M } \mu _ { k i j } ^ { x _ { i j } } . \\ \intertext { i r e p r e s t h e p a b l i t i y s } \intertext { p ( x | \mu _ { k } ) = \prod _ { i = 1 } ^ { D } \prod _ { j = 1 } ^ { M } \mu _ { k i j } ^ { x _ { i j } } . } \intertext { i r e p r e s t h e p a b l i t i y s } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) and m u s t s i s f y } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) = 0 } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _ { i j } = 1 | \mu _ { k } ) } \intertext { p ( x _
$$

The parameters µ kij represent the probabilities p ( x ij = 1 | µ k ) and must satisfy 0 µ kij 1 together with the constraint j µ kij = 1 for all values of k and i . Given an observed data set { x n } , where n = 1 ,...,N , derive the E and M step equations of the EM algorithm for optimizing the mixing coefﬁcients π k and the component parameters µ kij of this distribution by maximum likelihood.

9.20 ( ) www Show that maximization of the expected complete-data log likelihood function (9.62) for the Bayesian linear regression model leads to the M step reestimation result (9.63) for α .

9.21 ( ) Using the evidence framework of Section 3.5, derive the M-step re-estimation equations for the parameter β in the Bayesian linear regression model, analogous to the result (9.63) for α .

9.22 ( ) By maximization of the expected complete-data log likelihood deﬁned by (9.66), derive the M step equations (9.67) and (9.68) for re-estimating the hyperparameters of the relevance vector machine for regression.

9.23 ( ) www In Section 7.2.1 we used direct maximization of the marginal likelihood to derive the re-estimation equations (7.87) and (7.88) for ﬁnding values of the hyperparameters α and β for the regression RVM. Similarly, in Section 9.3.4 we used the EM algorithm to maximize the same marginal likelihood, giving the re-estimation equations (9.67) and (9.68). Show that these two sets of re-estimation equations are formally equivalent.

9.24 ( ) Verify the relation (9.70) in which L ( q, θ ) and KL( q p ) are deﬁned by (9.71) and (9.72), respectively.

9.25 ( ) www Show that the lower bound L ( q, θ ) given by (9.71), with q ( Z ) = p ( Z | X , θ (old) ) , has the same gradient with respect to θ as the log likelihood function ln p ( X | θ ) at the point θ = θ (old) .

9.26 ( ) www Consider the incremental form of the EM algorithm for a mixture of Gaussians, in which the responsibilities are recomputed only for a speciﬁc data point x m . Starting from the M-step formulae (9.17) and (9.18), derive the results (9.78) and (9.79) for updating the component means.

9.27 ( ) Derive M-step formulae for updating the covariance matrices and mixing coefﬁcients in a Gaussian mixture model when the responsibilities are updated incrementally, analogous to the result (9.78) for updating the means.

![image 38](Bishop2006_images/imageFile38.png)

## 10 Approximate Inference Exercises

10.1 ( ) www Verify that the log marginal distribution of the observed data ln p ( X ) can be decomposed into two terms in the form (10.2) where L ( q ) is given by (10.3) and KL( q p ) is given by (10.4).

10.2 ( ) Use the properties E [ z 1 ] = m 1 and E [ z 2 ] = m 2 to solve the simultaneous equations (10.13) and (10.15), and hence show that, provided the original distribution p ( z ) is nonsingular, the unique solution for the means of the factors in the approximation distribution is given by E [ z 1 ] = µ 1 and E [ z 2 ] = µ 2 .

10.3 ( ) www Consider a factorized variational distribution q ( Z ) of the form (10.5). By using the technique of Lagrange multipliers, verify that minimization of the Kullback-Leibler divergence KL( p q ) with respect to one of the factors q i ( Z i ) , keeping all other factors ﬁxed, leads to the solution (10.17).

10.4 ( ) Suppose that p ( x ) is some ﬁxed distribution and that we wish to approximate it using a Gaussian distribution q ( x ) = N ( x | µ , Σ ) . By writing down the form of the KL divergence KL( p q ) for a Gaussian q ( x ) and then differentiating, show that

minimization of KL( p q ) with respect to µ and Σ leads to the result that µ is given by the expectation of x under p ( x ) and that Σ is given by the covariance.

10.5 ( ) www Consider a model in which the set of all hidden stochastic variables, denoted collectively by Z , comprises some latent variables z together with some model parameters θ . Suppose we use a variational distribution that factorizes between latent variables and parameters so that q ( z , θ ) = q z ( z ) q θ ( θ ) , in which the distribution q θ ( θ ) is approximated by a point estimate of the form q θ ( θ ) = δ ( θ − θ 0 ) where θ 0 is a vector of free parameters. Show that variational optimization of this factorized distribution is equivalent to an EM algorithm, in which the E step optimizes q z ( z ) , and the M step maximizes the expected complete-data log posterior distribution of θ with respect to θ 0 .

10.6 ( ) The alpha family of divergences is deﬁned by (10.19). Show that the KullbackLeibler divergence KL( p q ) corresponds to α → 1 . This can be done by writing p = exp( ln p ) = 1 + ln p + O ( 2 ) and then taking → 0 . Similarly show that KL( q p ) corresponds to α → − 1 .

10.7 ( ) Consider the problem of inferring the mean and precision of a univariate Gaussian using a factorized variational approximation, as considered in Section 10.1.3. Show that the factor q µ ( µ ) is a Gaussian of the form N ( µ | µ N ,λ − 1 N ) with mean and precision given by (10.26) and (10.27), respectively. Similarly show that the factor q τ ( τ ) is a gamma distribution of the form Gam( τ | a N ,b N ) with parameters given by (10.29) and (10.30).

10.8 ( ) Consider the variational posterior distribution for the precision of a univariate Gaussian whose parameters are given by (10.29) and (10.30). By using the standard results for the mean and variance of the gamma distribution given by (B.27) and (B.28), show that if we let N → ∞ , this variational posterior distribution has a mean given by the inverse of the maximum likelihood estimator for the variance of the data, and a variance that goes to zero.

10.9 ( ) By making use of the standard result E [ τ ] = a N /b N for the mean of a gamma distribution, together with (10.26), (10.27), (10.29), and (10.30), derive the result (10.33) for the reciprocal of the expected precision in the factorized variational treatment of a univariate Gaussian.

10.10 ( ) www Derive the decomposition given by (10.34) that is used to ﬁnd approximate posterior distributions over models using variational inference.

10.11 ( ) www By using a Lagrange multiplier to enforce the normalization constraint on the distribution q ( m ) , show that the maximum of the lower bound (10.35) is given by (10.36).

10.12 ( ) Starting from the joint distribution (10.41), and applying the general result (10.9), show that the optimal variational distribution q ( Z ) over the latent variables for the Bayesian mixture of Gaussians is given by (10.48) by verifying the steps given in the text.

10.13 ( ) www Starting from (10.54), derive the result (10.59) for the optimum variational posterior distribution over µ k and Λ k in the Bayesian mixture of Gaussians, and hence verify the expressions for the parameters of this distribution given by (10.60)–(10.63).

10.14 ( ) Using the distribution (10.59), verify the result (10.64).

10.15 ( ) Using the result (B.17), show that the expected value of the mixing coefﬁcients in the variational mixture of Gaussians is given by (10.69).

10.16 ( ) www Verify the results (10.71) and (10.72) for the ﬁrst two terms in the lower bound for the variational Gaussian mixture model given by (10.70).

10.17 ( ) Verify the results (10.73)–(10.77) for the remaining terms in the lower bound for the variational Gaussian mixture model given by (10.70).

10.18 ( ) In this exercise, we shall derive the variational re-estimation equations for the Gaussian mixture model by direct differentiation of the lower bound. To do this we assume that the variational distribution has the factorization deﬁned by (10.42) and (10.55) with factors given by (10.48), (10.57), and (10.59). Substitute these into (10.70) and hence obtain the lower bound as a function of the parameters of the variational distribution. Then, by maximizing the bound with respect to these parameters, derive the re-estimation equations for the factors in the variational distribution, and show that these are the same as those obtained in Section 10.2.1.

10.19 ( ) Derive the result (10.81) for the predictive distribution in the variational treatment of the Bayesian mixture of Gaussians model.

10.20 ( ) www This exercise explores the variational Bayes solution for the mixture of Gaussians model when the size N of the data set is large and shows that it reduces (as we would expect) to the maximum likelihood solution based on EM derived in Chapter 9. Note that results from Appendix B may be used to help answer this exercise. First show that the posterior distribution q ( Λ k ) of the precisions becomes sharply peaked around the maximum likelihood solution. Do the same for the posterior distribution of the means q ( µ k | Λ k ) . Next consider the posterior distribution q ( π ) for the mixing coefﬁcients and show that this too becomes sharply peaked around the maximum likelihood solution. Similarly, show that the responsibilities become equal to the corresponding maximum likelihood values for large N , by making use of the following asymptotic result for the digamma function for large x

$$
\psi ( x ) = \ln x + O \left ( 1 / x \right ) .
$$

Finally, by making use of (10.80), show that for large N , the predictive distribution becomes a mixture of Gaussians.

10.21 ( ) Show that the number of equivalent parameter settings due to interchange symmetries in a mixture model with K components is K ! .

10.22 ( ) We have seen that each mode of the posterior distribution in a Gaussian mixture model is a member of a family of K ! equivalent modes. Suppose that the result of running the variational inference algorithm is an approximate posterior distribution q that is localized in the neighbourhood of one of the modes. We can then approximate the full posterior distribution as a mixture of K ! such q distributions, once centred on each mode and having equal mixing coefﬁcients. Show that if we assume negligible overlap between the components of the q mixture, the resulting lower bound differs from that for a single component q distribution through the addition of an extra term ln K ! .

10.23 ( ) www Consider a variational Gaussian mixture model in which there is no prior distribution over mixing coefﬁcients { π k } . Instead, the mixing coefﬁcients are treated as parameters, whose values are to be found by maximizing the variational lower bound on the log marginal likelihood. Show that maximizing this lower bound with respect to the mixing coefﬁcients, using a Lagrange multiplier to enforce the constraint that the mixing coefﬁcients sum to one, leads to the re-estimation result (10.83). Note that there is no need to consider all of the terms in the lower bound but only the dependence of the bound on the { π k } .

10.24 ( ) www We have seen in Section 10.2 that the singularities arising in the maximum likelihood treatment of Gaussian mixture models do not arise in a Bayesian treatment. Discuss whether such singularities would arise if the Bayesian model were solved using maximum posterior (MAP) estimation.

10.25 ( ) The variational treatment of the Bayesian mixture of Gaussians, discussed in Section 10.2, made use of a factorized approximation (10.5) to the posterior distribution. As we saw in Figure 10.2, the factorized assumption causes the variance of the posterior distribution to be under-estimated for certain directions in parameter space. Discuss qualitatively the effect this will have on the variational approximation to the model evidence, and how this effect will vary with the number of components in the mixture. Hence explain whether the variational Gaussian mixture will tend to under-estimate or over-estimate the optimal number of components.

10.26 ( ) Extend the variational treatment of Bayesian linear regression to include a gamma hyperprior Gam( β | c 0 ,d 0 ) over β and solve variationally, by assuming a factorized variational distribution of the form q ( w ) q ( α ) q ( β ) . Derive the variational update equations for the three factors in the variational distribution and also obtain an expression for the lower bound and for the predictive distribution.

10.27 ( ) By making use of the formulae given in Appendix B show that the variational lower bound for the linear basis function regression model, deﬁned by (10.107), can be written in the form (10.107) with the various terms deﬁned by (10.108)–(10.112).

10.28 ( ) Rewrite the model for the Bayesian mixture of Gaussians, introduced in Section 10.2, as a conjugate model from the exponential family, as discussed in Section 10.4. Hence use the general results (10.115) and (10.119) to derive the speciﬁc results (10.48), (10.57), and (10.59).

10.29 ( ) www Show that the function f ( x ) = ln( x ) is concave for 0 < x < ∞ by computing its second derivative. Determine the form of the dual function g ( λ ) deﬁned by (10.133), and verify that minimization of λx − g ( λ ) with respect to λ according to (10.132) indeed recovers the function ln( x ) .

10.30 ( ) By evaluating the second derivative, show that the log logistic function f ( x ) = − ln(1 + e − x ) is concave. Derive the variational upper bound (10.137) directly by making a second order Taylor expansion of the log logistic function around a point x = ξ .

10.31 ( ) By ﬁnding the second derivative with respect to x , show that the function f ( x ) = − ln( e x/ 2 + e − x/ 2 ) is a concave function of x . Now consider the second derivatives with respect to the variable x 2 and hence show that it is a convex function of x 2 . Plot graphs of f ( x ) against x and against x 2 . Derive the lower bound (10.144) on the logistic sigmoid function directly by making a ﬁrst order Taylor series expansion of the function f ( x ) in the variable x 2 centred on the value ξ 2 .

10.32 ( ) www Consider the variational treatment of logistic regression with sequential learning in which data points are arriving one at a time and each must be processed and discarded before the next data point arrives. Show that a Gaussian approximation to the posterior distribution can be maintained through the use of the lower bound (10.151), in which the distribution is initialized using the prior, and as each data point is absorbed its corresponding variational parameter ξ n is optimized.

10.33 ( ) By differentiating the quantity Q ( ξ , ξ old ) deﬁned by (10.161) with respect to the variational parameter ξ n show that the update equation for ξ n for the Bayesian logistic regression model is given by (10.163).

10.34 ( ) In this exercise we derive re-estimation equations for the variational parameters ξ in the Bayesian logistic regression model of Section 4.5 by direct maximization of the lower bound given by (10.164). To do this set the derivative of L ( ξ ) with respect to ξ n equal to zero, making use of the result (3.117) for the derivative of the log of a determinant, together with the expressions (10.157) and (10.158) which deﬁne the mean and covariance of the variational posterior distribution q ( w ) .

10.35 ( ) Derive the result (10.164) for the lower bound L ( ξ ) in the variational logistic regression model. This is most easily done by substituting the expressions for the Gaussian prior q ( w ) = N ( w | m 0 , S 0 ) , together with the lower bound h ( w , ξ ) on the likelihood function, into the integral (10.159) which deﬁnes L ( ξ ) . Next gather together the terms which depend on w in the exponential and complete the square to give a Gaussian integral, which can then be evaluated by invoking the standard result for the normalization coefﬁcient of a multivariate Gaussian. Finally take the logarithm to obtain (10.164).

10.36 ( ) Consider the ADF approximation scheme discussed in Section 10.7, and show that inclusion of the factor f j ( θ ) leads to an update of the model evidence of the form

$$
p _ { j } ( \mathcal { D } ) \simeq p _ { j - 1 } ( \mathcal { D } ) Z _ { j }
$$

where Z j is the normalization constant deﬁned by (10.197). By applying this result recursively, and initializing with p 0 ( D ) = 1 , derive the result

$$
p ( \mathcal { D } ) \simeq \prod _ { j } Z _ { j } .
$$

10.37 ( ) www Consider the expectation propagation algorithm from Section 10.7, and suppose that one of the factors f 0 ( θ ) in the deﬁnition (10.188) has the same exponential family functional form as the approximating distribution q ( θ ) . Show that if the factor f 0 ( θ ) is initialized to be f 0 ( θ ) , then an EP update to reﬁne f 0 ( θ ) leaves f 0 ( θ ) unchanged. This situation typically arises when one of the factors is the prior p ( θ ) , and so we see that the prior factor can be incorporated once exactly and does not need to be reﬁned.

10.38 ( ) In this exercise and the next, we shall verify the results (10.214)–(10.224) for the expectation propagation algorithm applied to the clutter problem. Begin by using the division formula (10.205) to derive the expressions (10.214) and (10.215) by completing the square inside the exponential to identify the mean and variance. Also, show that the normalization constant Z n , deﬁned by (10.206), is given for the clutter problem by (10.216). This can be done by making use of the general result (2.115).

10.39 ( ) Show that the mean and variance of q new ( θ ) for EP applied to the clutter problem are given by (10.217) and (10.218). To do this, ﬁrst prove the following results for the expectations of θ and θθ T under q new ( θ )

$$
\mathbb { E } [ \theta ] \ = \ \mathbf m ^ { \langle n } + v ^ { \langle n } \nabla _ { m ^ { \langle n } } \ln Z _ { n } & & ( 1 0 . 2 4 4 ) \\ \mathbb { F } [ \theta ^ { T } \theta ] \ = \ \mathcal { 2 } ( v ^ { \langle n } ) ^ { 2 } \nabla _ { \xi } \, \cdot \, \ln Z _ { n } \, & & \mathbb { W } [ \theta ] ^ { T } _ { m } \langle n \, \rangle _ { | m | } \, \| \mathbf m ^ { \langle n } \| ^ { 2 } \, & & ( 1 0 . 2 4 5 )
$$

$$
\mathbb { E } [ \theta ^ { T } \theta ] \ = \ 2 ( v ^ { \wedge n } ) ^ { 2 } \nabla _ { v ^ { \wedge n } } \ln Z _ { n } + 2 \mathbb { E } [ \theta ] ^ { T } m ^ { \wedge n } - \| m ^ { \wedge n } \| ^ { 2 } \quad ( 1 0 . 2 4 5 )
$$

and then make use of the result (10.216) for Z n . Next, prove the results (10.220)– (10.222) by using (10.207) and completing the square in the exponential. Finally, use (10.208) to derive the result (10.223).

![image 40](Bishop2006_images/imageFile40.png)

## 11 Sampling Methods Exercises

11.1 ( ) www Show that the ﬁnite sample estimator f deﬁned by (11.2) has mean equal to E [ f ] and variance given by (11.3). 11.2 ( ) Suppose that z is a random variable with uniform distribution over (0 , 1) and

that we transform z using y = h − 1 ( z ) where h ( y ) is given by (11.6). Show that y has the distribution p ( y ) .

11.3 ( ) Given a random variable z that is uniformly distributed over (0 , 1) , ﬁnd a transformation y = f ( z ) such that y has a Cauchy distribution given by (11.8).

11.4 ( ) Suppose that z 1 and z 2 are uniformly distributed over the unit circle, as shown in Figure 11.3, and that we make the change of variables given by (11.10) and (11.11). Show that ( y 1 ,y 2 ) will be distributed according to (11.12).

11.5 ( ) www Let z be a D -dimensional random variable having a Gaussian distribution with zero mean and unit covariance matrix, and suppose that the positive deﬁnite symmetric matrix Σ has the Cholesky decomposition Σ = LL T where L is a lowertriangular matrix (i.e., one with zeros above the leading diagonal). Show that the variable y = µ + Lz has a Gaussian distribution with mean µ and covariance Σ . This provides a technique for generating samples from a general multivariate Gaussian using samples from a univariate Gaussian having zero mean and unit variance.

11.6 ( ) www In this exercise, we show more carefully that rejection sampling does indeed draw samples from the desired distribution p ( z ) . Suppose the proposal distribution is q ( z ) and show that the probability of a sample value z being accepted is given by p ( z ) /kq ( z ) where p is any unnormalized distribution that is proportional to p ( z ) , and the constant k is set to the smallest value that ensures kq ( z ) p ( z ) for all values of z . Note that the probability of drawing a value z is given by the probability of drawing that value from q ( z ) times the probability of accepting that value given that it has been drawn. Make use of this, along with the sum and product rules of probability, to write down the normalized form for the distribution over z , and show that it equals p ( z ) .

11.7 ( ) Suppose that z has a uniform distribution over the interval [0 , 1] . Show that the variable y = b tan z + c has a Cauchy distribution given by (11.16).

11.8 ( ) Determine expressions for the coefﬁcients k i in the envelope distribution (11.17) for adaptive rejection sampling using the requirements of continuity and normalization.

11.9 ( ) By making use of the technique discussed in Section 11.1.1 for sampling from a single exponential distribution, devise an algorithm for sampling from the piecewise exponential distribution deﬁned by (11.17).

11.10 ( ) Show that the simple random walk over the integers deﬁned by (11.34), (11.35), and (11.36) has the property that E [( z ( τ ) ) 2 ] = E [( z ( τ − 1) ) 2 ] + 1 / 2 and hence by induction that E [( z ( τ ) ) 2 ] = τ/ 2 .

![image 270](Bishop2006_images/imageFile270.png)

Figure 11.15 A probability distribution over two variables z 1 and z 2 that is uniform over the shaded regions and that is zero everywhere else.

z

2

z

1

11.11 ( ) www Show that the Gibbs sampling algorithm, discussed in Section 11.3, satisﬁes detailed balance as deﬁned by (11.40).

11.12 ( ) Consider the distribution shown in Figure 11.15. Discuss whether the standard Gibbs sampling procedure for this distribution is ergodic, and therefore whether it would sample correctly from this distribution

11.13 ( ) Consider the simple 3-node graph shown in Figure 11.16 in which the observed node x is given by a Gaussian distribution N ( x | µ,τ − 1 ) with mean µ and precision τ . Suppose that the marginal distributions over the mean and precision are given by N ( µ | µ 0 ,s 0 ) and Gam( τ | a,b ) , where Gam( ·|· , · ) denotes a gamma distribution. Write down expressions for the conditional distributions p ( µ | x,τ ) and p ( τ | x,µ ) that would be required in order to apply Gibbs sampling to the posterior distribution p ( µ,τ | x ) .

11.14 ( ) Verify that the over-relaxation update (11.50), in which z i has mean µ i and variance σ i , and where ν has zero mean and unit variance, gives a value z i with mean µ i and variance σ 2 i .

11.15 ( ) www Using (11.56) and (11.57), show that the Hamiltonian equation (11.58) is equivalent to (11.53). Similarly, using (11.57) show that (11.59) is equivalent to (11.55).

11.16 ( ) By making use of (11.56), (11.57), and (11.63), show that the conditional distribution p ( r | z ) is a Gaussian.

Figure 11.16 A graph involving an observed Gaussian variable x with prior distributions over its mean µ and precision τ .

µ

![image 271](Bishop2006_images/imageFile271.png)

τ

x

## 12 Continuous Latent Variables Exercises

12.1 (\* \*) lIB In this exercise, we use proof by induction to show that the linear projection onto an M -dimensional subspace that maximizes the variance of the projected data is defined by the M eigenvectors of the data covariance matrix S, given by (12.3), corresponding to the M largest eigenvalues. In Section 12.1, this result was proven for the case of M = 1. Now suppose the result holds for some general value of M and show that it consequently holds for dimensionality M + 1. To do this, first set the derivative of the variance of the projected data with respect to a vector UM+1 defining the new direction in data space equal to zero. This should be done subject to the constraints that UM +l be orthogonal to the existing vectors U1,"" UM, and also that it be normalized to unit length. Use Lagrange multipliers to enforce these constraints. Then make use of the orthonormality properties of the vectors U1,"" UM to show that the new vector UM+1 is an eigenvector of S. Finally, show that the variance is maximized if the eigenvector is chosen to be the one corresponding to eigenvector AM+1 where the eigenvalues have been ordered in decreasing value.

Appendix E

12.2 (\*\*) Show that the minimum value of the PCA distortion measure J given by (12.15) with respect to the Ui, subject to the orthonormality constraints (12.7), is obtained when the Ui are eigenvectors of the data covariance matrix S. To do this, introduce a matrix H of Lagrange multipliers, one for each constraint, so that the modified distortion measure, in matrix notation reads

$$
\widetilde { J } = \text {Tr} \left \{ \widehat { U } ^ { T } \mathbb { S } \widehat { U } \right \} + \text {Tr} \left \{ H ( I - \widehat { U } ^ { T } \widehat { U } ) \right \}
$$

where U is a m~trix of dimensio~ D x (D M) whose columns are gi:::..en b~ Ui. Now minimize J with respect to U and show that the s~ution satisfies SU = UH. Clearly, one possible solution is that the columns of U are eigenvectors of S, in which case H is a diagonal matrix containing the corresponding eigenvalues. To obtain the general solution, show that H can be assumed to be a symmetr~ ma~ix, and by using its eigenvect£r expansion show that the general solution to SU =~ UH gives the same value for J as the specific solution in which the columns of U are

12.3 (\*) Verify that the eigenvectors defined by (12.30) are normalized to unit length, assuming that the eigenvectors Vi have unit length.

12.4 (\*) Imm Suppose we replace the zero-mean, unit-covariance latent space distribution (12.31) in the probabilistic PCA model by a general Gaussian distribution of the formN(zlm, ~). By redefining the parameters of the model, show that this leads to an identical model for the marginal distribution p(x) over the observed variables for any valid choice of m and ~.

12.5 (\* \*) Let x be a D-dimensional random variable having a Gaussian distribution given by N(xIJL, ~), and consider the M-dimensional random variable given by y = Ax + b where A is an M x D matrix. Show that y also has a Gaussian distribution, and find expressions for its mean and covariance. Discuss the form of this Gaussian distribution for M < D, for M = D, and for M > D.

12.6 (\*) Imm Draw a directed probabilistic graph for the probabilistic PCA model described in Section 12.2 in which the components of the observed variable x are shown explicitly as separate nodes. Hence verify that the probabilistic PCA model has the same independence structure as the naive Bayes model discussed in Section 8.2.2.

12.7 (\* \*) By making use of the results (2.270) and (2.271) for the mean and covariance of a general distribution, derive the result (12.35) for the marginal distribution p(x) in the probabilistic PCA model.

12.8 (\* \*) Imm By making use of the result (2.116), show that the posterior distribution p(zlx) for the probabilistic PCA model is given by (12.42).

12.9 (\*) Verify that maximizing the log likelihood (12.43) for the probabilistic PCA model with respect to the parameter JL gives the result JLML = x where x is the mean of the data vectors.

12.10 (\*\*) By evaluating the second derivatives of the log likelihood function (12.43) for the probabilistic PCA model with respect to the parameter JL, show that the stationary point JLML = x represents the unique maximum.

12.11 (\* \*) Imm Show that in the limit (Y2 -. 0, the posterior mean for the probabilistic PCA model becomes an orthogonal projection onto the principal subspace, as in conventional PCA.

12.12 (\* \*) For (Y2 > 0 show that the posterior mean in the probabilistic PCA model is shifted towards the origin relative to the orthogonal projection.

12.13 (\* \*) Show that the optimal reconstruction of a data point under probabilistic PCA, according to the least squares projection cost of conventional PCA, is given by

$$
\widetilde { x } = W _ { M L } ( W _ { M L } ^ { T } W _ { M L } ) ^ { - 1 } M \mathbb { E } [ z | x ] .
$$

12.14 (\*) The number of independent parameters in the covariance matrix for the probabilistic PCA model with an M -dimensional latent space and a D-dimensional data space is given by (12.51). Verify that in the case of M = D 1, the number of independent parameters is the same as in a general covariance Gaussian, whereas for M = ° it is the same as for a Gaussian with an isotropic covariance.

12.15 (\*\*) IIiI!I Derive the M-step equations (12.56) and (12.57) for the probabilistic PCA model by maximization of the expected complete-data log likelihood function given by (12.53).

12.16 (\* \* \*) In Figure 12.11, we showed an application of probabilistic PCA to a data set in which some of the data values were missing at random. Derive the EM algorithm for maximizing the likelihood function for the probabilistic PCA model in this situation. Note that the {zn}, as well as the missing data values that are components of the vectors {x n }, are now latent variables. Show that in the special case in which all of the data values are observed, this reduces to the EM algorithm for probabilistic PCA derived in Section 12.2.2.

12.17 (\*\*) IIiI!I Let W be a D x M matrix whose columns define a linear subspace of dimensionality M embedded within a data space of dimensionality D, and let J1 be a D-dimensional vector. Given a data set {x n } where n = 1, ... , N, we can approximate the data points using a linear mapping from a set of M -dimensional vectors {zn}, so that X n is approximated by W Zn + J1. The associated sum-ofsquares reconstruction cost is given by

$$
J = \sum _ { n = 1 } ^ { N } \| x _ { n } - \mu - W z _ { n } \| ^ { 2 } .
$$

First show that minimizing J with respect to J1leads to an analogous expression with X n and Zn replaced by zero-mean variables X n x and Zn Z, respectively, where x and Z denote sample means. Then show that minimizing J with respect to Zn, where W is kept fixed, gives rise to the PCA Estep (12.58), and that minimizing J with respect to W, where {zn} is kept fixed, gives rise to the PCA M step (12.59).

12.18 (\*) Derive an expression for the number of independent parameters in the factor analysis model described in Section 12.2.4.

12.19 (\*\*) IIiI!I Show that the factor analysis model described in Section 12.2.4 is invariant under rotations of the latent space coordinates.

12.20 (\*\*) By considering second derivatives, show that the only stationary point of the log likelihood function for the factor analysis model discussed in Section 12.2.4 with respect to the parameter J1 is given by the sample mean defined by (12.1). Furthermore, show that this stationary point is a maximum.

12.21 (\*\*) Derive the formulae (12.66) and (12.67) for the E step of the EM algorithm for factor analysis. Note that from the result of Exercise 12.20, the parameter J1 can be replaced by the sample mean x.

12.22 (\* \*) Write down an expression for the expected complete-data log likelihood function for the factor analysis model, and hence derive the corresponding M step equations (12.69) and (12.70).

12.23 (\*) III!I Draw a directed probabilistic graphical model representing a discrete mixture of probabilistic PCA models in which each PCA model has its own values of W, JL, and 02 • Now draw a modified graph in which these parameter values are shared between the components of the mixture.

12.24 (\*\*\*) We saw in Section 2.3.7 that Student's t-distribution can be viewed as an infinite mixture of Gaussians in which we marginalize with respect to a continuous latent variable. By exploiting this representation, formulate an EM algorithm for maximizing the log likelihood function for a multivariate Student's t-distribution given an observed set of data points, and derive the forms of the E and M step equations.

12.25 (\*\*) III!I Consider a linear-Gaussian latent-variable model having a latent space distribution p(z) = N(xIO, I) and a conditional distribution for the observed variable p(xlz) = N(xlWz + IL, <p) where <P is an arbitrary symmetric, positivedefinite noise covariance matrix. Now suppose that we make a nonsingular linear transformation of the data variables x ---t Ax, where A is a D x D matrix. If JLML' W ML and <PML represent the maximum likelihood solution corresponding to the original untransformed data, show that AJLML' AWML, and A <PMLA T will represent the corresponding maximum likelihood solution for the transformed data set. Finally, show that the form of the model is preserved in two cases: (i) A is a diagonal matrix and <P is a diagonal matrix. This corresponds to the case of factor analysis. The transformed <P remains diagonal, and hence factor analysis is covariant under component-wise re-scaling of the data variables; (ii) A is orthogonal and <P is proportional to the unit matrix so that <P = 02 1. This corresponds to probabilistic PCA. The transformed <P matrix remains proportional to the unit matrix, and hence probabilistic PCA is covariant under a rotation of the axes of data space, as is the case for conventional PCA.

\ 12.26 (\*\*) Show that any vector ai that satisfies (12.80) will also satisfy (12.79). Also, show that for any solution of (12.80) having eigenvalue A, we can add any multiple of an eigenvector of K having zero eigenvalue, and obtain a solution to (12.79) that also has eigenvalue A. Finally, show that such modifications do not affect the principal-component projection given by (12.82).

12.27 (\* \*) Show that the conventional linear PCA algorithm is recovered as a special case of kernel PCA if we choose the linear kernel function given by k(x, x') = x T x'.

12.28 (\* \*) III!I Use the transformation property (1.27) of a probability density under a change of variable to show that any density p(y) can be obtained from a fixed density q(x) that is everywhere nonzero by making a nonlinear change of variable y = f(x) in which f(x) is a monotonic function so that 0 :::; j'(x) < 00. Write down the differential equation satisfied by f (x) and draw a diagram illustrating the transformation of the density.

12.29 (\*\*) Em Suppose that two variables Zl and Z2 are independent so thatp(zl' Z2) = P(Zl)P(Z2)' Show that the covariance matrix between these variables is diagonal. This shows that independence is a sufficient condition for two variables to be uncorrelated. Now consider two variables Yl and Y2 in which -1 :0;; Yl :0;; 1 and Y2 = yg. Write down the conditional distribution p(Y2IYl) and observe that this is dependent on Yb showing that the two variables are not independent. Now show that the covariance matrix between these two variables is again diagonal. To do this, use the relation P(Yl, Y2) = P(YI )p(Y2IYl) to show that the off-diagonal terms are zero. This counter-example shows that zero correlation is not a sufficient condition for independence.

![image 45](Bishop2006_images/imageFile45.png)

## 13 Sequential Data Exercises

13.1 ( ) www Use the technique of d-separation, discussed in Section 8.2, to verify that the Markov model shown in Figure 13.3 having N nodes in total satisﬁes the conditional independence properties (13.3) for n = 2 ,...,N . Similarly, show that a model described by the graph in Figure 13.4 in which there are N nodes in total

![image 323](Bishop2006_images/imageFile323.png)

|

p

(

z

)

n

n

X

|

p

(

z

)

n

n

+1 |

X

|

p

(

z

)

n

n

+1 |

+1 )

x

|

p

(

z

)

n

n

+1 |

+1 )

z

X

Figure 13.23 Schematic illustration of the operation of the particle ﬁlter for a one-dimensional latent space. At time step n , the posterior p ( z n | x n ) is represented as a mixture distribution, shown schematically as circles whose sizes are proportional to the weights w ( l ) n . A set of L samples is then drawn from this distribution and the new weights w ( l ) n +1 evaluated using p ( x n +1 | z ( l ) n +1 ) .

$$
\text {for } n = 3 , \dots , N .
$$

$$
p ( x _ { n } | x _ { 1 } , \dots , x _ { n - 1 } ) = p ( x _ { n } | x _ { n - 1 } , x _ { n - 2 } )
$$

13.2 ( ) Consider the joint probability distribution (13.2) corresponding to the directed graph of Figure 13.3. Using the sum and product rules of probability, verify that this joint distribution satisﬁes the conditional independence property (13.3) for n = 2 ,...,N . Similarly, show that the second-order Markov model described by the joint distribution (13.4) satisﬁes the conditional independence property

$$
\text {for } n = 3 , \dots , N .
$$

$$
p ( x _ { n } | x _ { 1 } , \dots , x _ { n - 1 } ) = p ( x _ { n } | x _ { n - 1 } , x _ { n - 2 } )
$$

13.3 ( ) By using d-separation, show that the distribution p ( x 1 ,..., x N ) of the observed data for the state space model represented by the directed graph in Figure 13.5 does not satisfy any conditional independence properties and hence does not exhibit the Markov property at any ﬁnite order.

13.4 ( ) www Consider a hidden Markov model in which the emission densities are represented by a parametric model p ( x | z , w ) , such as a linear regression model or a neural network, in which w is a vector of adaptive parameters. Describe how the parameters w can be learned from data using maximum likelihood.

13.5 ( ) Verify the M-step equations (13.18) and (13.19) for the initial state probabilities and transition probability parameters of the hidden Markov model by maximization of the expected complete-data log likelihood function (13.17), using appropriate Lagrange multipliers to enforce the summation constraints on the components of π and A .

13.6 ( ) Show that if any elements of the parameters π or A for a hidden Markov model are initially set to zero, then those elements will remain zero in all subsequent updates of the EM algorithm.

13.7 ( ) Consider a hidden Markov model with Gaussian emission densities. Show that maximization of the function Q ( θ , θ old ) with respect to the mean and covariance parameters of the Gaussians gives rise to the M-step equations (13.20) and (13.21).

13.8 ( ) www For a hidden Markov model having discrete observations governed by a multinomial distribution, show that the conditional distribution of the observations given the hidden variables is given by (13.22) and the corresponding M step equations are given by (13.23). Write down the analogous equations for the conditional distribution and the M step equations for the case of a hidden Markov with multiple binary output variables each of which is governed by a Bernoulli conditional distribution. Hint: refer to Sections 2.1 and 2.2 for a discussion of the corresponding maximum likelihood solutions for i.i.d. data if required.

13.9 ( ) www Use the d-separation criterion to verify that the conditional independence properties (13.24)–(13.31) are satisﬁed by the joint distribution for the hidden Markov model deﬁned by (13.6).

13.10 ( ) By applying the sum and product rules of probability, verify that the conditional independence properties (13.24)–(13.31) are satisﬁed by the joint distribution for the hidden Markov model deﬁned by (13.6).

13.11 ( ) Starting from the expression (8.72) for the marginal distribution over the variables of a factor in a factor graph, together with the results for the messages in the sum-product algorithm obtained in Section 13.2.3, derive the result (13.43) for the joint posterior distribution over two successive latent variables in a hidden Markov model.

13.12 ( ) Suppose we wish to train a hidden Markov model by maximum likelihood using data that comprises R independent sequences of observations, which we denote by X ( r ) where r = 1 ,...,R . Show that in the E step of the EM algorithm, we simply evaluate posterior probabilities for the latent variables by running the α and β recursions independently for each of the sequences. Also show that in the M step, the initial probability and transition probability parameters are re-estimated

using modiﬁed forms of (13.18 ) and (13.19) given by

$$
\pi _ { k } \ = \ \frac { \sum _ { r = 1 } ^ { R } \gamma ( z _ { 1 k } ^ { ( r ) } ) } { \sum _ { r = 1 } ^ { R } \sum _ { j = 1 } ^ { K } \gamma ( z _ { 1 j } ^ { ( r ) } ) }
$$

$$
\frac { \sum _ { r = 1 } ^ { r = 1 } \gamma ( z _ { 1 k } ^ { ( r ) } ) } { \sum _ { r = 1 } ^ { R } \sum _ { j = 1 } ^ { N } \gamma ( z _ { 1 j } ^ { ( r ) } ) } \\ \frac { r } { R } \frac { N } { K } \sum _ { r = 1 } ^ { N } \xi ( z _ { r } ^ { ( r ) } ) \\ \sum _ { r = 1 } ^ { R } \sum _ { l = 1 } ^ { N } \xi ( z _ { r } ^ { ( r ) } )
$$

$$
r = & 1 \ j = 1 \\ \sum _ { r = 1 } ^ { R } \sum _ { n = 2 } ^ { N } \xi ( z _ { n - 1 , j } ^ { ( r ) } , z _ { n , k } ^ { ( r ) } ) \\ A _ { j k } \ = \ \frac { r = 1 } { R } \ K \ \frac { N } { N } \\ \sum _ { r = 1 } ^ { R } \sum _ { l = 1 } ^ { N } \sum _ { n = 2 } ^ { \xi ( z _ { n - 1 , j } ^ { ( r ) } , z _ { n , l } ^ { ( r ) } ) } \\
$$

where, for notational convenience, we have assumed that the sequences are of the same length (the generalization to sequences of different lengths is straightforward). Similarly, show that the M-step equation for re-estimation of the means of Gaussian emission models is given by

$$
\sum _ { k } \sum _ { R } \sum _ { N } ^ { R } \gamma ( z _ { n k } ^ { ( r ) } ) x _ { n } ^ { ( r ) } \\ \mu _ { k } = \frac { r = 1 } { R } \sum _ { N } ^ { R } \sum _ { N } ^ { N } \gamma ( z _ { n k } ^ { ( r ) } ) \\ \sum _ { r = 1 } ^ { R } \sum _ { n = 1 } ^ { N } \gamma ( z _ { n k } ^ { ( r ) } ) \\ \ e p \text {equations for other emission model parameters and distributions}
$$

Note that the M-step equations for other emission model parameters and distributions take an analogous form.

13.13 ( ) www Use the deﬁnition (8.64) of the messages passed from a factor node to a variable node in a factor graph, together with the expression (13.6) for the joint distribution in a hidden Markov model, to show that the deﬁnition (13.50) of the alpha message is the same as the deﬁnition (13.34).

13.14 ( ) Use the deﬁnition (8.67) of the messages passed from a factor node to a variable node in a factor graph, together with the expression (13.6) for the joint distribution in a hidden Markov model, to show that the deﬁnition (13.52) of the beta message is the same as the deﬁnition (13.35).

13.15 ( ) Use the expressions (13.33) and (13.43) for the marginals in a hidden Markov model to derive the corresponding results (13.64) and (13.65) expressed in terms of re-scaled variables.

13.16 ( ) In this exercise, we derive the forward message passing equation for the Viterbi algorithm directly from the expression (13.6) for the joint distribution. This involves maximizing over all of the hidden variables z 1 ,..., z N . By taking the logarithm and then exchanging maximizations and summations, derive the recursion

(13.68) where the quantities ω ( z n ) are deﬁned by (13.70). Show that the initial condition for this recursion is given by (13.69).

13.17 ( ) www Show that the directed graph for the input-output hidden Markov model, given in Figure 13.18, can be expressed as a tree-structured factor graph of the form shown in Figure 13.15 and write down expressions for the initial factor h ( z 1 ) and for the general factor f n ( z n − 1 , z n ) where 2 n N .

13.18 ( ) Using the result of Exercise 13.17, derive the recursion equations, including the initial conditions, for the forward-backward algorithm for the input-output hidden Markov model shown in Figure 13.18.

13.19 ( ) www The Kalman ﬁlter and smoother equations allow the posterior distributions over individual latent variables, conditioned on all of the observed variables, to be found efﬁciently for linear dynamical systems. Show that the sequence of latent variable values obtained by maximizing each of these posterior distributions individually is the same as the most probable sequence of latent values. To do this, simply note that the joint distribution of all latent and observed variables in a linear dynamical system is Gaussian, and hence all conditionals and marginals will also be Gaussian, and then make use of the result (2.98).

13.20 ( ) www Use the result (2.115) to prove (13.87).

13.21 ( ) Use the results (2.115) and (2.116), together with the matrix identities (C.5) and (C.7), to derive the results (13.89), (13.90), and (13.91), where the Kalman gain matrix K n is deﬁned by (13.92).

13.22 ( ) www Using (13.93), together with the deﬁnitions (13.76) and (13.77) and the result (2.115), derive (13.96).

13.23 ( ) Using (13.93), together with the deﬁnitions (13.76) and (13.77) and the result (2.116), derive (13.94), (13.95) and (13.97).

13.24 ( ) www Consider a generalization of (13.75) and (13.76) in which we include constant terms a and c in the Gaussian means, so that

$$
p ( z _ { n } | z _ { n - 1 } ) & = \mathcal { N } ( z _ { n } | A z _ { n - 1 } + \mathbf i \\ p ( x \ | z _ { n } ) & = \mathcal { N } ( x \ | C z _ { n } + \mathbf c \cdot
$$

$$
p ( z _ { n } | z _ { n - 1 } ) = \mathcal { N } ( z _ { n } | A z _ { n - 1 } + a , \Gamma )
$$

$$
p ( x _ { n } | z _ { n } ) = \mathcal { N } ( x _ { n } | C z _ { n } + c , \Sigma ) .
$$

Show that this extension can be re-case in the framework discussed in this chapter by deﬁning a state vector z with an additional component ﬁxed at unity, and then augmenting the matrices A and C using extra columns corresponding to the parameters a and c .

13.25 ( ) In this exercise, we show that when the Kalman ﬁlter equations are applied to independent observations, they reduce to the results given in Section 2.3 for the maximum likelihood solution for a single Gaussian distribution. Consider the problem of ﬁnding the mean µ of a single Gaussian random variable x , in which we are given a set of independent observations { x 1 ,...,x N } . To model this we can use

a linear dynamical system governed by (13.75) and (13.76), with latent variables { z 1 ,...,z N } in which C becomes the identity matrix and where the transition probability A = 0 because the observations are independent. Let the parameters m 0 and V 0 of the initial state be denoted by µ 0 and σ 2 0 , respectively, and suppose that Σ becomes σ 2 . Write down the corresponding Kalman ﬁlter equations starting from the general results (13.89) and (13.90), together with (13.94) and (13.95). Show that these are equivalent to the results (2.141) and (2.142) obtained directly by considering independent data.

- 13.26 ( ) Consider a special case of the linear dynamical system of Section 13.3 that is equivalent to probabilistic PCA, so that the transition matrix A = 0 , the covariance Γ = I , and the noise covariance Σ = σ 2 I . By making use of the matrix inversion identity (C.7) show that, if the emission density matrix C is denoted W , then the posterior distribution over the hidden states deﬁned by (13.89) and (13.90) reduces to the result (12.42) for probabilistic PCA.
- 13.27 ( ) www Consider a linear dynamical system of the form discussed in Section 13.3 in which the amplitude of the observation noise goes to zero, so that Σ = 0 . Show that the posterior distribution for z n has mean x n and zero variance. This accords with our intuition that if there is no noise, we should just use the current observation x n to estimate the state variable z n and ignore all previous observations.
- 13.28 ( ) Consider a special case of the linear dynamical system of Section 13.3 in which the state variable z n is constrained to be equal to the previous state variable, which corresponds to A = I and Γ = 0 . For simplicity, assume also that V 0 → ∞ so that the initial conditions for z are unimportant, and the predictions are determined purely by the data. Use proof by induction to show that the posterior mean for state z n is determined by the average of x 1 ,..., x n . This corresponds to the intuitive result that if the state variable is constant, our best estimate is obtained by averaging the observations.
- 13.29 ( ) Starting from the backwards recursion equation (13.99), derive the RTS smoothing equations (13.100) and (13.101) for the Gaussian linear dynamical system.
- 13.30 ( ) Starting from the result (13.65) for the pairwise posterior marginal in a state space model, derive the speciﬁc form (13.103) for the case of the Gaussian linear dynamical system.
- 13.31 ( ) Starting from the result (13.103) and by substituting for α ( z n ) using (13.84), verify the result (13.104) for the covariance between z n and z n − 1 . 13.32 ( ) www Verify the results (13.110) and (13.111) for the M-step equations for
- 13.32 ( /star /star ) www Verify the results (13.110) and (13.111) for the M-step equations for µ 0 and V 0 in the linear dynamical system.
- 13.33 ( ) Verify the results (13.113) and (13.114) for the M-step equations for A and Γ in the linear dynamical system.

  13.34 ( ) Verify the results (13.115) and (13.116) for the M-step equations for C and Σ in the linear dynamical system.

![image 47](Bishop2006_images/imageFile47.png)

## 14 Combining Models Exercises

14.1 ( ) www Consider a set models of the form p ( t | x , z h , θ h ,h ) in which x is the input vector, t is the target vector, h indexes the different models, z h is a latent variable for model h , and θ h is the set of parameters for model h . Suppose the models have prior probabilities p ( h ) and that we are given a training set X = { x 1 ,..., x N } and T = { t 1 ,..., t N } . Write down the formulae needed to evaluate the predictive distribution p ( t | x , X , T ) in which the latent variables and the model index are marginalized out. Use these formulae to highlight the difference between Bayesian averaging of different models and the use of latent variables within a single model.

14.2 ( ) The expected sum-of-squares error E AV for a simple committee model can be deﬁned by (14.10), and the expected error of the committee itself is given by (14.11). Assuming that the individual errors satisfy (14.12) and (14.13), derive the result (14.14).

14.3 ( ) www By making use of Jensen’s inequality (1.115), for the special case of the convex function f ( x ) = x 2 , show that the average expected sum-of-squares error E AV of the members of a simple committee model, given by (14.10), and the expected error E COM of the committee itself, given by (14.11), satisfy

$$
E _ { C O M } \leqslant E _ { A V } .
$$

14.4 ( ) By making use of Jensen’s in equality (1.115), show that the result (14.54) derived in the previous exercise hods for any error function E ( y ) , not just sum-ofsquares, provided it is a convex function of y .

14.5 ( ) www Consider a committee in which we allow unequal weighting of the constituent models, so that

$$
y _ { \text {COM} } ( x ) = \sum _ { m = 1 } ^ { M } \alpha _ { m } y _ { m } ( x ) . \\ \intertext { t h a t h the predictions y _ { \text {COM} } ( x ) \text { remain within sensible limits, sup-} }
$$

In order to ensure that the predictions y COM ( x ) remain within sensible limits, suppose that we require that they be bounded at each value of x by the minimum and maximum values given by any of the members of the committee, so that

$$
y _ { \min } ( x ) \leqslant y _ { C O M } ( x ) \leqslant y _ { \max } ( x ) .
$$

Show that a necessary and sufﬁcient condition for this constraint is that the coefﬁcients α m satisfy M

$$
\alpha _ { m } \geqslant 0 , \quad \sum _ { m = 1 } ^ { M } \alpha _ { m } = 1 .
$$

14.6 ( ) www By differentiating the error function (14.23) with respect to α m , show that the parameters α m in the AdaBoost algorithm are updated using (14.17) in which m is deﬁned by (14.16).

14.7 ( ) By making a variational minimization of the expected exponential error function given by (14.27) with respect to all possible functions y ( x ) , show that the minimizing function is given by (14.28).

14.8 ( ) Show that the exponential error function (14.20), which is minimized by the AdaBoost algorithm, does not correspond to the log likelihood of any well-behaved probabilistic model. This can be done by showing that the corresponding conditional distribution p ( t | x ) cannot be correctly normalized.

14.9 ( ) www Show that the sequential minimization of the sum-of-squares error function for an additive model of the form (14.21) in the style of boosting simply involves ﬁtting each new base classiﬁer to the residual errors t n − f m − 1 ( x n ) from the previous model.

14.10 ( ) Verify that if we minimize the sum-of-squares error between a set of training values { t n } and a single predictive value t , then the optimal solution for t is given by the mean of the { t n } .

14.11 ( ) Consider a data set comprising 400 data points from class C 1 and 400 data points from class C 2 . Suppose that a tree model A splits these into (300 , 100) at the ﬁrst leaf node and (100 , 300) at the second leaf node, where ( n,m ) denotes that n points are assigned to C 1 and m points are assigned to C 2 . Similarly, suppose that a second tree model B splits them into (200 , 400) and (200 , 0) . Evaluate the misclassiﬁcation rates for the two trees and hence show that they are equal. Similarly, evaluate the cross-entropy (14.32) and Gini index (14.33) for the two trees and show that they are both lower for tree B than for tree A.

14.12 ( ) Extend the results of Section 14.5.1 for a mixture of linear regression models to the case of multiple target values described by a vector t . To do this, make use of the results of Section 3.1.5.

14.13 ( ) www Verify that the complete-data log likelihood function for the mixture of linear regression models is given by (14.36).

14.14 ( ) Use the technique of Lagrange multipliers (Appendix E) to show that the M-step re-estimation equation for the mixing coefﬁcients in the mixture of linear regression models trained by maximum likelihood EM is given by (14.38).

14.15 ( ) www We have already noted that if we use a squared loss function in a regression problem, the corresponding optimal prediction of the target variable for a new input vector is given by the conditional mean of the predictive distribution. Show that the conditional mean for the mixture of linear regression models discussed in Section 14.5.1 is given by a linear combination of the means of each component distribution. Note that if the conditional distribution of the target data is multimodal, the conditional mean can give poor predictions.

14.16 ( ) Extend the logistic regression mixture model of Section 14.5.2 to a mixture of softmax classiﬁers representing C 2 classes. Write down the EM algorithm for determining the parameters of this model through maximum likelihood.

14.17 ( ) www Consider a mixture model for a conditional distribution p ( t | x ) of the form K

$$
p ( t | x ) = \sum _ { k = 1 } ^ { K } \pi _ { k } \psi _ { k } ( t | x ) \\ \text {are component } \psi _ { k } ( t | x ) \text { is itself a mixture model. Show that this}
$$

in which each mixture component ψ k ( t | x ) is itself a mixture model. Show that this two-level hierarchical mixture is equivalent to a conventional single-level mixture model. Now suppose that the mixing coefﬁcients in both levels of such a hierarchical model are arbitrary functions of x . Again, show that this hierarchical model is again equivalent to a single-level model with x -dependent mixing coefﬁcients. Finally, consider the case in which the mixing coefﬁcients at both levels of the hierarchical mixture are constrained to be linear classiﬁcation (logistic or softmax) models. Show that the hierarchical mixture cannot in general be represented by a single-level mixture having linear classiﬁcation models for the mixing coefﬁcients. Hint: to do this it is sufﬁcient to construct a single counter-example, so consider a mixture of two components in which one of those components is itself a mixture of two components, with mixing coefﬁcients given by linear-logistic models. Show that this cannot be represented by a single-level mixture of 3 components having mixing coefﬁcients determined by a linear-softmax model.
