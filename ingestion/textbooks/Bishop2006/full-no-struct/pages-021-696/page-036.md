[Page 36]

![The image is a bar chart titled Y=1 with four different categories represented by blue bars. The x-axis is labeled Y and the y-axis is labeled P(X). The bars are color-coded to represent different values of P(X). ### Description of the Bar Chart: - **Y-Axis (X-Axis)**: The x-axis is labeled Y and the y-axis is labeled P(X). - **Bars**: There are four different categories represented by blue bars: - **X**: The category labeled x - **Y**: The category labeled y - **P(X)**: The category labeled P(X) ### Analysis: - **Bars Color Coding**: The bars are color-coded to represent different values of P(X). The colors are blue for x and red for y. - **](../images/imageFile14.png)

p

(

Y

)

p

(

X,Y )

)

Y

= 2

Y

= 1

X

|

p

(

X

Y

= 1)

p

(

X

)

X

X

Figure 1.11 An illustration of a distribution over two variables, X , which takes 9 possible values, and Y , which takes two possible values. The top left ﬁgure shows a sample of 60 points drawn from a joint probability distribution over these variables. The remaining ﬁgures show histogram estimates of the marginal distributions p ( X ) and p ( Y ) , as well as the conditional distribution p ( X | Y = 1) corresponding to the bottom row in the top left ﬁgure.

Again, note that these probabilities are normalized so that

$$
p ( F = a | B = r ) + p ( F = o | B = r ) = 1
$$

and similarly Suppose instead we are told that a piece of fruit has been selected and it is an orange, and we would like to know which box it came from. This requires that we evaluate the probability distribution over boxes conditioned on the identity of the fruit, whereas the probabilities in (1.16)-(1.19) give the probability distribution over the fruit conditioned on the identity of the box. We can solve the problem of reversing the conditional probability by using Bayes' theorem to give

$$
p ( F = a | B = b ) + p ( F = o | B = b ) & = 1 . \\ \\ p ( 1 ) & = 1 . 1 - 1 . 1 - 1 . 1 - 1 . 1 - 1 . 1 - 1 . 1 .
$$

We can now use the sum and product rules of probability to evaluate the overall probability of choosing an apple

$$
p ( F = a ) \ & = \ p ( F = a | B = r ) p ( B = r ) + p ( F = a | B = b ) p ( B = b ) \\ & = \ \frac { 1 } { 4 } \times \frac { 4 } { 1 0 } + \frac { 3 } { 4 } \times \frac { 6 } { 1 0 } = \frac { 1 1 } { 2 0 }
$$

from which it follows, using the sum rule, that p ( F = o ) = 1 − 11 / 20 = 9 / 20 .
