[Page 161]

will be simply

###### E[t|x] = tp(t|x)dt = y(x,w). (3.9)

Note that the Gaussian noise assumption implies that the conditional distribution of t given x is unimodal, which may be inappropriate for some applications. An extension to mixtures of conditional Gaussian distributions, which permit multimodal conditional distributions, will be discussed in Section 14.5.1.

Now consider a data set of inputs X = {x1,...,xN} with corresponding target values t1,...,tN. We group the target variables {tn} into a column vector that we denote by t where the typeface is chosen to distinguish it from a single observation of a multivariate target, which would be denoted t. Making the assumption that these data points are drawn independently from the distribution (3.8), we obtain the following expression for the likelihood function, which is a function of the adjustable parameters w and β, in the form

p(t|X,w,β) =

N

N(tn|wTφ(xn),β−1) (3.10)

n=1

where we have used (3.3). Note that in supervised learning problems such as regression (and classiﬁcation), we are not seeking to model the distribution of the input variables. Thus x will always appear in the set of conditioning variables, and so from now on we will drop the explicit x from expressions such as p(t|x,w,β) in order to keep the notation uncluttered. Taking the logarithm of the likelihood function, and making use of the standard form (1.46) for the univariate Gaussian, we have

N

lnN(tn|wTφ(xn),β−1)

lnp(t|w,β) =

n=1

N 2

N 2

=

ln(2π) − βED(w) (3.11) where the sum-of-squares error function is deﬁned by

lnβ −

1 2

ED(w) =

N

{tn − wTφ(xn)}2. (3.12)

n=1

Having written down the likelihood function, we can use maximum likelihood to determine w and β. Consider ﬁrst the maximization with respect to w. As observed already in Section 1.2.5, we see that maximization of the likelihood function under a conditional Gaussian noise distribution for a linear model is equivalent to minimizing a sum-of-squares error function given by ED(w). The gradient of the log likelihood function (3.11) takes the form

N

∇lnp(t|w,β) =

tn − wTφ(xn) φ(xn)T. (3.13)
