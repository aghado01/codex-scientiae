[Page 196]

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
