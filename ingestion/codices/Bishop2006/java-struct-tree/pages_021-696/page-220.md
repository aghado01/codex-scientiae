[Page 220]

2.5

2

1.5

1

0.5

0

−0.5

−1

−1.5

−2

−2.5

−2 −1 0 1 2

![image 69](../../../../../images/imageFile69.png)

![image 70](../../../../../images/imageFile70.png)

Figure 4.11 The left-hand plot shows the class-conditional densities for three classes each having a Gaussian distribution, coloured red, green, and blue, in which the red and green classes have the same covariance matrix. The right-hand plot shows the corresponding posterior probabilities, in which the RGB colour vector represents the posterior probabilities for the respective three classes. The decision boundaries are also shown. Notice that the boundary between the red and green classes, which have the same covariance matrix, is linear, whereas those between the other pairs of classes are quadratic.

4.2.2 Maximum likelihood solution

Once we have speciﬁed a parametric functional form for the class-conditional densities p(x|Ck), we can then determine the values of the parameters, together with the prior class probabilities p(Ck), using maximum likelihood. This requires a data set comprising observations of x along with their corresponding class labels.

Consider ﬁrst the case of two classes, each having a Gaussian class-conditional density with a shared covariance matrix, and suppose we have a data set {xn,tn} where n = 1,...,N. Here tn = 1 denotes class C1 and tn = 0 denotes class C2. We denote the prior class probability p(C1) = π, so that p(C2) = 1 − π. For a data point xn from class C1, we have tn = 1 and hence

p(xn,C1) = p(C1)p(xn|C1) = πN(xn|µ1,Σ). Similarly for class C2, we have tn = 0 and hence

p(xn,C2) = p(C2)p(xn|C2) = (1 − π)N(xn|µ2,Σ). Thus the likelihood function is given by

�N

[πN(xn|µ1,Σ)]tn [(1 − π)N(xn|µ2,Σ)]1−tn (4.71)

p(t|π,µ1,µ2,Σ) =

n=1

where t = (t1,...,tN)T. As usual, it is convenient to maximize the log of the likelihood function. Consider ﬁrst the maximization with respect to π. The terms in
