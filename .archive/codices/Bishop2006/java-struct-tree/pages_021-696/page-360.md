[Page 360]

Figure 7.6 Plot of an �-insensitive error function (in red) in which the error increases linearly with distance beyond the insensitive region. Also shown for comparison is the quadratic error function (in green).

E(z)

0 z

−� �

minimize a regularized error function given by

�N

1 2

λ 2�w�2. (7.50)

{yn − tn}2 +

n=1

To obtain sparse solutions, the quadratic error function is replaced by an �-insensitive error function (Vapnik, 1995), which gives zero error if the absolute difference between the prediction y(x) and the target t is less than � where � > 0. A simple example of an �-insensitive error function, having a linear cost associated with errors outside the insensitive region, is given by

E�(y(x) − t) = �

0, if |y(x) − t| < �; |y(x) − t| − �, otherwise

(7.51)

and is illustrated in Figure 7.6. We therefore minimize a regularized error function given by

�N

1 2�w�2 (7.52)

E�(y(xn) − tn) +

C

n=1

where y(x) is given by (7.1). By convention the (inverse) regularization parameter, denoted C, appears in front of the error term.

As before, we can re-express the optimization problem by introducing slack variables. For each data point xn, we now need two slack variables ξn � 0 and �ξn � 0, where ξn > 0 corresponds to a point for which tn > y(xn) + �, and �ξn > 0 corresponds to a point for which tn < y(xn) − �, as illustrated in Figure 7.7.

The condition for a target point to lie inside the �-tube is that yn − � � tn � yn+�, where yn = y(xn). Introducing the slack variables allows points to lie outside the tube provided the slack variables are nonzero, and the corresponding conditions are

tn � y(xn) + � + ξn (7.53) tn � y(xn) − � −�ξn. (7.54)
