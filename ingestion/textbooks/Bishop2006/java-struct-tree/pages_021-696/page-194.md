[Page 194]

3.2 (��) Show that the matrix

Φ(ΦTΦ)−1ΦT (3.103)

takes any vector v and projects it onto the space spanned by the columns of Φ. Use this result to show that the least-squares solution (3.15) corresponds to an orthogonal projection of the vector t onto the manifold S as shown in Figure 3.2.

3.3 (�) Consider a data set in which each data point tn is associated with a weighting

factor rn > 0, so that the sum-of-squares error function becomes

�N

1 2

�

�2

ED(w) =

tn − wTφ(xn)

. (3.104)

rn

n=1

Find an expression for the solution w� that minimizes this error function. Give two alternative interpretations of the weighted sum-of-squares error function in terms of (i) data dependent noise variance and (ii) replicated data points.

3.4 (�) www Consider a linear model of the form

�D

y(x,w) = w0 +

wixi (3.105)

i=1

together with a sum-of-squares error function of the form

�N

1 2

{y(xn,w) − tn}2 . (3.106)

ED(w) =

n=1

Now suppose that Gaussian noise �i with zero mean and variance σ2 is added independently to each of the input variables xi. By making use of E[�i] = 0 and E[�i�j] = δijσ2, show that minimizing ED averaged over the noise distribution is equivalent to minimizing the sum-of-squares error for noise-free input variables with the addition of a weight-decay regularization term, in which the bias parameter w0 is omitted from the regularizer.

3.5 (�) www Using the technique of Lagrange multipliers, discussed in Appendix E, show that minimization of the regularized error function (3.29) is equivalent to minimizing the unregularized sum-of-squares error (3.12) subject to the constraint (3.30). Discuss the relationship between the parameters η and λ.

3.6 (�) www Consider a linear basis function regression model for a multivariate

target variable t having a Gaussian distribution of the form

p(t|W,Σ) = N(t|y(x,W),Σ) (3.107) where

y(x,W) = WTφ(x) (3.108)
