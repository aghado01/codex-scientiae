[Page 30]

![The image presents two graphs, each with a different set of data points. The x-axis is labeled lina and the y-axis is labeled 18. The graph on the left shows a downward trend, while the graph on the right shows a upward trend. Both graphs have a horizontal line labeled ln(a) = 0 at the end of the graph. The first graph has a horizontal line labeled ln(a) = 0 at the end of the graph. The graph on the left shows a downward trend, while the graph on the right shows a upward trend. Both graphs have a vertical line labeled ln(a) = 0 at the end of the graph. The second graph has a horizontal line labeled ln(a) = 0 at the end of the graph. The graph on the left shows a downward trend, while the graph on the right shows a upward trend. Both graphs have](../images/imageFile10.png)

-

ln λ

λ

=

18

ln λ

λ

= 0

1

1

t

t

0

0

−1

−1

0

1

0

1

x

x

Figure 1.7 Plots of M = 9 polynomials ﬁtted to the data set shown in Figure 1.2 using the regularized error function (1.4) for two values of the regularization parameter λ corresponding to ln λ = − 18 and ln λ = 0 . The case of no regularizer, i.e., λ = 0 , corresponding to ln λ = −∞ , is shown at the bottom right of Figure 1.4.

Exercise 1.2

may wish to use relatively complex and ﬂexible models. One technique that is often used to control the over-ﬁtting phenomenon in such cases is that of regularization , which involves adding a penalty term to the error function (1.2) in order to discourage the coefﬁcients from reaching large values. The simplest such penalty term takes the form of a sum of squares of all of the coefﬁcients, leading to a modiﬁed error function of the form N

$$
\widetilde { E } ( w ) & = \frac { 1 } { 2 } \sum _ { n = 1 } ^ { N } \{ y ( x _ { n } , w ) - t _ { n } \} ^ { 2 } + \frac { \lambda } { 2 } \| w \| ^ { 2 } \\ w \| ^ { 2 } & \equiv w ^ { T } w = w _ { 0 } ^ { 2 } + w _ { 1 } ^ { 2 } + \dots + w _ { M } ^ { 2 } , \, \text {and} \, \text {the coefficient} \, \lambda \text { governs the rel-} \\ \intertext { t h e r g r a t i o n s }
$$

where w 2 ≡ w T w = w 2 0 + w 2 1 + ... + w 2 M , and the coefﬁcient λ governs the relative importance of the regularization term compared with the sum-of-squares error term. Note that often the coefﬁcient w 0 is omitted from the regularizer because its inclusion causes the results to depend on the choice of origin for the target variable (Hastie et al. , 2001), or it may be included but with its own regularization coefﬁcient (we shall discuss this topic in more detail in Section 5.5.1). Again, the error function in (1.4) can be minimized exactly in closed form. Techniques such as this are known in the statistics literature as shrinkage methods because they reduce the value of the coefﬁcients. The particular case of a quadratic regularizer is called ridge regression (Hoerl and Kennard, 1970). In the context of neural networks, this approach is known as weight decay .

Figure 1.7 shows the results of ﬁtting the polynomial of order M = 9 to the same data set as before but now using the regularized error function given by (1.4). We see that, for a value of ln λ = − 18 , the over-ﬁtting has been suppressed and we now obtain a much closer representation of the underlying function sin(2 πx ) . If, however, we use too large a value for λ then we again obtain a poor ﬁt, as shown in Figure 1.7 for ln λ = 0 . The corresponding coefﬁcients from the ﬁtted polynomials are given in Table 1.2, showing that regularization has the desired effect of reducing
