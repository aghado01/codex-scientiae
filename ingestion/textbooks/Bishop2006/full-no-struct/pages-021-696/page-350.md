[Page 350]

In Appendix E, we show that a constrained optimization of this form satisﬁes the Karush-Kuhn-Tucker (KKT) conditions, which in this case require that the following three properties hold

$$
a _ { n } \ \geq \ 0
$$

$$
t _ { n } y ( x _ { n } ) - 1 \ & \geq \ 0 \\ a _ { n } \{ t _ { n } y ( x _ { n } ) - 1 \} \ & = \ 0
$$

$$
a _ { n } \left \{ t _ { n } y ( x _ { n } ) - 1 \right \} \ = \ 0 .
$$

Thus for every data point, either a n = 0 or t n y ( x n ) = 1 . Any data point for which a n = 0 will not appear in the sum in (7.13) and hence plays no role in making predictions for new data points. The remaining data points are called support vectors , and because they satisfy t n y ( x n ) = 1 , they correspond to points that lie on the maximum margin hyperplanes in feature space, as illustrated in Figure 7.1. This property is central to the practical applicability of support vector machines. Once the model is trained, a signiﬁcant proportion of the data points can be discarded and only the support vectors retained.

Having solved the quadratic programming problem and found a value for a , we can then determine the value of the threshold parameter b by noting that any support vector x n satisﬁes t n y ( x n ) = 1 . Using (7.13) this gives

$$
\i m s \, t _ { n } \, y ( x _ { n } ) = 1 . \, \text {Using} \, ( . . . ) \, \text {this gives} \\ t _ { n } \left ( \sum _ { m \in \mathcal { S } } a _ { m } t _ { m } k ( x _ { n } , x _ { m } ) + b \right ) = 1 \\ \text {notes the set of indices of the support vectors} \, \ A \text { though we can solve}
$$

where S denotes the set of indices of the support vectors. Although we can solve this equation for b using an arbitrarily chosen support vector x n , a numerically more stable solution is obtained by ﬁrst multiplying through by t n , making use of t 2 n = 1 , and then averaging these equations over all support vectors and solving for b to give

$$
b = \frac { 1 } { N _ { S } } \sum _ { n \in S } \left ( t _ { n } - \sum _ { m \in S } a _ { m } t _ { m } k ( x _ { n } , x _ { m } ) \right ) \\ \intertext { c . s . i . } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text { } \text
$$

where N S is the total number of support vectors. For later comparison with alternative models,

we can express the maximummargin classiﬁer in terms of the minimization of an error function, with a simple quadratic regularizer, in the form

$$
\sum _ { n = 1 } ^ { N } E _ { \infty } ( y ( x _ { n } ) t _ { n } - 1 ) + \lambda \| w \| ^ { 2 } \\ \intertext { i s o f u n t h e i s z o r i f z > 0 and o n d o w h e r s }
$$

where E ∞ ( z ) is a function that is zero if z 0 and ∞ otherwise and ensures that the constraints (7.5) are satisﬁed. Note that as long as the regularization parameter satisﬁes λ > 0 , its precise value plays no role.

Figure 7.2 shows an example of the classiﬁcation resulting from training a support vector machine on a simple synthetic data set using a Gaussian kernel of the
