[Page 230]

�

k tnk = 1. Once again, we see the same form arising for the gradient as was found for the sum-of-squares error function with the linear model and the cross-entropy error for the logistic regression model, namely the product of the error (ynj − tnj) times the basis function φn. Again, we could use this to formulate a sequential algorithm in which patterns are presented one at a time, in which each of the weight vectors is updated using (3.22).

where we have made use of

We have seen that the derivative of the log likelihood function for a linear regression model with respect to the parameter vector w for a data point n took the form of the ‘error’ yn − tn times the feature vector φn. Similarly, for the combination of logistic sigmoid activation function and cross-entropy error function (4.90), and for the softmax activation function with the multiclass cross-entropy error function (4.108), we again obtain this same simple form. This is an example of a more general result, as we shall see in Section 4.3.6.

To ﬁnd a batch algorithm, we again appeal to the Newton-Raphson update to obtain the corresponding IRLS algorithm for the multiclass problem. This requires evaluation of the Hessian matrix that comprises blocks of size M × M in which block j,k is given by

�N

E(w1,...,wK) = −

ynk(Ikj − ynj)φnφTn. (4.110)

∇wk∇wj

n=1

As with the two-class problem, the Hessian matrix for the multiclass logistic regresExercise 4.20 sion model is positive deﬁnite and so the error function again has a unique minimum. Practical details of IRLS for the multiclass case can be found in Bishop and Nabney

(2008).

4.3.5 Probit regression

We have seen that, for a broad range of class-conditional distributions, described by the exponential family, the resulting posterior class probabilities are given by a logistic (or softmax) transformation acting on a linear function of the feature variables. However, not all choices of class-conditional density give rise to such a simple form for the posterior probabilities (for instance, if the class-conditional densities are modelled using Gaussian mixtures). This suggests that it might be worth exploring other types of discriminative probabilistic model. For the purposes of this chapter, however, we shall return to the two-class case, and again remain within the framework of generalized linear models so that

p(t = 1|a) = f(a) (4.111) where a = wTφ, and f(·) is the activation function.

One way to motivate an alternative choice for the link function is to consider a

noisy threshold model, as follows. For each input φn, we evaluate an = wTφn and then we set the target value according to

�

tn = 1 if an � θ tn = 0 otherwise.

(4.112)
