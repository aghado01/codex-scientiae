[Page 276]

and acting on these with the R{·} operator, we obtain expressions for the elements of the vector vTH

R

R

∂E ∂wkj

∂E ∂wji

= R{δk}zj + δkR{zj} (5.110)

= xiR{δj}. (5.111)

The implementation of this algorithm involves the introduction of additional variables R{aj}, R{zj} and R{δj} for the hidden units and R{δk} and R{yk} for the output units. For each input pattern, the values of these quantities can be found using the above results, and the elements of vTH are then given by (5.110) and (5.111). An elegant aspect of this technique is that the equations for evaluating vTH mirror closely those for standard forward and backward propagation, and so the extension of existing software to compute this product is typically straightforward.

If desired, the technique can be used to evaluate the full Hessian matrix by choosing the vector v to be given successively by a series of unit vectors of the form (0,0,...,1,...,0) each of which picks out one column of the Hessian. This leads to a formalism that is analytically equivalent to the backpropagation procedure of Bishop (1992), as described in Section 5.4.5, though with some loss of efﬁciency due to redundant calculations.

###### 5.5. Regularization in Neural Networks

The number of input and outputs units in a neural network is generally determined by the dimensionality of the data set, whereas the number M of hidden units is a free parameter that can be adjusted to give the best predictive performance. Note that M controls the number of parameters (weights and biases) in the network, and so we might expect that in a maximum likelihood setting there will be an optimum value of M that gives the best generalization performance, corresponding to the optimum balance between under-ﬁtting and over-ﬁtting. Figure 5.9 shows an example of the effect of different values of M for the sinusoidal regression problem.

The generalization error, however, is not a simple function of M due to the presence of local minima in the error function, as illustrated in Figure 5.10. Here we see the effect of choosing multiple random initializations for the weight vector for a range of values of M. The overall best validation set performance in this case occurred for a particular solution having M = 8. In practice, one approach to choosing M is in fact to plot a graph of the kind shown in Figure 5.10 and then to choose the speciﬁc solution having the smallest validation set error.

There are, however, other ways to control the complexity of a neural network model in order to avoid over-ﬁtting. From our discussion of polynomial curve ﬁtting in Chapter 1, we see that an alternative approach is to choose a relatively large value for M and then to control complexity by the addition of a regularization term to the error function. The simplest regularizer is the quadratic, giving a regularized error
