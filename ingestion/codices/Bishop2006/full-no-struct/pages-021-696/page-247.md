[Page 247]

# 5.1. Feed-forward Network Functions

# Exercise 5.1

The linear models for regression and classiﬁcation discussed in Chapters 3 and 4, respectively, are based on linear combinations of ﬁxed nonlinear basis functions φ j ( x ) and take the form M

$$
y ( x , w ) = f \left ( \sum _ { j = 1 } ^ { M } w _ { j } \phi _ { j } ( x ) \right ) \\ \text {nonlinear activation function in the case of classification and is the }
$$

where f ( · ) is a nonlinear activation function in the case of classiﬁcation and is the identity in the case of regression. Our goal is to extend this model by making the basis functions φ j ( x ) depend on parameters and then to allow these parameters to be adjusted, along with the coefﬁcients { w j } , during training. There are, of course, many ways to construct parametric nonlinear basis functions. Neural networks use basis functions that follow the same form as (5.1), so that each basis function is itself a nonlinear function of a linear combination of the inputs, where the coefﬁcients in the linear combination are adaptive parameters.

This leads to the basic neural network model, which can be described a series of functional transformations. First we construct M linear combinations of the input variables x 1 ,...,x D in the form

$$
a _ { j } = \sum _ { i = 1 } ^ { D } w _ { j i } ^ { ( 1 ) } x _ { i } + w _ { j 0 } ^ { ( 1 ) } \\ \text { and the superconst } ( 1 ) \text { indicates that the corresponding permutation}
$$

where j = 1 ,...,M , and the superscript (1) indicates that the corresponding parameters are in the ﬁrst ‘layer’ of the network. We shall refer to the parameters w (1) ji as weights and the parameters w (1) j 0 as biases , following the nomenclature of Chapter 3. The quantities a j are known as activations . Each of them is then transformed using a differentiable, nonlinear activation function h ( · ) to give

$$
z _ { j } = h ( a _ { j } ) .
$$

These quantities correspond to the outputs of the basis functions in (5.1) that, in the context of neural networks, are called hidden units . The nonlinear functions h ( · ) are generally chosen to be sigmoidal functions such as the logistic sigmoid or the ‘ tanh ’ function. Following (5.1), these values are again linearly combined to give output unit activations M

$$
a _ { k } = \sum _ { j = 1 } ^ { M } w _ { k j } ^ { ( 2 ) } z _ { j } + w _ { k 0 } ^ { ( 2 ) } \\ \text {, and } K \text { is the total number of outputs. This transformation cor-}
$$

where k = 1 ,...,K , and K is the total number of outputs. This transformation corresponds to the second layer of the network, and again the w (2) k 0 are bias parameters. Finally, the output unit activations are transformed using an appropriate activation function to give a set of network outputs y k . The choice of activation function is determined by the nature of the data and the assumed distribution of target variables
