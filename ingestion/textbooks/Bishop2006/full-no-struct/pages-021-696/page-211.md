[Page 211]

# 4.1.6 Fisher’s discriminant for multiple classes

We now consider the generalization of the Fisher discriminant to K > 2 classes, and we shall assume that the dimensionality D of the input space is greater than the number K of classes. Next, we introduce D > 1 linear ‘features’ y k = w T k x , where k = 1 ,...,D . These feature values can conveniently be grouped together to form a vector y . Similarly, the weight vectors { w k } can be considered to be the columns of a matrix W , so that T

$$
y = W ^ { T } x .
$$

Note that again we are not including any bias parameters in the deﬁnition of y . The generalization of the within-class covariance matrix to the case of K classes follows from (4.28) to give

$$
S _ { W } = \sum _ { k = 1 } ^ { K } S _ { k }
$$

where

$$
S _ { k } \ = \ \sum _ { n \in \mathcal { C } _ { k } } ( x _ { n } - m _ { k } ) ( x _ { n } - m _ { k } ) ^ { T } \\ m _ { k } \ = \ \sum _ { n \in \mathcal { C } _ { k } } x _ { n }
$$

$$
m _ { k } \ = \ \frac { 1 } { N _ { k } } \sum _ { n \in \mathcal { C } _ { k } } x _ { n } \\
$$

and N k is the number of patterns in class C k . In order to ﬁnd a generalization of the between-class covariance matrix, we follow Duda and Hart (1973) and consider ﬁrst the total covariance matrix

$$
S _ { T } = \sum _ { n = 1 } ^ { N } ( x _ { n } - m ) ( x _ { n } - m ) ^ { T } \\ \text {mean of the total data set}
$$

where m is the mean of the total data set

$$
m = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } x _ { n } = \frac { 1 } { N } \sum _ { k = 1 } ^ { K } N _ { k } m _ { k } \\ N _ { \ } i s t o l _ { \ } t o l _ { \ } n u m o r _ { \ } o f d e t a \, \text {points} \, \ T h o t e l _ { \ } o v e r i o n a \, \rho _ { \ } n t r i v _ { \ } o n }
$$

and N = k N k is the total number of data points. The total covariance matrix can be decomposed into the sum of the within-class covariance matrix, given by (4.40) and (4.41), plus an additional matrix S B , which we identify as a measure of the between-class covariance

$$
S _ { T } = S _ { W } + S _ { B }
$$

where These covariance matrices have been defined in the original x -space. We can now define similar matrices in the projected D ′ -dimensional y -space

$$
S _ { B } = \sum _ { k = 1 } ^ { K } N _ { k } ( m _ { k } - m ) ( m _ { k } - m ) ^ { T } .
$$
