[Page 222]

Exercise 4.10

Section 2.3.7

Section 8.2.2

Exercise 4.11

where we have deﬁned

$$
S \ = \ \frac { N _ { 1 } } { N } S _ { 1 } + \frac { N _ { 2 } } { N } S _ { 2 }
$$

$$
S _ { 1 } \ & = \ \frac { 1 } { N _ { 1 } } \sum _ { n \in \mathcal { C } _ { 1 } } ( x _ { n } - \mu _ { 1 } ) ( x _ { n } - \mu _ { 1 } ) ^ { \top } \\ S _ { 2 } & = \ \frac { 1 } { N _ { 1 } } \sum _ { n \in \mathcal { C } _ { 1 } } ( x _ { n } - \mu _ { 1 } ) ( x _ { n } - \mu _ { 1 } ) ^ { \top }
$$

$$
S _ { 2 } \ = \ \frac { 1 } { N _ { 2 } } \sum _ { n \in \mathcal { C } _ { 2 } } ( x _ { n } - \mu _ { 2 } ) ( x _ { n } - \mu _ { 2 } ) ^ { \top } . \\ \intertext { s t a n d r e s l u t for t h e a m i m u m l i k l i o b h o d s u l i o n for a G a u s i a n d i s t r i _ { } }
$$

Using the standard result for the maximum likelihood solution for a Gaussian distribution, we see that Σ = S , which represents a weighted average of the covariance matrices associated with each of the two classes separately.

This result is easily extended to the K class problem to obtain the corresponding maximum likelihood solutions for the parameters in which each class-conditional density is Gaussian with a shared covariance matrix. Note that the approach of ﬁtting Gaussian distributions to the classes is not robust to outliers, because the maximum likelihood estimation of a Gaussian is not robust.

# 4.2.3 Discrete features

Let us now consider the case of discrete feature values x i . For simplicity, we begin by looking at binary feature values x i ∈ { 0 , 1 } and discuss the extension to more general discrete features shortly. If there are D inputs, then a general distribution would correspond to a table of 2 D numbers for each class, containing 2 D − 1 independent variables (due to the summation constraint). Because this grows exponentially with the number of features, we might seek a more restricted representation. Here we will make the naive Bayes assumption in which the feature values are treated as independent, conditioned on the class C k . Thus we have class-conditional distributions of the form

$$
p ( x | \mathcal { C } _ { k } ) = \prod _ { i = 1 } ^ { D } \mu _ { k i } ^ { x _ { i } } ( 1 - \mu _ { k i } ) ^ { 1 - x _ { i } } \\ \intertext { A n d e n e n d e p a r m e t s for e a c h l c s . $ Substituting into ( 4 . 6 3 ) $ }
$$

which contain D independent parameters for each class. Substituting into (4.63) then gives

$$
& \text {gives} \\ & \quad a _ { k } ( x ) = \sum _ { i = 1 } ^ { D } \{ x _ { i } \ln \mu _ { k i } + ( 1 - x _ { i } ) \ln ( 1 - \mu _ { k i } ) \} + \ln p ( \mathcal { C } _ { k } ) \\ & \text {which again are linear functions of the input values } x _ { i } . \text { For the case of } K = 2 \text { classes} ,
$$

which again are linear functions of the input values x i . For the case of K = 2 classes, we can alternatively consider the logistic sigmoid formulation given by (4.57). Analogous results are obtained for discrete variables each of which can take M > 2 states.

# 4.2.4 Exponential family

As we have seen, for both Gaussian distributed and discrete inputs, the posterior class probabilities are given by generalized linear models with logistic sigmoid ( K =
