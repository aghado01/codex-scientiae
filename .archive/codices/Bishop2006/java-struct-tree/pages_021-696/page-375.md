[Page 375]

mation, we have

p(t|α) = � p(t|w)p(w|α)dw

� p(t|w�)p(w�|α)(2π)M/2|Σ|1/2. (7.114)

If we substitute for p(t|w�) and p(w�|α) and then set the derivative of the marginal Exercise 7.19 likelihood with respect to αi equal to zero, we obtain

1 2αi −

1 2

(wi�)2 +

−

1 2

Σii = 0. (7.115)

Deﬁning γi = 1 − αiΣii and rearranging then gives

γi (wi�)2

αinew =

(7.116)

which is identical to the re-estimation formula (7.87) obtained for the regression RVM.

If we deﬁne

�t = Φw� + B−1(t − y) (7.117) we can write the approximate log marginal likelihood in the form

1 2 �N ln(2π) + ln|C| + (�t)TC−1�t� (7.118)

lnp(t|α,β) = −

where

C = B + ΦAΦT. (7.119)

This takes the same form as (7.85) in the regression case, and so we can apply the same analysis of sparsity and obtain the same fast learning algorithm in which we fully optimize a single hyperparameter αi at each step.

Figure 7.12 shows the relevance vector machine applied to a synthetic classiﬁ-

Appendix A cation data set. We see that the relevance vectors tend not to lie in the region of the decision boundary, in contrast to the support vector machine. This is consistent with our earlier discussion of sparsity in the RVM, because a basis function φi(x) centred on a data point near the boundary will have a vector ϕi that is poorly aligned with the training data vector t.

One of the potential advantages of the relevance vector machine compared with the SVM is that it makes probabilistic predictions. For example, this allows the RVM to be used to help construct an emission density in a nonlinear extension of the linear

Section 13.3 dynamical system for tracking faces in video sequences (Williams et al., 2005).

So far, we have considered the RVM for binary classiﬁcation problems. For K > 2 classes, we again make use of the probabilistic approach in Section 4.3.4 in which there are K linear models of the form

ak = wkTx (7.120)
