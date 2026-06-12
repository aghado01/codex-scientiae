[Page 248]

Figure 5.1 Network diagram for the twolayer neural network corresponding to (5.7). The input, hidden, and output variables are represented by nodes, and the weight parameters are represented by links between the nodes, in which the bias parameters are denoted by links coming from additional input and hidden variables x0 and z0. Arrows denote the direction of information ﬂow through the network during forward propagation.

xD

hidden units

zM

wMD(1)

wKM(2)

yK

inputs outputs

x1

y1

x0

z1

w10(2)

z0

and follows the same considerations as for linear models discussed in Chapters 3 and 4. Thus for standard regression problems, the activation function is the identity so that yk = ak. Similarly, for multiple binary classiﬁcation problems, each output unit activation is transformed using a logistic sigmoid function so that

yk = σ(ak) (5.5) where

1 1 + exp(−a)

σ(a) =

. (5.6)

Finally, for multiclass problems, a softmax activation function of the form (4.62) is used. The choice of output unit activation function is discussed in detail in Section 5.2.

We can combine these various stages to give the overall network function that, for sigmoidal output unit activation functions, takes the form

yk(x,w) = σ � M

wkj(2)h� D

wji(1)xi + wj(1)0 � + wk(2)0 � (5.7)

�

�

j=1

i=1

where the set of all weight and bias parameters have been grouped together into a vector w. Thus the neural network model is simply a nonlinear function from a set of input variables {xi} to a set of output variables {yk} controlled by a vector w of adjustable parameters.

This function can be represented in the form of a network diagram as shown in Figure 5.1. The process of evaluating (5.7) can then be interpreted as a forward propagation of information through the network. It should be emphasized that these diagrams do not represent probabilistic graphical models of the kind to be considered in Chapter 8 because the internal nodes represent deterministic variables rather than stochastic ones. For this reason, we have adopted a slightly different graphical
