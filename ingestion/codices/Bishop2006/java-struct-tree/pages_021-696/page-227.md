[Page 227]

4.3.3 Iterative reweighted least squares

In the case of the linear regression models discussed in Chapter 3, the maximum likelihood solution, on the assumption of a Gaussian noise model, leads to a closed-form solution. This was a consequence of the quadratic dependence of the log likelihood function on the parameter vector w. For logistic regression, there is no longer a closed-form solution, due to the nonlinearity of the logistic sigmoid function. However, the departure from a quadratic form is not substantial. To be precise, the error function is concave, as we shall see shortly, and hence has a unique minimum. Furthermore, the error function can be minimized by an efﬁcient iterative technique based on the Newton-Raphson iterative optimization scheme, which uses a local quadratic approximation to the log likelihood function. The Newton-Raphson update, for minimizing a function E(w), takes the form (Fletcher, 1987; Bishop and Nabney, 2008)

w(new) = w(old) − H−1∇E(w). (4.92)

where H is the Hessian matrix whose elements comprise the second derivatives of E(w) with respect to the components of w.

Let us ﬁrst of all apply the Newton-Raphson method to the linear regression model (3.3) with the sum-of-squares error function (3.12). The gradient and Hessian of this error function are given by

�N

(wTφn − tn)φn = ΦTΦw − ΦTt (4.93)

∇E(w) =

n=1

�N

φnφTn = ΦTΦ (4.94)

H = ∇∇E(w) =

n=1

Section 3.1.1 where Φ is the N × M design matrix, whose nth row is given by φTn. The Newton-

Raphson update then takes the form

w(new) = w(old) − (ΦTΦ)−1 �

�

ΦTΦw(old) − ΦTt

= (ΦTΦ)−1ΦTt (4.95)

which we recognize as the standard least-squares solution. Note that the error function in this case is quadratic and hence the Newton-Raphson formula gives the exact solution in one step.

Now let us apply the Newton-Raphson update to the cross-entropy error function (4.90) for the logistic regression model. From (4.91) we see that the gradient and Hessian of this error function are given by

�N

(yn − tn)φn = ΦT(y − t) (4.96)

∇E(w) =

n=1

�N

H = ∇∇E(w) =

yn(1 − yn)φnφTn = ΦTRΦ (4.97)

n=1
