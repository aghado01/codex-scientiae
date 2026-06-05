[Page 435]

by the lines connecting the nodes. Once we know the most probable value of the ﬁnal node xN, we can then simply follow the link back to ﬁnd the most probable state of node xN−1 and so on back to the initial node x1. This corresponds to propagating a message back down the chain using

xmaxn−1 = φ(xmaxn ) (8.102)

and is known as back-tracking. Note that there could be several values of xn−1 all of which give the maximum value in (8.101). Provided we chose one of these values when we do the back-tracking, we are assured of a globally consistent maximizing conﬁguration.

In Figure 8.53, we have indicated two paths, each of which we shall suppose corresponds to a global maximum of the joint probability distribution. If k = 2 and k = 3 each represent possible values of xmaxN , then starting from either state and tracing back along the black lines, which corresponds to iterating (8.102), we obtain a valid global maximum conﬁguration. Note that if we had run a forward pass of max-sum message passing followed by a backward pass and then applied (8.98) at each node separately, we could end up selecting some states from one path and some from the other path, giving an overall conﬁguration that is not a global maximizer. We see that it is necessary instead to keep track of the maximizing states during the forward pass using the functions φ(xn) and then use back-tracking to ﬁnd a consistent solution.

The extension to a general tree-structured factor graph should now be clear. If a message is sent from a factor node f to a variable node x, a maximization is performed over all other variable nodes x1,...,xM that are neighbours of that factor node, using (8.93). When we perform this maximization, we keep a record of which values of the variables x1,...,xM gave rise to the maximum. Then in the back-tracking step, having found xmax, we can then use these stored values to assign consistent maximizing states xmax1 ,...,xmaxM . The max-sum algorithm, with back-tracking, gives an exact maximizing conﬁguration for the variables provided the factor graph is a tree. An important application of this technique is for ﬁnding the most probable sequence of hidden states in a hidden Markov model, in which

Section 13.2 case it is known as the Viterbi algorithm.

As with the sum-product algorithm, the inclusion of evidence in the form of observed variables is straightforward. The observed variables are clamped to their observed values, and the maximization is performed over the remaining hidden variables. This can be shown formally by including identity functions for the observed variables into the factor functions, as we did for the sum-product algorithm.

It is interesting to compare max-sum with the iterated conditional modes (ICM) algorithm described on page 389. Each step in ICM is computationally simpler because the ‘messages’ that are passed from one node to the next comprise a single value consisting of the new state of the node for which the conditional distribution is maximized. The max-sum algorithm is more complex because the messages are functions of node variables x and hence comprise a set of K values for each possible state of x. Unlike max-sum, however, ICM is not guaranteed to ﬁnd a global maximum even for tree-structured graphs.
