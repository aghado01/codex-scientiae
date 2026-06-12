[Page 294]

![The image depicts a diagram of a network, specifically a graph. The graph consists of a set of interconnected nodes, each connected to the others. The nodes are connected by lines, which are represented by circles. The nodes are connected by arrows, which indicate the direction of the flow of data or information. The graph is labeled as p(t|x), which stands for p(t|x) is the probability of the event occurring. This means that the probability of an event occurring is given by the probability of the event occurring in the event. The diagram is labeled as follows: - The nodes are labeled as follows: - A - B - C - D - E - F - G - H - I - J - K - L - M - N - O - P - Q - R - S - T - U - V](../images/imageFile126.png)

Figure 5.20 The mixture density network can represent general conditional probability densities $p(\mathbf{t}|\mathbf{x})$ by considering a parametric mixture model for the distribution of $\mathbf{t}$ whose parameters are determined by the outputs of a neural network that takes $\mathbf{x}$ as its input vector.

the outputs of a conventional neural network that takes $\mathbf{x}$ as its input. The structure of this mixture density network is illustrated in Figure 5.20. The mixture density network is closely related to the mixture of experts discussed in Section 14.5.3. The principle difference is that in the mixture density network the same function is used to predict the parameters of all of the component densities as well as the mixing coefficients, and so the nonlinear hidden units are shared amongst the input-dependent functions.

The neural network in Figure 5.20 can, for example, be a two-layer network having sigmoidal ('tanh') hidden units. If there are $L$ components in the mixture model (5.148), and if $\mathbf{t}$ has $K$ components, then the network will have $L$ output unit activations denoted by $a_k^\pi$ that determine the mixing coefficients $\pi_k(\mathbf{x})$, $K$ outputs denoted by $a_k^\sigma$ that determine the kernel widths $\sigma_k(\mathbf{x})$, and $L \times K$ outputs denoted by $a_{kj}^\mu$ that determine the components $\mu_{kj}(\mathbf{x})$ of the kernel centres $\boldsymbol{\mu}_k(\mathbf{x})$. The total number of network outputs is given by $(K + 2)L$, as compared with the usual $K$ outputs for a network, which simply predicts the conditional means of the target variables.

The mixing coefficients must satisfy the constraints

$$
\sum_{k=1}^K \pi_k(\mathbf{x}) = 1, \quad 0 \leqslant \pi_k(\mathbf{x}) \leqslant 1 \tag{5.149}
$$

which can be achieved using a set of softmax outputs

$$
\pi_k(\mathbf{x}) = \frac{\exp(a_k^\pi)}{\sum_{l=1}^K \exp(a_l^\pi)} . \tag{5.150}
$$

Similarly, the variances must satisfy $\sigma_k^2(\mathbf{x}) \geqslant 0$ and so can be represented in terms of the exponentials of the corresponding network activations using

$$
\sigma_k(\mathbf{x}) = \exp(a_k^\sigma) . \tag{5.151}
$$

Finally, because the means $\boldsymbol{\mu}_k(\mathbf{x})$ have real components, they can be represented
