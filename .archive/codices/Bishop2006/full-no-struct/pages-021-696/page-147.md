[Page 147]

An interesting property of the nearest-neighbour ( K = 1 ) classiﬁer is that, in the limit N → ∞ , the error rate is never more than twice the minimum achievable error rate of an optimal classiﬁer, i.e., one that uses the true class distributions (Cover and Hart, 1967) .

As discussed so far, both the K -nearest-neighbour method, and the kernel density estimator, require the entire training data set to be stored, leading to expensive computation if the data set is large. This effect can be offset, at the expense of some additional one-off computation, by constructing tree-based search structures to allow (approximate) near neighbours to be found efﬁciently without doing an exhaustive search of the data set. Nevertheless, these nonparametric methods are still severely limited. On the other hand, we have seen that simple parametric models are very restricted in terms of the forms of distribution that they can represent. We therefore need to ﬁnd density models that are very ﬂexible and yet for which the complexity of the models can be controlled independently of the size of the training set, and we shall see in subsequent chapters how to achieve this.

# Exercises

2.1 ( ) www Verify that the Bernoulli distribution (2.2) satisﬁes the following properties

$$
\sum _ { x = 0 } ^ { 1 } p ( x | \mu ) \ = \ 1 & & ( 2 . 2 5 7 ) \\ \mathbb { E } [ x ] \ = \ \mu & & ( 2 . 2 5 8 )
$$

$$
\mathbb { E } [ x ] \ = \ \mu
$$

$$
\var { v } [ x ] \ = \ \mu ( 1 - \mu ) . \\
$$

Show that the entropy H[ x ] of a Bernoulli distributed random binary variable x is given by

$$
H [ x ] = - \mu \ln \mu - ( 1 - \mu ) \ln ( 1 - \mu ) .
$$

2.2 ( ) The form of the Bernoulli distribution given by (2.2) is not symmetric between the two values of x . In some situations, it will be more convenient to use an equivalent formulation for which x ∈ {− 1 , 1 } , in which case the distribution can be written (1 x ) / 2 (1+ x ) / 2

$$
p ( x | \mu ) & = \left ( \frac { 1 - \mu } { 2 } \right ) ^ { ( 1 - x ) / 2 } \left ( \frac { 1 + \mu } { 2 } \right ) ^ { ( 1 + x ) / 2 } \\ \in [ - 1 , 1 ] \, \text {Show that the distribution } ( 2 . 2 6 1 ) \, \text {is normalized, and evaluate its}
$$

where µ ∈ [ − 1 , 1] . Show that the distribution (2.261) is normalized, and evaluate its mean, variance, and entropy.

2.3 ( ) www In this exercise, we prove that the binomial distribution (2.9) is normalized. First use the deﬁnition (2.10) of the number of combinations of m identical objects chosen from a total of N to show that

$$
\text {from a total of $N$ to show that} \\ \begin{pmatrix} N \\ m \end{pmatrix} + \begin{pmatrix} N \\ m - 1 \end{pmatrix} = \begin{pmatrix} N + 1 \\ m \end{pmatrix} .
$$
