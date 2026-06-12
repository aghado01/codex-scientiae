## 6. Kernel Methods

### 6.4 Gaussian Processes

#### 6.4.1 Linear regression revisited

In order to motivate the Gaussian process viewpoint, let us return to the linear regression example and re-derive the predictive distribution by working in terms of distributions over functions y(x,w). This will provide a speciﬁc example of a Gaussian process.

Consider a model deﬁned in terms of a linear combination of M ﬁxed basis functions given by the elements of the vector φ(x) so that

y(x) = wTφ(x) (6.49)

where x is the input vector and w is the M-dimensional weight vector. Now consider a prior distribution over w given by an isotropic Gaussian of the form

p(w) = N(w|0,α−1I) (6.50)

governed by the hyperparameter α, which represents the precision (inverse variance) of the distribution. For any given value of w, the deﬁnition (6.49) deﬁnes a particular function of x. The probability distribution over w deﬁned by (6.50) therefore induces a probability distribution over functions y(x). In practice, we wish to evaluate this function at speciﬁc values of x, for example at the training data points

x1,...,xN. We are therefore interested in the joint distribution of the function values y(x1),...,y(xN), which we denote by the vector y with elements yn = y(xn) for n = 1,...,N. From (6.49), this vector is given by

y = Φw (6.51)

where Φ is the design matrix with elements Φnk = φk(xn). We can ﬁnd the probability distribution of y as follows. First of all we note that y is a linear combination of Gaussian distributed variables given by the elements of w and hence is itself Gaus-

Exercise 2.31 sian. We therefore need only to ﬁnd its mean and covariance, which are given from

(6.50) by

E[y] = ΦE[w] = 0 (6.52) cov[y] = E yyT = ΦE wwT ΦT =

1 α

ΦΦT = K (6.53) where K is the Gram matrix with elements

1 α

φ(xn)Tφ(xm) (6.54) and k(x,x ) is the kernel function.

Knm = k(xn,xm) =

This model provides us with a particular example of a Gaussian process. In general, a Gaussian process is deﬁned as a probability distribution over functions y(x) such that the set of values of y(x) evaluated at an arbitrary set of points x1,...,xN jointly have a Gaussian distribution. In cases where the input vector x is two dimensional, this may also be known as a Gaussian random ﬁeld. More generally, a stochastic process y(x) is speciﬁed by giving the joint probability distribution for any ﬁnite set of values y(x1),...,y(xN) in a consistent manner.

A key point about Gaussian stochastic processes is that the joint distribution over N variables y1,...,yN is speciﬁed completely by the second-order statistics, namely the mean and the covariance. In most applications, we will not have any prior knowledge about the mean of y(x) and so by symmetry we take it to be zero. This is equivalent to choosing the mean of the prior over weight values p(w|α) to be zero in the basis function viewpoint. The speciﬁcation of the Gaussian process is then completed by giving the covariance of y(x) evaluated at any two values of x, which is given by the kernel function

E[y(xn)y(xm)] = k(xn,xm). (6.55)

For the speciﬁc case of a Gaussian process deﬁned by the linear regression model (6.49) with a weight prior (6.50), the kernel function is given by (6.54).

We can also deﬁne the kernel function directly, rather than indirectly through a choice of basis function. Figure 6.4 shows samples of functions drawn from Gaussian processes for two different choices of kernel function. The ﬁrst of these is a ‘Gaussian’ kernel of the form (6.23), and the second is the exponential kernel given by

k(x,x ) = exp(−θ |x − x |) (6.56) which corresponds to the Ornstein-Uhlenbeck process originally introduced by Uhlenbeck and Ornstein (1930) to describe Brownian motion.

where the covariance matrix C has elements

C(xn,xm) = k(xn,xm) + β−1δnm. (6.62)

This result reﬂects the fact that the two Gaussian sources of randomness, namely that associated with y(x) and that associated with , are independent and so their covariances simply add.

One widely used kernel function for Gaussian process regression is given by the exponential of a quadratic form, with the addition of constant and linear terms to give

θ1 2

k(xn,xm) = θ0 exp −

xn − xm 2 + θ2 + θ3xTnxm. (6.63)

Note that the term involving θ3 corresponds to a parametric model that is a linear function of the input variables. Samples from this prior are plotted for various values

of the parameters θ0,...,θ3 in Figure 6.5, and Figure 6.6 shows a set of points sampled from the joint distribution (6.60) along with the corresponding values deﬁned by (6.61).

So far, we have used the Gaussian process viewpoint to build a model of the joint distribution over sets of data points. Our goal in regression, however, is to make predictions of the target variables for new inputs, given a set of training data. Let us suppose that tN = (t1,...,tN)T, corresponding to input values x1,...,xN, comprise the observed training set, and our goal is to predict the target variable tN+1 for a new input vector xN+1. This requires that we evaluate the predictive distribution p(tN+1|tN). Note that this distribution is conditioned also on the variables x1,...,xN and xN+1. However, to keep the notation simple we will not show these conditioning variables explicitly.

To ﬁnd the conditional distribution p(tN+1|t), we begin by writing down the joint distribution p(tN+1), where tN+1 denotes the vector (t1,...,tN,tN+1)T. We then apply the results from Section 2.3.1 to obtain the required conditional distribution, as illustrated in Figure 6.7.

From (6.61), the joint distribution over t1,...,tN+1 will be given by

p(tN+1) = N(tN+1|0,CN+1) (6.64)

