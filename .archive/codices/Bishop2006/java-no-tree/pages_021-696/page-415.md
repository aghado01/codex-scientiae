[Page 415]

The joint distribution for this graph takes the form

1 Z

p(x) =

ψ1,2(x1,x2)ψ2,3(x2,x3)···ψN−1,N(xN−1,xN). (8.49)

We shall consider the speciﬁc case in which the N nodes represent discrete variables each having K states, in which case each potential function ψn−1,n(xn−1,xn) comprises an K × K table, and so the joint distribution has (N − 1)K2 parameters.

Let us consider the inference problem of ﬁnding the marginal distribution p(xn) for a speciﬁc node xn that is part way along the chain. Note that, for the moment, there are no observed nodes. By deﬁnition, the required marginal is obtained by summing the joint distribution over all variables except xn, so that

p(xn) =

x1

···

###### ···

xn−1 xn+1

p(x). (8.50)

xN

In a naive implementation, we would ﬁrst evaluate the joint distribution and then perform the summations explicitly. The joint distribution can be represented as a set of numbers, one for each possible value for x. Because there are N variables each with K states, there are KN values for x and so evaluation and storage of the joint distribution, as well as marginalization to obtain p(xn), all involve storage and computation that scale exponentially with the length N of the chain.

We can, however, obtain a much more efﬁcient algorithm by exploiting the conditional independence properties of the graphical model. If we substitute the factorized expression (8.49) for the joint distribution into (8.50), then we can rearrange the order of the summations and the multiplications to allow the required marginal to be evaluated much more efﬁciently. Consider for instance the summation over xN. The potential ψN−1,N(xN−1,xN) is the only one that depends on xN, and so we can perform the summation

###### ψN−1,N(xN−1,xN) (8.51)

xN

ﬁrst to give a function of xN−1. We can then use this to perform the summation over xN−1, which will involve only this new function together with the potential ψN−2,N−1(xN−2,xN−1), because this is the only other place that xN−1 appears. Similarly, the summation over x1 involves only the potential ψ1,2(x1,x2) and so can be performed separately to give a function of x2, and so on. Because each summation effectively removes a variable from the distribution, this can be viewed as the removal of a node from the graph.

If we group the potentials and summations together in this way, we can express
