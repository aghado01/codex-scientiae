[Page 225]

basis functions is typically set to a constant, say φ0(x) = 1, so that the corresponding parameter w0 plays the role of a bias. For the remainder of this chapter, we shall include a ﬁxed basis function transformation φ(x), as this will highlight some useful similarities to the regression models discussed in Chapter 3.

For many problems of practical interest, there is signiﬁcant overlap between the class-conditional densities p(x|Ck). This corresponds to posterior probabilities p(Ck|x), which, for at least some values of x, are not 0 or 1. In such cases, the optimal solution is obtained by modelling the posterior probabilities accurately and then applying standard decision theory, as discussed in Chapter 1. Note that nonlinear transformations φ(x) cannot remove such class overlap. Indeed, they can increase the level of overlap, or create overlap where none existed in the original observation space. However, suitable choices of nonlinearity can make the process of modelling the posterior probabilities easier.

- Section 3.6 Such ﬁxed basis function models have important limitations, and these will be resolved in later chapters by allowing the basis functions themselves to adapt to the data. Notwithstanding these limitations, models with ﬁxed nonlinear basis functions play an important role in applications, and a discussion of such models will introduce many of the key concepts needed for an understanding of their more complex counterparts.


###### 4.3.2 Logistic regression

We begin our treatment of generalized linear models by considering the problem of two-class classiﬁcation. In our discussion of generative approaches in Section 4.2, we saw that under rather general assumptions, the posterior probability of class C1 can be written as a logistic sigmoid acting on a linear function of the feature vector φ so that

p(C1|φ) = y(φ) = σ wTφ (4.87)

with p(C2|φ) = 1 − p(C1|φ). Here σ(·) is the logistic sigmoid function deﬁned by (4.59). In the terminology of statistics, this model is known as logistic regression, although it should be emphasized that this is a model for classiﬁcation rather than regression.

For an M-dimensional feature space φ, this model has M adjustable parameters. By contrast, if we had ﬁtted Gaussian class conditional densities using maximum likelihood, we would have used 2M parameters for the means and M(M + 1)/2 parameters for the (shared) covariance matrix. Together with the class prior p(C1), this gives a total of M(M +5)/2+1 parameters, which grows quadratically with M, in contrast to the linear dependence on M of the number of parameters in logistic regression. For large values of M, there is a clear advantage in working with the logistic regression model directly.

We now use maximum likelihood to determine the parameters of the logistic regression model. To do this, we shall make use of the derivative of the logistic sigmoid function, which can conveniently be expressed in terms of the sigmoid function

- Exercise 4.12 itself dσ


= σ(1 − σ). (4.88)

da
