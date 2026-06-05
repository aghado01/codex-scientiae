[Page 248]

Figure 5.1 Network diagram for the twolayer neural network corresponding to (5.7). The input, hidden, and output variables are represented by nodes, and the weight parameters are represented by links between the nodes, in which the bias parameters are denoted by links coming from additional input and hidden variables x 0 and z 0 . Arrows denote the direction of information ﬂow through the network during forward propagation.

![In the image there is a diagram with a line diagram. The diagram consists of a circle and a line. The line is labeled as W and M. The circle is labeled as W and M. The line is labeled as W and M. The diagram is labeled as W and M.](../images/imageFile107.png)

hidden units

z

M

w (1)

w

MD

(2)

w

KM

x

D

y

K

outputs

inputs

y

1

x

1

z

(2)

1

w

10

x

0

z

0

and follows the same considerations as for linear models discussed in Chapters 3 and 4. Thus for standard regression problems, the activation function is the identity so that y k = a k . Similarly, for multiple binary classiﬁcation problems, each output unit activation is transformed using a logistic sigmoid function so that

$$
y _ { k } = \sigma ( a _ { k } )
$$

where

$$
\sigma ( a ) = \frac { 1 } { 1 + \exp ( - a ) } . \\ \text {class problems. a softmax activation function of the form (4.62)}
$$

Finally, for multiclass problems, a softmax activation function of the form (4.62) is used. The choice of output unit activation function is discussed in detail in Section 5.2.

We can combine these various stages to give the overall network function that, for sigmoidal output unit activation functions, takes the form

$$
\text {for sigma} \text {dar output unit activation functions, takes the form} \\ y _ { k } ( x , w ) = \sigma \left ( \sum _ { j = 1 } ^ { M } w _ { k j } ^ { ( 2 ) } h \left ( \sum _ { i = 1 } ^ { D } w _ { j i } ^ { ( 1 ) } x _ { i } + w _ { j 0 } ^ { ( 1 ) } \right ) + w _ { k 0 } ^ { ( 2 ) } \right ) \\ \text {where the set of all weight and bias parameters have been grouped together into a}
$$

where the set of all weight and bias parameters have been grouped together into a vector w . Thus the neural network model is simply a nonlinear function from a set of input variables { x i } to a set of output variables { y k } controlled by a vector w of adjustable parameters.

This function can be represented in the form of a network diagram as shown in Figure 5.1. The process of evaluating (5.7) can then be interpreted as a forward propagation of information through the network. It should be emphasized that these diagrams do not represent probabilistic graphical models of the kind to be considered in Chapter 8 because the internal nodes represent deterministic variables rather than stochastic ones. For this reason, we have adopted a slightly different graphical
