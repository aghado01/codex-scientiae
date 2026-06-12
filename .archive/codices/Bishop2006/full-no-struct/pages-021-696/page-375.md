[Page 375]

Exercise 7.19

Appendix A

Section 13.3

mation, we have

$$
p ( t | \alpha ) \ & = \ \int p ( t | w ) p ( w | \alpha ) \, d w \\ & \simeq \ p ( t | w ^ { * } ) p ( w ^ { * } | \alpha ) ( 2 \pi ) ^ { M / 2 } | \Sigma | ^ { 1 / 2 } . \\ \text {substitute for } p ( t | w ^ { * } ) \, a n d \, p ( w ^ { * } | \alpha ) \, a n d \, then \, \text {set the derivative of the marginal}
$$

If we substitute for p ( t | w ) and p ( w | α ) and then set the derivative of the marginal likelihood with respect to α i equal to zero, we obtain

$$
- \frac { 1 } { 2 } ( w _ { i } ^ { * } ) ^ { 2 } + \frac { 1 } { 2 \alpha _ { i } } - \frac { 1 } { 2 } \Sigma _ { i i } = 0 .
$$

Deﬁning γ i = 1 − α i Σ ii and rearranging then gives

$$
\alpha _ { i } ^ { \text {new} } = \frac { \gamma _ { i } } { ( w _ { i } ^ { * } ) ^ { 2 } }
$$

which is identical to the re-estimation formula (7.87) obtained for the regression RVM.

If we deﬁne

$$
\widehat { t } = \Phi w ^ { * } + B ^ { - 1 } ( t - y ) & & ( 7 . 1 1 7 ) \\ \text {proximate log marginal likelihood in the form} \\
$$

we can write the approximate log marginal likelihood in the form

$$
\text {can write the approximate log margar in the form} \\ \ln p ( \mathbf t | \alpha , \beta ) = - \frac { 1 } { 2 } \left \{ N \ln ( 2 \pi ) + \ln | C | + ( \widehat { \mathbf t } ) ^ { T } C ^ { - 1 } \widehat { \mathbf t } \right \} \\ \text {where} \\ C = B + \Phi A \Phi ^ { T } .
$$

where

$$
C = B + \Phi A \Phi ^ { T } .
$$

This takes the same form as (7.85) in the regression case, and so we can apply the same analysis of sparsity and obtain the same fast learning algorithm in which we fully optimize a single hyperparameter α i at each step. Figure 7.12 shows the relevance vector machine applied to a synthetic classiﬁ-

cation data set. We see that the relevance vectors tend not to lie in the region of the decision boundary, in contrast to the support vector machine. This is consistent with our earlier discussion of sparsity in the RVM, because a basis function φ i ( x ) centred on a data point near the boundary will have a vector ϕ i that is poorly aligned with the training data vector t .

One of the potential advantages of the relevance vector machine compared with the SVM is that it makes probabilistic predictions. For example, this allows the RVM to be used to help construct an emission density in a nonlinear extension of the linear dynamical system for tracking faces in video sequences (Williams et al. , 2005).

So far, we have considered the RVM for binary classiﬁcation problems. For K > 2 classes, we again make use of the probabilistic approach in Section 4.3.4 in which there are K linear models of the form

$$
a _ { k } = w _ { k } ^ { T } x
$$
