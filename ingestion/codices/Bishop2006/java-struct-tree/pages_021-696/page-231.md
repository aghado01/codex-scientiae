[Page 231]

Figure 4.13 Schematic example of a probability density p(θ) shown by the blue curve, given in this example by a mixture of two Gaussians, along with its cumulative distribution function f(a), shown by the red curve. Note that the value of the blue curve at any point, such as that indicated by the vertical green line, corresponds to the slope of the red curve at the same point. Conversely, the value of the red curve at this point corresponds to the area under the blue curve indicated by the shaded green region. In the stochastic threshold model, the class label takes the value t = 1 if the value of a = wTφ exceeds a threshold, otherwise it takes the value t = 0. This is equivalent to an activation function given by the cumulative distribution function f(a).

1

0.8

0.6

0.4

0.2

0

0 1 2 3 4

If the value of θ is drawn from a probability density p(θ), then the corresponding activation function will be given by the cumulative distribution function

f(a) = � a

p(θ)dθ (4.113)

−∞

as illustrated in Figure 4.13.

As a speciﬁc example, suppose that the density p(θ) is given by a zero mean, unit variance Gaussian. The corresponding cumulative distribution function is given by

Φ(a) = � a

N(θ|0,1)dθ (4.114)

−∞

which is known as the probit function. It has a sigmoidal shape and is compared with the logistic sigmoid function in Figure 4.9. Note that the use of a more general Gaussian distribution does not change the model because this is equivalent to a re-scaling of the linear coefﬁcients w. Many numerical packages provide for the evaluation of a closely related function deﬁned by

� a

2 √π

exp(−θ2/2)dθ (4.115)

erf(a) =

0

and known as the erf function or error function (not to be confused with the error Exercise 4.21 function of a machine learning model). It is related to the probit function by

�1 +

erf(a)�. (4.116)

1 √2

1 2

Φ(a) =

The generalized linear model based on a probit activation function is known as probit regression.

We can determine the parameters of this model using maximum likelihood, by a straightforward extension of the ideas discussed earlier. In practice, the results found using probit regression tend to be similar to those of logistic regression. We shall,
