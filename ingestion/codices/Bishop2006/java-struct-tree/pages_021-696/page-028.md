[Page 28]

Figure 1.5 Graphs of the root-mean-square error, deﬁned by (1.3), evaluated on the training set and on an independent test set for various values of M.

1

ERMS

0.5

Training Test

0

0 3 6 9

M

For M = 9, the training set error goes to zero, as we might expect because this polynomial contains 10 degrees of freedom corresponding to the 10 coefﬁcients w0,...,w9, and so can be tuned exactly to the 10 data points in the training set. However, the test set error has become very large and, as we saw in Figure 1.4, the corresponding function y(x,w�) exhibits wild oscillations.

This may seem paradoxical because a polynomial of given order contains all lower order polynomials as special cases. The M = 9 polynomial is therefore capable of generating results at least as good as the M = 3 polynomial. Furthermore, we might suppose that the best predictor of new data would be the function sin(2πx) from which the data was generated (and we shall see later that this is indeed the case). We know that a power series expansion of the function sin(2πx) contains terms of all orders, so we might expect that results should improve monotonically as we increase M.

We can gain some insight into the problem by examining the values of the coefﬁcients w� obtained from polynomials of various order, as shown in Table 1.1. We see that, as M increases, the magnitude of the coefﬁcients typically gets larger. In particular for the M = 9 polynomial, the coefﬁcients have become ﬁnely tuned to the data by developing large positive and negative values so that the correspond-

Table 1.1 Table of the coefﬁcients w� for polynomials of various order. Observe how the typical magnitude of the coefﬁcients increases dramatically as the order of the polynomial increases.

M = 0 M = 1 M = 6 M = 9 w0� 0.19 0.82 0.31 0.35 w1� -1.27 7.99 232.37 w2� -25.43 -5321.83 w3� 17.37 48568.31 w4� -231639.30 w5� 640042.26 w6� -1061800.52 w7� 1042400.18 w8� -557682.99 w9� 125201.43
