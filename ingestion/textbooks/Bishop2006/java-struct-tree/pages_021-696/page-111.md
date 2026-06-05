[Page 111]

a linear Gaussian model (Roweis and Ghahramani, 1999), which we shall study in greater generality in Section 8.1.4. We wish to ﬁnd the marginal distribution p(y) and the conditional distribution p(x|y). This is a problem that will arise frequently in subsequent chapters, and it will prove convenient to derive the general results here.

We shall take the marginal and conditional distributions to be p(x) = N �

x|µ,Λ−1�

(2.99) p(y|x) = N �

y|Ax + b,L−1�

(2.100)

where µ, A, and b are parameters governing the means, and Λ and L are precision matrices. If x has dimensionality M and y has dimensionality D, then the matrix A has size D × M.

First we ﬁnd an expression for the joint distribution over x and y. To do this, we deﬁne

z = �

x y� (2.101)

and then consider the log of the joint distribution

lnp(z) = lnp(x) + lnp(y|x)

1 2

= −

(x − µ)TΛ(x − µ) −

1 2

(y − Ax − b)TL(y − Ax − b) + const (2.102)

where ‘const’ denotes terms independent of x and y. As before, we see that this is a quadratic function of the components of z, and hence p(z) is Gaussian distribution. To ﬁnd the precision of this Gaussian, we consider the second order terms in (2.102), which can be written as

1 2

1 2

1 2

1 2

xT(Λ + ATLA)x −

yTLy +

yTLAx +

xTATLy

−

�

x y�T �

��

x y� = −

1 2

1 2

Λ + ATLA −ATL −LA L

= −

zTRz (2.103)

and so the Gaussian distribution over z has precision (inverse covariance) matrix given by

R = �

�. (2.104)

Λ + ATLA −ATL −LA L

The covariance matrix is found by taking the inverse of the precision, which can be Exercise 2.29 done using the matrix inversion formula (2.76) to give

cov[z] = R−1 = �

�. (2.105)

Λ−1 Λ−1AT AΛ−1 L−1 + AΛ−1AT
