[Page 674]

model combination is to select one of the models to make the prediction, in which the choice of model is a function of the input variables. Thus different models become responsible for making predictions in different regions of input space. One widely used framework of this kind is known as a decision tree in which the selection process can be described as a sequence of binary selections corresponding to the traversal of a tree structure and is discussed in Section 14.4. In this case, the individual models are generally chosen to be very simple, and the overall ﬂexibility of the model arises from the input-dependent selection process. Decision trees can be applied to both classiﬁcation and regression problems.

One limitation of decision trees is that the division of input space is based on hard splits in which only one model is responsible for making predictions for any given value of the input variables. The decision process can be softened by moving to a probabilistic framework for combining models, as discussed in Section 14.5. For example, if we have a set of K models for a conditional distribution p ( t | x ,k ) where x is the input variable, t is the target variable, and k = 1 ,...,K indexes the model, then we can form a probabilistic mixture of the form

$$
p ( t | x ) = \sum _ { k = 1 } ^ { K } \pi _ { k } ( x ) p ( t | x , k ) \\ = \sigma ( k | x ) \, \text { represent the input dependent mixing coefficients} \, \text { such }
$$

in which π k ( x ) = p ( k | x ) represent the input-dependent mixing coefﬁcients. Such models can be viewed as mixture distributions in which the component densities, as well as the mixing coefﬁcients, are conditioned on the input variables and are known as mixtures of experts . They are closely related to the mixture density network model discussed in Section 5.6.

# 14.1. Bayesian Model Averaging

# Section 9.2

It is important to distinguish between model combination methods and Bayesian model averaging, as the two are often confused. To understand the difference, consider the example of density estimation using a mixture of Gaussians in which several Gaussian components are combined probabilistically. The model contains a binary latent variable z that indicates which component of the mixture is responsible for generating the corresponding data point. Thus the model is speciﬁed in terms of a joint distribution

$$
p ( x , z )
$$

and the corresponding density over the observed variable x is obtained by marginalizing over the latent variable

$$
p ( x ) = \sum _ { z } p ( x , z ) .
$$