where CN+1 is an (N + 1) × (N + 1) covariance matrix with elements given by (6.62). Because this joint distribution is Gaussian, we can apply the results from Section 2.3.1 to ﬁnd the conditional Gaussian distribution. To do this, we partition the covariance matrix as follows

CN+1 =

CN k kT c

(6.65)

where CN is the N ×N covariance matrix with elements given by (6.62) for n,m = 1,...,N, the vector k has elements k(xn,xN+1) for n = 1,...,N, and the scalar

where we have used p(tN|aN+1,aN) = p(tN|aN). The conditional distribution p(aN+1|aN) is obtained by invoking the results (6.66) and (6.67) for Gaussian process regression, to give

p(aN+1|aN) = N(aN+1|kTC−1

N aN,c − kTC−1

N k). (6.78)

We can therefore evaluate the integral in (6.77) by ﬁnding a Laplace approximation for the posterior distribution p(aN|tN), and then using the standard result for the convolution of two Gaussian distributions.

The prior p(aN) is given by a zero-mean Gaussian process with covariance matrix CN, and the data term (assuming independence of the data points) is given by

p(tN|aN) =

N

N

σ(an)tn(1 − σ(an))1−tn =

n=1

n=1

ntnσ(−an). (6.79)

ea

We then obtain the Laplace approximation by Taylor expanding the logarithm of p(aN|tN), which up to an additive normalization constant is given by the quantity

Ψ(aN) = lnp(aN) + lnp(tN|aN)

1 2

1 2

N 2

aTNC−1

ln(2π) −

ln|CN| + tTNaN

= −

N aN −

N

ln(1 + ea

n) + const. (6.80)

−

n=1

First we need to ﬁnd the mode of the posterior distribution, and this requires that we evaluate the gradient of Ψ(aN), which is given by

∇Ψ(aN) = tN − σN − C−1

N aN (6.81)

where σN is a vector with elements σ(an). We cannot simply ﬁnd the mode by setting this gradient to zero, because σN depends nonlinearly on aN, and so we resort to an iterative scheme based on the Newton-Raphson method, which gives rise

Section 4.3.3 to an iterative reweighted least squares (IRLS) algorithm. This requires the second

derivatives of Ψ(aN), which we also require for the Laplace approximation anyway, and which are given by

∇∇Ψ(aN) = −WN − C−1

N (6.82)

where WN is a diagonal matrix with elements σ(an)(1−σ(an)), and we have used the result (4.88) for the derivative of the logistic sigmoid function. Note that these

diagonal elements lie in the range (0,1/4), and hence WN is a positive deﬁnite matrix. Because CN (and hence its inverse) is positive deﬁnite by construction, and

Exercise 6.24 because the sum of two positive deﬁnite matrices is also positive deﬁnite, we see that the Hessian matrix A = −∇∇Ψ(aN) is positive deﬁnite and so the posterior distribution p(aN|tN) is log convex and therefore has a single mode that is the global

### 6.4 Gaussian Processes

maximum. The posterior distribution is not Gaussian, however, because the Hessian is a function of aN.

Using the Newton-Raphson formula (4.92), the iterative update equation for aN Exercise 6.25 is given by

anewN = CN(I + WNCN)−1 {tN − σN + WNaN}. (6.83) These equations are iterated until they converge to the mode which we denote by a N. At the mode, the gradient ∇Ψ(aN) will vanish, and hence a N will satisfy

a N = CN(tN − σN). (6.84)

Once we have found the mode a N of the posterior, we can evaluate the Hessian matrix given by

H = −∇∇Ψ(aN) = WN + C−1

N (6.85)

where the elements of WN are evaluated using a N. This deﬁnes our Gaussian approximation to the posterior distribution p(aN|tN) given by

q(aN) = N(aN|a N,H−1). (6.86)

We can now combine this with (6.78) and hence evaluate the integral (6.77). Because this corresponds to a linear-Gaussian model, we can use the general result (2.115) to

Exercise 6.26 give

E[aN+1|tN] = kT(tN − σN) (6.87) var[aN+1|tN] = c − kT(W−1

N + CN)−1k. (6.88)

Now that we have a Gaussian distribution for p(aN+1|tN), we can approximate the integral (6.76) using the result (4.153). As with the Bayesian logistic regression model of Section 4.5, if we are only interested in the decision boundary corresponding to p(tN+1|tN) = 0.5, then we need only consider the mean and we can ignore the effect of the variance.

We also need to determine the parameters θ of the covariance function. One approach is to maximize the likelihood function given by p(tN|θ) for which we need expressions for the log likelihood and its gradient. If desired, suitable regularization terms can also be added, leading to a penalized maximum likelihood solution. The likelihood function is deﬁned by

p(tN|θ) = p(tN|aN)p(aN|θ)daN. (6.89)

This integral is analytically intractable, so again we make use of the Laplace approximation. Using the result (4.135), we obtain the following approximation for the log of the likelihood function

lnp(tN|θ) = Ψ(a N) −

1 2

ln|WN + C−1

N | +

N 2

ln(2π) (6.90)

By working directly with the covariance function we have implicitly marginalized over the distribution of weights. If the weight prior is governed by hyperparameters, then their values will determine the length scales of the distribution over functions, as can be understood by studying the examples in Figure 5.11 for the case of a ﬁnite number of hidden units. Note that we cannot marginalize out the hyperparameters analytically, and must instead resort to techniques of the kind discussed in Section 6.4.

