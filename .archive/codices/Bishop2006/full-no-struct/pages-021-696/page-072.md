[Page 72]

![The image is a bar chart titled probabilities. The chart is divided into two main sections: the x-axis and the y-axis. The x-axis is labeled probabilities and the y-axis is labeled probabilities. The chart has two categories, H and H - 1.77, with a range of 0.25 to 0.55. The y-axis is labeled probabilities and has a scale of range 0.0 to 0.55. The y-axis is labeled probabilities and has a scale of range 0.0 to 0.55. The chart has two sets of bars, one for each category. The first set of bars is labeled H and the second set of bars is labeled H - 1.77. The values of the bars for each category are as follows: - H](../images/imageFile34.png)

0.5

0.5

H = 1.77

H = 3.09

probabilities

probabilities

0.25

0.25

0

0

Figure 1.30 Histograms of two probability distributions over 30 bins illustrating the higher value of the entropy H for the broader distribution. The largest entropy would arise from a uniform distribution that would give H = − ln(1 / 30) = 3 . 40 .

Exercise 1.29

from which we ﬁnd that all of the p ( x i ) are equal and are given by p ( x i ) = 1 /M where M is the total number of states x i . The corresponding value of the entropy is then H = ln M . This result can also be derived from Jensen’s inequality (to be discussed shortly). To verify that the stationary point is indeed a maximum, we can evaluate the second derivative of the entropy, which gives

$$
\frac { \partial \widetilde { H } } { \partial p ( x _ { i } ) \partial p ( x _ { j } ) } = - I _ { i j } \frac { 1 } { p _ { i } } \\ \text {elements of the identity matrix.}
$$

where I ij are the elements of the identity matrix. We can extend the deﬁnition of entropy to

include distributions p ( x ) over continuous variables x as follows. First divide x into bins of width ∆ . Then, assuming p ( x ) is continuous, the mean value theorem (Weisstein, 1999) tells us that, for each such bin, there must exist a value x i such that

$$
\int _ { i \Delta } ^ { ( i + 1 ) \Delta } p ( x ) \, d x & = p ( x _ { i } ) \Delta . & ( 1 . 1 0 1 ) \\ \intertext { t i z e } \int _ { \ } \text {continuous variable } x \, \text {by assigning any value } x \, \text {to the value }
$$

We can now quantize the continuous variable x by assigning any value x to the value x i whenever x falls in the i th bin. The probability of observing the value x i is then p ( x i )∆ . This gives a discrete distribution for which the entropy takes the form

$$
p ( x _ { i } ) \Delta \colon & \text {Im} \ g r e s \ A \text { discrete} \ \text {assumation} \ \text {for} \ \text {when} \ \text {the} \ \text {big} \ \text {cycles} \ \text {and} \ \text {if} \ \text { } H _ { \Delta } \ \text { } = - \sum _ { i } p ( x _ { i } ) \Delta \ln \left ( p ( x _ { i } ) \Delta \ln p ( x _ { i } ) - \ln \Delta \right ) \quad ( 1 . 1 0 2 ) \\ & \text { } H _ { \Delta } = - \sum _ { i } p ( x _ { i } ) \Delta \ln \left ( p ( x _ { i } ) \Delta \right ) = - \sum _ { i } p ( x _ { i } ) \Delta \ln p ( x _ { i } ) - \ln \Delta \quad ( 1 . 1 0 2 ) \\ & \text {where} \ \text { we have used} \ \sum _ { i } p ( x _ { i } ) \Delta \, - \, 1 \, \text { which follows from} \ ( 1 . 1 0 1 ) \ \text { We now omit}
$$

i i where we have used i p ( x i )∆ = 1 , which follows from (1.101). We now omit the second term − ln∆ on the right-hand side of (1.102) and then consider the limit
