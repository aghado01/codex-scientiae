[Page 396]

Figure 8.20 As in Figure 8.19 but conditioning on the value of node c. In this graph, the act of conditioning induces a dependence between a and b.

a b

c

and so a and b are independent with no variables observed, in contrast to the two previous examples. We can write this result as

a ⊥⊥ b | ∅. (8.29)

Now suppose we condition on c, as indicated in Figure 8.20. The conditional distribution of a and b is then given by

p(a,b|c) =

=

p(a,b,c) p(c)

p(a)p(b)p(c|a,b) p(c)

which in general does not factorize into the product p(a)p(b), and so

a⊥�⊥ b | c.

Thus our third example has the opposite behaviour from the ﬁrst two. Graphically, we say that node c is head-to-head with respect to the path from a to b because it connects to the heads of the two arrows. When node c is unobserved, it ‘blocks’ the path, and the variables a and b are independent. However, conditioning on c ‘unblocks’ the path and renders a and b dependent.

There is one more subtlety associated with this third example that we need to consider. First we introduce some more terminology. We say that node y is a descendant of node x if there is a path from x to y in which each step of the path follows the directions of the arrows. Then it can be shown that a head-to-head path

Exercise 8.10 will become unblocked if either the node, or any of its descendants, is observed.

In summary, a tail-to-tail node or a head-to-tail node leaves a path unblocked unless it is observed in which case it blocks the path. By contrast, a head-to-head node blocks a path if it is unobserved, but once the node, and/or at least one of its descendants, is observed the path becomes unblocked.

It is worth spending a moment to understand further the unusual behaviour of the graph of Figure 8.20. Consider a particular instance of such a graph corresponding to a problem with three binary random variables relating to the fuel system on a car, as shown in Figure 8.21. The variables are called B, representing the state of a battery that is either charged (B = 1) or ﬂat (B = 0), F representing the state of the fuel tank that is either full of fuel (F = 1) or empty (F = 0), and G, which is the state of an electric fuel gauge and which indicates either full (G = 1) or empty
