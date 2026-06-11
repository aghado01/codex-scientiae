[Page 254]

where we have discarded additive and multiplicative constants. The value of w found by minimizing E(w) will be denoted wML because it corresponds to the maximum likelihood solution. In practice, the nonlinearity of the network function y(xn,w) causes the error E(w) to be nonconvex, and so in practice local maxima of the likelihood may be found, corresponding to local minima of the error function, as discussed in Section 5.2.1.

Having found wML, the value of β can be found by minimizing the negative log likelihood to give

N

1 βML

1 N

=

{y(xn,wML) − tn}2. (5.15)

n=1

Note that this can be evaluated once the iterative optimization required to ﬁnd wML is completed. If we have multiple target variables, and we assume that they are independent conditional on x and w with shared noise precision β, then the conditional distribution of the target values is given by

###### p(t|x,w) = N t|y(x,w),β−1I . (5.16)

Following the same argument as for a single target variable, we see that the maximum likelihood weights are determined by minimizing the sum-of-squares error function

- Exercise 5.2 (5.11). The noise precision is then given by 1

βML

=

1 NK

N

n=1

y(xn,wML) − tn 2 (5.17)

where K is the number of target variables. The assumption of independence can be

- Exercise 5.3 dropped at the expense of a slightly more complex optimization problem. Recall from Section 4.3.6 that there is a natural pairing of the error function


(given by the negative log likelihood) and the output unit activation function. In the regression case, we can view the network as having an output activation function that is the identity, so that yk = ak. The corresponding sum-of-squares error function has the property

∂E ∂ak

= yk − tk (5.18) which we shall make use of when discussing error backpropagation in Section 5.3.

Now consider the case of binary classiﬁcation in which we have a single target

variable t such that t = 1 denotes class C1 and t = 0 denotes class C2. Following the discussion of canonical link functions in Section 4.3.6, we consider a network having a single output whose activation function is a logistic sigmoid

1 1 + exp(−a)

y = σ(a) ≡

(5.19)

so that 0 y(x,w) 1. We can interpret y(x,w) as the conditional probability p(C1|x), with p(C2|x) given by 1 − y(x,w). The conditional distribution of targets given inputs is then a Bernoulli distribution of the form

###### p(t|x,w) = y(x,w)t {1 − y(x,w)}1−t . (5.20)
