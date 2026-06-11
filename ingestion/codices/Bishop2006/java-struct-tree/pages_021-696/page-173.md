[Page 173]

Next we compute the posterior distribution, which is proportional to the product of the likelihood function and the prior. Due to the choice of a conjugate Gaussian prior distribution, the posterior will also be Gaussian. We can evaluate this distribution by the usual procedure of completing the square in the exponential, and then ﬁnding the normalization coefﬁcient using the standard result for a normalized

Exercise 3.7 Gaussian. However, we have already done the necessary work in deriving the general result (2.116), which allows us to write down the posterior distribution directly in the form

p(w|t) = N(w|mN,SN) (3.49) where

�

�

S−1

mN = SN

0 m0 + βΦTt

(3.50) S−1

N = S−1

0 + βΦTΦ. (3.51)

Note that because the posterior distribution is Gaussian, its mode coincides with its mean. Thus the maximum posterior weight vector is simply given by wMAP = mN. If we consider an inﬁnitely broad prior S0 = α−1I with α → 0, the mean mN of the posterior distribution reduces to the maximum likelihood value wML given by (3.15). Similarly, if N = 0, then the posterior distribution reverts to the prior. Furthermore, if data points arrive sequentially, then the posterior distribution at any stage acts as the prior distribution for the subsequent data point, such that the new

Exercise 3.8 posterior distribution is again given by (3.49).

For the remainder of this chapter, we shall consider a particular form of Gaussian prior in order to simplify the treatment. Speciﬁcally, we consider a zero-mean isotropic Gaussian governed by a single precision parameter α so that

p(w|α) = N(w|0,α−1I) (3.52) and the corresponding posterior distribution over w is then given by (3.49) with

mN = βSNΦTt (3.53) S−1

N = αI + βΦTΦ. (3.54)

The log of the posterior distribution is given by the sum of the log likelihood and the log of the prior and, as a function of w, takes the form

�N

α 2

β 2

{tn − wTφ(xn)}2 −

wTw + const. (3.55)

lnp(w|t) = −

n=1

Maximization of this posterior distribution with respect to w is therefore equivalent to the minimization of the sum-of-squares error function with the addition of a quadratic regularization term, corresponding to (3.27) with λ = α/β.

We can illustrate Bayesian learning in a linear basis function model, as well as the sequential update of a posterior distribution, using a simple example involving straight-line ﬁtting. Consider a single input variable x, a single target variable t and
