[Page 243]

- 4.17 ( ) www Show that the derivatives of the softmax activation function (4.104), where the ak are deﬁned by (4.105), are given by (4.106).

- 4.18 ( ) Using the result (4.91) for the derivatives of the softmax activation function, show that the gradients of the cross-entropy error (4.108) are given by (4.109).
- 4.19 ( ) www Write down expressions for the gradient of the log likelihood, as well as the corresponding Hessian matrix, for the probit regression model deﬁned in Section 4.3.5. These are the quantities that would be required to train such a model using IRLS.

- 4.20 ( ) Show that the Hessian matrix for the multiclass logistic regression problem, deﬁned by (4.110), is positive semideﬁnite. Note that the full Hessian matrix for this problem is of size MK × MK, where M is the number of parameters and K is the number of classes. To prove the positive semideﬁnite property, consider the product uTHu where u is an arbitrary vector of length MK, and then apply Jensen’s inequality.
- 4.21 ( ) Show that the probit function (4.114) and the erf function (4.115) are related by (4.116).
- 4.22 ( ) Using the result (4.135), derive the expression (4.137) for the log model evidence under the Laplace approximation.
- 4.23 ( ) www In this exercise, we derive the BIC result (4.139) starting from the Laplace approximation to the model evidence given by (4.137). Show that if the

prior over parameters is Gaussian of the form p(θ) = N(θ|m,V0), the log model evidence under the Laplace approximation takes the form

lnp(D) lnp(D|θMAP) −

1 2

(θMAP − m)TV−1

0 (θMAP − m) −

1 2

ln|H| + const

where H is the matrix of second derivatives of the log likelihood lnp(D|θ) evaluated at θMAP. Now assume that the prior is broad so that V−1

0 is small and the second term on the right-hand side above can be neglected. Furthermore, consider the case of independent, identically distributed data so that H is the sum of terms one for each data point. Show that the log model evidence can then be written approximately in the form of the BIC expression (4.139).

- 4.24 ( ) Use the results from Section 2.3.2 to derive the result (4.151) for the marginalization of the logistic regression model with respect to a Gaussian posterior distribution over the parameters w.
- 4.25 ( ) Suppose we wish to approximate the logistic sigmoid σ(a) deﬁned by (4.59) by a scaled probit function Φ(λa), where Φ(a) is deﬁned by (4.114). Show that if λ is chosen so that the derivatives of the two functions are equal at a = 0, then λ2 = π/8.
