[Page 218]

Note that in (4.57) we have simply rewritten the posterior probabilities in an equivalent form, and so the appearance of the logistic sigmoid may seem rather vacuous. However, it will have signiﬁcance provided a ( x ) takes a simple functional form. We shall shortly consider situations in which a ( x ) is a linear function of x , in which case the posterior probability is governed by a generalized linear model.

For the case of K > 2 classes, we have

$$
\begin{array} { r l } { c o n R < 2 \, c l a s s , w c h a v c } \\ { p ( \mathcal { C } _ { k } | \mathbf x ) } & = } & { \frac { p ( \mathbf x | \mathcal { C } _ { k } ) p ( \mathcal { C } _ { k } ) } { \sum _ { j } p ( \mathbf x | \mathcal { C } _ { j } ) p ( \mathcal { C } _ { j } ) } } \\ & = } & { \frac { \exp ( a _ { k } ) } { \sum _ { j } \exp ( a _ { j } ) } } \end{array}
$$

which is known as the normalized exponential and can be regarded as a multiclass generalization of the logistic sigmoid. Here the quantities a k are deﬁned by

$$
a _ { k } = \ln p ( \mathbf x | \mathcal { C } _ { k } ) p ( \mathcal { C } _ { k } ) .
$$

The normalized exponential is also known as the softmax function , as it represents a smoothed version of the ‘max’ function because, if a k a j for all j = k , then p ( C k | x ) 1 , and p ( C j | x ) 0 . We now investigate the consequences of choosing speciﬁc forms for the class-

/negationslash

conditional densities, looking ﬁrst at continuous input variables x and then discussing brieﬂy the case of discrete inputs.

# 4.2.1 Continuous inputs

Let us assume that the class-conditional densities are Gaussian and then explore the resulting form for the posterior probabilities. To start with, we shall assume that all classes share the same covariance matrix. Thus the density for class C k is given by

$$
p ( x | \mathcal { C } _ { k } ) & = \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \exp \left \{ - \frac { 1 } { 2 } ( x - \mu _ { k } ) ^ { T } \Sigma ^ { - 1 } ( x - \mu _ { k } ) \right \} . \\ \intertext { s i d e r s i f t h e c a s o f t w o l c h e s }
$$

Consider ﬁrst the case of two classes. From (4.57) and (4.58), we have

where we have deﬁned

$$
p ( \mathcal { C } _ { 1 } | \mathbf x ) = \sigma ( \mathbf w ^ { \mathrm T } \mathbf x + \mathbf w _ { 0 } )
$$

$$
w \ = \ \Sigma ^ { - 1 } ( \mu _ { 1 } - \mu _ { 2 } ) \\ 1 _ { \ t _ { 0 } } \ + \ 1 _ { \ t _ { 1 } } \ + \ \mu _ { 2 } \, \quad \, \ p ( \mathcal { C } _ { 1 } )
$$

$$
w _ { 0 } \ = \ - \frac { 1 } { 2 } \mu _ { 1 } ^ { \top } \Sigma ^ { - 1 } \mu _ { 1 } + \frac { 1 } { 2 } \mu _ { 2 } ^ { \top } \Sigma ^ { - 1 } \mu _ { 2 } + \ln \frac { p ( \mathcal { C } _ { 1 } ) } { p ( \mathcal { C } _ { 2 } ) } . \\ \intertext { a n t h e w d m e t i o n g e r s i n v e r }
$$

We see that the quadratic terms in x from the exponents of the Gaussian densities have cancelled (due to the assumption of common covariance matrices) leading to a linear function of x in the argument of the logistic sigmoid. This result is illustrated for the case of a two-dimensional input space x in Figure 4.10. The resulting decision boundaries correspond to surfaces along which the posterior probabilities p ( C k | x ) are constant and so will be given by linear functions of x , and therefore the decision boundaries are linear in input space. The prior probabilities p ( C k ) enter only through the bias parameter w 0 so that changes in the priors have the effect of making parallel shifts of the decision boundary and more generally of the parallel contours of constant posterior probability.
