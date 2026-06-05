[Page 164]

in which the data points are considered one at a time, and the model parameters updated after each such presentation. Sequential learning is also appropriate for realtime applications in which the data observations are arriving in a continuous stream, and predictions must be made before all of the data points are seen.

We can obtain a sequential learning algorithm by applying the technique of stochastic gradient descent , also known as sequential gradient descent , as follows. If the error function comprises a sum over data points E = n E n , then after presentation of pattern n , the stochastic gradient descent algorithm updates the parameter vector w using ( τ +1) ( τ )

$$
w ^ { ( \tau + 1 ) } = w ^ { ( \tau ) } - \eta \nabla E _ { n } \\ \intertext { w } \intertext { i t r o i t } \intertext { o n t i o r } \intertext { n o n b o r }
$$

where τ denotes the iteration number, and η is a learning rate parameter. We shall discuss the choice of value for η shortly. The value of w is initialized to some starting vector w (0) . For the case of the sum-of-squares error function (3.12), this gives

$$
w ^ { ( \tau + 1 ) } = w ^ { ( \tau ) } + \eta ( t _ { n } - w ^ { ( \tau ) T } \phi _ { n } ) \phi _ { n } \\
$$

where φ n = φ ( x n ) . This is known as least-mean-squares or the LMS algorithm . The value of η needs to be chosen with care to ensure that the algorithm converges (Bishop and Nabney, 2008).

# 3.1.4 Regularized least squares

In Section 1.1, we introduced the idea of adding a regularization term to an error function in order to control over-ﬁtting, so that the total error function to be minimized takes the form

$$
E _ { D } ( \mathbf w ) + \lambda E _ { W } ( \mathbf w )
$$

where λ is the regularization coefﬁcient that controls the relative importance of the data-dependent error E D ( w ) and the regularization term E W ( w ) . One of the simplest forms of regularizer is given by the sum-of-squares of the weight vector elements 1

$$
E _ { W } ( w ) = \frac { 1 } { 2 } w ^ { T } w .
$$

If we also consider the sum-of-squares error function given by

$$
E ( w ) = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \{ t _ { n } - w ^ { \top } \phi ( x _ { n } ) \} ^ { 2 } \\ \intertext { f o r } \text { function becomes }
$$

then the total error function becomes

$$
\frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \{ t _ { n } - w ^ { T } \phi ( x _ { n } ) \} ^ { 2 } + \frac { \lambda } { 2 } w ^ { T } w . \\ \intertext { a r c o i s e f o r g u l a r i z e r $ i s $ k n $ o w n $ i n t h e m a t h e l r e a $ i s $ }
$$

This particular choice of regularizer is known in the machine learning literature as weight decay because in sequential learning algorithms, it encourages weight values to decay towards zero, unless supported by the data. In statistics, it provides an example of a parameter shrinkage method because it shrinks parameter values towards
