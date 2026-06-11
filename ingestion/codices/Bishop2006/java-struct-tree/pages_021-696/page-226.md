[Page 226]

For a data set {φn,tn}, where tn ∈ {0,1} and φn = φ(xn), with n = 1,...,N, the likelihood function can be written

�N

n {1 − yn}1−tn (4.89)

p(t|w) =

yt

n

n=1

where t = (t1,...,tN)T and yn = p(C1|φn). As usual, we can deﬁne an error function by taking the negative logarithm of the likelihood, which gives the crossentropy error function in the form

�N

{tn lnyn + (1 − tn)ln(1 − yn)} (4.90)

E(w) = −lnp(t|w) = −

n=1

where yn = σ(an) and an = wTφn. Taking the gradient of the error function with Exercise 4.13 respect to w, we obtain

�N

∇E(w) =

(yn − tn)φn (4.91)

n=1

where we have made use of (4.88). We see that the factor involving the derivative of the logistic sigmoid has cancelled, leading to a simpliﬁed form for the gradient of the log likelihood. In particular, the contribution to the gradient from data point n is given by the ‘error’ yn − tn between the target value and the prediction of the model, times the basis function vector φn. Furthermore, comparison with (3.13) shows that this takes precisely the same form as the gradient of the sum-of-squares

Section 3.1.1 error function for the linear regression model.

If desired, we could make use of the result (4.91) to give a sequential algorithm in which patterns are presented one at a time, in which each of the weight vectors is updated using (3.22) in which ∇En is the nth term in (4.91).

It is worth noting that maximum likelihood can exhibit severe over-ﬁtting for data sets that are linearly separable. This arises because the maximum likelihood solution occurs when the hyperplane corresponding to σ = 0.5, equivalent to wTφ = 0, separates the two classes and the magnitude of w goes to inﬁnity. In this case, the logistic sigmoid function becomes inﬁnitely steep in feature space, corresponding to a Heaviside step function, so that every training point from each class k is assigned

Exercise 4.14 a posterior probability p(Ck|x) = 1. Furthermore, there is typically a continuum of such solutions because any separating hyperplane will give rise to the same posterior probabilities at the training data points, as will be seen later in Figure 10.13. Maximum likelihood provides no way to favour one such solution over another, and which solution is found in practice will depend on the choice of optimization algorithm and on the parameter initialization. Note that the problem will arise even if the number of data points is large compared with the number of parameters in the model, so long as the training data set is linearly separable. The singularity can be avoided by inclusion of a prior and ﬁnding a MAP solution for w, or equivalently by adding a regularization term to the error function.
