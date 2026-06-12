[Page 627]

Figure 13.2 The simplest approach to modelling a sequence of observations is to treat them as independent, corresponding to a graph without links.

![image 302](../images/imageFile302.png)

1

2

3

4

x

x

x

x

Although such models are tractable, they are also severely limited. We can obtain a more general framework, while still retaining tractability, by the introduction of latent variables, leading to state space models . As in Chapters 9 and 12, we shall see that complex models can thereby be constructed from simpler components (in particular, from distributions belonging to the exponential family) and can be readily characterized using the framework of probabilistic graphical models. Here we focus on the two most important examples of state space models, namely the hidden Markov model , in which the latent variables are discrete, and linear dynamical systems , in which the latent variables are Gaussian. Both models are described by directed graphs having a tree structure (no loops) for which inference can be performed efﬁciently using the sum-product algorithm.

# 13.1. Markov Models

The easiest way to treat sequential data would be simply to ignore the sequential aspects and treat the observations as i.i.d., corresponding to the graph in Figure 13.2. Such an approach, however, would fail to exploit the sequential patterns in the data, such as correlations between observations that are close in the sequence. Suppose, for instance, that we observe a binary variable denoting whether on a particular day it rained or not. Given a time series of recent observations of this variable, we wish to predict whether it will rain on the next day. If we treat the data as i.i.d., then the only information we can glean from the data is the relative frequency of rainy days. However, we know in practice that the weather often exhibits trends that may last for several days. Observing whether or not it rains today is therefore of signiﬁcant help in predicting if it will rain tomorrow.

To express such effects in a probabilistic model, we need to relax the i.i.d. assumption, and one of the simplest ways to do this is to consider a Markov model . First of all we note that, without loss of generality, we can use the product rule to express the joint distribution for a sequence of observations in the form

$$
p ( x _ { 1 } , \dots , x _ { N } ) = \prod _ { n = 1 } ^ { N } p ( x _ { n } | x _ { 1 } , \dots , x _ { n - 1 } ) .
$$

If we now assume that each of the conditional distributions on the right-hand side is independent of all previous observations except the most recent, we obtain the ﬁrst-order Markov chain , which is depicted as a graphical model in Figure 13.3. The
