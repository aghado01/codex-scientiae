[Page 516]

1

1

|λ = 0.2<br><br>λ = 0.7<br><br>|
|---|


###### ξ = 2.5

0.5

0.5

0

0

−6 0 6

−6 −ξ 0 ξ 6

- Figure 10.12 The left-hand plot shows the logistic sigmoid function σ(x) deﬁned by (10.134) in red, together with two examples of the exponential upper bound (10.137) shown in blue. The right-hand plot shows the logistic sigmoid again in red together with the Gaussian lower bound (10.144) shown in blue. Here the parameter ξ = 2.5, and the bound is exact at x = ξ and x = −ξ, denoted by the dashed green lines.


and taking the exponential, we obtain an upper bound on the logistic sigmoid itself of the form

σ(x) exp(λx − g(λ)) (10.137) which is plotted for two values of λ on the left-hand plot in Figure 10.12.

We can also obtain a lower bound on the sigmoid having the functional form of a Gaussian. To do this, we follow Jaakkola and Jordan (2000) and make transformations both of the input variable and of the function itself. First we take the log of the logistic function and then decompose it so that

###### lnσ(x) = −ln(1 + e−x) = −ln e−x/2(ex/2 + e−x/2)

= x/2 − ln(ex/2 + e−x/2). (10.138) We now note that the function f(x) = −ln(ex/2 + e−x/2) is a convex function of

- Exercise 10.31 the variable x2, as can again be veriﬁed by ﬁnding the second derivative. This leads to a lower bound on f(x), which is a linear function of x2 whose conjugate function is given by


√

g(λ) = max

λx2 − f

x2 . (10.139) The stationarity condition leads to

x2

dx dx2

0 = λ −

1 4x

d dx

f(x) = λ +

tanh

x 2

. (10.140)

If we denote this value of x, corresponding to the contact point of the tangent line for this particular value of λ, by ξ, then we have

1 4ξ

λ(ξ) = −

tanh

ξ 2

- 1

- 2ξ


= −

1 2

σ(ξ) −

. (10.141)
