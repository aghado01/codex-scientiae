[Page 639]

the messages that are propagated along the chain (Jordan, 2007). We shall focus on the most widely used of these, known as the alpha-beta algorithm.

As well as being of great practical importance in its own right, the forwardbackward algorithm provides us with a nice illustration of many of the concepts introduced in earlier chapters. We shall therefore begin in this section with a ‘conventional’ derivation of the forward-backward equations, making use of the sum and product rules of probability, and exploiting conditional independence properties which we shall obtain from the corresponding graphical model using d-separation. Then in Section 13.2.3, we shall see how the forward-backward algorithm can be obtained very simply as a speciﬁc example of the sum-product algorithm introduced in Section 8.4.4.

It is worth emphasizing that evaluation of the posterior distributions of the latent variables is independent of the form of the emission density p(x|z) or indeed of whether the observed variables are continuous or discrete. All we require is the values of the quantities p(xn|zn) for each value of zn for every n. Also, in this section and the next we shall omit the explicit dependence on the model parameters θold because these ﬁxed throughout.

We therefore begin by writing down the following conditional independence properties (Jordan, 2007)

p(X|zn) = p(x1,...,xn|zn)

p(xn+1,...,xN|zn) (13.24) p(x1,...,xn−1|xn,zn) = p(x1,...,xn−1|zn) (13.25)

p(x1,...,xn−1|zn−1,zn) = p(x1,...,xn−1|zn−1) (13.26) p(xn+1,...,xN|zn,zn+1) = p(xn+1,...,xN|zn+1) (13.27)

p(xn+2,...,xN|zn+1,xn+1) = p(xn+2,...,xN|zn+1) (13.28) p(X|zn−1,zn) = p(x1,...,xn−1|zn−1)

p(xn|zn)p(xn+1,...,xN|zn) (13.29) p(xN+1|X,zN+1) = p(xN+1|zN+1) (13.30)

p(zN+1|zN,X) = p(zN+1|zN) (13.31)

where X = {x1,...,xN}. These relations are most easily proved using d-separation. For instance in the ﬁrst of these results, we note that every path from any one of the nodes x1,...,xn−1 to the node xn passes through the node zn, which is observed. Because all such paths are head-to-tail, it follows that the conditional independence property must hold. The reader should take a few moments to verify each of these properties in turn, as an exercise in the application of d-separation. These relations can also be proved directly, though with signiﬁcantly greater effort, from the joint distribution for the hidden Markov model using the sum and product rules of proba-

###### Exercise 13.10 bility.

Let us begin by evaluating γ(znk). Recall that for a discrete multinomial random variable the expected value of one of its components is just the probability of that component having the value 1. Thus we are interested in ﬁnding the posterior distribution p(zn|x1,...,xN) of zn given the observed data set x1,...,xN. This
