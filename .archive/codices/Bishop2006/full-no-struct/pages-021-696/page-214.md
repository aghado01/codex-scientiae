[Page 214]

# Section 3.1.3

We now apply the stochastic gradient descent algorithm to this error function. The change in the weight vector w is then given by

$$
w ^ { ( \tau + 1 ) } = w ^ { ( \tau ) } - \eta \nabla E _ { P } ( w ) = w ^ { ( \tau ) } + \eta \phi _ { n } t _ { n }
$$

where η is the learning rate parameter and τ is an integer that indexes the steps of the algorithm. Because the perceptron function y ( x , w ) is unchanged if we multiply w by a constant, we can set the learning rate parameter η equal to 1 without of generality. Note that, as the weight vector evolves during training, the set of patterns that are misclassiﬁed will change.

The perceptron learning algorithm has a simple interpretation, as follows. We cycle through the training patterns in turn, and for each pattern x n we evaluate the perceptron function (4.52). If the pattern is correctly classiﬁed, then the weight vector remains unchanged, whereas if it is incorrectly classiﬁed, then for class C 1 we add the vector φ ( x n ) onto the current estimate of weight vector w while for class C 2 we subtract the vector φ ( x n ) from w . The perceptron learning algorithm is illustrated in Figure 4.7.

If we consider the effect of a single update in the perceptron learning algorithm, we see that the contribution to the error from a misclassiﬁed pattern will be reduced because from (4.55) we have

$$
- w ^ { ( \tau + 1 ) T } \phi _ { n } t _ { n } = - w ^ { ( \tau ) T } \phi _ { n } t _ { n } - ( \phi _ { n } t _ { n } ) ^ { T } \phi _ { n } t _ { n } < - w ^ { ( \tau ) T } \phi _ { n } t _ { n } \quad \\
$$

where we have set η = 1 , and made use of φ n t n 2 > 0 . Of course, this does not imply that the contribution to the error function from the other misclassiﬁed patterns will have been reduced. Furthermore, the change in weight vector may have caused some previously correctly classiﬁed patterns to become misclassiﬁed. Thus the perceptron learning rule is not guaranteed to reduce the total error function at each stage.

However, the perceptron convergence theorem states that if there exists an exact solution (in other words, if the training data set is linearly separable), then the perceptron learning algorithm is guaranteed to ﬁnd an exact solution in a ﬁnite number of steps. Proofs of this theorem can be found for example in Rosenblatt (1962), Block (1962), Nilsson (1965), Minsky and Papert (1969), Hertz et al. (1991), and Bishop (1995a). Note, however, that the number of steps required to achieve convergence could still be substantial, and in practice, until convergence is achieved, we will not be able to distinguish between a nonseparable problem and one that is simply slow to converge.

Even when the data set is linearly separable, there may be many solutions, and which one is found will depend on the initialization of the parameters and on the order of presentation of the data points. Furthermore, for data sets that are not linearly separable, the perceptron learning algorithm will never converge.
