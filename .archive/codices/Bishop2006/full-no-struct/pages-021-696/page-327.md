[Page 327]

where the covariance matrix C has elements

$$
C ( x _ { n } , x _ { m } ) = k ( x _ { n } , x _ { m } ) + \beta ^ { - 1 } \delta _ { n m } .
$$

This result reﬂects the fact that the two Gaussian sources of randomness, namely that associated with y ( x ) and that associated with , are independent and so their covariances simply add.

One widely used kernel function for Gaussian process regression is given by the exponential of a quadratic form, with the addition of constant and linear terms to give

$$
g ^ { \infty } \\ k ( x _ { n } , x _ { m } ) = \theta _ { 0 } \exp \left \{ - \frac { \theta _ { 1 } } { 2 } \| x _ { n } - x _ { m } \| ^ { 2 } \right \} + \theta _ { 2 } + \theta _ { 3 } x _ { n } ^ { T } x _ { m } . \\ \\ N _ { \ } e q \Delta _ { 1 } + \Delta _ { 2 } - \Delta _ { 1 } \cdot \Delta _ { 2 } = 0
$$

Note that the term involving θ 3 corresponds to a parametric model that is a linear function of the input variables. Samples from this prior are plotted for various values of the parameters θ 0 ,...,θ 3 in Figure 6.5, and Figure 6.6 shows a set of points sampled from the joint distribution (6.60) along with the corresponding values deﬁned by (6.61).

So far, we have used the Gaussian process viewpoint to build a model of the joint distribution over sets of data points. Our goal in regression, however, is to make predictions of the target variables for new inputs, given a set of training data. Let us suppose that t N = ( t 1 ,...,t N ) T , corresponding to input values x 1 ,..., x N , comprise the observed training set, and our goal is to predict the target variable t N +1 for a new input vector x N +1 . This requires that we evaluate the predictive distribution p ( t N +1 | t N ) . Note that this distribution is conditioned also on the variables x 1 ,..., x N and x N +1 . However, to keep the notation simple we will not show these conditioning variables explicitly.

To ﬁnd the conditional distribution p ( t N +1 | t ) , we begin by writing down the joint distribution p ( t N +1 ) , where t N +1 denotes the vector ( t 1 ,...,t N ,t N +1 ) T . We then apply the results from Section 2.3.1 to obtain the required conditional distribution, as illustrated in Figure 6.7.

From (6.61), the joint distribution over t 1 ,...,t N +1 will be given by

$$
p ( \mathbf t _ { N + 1 } ) = \mathcal { N } ( \mathbf t _ { N + 1 } | 0 , C _ { N + 1 } )
$$

where C N +1 is an ( N + 1) × ( N + 1) covariance matrix with elements given by (6.62). Because this joint distribution is Gaussian, we can apply the results from Section 2.3.1 to ﬁnd the conditional Gaussian distribution. To do this, we partition the covariance matrix as follows

$$
C _ { N + 1 } = \left ( \begin{array} { c c } C _ { N } & k \\ k ^ { T } & c \end{array} \right ) \\
$$

where C N is the N × N covariance matrix with elements given by (6.62) for n, m = 1 , . . . , N , the vector k has elements k ( x n , x N +1 ) for n = 1 , . . . , N , and the scalar c = k ( x N +1 , x N +1 ) + β -1 . Using the results (2.81) and (2.82), we see that the conditional distribution p ( t N +1 | t ) is a Gaussian distribution with mean and covariance given by
