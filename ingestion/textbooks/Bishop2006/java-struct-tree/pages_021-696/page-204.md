[Page 204]

Figure 4.3 Illustration of the decision regions for a multiclass linear discriminant, with the decision boundaries shown in red. If two points xA and xB both lie inside the same decision region Rk, then any point xb that lies on the line connecting these two points must also lie in Rk, and hence the decision region must be singly connected and convex.

Ri

xA

Rj

Rk

xB xˆ

where 0 � λ � 1. From the linearity of the discriminant functions, it follows that

yk(x�) = λyk(xA) + (1 − λ)yk(xB). (4.12)

Because both xA and xB lie inside Rk, it follows that yk(xA) > yj(xA), and yk(xB) > yj(xB), for all j �= k, and hence yk(x�) > yj(x�), and so x� also lies inside Rk. Thus Rk is singly connected and convex.

Note that for two classes, we can either employ the formalism discussed here,

based on two discriminant functions y1(x) and y2(x), or else use the simpler but equivalent formulation described in Section 4.1.1 based on a single discriminant function y(x).

We now explore three approaches to learning the parameters of linear discriminant functions, based on least squares, Fisher’s linear discriminant, and the perceptron algorithm.

4.1.3 Least squares for classiﬁcation

In Chapter 3, we considered models that were linear functions of the parameters, and we saw that the minimization of a sum-of-squares error function led to a simple closed-form solution for the parameter values. It is therefore tempting to see if we can apply the same formalism to classiﬁcation problems. Consider a general classiﬁcation problem with K classes, with a 1-of-K binary coding scheme for the target vector t. One justiﬁcation for using least squares in such a context is that it approximates the conditional expectation E[t|x] of the target values given the input vector. For the binary coding scheme, this conditional expectation is given by the vector of posterior class probabilities. Unfortunately, however, these probabilities are typically approximated rather poorly, indeed the approximations can have values outside the range (0,1), due to the limited ﬂexibility of a linear model as we shall see shortly.

Each class Ck is described by its own linear model so that

yk(x) = wkTx + wk0 (4.13)

where k = 1,...,K. We can conveniently group these together using vector notation so that

y(x) = W�Tx� (4.14)
