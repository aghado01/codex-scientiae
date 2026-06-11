[Page 30]

1

t

0

ln λ = −18

1

t

0

ln λ = 0

−1

−1

0 1

x

0 1

x

Figure 1.7 Plots of M = 9 polynomials ﬁtted to the data set shown in Figure 1.2 using the regularized error function (1.4) for two values of the regularization parameter λ corresponding to ln λ = −18 and ln λ = 0. The case of no regularizer, i.e., λ = 0, corresponding to ln λ = −∞, is shown at the bottom right of Figure 1.4.

may wish to use relatively complex and ﬂexible models. One technique that is often used to control the over-ﬁtting phenomenon in such cases is that of regularization, which involves adding a penalty term to the error function (1.2) in order to discourage the coefﬁcients from reaching large values. The simplest such penalty term takes the form of a sum of squares of all of the coefﬁcients, leading to a modiﬁed error function of the form

�N

1 2

λ 2�w�2 (1.4)

E�(w) =

{y(xn,w) − tn}2 +

n=1

where �w�2 ≡ wTw = w02 + w12 + ... + wM2 , and the coefﬁcient λ governs the relative importance of the regularization term compared with the sum-of-squares error

term. Note that often the coefﬁcient w0 is omitted from the regularizer because its inclusion causes the results to depend on the choice of origin for the target variable (Hastie et al., 2001), or it may be included but with its own regularization coefﬁcient (we shall discuss this topic in more detail in Section 5.5.1). Again, the error function

Exercise 1.2 in (1.4) can be minimized exactly in closed form. Techniques such as this are known in the statistics literature as shrinkage methods because they reduce the value of the coefﬁcients. The particular case of a quadratic regularizer is called ridge regression (Hoerl and Kennard, 1970). In the context of neural networks, this approach is known as weight decay.

Figure 1.7 shows the results of ﬁtting the polynomial of order M = 9 to the same data set as before but now using the regularized error function given by (1.4). We see that, for a value of lnλ = −18, the over-ﬁtting has been suppressed and we now obtain a much closer representation of the underlying function sin(2πx). If, however, we use too large a value for λ then we again obtain a poor ﬁt, as shown in Figure 1.7 for lnλ = 0. The corresponding coefﬁcients from the ﬁtted polynomials are given in Table 1.2, showing that regularization has the desired effect of reducing
