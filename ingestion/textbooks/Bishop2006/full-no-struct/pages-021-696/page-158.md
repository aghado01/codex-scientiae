[Page 158]

Given a training data set comprising N observations { x n } , where n = 1 ,...,N , together with corresponding target values { t n } , the goal is to predict the value of t for a new value of x . In the simplest approach, this can be done by directly constructing an appropriate function y ( x ) whose values for new inputs x constitute the predictions for the corresponding values of t . More generally, from a probabilistic perspective, we aim to model the predictive distribution p ( t | x ) because this expresses our uncertainty about the value of t for each value of x . From this conditional distribution we can make predictions of t , for any new value of x , in such a way as to minimize the expected value of a suitably chosen loss function. As discussed in Section 1.5.5, a common choice of loss function for real-valued variables is the squared loss, for which the optimal solution is given by the conditional expectation of t .

Although linear models have signiﬁcant limitations as practical techniques for pattern recognition, particularly for problems involving input spaces of high dimensionality, they have nice analytical properties and form the foundation for more sophisticated models to be discussed in later chapters.

# 3.1. Linear Basis Function Models

The simplest linear model for regression is one that involves a linear combination of the input variables

$$
y ( x , w ) = w _ { 0 } + w _ { 1 } x _ { 1 } + \dots + w _ { D } x _ { D }
$$

where x = ( x 1 ,...,x D ) T . This is often simply known as linear regression . The key property of this model is that it is a linear function of the parameters w 0 ,...,w D . It is also, however, a linear function of the input variables x i , and this imposes signiﬁcant limitations on the model. We therefore extend the class of models by considering linear combinations of ﬁxed nonlinear functions of the input variables, of the form

$$
y ( x , w ) = w _ { 0 } + \sum _ { j = 1 } ^ { M - 1 } w _ { j } \phi _ { j } ( x ) \\
$$

where φ j ( x ) are known as basis functions . By denoting the maximum value of the index j by M − 1 , the total number of parameters in this model will be M . The parameter w 0 allows for any ﬁxed offset in the data and is sometimes called

a bias parameter (not to be confused with ‘bias’ in a statistical sense). It is often convenient to deﬁne an additional dummy ‘basis function’ φ 0 ( x ) = 1 so that

$$
y ( x , w ) = \sum _ { j = 0 } ^ { M - 1 } w _ { j } \phi _ { j } ( x ) = w ^ { T } \phi ( x ) \\
$$

where w = ( w 0 , . . . , w M -1 ) T and φ = ( φ 0 , . . . , φ M -1 ) T . In many practical applications of pattern recognition, we will apply some form of fixed pre-processing, or feature extraction, to the original data variables. If the original variables comprise the vector x , then the features can be expressed in terms of the basis functions { φ j ( x ) } .
