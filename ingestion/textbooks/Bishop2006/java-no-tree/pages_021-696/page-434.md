[Page 434]

- Figure 8.53 A lattice, or trellis, diagram showing explicitly the K possible states (one per row


of the diagram) for each of the variables xn in the chain model. In this illustration K = 3. The arrow shows the direction of message passing in the max-product algorithm. For every state k of each variable xn (corresponding to column n of the diagram) the function φ(xn) deﬁnes a unique state at the previous variable, indicated by the black lines. The two paths through the lattice correspond to conﬁgurations that give the global maximum of the joint probability distribution, and either of these can be found by tracing back along the black lines in the opposite direction to the arrow.

- k = 1
- k = 2
- k = 3


n − 2 n − 1 n n + 1

corresponding to the graph shown in Figure 8.38. Suppose we take node xN to be the root node. Then in the ﬁrst phase, we propagate messages from the leaf node x1 to the root node using

n−1,n→xn(xn) µf

n→fn,n+1(xn) = µf

µx

n−1,n→xn(xn) = max xn−1

lnfn−1,n(xn−1,xn) + µx

n−1→fn−1,n(xn)

which follow from applying (8.94) and (8.93) to this particular graph. The initial message sent from the leaf node is simply

1→f1,2(x1) = 0. (8.99) The most probable value for xN is then given by

µx

###### xmaxN = arg max

xN

N−1,N→xN(xN) . (8.100)

µf

Now we need to determine the states of the previous variables that correspond to the same maximizing conﬁguration. This can be done by keeping track of which values of the variables gave rise to the maximum state of each variable, in other words by storing quantities given by

###### φ(xn) = arg max

xn−1

lnfn−1,n(xn−1,xn) + µx

n−1→fn−1,n(xn) . (8.101)

To understand better what is happening, it is helpful to represent the chain of variables in terms of a lattice or trellis diagram as shown in Figure 8.53. Note that this is not a probabilistic graphical model because the nodes represent individual states of variables, while each variable corresponds to a column of such states in the diagram. For each state of a given variable, there is a unique state of the previous variable that maximizes the probability (ties are broken either systematically or at random), corresponding to the function φ(xn) given by (8.101), and this is indicated
