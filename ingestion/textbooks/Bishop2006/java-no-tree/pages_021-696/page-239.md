[Page 239]

where

###### p(a) = δ(a − wTφ)q(w)dw. (4.148)

We can evaluate p(a) by noting that the delta function imposes a linear constraint on w and so forms a marginal distribution from the joint distribution q(w) by integrating out all directions orthogonal to φ. Because q(w) is Gaussian, we know from Section 2.3.2 that the marginal distribution will also be Gaussian. We can evaluate the mean and covariance of this distribution by taking moments, and interchanging the order of integration over a and w, so that

###### µa = E[a] = p(a)ada = q(w)wTφdw = wMAPT φ (4.149)

where we have used the result (4.144) for the variational posterior distribution q(w). Similarly

σa2 = var[a] = p(a) a2 − E[a]2 da

= q(w) (wTφ)2 − (mTNφ)2 dw = φTSNφ. (4.150)

Note that the distribution of a takes the same form as the predictive distribution (3.58) for the linear regression model, with the noise variance set to zero. Thus our variational approximation to the predictive distribution becomes

p(C1|t) = σ(a)p(a)da = σ(a)N(a|µa,σa2)da. (4.151) This result can also be derived directly by making use of the results for the marginal

- Exercise 4.24 of a Gaussian distribution given in Section 2.3.2. The integral over a represents the convolution of a Gaussian with a logistic sig-

moid, and cannot be evaluated analytically. We can, however, obtain a good approximation (Spiegelhalter and Lauritzen, 1990; MacKay, 1992b; Barber and Bishop, 1998a) by making use of the close similarity between the logistic sigmoid function σ(a) deﬁned by (4.59) and the probit function Φ(a) deﬁned by (4.114). In order to obtain the best approximation to the logistic function we need to re-scale the horizontal axis, so that we approximate σ(a) by Φ(λa). We can ﬁnd a suitable value of λ by requiring that the two functions have the same slope at the origin, which gives

- Exercise 4.25 λ2 = π/8. The similarity of the logistic sigmoid and the probit function, for this choice of λ, is illustrated in Figure 4.9.

The advantage of using a probit function is that its convolution with a Gaussian can be expressed analytically in terms of another probit function. Speciﬁcally we

- Exercise 4.26 can show that


Φ(λa)N(a|µ,σ2)da = Φ

µ (λ−2 + σ2)1/2

. (4.152)
