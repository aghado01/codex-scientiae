[Page 352]

Figure 7.3 Illustration of the slack variables ξn 0. Data points with circles around them are support vectors.

y = −1

y = 0

y = 1

ξ > 1

ξ < 1

ξ = 0

ξ = 0

with ξn > 1 will be misclassiﬁed. The exact classiﬁcation constraints (7.5) are then replaced with

###### tny(xn) 1 − ξn, n = 1,...,N (7.20)

in which the slack variables are constrained to satisfy ξn 0. Data points for which ξn = 0 are correctly classiﬁed and are either on the margin or on the correct side of the margin. Points for which 0 < ξn 1 lie inside the margin, but on the correct side of the decision boundary, and those data points for which ξn > 1 lie on the wrong side of the decision boundary and are misclassiﬁed, as illustrated in Figure 7.3. This is sometimes described as relaxing the hard margin constraint to give a soft margin and allows some of the training set data points to be misclassiﬁed. Note that while slack variables allow for overlapping class distributions, this framework is still sensitive to outliers because the penalty for misclassiﬁcation increases linearly with ξ.

Our goal is now to maximize the margin while softly penalizing points that lie on the wrong side of the margin boundary. We therefore minimize

N

1 2

ξn +

C

n=1

w 2 (7.21)

where the parameter C > 0 controls the trade-off between the slack variable penalty and the margin. Because any point that is misclassiﬁed has ξn > 1, it follows that

n ξn is an upper bound on the number of misclassiﬁed points. The parameter C is therefore analogous to (the inverse of) a regularization coefﬁcient because it controls the trade-off between minimizing training errors and controlling model complexity. In the limit C → ∞, we will recover the earlier support vector machine for separable data.

We now wish to minimize (7.21) subject to the constraints (7.20) together with ξn 0. The corresponding Lagrangian is given by

1 2

L(w,b,a) =

N

w 2+C

n=1

N

ξn−

n=1

N

an {tny(xn) − 1 + ξn}−

n=1

µnξn (7.22)
