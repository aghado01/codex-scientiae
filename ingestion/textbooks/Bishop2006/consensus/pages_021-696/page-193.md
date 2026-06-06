[Page 193]

mapping from input variables to targets. In the next chapter, we shall study an analogous class of models for classiﬁcation.

It might appear, therefore, that such linear models constitute a general purpose framework for solving problems in pattern recognition. Unfortunately, there are some signiﬁcant shortcomings with linear models, which will cause us to turn in later chapters to more complex models such as support vector machines and neural networks.

The difﬁculty stems from the assumption that the basis functions φj(x) are ﬁxed before the training data set is observed and is a manifestation of the curse of dimensionality discussed in Section 1.4. As a consequence, the number of basis functions needs to grow rapidly, often exponentially, with the dimensionality D of the input space.

Fortunately, there are two properties of real data sets that we can exploit to help alleviate this problem. First of all, the data vectors {xn} typically lie close to a nonlinear manifold whose intrinsic dimensionality is smaller than that of the input space as a result of strong correlations between the input variables. We will see an example of this when we consider images of handwritten digits in Chapter 12. If we are using localized basis functions, we can arrange that they are scattered in input space only in regions containing data. This approach is used in radial basis function networks and also in support vector and relevance vector machines. Neural network models, which use adaptive basis functions having sigmoidal nonlinearities, can adapt the parameters so that the regions of input space over which the basis functions vary corresponds to the data manifold. The second property is that target variables may have signiﬁcant dependence on only a small number of possible directions within the data manifold. Neural networks can exploit this property by choosing the directions in input space to which the basis functions respond.

###### Exercises

- 3.1 ( ) www Show that the ‘tanh’ function and the logistic sigmoid function (3.6) are related by


tanh(a) = 2σ(2a) − 1. (3.100)

Hence show that a general linear combination of logistic sigmoid functions of the form

M

x − µj s

y(x,w) = w0 +

(3.101)

wjσ

j=1

is equivalent to a linear combination of ‘tanh’ functions of the form

M

y(x,u) = u0 +

uj tanh

j=1

x − µj s

(3.102)

and ﬁnd expressions to relate the new parameters {u1,...,uM} to the original parameters {w1,...,wM}.
