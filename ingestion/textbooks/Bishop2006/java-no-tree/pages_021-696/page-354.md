[Page 354]

model (7.13). The remaining data points constitute the support vectors. These have an > 0 and hence from (7.25) must satisfy

###### tny(xn) = 1 − ξn. (7.35)

If an < C, then (7.31) implies that µn > 0, which from (7.28) requires ξn = 0 and hence such points lie on the margin. Points with an = C can lie inside the margin and can either be correctly classiﬁed if ξn 1 or misclassiﬁed if ξn > 1.

To determine the parameter b in (7.1), we note that those support vectors for which 0 < an < C have ξn = 0 so that tny(xn) = 1 and hence will satisfy

amtmk(xn,xm) + b = 1. (7.36)

tn

m∈S

Again, a numerically stable solution is obtained by averaging to give

1 NM

b =

amtmk(xn,xm) (7.37)

tn −

n∈M

m∈S

where M denotes the set of indices of data points having 0 < an < C.

An alternative, equivalent formulation of the support vector machine, known as the ν-SVM, has been proposed by Sch¨olkopf et al. (2000). This involves maximizing

1 2

L(a) = −

N

n=1

subject to the constraints

###### N

anamtntmk(xn,xm) (7.38)

m=1

0 an 1/N (7.39)

N

antn = 0 (7.40)

n=1

N

an ν. (7.41)

n=1

This approach has the advantage that the parameter ν, which replaces C, can be interpreted as both an upper bound on the fraction of margin errors (points for which ξn > 0 and hence which lie on the wrong side of the margin boundary and which may or may not be misclassiﬁed) and a lower bound on the fraction of support vectors. An example of the ν-SVM applied to a synthetic data set is shown in Figure 7.4. Here Gaussian kernels of the form exp(−γ x − x 2) have been used, with γ = 0.45.

Although predictions for new inputs are made using only the support vectors, the training phase (i.e., the determination of the parameters a and b) makes use of the whole data set, and so it is important to have efﬁcient algorithms for solving
