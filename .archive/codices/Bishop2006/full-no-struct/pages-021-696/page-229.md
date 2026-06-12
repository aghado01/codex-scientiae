[Page 229]

# Section 4.2

# Exercise 4.17

Exercise 4.18

# 4.3.4 Multiclass logistic regression

In our discussion of generative models for multiclass classiﬁcation, we have seen that for a large class of distributions, the posterior probabilities are given by a softmax transformation of linear functions of the feature variables, so that

$$
p ( \mathcal { C } _ { k } | \phi ) = y _ { k } ( \phi ) = \frac { \exp ( a _ { k } ) } { \sum _ { j } \exp ( a _ { j } ) } \\ \intertext { v iations } \ a _ { k } \text { are given by } &
$$

where the ‘activations’ a k are given by

$$
a _ { k } = \mathbf w _ { k } ^ { T } \phi .
$$

There we used maximum likelihood to determine separately the class-conditional densities and the class priors and then found the corresponding posterior probabilities using Bayes’ theorem, thereby implicitly determining the parameters { w k } . Here we consider the use of maximum likelihood to determine the parameters { w k } of this model directly. To do this, we will require the derivatives of y k with respect to all of the activations a j . These are given by

$$
\frac { \partial y _ { k } } { \partial a _ { j } } = y _ { k } ( I _ { k j } - y _ { j } )
$$

where I kj are the elements of the identity matrix. Next we write down the likelihood function.

This is most easily done using the 1-ofK coding scheme in which the target vector t n for a feature vector φ n belonging to class C k is a binary vector with all elements zero except for element k , which equals one. The likelihood function is then given by

$$
p ( T | w _ { 1 } , \dots , w _ { K } ) = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } p ( \mathcal { C } _ { k } | \phi _ { n } ) ^ { t _ { n k } } = \prod _ { n = 1 } ^ { N } \prod _ { k = 1 } ^ { K } y _ { n k } ^ { t _ { n k } } \\ \intertext { w h o r } w _ { 1 } = \alpha _ { 1 } ( \phi _ { 1 } ) \text { and } T _ { i } \text { is } \text { } N \times K \text { matrix of } \text { } t \text { } \text { } o r t \text { } \text { } v o r i b l o s \text { with } \text { } o l l o ments }
$$

where y nk = y k ( φ n ) , and T is an N × K matrix of target variables with elements t nk . Taking the negative logarithm then gives

$$
E ( w _ { 1 } , \dots , w _ { K } ) = - \ln p ( T | w _ { 1 } , \dots , w _ { K } ) = - \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } t _ { n k } \ln y _ { n k } \quad ( 4 . 1 0 8 ) \\ \intertext { w h i c h is k o n w }
$$

which is known as the cross-entropy error function for the multiclass classiﬁcation problem.

We now take the gradient of the error function with respect to one of the parameter vectors w j . Making use of the result (4.106) for the derivatives of the softmax function, we obtain

$$
\nabla _ { w _ { j } } E ( w _ { 1 } , \dots , w _ { K } ) = \sum _ { n = 1 } ^ { N } ( y _ { n j } - t _ { n j } ) \, \phi _ { n }
$$
