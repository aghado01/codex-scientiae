[Page 165]

###### q = 0.5 q = 1 q = 2 q = 4

Figure 3.3 Contours of the regularization term in (3.29) for various values of the parameter q.

zero. It has the advantage that the error function remains a quadratic function of w, and so its exact minimizer can be found in closed form. Speciﬁcally, setting the gradient of (3.27) with respect to w to zero, and solving for w as before, we obtain

w = λI + ΦTΦ −1 ΦTt. (3.28) This represents a simple extension of the least-squares solution (3.15).

A more general regularizer is sometimes used, for which the regularized error takes the form

N

M

- 1

- 2


λ 2

{tn − wTφ(xn)}2 +

|wj|q (3.29)

n=1

j=1

where q = 2 corresponds to the quadratic regularizer (3.27). Figure 3.3 shows contours of the regularization function for different values of q.

The case of q = 1 is know as the lasso in the statistics literature (Tibshirani, 1996). It has the property that if λ is sufﬁciently large, some of the coefﬁcients wj are driven to zero, leading to a sparse model in which the corresponding basis functions play no role. To see this, we ﬁrst note that minimizing (3.29) is equivalent

- Exercise 3.5 to minimizing the unregularized sum-of-squares error (3.12) subject to the constraint


###### M

|wj|q η (3.30)

j=1

for an appropriate value of the parameter η, where the two approaches can be related

Appendix E using Lagrange multipliers. The origin of the sparsity can be seen from Figure 3.4, which shows that the minimum of the error function, subject to the constraint (3.30). As λ is increased, so an increasing number of parameters are driven to zero.

Regularization allows complex models to be trained on data sets of limited size without severe over-ﬁtting, essentially by limiting the effective model complexity. However, the problem of determining the optimal model complexity is then shifted from one of ﬁnding the appropriate number of basis functions to one of determining a suitable value of the regularization coefﬁcient λ. We shall return to the issue of model complexity later in this chapter.
