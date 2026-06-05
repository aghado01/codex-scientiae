[Page 367]

in the predictions made by the model and so are effectively pruned out, resulting in a sparse model.

Using the result (3.49) for linear regression models, we see that the posterior distribution for the weights is again Gaussian and takes the form

p(w|t,X,α,β) = N(w|m,Σ) (7.81)

where the mean and covariance are given by m = βΣΦTt (7.82) Σ =

�

�−1

A + βΦTΦ

(7.83)

where Φ is the N × M design matrix with elements Φni = φi(xn), and A = diag(αi). Note that in the speciﬁc case of the model (7.78), we have Φ = K, where K is the symmetric (N + 1) × (N + 1) kernel matrix with elements k(xn,xm).

The values of α and β are determined using type-2 maximum likelihood, also Section 3.5 known as the evidence approximation, in which we maximize the marginal likeli-

hood function obtained by integrating out the weight parameters

p(t|X,α,β) = � p(t|X,w,β)p(w|α)dw. (7.84)

Exercise 7.10 Because this represents the convolution of two Gaussians, it is readily evaluated to

give the log marginal likelihood in the form

lnp(t|X,α,β) = lnN(t|0,C)

1 2 �

�

N ln(2π) + ln|C| + tTC−1t

= −

(7.85)

where t = (t1,...,tN)T, and we have deﬁned the N × N matrix C given by

C = β−1I + ΦA−1ΦT. (7.86)

Our goal is now to maximize (7.85) with respect to the hyperparameters α and β. This requires only a small modiﬁcation to the results obtained in Section 3.5 for the evidence approximation in the linear regression model. Again, we can identify two approaches. In the ﬁrst, we simply set the required derivatives of the marginal

Exercise 7.12 likelihood to zero and obtain the following re-estimation equations

γi m2i

αinew =

(7.87)

(βnew)−1 = �t − Φm�2

(7.88)

N − �

i γi

where mi is the ith component of the posterior mean m deﬁned by (7.82). The quantity γi measures how well the corresponding parameter wi is determined by the

Section 3.5.3 data and is deﬁned by
