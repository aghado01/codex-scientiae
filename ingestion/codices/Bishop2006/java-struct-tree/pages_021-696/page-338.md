[Page 338]

where Ψ(a�N) = lnp(a�N|θ) + lnp(tN|a�N). We also need to evaluate the gradient of lnp(tN|θ) with respect to the parameter vector θ. Note that changes in θ will cause changes in a�N, leading to additional terms in the gradient. Thus, when we differentiate (6.90) with respect to θ, we obtain two sets of terms, the ﬁrst arising from the dependence of the covariance matrix CN on θ, and the rest arising from dependence of a�N on θ.

The terms arising from the explicit dependence on θ can be found by using (6.80) together with the results (C.21) and (C.22), and are given by

∂ lnp(tN|θ) ∂θj

1 2

∂CN ∂θj

a�NTC−1

C−1

=

N a�N

N

Tr�(I + CNWN)−1WN

�. (6.91)

1 2

∂CN ∂θj

−

To compute the terms arising from the dependence of a�N on θ, we note that the Laplace approximation has been constructed such that Ψ(aN) has zero gradient at aN = a�N, and so Ψ(a�N) gives no contribution to the gradient as a result of its dependence on a�N. This leaves the following contribution to the derivative with respect to a component θj of θ

�N

∂ ln|WN + C−1

1 2

∂a�n ∂θj

N | ∂a�n

−

n=1

�N

1 2

�

�nn σn�(1 − σn�)(1 − 2σn�)

∂a�n ∂θj

= −

(I + CNWN)−1CN

(6.92)

n=1

where σn� = σ(a�n), and again we have used the result (C.22) together with the deﬁnition of WN. We can evaluate the derivative of a�N with respect to θj by differentiating the relation (6.84) with respect to θj to give

∂a�n ∂θj

∂CN ∂θj

=

(tN − σN) − CNWN

∂a�n ∂θj

. (6.93)

Rearranging then gives

= (I + WNCN)−1∂CN ∂θj

∂a�n ∂θj

(tN − σN). (6.94)

Combining (6.91), (6.92), and (6.94), we can evaluate the gradient of the log likelihood function, which can be used with standard nonlinear optimization algorithms in order to determine a value for θ.

We can illustrate the application of the Laplace approximation for Gaussian pro-

Appendix A cesses using the synthetic two-class data set shown in Figure 6.12. Extension of the Laplace approximation to Gaussian processes involving K > 2 classes, using the softmax activation function, is straightforward (Williams and Barber, 1998).
