[Page 280]

###### αw1 = 1, α1b = 1, αw2 = 1, α2b = 1

###### αw1 = 1, α1b = 1, αw2 = 10, α2b = 1

4

40

| |
|---|


| |
|---|


2

20

0

0

- −1 −0.5 0 0.5 1

−6

−4

- −2


−20

−40

−60

−1 −0.5 0 0.5 1

###### αw1 = 1000, α1b = 100, αw2 = 1, α2b = 1

###### αw1 = 1000, α1b = 1000, αw2 = 1, α2b = 1

5

5

| |
|---|


| |
|---|


0

0

−5

−5

−10

−10

−1 −0.5 0 0.5 1

−1 −0.5 0 0.5 1

- Figure 5.11 Illustration of the effect of the hyperparameters governing the prior distribution over weights and biases in a two-layer network having a single input, a single linear output, and 12 hidden units having ‘tanh’


activation functions. The priors are governed by four hyperparameters α1b, α1w, α2b, and α2w, which represent the precisions of the Gaussian distributions of the ﬁrst-layer biases, ﬁrst-layer weights, second-layer biases, and

second-layer weights, respectively. We see that the parameter α2w governs the vertical scale of functions (note the different vertical axis ranges on the top two diagrams), α1w governs the horizontal scale of variations in the function values, and α1b governs the horizontal range over which variations occur. The parameter α2b, whose effect is not illustrated here, governs the range of vertical offsets of the functions.

a minimum of the training error has been reached then represents a way of limiting the effective network complexity.

In the case of a quadratic error function, we can verify this insight, and show that early stopping should exhibit similar behaviour to regularization using a simple weight-decay term. This can be understood from Figure 5.13, in which the axes in weight space have been rotated to be parallel to the eigenvectors of the Hessian matrix. If, in the absence of weight decay, the weight vector starts at the origin and proceeds during training along a path that follows the local negative gradient vector, then the weight vector will move initially parallel to the w2 axis through a point corresponding roughly to w and then move towards the minimum of the error function wML. This follows from the shape of the error surface and the widely differing eigenvalues of the Hessian. Stopping at a point near w is therefore similar to weight decay. The relationship between early stopping and weight decay can be made quan-

- Exercise 5.25 titative, thereby showing that the quantity τη (where τ is the iteration index, and η is the learning rate parameter) plays the role of the reciprocal of the regularization
