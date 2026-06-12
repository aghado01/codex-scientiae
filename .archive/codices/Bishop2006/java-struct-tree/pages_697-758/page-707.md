[Page 707]

B. PROBABILITY DISTRIBUTIONS 687

![image 275](../../../../../images/imageFile275.png)

![image 276](../../../../../images/imageFile276.png)

![image 277](../../../../../images/imageFile277.png)

![image 278](../../../../../images/imageFile278.png)

Dirichlet

![image 279](../../../../../images/imageFile279.png)

The Dirichlet is a multivariate distribution over K random variables 0 � µk � 1, where k = 1,...,K, subject to the constraints

�K

0 � µk � 1,

µk = 1. (B.15)

k=1

Denoting µ = (µ1,...,µK)T and α = (α1,...,αK)T, we have

�K

k−1

µα

Dir(µ|α) = C(α)

k (B.16)

k=1

αk α�

E[µk] =

(B.17)

![image 280](../../../../../images/imageFile280.png)

αk(α� − αk) α�2(α� + 1)

var[µk] =

(B.18)

![image 281](../../../../../images/imageFile281.png)

αjαk α�2(α� + 1)

cov[µjµk] = −

(B.19)

![image 282](../../../../../images/imageFile282.png)

αk − 1 α� − K

mode[µk] =

(B.20) E[lnµk] = ψ(αk) − ψ(α�) (B.21)

![image 283](../../../../../images/imageFile283.png)

�K

H[µ] = −

(αk − 1){ψ(αk) − ψ(α�)} − lnC(α) (B.22)

k=1

where

Γ(α�) Γ(α1) ···Γ(αK)

C(α) =

(B.23) and

![image 284](../../../../../images/imageFile284.png)

�K

α� =

αk. (B.24)

k=1

Here

d da

ψ(a) ≡

lnΓ(a) (B.25)

![image 285](../../../../../images/imageFile285.png)

is known as the digamma function (Abramowitz and Stegun, 1965). The parameters αk are subject to the constraint αk > 0 in order to ensure that the distribution can be normalized.

The Dirichlet forms the conjugate prior for the multinomial distribution and represents a generalization of the beta distribution. In this case, the parameters αk can be interpreted as effective numbers of observations of the corresponding values of the K-dimensional binary observation vector x. As with the beta distribution, the Dirichlet has ﬁnite density everywhere provided αk � 1 for all k.
