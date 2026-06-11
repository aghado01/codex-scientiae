[Page 426]

Figure 8.48 Illustration of the evaluation of the message sent by a variable node to an adjacent factor node.

![image 208](../images/imageFile208.png)

then obtain

$$
\begin{aligned}
\mu_{x_m \to f_s}(x_m) &= \prod_{l \in \text{ne}(x_m) \setminus f_s} \left[ \sum_{X_{ml}} F_l(x_m, X_{ml}) \right] \\
&= \prod_{l \in \text{ne}(x_m) \setminus f_s} \mu_{f_l \to x_m}(x_m)
\end{aligned} \tag{8.69}
$$

where we have used the deﬁnition (8.64) of the messages passed from factor nodes to variable nodes. Thus to evaluate the message sent by a variable node to an adjacent factor node along the connecting link, we simply take the product of the incoming messages along all of the other links. Note that any variable node that has only two neighbours performs no computation but simply passes messages through unchanged. Also, we note that a variable node can send a message to a factor node once it has received incoming messages from all other neighbouring factor nodes.

Recall that our goal is to calculate the marginal for variable node $x$, and that this marginal is given by the product of incoming messages along all of the links arriving at that node. Each of these messages can be computed recursively in terms of other messages. In order to start this recursion, we can view the node $x$ as the root of the tree and begin at the leaf nodes. From the deﬁnition (8.69), we see that if a leaf node is a variable node, then the message that it sends along its one and only link is given by

$$
\mu_{x \to f}(x) = 1 \tag{8.70}
$$

as illustrated in Figure 8.49(a). Similarly, if the leaf node is a factor node, we see from (8.66) that the message sent should take the form

$$
\mu_{f \to x}(x) = f(x) \tag{8.71}
$$

Figure 8.49 The sum-product algorithm begins with messages sent by the leaf nodes, which depend on whether the leaf node is (a) a variable node, or (b) a factor node.

![image 207](../images/imageFile207.png)
