[Page 238]

where m0 and S0 are ﬁxed hyperparameters. The posterior distribution over w is given by

p(w|t) ∝ p(w)p(t|w) (4.141)

where t = (t1,...,tN)T. Taking the log of both sides, and substituting for the prior distribution using (4.140), and for the likelihood function using (4.89), we obtain

- 1

- 2


lnp(w|t) = −

+

(w − m0)TS−1

0 (w − m0)

N

{tn lnyn + (1 − tn)ln(1 − yn)} + const (4.142)

n=1

where yn = σ(wTφn). To obtain a Gaussian approximation to the posterior distribution, we ﬁrst maximize the posterior distribution to give the MAP (maximum

posterior) solution wMAP, which deﬁnes the mean of the Gaussian. The covariance is then given by the inverse of the matrix of second derivatives of the negative log likelihood, which takes the form

SN = −∇∇lnp(w|t) = S−1

0 +

N

yn(1 − yn)φnφTn. (4.143)

n=1

The Gaussian approximation to the posterior distribution therefore takes the form

q(w) = N(w|wMAP,SN). (4.144)

Having obtained a Gaussian approximation to the posterior distribution, there remains the task of marginalizing with respect to this distribution in order to make predictions.

###### 4.5.2 Predictive distribution

The predictive distribution for class C1, given a new feature vector φ(x), is obtained by marginalizing with respect to the posterior distribution p(w|t), which is itself approximated by a Gaussian distribution q(w) so that

p(C1|φ,t) = p(C1|φ,w)p(w|t)dw σ(wTφ)q(w)dw (4.145)

with the corresponding probability for class C2 given by p(C2|φ,t) = 1−p(C1|φ,t). To evaluate the predictive distribution, we ﬁrst note that the function σ(wTφ) depends on w only through its projection onto φ. Denoting a = wTφ, we have

σ(wTφ) = δ(a − wTφ)σ(a)da (4.146)

where δ(·) is the Dirac delta function. From this we obtain

σ(wTφ)q(w)dw = σ(a)p(a)da (4.147)
