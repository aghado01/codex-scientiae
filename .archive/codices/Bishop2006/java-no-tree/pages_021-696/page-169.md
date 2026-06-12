[Page 169]

inside the braces, and then expand, we obtain

{y(x;D) − ED[y(x;D)] + ED[y(x;D)] − h(x)}2

= {y(x;D) − ED[y(x;D)]}2 + {ED[y(x;D)] − h(x)}2

+2{y(x;D) − ED[y(x;D)]}{ED[y(x;D)] − h(x)}. (3.39)

We now take the expectation of this expression with respect to D and note that the ﬁnal term will vanish, giving

ED {y(x;D) − h(x)}2

= {ED[y(x;D)] − h(x)}2 (bias)2

+ED {y(x;D) − ED[y(x;D)]}2

variance

. (3.40)

We see that the expected squared difference between y(x;D) and the regression function h(x) can be expressed as the sum of two terms. The ﬁrst term, called the squared bias, represents the extent to which the average prediction over all data sets differs from the desired regression function. The second term, called the variance, measures the extent to which the solutions for individual data sets vary around their average, and hence this measures the extent to which the function y(x;D) is sensitive to the particular choice of data set. We shall provide some intuition to support these deﬁnitions shortly when we consider a simple example.

So far, we have considered a single input value x. If we substitute this expansion back into (3.37), we obtain the following decomposition of the expected squared loss

expected loss = (bias)2 + variance + noise (3.41) where

(bias)2 = {ED[y(x;D)] − h(x)}2p(x)dx (3.42)

variance = ED {y(x;D) − ED[y(x;D)]}2 p(x)dx (3.43)

noise = {h(x) − t}2p(x,t)dxdt (3.44)

and the bias and variance terms now refer to integrated quantities.

Our goal is to minimize the expected loss, which we have decomposed into the sum of a (squared) bias, a variance, and a constant noise term. As we shall see, there is a trade-off between bias and variance, with very ﬂexible models having low bias and high variance, and relatively rigid models having high bias and low variance. The model with the optimal predictive capability is the one that leads to the best balance between bias and variance. This is illustrated by considering the sinusoidal

Appendix A data set from Chapter 1. Here we generate 100 data sets, each containing N = 25 data points, independently from the sinusoidal curve h(x) = sin(2πx). The data sets are indexed by l = 1,...,L, where L = 100, and for each data set D(l) we
