[Page 83]

###### 1.20 ( ) www In this exercise, we explore the behaviour of the Gaussian distribution in high-dimensional spaces. Consider a Gaussian distribution in D dimensions given by

1 (2πσ2)D/2

x 2 2σ2

p(x) =

exp −

. (1.147)

We wish to ﬁnd the density with respect to radius in polar coordinates in which the direction variables have been integrated out. To do this, show that the integral of the probability density over a thin shell of radius r and thickness , where 1, is given by p(r) where

SDrD−1 (2πσ2)D/2

r2 2σ2

p(r) =

exp −

(1.148)

where SD is the surface area of a unit sphere in D dimensions. Show that the function p(r) has a single stationary point located, for large D, at r

√

Dσ. By considering p( r + ) where r, show that for large D,

3 2 2σ2

p( r + ) = p( r)exp −

(1.149)

which shows that r is a maximum of the radial probability density and also that p(r) decays exponentially away from its maximum at r with length scale σ. We have already seen that σ r for large D, and so we see that most of the probability mass is concentrated in a thin shell at large radius. Finally, show that the probability density p(x) is larger at the origin than at the radius r by a factor of exp(D/2). We therefore see that most of the probability mass in a high-dimensional Gaussian distribution is located at a different radius from the region of high probability density. This property of distributions in spaces of high dimensionality will have important consequences when we consider Bayesian inference of model parameters in later chapters.

###### 1.21 ( ) Consider two nonnegative numbers a and b, and show that, if a b, then a (ab)1/2. Use this result to show that, if the decision regions of a two-class classiﬁcation problem are chosen to minimize the probability of misclassiﬁcation, this probability will satisfy

p(mistake) {p(x,C1)p(x,C2)}1/2 dx. (1.150)

###### 1.22 ( ) www Given a loss matrix with elements Lkj, the expected risk is minimized if, for each x, we choose the class that minimizes (1.81). Verify that, when the

loss matrix is given by Lkj = 1 − Ikj, where Ikj are the elements of the identity matrix, this reduces to the criterion of choosing the class having the largest posterior probability. What is the interpretation of this form of loss matrix?

###### 1.23 ( ) Derive the criterion for minimizing the expected loss when there is a general loss matrix and general prior probabilities for the classes.
