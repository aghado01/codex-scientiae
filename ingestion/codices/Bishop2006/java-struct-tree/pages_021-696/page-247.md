[Page 247]

5.1. Feed-forward Network Functions

The linear models for regression and classiﬁcation discussed in Chapters 3 and 4, respectively, are based on linear combinations of ﬁxed nonlinear basis functions φj(x) and take the form

y(x,w) = f � M

wjφj(x)� (5.1)

�

j=1

where f(·) is a nonlinear activation function in the case of classiﬁcation and is the identity in the case of regression. Our goal is to extend this model by making the basis functions φj(x) depend on parameters and then to allow these parameters to be adjusted, along with the coefﬁcients {wj}, during training. There are, of course, many ways to construct parametric nonlinear basis functions. Neural networks use basis functions that follow the same form as (5.1), so that each basis function is itself a nonlinear function of a linear combination of the inputs, where the coefﬁcients in the linear combination are adaptive parameters.

This leads to the basic neural network model, which can be described a series of functional transformations. First we construct M linear combinations of the input variables x1,...,xD in the form

�D

wji(1)xi + wj(1)0 (5.2)

aj =

i=1

where j = 1,...,M, and the superscript (1) indicates that the corresponding parameters are in the ﬁrst ‘layer’ of the network. We shall refer to the parameters wji(1) as weights and the parameters wj(1)0 as biases, following the nomenclature of Chapter 3. The quantities aj are known as activations. Each of them is then transformed using a differentiable, nonlinear activation function h(·) to give

zj = h(aj). (5.3)

These quantities correspond to the outputs of the basis functions in (5.1) that, in the context of neural networks, are called hidden units. The nonlinear functions h(·) are generally chosen to be sigmoidal functions such as the logistic sigmoid or the ‘tanh’

Exercise 5.1 function. Following (5.1), these values are again linearly combined to give output unit activations

�M

wkj(2)zj + wk(2)0 (5.4)

ak =

j=1

where k = 1,...,K, and K is the total number of outputs. This transformation corresponds to the second layer of the network, and again the wk(2)0 are bias parameters. Finally, the output unit activations are transformed using an appropriate activation function to give a set of network outputs yk. The choice of activation function is determined by the nature of the data and the assumed distribution of target variables
