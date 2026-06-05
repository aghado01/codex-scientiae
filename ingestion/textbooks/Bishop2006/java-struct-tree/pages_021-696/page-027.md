[Page 27]

1

t

0

M = 0

1

t

0

M = 1

−1

0 1

x

−1

0 1

x

1

t

0

M = 3

1

t

0

M = 9

−1

−1

0 1

x

0 1

x

Figure 1.4 Plots of polynomials having various orders M, shown as red curves, ﬁtted to the data set shown in Figure 1.2.

(RMS) error deﬁned by

�

ERMS =

2E(w�)/N (1.3)

in which the division by N allows us to compare different sizes of data sets on an equal footing, and the square root ensures that ERMS is measured on the same scale (and in the same units) as the target variable t. Graphs of the training and test set RMS errors are shown, for various values of M, in Figure 1.5. The test set error is a measure of how well we are doing in predicting the values of t for new data observations of x. We note from Figure 1.5 that small values of M give relatively large values of the test set error, and this can be attributed to the fact that the corresponding polynomials are rather inﬂexible and are incapable of capturing the oscillations in the function sin(2πx). Values of M in the range 3 � M � 8 give small values for the test set error, and these also give reasonable representations of the generating function sin(2πx), as can be seen, for the case of M = 3, from Figure 1.4.
