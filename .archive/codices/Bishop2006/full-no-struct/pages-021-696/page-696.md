[Page 696]

14.16 ( ) Extend the logistic regression mixture model of Section 14.5.2 to a mixture of softmax classiﬁers representing C 2 classes. Write down the EM algorithm for determining the parameters of this model through maximum likelihood.

14.17 ( ) www Consider a mixture model for a conditional distribution p ( t | x ) of the form K

$$
p ( t | x ) = \sum _ { k = 1 } ^ { K } \pi _ { k } \psi _ { k } ( t | x ) \\ \text {are component } \psi _ { k } ( t | x ) \text { is itself a mixture model. Show that this}
$$

in which each mixture component ψ k ( t | x ) is itself a mixture model. Show that this two-level hierarchical mixture is equivalent to a conventional single-level mixture model. Now suppose that the mixing coefﬁcients in both levels of such a hierarchical model are arbitrary functions of x . Again, show that this hierarchical model is again equivalent to a single-level model with x -dependent mixing coefﬁcients. Finally, consider the case in which the mixing coefﬁcients at both levels of the hierarchical mixture are constrained to be linear classiﬁcation (logistic or softmax) models. Show that the hierarchical mixture cannot in general be represented by a single-level mixture having linear classiﬁcation models for the mixing coefﬁcients. Hint: to do this it is sufﬁcient to construct a single counter-example, so consider a mixture of two components in which one of those components is itself a mixture of two components, with mixing coefﬁcients given by linear-logistic models. Show that this cannot be represented by a single-level mixture of 3 components having mixing coefﬁcients determined by a linear-softmax model.
