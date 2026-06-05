[Page 544]

Figure 11.1 Schematic illustration of a function f(z) whose expectation is to be evaluated with respect to a distribution p(z).

p(z) f(z)

z

variables, we wish to evaluate the expectation

E[f] = � f(z)p(z)dz (11.1)

where the integral is replaced by summation in the case of discrete variables. This is illustrated schematically for a single continuous variable in Figure 11.1. We shall suppose that such expectations are too complex to be evaluated exactly using analytical techniques.

The general idea behind sampling methods is to obtain a set of samples z(l) (where l = 1,...,L) drawn independently from the distribution p(z). This allows the expectation (11.1) to be approximated by a ﬁnite sum

�L

1 L

f� =

f(z(l)). (11.2)

l=1

As long as the samples z(l) are drawn from the distribution p(z), then E[f�] = E[f] and so the estimator f� has the correct mean. The variance of the estimator is given

Exercise 11.1 by

1 L

�

�

var[f�] =

(f − E[f])2

(11.3)

E

is the variance of the function f(z) under the distribution p(z). It is worth emphasizing that the accuracy of the estimator therefore does not depend on the dimensionality of z, and that, in principle, high accuracy may be achievable with a relatively small number of samples z(l). In practice, ten or twenty independent samples may sufﬁce to estimate an expectation to sufﬁcient accuracy.

The problem, however, is that the samples {z(l)} might not be independent, and so the effective sample size might be much smaller than the apparent sample size. Also, referring back to Figure 11.1, we note that if f(z) is small in regions where p(z) is large, and vice versa, then the expectation may be dominated by regions of small probability, implying that relatively large sample sizes will be required to achieve sufﬁcient accuracy.

For many models, the joint distribution p(z) is conveniently speciﬁed in terms of a graphical model. In the case of a directed graph with no observed variables, it is
