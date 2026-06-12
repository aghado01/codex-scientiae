[Page 166]

Figure 3.4 Plot of the contours of the unregularized error function (blue) along with the constraint region (3.30) for the quadratic regularizer q = 2 on the left and the lasso regularizer q = 1 on the right, in which the optimum value for the parameter vector w is denoted by w . The lasso gives a sparse solution in which w 1 = 0 .

w

w

![In the image, we can see a diagram of a circle. There are two points named W and W*.](../images/imageFile76.png)

2

2

/star

/star

w

w

w

w

1

1

For the remainder of this chapter we shall focus on the quadratic regularizer (3.27) both for its practical importance and its analytical tractability.

# 3.1.5 Multiple outputs

So far, we have considered the case of a single target variable t . In some applications, we may wish to predict K > 1 target variables, which we denote collectively by the target vector t . This could be done by introducing a different set of basis functions for each component of t , leading to multiple, independent regression problems. However, a more interesting, and more common, approach is to use the same set of basis functions to model all of the components of the target vector so that

$$
y ( x , w ) = W ^ { T } \phi ( x )
$$

where y is a K -dimensional column vector, W is an M × K matrix of parameters, and φ ( x ) is an M -dimensional column vector with elements φ j ( x ) , with φ 0 ( x ) = 1 as before. Suppose we take the conditional distribution of the target vector to be an isotropic Gaussian of the form

$$
p ( t | x , W , \beta ) = \mathcal { N } ( t | W ^ { \top } \phi ( x ) , \beta ^ { - 1 } \mathbf I ) .
$$

If we have a set of observations t 1 ,..., t N , we can combine these into a matrix T of size N × K such that the n th row is given by t T n . Similarly, we can combine the input vectors x 1 ,..., x N into a matrix X . The log likelihood function is then given by

$$
\ln p ( T | X , W , \beta ) \ & = \ \sum _ { n = 1 } ^ { N } \ln \mathcal { N } ( t _ { n } | W ^ { T } \phi ( x _ { n } ) , \beta ^ { - 1 } I ) \\ & = \ \frac { N K } { 2 } \ln \left ( \frac { \beta } { 2 \pi } \right ) - \frac { \beta } { 2 } \sum _ { n = 1 } ^ { N } \left \| t _ { n } - W ^ { T } \phi ( x _ { n } ) \right \| ^ { 2 } . \ ( 3 . 3 3 )
$$
