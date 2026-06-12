[Page 251]

Figure 5.3 Illustration of the capability of a multilayer perceptron to approximate four different functions comprising (a) f(x) = x2, (b) f(x) = sin(x), (c), f(x) = |x|, and (d) f(x) = H(x) where H(x) is the Heaviside step function. In each case, N = 50 data points, shown as blue dots, have been sampled uniformly in x over the interval (−1, 1) and the corresponding values of f(x) evaluated. These data points are then used to train a twolayer network having 3 hidden units with ‘tanh’ activation functions and linear output units. The resulting network functions are shown by the red curves, and the outputs of the three hidden units are shown by the three dashed curves.

(a) (b)

(c) (d)

will show that there exist effective solutions to this problem based on both maximum likelihood and Bayesian approaches.

The capability of a two-layer network to model a broad range of functions is illustrated in Figure 5.3. This ﬁgure also shows how individual hidden units work collaboratively to approximate the ﬁnal function. The role of hidden units in a simple classiﬁcation problem is illustrated in Figure 5.4 using the synthetic classiﬁcation data set described in Appendix A.

5.1.1 Weight-space symmetries

One property of feed-forward networks, which will play a role when we consider Bayesian model comparison, is that multiple distinct choices for the weight vector w can all give rise to the same mapping function from inputs to outputs (Chen et al., 1993). Consider a two-layer network of the form shown in Figure 5.1 with M hidden units having ‘tanh’ activation functions and full connectivity in both layers. If we change the sign of all of the weights and the bias feeding into a particular hidden unit, then, for a given input pattern, the sign of the activation of the hidden unit will be reversed, because ‘tanh’ is an odd function, so that tanh(−a) = −tanh(a). This transformation can be exactly compensated by changing the sign of all of the weights leading out of that hidden unit. Thus, by changing the signs of a particular group of weights (and a bias), the input–output mapping function represented by the network is unchanged, and so we have found two different weight vectors that give rise to the same mapping function. For M hidden units, there will be M such ‘sign-ﬂip’
