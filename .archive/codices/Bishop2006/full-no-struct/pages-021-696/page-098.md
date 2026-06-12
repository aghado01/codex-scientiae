[Page 98]

![The image consists of three panels. Each panel contains a geometric shape and a text. The geometric shapes are a square, a triangle, and a circle. The text is written in a different color. The text is written in a different font. The background of the image is white.](../images/imageFile12.png)

Figure 2.5 Plots of the Dirichlet distribution over three variables, where the two horizontal axes are coordinates in the plane of the simplex and the vertical axis corresponds to the value of the density. Here { α k } = 0 . 1 on the left plot, { α k } = 1 in the centre plot, and { α k } = 10 in the right plot.

modelled using the binomial distribution (2.9) or as 1-of-2 variables and modelled using the multinomial distribution (2.34) with K = 2 .

# 2.3. The Gaussian Distribution

Section 1.6

Exercise 2.14

The Gaussian, also known as the normal distribution, is a widely used model for the distribution of continuous variables. In the case of a single variable x , the Gaussian distribution can be written in the form

$$
\text {bution can be written in the form} \\ \mathcal { N } ( x | \mu , \sigma ^ { 2 } ) = \frac { 1 } { ( 2 \pi \sigma ^ { 2 } ) ^ { 1 / 2 } } \exp \left \{ - \frac { 1 } { 2 \sigma ^ { 2 } } ( x - \mu ) ^ { 2 } \right \} \\
$$

where µ is the mean and σ 2 is the variance. For a D -dimensional vector x , the multivariate Gaussian distribution takes the form

$$
\text {multivariate Gaussian distribution takes the form} \\ \mathcal { N } ( x | \mu , \Sigma ) = \frac { 1 } { ( 2 \pi ) ^ { D / 2 } } \frac { 1 } { | \Sigma | ^ { 1 / 2 } } \exp \left \{ - \frac { 1 } { 2 } ( x - \mu ) ^ { T } \Sigma ^ { - 1 } ( x - \mu ) \right \} \\ \\ \text {where } \mu \text { is a 2-D diagonal moment.} \, \text {so} \, \Sigma \text { is a 2-D 2-overunion} \, \Pi \, \text { and } \, | \Sigma |
$$

where µ is a D -dimensional mean vector, Σ is a D × D covariance matrix, and | Σ | denotes the determinant of Σ .

The Gaussian distribution arises in many different contexts and can be motivated from a variety of different perspectives. For example, we have already seen that for a single real variable, the distribution that maximizes the entropy is the Gaussian. This property applies also to the multivariate Gaussian.

Another situation in which the Gaussian distribution arises is when we consider the sum of multiple random variables. The central limit theorem (due to Laplace) tells us that, subject to certain mild conditions, the sum of a set of random variables, which is of course itself a random variable, has a distribution that becomes increasingly Gaussian as the number of terms in the sum increases (Walker, 1969). We can
