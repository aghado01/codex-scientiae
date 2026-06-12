[Page 614]

Figure 12.19 Addition of extra hidden layers of noolinear units gives an auloassocialive network which can perform a noolinear dimensiooality reduction.

TD

inputs

F,

•

F,

•

outputs

x,

non-linear

x,

X3

The situation is different, however. if additional hidden layers are pcrmillcd in the network. Consider the four-layer autoassociativc network shown in Figure 12.19. Again the output units are linear, and the M units in the second hidden layer can also be linear. however, the first and third hidden layers have sigmoidal nonlinear activation functions. The network is again trained by minimization of the error function (12.91). We can view this network as two successive functional mappings F] and F 2 , as indicated in Figure 12.19. The first mapping F] projects the original Ddimensional data onto an AI-dimensional subspace S defined by the activations of the units in the second hidden layer. Because of the presence of the first hidden layer of nonlinear units. this mapping is very general. and in particular is not restricted to being linear. Similarly. the second half of the network defines an arbitrary functional mapping from the M -dimensional space back into the original D-dimensional input space. This has a simple geometrical interpretation. as indicated for the case D = 3 and M = 2 in Figure 12.20.

Such a network effectively perfonns a nonlinear principal component analysis.

•

F,

"

F2

13

x,

"

12

12

Figure 12.20 Geometrical interpretation of the mappings performed by the network in Figure 12.1 g for the case of 0 = 3 inputs and AI = 2 units in the middle hidden layer. The function F, maps from an M-dimensional space S into a D-dimensiooal space and therefore defines the way in which the space S is embedded within the original x-space. Since the mapping F, can be r"I()(llinear, the embedding 01 S can be nonplanar, as indicated in the figure. The mapping F. then defines a projectiorl of points in the original D-dimensional space into the M -dimensional subspace S.
