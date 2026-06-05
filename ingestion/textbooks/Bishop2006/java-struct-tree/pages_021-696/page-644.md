[Page 644]

This completes the E step, and we use the results to ﬁnd a revised set of parameters θnew using the M-step equations from Section 13.2.1. We then continue to alternate between E and M steps until some convergence criterion is satisﬁed, for instance when the change in the likelihood function is below some threshold.

Note that in these recursion relations the observations enter through conditional distributions of the form p(xn|zn). The recursions are therefore independent of the type or dimensionality of the observed variables or the form of this conditional distribution, so long as its value can be computed for each of the K possible states of zn. Since the observed variables {xn} are ﬁxed, the quantities p(xn|zn) can be pre-computed as functions of zn at the start of the EM algorithm, and remain ﬁxed throughout.

We have seen in earlier chapters that the maximum likelihood approach is most effective when the number of data points is large in relation to the number of parameters. Here we note that a hidden Markov model can be trained effectively, using maximum likelihood, provided the training sequence is sufﬁciently long. Alternatively, we can make use of multiple shorter sequences, which requires a straightforward

Exercise 13.12 modiﬁcation of the hidden Markov model EM algorithm. In the case of left-to-right models, this is particularly important because, in a given observation sequence, a given state transition corresponding to a nondiagonal element of A will seen at most once.

Another quantity of interest is the predictive distribution, in which the observed data is X = {x1,...,xN} and we wish to predict xN+1, which would be important for real-time applications such as ﬁnancial forecasting. Again we make use of the sum and product rules together with the conditional independence properties (13.29) and (13.31) giving

�

p(xN+1|X) =

p(xN+1,zN+1|X)

zN+1

�

p(xN+1|zN+1)p(zN+1|X)

=

zN+1

�

�

=

p(xN+1|zN+1)

p(zN+1,zN|X)

zN+1

zN

�

�

=

p(xN+1|zN+1)

p(zN+1|zN)p(zN|X)

zN+1

zN

�

�

p(zN,X) p(X)

=

p(xN+1|zN+1)

p(zN+1|zN)

zN+1

zN

p(X) �

�

1

=

p(xN+1|zN+1)

p(zN+1|zN)α(zN) (13.44)

zN+1

zN

which can be evaluated by ﬁrst running a forward α recursion and then computing the ﬁnal summations over zN and zN+1. The result of the ﬁrst summation over zN can be stored and used once the value of xN+1 is observed in order to run the α recursion forward to the next step in order to predict the subsequent value xN+2.
