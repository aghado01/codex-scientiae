[Page 425]

Figure 8.47 Illustration of the factorization of the subgraph as-

sociated with factor node fs.

xM

M→fs(xM)

µx

fs

xm

Gm(xm,Xsm)

s→x(x)

µf

x

where ne(fs) denotes the set of variable nodes that are neighbours of the factor node fs, and ne(fs) \ x denotes the same set but with node x removed. Here we have deﬁned the following messages from variable nodes to factor nodes

m→fs(xm) ≡ � Xsm

Gm(xm,Xsm). (8.67)

µx

We have therefore introduced two distinct kinds of message, those that go from factor nodes to variable nodes denoted µf→x(x), and those that go from variable nodes to factor nodes denoted µx→f(x). In each case, we see that messages passed along a link are always a function of the variable associated with the variable node that link connects to.

The result (8.66) says that to evaluate the message sent by a factor node to a variable node along the link connecting them, take the product of the incoming messages along all other links coming into the factor node, multiply by the factor associated with that node, and then marginalize over all of the variables associated with the incoming messages. This is illustrated in Figure 8.47. It is important to note that a factor node can send a message to a variable node once it has received incoming messages from all other neighbouring variable nodes.

Finally, we derive an expression for evaluating the messages from variable nodes to factor nodes, again by making use of the (sub-)graph factorization. From Figure 8.48, we see that term Gm(xm,Xsm) associated with node xm is given by a product of terms Fl(xm,Xml) each associated with one of the factor nodes fl that is linked to node xm (excluding node fs), so that

�

Gm(xm,Xsm) =

Fl(xm,Xml) (8.68)

l∈ne(xm)\fs

where the product is taken over all neighbours of node xm except for node fs. Note that each of the factors Fl(xm,Xml) represents a subtree of the original graph of precisely the same kind as introduced in (8.62). Substituting (8.68) into (8.67), we
