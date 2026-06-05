[Page 387]

Figure 8.9 (a) This fully-connected graph describes a general distribution over two K-state discrete variables having a total of K2 − 1 parameters. (b) By dropping the link between the nodes, the number of parameters is reduced to 2(K − 1).

- (a)

x1 x2

- (b)


###### x1 x2

distributions, and the framework of graphical models is very useful in expressing the way in which these building blocks are linked together.

Such models have particularly nice properties if we choose the relationship between each parent-child pair in a directed graph to be conjugate, and we shall explore several examples of this shortly. Two cases are particularly worthy of note, namely when the parent and child node each correspond to discrete variables and when they each correspond to Gaussian variables, because in these two cases the relationship can be extended hierarchically to construct arbitrarily complex directed acyclic graphs. We begin by examining the discrete case.

The probability distribution p(x|µ) for a single discrete variable x having K possible states (using the 1-of-K representation) is given by

K

p(x|µ) =

k=1

µx

k (8.9)

k

and is governed by the parameters µ = (µ1,...,µK)T. Due to the constraint

k µk = 1, only K − 1 values for µk need to be speciﬁed in order to deﬁne the distribution.

Now suppose that we have two discrete variables, x1 and x2, each of which has K states, and we wish to model their joint distribution. We denote the probability of observing both x1k = 1 and x2l = 1 by the parameter µkl, where x1k denotes the kth component of x1, and similarly for x2l. The joint distribution can be written

K

###### K

p(x1,x2|µ) =

k=1

l=1

µx

1kx2l kl .

Because the parameters µkl are subject to the constraint k l µkl = 1, this distribution is governed by K2 − 1 parameters. It is easily seen that the total number of

parameters that must be speciﬁed for an arbitrary joint distribution over M variables is KM − 1 and therefore grows exponentially with the number M of variables.

Using the product rule, we can factor the joint distribution p(x1,x2) in the form p(x2|x1)p(x1), which corresponds to a two-node graph with a link going from the x1 node to the x2 node as shown in Figure 8.9(a). The marginal distribution p(x1) is governed by K − 1 parameters, as before, Similarly, the conditional distribution p(x2|x1) requires the speciﬁcation of K − 1 parameters for each of the K possible values of x1. The total number of parameters that must be speciﬁed in the joint distribution is therefore (K − 1) + K(K − 1) = K2 − 1 as before.

Now suppose that the variables x1 and x2 were independent, corresponding to the graphical model shown in Figure 8.9(b). Each variable is then described by
