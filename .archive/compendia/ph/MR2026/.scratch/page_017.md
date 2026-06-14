[Page 17]

Increasing network depth enhances the stability of the topological signal. The MLP2 row of Fig. 10 shows a smoother decay of persistent entropy and reduced variability across realizations, particularly in the low-loss regime. The strongest stabilization is observed for the convolutional architecture: the CNN row exhibits a pronounced monotone decay together with a marked collapse of variability, indicating rapid convergence of persistence diagrams toward a low-complexity limiting structure.

Neural networks: Fashion-MNIST We then consider the Fashion-MNIST dataset, which represents an intermediate-to-high complexity classification task between MNIST and CIFAR-10. Although it shares the same input dimensionality as MNIST, Fashion-MNIST exhibits substantially higher intra-class variability and weaker low-level statistical regularities.

We analyzed two multilayer perceptron architectures (MLP1 and MLP2) and a convolutional neural network (CNN), each trained on Fashion-MNIST over R = 5 independent realizations. Persistent entropy PE( H 1 ) was computed from weight-based embeddings as a function of training loss.

The Fashion-MNIST results are summarized in the third column of Fig. 10. For the shallow fully connected architecture (MLP1), persistent entropy decreases monotonically with training loss, indicating progressive topological simplification. However, the decay is slower and accompanied by broader confidence intervals than in the MNIST case, reflecting increased variability across realizations.

Increasing network depth partially compensates for this increased complexity. As shown by the MLP2 row of Fig. 10, the deeper architecture exhibits a smoother decay of persistent entropy and reduced variability, especially in the low-loss regime. A qualitatively stronger stabilization is observed for the convolutional architecture: in the CNN row, persistent entropy decreases systematically with training loss and exhibits substantially narrower confidence intervals, indicating robust convergence toward a low-complexity limiting topology induced by architectural inductive bias.

Neural networks: CIFAR-10 We finally focus on the CIFAR-10 dataset, which constitutes the most complex learning task considered in this study due to its higher input dimensionality, color structure, and nontrivial spatial correlations. This setting provides a stringent test of the topological criterion and highlights the role of inductive bias in enabling convergence toward a stable limiting topology.

The CIFAR-10 results are shown in the rightmost column of Fig. 10. For the shallow fully connected architecture (MLP1), persistent entropy does not exhibit a monotone dependence on training loss and displays wide variability across realizations. After an initial decrease, PE( H 1 ) increases again at lower loss values, indicating that different runs explore topologically inequivalent regions of parameter space and that no coherent limiting persistence diagram exists.

Increasing network depth alone does not resolve this issue. As shown in the MLP2 row of Fig. 10, variability across realizations remains large, particularly in the low-loss regime, indicating that depth without appropriate architectural constraints is insufficient to stabilize the geometry induced by learning on CIFAR-10.

A qualitatively different behavior emerges for the convolutional architecture. In the CNN row of Fig. 10, persistent entropy decreases systematically with training loss and exhibits a marked reduction in variability across realizations. This behavior indicates convergence toward a stable
