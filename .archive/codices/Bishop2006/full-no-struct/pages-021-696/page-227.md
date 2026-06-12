[Page 227]

Section 3.1.1

# 4.3.3 Iterative reweighted least squares

In the case of the linear regression models discussed in Chapter 3, the maximum likelihood solution, on the assumption of a Gaussian noise model, leads to a closed-form solution. This was a consequence of the quadratic dependence of the log likelihood function on the parameter vector w . For logistic regression, there is no longer a closed-form solution, due to the nonlinearity of the logistic sigmoid function. However, the departure from a quadratic form is not substantial. To be precise, the error function is concave, as we shall see shortly, and hence has a unique minimum. Furthermore, the error function can be minimized by an efﬁcient iterative technique based on the Newton-Raphson iterative optimization scheme, which uses a local quadratic approximation to the log likelihood function. The Newton-Raphson update, for minimizing a function E ( w ) , takes the form (Fletcher, 1987; Bishop and Nabney, 2008) (new) (old) 1

$$
w ^ { ( n e w ) } = w ^ { ( o l d ) } - H ^ { - 1 } \nabla E ( w ) . \\ \intertext { w } \text { } H o s c i o n \, \text { mitriv w} \, \text {o} \, \text { elements a } \text { elements } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \text { a } \
$$

where H is the Hessian matrix whose elements comprise the second derivatives of E ( w ) with respect to the components of w .

Let us ﬁrst of all apply the Newton-Raphson method to the linear regression model (3.3) with the sum-of-squares error function (3.12). The gradient and Hessian of this error function are given by

$$
\nabla E ( w ) \ = \ \sum _ { n = 1 } ^ { N } ( w ^ { T } \phi _ { n } - t _ { n } ) \phi _ { n } = \Phi ^ { T } \Phi w - \Phi ^ { T } t \quad ( 4 . 9 3 ) \\
$$

$$
H = \nabla \nabla E ( w ) \ = \ \sum _ { n = 1 } ^ { N } \phi _ { n } \phi _ { n } ^ { T } = \Phi ^ { T } \Phi \\ \intertext { w h o r } \where \Phi \text { is the } N \times \mathbb { A } \ \{ \, \deg \eta \, \ m a t r i v { w } \, \ m a t h \, w i v { o n } \, \ m a t h \, \Phi \, \ T \, \ m a t h \, N \, w o t h \, \ m a t h \, \Phi \, \}
$$

where Φ is the N × M design matrix, whose n th row is given by φ T n . The NewtonRaphson update then takes the form

$$
\L a p h i s o n \, \text {update then takes the 1 to 1} \, \Pi \\ w ^ { ( n e w ) } \ = \ w ^ { ( o l d ) } - ( \Phi ^ { T } \Phi ) ^ { - 1 } \left \{ \Phi ^ { T } \Phi _ { W } ^ { ( o l d ) } - \Phi ^ { T } t \right \} \\ = \ ( \Phi ^ { T } \Phi ) ^ { - 1 } \Phi ^ { T } t
$$

which we recognize as the standard least-squares solution. Note that the error function in this case is quadratic and hence the Newton-Raphson formula gives the exact solution in one step.

Now let us apply the Newton-Raphson update to the cross-entropy error function (4.90) for the logistic regression model. From (4.91) we see that the gradient and Hessian of this error function are given by

$$
\nabla E ( w ) \ = \ \sum _ { n = 1 } ^ { N } ( y _ { n } - t _ { n } ) \phi _ { n } = \Phi ^ { T } ( y - t ) \\
$$

$$
H \ = \ \nabla \nabla E ( w ) = \sum _ { n = 1 } ^ { N } y _ { n } ( 1 - y _ { n } ) \phi _ { n } \phi _ { n } ^ { T } = \Phi ^ { T } R \Phi
$$
