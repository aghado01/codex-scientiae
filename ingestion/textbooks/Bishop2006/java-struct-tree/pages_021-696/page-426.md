[Page 426]

Figure 8.48 Illustration of the evaluation of the message sent by a variable node to an adjacent factor node.

fL

fl

Fl(xm,Xml)

xm

fs

then obtain

�

Fl(xm,Xml)�

�

�

m→fs(xm) =

µx

Xml

l∈ne(xm)\fs

�

=

l→xm(xm) (8.69)

µf

l∈ne(xm)\fs

where we have used the deﬁnition (8.64) of the messages passed from factor nodes to variable nodes. Thus to evaluate the message sent by a variable node to an adjacent factor node along the connecting link, we simply take the product of the incoming messages along all of the other links. Note that any variable node that has only two neighbours performs no computation but simply passes messages through unchanged. Also, we note that a variable node can send a message to a factor node once it has received incoming messages from all other neighbouring factor nodes.

Recall that our goal is to calculate the marginal for variable node x, and that this marginal is given by the product of incoming messages along all of the links arriving at that node. Each of these messages can be computed recursively in terms of other messages. In order to start this recursion, we can view the node x as the root of the tree and begin at the leaf nodes. From the deﬁnition (8.69), we see that if a leaf node is a variable node, then the message that it sends along its one and only link is given by

µx→f(x) = 1 (8.70)

as illustrated in Figure 8.49(a). Similarly, if the leaf node is a factor node, we see from (8.66) that the message sent should take the form

µf→x(x) = f(x) (8.71)

Figure 8.49 The sum-product algorithm begins with messages sent by the leaf nodes, which depend on whether the leaf node is (a) a variable node, or (b) a factor node.

µx→f(x) = 1

x f

(a)

µf→x(x) = f(x)

f x

(b)
