[Page 280]

![The image is a scatter plot with five different lines plotted on it. The x-axis is labeled as a and the y-axis is labeled as b. The lines are all different colors and are plotted on the graph. The x-axis is labeled as a and the y-axis is labeled as b. The lines are all connected and show a pattern of increasing and decreasing values. The lines are all different colors, but they all have the same pattern.](../images/imageFile117.png)

w

b

w

b

w

b

w

b

α

= 1,

α

= 1,

α

= 1,

α

= 1

α

= 1,

α

= 1,

α

= 10,

α

= 1

1

1

2

2

1

1

2

2

4

40

2

20

0

0

−2

−20

−4

−40

-6

-60

-1

−0.5

0

0.5

1

-1

−0.5

0

0.5

1

w

b

w

b

w

b

w

b

α

= 1000,

α

= 100,

α

= 1,

α

= 1

α

= 1000,

α

= 1000,

α

= 1,

α

= 1

1

1

2

2

1

1

2

2

5

5

0

0

−5

−5

-10

-10

-1

−0.5

0

0.5

1

-1

−0.5

0

0.5

1

Figure 5.11 Illustration of the effect of the hyperparameters governing the prior distribution over weights and biases in a two-layer network having a single input, a single linear output, and 12 hidden units having ‘ tanh ’ activation functions. The priors are governed by four hyperparameters α b 1 , α w 1 , α b 2 , and α w 2 , which represent the precisions of the Gaussian distributions of the ﬁrst-layer biases, ﬁrst-layer weights, second-layer biases, and second-layer weights, respectively. We see that the parameter α w 2 governs the vertical scale of functions (note the different vertical axis ranges on the top two diagrams), α w 1 governs the horizontal scale of variations in the function values, and α b 1 governs the horizontal range over which variations occur. The parameter α b 2 , whose effect is not illustrated here, governs the range of vertical offsets of the functions.

In the case of a quadratic error function, we can verify this insight, and show that early stopping should exhibit similar behaviour to regularization using a simple weight-decay term. This can be understood from Figure 5.13, in which the axes in weight space have been rotated to be parallel to the eigenvectors of the Hessian matrix. If, in the absence of weight decay, the weight vector starts at the origin and proceeds during training along a path that follows the local negative gradient vector, then the weight vector will move initially parallel to the w 2 axis through a point corresponding roughly to w and then move towards the minimum of the error function w ML . This follows from the shape of the error surface and the widely differing eigenvalues of the Hessian. Stopping at a point near w is therefore similar to weight decay. The relationship between early stopping and weight decay can be made quantitative, thereby showing that the quantity τη (where τ is the iteration index, and η is the learning rate parameter) plays the role of the reciprocal of the regularization
