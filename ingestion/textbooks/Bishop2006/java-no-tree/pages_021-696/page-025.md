[Page 25]

sin(2πx) and then adding a small level of random noise having a Gaussian distribution (the Gaussian distribution is discussed in Section 1.2.4) to each such point in order to obtain the corresponding value tn. By generating data in this way, we are capturing a property of many real data sets, namely that they possess an underlying regularity, which we wish to learn, but that individual observations are corrupted by random noise. This noise might arise from intrinsically stochastic (i.e. random) processes such as radioactive decay but more typically is due to there being sources of variability that are themselves unobserved.

Our goal is to exploit this training set in order to make predictions of the value t of the target variable for some new value x of the input variable. As we shall see later, this involves implicitly trying to discover the underlying function sin(2πx). This is intrinsically a difﬁcult problem as we have to generalize from a ﬁnite data set. Furthermore the observed data are corrupted with noise, and so for a given x there is uncertainty as to the appropriate value for t. Probability theory, discussed in Section 1.2, provides a framework for expressing such uncertainty in a precise and quantitative manner, and decision theory, discussed in Section 1.5, allows us to exploit this probabilistic representation in order to make predictions that are optimal according to appropriate criteria.

For the moment, however, we shall proceed rather informally and consider a simple approach based on curve ﬁtting. In particular, we shall ﬁt the data using a polynomial function of the form

y(x,w) = w0 + w1x + w2x2 + ... + wMxM =

M

wjxj (1.1)

j=0

where M is the order of the polynomial, and xj denotes x raised to the power of j. The polynomial coefﬁcients w0,...,wM are collectively denoted by the vector w. Note that, although the polynomial function y(x,w) is a nonlinear function of x, it is a linear function of the coefﬁcients w. Functions, such as the polynomial, which are linear in the unknown parameters have important properties and are called linear models and will be discussed extensively in Chapters 3 and 4.

The values of the coefﬁcients will be determined by ﬁtting the polynomial to the training data. This can be done by minimizing an error function that measures the misﬁt between the function y(x,w), for any given value of w, and the training set data points. One simple choice of error function, which is widely used, is given by the sum of the squares of the errors between the predictions y(xn,w) for each data point xn and the corresponding target values tn, so that we minimize

- 1

- 2


E(w) =

N

{y(xn,w) − tn}2 (1.2)

n=1

where the factor of 1/2 is included for later convenience. We shall discuss the motivation for this choice of error function later in this chapter. For the moment we simply note that it is a nonnegative quantity that would be zero if, and only if, the
