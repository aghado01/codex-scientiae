[Page 300]

where the input-dependent variance is given by

###### σ2(x) = β−1 + gTA−1g. (5.173)

We see that the predictive distribution p(t|x,D) is a Gaussian whose mean is given by the network function y(x,wMAP) with the parameter set to their MAP value. The variance has two terms, the ﬁrst of which arises from the intrinsic noise on the target variable, whereas the second is an x-dependent term that expresses the uncertainty in the interpolant due to the uncertainty in the model parameters w. This should be compared with the corresponding predictive distribution for the linear regression model, given by (3.58) and (3.59).

###### 5.7.2 Hyperparameter optimization

So far, we have assumed that the hyperparameters α and β are ﬁxed and known. We can make use of the evidence framework, discussed in Section 3.5, together with the Gaussian approximation to the posterior obtained using the Laplace approximation, to obtain a practical procedure for choosing the values of such hyperparameters.

The marginal likelihood, or evidence, for the hyperparameters is obtained by integrating over the network weights

p(D|α,β) = p(D|w,β)p(w|α)dw. (5.174)

- Exercise 5.39 This is easily evaluated by making use of the Laplace approximation result (4.135). Taking logarithms then gives


1 2

W 2

N 2

N 2

lnp(D|α,β) −E(wMAP) −

ln|A| +

lnα +

lnβ −

ln(2π) (5.175)

where W is the total number of parameters in w, and the regularized error function is deﬁned by

β 2

E(wMAP) =

N

{y(xn,wMAP) − tn}2 +

n=1

α 2

wMAPT wMAP. (5.176)

We see that this takes the same form as the corresponding result (3.86) for the linear regression model.

In the evidence framework, we make point estimates for α and β by maximizing lnp(D|α,β). Consider ﬁrst the maximization with respect to α, which can be done by analogy with the linear regression case discussed in Section 3.5.2. We ﬁrst deﬁne the eigenvalue equation

βHui = λiui (5.177) where H is the Hessian matrix comprising the second derivatives of the sum-ofsquares error function, evaluated at w = wMAP. By analogy with (3.92), we obtain

γ wMAPT wMAP

α =

(5.178)
