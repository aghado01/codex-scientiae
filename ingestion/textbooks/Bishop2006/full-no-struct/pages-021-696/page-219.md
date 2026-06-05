[Page 219]

![The image is a bar chart that shows the values of two variables, labeled x and y. The x-axis is labeled x and the y-axis is labeled y. The chart is divided into two sections, each labeled 1 and 1.1. The x-axis is labeled x and the y-axis is labeled y. The chart has a legend at the bottom right corner that indicates the values of x and y. ### Description of the Chart: - **Title**: The title of the chart is x and y. - **X-Axis**: The x-axis is labeled x and is marked with intervals of 0.0. - **Y-Axis**: The y-axis is labeled y and is marked with intervals of 0.1. - **Legend**: The legend at the bottom right corner of the chart indicates the values of](../images/imageFile22.png)

0.4

0.3

0.2

0.1

0

0.8

0.6

0.4

0.2

0

Figure 4.10 The left-hand plot shows the class-conditional densities for two classes, denoted red and blue. On the right is the corresponding posterior probability p ( C 1 | x ) , which is given by a logistic sigmoid of a linear function of x . The surface in the right-hand plot is coloured using a proportion of red ink given by p ( C 1 | x ) and a proportion of blue ink given by p ( C 2 | x ) = 1 − p ( C 1 | x ) .

For the general case of K classes we have, from (4.62) and (4.63),

$$
a _ { k } ( x ) = w _ { k } ^ { T } x + w _ { k 0 }
$$

where we have deﬁned

$$
w _ { k } \ = \ \Sigma ^ { - 1 } \mu _ { k }
$$

$$
w _ { k 0 } \ = \ - \frac { 1 } { 2 } \mu _ { k } ^ { \text {T} } \Sigma ^ { - 1 } \mu _ { k } + \ln p ( \mathcal { C } _ { k } ) .
$$

We see that the a k ( x ) are again linear functions of x as a consequence of the cancellation of the quadratic terms due to the shared covariances. The resulting decision boundaries, corresponding to the minimum misclassiﬁcation rate, will occur when two of the posterior probabilities (the two largest) are equal, and so will be deﬁned by linear functions of x , and so again we have a generalized linear model.

If we relax the assumption of a shared covariance matrix and allow each classconditional density p ( x |C k ) to have its own covariance matrix Σ k , then the earlier cancellations will no longer occur, and we will obtain quadratic functions of x , giving rise to a quadratic discriminant . The linear and quadratic decision boundaries are illustrated in Figure 4.11.
