[Page 29]

1

t

0

N = 15

1

t

0

N = 100

−1

−1

0 1

x

0 1

x

Figure 1.6 Plots of the solutions obtained by minimizing the sum-of-squares error function using the M = 9 polynomial for N = 15 data points (left plot) and N = 100 data points (right plot). We see that increasing the size of the data set reduces the over-ﬁtting problem.

ing polynomial function matches each of the data points exactly, but between data points (particularly near the ends of the range) the function exhibits the large oscillations observed in Figure 1.4. Intuitively, what is happening is that the more ﬂexible polynomials with larger values of M are becoming increasingly tuned to the random noise on the target values.

It is also interesting to examine the behaviour of a given model as the size of the data set is varied, as shown in Figure 1.6. We see that, for a given model complexity, the over-ﬁtting problem become less severe as the size of the data set increases. Another way to say this is that the larger the data set, the more complex (in other words more ﬂexible) the model that we can afford to ﬁt to the data. One rough heuristic that is sometimes advocated is that the number of data points should be no less than some multiple (say 5 or 10) of the number of adaptive parameters in the model. However, as we shall see in Chapter 3, the number of parameters is not necessarily the most appropriate measure of model complexity.

Also, there is something rather unsatisfying about having to limit the number of parameters in a model according to the size of the available training set. It would seem more reasonable to choose the complexity of the model according to the complexity of the problem being solved. We shall see that the least squares approach to ﬁnding the model parameters represents a speciﬁc case of maximum likelihood (discussed in Section 1.2.5), and that the over-ﬁtting problem can be understood as

Section 3.4 a general property of maximum likelihood. By adopting a Bayesian approach, the over-ﬁtting problem can be avoided. We shall see that there is no difﬁculty from a Bayesian perspective in employing models for which the number of parameters greatly exceeds the number of data points. Indeed, in a Bayesian model the effective number of parameters adapts automatically to the size of the data set.

For the moment, however, it is instructive to continue with the current approach and to consider how in practice we can apply it to data sets of limited size where we
