[Page 688]

Figure 14.7 Probabilistic directed graph representing a mixture of linear regression models, deﬁned by (14.35).

![image 331](../images/imageFile331.png)

φ

n

z

n

π

β

t

n

N

W

Exercise 14.14

The EM algorithm begins by ﬁrst choosing an initial value θ old for the model parameters. In the E step, these parameter values are then used to evaluate the posterior probabilities, or responsibilities, of each component k for every data point n given by T 1

$$
by & & \gamma _ { n k } = \mathbb { E } [ z _ { n k } ] = p ( k | \phi _ { n } , \theta ^ { \text {old} } ) = \frac { \pi _ { k } \mathcal { N } ( t _ { n } | w _ { k } ^ { \top } \phi _ { n } , \beta ^ { - 1 } ) } { \sum _ { j } \pi _ { j } \mathcal { N } ( t _ { n } | w _ { j } ^ { \top } \phi _ { n } , \beta ^ { - 1 } ) } . \\ & \text {The responsibilities are then used to determine the expectation, with respect to the } \\ & \text {posterior distribution } p ( Z | t , \theta ^ { \text {old} } ) , \text { of the complete-data log likelihood, which takes }
$$

The responsibilities are then used to determine the expectation, with respect to the posterior distribution p ( Z | t , θ old ) , of the complete-data log likelihood, which takes the form

$$
Q ( \theta , \theta ^ { \text {old} } ) = \mathbb { E } _ { Z } \left [ \ln p ( \mathbf t , Z | \theta ) \right ] = \sum _ { n = 1 } ^ { N } \sum _ { k = 1 } ^ { K } \gamma _ { n k } \left \{ \ln \pi _ { k } + \ln \mathcal { N } ( \mathbf t _ { n } | \mathbf w _ { k } ^ { \text {f} } \phi _ { n } , \beta ^ { - 1 } ) \right \} . \\ \\ \text {In the } M \text { at } \mathbf w \text { maximize the function } Q ( \theta , \theta ^ { \text {old} } ) \text { with respect to } \theta \text {, } \text {looping the } \mathbf h \text { }
$$

In the M step, we maximize the function Q ( θ , θ old ) with respect to θ , keeping the γ nk ﬁxed. For the optimization with respect to the mixing coefﬁcients π k we need to take account of the constraint k π k = 1 , which can be done with the aid of a Lagrange multiplier, leading to an M-step re-estimation equation for π k in the form

$$
\pi _ { k } = \frac { 1 } { N } \sum _ { n = 1 } ^ { N } \gamma _ { n k } . \\ \text {ly} \, \text {the same form as the corresponding result for a simple}
$$

Note that this has exactly the same form as the corresponding result for a simple mixture of unconditional Gaussians given by (9.22).

Next consider the maximization with respect to the parameter vector w k of the k th linear regression model. Substituting for the Gaussian distribution, we see that the function Q ( θ , θ old ) , as a function of the parameter vector w k , takes the form

$$
Q ( \theta , \theta ^ { o l d } ) = \sum _ { n = 1 } ^ { N } \gamma _ { n k } \left \{ - \frac { \beta } { 2 } \left ( t _ { n } - w _ { k } ^ { T } \phi _ { n } \right ) ^ { 2 } \right \} + \text {const} \\ \intertext { w h e r e the constant term includes the contributions from other weight vectors w i f }
$$

where the constant term includes the contributions from other weight vectors w j for j = k . Note that the quantity we are maximizing is similar to the (negative of the) standard sum-of-squares error (3.12) for a single linear regression model, but with the inclusion of the responsibilities γ nk . This represents a weighted least squares

/negationslash
