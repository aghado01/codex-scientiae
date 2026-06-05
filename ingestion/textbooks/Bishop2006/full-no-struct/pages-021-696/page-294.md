[Page 294]

![The image depicts a diagram of a network, specifically a graph. The graph consists of a set of interconnected nodes, each connected to the others. The nodes are connected by lines, which are represented by circles. The nodes are connected by arrows, which indicate the direction of the flow of data or information. The graph is labeled as p(t|x), which stands for p(t|x) is the probability of the event occurring. This means that the probability of an event occurring is given by the probability of the event occurring in the event. The diagram is labeled as follows: - The nodes are labeled as follows: - A - B - C - D - E - F - G - H - I - J - K - L - M - N - O - P - Q - R - S - T - U - V](../images/imageFile126.png)

|

p

(

t

)

x

x

θ

D

M

θ

x

θ

1

1

t

Figure 5.20 The mixture density network can represent general conditional probability densities p ( t | x ) by considering a parametric mixture model for the distribution of t whose parameters are determined by the outputs of a neural network that takes x as its input vector.

The neural network in Figure 5.20 can, for example, be a two-layer network having sigmoidal (‘ tanh ’) hidden units. If there are L components in the mixture model (5.148), and if t has K components, then the network will have L output unit activations denoted by a π k that determine the mixing coefﬁcients π k ( x ) , K outputs denoted by a σ k that determine the kernel widths σ k ( x ) , and L × K outputs denoted by a µ kj that determine the components µ kj ( x ) of the kernel centres µ k ( x ) . The total number of network outputs is given by ( K + 2) L , as compared with the usual K outputs for a network, which simply predicts the conditional means of the target variables.

The mixing coefﬁcients must satisfy the constraints

$$
\sum _ { k = 1 } ^ { K } \pi _ { k } ( x ) = 1 , \quad 0 \leqslant \pi _ { k } ( x ) \leqslant 1 \\ \intertext { e a c h i v e d u s i n g a s e t o f s o f t a x $ p a r t u s $ }
$$

which can be achieved using a set of softmax outputs

$$
\pi _ { k } ( x ) = \frac { \exp ( a _ { k } ^ { \pi } ) } { \sum _ { l = 1 } ^ { K } \exp ( a _ { l } ^ { \pi } ) } . \\ \intertext { c h e n s u m s t a s i f y o d i s ( x ) \geqslant 0 a n d s o c a n b e r p r e s e n t e d i n t e r m s } \text {of the corresponding network activations using}
$$

Similarly, the variances must satisfy σ 2 k ( x ) 0 and so can be represented in terms of the exponentials of the corresponding network activations using

$$
\sigma _ { k } ( \mathbf x ) = \exp ( a _ { k } ^ { \sigma } ) .
$$

Finally, because the means µ k ( x ) have real components, they can be represented
