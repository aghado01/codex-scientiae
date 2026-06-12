[Page 250]

Example of a neural network having a general feed-forward topology. Note that each hidden and output unit has an associated bias parameter (omitted for clarity).

![The image depicts a diagram with a clockwise orientation. The diagram consists of a network with four interconnected nodes. Each node is connected to four other nodes, forming a network. The nodes are labeled with numbers and are connected by lines. The diagram includes a series of arrows pointing from one node to another. The arrows are colored blue and green, with the blue arrow pointing to the left and the green arrow pointing to the right. The arrows are connected to the nodes, indicating that they are part of a larger network. Here is a detailed description of the components and elements present in the image: - **Node 1**: The first node is labeled with a number 1 and is connected to the second node. - **Node 2**: The second node is labeled with a number 2 and is connected to the third node. - **Node 3**: The third node is labeled with a number 3 and is connected to the fourth node](../images/imageFile108.png)

z

2

y

x

2

2

z

outputs

inputs

1

y

x

1

1

z

3

instance, in a two-layer network these would go directly from inputs to outputs. In principle, a network with sigmoidal hidden units can always mimic skip layer connections (for bounded input values) by using a sufﬁciently small ﬁrst-layer weight that, over its operating range, the hidden unit is effectively linear, and then compensating with a large weight value from the hidden unit to the output. In practice, however, it may be advantageous to include skip-layer connections explicitly.

Furthermore, the network can be sparse, with not all possible connections within a layer being present. We shall see an example of a sparse network architecture when we consider convolutional neural networks in Section 5.5.6.

Because there is a direct correspondence between a network diagram and its mathematical function, we can develop more general network mappings by considering more complex network diagrams. However, these must be restricted to a feed-forward architecture, in other words to one having no closed directed cycles, to ensure that the outputs are deterministic functions of the inputs. This is illustrated with a simple example in Figure 5.2. Each (hidden or output) unit in such a network computes a function given by

$$
z _ { k } = h \left ( \sum _ { j } w _ { k j } z _ { j } \right ) \\ \intertext { v e r a l l u n i s t h a r d e c k i n n e s t o u n i t k ( a n d a b i a s param }
$$

where the sum runs over all units that send connections to unit k (and a bias parameter is included in the summation). For a given set of values applied to the inputs of the network, successive application of (5.10) allows the activations of all units in the network to be evaluated including those of the output units.

The approximation properties of feed-forward networks have been widely studied (Funahashi, 1989; Cybenko, 1989; Hornik et al. , 1989; Stinchecombe and White, 1989; Cotter, 1990; Ito, 1991; Hornik, 1991; Kreinovich, 1991; Ripley, 1996) and found to be very general. Neural networks are therefore said to be universal approximators . For example, a two-layer network with linear outputs can uniformly approximate any continuous function on a compact input domain to arbitrary accuracy provided the network has a sufﬁciently large number of hidden units. This result holds for a wide range of hidden unit activation functions, but excluding polynomials. Although such theorems are reassuring, the key problem is how to ﬁnd suitable parameter values given a set of training data, and in later sections of this chapter we
