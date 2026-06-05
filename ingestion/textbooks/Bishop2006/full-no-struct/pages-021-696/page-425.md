[Page 425]

Figure 8.47 Illustration of the factorization of the subgraph associated with factor node f s .

x

![In this image there is a diagram with some text and numbers.](../images/imageFile206.png)

M

µ

(

x

)

→

x

f

M

s

M

f

s

x

µ

(

x

)

→

f

x

s

x

m

G

(

x

,X

)

m

m

sm )

where ne( f s ) denotes the set of variable nodes that are neighbours of the factor node f s , and ne( f s ) \ x denotes the same set but with node x removed. Here we have deﬁned the following messages from variable nodes to factor nodes

$$
\mu _ { x _ { m } \rightarrow f _ { s } } ( x _ { m } ) \equiv \sum _ { X _ { s m } } G _ { m } ( x _ { m } , X _ { s m } ) . \\
$$

We have therefore introduced two distinct kinds of message, those that go from factor nodes to variable nodes denoted µ f → x ( x ) , and those that go from variable nodes to factor nodes denoted µ x → f ( x ) . In each case, we see that messages passed along a link are always a function of the variable associated with the variable node that link connects to.

The result (8.66) says that to evaluate the message sent by a factor node to a variable node along the link connecting them, take the product of the incoming messages along all other links coming into the factor node, multiply by the factor associated with that node, and then marginalize over all of the variables associated with the incoming messages. This is illustrated in Figure 8.47. It is important to note that a factor node can send a message to a variable node once it has received incoming messages from all other neighbouring variable nodes.

Finally, we derive an expression for evaluating the messages from variable nodes to factor nodes, again by making use of the (sub-)graph factorization. From Figure 8.48, we see that term G m ( x m ,X sm ) associated with node x m is given by a product of terms F l ( x m ,X ml ) each associated with one of the factor nodes f l that is linked to node x m (excluding node f s ), so that

$$
G _ { m } ( x _ { m } , X _ { s m } ) = \prod _ { l \in \text {ne} ( x _ { m } ) \ \{ f _ { s } \} } F _ { l } ( x _ { m } , X _ { m l } ) \\
$$

where the product is taken over all neighbours of node x m except for node f s . Note that each of the factors F l ( x m ,X ml ) represents a subtree of the original graph of precisely the same kind as introduced in (8.62). Substituting (8.68) into (8.67), we
