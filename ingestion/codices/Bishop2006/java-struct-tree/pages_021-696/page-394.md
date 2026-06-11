[Page 394]

Figure 8.16 As in Figure 8.15 but where we have conditioned on the

value of variable c.

a b

where ∅ denotes the empty set, and the symbol⊥�⊥ means that the conditional independence property does not hold in general. Of course, it may hold for a particular distribution by virtue of the speciﬁc numerical values associated with the various conditional probabilities, but it does not follow in general from the structure of the graph.

Now suppose we condition on the variable c, as represented by the graph of Figure 8.16. From (8.23), we can easily write down the conditional distribution of a and b, given c, in the form

p(a,b,c) p(c)

p(a,b|c) =

= p(a|c)p(b|c) and so we obtain the conditional independence property

a ⊥⊥ b | c.

We can provide a simple graphical interpretation of this result by considering the path from node a to node b via c. The node c is said to be tail-to-tail with respect to this path because the node is connected to the tails of the two arrows, and the presence of such a path connecting nodes a and b causes these nodes to be dependent. However, when we condition on node c, as in Figure 8.16, the conditioned node ‘blocks’ the path from a to b and causes a and b to become (conditionally) independent.

We can similarly consider the graph shown in Figure 8.17. The joint distribution corresponding to this graph is again obtained from our general formula (8.5) to give

p(a,b,c) = p(a)p(c|a)p(b|c). (8.26)

First of all, suppose that none of the variables are observed. Again, we can test to see if a and b are independent by marginalizing over c to give

�

p(c|a)p(b|c) = p(a)p(b|a).

p(a,b) = p(a)

c

Figure 8.17 The second of our three examples of 3-node graphs used to motivate the conditional independence framework for directed graphical models.

a c b
