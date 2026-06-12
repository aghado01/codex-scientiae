[Page 51]

In the curve ﬁtting problem, we are given the training data x and t, along with a new test point x, and our goal is to predict the value of t. We therefore wish to evaluate the predictive distribution p(t|x,x,t). Here we shall assume that the parameters α and β are ﬁxed and known in advance (in later chapters we shall discuss how such parameters can be inferred from data in a Bayesian setting).

A Bayesian treatment simply corresponds to a consistent application of the sum and product rules of probability, which allow the predictive distribution to be written in the form

###### p(t|x,x,t) = p(t|x,w)p(w|x,t)dw. (1.68)

Here p(t|x,w) is given by (1.60), and we have omitted the dependence on α and β to simplify the notation. Here p(w|x,t) is the posterior distribution over parameters, and can be found by normalizing the right-hand side of (1.66). We shall see in Section 3.3 that, for problems such as the curve-ﬁtting example, this posterior distribution is a Gaussian and can be evaluated analytically. Similarly, the integration in (1.68) can also be performed analytically with the result that the predictive distribution is given by a Gaussian of the form

p(t|x,x,t) = N t|m(x),s2(x) (1.69) where the mean and variance are given by

N

φ(xn)tn (1.70)

m(x) = βφ(x)TS

n=1

s2(x) = β−1 + φ(x)TSφ(x). (1.71) Here the matrix S is given by

S−1 = αI + β

N

φ(xn)φ(x)T (1.72)

n=1

where I is the unit matrix, and we have deﬁned the vector φ(x) with elements φi(x) = xi for i = 0,...,M.

We see that the variance, as well as the mean, of the predictive distribution in (1.69) is dependent on x. The ﬁrst term in (1.71) represents the uncertainty in the predicted value of t due to the noise on the target variables and was expressed already in the maximum likelihood predictive distribution (1.64) through βML−1. However, the second term arises from the uncertainty in the parameters w and is a consequence of the Bayesian treatment. The predictive distribution for the synthetic sinusoidal regression problem is illustrated in Figure 1.17.
