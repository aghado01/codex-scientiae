[Page 83]

1.20 ( ) www In this exercise, we explore the behaviour of the Gaussian distribution in high-dimensional spaces. Consider a Gaussian distribution in D dimensions given by 2

$$
p ( x ) = \frac { 1 } { ( 2 \pi \sigma ^ { 2 } ) ^ { D / 2 } } \exp \left ( - \frac { \| x \| ^ { 2 } } { 2 \sigma ^ { 2 } } \right ) . \\ \intertext { i n d t h e d s i n t y w i t h e s e c t r o d i a n t e s i n p o r a l c o d r i n d a t e s i n w h i c h e r }
$$

We wish to ﬁnd the density with respect to radius in polar coordinates in which the direction variables have been integrated out. To do this, show that the integral of the probability density over a thin shell of radius r and thickness , where 1 , is given by p ( r ) where

$$
p ( r ) & = \frac { S _ { D } r ^ { D - 1 } } { ( 2 \pi \sigma ^ { 2 } ) ^ { D / 2 } } \exp \left ( - \frac { r ^ { 2 } } { 2 \sigma ^ { 2 } } \right ) \\ \intertext { s u r f a c e a r a o f a u n i t s p h e r e i n g s u p t h e r f o w t h e f u c t i o n }
$$

where S D is the surface area of a unit sphere in D dimensions. Show that the function p ( r ) has a single stationary point located, for large D , at r √ Dσ . By considering p ( r + ) where r , show that for large D , p ( r + ) = p ( r )exp − 3 2 2 σ 2 (1.149)

$$
\epsilon \ll r , \, \text {show that for large } D , \\ p ( \widehat { r } + \epsilon ) = p ( \widehat { r } ) \exp \left ( - \frac { 3 \epsilon ^ { 2 } } { 2 \sigma ^ { 2 } } \right ) \\ \intertext { t \, r \, is \, a \, \max i m u m \, o f the r a d i a b l i g h \, o f t i l y \, d e n s i t y \, a n d \, a l s o t h a r \, d e p t ( r ) } \text {tally  away  from  its  maximum  at  } \widehat { r } \, \text { with  length  scale  } \sigma . \text {  We  have}
$$

which shows that r is a maximum of the radial probability density and also that p ( r ) decays exponentially away from its maximum at r with length scale σ . We have already seen that σ r for large D , and so we see that most of the probability mass is concentrated in a thin shell at large radius. Finally, show that the probability density p ( x ) is larger at the origin than at the radius r by a factor of exp( D/ 2) . We therefore see that most of the probability mass in a high-dimensional Gaussian distribution is located at a different radius from the region of high probability density. This property of distributions in spaces of high dimensionality will have important consequences when we consider Bayesian inference of model parameters in later chapters.

1.21 ( ) Consider two nonnegative numbers a and b , and show that, if a b , then a ( ab ) 1 / 2 . Use this result to show that, if the decision regions of a two-class classiﬁcation problem are chosen to minimize the probability of misclassiﬁcation, this probability will satisfy

$$
\text {mobility with satisfy} \\ p ( \text {mistake} ) \leqslant \int \{ p ( x , \mathcal { C } _ { 1 } ) p ( x , \mathcal { C } _ { 2 } ) \} ^ { 1 / 2 } \, d x .
$$

1.22 ( ) www Given a loss matrix with elements L kj , the expected risk is minimized if, for each x , we choose the class that minimizes (1.81). Verify that, when the loss matrix is given by L kj = 1 − I kj , where I kj are the elements of the identity matrix, this reduces to the criterion of choosing the class having the largest posterior probability. What is the interpretation of this form of loss matrix?

1.23 ( ) Derive the criterion for minimizing the expected loss when there is a general loss matrix and general prior probabilities for the classes.
