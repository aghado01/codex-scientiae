[Page 188]

Figure 3.14 Plot of the model evidence versus the order M, for the polynomial regression model, showing that the evidence favours the model with M = 3.

−18

−20

−22

−24

−26

0 2 4 6 8

M

for the evidence. Going to the M = 1 polynomial greatly improves the data ﬁt, and hence the evidence is signiﬁcantly higher. However, in going to M = 2, the data ﬁt is improved only very marginally, due to the fact that the underlying sinusoidal function from which the data is generated is an odd function and so has no even terms in a polynomial expansion. Indeed, Figure 1.5 shows that the residual data error is reduced only slightly in going from M = 1 to M = 2. Because this richer model suffers a greater complexity penalty, the evidence actually falls in going from M = 1 to M = 2. When we go to M = 3 we obtain a signiﬁcant further improvement in data ﬁt, as seen in Figure 1.4, and so the evidence is increased again, giving the highest overall evidence for any of the polynomials. Further increases in the value of M produce only small improvements in the ﬁt to the data but suffer increasing complexity penalty, leading overall to a decrease in the evidence values. Looking again at Figure 1.5, we see that the generalization error is roughly constant between M = 3 and M = 8, and it would be difﬁcult to choose between these models on the basis of this plot alone. The evidence values, however, show a clear preference for M = 3, since this is the simplest model which gives a good explanation for the observed data.

3.5.2 Maximizing the evidence function

Let us ﬁrst consider the maximization of p(t|α,β) with respect to α. This can be done by ﬁrst deﬁning the following eigenvector equation

�

�

ui = λiui. (3.87)

βΦTΦ

From (3.81), it then follows that A has eigenvalues α+λi. Now consider the derivative of the term involving ln|A| in (3.86) with respect to α. We have

�

dα �

�

1 λi + α

d

d dα

d dα

(λi + α) =

ln(λi + α) =

ln|A| =

ln

. (3.88)

i

i

i

Thus the stationary points of (3.86) with respect to α satisfy

1 2 �

1 λi + α

1 2

M 2α −

0 =

mTNmN −

. (3.89)

i
