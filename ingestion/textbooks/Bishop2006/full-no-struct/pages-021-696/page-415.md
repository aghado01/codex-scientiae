[Page 415]

The joint distribution for this graph takes the form

$$
p ( x ) = \frac { 1 } { Z } \psi _ { 1 , 2 } ( x _ { 1 } , x _ { 2 } ) \psi _ { 2 , 3 } ( x _ { 2 } , x _ { 3 } ) \cdots \psi _ { N - 1 , N } ( x _ { N - 1 } , x _ { N } ) .
$$

We shall consider the speciﬁc case in which the N nodes represent discrete variables each having K states, in which case each potential function ψ n − 1 ,n ( x n − 1 ,x n ) comprises an K × K table, and so the joint distribution has ( N − 1) K 2 parameters. Let us consider the inference problem of ﬁnding the marginal distribution p ( x n )

for a speciﬁc node x n that is part way along the chain. Note that, for the moment, there are no observed nodes. By deﬁnition, the required marginal is obtained by summing the joint distribution over all variables except x n , so that

$$
p ( x _ { n } ) = \sum _ { x _ { 1 } } \cdots \sum _ { x _ { n - 1 } } \sum _ { x _ { n + 1 } } \cdots \sum _ { x _ { N } } p ( x ) .
$$

In a naive implementation, we would ﬁrst evaluate the joint distribution and then perform the summations explicitly. The joint distribution can be represented as a set of numbers, one for each possible value for x . Because there are N variables each with K states, there are K N values for x and so evaluation and storage of the joint distribution, as well as marginalization to obtain p ( x n ) , all involve storage and computation that scale exponentially with the length N of the chain.

We can, however, obtain a much more efﬁcient algorithm by exploiting the conditional independence properties of the graphical model. If we substitute the factorized expression (8.49) for the joint distribution into (8.50), then we can rearrange the order of the summations and the multiplications to allow the required marginal to be evaluated much more efﬁciently. Consider for instance the summation over x N . The potential ψ N − 1 ,N ( x N − 1 ,x N ) is the only one that depends on x N , and so we can perform the summation

$$
\sum _ { x _ { N } } \psi _ { N - 1 , N } ( x _ { N - 1 } , x _ { N } ) \\ \text {of } x _ { N - 1 } , \text { we can then use this to perform the summation}
$$

ﬁrst to give a function of x N − 1 . We can then use this to perform the summation over x N − 1 , which will involve only this new function together with the potential ψ N − 2 ,N − 1 ( x N − 2 ,x N − 1 ) , because this is the only other place that x N − 1 appears. Similarly, the summation over x 1 involves only the potential ψ 1 , 2 ( x 1 ,x 2 ) and so can be performed separately to give a function of x 2 , and so on. Because each summation effectively removes a variable from the distribution, this can be viewed as the removal of a node from the graph.

If we group the potentials and summations together in this way, we can express
