[Page 434]

Figure 8.53 A lattice, or trellis, diagram showing explicitly the K possible states (one per row of the diagram) for each of the variables x n in the chain model. In this illustration K = 3 . The arrow shows the direction of message passing in the max-product algorithm. For every state k of each variable x n (corresponding to column n of the diagram) the function φ ( x n ) deﬁnes a unique state at the previous variable, indicated by the black lines. The two paths through the lattice correspond to conﬁgurations that give the global maximum of the joint probability distribution, and either of these can be found by tracing back along the black lines in the opposite direction to the arrow.

![In this image, we can see a diagram with some numbers and arrows.](../images/imageFile212.png)

k

= 1

k

= 2

k

= 3

-

-

n

2

n

1

n

n

- 1

corresponding to the graph shown in Figure 8.38. Suppose we take node x N to be the root node. Then in the ﬁrst phase, we propagate messages from the leaf node x 1 to the root node using

$$
\mu _ { x _ { n } \to f _ { n , n + 1 } } ( x _ { n } ) & \ = \ \mu _ { f _ { n - 1 , n } \to x _ { n } } ( x _ { n } ) \\ \mu _ { f _ { n - 1 , n } \to x _ { n } } ( x _ { n } ) & \ = \ \max _ { x _ { n - 1 } } \left [ \ln f _ { n - 1 , n } ( x _ { n - 1 } , x _ { n } ) + \mu _ { x _ { n - 1 } \to f _ { n - 1 , n } } ( x _ { n } ) \right ] \\ \text {which follow from applying (8.94) and (8.93) to this particular graph. The initial}
$$

which follow from applying (8.94) and (8.93) to this particular graph. The initial message sent from the leaf node is simply

$$
\mu _ { x _ { 1 } \rightarrow f _ { 1 , 2 } } ( x _ { 1 } ) = 0 .
$$

The most probable value for x N is then given by

$$
\text {loc} \, \text { value for } x _ { N } \text { is much given by} \\ x _ { N } ^ { \max } = \arg \max _ { x _ { N } } \left [ \mu _ { f N - 1 , N } \rightarrow x _ { N } \left ( x _ { N } \right ) \right ] . \\ \\ \text {ed to determine the states of the previous variables that correspond to the}
$$

Now we need to determine the states of the previous variables that correspond to the same maximizing conﬁguration. This can be done by keeping track of which values of the variables gave rise to the maximum state of each variable, in other words by storing quantities given by

$$
\text {using quantities} \ g r { n } { \beta } \\ \phi ( x _ { n } ) = \arg \max \left [ \ln f _ { n - 1 , n } ( x _ { n - 1 } , x _ { n } ) + \mu _ { x _ { n - 1 } \rightarrow f n - 1 , n } ( x _ { n } ) \right ] . \\ \\ \text {To understand better what is happening, it is helpful to represent the chain of vari-}
$$

To understand better what is happening, it is helpful to represent the chain of variables in terms of a lattice or trellis diagram as shown in Figure 8.53. Note that this is not a probabilistic graphical model because the nodes represent individual states of variables, while each variable corresponds to a column of such states in the diagram. For each state of a given variable, there is a unique state of the previous variable that maximizes the probability (ties are broken either systematically or at random), corresponding to the function φ ( x n ) given by (8.101), and this is indicated
