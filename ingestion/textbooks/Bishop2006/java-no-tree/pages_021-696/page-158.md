[Page 158]

Given a training data set comprising N observations {xn}, where n = 1,...,N, together with corresponding target values {tn}, the goal is to predict the value of t for a new value of x. In the simplest approach, this can be done by directly constructing an appropriate function y(x) whose values for new inputs x constitute the predictions for the corresponding values of t. More generally, from a probabilistic perspective, we aim to model the predictive distribution p(t|x) because this expresses our uncertainty about the value of t for each value of x. From this conditional distribution we can make predictions of t, for any new value of x, in such a way as to minimize the expected value of a suitably chosen loss function. As discussed in Section 1.5.5, a common choice of loss function for real-valued variables is the squared loss, for which the optimal solution is given by the conditional expectation of t.

Although linear models have signiﬁcant limitations as practical techniques for pattern recognition, particularly for problems involving input spaces of high dimensionality, they have nice analytical properties and form the foundation for more sophisticated models to be discussed in later chapters.

###### 3.1. Linear Basis Function Models

The simplest linear model for regression is one that involves a linear combination of the input variables

###### y(x,w) = w0 + w1x1 + ... + wDxD (3.1)

where x = (x1,...,xD)T. This is often simply known as linear regression. The key property of this model is that it is a linear function of the parameters w0,...,wD. It is also, however, a linear function of the input variables xi, and this imposes signiﬁcant limitations on the model. We therefore extend the class of models by considering linear combinations of ﬁxed nonlinear functions of the input variables, of the form

y(x,w) = w0 +

M−1

wjφj(x) (3.2)

j=1

where φj(x) are known as basis functions. By denoting the maximum value of the index j by M − 1, the total number of parameters in this model will be M.

The parameter w0 allows for any ﬁxed offset in the data and is sometimes called a bias parameter (not to be confused with ‘bias’ in a statistical sense). It is often convenient to deﬁne an additional dummy ‘basis function’ φ0(x) = 1 so that

y(x,w) =

M−1

wjφj(x) = wTφ(x) (3.3)

j=0

where w = (w0,...,wM−1)T and φ = (φ0,...,φM−1)T. In many practical applications of pattern recognition, we will apply some form of ﬁxed pre-processing,
