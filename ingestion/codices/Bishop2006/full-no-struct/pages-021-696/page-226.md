[Page 226]

Exercise 4.13

Section 3.1.1

Exercise 4.14

For a data set { φ n ,t n } , where t n ∈ { 0 , 1 } and φ n = φ ( x n ) , with n = 1 ,...,N , the likelihood function can be written

$$
p ( \mathbf t | w ) = \prod _ { n = 1 } ^ { N } y _ { n } ^ { t _ { n } } \left \{ 1 - y _ { n } \right \} ^ { 1 - t _ { n } } \\ t _ { n } ( T ) = \mathbf n - ( \mathcal { C } _ { n } | \phi _ { n } ) \ \ A s u v a l \ w \ c a n d e f i n a r g r o w
$$

where t = ( t 1 ,...,t N ) T and y n = p ( C 1 | φ n ) . As usual, we can deﬁne an error function by taking the negative logarithm of the likelihood, which gives the crossentropy error function in the form

$$
E ( w ) = - \ln p ( \mathbf t | w ) = - \sum _ { n = 1 } ^ { N } \{ t _ { n } \ln y _ { n } + ( 1 - t _ { n } ) \ln ( 1 - y _ { n } ) \} \\ \intertext { w h e r $ y = \sigma ( a ) $ and $ a = w ^ { T } \phi $ }
$$

where y n = σ ( a n ) and a n = w T φ n . Taking the gradient of the error function with respect to w , we obtain

$$
\nabla E ( w ) = \sum _ { n = 1 } ^ { N } ( y _ { n } - t _ { n } ) \phi _ { n } \\ \text {ade} \, \text {use of } ( 4 . 8 8 ) \text { .} \, \text {We see that the factor involving the derivative}
$$

where we have made use of (4.88). We see that the factor involving the derivative of the logistic sigmoid has cancelled, leading to a simpliﬁed form for the gradient of the log likelihood. In particular, the contribution to the gradient from data point n is given by the ‘error’ y n − t n between the target value and the prediction of the model, times the basis function vector φ n . Furthermore, comparison with (3.13) shows that this takes precisely the same form as the gradient of the sum-of-squares error function for the linear regression model.

If desired, we could make use of the result (4.91) to give a sequential algorithm in which patterns are presented one at a time, in which each of the weight vectors is updated using (3.22) in which ∇ E n is the n th term in (4.91). It is worth noting that maximum likelihood can exhibit severe over-ﬁtting for

data sets that are linearly separable. This arises because the maximum likelihood solution occurs when the hyperplane corresponding to σ = 0 . 5 , equivalent to w T φ = 0 , separates the two classes and the magnitude of w goes to inﬁnity. In this case, the logistic sigmoid function becomes inﬁnitely steep in feature space, corresponding to a Heaviside step function, so that every training point from each class k is assigned a posterior probability p ( C k | x ) = 1 . Furthermore, there is typically a continuum of such solutions because any separating hyperplane will give rise to the same posterior probabilities at the training data points, as will be seen later in Figure 10.13. Maximum likelihood provides no way to favour one such solution over another, and which solution is found in practice will depend on the choice of optimization algorithm and on the parameter initialization. Note that the problem will arise even if the number of data points is large compared with the number of parameters in the model, so long as the training data set is linearly separable. The singularity can be avoided by inclusion of a prior and ﬁnding a MAP solution for w , or equivalently by adding a regularization term to the error function.
