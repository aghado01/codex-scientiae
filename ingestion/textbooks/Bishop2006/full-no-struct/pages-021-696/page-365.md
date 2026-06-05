[Page 365]

case, because they apply to any choice for the distribution p ( x , t ) , so long as both the training and the test examples are drawn (independently) from the same distribution, and for any choice for the function f ( x ) so long as it belongs to F . In real-world applications of machine learning, we deal with distributions that have signiﬁcant regularity, for example in which large regions of input space carry the same class label. As a consequence of the lack of any assumptions about the form of the distribution, the PAC bounds are very conservative, in other words they strongly over-estimate the size of data sets required to achieve a given generalization performance. For this reason, PAC bounds have found few, if any, practical applications.

One attempt to improve the tightness of the PAC bounds is the PAC-Bayesian framework (McAllester, 2003), which considers a distribution over the space F of functions, somewhat analogous to the prior in a Bayesian treatment. This still considers any possible choice for p ( x , t ) , and so although the bounds are tighter, they are still very conservative.

# 7.2. Relevance Vector Machines

Support vector machines have been used in a variety of classiﬁcation and regression applications. Nevertheless, they suffer from a number of limitations, several of which have been highlighted already in this chapter. In particular, the outputs of an SVM represent decisions rather than posterior probabilities. Also, the SVM was originally formulated for two classes, and the extension to K > 2 classes is problematic. There is a complexity parameter C , or ν (as well as a parameter in the case of regression), that must be found using a hold-out method such as cross-validation. Finally, predictions are expressed as linear combinations of kernel functions that are centred on training data points and that are required to be positive deﬁnite.

The relevance vector machine or RVM (Tipping, 2001) is a Bayesian sparse kernel technique for regression and classiﬁcation that shares many of the characteristics of the SVM whilst avoiding its principal limitations. Additionally, it typically leads to much sparser models resulting in correspondingly faster performance on test data whilst maintaining comparable generalization error.

In contrast to the SVM we shall ﬁnd it more convenient to introduce the regression form of the RVM ﬁrst and then consider the extension to classiﬁcation tasks.

# 7.2.1 RVM for regression

The relevance vector machine for regression is a linear model of the form studied in Chapter 3 but with a modiﬁed prior that results in sparse solutions. The model deﬁnes a conditional distribution for a real-valued target variable t , given an input vector x , which takes the form

$$
p ( t | x , w , \beta ) = \mathcal { N } ( t | y ( x ) , \beta ^ { - 1 } )
$$
