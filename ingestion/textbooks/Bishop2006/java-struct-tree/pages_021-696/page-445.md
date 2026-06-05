[Page 445]

assigned vector µk. Our goal is to ﬁnd values for the {rnk} and the {µk} so as to minimize J. We can do this through an iterative procedure in which each iteration involves two successive steps corresponding to successive optimizations with respect to the rnk and the µk. First we choose some initial values for the µk. Then in the ﬁrst phase we minimize J with respect to the rnk, keeping the µk ﬁxed. In the second phase we minimize J with respect to the µk, keeping rnk ﬁxed. This two-stage optimization is then repeated until convergence. We shall see that these two stages of updating rnk and updating µk correspond respectively to the E (expectation) and

Section 9.4 M (maximization) steps of the EM algorithm, and to emphasize this we shall use the

terms E step and M step in the context of the K-means algorithm.

Consider ﬁrst the determination of the rnk. Because J in (9.1) is a linear function of rnk, this optimization can be performed easily to give a closed form solution. The terms involving different n are independent and so we can optimize for each

n separately by choosing rnk to be 1 for whichever value of k gives the minimum value of �xn − µk�2. In other words, we simply assign the nth data point to the closest cluster centre. More formally, this can be expressed as

rnk = �

1 if k = arg minj �xn − µj�2 0 otherwise.

(9.2)

Now consider the optimization of the µk with the rnk held ﬁxed. The objective function J is a quadratic function of µk, and it can be minimized by setting its derivative with respect to µk to zero giving

�N

rnk(xn − µk) = 0 (9.3)

2

n=1

which we can easily solve for µk to give

µk = �

n rnkxn

. (9.4)

�

n rnk

The denominator in this expression is equal to the number of points assigned to cluster k, and so this result has a simple interpretation, namely set µk equal to the mean of all of the data points xn assigned to cluster k. For this reason, the procedure is known as the K-means algorithm.

The two phases of re-assigning data points to clusters and re-computing the cluster means are repeated in turn until there is no further change in the assignments (or until some maximum number of iterations is exceeded). Because each phase reduces

Exercise 9.1 the value of the objective function J, convergence of the algorithm is assured. However, it may converge to a local rather than global minimum of J. The convergence properties of the K-means algorithm were studied by MacQueen (1967).

Appendix A The K-means algorithm is illustrated using the Old Faithful data set in Figure 9.1. For the purposes of this example, we have made a linear re-scaling of the data, known as standardizing, such that each of the variables has zero mean and unit standard deviation. For this example, we have chosen K = 2, and so in this
