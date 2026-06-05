[Page 695]

###### Exercises 675

- 14.6 ( ) www By differentiating the error function (14.23) with respect to αm, show that the parameters αm in the AdaBoost algorithm are updated using (14.17) in which m is deﬁned by (14.16).

- 14.7 ( ) By making a variational minimization of the expected exponential error function given by (14.27) with respect to all possible functions y(x), show that the minimizing function is given by (14.28).
- 14.8 ( ) Show that the exponential error function (14.20), which is minimized by the AdaBoost algorithm, does not correspond to the log likelihood of any well-behaved probabilistic model. This can be done by showing that the corresponding conditional distribution p(t|x) cannot be correctly normalized.
- 14.9 ( ) www Show that the sequential minimization of the sum-of-squares error function for an additive model of the form (14.21) in the style of boosting simply involves

ﬁtting each new base classiﬁer to the residual errors tn−fm−1(xn) from the previous model.

- 14.10 ( ) Verify that if we minimize the sum-of-squares error between a set of training values {tn} and a single predictive value t, then the optimal solution for t is given by the mean of the {tn}.
- 14.11 ( ) Consider a data set comprising 400 data points from class C1 and 400 data points from class C2. Suppose that a tree model A splits these into (300,100) at the ﬁrst leaf node and (100,300) at the second leaf node, where (n,m) denotes that

n points are assigned to C1 and m points are assigned to C2. Similarly, suppose that a second tree model B splits them into (200,400) and (200,0). Evaluate the misclassiﬁcation rates for the two trees and hence show that they are equal. Similarly, evaluate the cross-entropy (14.32) and Gini index (14.33) for the two trees and show that they are both lower for tree B than for tree A.

- 14.12 ( ) Extend the results of Section 14.5.1 for a mixture of linear regression models to the case of multiple target values described by a vector t. To do this, make use of the results of Section 3.1.5.
- 14.13 ( ) www Verify that the complete-data log likelihood function for the mixture of linear regression models is given by (14.36).

- 14.14 ( ) Use the technique of Lagrange multipliers (Appendix E) to show that the M-step re-estimation equation for the mixing coefﬁcients in the mixture of linear regression models trained by maximum likelihood EM is given by (14.38).
- 14.15 ( ) www We have already noted that if we use a squared loss function in a regression problem, the corresponding optimal prediction of the target variable for a new input vector is given by the conditional mean of the predictive distribution. Show that the conditional mean for the mixture of linear regression models discussed in Section 14.5.1 is given by a linear combination of the means of each component distribution. Note that if the conditional distribution of the target data is multimodal, the conditional mean can give poor predictions.
