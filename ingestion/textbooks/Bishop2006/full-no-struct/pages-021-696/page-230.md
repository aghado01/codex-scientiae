[Page 230]

Exercise 4.20

We have seen that the derivative of the log likelihood function for a linear regression model with respect to the parameter vector w for a data point n took the form of the ‘error’ y n − t n times the feature vector φ n . Similarly, for the combination of logistic sigmoid activation function and cross-entropy error function (4.90), and for the softmax activation function with the multiclass cross-entropy error function (4.108), we again obtain this same simple form. This is an example of a more general result, as we shall see in Section 4.3.6.

To ﬁnd a batch algorithm, we again appeal to the Newton-Raphson update to obtain the corresponding IRLS algorithm for the multiclass problem. This requires evaluation of the Hessian matrix that comprises blocks of size M × M in which block j,k is given by

$$
\nabla _ { w _ { k } } \nabla _ { w _ { j } } E ( w _ { 1 } , \dots , w _ { K } ) = - \sum _ { n = 1 } ^ { N } y _ { n k } ( I _ { k j } - y _ { n j } ) \phi _ { n } \phi _ { n } ^ { T } . \\ \intertext { A s w i t h e t w o-class s o m b l e r g r e s } \text {As with the two-class problem the Hessian matrix for the multiclass logistic regress-}
$$

As with the two-class problem, the Hessian matrix for the multiclass logistic regression model is positive deﬁnite and so the error function again has a unique minimum. Practical details of IRLS for the multiclass case can be found in Bishop and Nabney (2008).

# 4.3.5 Probit regression

We have seen that, for a broad range of class-conditional distributions, described by the exponential family, the resulting posterior class probabilities are given by a logistic (or softmax) transformation acting on a linear function of the feature variables. However, not all choices of class-conditional density give rise to such a simple form for the posterior probabilities (for instance, if the class-conditional densities are modelled using Gaussian mixtures). This suggests that it might be worth exploring other types of discriminative probabilistic model. For the purposes of this chapter, however, we shall return to the two-class case, and again remain within the framework of generalized linear models so that

$$
p ( t = 1 | a ) = f ( a )
$$

where a = w T φ , and f ( · ) is the activation function. One way to motivate an alternative choice for the

link function is to consider a noisy threshold model, as follows. For each input φ n , we evaluate a n = w T φ n and then we set the target value according to

$$
\begin{cases} t _ { n } = 1 & \text {if } a _ { n } \geq \theta \\ t _ { n } = 0 & \text {otherwise.} \end{cases} ( 4 . 1 1 2 )
$$
