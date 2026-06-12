[Page 417]

Figure 8.38 The marginal distribution p(xn) for a node xn along the chain is obtained by multiplying the two messages µα(xn) and µβ(xn), and then normalizing. These messages can themselves be evaluated recursively by passing messages from both ends of the chain towards node xn.

###### µα(xn−1) µα(xn) µβ(xn) µβ(xn+1)

x1 xn−1 xn xn+1 xN

along the chain to node xn from node xn+1. Note that each of the messages comprises a set of K values, one for each choice of xn, and so the product of two messages should be interpreted as the point-wise multiplication of the elements of the two messages to give another set of K values.

The message µα(xn) can be evaluated recursively because

###### ⎡

###### ⎤ ⎦

⎣ xn−2

###### µα(xn) =

ψn−1,n(xn−1,xn)

···

xn−1

###### =

###### ψn−1,n(xn−1,xn)µα(xn−1). (8.55)

xn−1

We therefore ﬁrst evaluate

µα(x2) =

x1

ψ1,2(x1,x2) (8.56)

and then apply (8.55) repeatedly until we reach the desired node. Note carefully the structure of the message passing equation. The outgoing message µα(xn) in (8.55) is obtained by multiplying the incoming message µα(xn−1) by the local potential involving the node variable and the outgoing variable and then summing over the node variable.

Similarly, the message µβ(xn) can be evaluated recursively by starting with node xN and using

###### ⎡

###### ⎤ ⎦

⎣ xn+2

###### µβ(xn) =

ψn+1,n(xn+1,xn)

···

xn+1

###### =

###### ψn+1,n(xn+1,xn)µβ(xn+1). (8.57)

xn+1

This recursive message passing is illustrated in Figure 8.38. The normalization constant Z is easily evaluated by summing the right-hand side of (8.54) over all states of xn, an operation that requires only O(K) computation.

Graphs of the form shown in Figure 8.38 are called Markov chains, and the corresponding message passing equations represent an example of the ChapmanKolmogorov equations for Markov processes (Papoulis, 1984).
