[Page 219]

![image 65](../../../../../images/imageFile65.png)

![image 66](../../../../../images/imageFile66.png)

![image 67](../../../../../images/imageFile67.png)

![image 68](../../../../../images/imageFile68.png)

Figure 4.10 The left-hand plot shows the class-conditional densities for two classes, denoted red and blue. On the right is the corresponding posterior probability p(C1|x), which is given by a logistic sigmoid of a linear function of x. The surface in the right-hand plot is coloured using a proportion of red ink given by p(C1|x) and a proportion of blue ink given by p(C2|x) = 1 − p(C1|x).

decision boundaries correspond to surfaces along which the posterior probabilities p(Ck|x) are constant and so will be given by linear functions of x, and therefore the decision boundaries are linear in input space. The prior probabilities p(Ck) enter only through the bias parameter w0 so that changes in the priors have the effect of making parallel shifts of the decision boundary and more generally of the parallel contours of constant posterior probability.

For the general case of K classes we have, from (4.62) and (4.63),

ak(x) = wkTx + wk0 (4.68) where we have deﬁned

wk = Σ−1µk (4.69) wk0 = −

1 2

µTkΣ−1µk + lnp(Ck). (4.70)

We see that the ak(x) are again linear functions of x as a consequence of the cancellation of the quadratic terms due to the shared covariances. The resulting decision boundaries, corresponding to the minimum misclassiﬁcation rate, will occur when two of the posterior probabilities (the two largest) are equal, and so will be deﬁned by linear functions of x, and so again we have a generalized linear model.

If we relax the assumption of a shared covariance matrix and allow each classconditional density p(x|Ck) to have its own covariance matrix Σk, then the earlier cancellations will no longer occur, and we will obtain quadratic functions of x, giving rise to a quadratic discriminant. The linear and quadratic decision boundaries are illustrated in Figure 4.11.
