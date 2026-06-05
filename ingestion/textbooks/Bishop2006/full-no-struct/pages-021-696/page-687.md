[Page 687]

Exercise 14.13

logistic regression models (Section 14.5.2). In the simplest case, the mixing coefﬁcients are independent of the input variables. If we make a further generalization to allow the mixing coefﬁcients also to depend on the inputs then we obtain a mixture of experts model. Finally, if we allow each component in the mixture model to be itself a mixture of experts model, then we obtain a hierarchical mixture of experts.

# 14.5.1 Mixtures of linear regression models

One of the many advantages of giving a probabilistic interpretation to the linear regression model is that it can then be used as a component in more complex probabilistic models. This can be done, for instance, by viewing the conditional distribution representing the linear regression model as a node in a directed probabilistic graph. Here we consider a simple example corresponding to a mixture of linear regression models, which represents a straightforward extension of the Gaussian mixture model discussed in Section 9.2 to the case of conditional Gaussian distributions.

We therefore consider K linear regression models, each governed by its own weight parameter w k . In many applications, it will be appropriate to use a common noise variance, governed by a precision parameter β , for all K components, and this is the case we consider here. We will once again restrict attention to a single target variable t , though the extension to multiple outputs is straightforward. If we denote the mixing coefﬁcients by π k , then the mixture distribution can be written

$$
p ( t | \theta ) = \sum _ { k = 1 } ^ { K } \pi _ { k } \mathcal { N } ( t | w _ { k } ^ { \top } \phi , \beta ^ { - 1 } ) \\ \intertext { s t e s t o f a l l a d a p t i v e parameters in the model, n a m e l y W = \{ w _ { k } \} , }
$$

where θ denotes the set of all adaptive parameters in the model, namely W = { w k } , π = { π k } , and β . The log likelihood function for this model, given a data set of observations { φ n ,t n } , then takes the form N K

$$
\text {vations} \left \{ \phi _ { n } , t _ { n } \right \} , \text { then takes the form} \\ \ln p ( \mathfrak { t } | \theta ) = \sum _ { n = 1 } ^ { N } \ln \left ( \sum _ { k = 1 } ^ { K } \pi _ { k } \mathcal { N } ( t _ { n } | w _ { k } ^ { T } \phi _ { n } , \beta ^ { - 1 } ) \right ) \\ \mathfrak { t } = ( t _ { 1 } , \dots , t _ { N } ) ^ { T } \detnotes the vector of target variables .
$$

where t = ( t 1 , . . . , t N ) T denotes the vector of target variables.

again appeal to the EM algorithm, which will turn out to be a simple extension of the EM algorithm for unconditional Gaussian mixtures of Section 9.2. We can therefore build on our experience with the unconditional mixture and introduce a set Z = { z n } of binary latent variables where z nk ∈ { 0 , 1 } in which, for each data point n , all of the elements k = 1 ,...,K are zero except for a single value of 1 indicating which component of the mixture was responsible for generating that data point. The joint distribution over latent and observed variables can be represented by the graphical model shown in Figure 14.7.

The complete-data log likelihood function then takes the form

$$
\ln p ( t , Z | \theta ) = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } z _ { n k } \ln \left \{ \pi _ { k } \mathcal { N } ( t _ { n } | w _ { k } ^ { \top } \phi _ { n } , \beta ^ { - 1 } ) \right \} .
$$
