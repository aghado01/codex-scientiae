[Page 614]

![Figure 12.19](../images/imageFile151.png)

Figure 12.19 Addition of extra hidden layers of nonlinear units gives an autoassociative network which can perform a nonlinear dimensionality reduction.

The situation is different, however, if additional hidden layers are permitted in the network. Consider the four-layer autoassociative network shown in Figure 12.19. Again the output units are linear, and the $M$ units in the second hidden layer can also be linear, however, the ﬁrst and third hidden layers have sigmoidal nonlinear activation functions. The network is again trained by minimization of the error function (12.91). We can view this network as two successive functional mappings $F_1$ and $F_2$, as indicated in Figure 12.19. The ﬁrst mapping $F_1$ projects the original $D$-dimensional data onto an $M$-dimensional subspace $S$ deﬁned by the activations of the units in the second hidden layer. Because of the presence of the ﬁrst hidden layer of nonlinear units, this mapping is very general, and in particular is not restricted to being linear. Similarly, the second half of the network deﬁnes an arbitrary functional mapping from the $M$-dimensional space back into the original $D$-dimensional input space. This has a simple geometrical interpretation, as indicated for the case $D = 3$ and $M = 2$ in Figure 12.20.

Such a network effectively performs a nonlinear principal component analysis.

![Figure 12.20](../images/imageFile151.png)

Figure 12.20 Geometrical interpretation of the mappings performed by the network in Figure 12.19 for the case of $D = 3$ inputs and $M = 2$ units in the middle hidden layer. The function $F_1$ maps from an $M$-dimensional space $S$ into a $D$-dimensional space and therefore deﬁnes the way in which the space $S$ is embedded within the original $\mathbf{x}$-space. Since the mapping $F_1$ can be nonlinear, the embedding of $S$ can be nonplanar, as indicated in the ﬁgure. The mapping $F_2$ then deﬁnes a projection of points in the original $D$-dimensional space into the $M$-dimensional subspace $S$.
