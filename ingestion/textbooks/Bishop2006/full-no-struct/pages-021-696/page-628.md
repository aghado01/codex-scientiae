[Page 628]

Figure 13.3 A ﬁrst-order Markov chain of observations { x n } in which the distribution p ( x n | x n − 1 ) of a particular observation x n is conditioned on the value of the previous observation .

![image 304](../images/imageFile304.png)

1

2

3

4

x

x

x

x

Section 8.2

Exercise 13.1

joint distribution for a sequence of N observations under this model is given by

$$
p ( x _ { 1 } , \dots , x _ { N } ) = p ( x _ { 1 } ) \prod _ { n = 2 } ^ { N } p ( x _ { n } | x _ { n - 1 } ) . \\ \intertext { d - s e r a p o r y , w e s e e t h a t the c o n t i o n a l d i t u b i o n f o r a s e r a - }
$$

From the d-separation property, we see that the conditional distribution for observation x n , given all of the observations up to time n , is given by

$$
p ( x _ { n } | x _ { 1 } , \dots , x _ { n - 1 } ) = p ( x _ { n } | x _ { n - 1 } ) \\ \\
$$

which is easily veriﬁed by direct evaluation starting from (13.2) and using the product rule of probability. Thus if we use such a model to predict the next observation in a sequence, the distribution of predictions will depend only on the value of the immediately preceding observation and will be independent of all earlier observations.

In most applications of such models, the conditional distributions p ( x n | x n − 1 ) that deﬁne the model will be constrained to be equal, corresponding to the assumption of a stationary time series. The model is then known as a homogeneous Markov chain. For instance, if the conditional distributions depend on adjustable parameters (whose values might be inferred from a set of training data), then all of the conditional distributions in the chain will share the same values of those parameters.

Although this is more general than the independence model, it is still very restrictive. For many sequential observations, we anticipate that the trends in the data over several successive observations will provide important information in predicting the next value. One way to allow earlier observations to have an inﬂuence is to move to higher-order Markov chains. If we allow the predictions to depend also on the previous-but-one value, we obtain a second-order Markov chain, represented by the graph in Figure 13.4. The joint distribution is now given by

$$
p ( x _ { 1 } , \dots , x _ { N } ) = p ( x _ { 1 } ) p ( x _ { 2 } | x _ { 1 } ) \prod _ { n = 3 } ^ { N } p ( x _ { n } | x _ { n - 1 } , x _ { n - 2 } ) . \\ \text { again, using } d \text { separation or by direct evaluation, we see that the conditional distrib-}
$$

Again, using d-separation or by direct evaluation, we see that the conditional distribution of x n given x n − 1 and x n − 2 is independent of all observations x 1 ,... x n − 3 .

Figure 13.4

A second-order Markov chain, in which the conditional distribution of a particular observation x n depends on the values of the two previous observations x n − 1 and x n − 2 .

![image 303](../images/imageFile303.png)

1

2

3

4

x

x

x

x
