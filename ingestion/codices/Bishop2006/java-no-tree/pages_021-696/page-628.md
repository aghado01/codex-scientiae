[Page 628]

Figure 13.3 A ﬁrst-order Markov chain of observations {xn} in which the distribution p(xn|xn−1) of a particular observation xn is conditioned on the value of the previous observation xn−1.

###### x1 x2 x3 x4

joint distribution for a sequence of N observations under this model is given by

p(x1,...,xN) = p(x1)

N

p(xn|xn−1). (13.2)

n=2

Section 8.2 From the d-separation property, we see that the conditional distribution for observation xn, given all of the observations up to time n, is given by

p(xn|x1,...,xn−1) = p(xn|xn−1) (13.3) which is easily veriﬁed by direct evaluation starting from (13.2) and using the prod-

Exercise 13.1 uct rule of probability. Thus if we use such a model to predict the next observation in a sequence, the distribution of predictions will depend only on the value of the immediately preceding observation and will be independent of all earlier observations.

In most applications of such models, the conditional distributions p(xn|xn−1) that deﬁne the model will be constrained to be equal, corresponding to the assumption of a stationary time series. The model is then known as a homogeneous Markov chain. For instance, if the conditional distributions depend on adjustable parameters (whose values might be inferred from a set of training data), then all of the conditional distributions in the chain will share the same values of those parameters.

Although this is more general than the independence model, it is still very restrictive. For many sequential observations, we anticipate that the trends in the data over several successive observations will provide important information in predicting the next value. One way to allow earlier observations to have an inﬂuence is to move to higher-order Markov chains. If we allow the predictions to depend also on the previous-but-one value, we obtain a second-order Markov chain, represented by the graph in Figure 13.4. The joint distribution is now given by

p(x1,...,xN) = p(x1)p(x2|x1)

N

p(xn|xn−1,xn−2). (13.4)

n=3

Again, using d-separation or by direct evaluation, we see that the conditional distribution of xn given xn−1 and xn−2 is independent of all observations x1,...xn−3.

Figure 13.4 A second-order Markov chain, in which the conditional distribution of a particular observation xn depends on the values of the two previous observations xn−1 and xn−2.

###### x1 x2 x3 x4
