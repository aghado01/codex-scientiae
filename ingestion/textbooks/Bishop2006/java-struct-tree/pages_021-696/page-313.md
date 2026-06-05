[Page 313]

6.1. Dual Representations 293

6.1. Dual Representations

Many linear models for regression and classiﬁcation can be reformulated in terms of a dual representation in which the kernel function arises naturally. This concept will play an important role when we consider support vector machines in the next chapter. Here we consider a linear regression model whose parameters are determined by minimizing a regularized sum-of-squares error function given by

�N

1 2

�

�2

λ 2

J(w) =

wTφ(xn) − tn

+

wTw (6.2)

n=1

where λ � 0. If we set the gradient of J(w) with respect to w equal to zero, we see that the solution for w takes the form of a linear combination of the vectors φ(xn), with coefﬁcients that are functions of w, of the form

�N

�N

1 λ

�

�

w = −

wTφ(xn) − tn

φ(xn) =

anφ(xn) = ΦTa (6.3)

n=1

n=1

where Φ is the design matrix, whose nth row is given by φ(xn)T. Here the vector a = (a1,...,aN)T, and we have deﬁned

1 λ �

�

an = −

wTφ(xn) − tn

. (6.4)

Instead of working with the parameter vector w, we can now reformulate the leastsquares algorithm in terms of the parameter vector a, giving rise to a dual representation. If we substitute w = ΦTa into J(w), we obtain

J(a) =

1 2

aTΦΦTΦΦTa − aTΦΦTt +

1 2

tTt +

λ 2

aTΦΦTa (6.5)

where t = (t1,...,tN)T. We now deﬁne the Gram matrix K = ΦΦT, which is an N × N symmetric matrix with elements

Knm = φ(xn)Tφ(xm) = k(xn,xm) (6.6)

where we have introduced the kernel function k(x,x�) deﬁned by (6.1). In terms of the Gram matrix, the sum-of-squares error function can be written as

J(a) =

1 2

aTKKa − aTKt +

1 2

tTt +

λ 2

aTKa. (6.7)

Setting the gradient of J(a) with respect to a to zero, we obtain the following solution

a = (K + λIN)−1 t. (6.8)
