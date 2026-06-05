[Page 667]

p(zn|Xn)

p(zn+1|Xn)

| | | | | | | | | | | |
|---|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | | |


p(xn+1|zn+1)

###### p(zn+1|Xn+1) z

Figure 13.23 Schematic illustration of the operation of the particle ﬁlter for a one-dimensional latent space. At time step n, the posterior p(zn|xn) is represented as a mixture distribution, shown schematically as circles whose sizes are proportional to the weights wn(l). A set of L samples is then drawn from this distribution and the new weights wn(l+1) evaluated using p(xn+1|z(nl+1) ).

satisﬁes the conditional independence properties

p(xn|x1,...,xn−1) = p(xn|xn−1,xn−2) (13.122) for n = 3,...,N.

- 13.2 ( ) Consider the joint probability distribution (13.2) corresponding to the directed graph of Figure 13.3. Using the sum and product rules of probability, verify that this joint distribution satisﬁes the conditional independence property (13.3) for n = 2,...,N. Similarly, show that the second-order Markov model described by the joint distribution (13.4) satisﬁes the conditional independence property

p(xn|x1,...,xn−1) = p(xn|xn−1,xn−2) (13.123) for n = 3,...,N.

- 13.3 ( ) By using d-separation, show that the distribution p(x1,...,xN) of the observed data for the state space model represented by the directed graph in Figure 13.5 does not satisfy any conditional independence properties and hence does not exhibit the Markov property at any ﬁnite order.
- 13.4 ( ) www Consider a hidden Markov model in which the emission densities are represented by a parametric model p(x|z,w), such as a linear regression model or a neural network, in which w is a vector of adaptive parameters. Describe how the parameters w can be learned from data using maximum likelihood.
