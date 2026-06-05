[Page 431]

Table 8.1 Example of a joint distribution over two binary variables for which the maximum of the joint distribution occurs for different variable values compared to the maxima of the two marginals.

| |x = 0 x = 1|
|---|---|
|y = 0<br><br>y = 1<br><br><br>|0.3 0.4 0.3 0.0|


continuous variables the summations are simply replaced by integrations. We shall give an example of the sum-product algorithm applied to a graph of linear-Gaussian

Section 13.3 variables when we consider linear dynamical systems.

###### 8.4.5 The max-sum algorithm

The sum-product algorithm allows us to take a joint distribution p(x) expressed as a factor graph and efﬁciently ﬁnd marginals over the component variables. Two other common tasks are to ﬁnd a setting of the variables that has the largest probability and to ﬁnd the value of that probability. These can be addressed through a closely related algorithm called max-sum, which can be viewed as an application of dynamic programming in the context of graphical models (Cormen et al., 2001).

A simple approach to ﬁnding latent variable values having high probability would be to run the sum-product algorithm to obtain the marginals p(xi) for every variable, and then, for each marginal in turn, to ﬁnd the value x i that maximizes that marginal. However, this would give the set of values that are individually the most probable. In practice, we typically wish to ﬁnd the set of values that jointly have the largest probability, in other words the vector xmax that maximizes the joint distribution, so that

p(x) (8.87) for which the corresponding value of the joint probability will be given by

xmax = arg max

x

p(xmax) = max

p(x). (8.88)

x

In general, xmax is not the same as the set of x i values, as we can easily show using a simple example. Consider the joint distribution p(x,y) over two binary variables

x,y ∈ {0,1} given in Table 8.1. The joint distribution is maximized by setting x = 1 and y = 0, corresponding the value 0.4. However, the marginal for p(x), obtained by summing over both values of y, is given by p(x = 0) = 0.6 and p(x = 1) = 0.4, and similarly the marginal for y is given by p(y = 0) = 0.7 and p(y = 1) = 0.3, and so the marginals are maximized by x = 0 and y = 0, which corresponds to a value of 0.3 for the joint distribution. In fact, it is not difﬁcult to construct examples for which the set of individually most probable values has probability zero under the

Exercise 8.27 joint distribution.

We therefore seek an efﬁcient algorithm for ﬁnding the value of x that maximizes the joint distribution p(x) and that will allow us to obtain the value of the joint distribution at its maximum. To address the second of these problems, we shall simply write out the max operator in terms of its components

p(x) = max

...max

p(x) (8.89)

max

x1

xM

x
