[Page 387]

# Figure 8.9

(a) This fully-connected graph describes a general distribution over two K -state discrete variables having a total of K 2 − 1 parameters. (b) By dropping the link between the nodes, the number of parameters is reduced to 2( K − 1) .

![image 168](../images/imageFile168.png)

1

2

x

x

(a)

1

2

x

x

(b)

distributions, and the framework of graphical models is very useful in expressing the way in which these building blocks are linked together.

Such models have particularly nice properties if we choose the relationship between each parent-child pair in a directed graph to be conjugate, and we shall explore several examples of this shortly. Two cases are particularly worthy of note, namely when the parent and child node each correspond to discrete variables and when they each correspond to Gaussian variables, because in these two cases the relationship can be extended hierarchically to construct arbitrarily complex directed acyclic graphs. We begin by examining the discrete case.

The probability distribution p ( x | µ ) for a single discrete variable x having K possible states (using the 1-ofK representation) is given by

$$
p ( x | \mu ) & = \prod _ { k = 1 } ^ { K } \mu _ { k } ^ { x _ { k } } \\ \text {parameters} \, \mu & = ( \mu _ { 1 } , \quad \mu _ { K } ) ^ { T } \quad \text {Due to the constraint}
$$

and is governed by the parameters µ = ( µ 1 ,...,µ K ) T . Due to the constraint k µ k = 1 , only K − 1 values for µ k need to be speciﬁed in order to deﬁne the distribution. Now suppose that we have two discrete variables, x 1 and x 2 , each of which has

K states, and we wish to model their joint distribution. We denote the probability of observing both x 1 k = 1 and x 2 l = 1 by the parameter µ kl , where x 1 k denotes the k th component of x 1 , and similarly for x 2 l . The joint distribution can be written

$$
p ( x _ { 1 } , x _ { 2 } | \mu ) = \prod _ { k = 1 } ^ { K } \prod _ { l = 1 } ^ { K } \mu _ { k l } ^ { x _ { 1 k } x _ { 2 l } } . \\ \intertext { s u r s } \emph { u l } a r e s u b i c t o t h e c o n s t r a n g \sum _ { k = 1 } ^ { K } \sum _ { l = 1 } ^ { K } .
$$

k =1 l =1 Because the parameters µ kl are subject to the constraint k l µ kl = 1 , this distribution is governed by K 2 − 1 parameters. It is easily seen that the total number of parameters that must be speciﬁed for an arbitrary joint distribution over M variables is K M − 1 and therefore grows exponentially with the number M of variables. Using the product rule, we can factor the joint distribution p ( x 1 , x 2 ) in the form

p ( x 2 | x 1 ) p ( x 1 ) , which corresponds to a two-node graph with a link going from the x 1 node to the x 2 node as shown in Figure 8.9(a). The marginal distribution p ( x 1 ) is governed by K − 1 parameters, as before, Similarly, the conditional distribution p ( x 2 | x 1 ) requires the speciﬁcation of K − 1 parameters for each of the K possible values of x 1 . The total number of parameters that must be speciﬁed in the joint distribution is therefore ( K − 1) + K ( K − 1) = K 2 − 1 as before. Now suppose that the variables x 1 and x 2 were independent, corresponding to

Now suppose that the variables x 1 and x 2 were independent, corresponding to the graphical model shown in Figure 8.9(b). Each variable is then described by a separate multinomial distribution, and the total number of parameters would be 2( K -1) . For a distribution over M independent discrete variables, each having K states, the total number of parameters would be M ( K -1) , which therefore grows linearly with the number of variables. From a graphical perspective, we have reduced the number of parameters by dropping links in the graph, at the expense of having a restricted class of distributions.
