[Page 253]

target vectors {tn}, we minimize the error function

N

1 2

y(xn,w) − tn 2. (5.11)

E(w) =

n=1

However, we can provide a much more general view of network training by ﬁrst giving a probabilistic interpretation to the network outputs. We have already seen many advantages of using probabilistic predictions in Section 1.5.4. Here it will also provide us with a clearer motivation both for the choice of output unit nonlinearity and the choice of error function.

We start by discussing regression problems, and for the moment we consider a single target variable t that can take any real value. Following the discussions in Section 1.2.5 and 3.1, we assume that t has a Gaussian distribution with an xdependent mean, which is given by the output of the neural network, so that

###### p(t|x,w) = N t|y(x,w),β−1 (5.12)

where β is the precision (inverse variance) of the Gaussian noise. Of course this is a somewhat restrictive assumption, and in Section 5.6 we shall see how to extend this approach to allow for more general conditional distributions. For the conditional distribution given by (5.12), it is sufﬁcient to take the output unit activation function to be the identity, because such a network can approximate any continuous function from x to y. Given a data set of N independent, identically distributed observations X = {x1,...,xN}, along with corresponding target values t = {t1,...,tN}, we can construct the corresponding likelihood function

N

p(t|X,w,β) =

p(tn|xn,w,β).

n=1

Taking the negative logarithm, we obtain the error function

N

β 2

N 2

{y(xn,w) − tn}2 −

n=1

lnβ +

N 2

ln(2π) (5.13)

which can be used to learn the parameters w and β. In Section 5.7, we shall discuss the Bayesian treatment of neural networks, while here we consider a maximum likelihood approach. Note that in the neural networks literature, it is usual to consider the minimization of an error function rather than the maximization of the (log) likelihood, and so here we shall follow this convention. Consider ﬁrst the determination of w. Maximizing the likelihood function is equivalent to minimizing the sum-of-squares error function given by

- 1

- 2


E(w) =

N

{y(xn,w) − tn}2 (5.14)

n=1
