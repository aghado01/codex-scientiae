[Page 445]

Exercise 9.1

Appendix A

assigned vector µ k . Our goal is to ﬁnd values for the { r nk } and the { µ k } so as to minimize J . We can do this through an iterative procedure in which each iteration involves two successive steps corresponding to successive optimizations with respect to the r nk and the µ k . First we choose some initial values for the µ k . Then in the ﬁrst phase we minimize J with respect to the r nk , keeping the µ k ﬁxed. In the second phase we minimize J with respect to the µ k , keeping r nk ﬁxed. This two-stage optimization is then repeated until convergence. We shall see that these two stages of updating r nk and updating µ k correspond respectively to the E (expectation) and M (maximization) steps of the EM algorithm, and to emphasize this we shall use the terms E step and M step in the context of the K -means algorithm.

Consider ﬁrst the determination of the r nk . Because J in (9.1) is a linear function of r nk , this optimization can be performed easily to give a closed form solution. The terms involving different n are independent and so we can optimize for each n separately by choosing r nk to be 1 for whichever value of k gives the minimum value of x n − µ k 2 . In other words, we simply assign the n th data point to the closest cluster centre. More formally, this can be expressed as

$$
r _ { n k } = \begin{cases} 1 & \text {if } k = \arg \min _ { j } \| x _ { n } - \mu _ { j } \| ^ { 2 } \\ 0 & \text {otherwise.} \end{cases}
$$

Now consider the optimization of the µ k with the r nk held ﬁxed. The objective function J is a quadratic function of µ k , and it can be minimized by setting its derivative with respect to µ k to zero giving

$$
2 \sum _ { n = 1 } ^ { N } r _ { n k } ( x _ { n } - \mu _ { k } ) = 0 \\ \text {solve for } u _ { n } \text { to give}
$$

which we can easily solve for µ k to give

$$
\text {give for } \mu _ { k } \text { to give} \\ \mu _ { k } = \frac { \sum _ { n } r _ { n k } x _ { n } } { \sum _ { n } r _ { n k } } . \\ \text {is expression is equal to the number of points assigned to} \\ \text {result has a simple interpretation, namely set } \mu _ { k } \text { equal to the}
$$

The denominator in this expression is equal to the number of points assigned to cluster k , and so this result has a simple interpretation, namely set µ k equal to the mean of all of the data points x n assigned to cluster k . For this reason, the procedure is known as the K -means algorithm.

The two phases of re-assigning data points to clusters and re-computing the cluster means are repeated in turn until there is no further change in the assignments (or until some maximum number of iterations is exceeded). Because each phase reduces the value of the objective function J , convergence of the algorithm is assured. However, it may converge to a local rather than global minimum of J . The convergence properties of the K -means algorithm were studied by MacQueen (1967).

The K -means algorithm is illustrated using the Old Faithful data set in Figure 9.1. For the purposes of this example, we have made a linear re-scaling of the data, known as standardizing , such that each of the variables has zero mean and unit standard deviation. For this example, we have chosen K = 2 , and so in this
