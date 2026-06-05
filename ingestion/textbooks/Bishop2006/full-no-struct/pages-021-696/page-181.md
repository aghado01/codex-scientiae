[Page 181]

Chapter 6

be simply y ( x ) = 1 , from which we obtain (3.64). Note that the kernel function can be negative as well as positive, so although it satisﬁes a summation constraint, the corresponding predictions are not necessarily convex combinations of the training set target variables.

Finally, we note that the equivalent kernel (3.62) satisﬁes an important property shared by kernel functions in general, namely that it can be expressed in the form an inner product with respect to a vector ψ ( x ) of nonlinear functions, so that

$$
k ( x , z ) = \psi ( x ) ^ { \top } \psi ( z )
$$

$$
k ( x , z ) = \psi ( x ) ^ { \top } \psi ( z ) \\ 3 ^ { 1 / 2 } S _ { N } ^ { 1 / 2 } \phi ( x ) .
$$

$$
\text {where } \psi ( x ) = \beta ^ { 1 / 2 } S _ { N } ^ { 1 / 2 } \phi ( x ) .
$$

# 3.4. Bayesian Model Comparison

Section 1.5.4

In Chapter 1, we highlighted the problem of over-ﬁtting as well as the use of crossvalidation as a technique for setting the values of regularization parameters or for choosing between alternative models. Here we consider the problem of model selection from a Bayesian perspective. In this section, our discussion will be very general, and then in Section 3.5 we shall see how these ideas can be applied to the determination of regularization parameters in linear regression.

As we shall see, the over-ﬁtting associated with maximum likelihood can be avoided by marginalizing (summing or integrating) over the model parameters instead of making point estimates of their values. Models can then be compared directly on the training data, without the need for a validation set. This allows all available data to be used for training and avoids the multiple training runs for each model associated with cross-validation. It also allows multiple complexity parameters to be determined simultaneously as part of the training process. For example, in Chapter 7 we shall introduce the relevance vector machine , which is a Bayesian model having one complexity parameter for every training data point.

The Bayesian view of model comparison simply involves the use of probabilities to represent uncertainty in the choice of model, along with a consistent application of the sum and product rules of probability. Suppose we wish to compare a set of L models {M i } where i = 1 ,...,L . Here a model refers to a probability distribution over the observed data D . In the case of the polynomial curve-ﬁtting problem, the distribution is deﬁned over the set of target values t , while the set of input values X is assumed to be known. Other types of model deﬁne a joint distributions over X and t . We shall suppose that the data is generated from one of these models but we are uncertain which one. Our uncertainty is expressed through a prior probability distribution p ( M i ) . Given a training set D , we then wish to evaluate the posterior distribution

$$
p ( \mathcal { M } _ { i } | \mathcal { D } ) \circ p ( \mathcal { M } _ { i } ) p ( \mathcal { D } | \mathcal { M } _ { i } ) . \\ \intertext { p ( \mathcal { M } _ { i } | \mathcal { D } ) \circ p ( \mathcal { M } _ { i } ) p ( \mathcal { D } | \mathcal { M } _ { i } ) . } \intertext { a . w . t e v . a m p s e s e , a n d f o r g r o n t m e d l e . I e t w . a i n s p l y w }
$$

The prior allows us to express a preference for different models. Let us simply assume that all models are given equal prior probability. The interesting term is the model evidence p ( D|M i ) which expresses the preference shown by the data for
