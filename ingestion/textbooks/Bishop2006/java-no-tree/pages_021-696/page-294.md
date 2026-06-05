[Page 294]

xD

θM

x1

θ1

p(t|x)

###### θ

t

Figure 5.20 The mixture density networkcan represent general conditional probability densities p(t|x) by considering a parametric mixture model for the distribution of t whose parameters are determined by the outputs of a neural network that takes x as its input vector.

the outputs of a conventional neural network that takes x as its input. The structure of this mixture density network is illustrated in Figure 5.20. The mixture density network is closely related to the mixture of experts discussed in Section 14.5.3. The principle difference is that in the mixture density network the same function is used to predict the parameters of all of the component densities as well as the mixing coefﬁcients, and so the nonlinear hidden units are shared amongst the input-dependent functions.

The neural network in Figure 5.20 can, for example, be a two-layer network having sigmoidal (‘tanh’) hidden units. If there are L components in the mixture model (5.148), and if t has K components, then the network will have L output unit activations denoted by aπk that determine the mixing coefﬁcients πk(x), K outputs denoted by aσk that determine the kernel widths σk(x), and L × K outputs denoted by aµkj that determine the components µkj(x) of the kernel centres µk(x). The total number of network outputs is given by (K + 2)L, as compared with the usual K outputs for a network, which simply predicts the conditional means of the target variables.

The mixing coefﬁcients must satisfy the constraints

###### K

πk(x) = 1, 0 πk(x) 1 (5.149)

k=1

which can be achieved using a set of softmax outputs

exp(aπk) K l=1 exp(aπl )

πk(x) =

. (5.150)

Similarly, the variances must satisfy σk2(x) 0 and so can be represented in terms of the exponentials of the corresponding network activations using

σk(x) = exp(aσk). (5.151) Finally, because the means µk(x) have real components, they can be represented
