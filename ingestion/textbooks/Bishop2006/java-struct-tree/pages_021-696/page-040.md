[Page 40]

ﬁnite sum over these points

�N

1 N

f(xn). (1.35)

E[f] �

n=1

We shall make extensive use of this result when we discuss sampling methods in Chapter 11. The approximation in (1.35) becomes exact in the limit N → ∞.

Sometimes we will be considering expectations of functions of several variables, in which case we can use a subscript to indicate which variable is being averaged over, so that for instance

Ex[f(x,y)] (1.36) denotes the average of the function f(x,y) with respect to the distribution of x. Note that Ex[f(x,y)] will be a function of y.

We can also consider a conditional expectation with respect to a conditional distribution, so that

�

Ex[f|y] =

p(x|y)f(x) (1.37)

x

with an analogous deﬁnition for continuous variables. The variance of f(x) is deﬁned by

�

�

(f(x) − E[f(x)])2

var[f] = E

(1.38)

and provides a measure of how much variability there is in f(x) around its mean value E[f(x)]. Expanding out the square, we see that the variance can also be written

Exercise 1.5 in terms of the expectations of f(x) and f(x)2

var[f] = E[f(x)2] − E[f(x)]2. (1.39) In particular, we can consider the variance of the variable x itself, which is given by

var[x] = E[x2] − E[x]2. (1.40) For two random variables x and y, the covariance is deﬁned by

cov[x,y] = Ex,y [{x − E[x]}{y − E[y]}]

= Ex,y[xy] − E[x]E[y] (1.41) which expresses the extent to which x and y vary together. If x and y are indepen-

Exercise 1.6 dent, then their covariance vanishes.

In the case of two vectors of random variables x and y, the covariance is a matrix

�{x − E[x]}{yT − E[yT]}�

cov[x,y] = Ex,y

= Ex,y[xyT] − E[x]E[yT]. (1.42)

If we consider the covariance of the components of a vector x with each other, then we use a slightly simpler notation cov[x] ≡ cov[x,x].
