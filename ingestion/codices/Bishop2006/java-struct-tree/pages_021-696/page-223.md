[Page 223]

2 classes) or softmax (K � 2 classes) activation functions. These are particular cases of a more general result obtained by assuming that the class-conditional densities p(x|Ck) are members of the exponential family of distributions.

Using the form (2.194) for members of the exponential family, we see that the distribution of x can be written in the form

�

�

p(x|λk) = h(x)g(λk)exp

λTku(x)

. (4.83)

We now restrict attention to the subclass of such distributions for which u(x) = x. Then we make use of (2.236) to introduce a scaling parameter s, so that we obtain the restricted set of exponential family class-conditional densities of the form

h�

x�g(λk)exp�

λTkx�. (4.84)

1 s

1 s

1 s

p(x|λk,s) =

Note that we are allowing each class to have its own parameter vector λk but we are assuming that the classes share the same scale parameter s.

For the two-class problem, we substitute this expression for the class-conditional densities into (4.58) and we see that the posterior class probability is again given by a logistic sigmoid acting on a linear function a(x) which is given by

a(x) = (λ1 − λ2)Tx + lng(λ1) − lng(λ2) + lnp(C1) − lnp(C2). (4.85)

Similarly, for the K-class problem, we substitute the class-conditional density expression into (4.63) to give

ak(x) = λTkx + lng(λk) + lnp(Ck) (4.86) and so again is a linear function of x.

4.3. Probabilistic Discriminative Models

For the two-class classiﬁcation problem, we have seen that the posterior probability of class C1 can be written as a logistic sigmoid acting on a linear function of x, for a wide choice of class-conditional distributions p(x|Ck). Similarly, for the multiclass case, the posterior probability of class Ck is given by a softmax transformation of a linear function of x. For speciﬁc choices of the class-conditional densities p(x|Ck), we have used maximum likelihood to determine the parameters of the densities as well as the class priors p(Ck) and then used Bayes’ theorem to ﬁnd the posterior class probabilities.

However, an alternative approach is to use the functional form of the generalized linear model explicitly and to determine its parameters directly by using maximum likelihood. We shall see that there is an efﬁcient algorithm ﬁnding such solutions known as iterative reweighted least squares, or IRLS.

The indirect approach to ﬁnding the parameters of a generalized linear model, by ﬁtting class-conditional densities and class priors separately and then applying
