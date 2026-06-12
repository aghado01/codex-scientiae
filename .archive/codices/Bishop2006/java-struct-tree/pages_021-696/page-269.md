[Page 269]

activations of all of the hidden and output units in the network. Next, for each row k of the Jacobian matrix, corresponding to the output unit k, backpropagate using the recursive relation (5.74), starting with (5.75) or (5.76), for all of the hidden units in the network. Finally, use (5.73) to do the backpropagation to the inputs. The Jacobian can also be evaluated using an alternative forward propagation formalism, which can be derived in an analogous way to the backpropagation approach given

Exercise 5.15 here.

Again, the implementation of such algorithms can be checked by using numerical differentiation in the form

yk(xi + �) − yk(xi − �) 2�

∂yk ∂xi

+ O(�2) (5.77) which involves 2D forward propagations for a network having D inputs.

=

5.4. The Hessian Matrix

We have shown how the technique of backpropagation can be used to obtain the ﬁrst derivatives of an error function with respect to the weights in the network. Backpropagation can also be used to evaluate the second derivatives of the error, given by

∂2E ∂wji∂wlk

. (5.78)

Note that it is sometimes convenient to consider all of the weight and bias parameters as elements wi of a single vector, denoted w, in which case the second derivatives form the elements Hij of the Hessian matrix H, where i,j ∈ {1,...,W} and W is the total number of weights and biases. The Hessian plays an important role in many aspects of neural computing, including the following:

1. Several nonlinear optimization algorithms used for training neural networks are based on considerations of the second-order properties of the error surface, which are controlled by the Hessian matrix (Bishop and Nabney, 2008).

2. The Hessian forms the basis of a fast procedure for re-training a feed-forward network following a small change in the training data (Bishop, 1991).

3. The inverse of the Hessian has been used to identify the least signiﬁcant weights in a network as part of network ‘pruning’ algorithms (Le Cun et al., 1990).

4. The Hessian plays a central role in the Laplace approximation for a Bayesian neural network (see Section 5.7). Its inverse is used to determine the predictive distribution for a trained network, its eigenvalues determine the values of hyperparameters, and its determinant is used to evaluate the model evidence.

Various approximation schemes have been used to evaluate the Hessian matrix for a neural network. However, the Hessian can also be calculated exactly using an extension of the backpropagation technique.
